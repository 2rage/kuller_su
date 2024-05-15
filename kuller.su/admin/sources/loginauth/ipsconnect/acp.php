<?php
/**
 * @file		acp.php		IPS Connect - ACP Settings
 *
 * $Copyright: $
 * $License: $
 * $Author: mark $
 * $LastChangedDate: 2011-04-06 04:34:47 -0400 (Wed, 06 Apr 2011) $
 * $Revision: 8267 $
 * @since 		18th July 2012
 */

$config = array(
	array(
		'key'			=> 'master_url',
		'title'			=> 'Master URL',
		'description'	=> "Введите URL к файлу ipsconnect.php ведущего сервера.<br />Если ведущий сервер IPS Community Suite, то эту информацию можно найти на странице управления модулями авторизации."
		),
	array(
		'key'			=> 'master_key',
		'title'			=> 'Master-ключ,
		'description'	=> "Если ведущий сервер - IPS Community Suite, то эту информацию можно найти на странице управления модулями авторизации."
		)
	);