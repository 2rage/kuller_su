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
 Файл: quote.php
-----------------------------------------------------
 Назначение: цитирование комментариев
=====================================================
*/

@error_reporting ( E_ALL ^ E_WARNING ^ E_NOTICE );
@ini_set ( 'display_errors', true );
@ini_set ( 'html_errors', false );
@ini_set ( 'error_reporting', E_ALL ^ E_WARNING ^ E_NOTICE );

define( 'DATALIFEENGINE', true );
define( 'ROOT_DIR', substr( dirname(  __FILE__ ), 0, -12 ) );
define( 'ENGINE_DIR', ROOT_DIR . '/engine' );

include ENGINE_DIR . '/data/config.php';
require_once ENGINE_DIR . '/classes/mysql.php';
require_once ENGINE_DIR . '/data/dbconfig.php';
require_once ENGINE_DIR . '/modules/functions.php';
require_once ENGINE_DIR . '/classes/parse.class.php';

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

$is_logged = false;
$member_id = array ();

if ($config['allow_registration'] == "yes") {
	require_once ENGINE_DIR . '/modules/sitelogin.php';
}

if( ! $is_logged ) {
	$member_id['user_group'] = 5;
}

if ($is_logged AND $member_id['banned'] == "yes") die("error");

$id = intval( $_GET['id'] );

if(!$id) die( "error" );

$parse = new ParseFilter( );
$parse->safe_mode = true;

$row = $db->super_query( "SELECT autor, text FROM " . PREFIX . "_comments WHERE id = '{$id}'" );

if (!$row['text']) die( "error" );

if( !$config['allow_comments_wysiwyg'] ) {
	$text = $parse->decodeBBCodes( $row['text'], false );
} else {
	$text = $parse->decodeBBCodes( $row['text'], TRUE, $config['allow_comments_wysiwyg'] );
	$text = preg_replace('/<p[^>]*>/', '', $text); 
	$text = str_replace("</p>", "<br />", $text);	
	$text = preg_replace('/<div[^>]*>/', '', $text); 
	$text = str_replace("</div>", "<br />", $text);
	$text = str_replace( "\r", "", $text );
	$text = str_replace( "\n", "", $text );
	$text = trim($text, " <br />");

}

if( !$user_group[$member_id['user_group']]['allow_hide'] ) $text = preg_replace ( "#\[hide\](.+?)\[/hide\]#ims", "", $text );

@header( "Content-type: text/html; charset=" . $config['charset'] );
echo "[quote={$row['autor']}]{$text}[/quote]";
?>