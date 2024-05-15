<?php

/*
=====================================================
 Автор: Бирюков Роман a.k.a Inrus
-----------------------------------------------------
 http://webfound.ru/
-----------------------------------------------------
 Copyright (c) 2010 WF
=====================================================
 Файл: dt_online.php
-----------------------------------------------------
 Назначение: Формирование блока пользователей онлайн
=====================================================
*/




if( ! defined( 'DATALIFEENGINE' ) ) {
	die( "Hacking attempt!" );
}

session_start();
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Настройки
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$show_hint = false;    # true - Показывать хинт # false - Не показывать
$show_guests = true;  # true - Гости вкл. # false - Гости выкл.
$timer = 10;		  # Интервал поиска юзеров в минутах
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Стили групп
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
$group_style[1] = 'style="color: #063; font-weight: bold;"';
$group_style[2] = 'style="color: #000;"';
$group_style[3] = 'style="color: #000;"';
$group_style[4] = '';
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#                     DT Online v.1.2
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
define("DTIME1", time() + ($config['date_adjust']*60) - ($timer*60) );
define("DTIME2", time() + ($config['date_adjust']*60) + ($timer*60));

function count_all_online() {

    if ( $directory_handle = opendir( session_save_path() ) ) {

		$count = 0;

		while ( false !== ( $file = readdir( $directory_handle ) ) ) {

			if( $file != '.' && $file != '..' AND ( time() - filemtime( session_save_path() . '/' . $file)) < (60)  )  $count++;

		}

		closedir($directory_handle);

		return $count;
	} else return false;

}


$fuser_status = '';
$fuser_status = ((time() + ($config['date_adjust']*60)) < ($member_id['lastdate'] + ($timer*60))) ? $request_online = false : $request_online=true;

if( $show_hint ) $additional = ',news_num, comm_num, foto';
else $additional = '';

if ( $is_logged AND $request_online ) $db->query("UPDATE " . USERPREFIX . "_users SET lastdate = '".time()."' WHERE user_id = '$member_id[user_id]'");

$db->query("SELECT user_id, name, lastdate, user_group $additional FROM " . PREFIX . "_users WHERE lastdate > ".DTIME1." AND lastdate < ".DTIME2." ORDER BY user_id ASC");
$users_num = 0;
if( $db->num_rows() > 0 ) {

    if( $show_hint ) {

	    $tpl->load_template('dt_online_hint.tpl');
	    $tpl->compile('hint');
	    $tpl->clear();
	    $tooltable = $tpl->result['hint'];
    }

    $tpl->load_template('dt_online_user.tpl');
	while( $row = $db->get_row() ){

		if( $config['allow_alt_url'] == "yes" ) {

			$go_page = $config['http_home_url'] . "user/" . urlencode( $row['name'] ) . "/";

		} else {

			$go_page = "$PHP_SELF?subaction=userinfo&user=" . urlencode( $row['name'] );
		}
        if( $show_hint ) {
	        if( $row['foto'] and (file_exists( ROOT_DIR . "/uploads/fotos/" . $row['foto'] )) ) $foto = $config['http_home_url'] . "uploads/fotos/" . $row['foto'];
			else $foto = "{THEME}/images/noavatar.png";

			$tooltip =  str_replace('{foto}', $foto, $tooltable );
	        $tooltip =  str_replace('{news-num}', intval( $row['news_num'] ), $tooltip );
	        $tooltip =  str_replace('{comm-num}', intval( $row['comm_num'] ), $tooltip );

	        $tooltip =  str_replace('{group-name}', $user_group[$row['user_group']]['group_prefix'].$user_group[$row['user_group']]['group_name'].$user_group[$row['user_group']]['group_suffix'], $tooltip );

	        $tooltip = htmlentities($tooltip , ENT_QUOTES, $config['charset']);
        } else $tooltip ='';

        if( $config['version_id'] > 8.5 ) $go_page = "onclick=\"ShowProfile('" . urlencode( $row['name'] ) . "', '" . htmlspecialchars( $go_page ) . "'); return false;\"";

		if( $config['allow_alt_url'] == "yes" ) $tpl->set( '{user}', "<a title=\"{$tooltip}\" {$group_style[$row['user_group']]} {$go_page} href=\"" . $config['http_home_url'] . "user/" . urlencode( $row['name'] ) . "/\">" . $row['name'] . "</a>" );
		else $tpl->set( '{user}', "<a title=\"{$tooltip}\" {$group_style[$row['user_group']]} {$go_page} href=\"$PHP_SELF?subaction=userinfo&amp;user=" . urlencode( $row['name'] ) . "\">" . $row['name'] . "</a>" );

		$tpl->set( '{user-nolink}', $row['name'] );
		$tpl->set( '[/profile]', "</a>" );

        if( $users_num == $db->num_rows()-1 ) $tpl->set_block( "'\\[delimeter\\](.*?)\\[/delimeter\\]'si", "" );
        else $tpl->set_block( "'\\[delimeter\\](.*?)\\[/delimeter\\]'si", "\\1" );


		$users_num++;
		$tpl->compile('users');
	}
	$tpl->clear();
	$no_reg = false;

} else {

	$no_reg = true;
}
$db->free();

if( $show_guests ) $count_all = count_all_online();
else $count_all = $users_num;

$all_online = $count_all == 0 ? 1 : $count_all;
$all_online = ( $count_all < $users_num OR $count_all < 0 ) ? $count_all + $users_num : $count_all;

$tpl->load_template('dt_online.tpl');

if( $show_guests ) { $tpl->set( '{total_users}', $all_online ); } else $tpl->set( '{total_users}', '' );
$tpl->set( '{users_num}', $users_num );

if( $show_guests ) {
	if($users_num != 0) $tpl->set( '{guests_num}', $all_online - $users_num );
	else $tpl->set( '{guests_num}', $all_online );
} else $tpl->set( '{guests_num}', '' );
$tpl->set( '{register}', $tpl->result['users'] );

if( $no_reg ) $tpl->set_block( "'\\[register\\](.*?)\\[/register\\]'si", "" );
else $tpl->set_block( "'\\[register\\](.*?)\\[/register\\]'si", "\\1" );

$tpl->compile( 'online_block' );
$tpl->clear();


echo $tpl->result['online_block'];

?>