<?php

//-----------------------------------------------
// (DP32) Forum Icons
//-----------------------------------------------
//-----------------------------------------------
// Core Variables
//-----------------------------------------------
// Author: DawPi
// Site: http://www.ipslink.pl
// Written on: 02 / 08 / 2011
//-----------------------------------------------
// Copyright (C) 2011 DawPi
// All Rights Reserved
//----------------------------------------------- 

$_LOAD = array();

$_LOAD['fi_icons']	= 1;
		   
$CACHE['fi_icons'] 	= array( 
									'array'				=> 1,
								   	'allow_unload'		=> 0,
								   	'default_load'		=> 1,
								   	'recache_file'		=> IPSLib::getAppDir( 'forumicons' ) . '/sources/classes/library.php',
								   	'recache_class'		=> 'fiLibrary',
								   	'recache_function'	=> 'updateCache'
								);		
								
/**
* Array for holding reset information
*
* Populate the $_RESET array and ipsRegistry will do the rest
*/

$_RESET = array();																				   						   