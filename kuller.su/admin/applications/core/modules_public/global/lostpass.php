<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Recover Lost Password
 * Last Updated: $Date: 2012-11-28 04:54:58 -0500 (Wed, 28 Nov 2012) $
 * </pre>
 *
 * @author 		$Author $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Core
 * @link		http://www.invisionpower.com
 * @since		20th February 2002
 * @version		$Rev: 11651 $
 *
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

class public_core_global_lostpass extends ipsCommand
{
	/**
	 * Class entry point
	 *
	 * @param	object		Registry reference
	 * @return	@e void		[Outputs to screen/redirects]
	 */
	public function doExecute( ipsRegistry $registry )
	{
		/* Load language */
		$this->registry->class_localization->loadLanguageFile( array( 'public_register' ), 'core' );

    	//-----------------------------------------
    	// Meta tags
    	//-----------------------------------------
    	
    	$this->registry->output->addMetaTag( 'robots', 'noindex' );
    	
		/* What to do */
		switch( $this->request['do'] )
		{
			case 'sendform':
				$this->lostPasswordValidateForm();
			break;
			
			case '11':
				$this->lostPasswordEnd();
			break;
			
			case '03':
				$this->lostPasswordValidate();
			break;

			default:
			case '10':
				$this->lostPasswordForm();
			break;
		}
		
		/* Output */
		$this->registry->output->addContent( $this->output );
		$this->registry->output->sendOutput();				
	}
	
	/**
	 * Validates a lost password request
	 *
	 * @return	@e void
	 */
	public function lostPasswordValidate()
	{
		/* Check for input and it's in a valid format. */
		$in_user_id      = intval( trim( urldecode( $this->request['uid'] ) ) );
		$in_validate_key = IPSText::md5Clean( trim( urldecode( $this->request['aid'] ) ) );
		
		/* Check Input */
		if( ! $in_validate_key )
		{
			$this->registry->output->showError( 'validation_key_incorrect', 1015 );
		}
		
		if( ! preg_match( '/^(?:\d){1,}$/', $in_user_id ) )
		{
			$this->registry->output->showError( 'uid_key_incorrect', 1016 );
		}
		
		/* Attempt to get the profile of the requesting user */
		$member = IPSMember::load( $in_user_id );
			
		if( ! $member['member_id'] )
		{
			$this->registry->output->showError( 'lostpass_no_member', 1017 );
		}
		
		/* Get validating info.. */
		$validate = $this->DB->buildAndFetch( array( 'select' => '*', 'from' => 'validating', 'where' => 'member_id=' . $in_user_id . ' and lost_pass=1' ) );

		if( ! $validate['member_id'] )
		{
			$this->registry->output->showError( 'lostpass_not_validating', 1018 );
		}
		
		if( ( $validate['new_reg'] == 1 ) && ( $this->settings['reg_auth_type'] == "admin" ) ) 
		{ 
			$this->registry->output->showError( 'lostpass_new_reg', 4010, true ); 
		} 
		
		if( $validate['vid'] != $in_validate_key )
		{
			$this->registry->output->showError( 'lostpass_key_wrong', 1019 );
		}
		else
		{
			/* On the same page? */
			if( $validate['lost_pass'] != 1 )
			{
				$this->registry->output->showError( 'lostpass_not_lostpass', 4011, true );
			}
			
			/* Send a new random password? */
			if( $this->settings['lp_method'] == 'random' )
			{
				//-----------------------------------------
				// INIT
				//-----------------------------------------
				
				$save_array = array();
				
				//-----------------------------------------
				// Generate a new random password
				//-----------------------------------------
				
				$new_pass = IPSMember::makePassword();
				
				//-----------------------------------------
				// Generate a new salt
				//-----------------------------------------
				
				$salt = IPSMember::generatePasswordSalt(5);
				$salt = str_replace( '\\', "\\\\", $salt );
				
				//-----------------------------------------
				// New log in key
				//-----------------------------------------
				
				$key  = IPSMember::generateAutoLoginKey();
				
				//-----------------------------------------
				// Update...
				//-----------------------------------------
				
				$save_array['members_pass_salt']		= $salt;
				$save_array['members_pass_hash']		= md5( md5($salt) . md5( $new_pass ) );
				$save_array['member_login_key']			= $key;
				$save_array['member_login_key_expire']	= $this->settings['login_key_expire'] * 60 * 60 * 24;
				$save_array['failed_logins']			= null;
				$save_array['failed_login_count']		= 0;
				
		        //-----------------------------------------
		    	// Load handler...
		    	//-----------------------------------------
		    	
		    	$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/handlers/han_login.php', 'han_login' );
		    	$this->han_login =  new $classToLoad( $this->registry );
		    	$this->han_login->init();
		    	$this->han_login->changePass( $member['email'], md5( $new_pass ), $new_pass, $member );
		    	
		    	//if ( $this->han_login->return_code != 'METHOD_NOT_DEFINED' AND $this->han_login->return_code != 'SUCCESS' )
		    	//{
				//	$this->registry->output->showError( $this->lang->words['lostpass_external_fail'], 2013 );
		    	//}
				
		    	IPSMember::save( $member['member_id'], array( 'members' => $save_array ) );
				
				/* Password has been changed! */
				IPSLib::runMemberSync( 'onPassChange', $member['member_id'], $new_pass );
				
				//-----------------------------------------
				// Send out the email...
				//-----------------------------------------
			
				$message = array( 'NAME'		=> $member['members_display_name'],
								  'THE_LINK'	=> $this->registry->getClass('output')->buildUrl( 'app=core&module=usercp&tab=core&area=email', 'publicNoSession' ),
								  'PASSWORD'	=> $new_pass,
								  'LOGIN'		=> $this->registry->getClass('output')->buildUrl( 'app=core&module=global&section=login', 'publicNoSession' ),
								  'USERNAME'	=> $member['name'],
								  'EMAIL'		=> $member['email'],
								  'ID'		    => $member['member_id'] );
				
				IPSText::getTextClass('email')->setPlainTextTemplate( IPSText::getTextClass('email')->getTemplate( "lost_pass_email_pass", $member['language'] ) );
				IPSText::getTextClass('email')->buildPlainTextContent( $message );											
				IPSText::getTextClass('email')->buildHtmlContent( $message );
				
				IPSText::getTextClass('email')->subject = $this->lang->words['lp_random_pass_subject'] . ' ' . $this->settings['board_name'];
				IPSText::getTextClass('email')->to      = $member['email'];
				
				IPSText::getTextClass('email')->sendMail();

				$this->registry->output->setTitle( $this->lang->words['activation_form'] . ' - ' . ipsRegistry::$settings['board_name'] );
				$this->output = $this->registry->getClass('output')->getTemplate('register')->showLostPassWaitRandom( $member );	
			}
			else
			{
				if( $_POST['pass1'] == "" )
				{
					$this->registry->output->showError( 'pass_blank', 10184 );
				}
			
				if( $_POST['pass2'] == "" )
				{
					$this->registry->output->showError( 'pass_blank', 10185 );
				}
			
				$pass_a = trim( $this->request['pass1'] );
				$pass_b = trim( $this->request['pass2'] );
			
				/*
				There's no reason for this - http://community.invisionpower.com/resources/bugs.html/_/ip-board/registrations-limit-passwords-to-32-characters-for-no-apparent-reason-r37770
				if( strlen( $pass_a ) < 3 )
				{
					$this->registry->output->showError( 'pass_too_short', 10186 );						
				}
				*/
			
				if( $pass_a != $pass_b )
				{
					$this->registry->output->showError( 'pass_no_match', 10187 );								
				}
			
				$new_pass = md5( $pass_a );
				
				/* Update Member Array */
				$save_array = array();
				
				/* Generate a new salt */
				$salt = IPSMember::generatePasswordSalt(5);
				$salt = str_replace( '\\', "\\\\", $salt );
				
				/* New log in key */
				$key = IPSMember::generateAutoLoginKey();
				
				/* Update Array */
				$save_array['members_pass_salt']		= $salt;
				$save_array['members_pass_hash']		= md5( md5($salt) . $new_pass );
				$save_array['member_login_key']			= $key;
				$save_array['member_login_key_expire']	= $this->settings['login_key_expire'] * 60 * 60 * 24;
				$save_array['failed_logins']			= null;
				$save_array['failed_login_count']		= 0;					
				
				/* Change the password */
		    	$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/handlers/han_login.php', 'han_login' );
		    	$this->han_login =  new $classToLoad( $this->registry );
		    	$this->han_login->init();
				$this->han_login->changePass( $member['email'], $new_pass, $pass_a, $member );
		    	
				//-----------------------------------------
				// We'll ignore any remote errors
				//-----------------------------------------
				
		    	/*if( $this->han_login->return_code != 'METHOD_NOT_DEFINED' AND $this->han_login->return_code != 'SUCCESS' )
		    	{
					// Pass not changed remotely
		    	}*/
		    	
		    	/* Update the member */
		    	IPSMember::save( $member['member_id'], array( 'members' => $save_array ) );
				
				/* Password has been changed! */
				IPSLib::runMemberSync( 'onPassChange', $member['member_id'], $pass_a );
			
				/* Remove "dead" validation */
				$this->DB->delete( 'validating', "vid='{$validate['vid']}' OR (member_id={$member['member_id']} AND lost_pass=1)" );
				
				$this->registry->output->silentRedirect( $this->registry->getClass('output')->buildUrl( 'app=core&module=global&section=login&do=autologin&frompass=1' ) );
			}
		}
	} 	
	
	/**
	 * Completes the lost password request form
	 *
	 * @return	@e void
	 */
	public function lostPasswordEnd()
	{
		if( $this->settings['bot_antispam_type'] != 'none' )
		{
			if( !$this->registry->getClass('class_captcha')->validate( $this->request['regid'], $this->request['reg_code'] ) )
			{
				$this->lostPasswordForm( 'err_reg_code' );
				return;
			}
		}
		
		/* Back to the usual programming! :o */
		if( $this->request['member_name'] == "" AND $this->request['email_addy'] == "" )
		{
			$this->registry->output->showError( 'lostpass_name_email', 10110 );
		}
		
		/* Check for input and it's in a valid format. */
		$member_name = trim( mb_strtolower( $this->request['member_name'] ) );
		$email_addy  = trim( mb_strtolower( $this->request['email_addy'] ) );
		
		if( $member_name == "" AND $email_addy == "" )
		{
			$this->registry->output->showError( 'lostpass_name_email', 10111 );
		}
		
		/* Attempt to get the user details from the DB */
		if( $member_name )
		{
			$this->DB->build( array( 'select' => 'members_display_name, name, member_id, email, member_group_id', 'from' => 'members', 'where' => "members_l_username='{$member_name}'" ) );
			$this->DB->execute();
		}
		else if( $email_addy )
		{
			$this->DB->build( array( 'select' => 'members_display_name, name, member_id, email, member_group_id', 'from' => 'members', 'where' => "email='{$email_addy}'" ) );
			$this->DB->execute();
		}

		if ( ! $this->DB->getTotalRows() )
		{
			$this->registry->output->showError( 'lostpass_no_user', 10112 );
		}
		else
		{
			$member = $this->DB->fetch();
			
			/* Is there a validation key? If so, we'd better not touch it */
			if( $member['member_id'] == "" )
			{
				$this->registry->output->showError( 'lostpass_no_mid', 2014 );
			}
			
			$validate_key = md5( IPSMember::makePassword() . uniqid( mt_rand(), TRUE ) );
			
			/* Get rid of old entries for this member */
			$this->DB->delete( 'validating', "member_id={$member['member_id']} AND lost_pass=1" );
			
			/* Update the DB for this member. */
			$db_str = array('vid'         => $validate_key,
							'member_id'   => $member['member_id'],
							'temp_group'  => $member['member_group_id'],
							'entry_date'  => time(),
							'coppa_user'  => 0,
							'lost_pass'   => 1,
							'ip_address'  => $this->member->ip_address,
						   );
					
			/* Are they already in the validating group? */
			if( $member['member_group_id'] != $this->settings['auth_group'] )
			{
				$db_str['real_group'] = $member['member_group_id'];
			}
						   
			$this->DB->insert( 'validating', $db_str );
			
			/* Send out the email. */
			$message = array(   'USERNAME'   => $member['name'],
								'NAME'       => $member['members_display_name'],
								'THE_LINK'   => $this->registry->getClass('output')->buildUrl( "app=core&module=global&section=lostpass&do=sendform&uid={$member['member_id']}&aid={$validate_key}", 'publicNoSession' ),
								'MAN_LINK'   => $this->registry->getClass('output')->buildUrl( 'app=core&module=global&section=lostpass&do=sendform', 'publicNoSession' ),
								'EMAIL'      => $member['email'],
								'ID'         => $member['member_id'],
								'CODE'       => $validate_key,
								'IP_ADDRESS' => $this->member->ip_address );
				
			IPSText::getTextClass('email')->setPlainTextTemplate( IPSText::getTextClass('email')->getTemplate( "lost_pass", $member['language'] ) );
			IPSText::getTextClass('email')->buildPlainTextContent( $message );											
			IPSText::getTextClass('email')->buildHtmlContent( $message );
			
			IPSText::getTextClass('email')->subject = $this->lang->words['lp_subject'] . ' ' . $this->settings['board_name'];
			IPSText::getTextClass('email')->to      = $member['email'];			
			IPSText::getTextClass('email')->sendMail();
			
			$this->output = $this->registry->getClass('output')->getTemplate('register')->lostPasswordWait( $member );
		}
    	
    	$this->registry->output->setTitle( $this->lang->words['lost_pass_form'] . ' - ' . ipsRegistry::$settings['board_name'] );
    }	
	
	/**
	 * Displays the lost password form
	 *
	 * @param	string	$errors
	 * @return	@e void
	 */
	public function lostPasswordForm( $errors="" )
	{
		//-----------------------------------------
    	// Do we have another URL for password resets?
    	//-----------------------------------------
    	
    	$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/handlers/han_login.php', 'han_login' );
    	$han_login =  new $classToLoad( $this->registry );
    	$han_login->init();
    	$han_login->checkMaintenanceRedirect();
				
		/* CAPTCHA */
		if( $this->settings['bot_antispam_type'] != 'none' )
		{
			$captchaHTML = $this->registry->getClass('class_captcha')->getTemplate();
		}
		
		$this->registry->output->setTitle( $this->lang->words['lost_pass_form'] . ' - ' . ipsRegistry::$settings['board_name'] );
		$this->registry->output->addNavigation( $this->lang->words['lost_pass_form'], '' );

    	$this->output .= $this->registry->output->getTemplate('register')->lostPasswordForm( $this->lang->words[ $errors ] );
    	
    	if ( $this->settings['bot_antispam_type'] != 'none' )
		{
			$this->output = str_replace( "<!--{REG.ANTISPAM}-->", $captchaHTML, $this->output );
		}
    }	
	
	
	/**
	 * Shows the form for validating a lost password request
	 *
	 * @param	string	$msg
	 * @return	@e void
	 */
	public function lostPasswordValidateForm( $msg='' )
	{
		$this->output .= $this->registry->getClass('output')->getTemplate('register')->showLostpassForm( $this->lang->words[$msg] );
		
		/* Check for input and it's in a valid format. */
		if( $this->request['uid'] AND $this->request['aid'] )
		{ 
			$in_user_id      = intval( trim( urldecode( $this->request['uid'] ) ) );
			$in_validate_key = IPSText::md5Clean( trim( urldecode( $this->request['aid'] ) ) );
			$in_type         = trim( $this->request['type'] );
			
			if ($in_type == "")
			{
				$in_type = 'reg';
			}
			
			/* Check and test input */
			if ( ! $in_validate_key )
			{
				$this->registry->output->showError( 'validation_key_incorrect', 10113 );
			}
			
			if (! preg_match( '/^(?:\d){1,}$/', $in_user_id ) )
			{
				$this->registry->output->showError( 'uid_key_incorrect', 10114 );
			}
			
			/* Attempt to get the profile of the requesting user */
			$member = IPSMember::load( $in_user_id );

			if( ! $member['member_id'] )
			{
				$this->registry->output->showError( 'lostpass_no_member', 10115 );
			}
			
			/* Get validating info.. */
			$validate = $this->DB->buildAndFetch( array( 'select' => '*', 'from' => 'validating', 'where' => "member_id={$in_user_id} and vid='{$in_validate_key}' and lost_pass=1" ) );
			
			if( ! $validate['member_id'] )
			{
				$this->registry->output->showError( 'validation_key_incorrect', 10116 );
			}
			
			$this->output = str_replace( "<!--IBF.INPUT_TYPE-->", $this->registry->output->getTemplate('register')->show_lostpass_form_auto( $in_validate_key, $in_user_id ), $this->output );
		}
		else
		{
			$this->output = str_replace( "<!--IBF.INPUT_TYPE-->", $this->registry->output->getTemplate('register')->show_lostpass_form_manual(), $this->output );
		}
		
		$this->registry->output->setTitle( $this->lang->words['activation_form'] . ' - ' . ipsRegistry::$settings['board_name'] );
		$this->registry->output->addNavigation( $this->lang->words['activation_form'], '' );
	}
}