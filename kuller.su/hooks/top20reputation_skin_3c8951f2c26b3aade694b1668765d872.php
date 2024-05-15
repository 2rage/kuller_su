<?php

/**
 * Product Title:		(SOS32) TOP 20 Reputation Points
 * Product Version:		3.0.0
 * Author:				Adriano Faria
 * Website:				SOS Invision
 * Website URL:			http://forum.sosinvision.com.br/
 * Email:				administracao@sosinvision.com.br
 */

class top20reputation_skin
{
	public function __construct()
	{
		$this->registry   =  ipsregistry::instance();
		$this->memberData =& $this->registry->member()->fetchMemberData();
		$this->lang		=  $this->registry->getClass('class_localization');
	}
	
	public function getOutput()
	{
		$this->registry->class_localization->loadLanguageFile( array( 'public_boards' ), 'forums' );
		
		$url  = $this->registry->getClass( 'output' )->buildUrl( "app=forums&module=extras&section=stats&do=reputation", 'public' );
                                
		$link = "<li><a href='{$url}' title='".$this->lang->words['top20rep']."'>{$this->lang->words['top20rep']}</a></li>";

		return $this->registry->getClass( 'output' )->getTemplate( 'boards' )->top_reputation_link( $link );
	}
}