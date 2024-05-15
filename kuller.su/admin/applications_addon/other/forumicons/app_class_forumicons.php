<?php

//-----------------------------------------------
// (DP32) Forum Icons
//-----------------------------------------------
//-----------------------------------------------
// Loader
//-----------------------------------------------
// Author: DawPi
// Site: http://www.ipslink.pl
// Written on: 02 / 08 / 2011
//-----------------------------------------------
// Copyright (C) 2011 DawPi
// All Rights Reserved
//-----------------------------------------------   

class app_class_forumicons
{
	public function __construct( ipsRegistry $registry )
	{
		/* Load library */
		
		$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( 'forumicons' ) . '/sources/classes/library.php', 'fiLibrary', 'forumicons' );
		$registry->setClass( 'fiLibrary', new $classToLoad( $registry ) );			
		
		if ( IN_ACP )
		{			
			$registry->getClass('class_localization')->loadLanguageFile( array( 'admin_forumicons' ),  'forumicons' );
		}
	}		
}// End of class