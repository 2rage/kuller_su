<?php

/**
 * @author -RAW-
 * @copyright 2012
 * @link http://rawcodes.net
 * @filesource It's the Final Countdown
 * @version 1.2.0
 */

class admin_finalCountdown_test_test extends ipsCommand
{
	/**
	 * Main executable
	 * 
	 * @see ipsCommand::doExecute()
	 */
	public function doExecute( ipsRegistry $registry )
	{
		$this->html         		= $this->registry->output->loadTemplate( 'cp_skin_finalCountdown' );
		
		$this->form_code 	= $this->html->form_code    	= '&amp;module=test';
		$this->form_code_js = $this->html->form_code_js 	= '&module=test';
		
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'admin_core' ) );
		
		$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( 'finalCountdown' ) . "/sources/library.php", 'finalCountdown_library' );
		$this->library = new $classToLoad( $this->registry );

		$this->testCountdowns();
		
		$this->registry->output->html_main .= $this->registry->output->global_template->global_frame_wrapper();
		$this->registry->output->sendOutput();			
	}

	/**
	* Test all the current countdowns
	* 
	* @access	protected
	* @return	void
	*/
	protected function testCountdowns()
	{
		if ( ! is_array( $this->caches['countdowns'] ) )
		{
			$this->cache->rebuildCache( 'countdowns', 'finalCountdown' );
		}
		
		if ( count( $this->caches['countdowns'] ) > 0 )
		{
			IPSText::getTextClass( 'bbcode' )->parse_html		= 1;
			IPSText::getTextClass( 'bbcode' )->parse_smilies	= 1;
			IPSText::getTextClass( 'bbcode' )->parse_bbcode		= 1;

			foreach ( $this->caches['countdowns'] as $row )
			{
				$rows[] = $this->library->parseCountdown( $row );		

			}
		}
		
		$this->registry->output->html .= $this->html->testCountdown( $rows );
	}
}