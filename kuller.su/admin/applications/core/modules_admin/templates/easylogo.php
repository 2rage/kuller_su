<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Easy Logo Changer
 * Last Updated: $Date: 2012-10-11 17:27:04 -0400 (Thu, 11 Oct 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Core
 * @link		http://www.invisionpower.com
 * @since		Tuesday 17th August 2004
 * @version		$Revision: 11446 $
 *
 */

if ( ! defined( 'IN_ACP' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded 'admin.php'.";
	exit();
}


class admin_core_templates_easylogo extends ipsCommand
{
	/**
	 * HTML Skin object
	 *
	 * @var		object
	 */
	protected $html;
	
	/**
	 * Skin Functions Class
	 *
	 * @var		object
	 */
	protected $skinFunctions;
	
	/**
	 * Class entry point
	 *
	 * @param	object		Registry reference
	 * @return	@e void		[Outputs to screen/redirects]
	 */
	public function doExecute( ipsRegistry $registry )
	{
		//-----------------------------------------
		// Load lang
		//-----------------------------------------
		
		$this->registry->getClass('class_localization')->loadLanguageFile( array( 'admin_templates' ), 'core' );
		
		//-----------------------------------------
		// Load skin
		//-----------------------------------------
		
		$this->html			= $this->registry->output->loadTemplate('cp_skin_templates');
		
		//-----------------------------------------
		// Set up stuff
		//-----------------------------------------
		
		$this->form_code	= $this->html->form_code	= 'module=templates&amp;section=easylogo';
		$this->form_code_js	= $this->html->form_code_js	= 'module=templates&section=easylogo';
		
		//-----------------------------------------
		// Load functions and cache classes
		//-----------------------------------------
	
		require_once( IPS_ROOT_PATH . 'sources/classes/skins/skinFunctions.php' );/*noLibHook*/
		require_once( IPS_ROOT_PATH . 'sources/classes/skins/skinCaching.php' );/*noLibHook*/
		
		$this->skinFunctions = new skinCaching( $registry );		
	
		//-----------------------------------------
		// What to do?
		//-----------------------------------------

		$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'easy_logo' );
		
		switch( $this->request['do'] )
		{
			default:
			case 'splash':
				$this->splash();
				break;
			case 'finish':
				$this->complete();
				break;
		}
		
		/* Output */
		$this->registry->output->html_main .= $this->registry->output->global_template->global_frame_wrapper();
		$this->registry->output->sendOutput();
	}
	
	/**
	 * Finish changing the logo
	 *
	 * @return	@e void		[Outputs to screen/redirects]
	 */
	public function complete()
	{
		//-----------------------------------------
		// Check id
		//-----------------------------------------
		
		if ( ! $this->request['skin'] )
		{
			$this->registry->output->global_message = $this->lang->words['el_noskinid'];
			$this->splash();
			return;
		}

		//-----------------------------------------
		// Upload or new logo?
		//-----------------------------------------
		
		if ( $_FILES['FILE_UPLOAD']['name'] == "" or ! $_FILES['FILE_UPLOAD']['name'] or ($_FILES['FILE_UPLOAD']['name'] == "none") )
		{
			if ( ! $_POST['logo_url'] )
			{
				$this->registry->output->global_message = $this->lang->words['el_nofile'];
				$this->splash();
				return;
			}
			
			$newlogo = $_POST['logo_url'];
		}
		else
		{
			if ( ! is_writable( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . "/style_images" ) )
			{
				$this->registry->output->global_message = $this->lang->words['el_chmod'];
				$this->splash();
				return;
			}
			
			//-----------------------------------------
			// Upload
			//-----------------------------------------
			
			$FILE_NAME = $_FILES['FILE_UPLOAD']['name'];
			$FILE_SIZE = $_FILES['FILE_UPLOAD']['size'];
			$FILE_TYPE = $_FILES['FILE_UPLOAD']['type'];
			
			//-----------------------------------------
			// Silly spaces
			//-----------------------------------------
			
			$FILE_NAME = preg_replace( "/\s+/", "_", $FILE_NAME );
			
			//-----------------------------------------
			// Naughty Opera adds the filename on the end of the
			// mime type - we don't want this.
			//-----------------------------------------
			
			$FILE_TYPE = preg_replace( "/^(.+?);.*$/", "\\1", $FILE_TYPE );
			
			//-----------------------------------------
			// Correct file type?
			//-----------------------------------------
			
			if ( ! preg_match( "#\.(?:gif|jpg|jpeg|png)$#is", $FILE_NAME ) )
			{
				$this->registry->output->global_message = $this->lang->words['el_wrongformat'];
				$this->splash();
				return;
			}
			
			if ( move_uploaded_file( $_FILES[ 'FILE_UPLOAD' ]['tmp_name'], DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . "/style_images/{$this->request['skin']}_" . $FILE_NAME ) )
			{
				@chmod( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . "/style_images/" . $this->requestt['skin'] . "_" . $FILE_NAME, IPS_FILE_PERMISSION );
			}
			else
			{
				$this->registry->output->global_message = $this->lang->words['el_chmod'];
				$this->start();
				return;
			}
			
			$newlogo = "{$this->settings['public_dir']}style_images/{$this->request['skin']}_" . urlencode($FILE_NAME);
		}
		
		//-----------------------------------------
		// Update the macro..
		//-----------------------------------------
		
		$this->skinFunctions->saveReplacementFromEdit( $this->request['replacementId'], $this->request['skin'], $newlogo, 'logo_img' );
		
		//-----------------------------------------
		// Rebuild cache(s)
		//-----------------------------------------

		$this->skinFunctions->rebuildReplacementsCache( $this->request['skin'] );
		
		$this->registry->output->global_message = sprintf( $this->lang->words['el_log'], $this->request['skin'] );

		if( $this->skinFunctions->fetchErrorMessages() )
		{
			$this->registry->output->global_message .= "<br />" . implode( "<br />", $this->skinFunctions->fetchErrorMessages() );
		}
		
		if( $this->skinFunctions->fetchMessages() )
		{
			$this->registry->output->global_message .= "<br />" . implode( "<br />", $this->skinFunctions->fetchMessages() );
		}
		
		$this->splash();
	}
	
	/**
	 * Show the form to change the logo
	 *
	 * @return	@e void		[Outputs to screen/redirects]
	 */
	public function splash()
	{
		//-----------------------------------------
		// Can we upload into style_images?
		//-----------------------------------------
		
		$warning	= ! is_writable( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_images' ) ? true : false;
		
		//-----------------------------------------
		// Get header logo image
		//-----------------------------------------
		
		$replacements	= $this->skinFunctions->fetchReplacements( 0 );
		$currentUrl		= $replacements['logo_img']['replacement_content'];
		$currentId		= $replacements['logo_img']['replacement_id'];

		$this->registry->output->html .= $this->html->easyLogo( $warning, $currentUrl, $currentId );
	}
	
}