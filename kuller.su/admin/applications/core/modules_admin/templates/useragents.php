<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Gallery Application
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Core
 * @link		http://www.invisionpower.com
 * @since		Who knows...
 * @version		$Revision: 10721 $
 */

if ( ! defined( 'IN_ACP' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded 'admin.php'.";
	exit();
}

class admin_core_templates_useragents extends ipsCommand
{
	/**
	 * Skin Functions Class
	 *
	 * @var		object
	 */
	protected $skinFunctions;
	
	/**
	 * User agent functions
	 *
	 * @var		object			UA functions
	 */
	protected $userAgentFunctions;
	
	/**
	 * Skin object
	 *
	 * @var		object			Skin templates
	 */
	protected $html;
	
	/**#@+
	 * URL bits
	 *
	 * @var		string
	 */
	public $form_code		= '';
	public $form_code_js	= '';
	/**#@-*/	
	
	/**
	 * Main class entry point
	 *
	 * @param	object		ipsRegistry reference
	 * @return	@e void		[Outputs to screen]
	 */
	public function doExecute( ipsRegistry $registry ) 
	{
		//-----------------------------------------
		// Load skin
		//-----------------------------------------
		
		$this->html			= $this->registry->output->loadTemplate('cp_skin_templates');
	
		//-----------------------------------------
		// Set up stuff
		//-----------------------------------------
		
		$this->form_code	= $this->html->form_code	= 'module=templates&amp;section=useragents';
		$this->form_code_js	= $this->html->form_code_js	= 'module=templates&section=useragents';
		
		//-----------------------------------------
		// Load lang
		//-----------------------------------------
				
		$this->registry->getClass('class_localization')->loadLanguageFile( array( 'admin_templates' ) );
		
		//-----------------------------------------
		// Load functions and cache classes
		//-----------------------------------------
	
		require_once( IPS_ROOT_PATH . 'sources/classes/skins/skinFunctions.php' );/*noLibHook*/
		require_once( IPS_ROOT_PATH . 'sources/classes/skins/skinCaching.php' );/*noLibHook*/
		$this->skinFunctions = new skinCaching( $registry );
		
		$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/classes/useragents/userAgentFunctions.php', 'userAgentFunctions' );
		$this->userAgentFunctions = new $classToLoad( $registry );
		
		///----------------------------------------
		// What to do...
		//-----------------------------------------
		
		switch( $this->request['do'] )
		{
			case 'show':
			default:
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'useragent_skin_map' );
				$this->_showUserAgentMapping();
			break;
			case 'saveAgents':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'useragent_skin_map' );
				$this->_saveAgents();
			break;
		}
		
		/* Output */
		$this->registry->output->html_main .= $this->registry->output->global_template->global_frame_wrapper();
		$this->registry->output->sendOutput();
	}
	
	/**
	 * Show useragents for this skin set
	 *
	 * @return	string	HTML
	 */
	protected function _saveAgents()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$setID           = intval( $this->request['setID'] );
		$userAgentGroups = array();
		$userAgents		 = array();
		$saveAgents		 = array();
		$setData         = array();
		
		//-----------------------------------------
		// Get template set data
		//-----------------------------------------
	
		$setData = $this->skinFunctions->fetchSkinData( $setID );
		
		//-----------------------------------------
		// Get user agents
		//-----------------------------------------
	
		$userAgents = $this->userAgentFunctions->fetchAgents();
		
		//-----------------------------------------
		// Figure out agent groups
		//-----------------------------------------
		
		if ( is_array( $_POST['uGroups'] ) )
		{
			foreach( $_POST['uGroups'] as $group_id => $val )
			{
				if ( $val )
				{
					$userAgentGroups[] = intval( $group_id );
				}
			}
		}
		
		//-----------------------------------------
		// User agents..
		//-----------------------------------------
		
		if ( is_array( $_POST['uAgents'] ) )
		{
			foreach( $_POST['uAgents'] as $uAgentID => $val )
			{
				if ( $val )
				{
					$_version = ( isset( $_POST['uAgentVersion'][ $uAgentID ] ) ) ? $_POST['uAgentVersion'][ $uAgentID ] : '';
					
					$saveAgents[ $userAgents[ $uAgentID ]['uagent_key'] ] = $_version;
				}
			}
		}

		//-----------------------------------------
		// Save and serialize
		//-----------------------------------------
		
		$this->DB->update( 'skin_collections', array( 'set_locked_uagent' => serialize( array( 'groups'  => $userAgentGroups,
																								  'uagents' => $saveAgents ) ) ), 'set_id=' . $setID );
																								
		
		//-----------------------------------------
		// Recache skins
		//-----------------------------------------
		
		$this->skinFunctions->rebuildSkinSetsCache();
		
		//-----------------------------------------
		// Done, so dump us back
		//-----------------------------------------
		
		$this->registry->output->global_message = $this->lang->words['ua_saved'];
		
		//return $this->_showUserAgentMapping();
		$this->registry->output->silentRedirectWithMessage( $this->settings['base_url'] . $this->form_code . '&setID=' . $this->request['setID'] );
	}
	
	/**
	 * Show useragents for this skin set
	 *
	 * @return	@e void
	 */
	protected function _showUserAgentMapping()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$setID           = intval( $this->request['setID'] );
		$userAgentGroups = array();
		$userAgents		 = array();
		$setData         = array();
		
		//-----------------------------------------
		// Get template set data
		//-----------------------------------------
	
		$setData = $this->skinFunctions->fetchSkinData( $setID );
		
		//-----------------------------------------
		// Get user agents
		//-----------------------------------------
	
		$userAgents = $this->userAgentFunctions->fetchAgents();
		
		//-----------------------------------------
		// Get user agents
		//-----------------------------------------
	
		$userAgentGroups = $this->userAgentFunctions->fetchGroups();

		//-----------------------------------------
		// Navvy Gation
		//-----------------------------------------
		
		$this->registry->output->extra_nav[] = array( $this->settings['base_url'].'module=templates&amp;section=skinsets&amp;do=overview', $this->lang->words['ua_nav1'] );
		$this->registry->output->extra_nav[] = array( $this->settings['base_url'].'module=templates&amp;section=useragents&amp;do=show&amp;setID=' . $setID, $this->lang->words['ua_nav2'] . $setData['set_name'] );
		
		//-----------------------------------------
		// Print it...
		//-----------------------------------------
		
		$this->registry->output->html .= $this->html->useragents_showUserAgents( $userAgents, $userAgentGroups, $setData );
	}
}
