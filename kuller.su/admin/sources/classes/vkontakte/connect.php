<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.2.0
 * Vkontakte Connect Library
 * Last Updated: $Date: 2011-06-06 16:33:53 -0400 (Mon, 06 Jun 2011) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/community/board/license.html
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @version		$Rev: 8980 $
 *
 */

class vkontakte_connect
{
	/**#@+
	* Registry Object Shortcuts
	*
	* @access	protected
	* @var		object
	*/
	protected $registry;
	protected $DB;
	protected $settings;
	protected $request;
	protected $lang;
	protected $member;
	protected $memberData;
	protected $cache;
	protected $caches;
	/**#@-*/
	
	/**
	 * Vkontakte OAUTH wrapper
	 *
	 * @access	protected
	 * @var		object
	 */
	protected $_api;
	
	/**
	 * IPBs log in handler
	 *
	 * @access	protected
	 * @var		object
	 */
	protected $_login;
	
	/**
	 * User connected
	 * 
	 * @access	protected
	 * @var		boolean
	 */
	protected $_connected = false;
	
	/**
	 * User: Token
	 *
	 * @access	protected
	 * @var		string
	 */
	protected $_userToken;
	
	/**
	 * User: Secret
	 *
	 * @access	protected
	 * @var		string
	 */
	protected $_userSecret;

	/**
	 * User: ID
	 *
	 * @access	protected
	 * @var		int
	 */
	protected $_userId;

	
	/**
	 * User: Data
	 *
	 * @access	protected
	 * @var		array
	 */
	protected $_userData = array();
	
	/**
	 * Construct.
	 * @access	public
	 * @return	@e void
	 */
	public function __construct( $registry, $token='', $userId=0 )
	{
		/* Make object */
		$this->registry   =  $registry;
		$this->DB         =  $this->registry->DB();
		$this->settings   =& $this->registry->fetchSettings();
		$this->request    =& $this->registry->fetchRequest();
		$this->lang       =  $this->registry->getClass('class_localization');
		$this->member     =  $this->registry->member();
		$this->memberData =& $this->registry->member()->fetchMemberData();
		$this->cache      =  $this->registry->cache();
		$this->caches     =& $this->registry->cache()->fetchCaches();
		
		define("VKONTAKTE_APP_ID"   , trim( ipsRegistry::$settings['vk_api_id'] ) );
		define("VKONTAKTE_APP_SECRET", trim( ipsRegistry::$settings['vk_secret'] ) );
		define("VKONTAKTE_CALLBACK" , $this->settings['_original_base_url'] . '/interface/vkontakte/index.php?m=' . $this->memberData['member_id'] );

		/* Auto do it man */
		if ( ! $token AND $this->memberData['member_id'] AND $this->memberData['vk_token'] )
		{
			$token  = $this->memberData['vk_token'];
		}
		
		/* Auto do it man */
		if ( ! $userId AND $this->memberData['member_id'] AND $this->memberData['vk_uid'] )
		{
			$userId  = $this->memberData['vk_uid'];
		}
		
		
		/* Test */
		if ( ! VKONTAKTE_APP_ID OR ! VKONTAKTE_APP_SECRET )
		{
			throw new Exception( 'VK_NOT_SET_UP' );
		}

		/* Set include path.. */
		@set_include_path( IPS_KERNEL_PATH . 'vkontakte/' . PATH_SEPARATOR . ini_get( 'include_path' ) );/*noLibHook*/
		
		/* Reset the API */
		$this->resetApi( $token, $userId );
	}
	
	/**
	 * Resets API
	 *
	 * @access	public
	 * @param	string		OAUTH user token
	 * @param	string		OAUTH user secret
	 */
	public function resetApi( $token='', $userId='' )
	{
		$this->_userToken  = trim( $token );
		$this->_userId = trim( $userId );
		
		/* Load API */
		require_once( IPS_KERNEL_PATH . 'vkontakte/oauth2.php' );/*noLibHook*/
		$this->_api = new vkClient( 
		    array(
                'base_uri'                  => $this->settings['_original_base_url'],
                'client_id'                 => VKONTAKTE_APP_ID,
                'client_secret'             => VKONTAKTE_APP_SECRET,
                'cookie_support'            => true,
                'scope'                     => 'wall',
                'base_domain'               => $this->settings['cookie_domain'],
                'services_uri'              => 'https://api.vk.com/method',
                'access_token_uri'          => 'https://api.vk.com/oauth/access_token',
                'authorize_uri'             => 'https://oauth.vk.com/authorize',
                'authorize_callback_uri'    => VKONTAKTE_CALLBACK
            )
        );
		
        if ( $this->_userToken AND $this->_userId )
        {
            try
            {
    			$r = $this->_api->api( 'getProfiles', 'GET', array(
    			    'access_token'=> $this->_userToken, 
    			    'uids' => $this->_userId, 
    			    'fields' => 'uid,first_name,last_name,nickname,photo,photo_medium,photo_big,timezone,sex,activity' 
    			) );
			
    			$_userData = array_pop( $r['response'] );
            }
            catch ( Exception $e ) {}
            
            if ( $_userData['uid'] )
            {
                $this->_userData  = $_userData;
		$this->_userData['photo']=$_userData['photo_big'];
                $this->_connected = true;
            }
            else
            {
                $this->_userData  = array();
                $this->_connected = false;
            }
        }
        else
        {
			$this->_userData  = array();
			$this->_connected = false;
        }
	}

	/**
	 * Return user data
	 *
	 * @access	public
	 * @return	array
	 */
	public function fetchUserData( $token='' ) 
	{
		return $this->_userData;
	}
	
	/**
	 * Return whether or not the user is connected
	 *
	 * @access	public
	 * @return	boolean
	 */
	public function isConnected()
	{
		return ( $this->_connected == true ) ? true : false;
	}
	
	/**
	 * Post a status update to vk wall based on native content
	 * Which may be longer and such and so on and so forth, etc
	 *
	 * @access	public
	 * @param	string		Content
	 * @param	string		URL to add
	 * @param	bool		Always add the URL regardless of content length
	 */
	public function updateStatusWithUrl( $content, $url, $alwaysAdd=TRUE )
	{
		/* Ensure content is correctly de-html-ized */
		$content = IPSText::UNhtmlspecialchars( $content );
		
		/* Is the text longer than 140 chars? */
		if ( $alwaysAdd === TRUE or IPSText::mbstrlen( $content ) > 140 )
		{
			/* Leave 26 chars for URL shortener */
			if ( IPSText::mbstrlen( $content ) > 117 )
			{
				$content = IPSText::mbsubstr( $content, 0, 114 ) . '...';
			}
			
			/* Generate short URL */
			$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/classes/url/shorten.php', 'urlShorten' );
			$shorten = new $classToLoad();
 			
 			$data      = $shorten->shorten( $url, IPS_URL_SHORTEN_SERVICE );
 			
 			return $this->updateStatus( $content . ' ' . $data['url'] );
		}
		else
		{
			/* Just post it */
			return $this->updateStatus( $content );
		}
	}
	
	/**
	 * Post a status update to vkontakte
	 *
	 * @access	public
	 * @return	mixed		status id (int) successful, FALSE, #ftl
	 */
	public function updateStatus( $text )
	{
		die('To be implemented');
	}
	
	/**
	 * Redirects a user to the oauth connect page.
	 *
	 * @access	public
	 * @return	redirect
	 */
	public function redirectToConnectPage()
	{
                /* Stop - no need to redirect if ACP / IN_TASK  */
		if ( IN_ACP OR IPS_IS_TASK )
		{
			return false;
		}
		
		/* Reset api to ensure user is not logged in */
		$this->resetApi();
		
		/* Append OAUTH URL */
                $_urlExtra = '';
		$key =  md5( uniqid( microtime() ) );
		$_urlExtra = '&key=' . $key;

		/* From registration/log in? */
		if ( ! $this->memberData['member_id'] AND $this->request['reg'] )
		{
			/* Append URL with correct member ID and other params */
			$_urlExtra .= '&reg=1';
		}

		/* Update user's row */
		if ( $this->memberData['member_id'] )
		{
			IPSMember::save( $this->memberData['member_id'], array( 'core' => array( 'vk_token'  => $key ) ) );
		}
		/* Is mobile? */
		if ( $this->member->isMobileApp || ! empty( $_REQUEST['mobile'] ) )
		{
			$this->_oauth->setFormFactor( 'touch' );
		}
                /* Update callback url */
		$this->_api->setVariable( 'authorize_callback_uri', VKONTAKTE_CALLBACK . $_urlExtra );
		
		$this->registry->output->silentRedirect( $this->_api->getAuthorizeUrl() );  
	}
	
	/**
	 * Completes the connection
	 *
	 * @access	public
	 * @return	redirect
	 * 
	 */
	public function finishLogin()
	{
		/* From reg flag */
		if ( $_REQUEST['code'] )
		{
    		/* Reset api to ensure user is not logged in */
    		$this->resetApi();
			
			/* Ensure URL is correct */
			$_urlExtra = '';
			
			if ( $_REQUEST['key'] )
			{
				$_urlExtra .= '&key=' . $_REQUEST['key'];
			}
			
			if ( $_REQUEST['reg'] )
			{
				$_urlExtra .= '&reg=1';
			}
			
			/* Update callback url */
			$this->_api->setVariable( 'authorize_callback_uri', VKONTAKTE_CALLBACK . $_urlExtra );

			/* Generate oAuth token */
			$rToken = $this->_api->getAccessToken();
			
			if ( is_string( $rToken ) )
			{
				try
				{
				    $oAuthSession = $this->_api->getSession();
					$r = $this->_api->api( 'getProfiles', 'GET', array('uids' => $oAuthSession['user_id'], 'fields' => 'uid,first_name,last_name,nickname,photo,photo_medium,photo_big,timezone,sex,nickname,activity' ) );
					
					$_userData = array_pop( $r['response'] );
				}
				catch( Exception $e ){}
				
				/* A little gymnastics */
				$this->_userData = $_userData;
				$this->_userData['photo']=$_userData['photo_big'];
				
				/* Got a member linked already? */
				$_member = IPSMember::load( $_userData['uid'], 'all', 'vk_uid' );
								
				if ( $_member['member_id'] )
				{
					$memberData = $_member;
					
					/* Ensure user's row is up to date */
					IPSMember::save( $memberData['member_id'], array( 'core' => array( 'vk_token' => $rToken ) ) );
					    
					/* Here, so log us in!! */
					/* changed by denchu 26/12/12 */
					$r = $this->_login()->loginWithoutCheckingCredentials( $memberData['member_id'], TRUE );
					if (is_array($r))
								{
									if (isset($r[1]))
									{
										$this->registry->getClass('output')->redirectScreen( $r[0],$r[1] );
										$this->registry->getClass('output')->silentRedirect( $r[1] );
									}
									else
									{
										$this->registry->getClass('output')->silentRedirect( $r[0] );
									}
								}
								elseif (!$r)
								{
									throw new Exception( 'LINKED_MEMBER_LOGIN_FAIL' );
								}
								else
								{
									$this->registry->getClass('output')->silentRedirect( $this->settings['base_url'] );
								}

				}
				else
				{
                    /* No? Create a new member */
                    foreach( array( 'vc_s_pic', 'vc_s_status' ) as $field )
                    {
                        $toSave[ $field ] = 1;
                    }
                    
                    $vk_bwoptions = IPSBWOptions::freeze( $toSave, 'vkontakte' );
					$safeName   =  IPSText::convertCharsets( $_userData['first_name'] .' '. $_userData['last_name'], 'utf-8', IPS_DOC_CHAR_SET ) ;
					$displayName = ( $this->settings['fb_realname'] == 'enforced' ) ? $safeName : '';
					//$displayName  = ( ! $this->settings['auth_allow_dnames'] ) ? $safeName : FALSE;
					
					/* Make sure usernames are safe */
					if ( $this->settings['username_characters'] )
					{
						$check_against = preg_quote( $this->settings['username_characters'], "/" );
						$check_against = str_replace( '\-', '-', $check_against );
						
						$safeName = preg_replace( '/[^' . $check_against . ']+/i', '', $safeName );
						
					}
					if (IPSText::mbstrlen($safeName)>$this->settings['max_user_name_length'])
					{
					$safeName   =  mb_substr(IPSText::convertCharsets( $_userData['last_name'], 'utf-8', IPS_DOC_CHAR_SET ),0,$this->settings['max_user_name_length'],'UTF-8');
					}
					
					/* Check ban filters? */
					if ( IPSMember::isBanned( 'name', $safeName ) )
					{
						$this->registry->output->showError( 'you_are_banned', 1090003 );
					}
					
							
		
					/* From reg, so create new account properly */
					$toSave = array( 'core' 		 => array(  'name' 				     => $safeName,
													 		    'members_display_name'   => $displayName,
													 		    'members_created_remote' => 1,
													 		    'member_group_id'		 => ( $this->settings['vk_mgid'] ) ? $this->settings['vk_mgid'] : $this->settings['member_group'],
                                                                'email'                  => '',
															    'vk_uid'                 => $_userData['uid'],
															    'time_offset'            => $_userData['timezone'],
															    'vk_token'               => $rToken ),
									'extendedProfile' => array( 'vk_bwoptions'    		 => $vk_bwoptions ) );
	
					
					$memberData = IPSMember::create( $toSave, TRUE, FALSE, TRUE );
					
					if ( ! $memberData['member_id'] )
					{
						throw new Exception( 'CREATION_FAIL' );
					}
					
					/* Sync up photo */
                    $this->syncMember( $memberData['member_id'] );
					
					$pmember = $this->DB->buildAndFetch( array( 'select' => '*', 'from' => 'members_partial', 'where' => "partial_member_id=" . $memberData['member_id'] ) );

					if ( $pmember['partial_member_id'] )
					{
						$this->registry->getClass('output')->silentRedirect( $this->settings['base_url'] . 'app=core&module=global&section=register&do=complete_login&mid='. $memberData['member_id'].'&key='.$pmember['partial_date'] );
					}
					else
					{
						/* Already got a display name */
						if ( $displayName )
						{
							/* Here, so log us in!! */
							/* changed by denchu 26/12/12*/
							$r = $this->_login()->loginWithoutCheckingCredentials( $memberData['member_id'], TRUE );
							IPSLib::runMemberSync( 'onCompleteAccount', $memberData );
                                                        
                                                        if ( $this->settings['new_reg_notify'] )
							{
								$this->registry->class_localization->loadLanguageFile( array( 'public_register' ), 'core' );
								
								IPSText::getTextClass('email')->setPlainTextTemplate( IPSText::getTextClass('email')->getTemplate("admin_newuser") );
							
								IPSText::getTextClass('email')->buildMessage( array( 'DATE'			=> $this->registry->getClass('class_localization')->getDate( time(), 'LONG', 1 ),
																					 'LOG_IN_NAME'  => $safeFBName,
																					 'EMAIL'		=> $_userData['email'],
																					 'IP'			=> $this->member->ip_address,
																					 'DISPLAY_NAME'	=> $displayName ) );
															
								IPSText::getTextClass('email')->subject = sprintf( $this->lang->words['new_registration_email'], $this->settings['board_name'] );
								IPSText::getTextClass('email')->to      = $this->settings['email_in'];
								IPSText::getTextClass('email')->sendMail();
							}
							if (is_array($r))
								{
									if (isset($r[1]))
									{
										$this->registry->getClass('output')->redirectScreen( $r[0],$r[1] );
										$this->registry->getClass('output')->silentRedirect( $r[1] );
									}
									else
									{
										$this->registry->getClass('output')->silentRedirect( $r[0] );
									}
								}
								elseif (!$r)
								{
									throw new Exception( 'LINKED_MEMBER_LOGIN_FAIL' );
								}
								else
								{
									$this->registry->getClass('output')->silentRedirect( $this->settings['base_url'] );
								}
						}
						else
						{
							throw new Exception( 'CREATION_FAIL' );
						}
					}
				}
			}
			else
			{
				throw new Exception( 'CREATION_FAIL' );
			}
		}
	}
	
	/**
	 * Completes the connection
	 *
	 * @access	public
	 * @return	redirect
	 */
	public function finishConnection()
	{
		if ( $_REQUEST['m'] AND $_REQUEST['key'] )
		{
			/* Load user */
			$member = IPSMember::load( intval( $_REQUEST['m'] ) );
		
			if ( $member['vk_token'] == $_REQUEST['key'] )
			{
        		/* Reset api to ensure user is not logged in */
        		$this->resetApi();

    			/* Ensure URL is correct */
    			$_urlExtra = '';

    			if ( $_REQUEST['key'] )
    			{
    				$_urlExtra .= '&key=' . $_REQUEST['key'];
    			}

    			if ( $_REQUEST['reg'] )
    			{
    				$_urlExtra .= '&reg=1';
    			}

    			/* Update callback url */
    			$this->_api->setVariable( 'authorize_callback_uri', VKONTAKTE_CALLBACK . $_urlExtra );

    			/* Generate oAuth token */
    			$rToken = $this->_api->getAccessToken();

				if ( is_string( $rToken ) )
				{
					try
					{
    				    $oAuthSession = $this->_api->getSession();
    					$r = $this->_api->api( 'getProfiles', 'GET', array('uids' => $oAuthSession['user_id'], 'fields' => 'uid' ) );

    					$_userData = array_pop( $r['response'] );
					}
					catch( Exception $e )
                                        {
                                             $this->registry->output->logErrorMessage( $e->getMessage(), 'VK-EXCEPTION' );
                                        }              

					/* Ensure user's row is up to date */
					IPSMember::save( $member['member_id'], array( 'core' => array( 'vk_uid'    => $_userData['uid'],
																				   'vk_token'  => $rToken ) ) );
				}
			}
		}
		
		/* Redirect back to settings page */
		$this->registry->getClass('output')->silentRedirect( $this->settings['base_url'] . 'app=core&module=usercp&tab=core&area=vkontakte' );
	}
	
		/**
	 * Finish a log-in connection
	 * WARNING: NO PERMISSION CHECKS ARE PERFORMED IN THIS FUNCTION.
	 *
	 * @access		public
	 * @param		int			Forum ID of original member (member to keep)
	 * @param		int			Forum ID of linking member  (member to remove)
	 * @return		boolean
	 */
	public function finishNewConnection( $originalId, $newId )
	{
		if ( $originalId AND $newId )
		{
			$original = IPSMember::load( $originalId, 'all' );
			$new      = IPSMember::load( $newId, 'all' );
			
			if ( $original['member_id'] AND $new['vk_uid'] AND $new['vk_token'] )
			{
				IPSMember::save( $original['member_id'], array( 'core' => array( 'vk_uid' => $new['vk_uid'], 'vk_token' => $new['vk_token'] ) ) );
				
				return true;
			}
		}
		
		return false;
	}
	
	/**
	 * Function to resync a member's Vkontakte data
	 *
	 * @access	public
	 * @param	mixed		Member Data in an array form (result of IPSMember::load( $id, 'all' ) ) or a member ID
	 * @return	array 		Updated member data	
	 *
	 * EXCEPTION CODES:
	 * NO_MEMBER		Member ID does not exist
	 * NOT_LINKED		Member ID or data specified is not linked to a FB profile
	 */
	public function syncMember( $memberData )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$exProfile = array();
		
		/* Do we need to load a member? */
		if ( ! is_array( $memberData ) )
		{
			$memberData = IPSMember::load( intval( $memberData ), 'all' );
		}
		
		/* Got a member? */
		if ( ! $memberData['member_id'] )
		{
			throw new Exception( 'NO_MEMBER' );
		}
		
		/* Linked account? */
		if ( ! $memberData['vk_uid'] )
		{
			throw new Exception( 'NOT_LINKED' );
		}
		
		/* Not completed sign up ( no display name ) 
		if ( $memberData['member_group_id'] == $this->settings['auth_group'] )
		{
			return false;
		}
		*/
		/* Thaw Options */
		$bwOptions = IPSBWOptions::thaw( $memberData['vk_bwoptions'], 'vkontakte' );

		/* Grab the data */
		try
		{
			$this->resetApi( $memberData['vk_token'], $memberData['vk_uid'] );
			
			if ( $this->isConnected() )
			{
				$user = $this->fetchUserData();
				
				/* Load library */
				if ( $bwOptions['vc_s_pic'] )
				{
					$classToLoad  = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/classes/member/photo.php', 'classes_member_photo' );
					$photo = new $classToLoad( $this->registry );
					
					$photo->save( $memberData, 'vkontakte' );
				}
			
}
		}
		catch( Exception $e )
		{
		}
		
		return $memberData;
	}
	
	/**
	 * Fetch a user's recent status updates (max 50)
	 *
	 * @access	public
	 * @param	int		Vkontakte ID
	 * @param	bool	Strip @replies (true default)
	 * @param	int		Minimum ID to grab from
	 * @return	array
	 */
	public function fetchUserWall( $userId=0, $minId=0 )
	{
		$userId = ( $userId ) ? $userId : $this->_userData['uid'];
		$count  = 50;
		$final  = array();
		
		$updates = $this->_api->api('wall.get', 'GET', array( 
		    'access_token' => $this->_userToken,
		    'owner_id' => $userId, 'count' => 50, 'offset' => $minId, 'filter' => 'owner' ) );
		
		
		
		return $final;
	}
	
	/**
	 * Accessor for the log in functions
	 *
	 * @access	public
	 * @return	object
	 */
	public function _login()
	{
		if ( ! is_object( $this->_login ) )
		{
			$classToLoad  = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/handlers/han_login.php', 'han_login' );
			$this->_login =  new $classToLoad( $this->registry );
	    	$this->_login->init();
		}
		
		return $this->_login;
	}
	
}