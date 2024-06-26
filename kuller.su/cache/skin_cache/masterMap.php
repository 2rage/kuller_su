<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * IN_DEV Remapping.
 * Last Updated: $Date: 2012-11-06 13:46:51 -0500 (Tue, 06 Nov 2012) $
 * </pre>
 *
 * @author 		$Author: AndyMillne $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @since		3.0
 * @version		$Revision: 11564 $
 *
 */
 
/**
* This file is used to map skin IDs to a "master skin" directory for offline editing
* It is only used when IN_DEV is on.
* You are responsible for creating any directory and setting appropriate permission for IP.Board to write into it
* You can then import/export the skin in master format from the ACP -> Look & Feel (Menu button on appropriate skin row that will show when you have added it to the $REMAP array below
*/

/*
	To be able to edit a skin outside of the ACP, do this.

	1) Create a new skin set within the ACP. It can be a 'root' skin or a 'child'. It doesn't matter. Make sure you enter a 'skin_key' which must be unique.
	2) Put your board in IN_DEV mode by editing the constant in conf_global.php
	3) Create a new master skin directory in /cache/skin_cache. It must be something unique like 'mytest', like 'master_skin_mytest' for example.
	4) Add your new 'skin_key' to the 'templates' array below.
	5) Back into your ACP, go to the list of skin sets. Click on the menu icon for your new skin set and choose: 'EXPORT Templates into 'master' directory...'.

	You should now be able to edit those files as you browse the board without the ACP. When you are done, simply choose 'IMPORT Templates..'.
*/

$isApple   = (boolean) preg_match( '#(iPad|iPhone)#i', $_SERVER['HTTP_USER_AGENT'] );
$isAndroid = (boolean) preg_match( '#\sandroid\s+?([A-Za-z0-9.]{1,10})#i', $_SERVER['HTTP_USER_AGENT'] );

$REMAP = array(
	# This is the skin IPB uses when IN_DEV is switched on. Change the ID to
	# your own skin if desired.
	'inDevDefault' => ( $isApple || $isAndroid ) ? 'mobile' : 'root',
	
	# Master skins - please do not modify
	'masterKeys'  => array( 'root', 'xmlskin', 'mobile' ),
	
	# This defines which skins are exported for the installer
	'export'       => array(  0 => 'root',
							  2 => 'xmlskin',
							  1 => 'mobile' ),
	
	# Templates array. setID OR setKey => styleDir. styleDir must be created in 'cache/skin_cache' first
	'templates'    => array(
							 'root'     => 'master_skin',
							 'xmlskin'  => 'master_skin_xml',
							 'mobile'   => 'master_skin_mobile',
						   ),
						
	# CSS. setID OR setKey => cssDir. cssDir must be created in 'public/style_css' first
	'css'		   => array(
							'root'    => 'master_css',
							'xmlskin' => 'master_css_xml',
							'mobile'  => 'master_css_mobile',
							),
							
	# Images						
	'images'		=> array( 'root'    => 'master',
							  'xmlskin' => 'master',
							  'mobile'  => 'mobile' )
);