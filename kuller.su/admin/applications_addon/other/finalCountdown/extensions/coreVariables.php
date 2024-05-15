<?php

/**
 * @author -RAW-
 * @copyright 2012
 * @link http://rawcodes.net
 * @filesource It's the Final Countdown
 * @version 1.2.0
 */

$_RESET = array();

$_LOAD = array(
	'countdowns'         => 1,
);



$CACHE['countdowns'] = array( 
								'array'            => 1,
								'allow_unload'     => 0,
							    'default_load'     => 1,
							    'recache_file'     => IPSLib::getAppDir( 'finalCountdown' ) . '/modules_admin/core/core.php',
								'recache_class'    => 'admin_finalCountdown_core_core',
							    'recache_function' => 'rebuildCountdownCache' 
							);

