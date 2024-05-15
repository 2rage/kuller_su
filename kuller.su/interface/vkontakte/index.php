<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.2.0 Beta 1
 * Main public executable wrapper.
 * Set-up and load module to run
 * Last Updated: $Date: 2011-03-11 12:41:48 -0500 (Fri, 11 Mar 2011) $
 * </pre>
 *
 * @author 		$Author: ips_terabyte $
 * @copyright	(c) 2001 - 2008 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/community/board/license.html
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @version		$Rev: 8042 $
 *
 */

define( 'IPS_ENFORCE_ACCESS', TRUE );
define( 'IPB_THIS_SCRIPT', 'public' );
require_once( '../../initdata.php' );/*noLibHook*/

require_once( IPS_ROOT_PATH . 'sources/base/ipsRegistry.php' );/*noLibHook*/
require_once( IPS_ROOT_PATH . 'sources/base/ipsController.php' );/*noLibHook*/

$registry = ipsRegistry::instance();
$registry->init();

$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/classes/vkontakte/connect.php', 'vkontakte_connect' );
$vkontakte = new $classToLoad( $registry );

if ( $_REQUEST['code'] )
{
	/* From the log in page */
	if ( $_REQUEST['key'] )
	{
		try
		{
			if ( ! intval( $_REQUEST['m'] ) )
			{
				$vkontakte->finishLogin();
			}
			else
			{
				$vkontakte->finishConnection();
			}
		}
		catch( Exception $error )
		{
			$msg = $error->getMessage();
		
			switch( $msg )
			{
				default:
					$registry->getClass('output')->showError( 'vk_ohnoes', 1090194, 1, $msg, 403 );
				break;
				case 'VK_NOT_SET_UP':
					$registry->getClass('output')->showError( 'vk_not_on', 1090195, null, null, 403 );
				case 'NOT_REMOTE_MEMBER':
					$registry->getClass('output')->showError( 'vk_not_remote', 1090196, null, null, 403 );
				break;
			}
		}
	}
	else
	{
		$vkontakte->finishConnection();
	}
}
else
{
	$vkontakte->redirectToConnectPage();
}

exit();