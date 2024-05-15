<?php
/*
=====================================================
 DataLife Engine - by SoftNews Media Group 
-----------------------------------------------------
 http://dle-news.ru/
-----------------------------------------------------
 Copyright (c) 2004,2013 SoftNews Media Group
=====================================================
 Данный код защищен авторскими правами
=====================================================
 Файл: adminfunction.php
-----------------------------------------------------
 Назначение: Выполнение различных функций админпанели
=====================================================
*/

@error_reporting ( E_ALL ^ E_WARNING ^ E_NOTICE );
@ini_set ( 'display_errors', true );
@ini_set ( 'html_errors', false );
@ini_set ( 'error_reporting', E_ALL ^ E_WARNING ^ E_NOTICE );

define('DATALIFEENGINE', true);
define( 'ROOT_DIR', substr( dirname(  __FILE__ ), 0, -12 ) );
define( 'ENGINE_DIR', ROOT_DIR . '/engine' );

include ENGINE_DIR.'/data/config.php';

if ($config['http_home_url'] == "") {

	$config['http_home_url'] = explode("engine/ajax/adminfunction.php", $_SERVER['PHP_SELF']);
	$config['http_home_url'] = reset($config['http_home_url']);
	$config['http_home_url'] = "http://".$_SERVER['HTTP_HOST'].$config['http_home_url'];

}

require_once ENGINE_DIR.'/classes/mysql.php';
require_once ENGINE_DIR.'/data/dbconfig.php';
require_once ENGINE_DIR.'/inc/include/functions.inc.php';

dle_session();
$_TIME = time () + ($config['date_adjust'] * 60);

//################# Определение групп пользователей
$user_group = get_vars( "usergroup" );

if( ! $user_group ) {
	$user_group = array ();
	
	$db->query( "SELECT * FROM " . USERPREFIX . "_usergroups ORDER BY id ASC" );
	
	while ( $row = $db->get_row() ) {
		
		$user_group[$row['id']] = array ();
		
		foreach ( $row as $key => $value ) {
			$user_group[$row['id']][$key] = stripslashes($value);
		}
	
	}
	set_vars( "usergroup", $user_group );
	$db->free();
}

require_once ENGINE_DIR.'/modules/sitelogin.php';

if( !$is_logged OR !$user_group[$member_id['user_group']]['allow_admin'] ) { die ("error"); }

$selected_language = $config['langs'];

if (isset( $_COOKIE['selected_language'] )) { 

	$_COOKIE['selected_language'] = trim(totranslit( $_COOKIE['selected_language'], false, false ));

	if ($_COOKIE['selected_language'] != "" AND @is_dir ( ROOT_DIR . '/language/' . $_COOKIE['selected_language'] )) {
		$selected_language = $_COOKIE['selected_language'];
	}

}

if ( file_exists( ROOT_DIR.'/language/'.$selected_language.'/adminpanel.lng' ) ) {
	require_once ROOT_DIR.'/language/'.$selected_language.'/adminpanel.lng';
} else die("Language file not found");

$config['charset'] = ($lang['charset'] != '') ? $lang['charset'] : $config['charset'];
$buffer = "";

@header("Content-type: text/html; charset=".$config['charset']);

if ($_REQUEST['action'] == "newsspam") {

	if ( !$user_group[$member_id['user_group']]['allow_all_edit']) die ("error");

	if( $_REQUEST['user_hash'] == "" or $_REQUEST['user_hash'] != $dle_login_hash ) {
		
		die ("error");
	
	}

	$id = intval( $_REQUEST['id'] );
	
	if( $id < 1 ) die( "error" );

	$row = $db->super_query( "SELECT id, autor, approve FROM " . PREFIX . "_post WHERE id = '{$id}'" );

	if ($row['id'])	{

		$author = $db->safesql($row['autor']);

		if( $row['approve'] ) die ("error");

		$row = $db->super_query( "SELECT user_id, user_group FROM " . USERPREFIX . "_users WHERE name = '{$author}'" );

		$user_id = intval($row['user_id']);

		if ($user_group[$row['user_group']]['allow_admin']) die ($lang['mark_spam_error']);

		$db->query( "INSERT INTO " . USERPREFIX . "_admin_logs (name, date, ip, action, extras) values ('".$db->safesql($member_id['name'])."', '{$_TIME}', '{$_IP}', '87', '{$author}')" );

		$result = $db->query( "SELECT id FROM " . PREFIX . "_post WHERE autor='{$author}' AND approve='0'" );
			
		while ( $row = $db->get_array( $result ) ) {
			$id = intval( $row['id'] );
			$db->query( "UPDATE " . USERPREFIX . "_users SET news_num=news_num-1 WHERE user_id='{$user_id}'" );

			$db->query( "DELETE FROM " . PREFIX . "_post WHERE id='{$id}'" );
			$db->query( "DELETE FROM " . PREFIX . "_post_extras WHERE news_id='{$id}'" );
			$db->query( "DELETE FROM " . PREFIX . "_comments WHERE post_id='{$id}'" );
			$db->query( "DELETE FROM " . PREFIX . "_poll WHERE news_id = '{$id}'" );
			$db->query( "DELETE FROM " . PREFIX . "_poll_log WHERE news_id = '{$id}'" );
			$db->query( "DELETE FROM " . PREFIX . "_post_log WHERE news_id = '{$id}'" );
			$db->query( "DELETE FROM " . PREFIX . "_logs WHERE news_id = '{$id}'" );
			$db->query( "DELETE FROM " . PREFIX . "_tags WHERE news_id = '{$id}'" );

			$db->query( "SELECT onserver FROM " . PREFIX . "_files WHERE news_id = '{$id}'" );

			while ( $row = $db->get_row() ) {
				$url = explode( "/", $row['onserver'] );

				if( count( $url ) == 2 ) {
						
					$folder_prefix = $url[0] . "/";
					$file = $url[1];
					
				} else {
						
					$folder_prefix = "";
					$file = $url[0];
					
				}
				$file = totranslit( $file, false );
	
				if( trim($file) == ".htaccess") die("Hacking attempt!");

				@unlink( ROOT_DIR . "/uploads/files/" . $folder_prefix . $file );
			}

			$db->query( "DELETE FROM " . PREFIX . "_files WHERE news_id = '{$id}'" );

			$row = $db->super_query( "SELECT images  FROM " . PREFIX . "_images where news_id = '{$id}'" );
			
			$listimages = explode( "|||", $row['images'] );
			
			if( $row['images'] != "" ) foreach ( $listimages as $dataimages ) {
				$url_image = explode( "/", $dataimages );
				
				if( count( $url_image ) == 2 ) {
					
					$folder_prefix = $url_image[0] . "/";
					$dataimages = $url_image[1];
				
				} else {
					
					$folder_prefix = "";
					$dataimages = $url_image[0];
				
				}
				
				@unlink( ROOT_DIR . "/uploads/posts/" . $folder_prefix . $dataimages );
				@unlink( ROOT_DIR . "/uploads/posts/" . $folder_prefix . "thumbs/" . $dataimages );
			}
			
			$db->query( "DELETE FROM " . PREFIX . "_images WHERE news_id = '{$id}'" );
			
		}

		$db->free( $result );
		$db->query( "UPDATE " . USERPREFIX . "_users SET restricted='3', restricted_days='0' WHERE user_id ='{$user_id}'" );
		clear_cache();
		$buffer = $lang['mark_spam_ok_2'];

	} else die ("error");

}

if ($_REQUEST['action'] == "commentsspam") {

	if ( !$user_group[$member_id['user_group']]['del_allc']) die ("error");

	if( $_REQUEST['user_hash'] == "" or $_REQUEST['user_hash'] != $dle_login_hash ) {
		
		die ("error");
	
	}

	$id = intval( $_REQUEST['id'] );
	
	if( $id < 1 ) die( "error" );

	$row = $db->super_query( "SELECT id, user_id, autor, ip, is_register FROM " . PREFIX . "_comments WHERE id = '{$id}'" );

	if ($row['id'])	{

		$user_id = intval($row['user_id']);
		$author = $db->safesql($row['autor']);
		$is_register = $row['is_register'];
		$ip = $db->safesql($row['ip']);

		if ( $is_register ) {

			$row = $db->super_query( "SELECT user_group FROM " . USERPREFIX . "_users WHERE user_id = '{$user_id}'" );

			if ($user_group[$row['user_group']]['allow_admin']) die ($lang['mark_spam_error']);

			$db->query( "INSERT INTO " . USERPREFIX . "_admin_logs (name, date, ip, action, extras) values ('".$db->safesql($member_id['name'])."', '{$_TIME}', '{$_IP}', '87', '{$author}')" );

			$result = $db->query( "SELECT COUNT(*) as count, post_id FROM " . PREFIX . "_comments WHERE user_id='{$user_id}' AND is_register='1' AND approve='1' GROUP BY post_id" );
			
			while ( $row = $db->get_array( $result ) ) {
				
				$db->query( "UPDATE " . PREFIX . "_post SET comm_num=comm_num-{$row['count']} WHERE id='{$row['post_id']}'" );
			
			}
			$db->free( $result );

			$db->query( "UPDATE " . USERPREFIX . "_users SET comm_num='0', restricted='3', restricted_days='0' WHERE user_id ='{$user_id}'" );
			$db->query( "DELETE FROM " . PREFIX . "_comments WHERE user_id='{$user_id}' AND is_register='1'" );

		} else {

			$db->query( "INSERT INTO " . USERPREFIX . "_admin_logs (name, date, ip, action, extras) values ('".$db->safesql($member_id['name'])."', '{$_TIME}', '{$_IP}', '88', '{$author}')" );

			$result = $db->query( "SELECT COUNT(*) as count, post_id FROM " . PREFIX . "_comments WHERE ip='{$ip}' AND is_register='0' AND approve='1' GROUP BY post_id" );
			
			while ( $row = $db->get_array( $result ) ) {
				
				$db->query( "UPDATE " . PREFIX . "_post SET comm_num=comm_num-{$row['count']} WHERE id='{$row['post_id']}'" );
			
			}
			$db->free( $result );

			$db->query( "DELETE FROM " . PREFIX . "_comments WHERE ip='{$ip}' AND is_register='0'" );
			$db->query( "INSERT INTO " . USERPREFIX . "_banned (descr, date, days, ip) values ('{$lang['mark_spam_ok_1']}', '0', '0', '{$ip}')" );
			@unlink( ENGINE_DIR . '/cache/system/banned.php' );

		}

		clear_cache();
		$buffer = $lang['mark_spam_ok'];		

	} else die ("error");
}

if ($_REQUEST['action'] == "clearcache") {

	if ( $member_id['user_group'] != 1 ) die ("error");

	$fdir = opendir( ENGINE_DIR . '/cache/system/' );
	while ( $file = readdir( $fdir ) ) {
		if( $file != '.' and $file != '..' and $file != '.htaccess' and $file != 'cron.php' ) {
			@unlink( ENGINE_DIR . '/cache/system/' . $file );
		
		}
	}
	
	clear_cache();

	$buffer = "<font color=\"green\">".$lang['clear_cache']."</font>";

}


if ($_REQUEST['action'] == "clearsubscribe") {

	if ( $member_id['user_group'] != 1 ) die ("error");

	$db->query("TRUNCATE TABLE " . PREFIX . "_subscribe");

	$buffer = "<font color=\"green\">".$lang['clear_subscribe']."</font>";

}

if ($_REQUEST['action'] == "sendnotice") {

	$row = $db->super_query( "SELECT id FROM " . PREFIX . "_notice WHERE user_id = '{$member_id['user_id']}'" );
	
	$notice = $db->safesql( convert_unicode($_POST['notice'], $config['charset']) );
	
	if( $row['id'] ) {
		
		$db->query( "UPDATE " . PREFIX . "_notice SET notice='{$notice}' WHERE user_id = '{$member_id['user_id']}'" );
	
	} else {
		
		$db->query( "INSERT INTO " . PREFIX . "_notice (user_id, notice) values ('{$member_id['user_id']}', '$notice')" );
	
	}

	$buffer = "<font color=\"green\">".$lang['saved']."</font>";

}

if ($_REQUEST['action'] == "deletemodules") {

	if ( $member_id['user_group'] != 1 ) die ("error");

	$id = intval($_REQUEST['id']);

	if ( $id ) {
		$db->query( "DELETE FROM " . PREFIX . "_admin_sections WHERE id = '{$id}'" );
	
		$buffer = 'ok';
	}

}

if ($_REQUEST['action'] == "catsort") {

	if( !$user_group[$member_id['user_group']]['admin_categories'] ) die ("error");

	if ( !count($_POST['list']) ) die ("error");

	$i= 0;

	foreach ( $_POST['list'] as $id => $parentid ) {
		$i++;

		$id = intval($id);
		$parentid = intval($parentid);

		if ( $id ) {

			$db->query( "UPDATE " . PREFIX . "_category SET parentid='{$parentid}', posi='{$i}' WHERE id = '{$id}'" );

		}
	}

	@unlink( ENGINE_DIR . '/cache/system/category.php' );
	$db->query( "INSERT INTO " . USERPREFIX . "_admin_logs (name, date, ip, action, extras) values ('".$db->safesql($member_id['name'])."', '{$_TIME}', '{$_IP}', '11', '')" );

	$buffer = 'ok';

}

echo $buffer;

?>