<?php

//-----------------------------------------------
// (DP32) Forum Icons
//-----------------------------------------------
//-----------------------------------------------
// Application
//-----------------------------------------------
// Author: DawPi
// Site: http://www.ipslink.pl
// Written on: 02 / 08 / 2011
//-----------------------------------------------
// Copyright (C) 2011 DawPi
// All Rights Reserved
//-----------------------------------------------   

class admin_forumicons_settings_settings extends ipsCommand
{
	public $html;
	
	public function doExecute( ipsRegistry $registry )
	{
		$this->form_code    = '&amp;module=settings&amp;section=settings';
		$this->form_code_js = '&module=settings&section=settings';
		
		/* Check permissions */
		
		$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'manage_settings' );
		
		/* Do the job */
		
		$this->settings();
		
		/* Show results */
			
		$this->registry->output->html .= $this->registry->fiLibrary->c_acp();
		$this->registry->output->sendOutput();
	}
	

	private function settings()
	{			
		/* Set up stuff */
		
		$this->form_code	= 'module=settings&amp;section=settings';
		$this->form_code_js	= 'module=settings&section=settings';
		
		/* Grab, init and load settings */
		
		$classToLoad	= IPSLib::loadLibrary( IPSLib::getAppDir( 'core' ).'/modules_admin/settings/settings.php', 'admin_core_settings_settings' );
		$settings		= new $classToLoad( $this->registry );
		$settings->makeRegistryShortcuts( $this->registry );
		
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'admin_tools' ), 'core' );
		
		$settings->html			= $this->registry->output->loadTemplate( 'cp_skin_settings', 'core' );		
		$settings->form_code	= $settings->html->form_code    = 'module=settings&amp;section=settings';
		$settings->form_code_js	= $settings->html->form_code_js = 'module=settings&section=settings';

		$this->request['conf_title_keyword'] = 'dp3_fi';
		$settings->return_after_save         = $this->settings['base_url'] . $this->form_code . '&amp;do=settings';
		$settings->_viewSettings();
		
		/* Pass to CP output handler */
		
		$this->registry->getClass('output')->html_main .= $this->registry->getClass('output')->global_template->global_frame_wrapper();		
	}
}// End of class