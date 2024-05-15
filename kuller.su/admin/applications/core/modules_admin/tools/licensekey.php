<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * License Manager
 * Last Updated: $LastChangedDate: 2013-01-02 05:58:55 -0500 (Wed, 02 Jan 2013) $
 * </pre>
 *
 * @author 		$Author: mark $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Core
 * @link		http://www.invisionpower.com
 * @version		$Rev: 11770 $
 */

if ( ! defined( 'IN_ACP' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded 'admin.php'.";
	exit();
}


class admin_core_tools_licensekey extends ipsCommand
{
	/**
	 * Main entry point
	 *
	 * @param	object		ipsRegistry reference
	 * @return	@e void
	 */
	public function doExecute( ipsRegistry $registry )
	{
		/* Load lang and skin */
		$this->registry->class_localization->loadLanguageFile( array( 'admin_tools' ) );
		$this->html = $this->registry->output->loadTemplate( 'cp_skin_tools' );
		
		/* URLs */
		$this->form_code    = $this->html->form_code    = 'module=tools&amp;section=licensekey';
		$this->form_code_js = $this->html->form_code_js = 'module=tools&section=licensekey';
						
		/* What to do */
		switch( $this->request['do'] )
		{
			case 'activate':
				$this->activate();
				break;
				
			case 'remove':
				IPSLib::updateSettings( array( 'ipb_reg_number' => '' ) );
				$this->settings['ipb_reg_number'] = '';
				// Deliberately no break as we'll do onto recahce and then default action
				
			case 'refresh':
				$this->recache();
				// Deliberately no break as we'll go on to the default action
		
			default:
				if ( $this->settings['ipb_reg_number'] )
				{
					$this->overview();
				}
				else
				{
					$this->activateForm();
				}
		}
		
		/* Output */
		$this->registry->output->html_main .= $this->registry->output->global_template->global_frame_wrapper();
		$this->registry->output->sendOutput();
	}

	/**
	 * Show Activation Form
	 */
	protected function activateForm( $error='' )
	{
		$this->registry->output->html .= $this->html->activateForm( $error );
	}
	
	/**
	 * Activate
	 */
	protected function activate()
	{
		$key = darkLAE::getLicenseKey();
		IPSLib::updateSettings( array( 'ipb_reg_number' => $key ) );
		$this->settings['ipb_reg_number'] = $key;
		$this->recache();
		
		$this->registry->output->silentRedirect( $this->settings['base_url'] . $this->form_code );		
	}
	
	/**
	 * Overview
	 */
	protected function overview()
	{
		$this->registry->output->html .= $this->html->licenseKeyStatusScreen( $this->settings['ipb_reg_number'], $this->cache->getCache( 'licenseData' ) );
	}
	
	/**
	 * Recache License Data
	 */
	public function recache()
	{
		/* Save */
		$licenseData = darkLAE::getLicenseData();
		$licenseData['_cached_date']	= time();
		$licenseData['key']['_expires']	= $licenseData['key']['_expires'] ? $licenseData['key']['_expires'] : 9999999999;
		$licenseData['key']['expires']	= $licenseData['key']['expires'] ? $licenseData['key']['expires'] : 9999999999;
		$this->cache->setCache( 'licenseData', $licenseData, array( 'array' => 1 ) );
	}
}