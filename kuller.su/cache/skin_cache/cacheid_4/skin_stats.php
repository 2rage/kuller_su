<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 4               */
/* CACHE FILE: Generated: Fri, 24 May 2013 01:43:18 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_stats_4 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['group_strip'] = array('forums','forums','moreThanOne','noVisibleForums','specificForums','isonline','isFriend','isFriendable','canPm','members','hasPaginationTop','hasLeaders','hasPaginationBottom');
$this->_funcHooks['top_posters'] = array('tpIsFriend','tpIsFrindable','tpPm','tpBlog','tpGallery','topposters','hasTopPosters');
$this->_funcHooks['top_reputation'] = array('topPosterMid','tpIsFriend','tpIsFrindable','tpPm','tpBlog','tpGallery','topreputation','hasTopPosters');
$this->_funcHooks['whoPosted'] = array('whoposted','hasPosters');


}

/* -- group_strip --*/
function group_strip($group="", $members=array(), $pagination='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_stats', $this->_funcHooks['group_strip'] ) )
{
$count_d716df7e063830666d549bec0830d273 = is_array($this->functionData['group_strip']) ? count($this->functionData['group_strip']) : 0;
$this->functionData['group_strip'][$count_d716df7e063830666d549bec0830d273]['group'] = $group;
$this->functionData['group_strip'][$count_d716df7e063830666d549bec0830d273]['members'] = $members;
$this->functionData['group_strip'][$count_d716df7e063830666d549bec0830d273]['pagination'] = $pagination;
}

if ( ! isset( $this->registry->templateStriping['staff'] ) ) {
$this->registry->templateStriping['staff'] = array( FALSE, "row1","row2");
}
$IPBHTML .= "" . (($pagination) ? ("
	<div class='topic_controls'>{$pagination}</div>
") : ("")) . "
" . $this->registry->getClass('output')->getReplacement("header_start") . "<h3 class='maintitle'>{$group}</h3>" . $this->registry->getClass('output')->getReplacement("header_end") . "
<table class='ipb_table ipsMemberList'>
	<tr class='header'>
		<th scope='col' style='width: 3%'>&nbsp;</th>
		<th scope='col' style='width: 20%'>{$this->lang->words['leader_name']}</th>
		<th scope='col' style='width: 15%'>{$this->lang->words['leader_group']}</th>
		<th scope='col' style='width: 25%' class='short'>{$this->lang->words['leader_forums']}</th>
		<th scope='col' style='width: 25%'>{$this->lang->words['leader_last_seen']}</th>
		<th scope='col' style='width: 12%'>&nbsp;</th>
	</tr>
	" . ((count($members) AND is_array($members)) ? ("
				".$this->__f__82e51c2259db5184c0c617b0ca9dd651($group,$members,$pagination)."	") : ("")) . "
</table>" . $this->registry->getClass('output')->getReplacement("box_end") . "
" . (($pagination) ? ("
	<div class='topic_controls'>{$pagination}</div>
") : ("")) . "
<br class='clear' />";
return $IPBHTML;
}


function __f__66a50a101352c8c7ee311e6d343f15cc($group="", $members=array(), $pagination='',$info='')
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $info['forums'] as $id => $name )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
									<a href=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "showforum={$id}", "public",'' ), "{$this->registry->class_forums->forum_by_id[ $id ]['name_seo']}", "showforum" ) . "\">{$name}</a>
								
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__c71dc02c4432e6b1107ee4f2cf685d3d($group="", $members=array(), $pagination='',$info='')
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $info['forums'] as $id => $name )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
									<li><a href=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "showforum={$id}", "public",'' ), "{$this->registry->class_forums->forum_by_id[ $id ]['name_seo']}", "showforum" ) . "\">{$name}</a></li>
								
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__82e51c2259db5184c0c617b0ca9dd651($group="", $members=array(), $pagination='')
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $members as $info )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
			<tr class='" .  IPSLib::next( $this->registry->templateStriping["staff"] ) . "'>
				<td>" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'userSmallPhoto' ) ? $this->registry->getClass('output')->getTemplate('global')->userSmallPhoto($info) : '' ) . "</td>
				<td>" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'userHoverCard' ) ? $this->registry->getClass('output')->getTemplate('global')->userHoverCard($info) : '' ) . "</td>
				<td>{$info['_group_formatted']}</td>
				<td class='altrow short'>
					" . ((is_array($info['forums'])) ? ("" . ((empty( $info['forums'] )) ? ("
							--
						") : ("" . ((count( $info['forums'] ) == 1) ? ("
								".$this->__f__66a50a101352c8c7ee311e6d343f15cc($group,$members,$pagination,$info)."							") : ("
								<a href='#' id='mod_page_{$info['member_id']}'>" . sprintf($this->lang->words['no_forums'],count($info['forums'])) . "</a>
								<ul class='ipbmenu_content' id='mod_page_{$info['member_id']}_menucontent'  style='display:none'>
								".$this->__f__c71dc02c4432e6b1107ee4f2cf685d3d($group,$members,$pagination,$info)."								</ul>
								<script type='text/javascript'>
									document.observe(\"dom:loaded\", function()
									{
										new ipb.Menu( $('mod_page_{$info['member_id']}'), $('mod_page_{$info['member_id']}_menucontent') );
									} );
								</script>
							")) . "")) . "") : ("
						{$info['forums']}
					")) . "
				</td>
				<td>
					<span class='ipsText_small desc'>{$info['_last_active']}</span>
					" . (($info['_online'] && ($info['online_extra'] != $this->lang->words['not_online'])) ? ("
						<span data-tooltip=\"{$info['online_extra']}\" class='ipsBadge ipsBadge_green'>{$this->lang->words['m_online']}</span>
					") : ("")) . "
				</td>
				<td class='short altrow'>
					<ul class='ipsList_inline right ipsList_nowrap'>
						" . (($this->memberData['member_id'] AND $this->memberData['member_id'] != $info['member_id'] && $this->settings['friends_enabled'] AND $this->memberData['g_can_add_friends']) ? ("" . ((IPSMember::checkFriendStatus( $info['member_id'] )) ? ("
								<li class='mini_friend_toggle is_friend' id='friend_xxx_{$info['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=profile&amp;section=friends&amp;do=remove&amp;member_id={$info['member_id']}&amp;secure_key={$this->member->form_hash}", "public",'' ), "", "" ) . "' title='{$this->lang->words['remove_friend']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("remove_friend") . "</a></li>
							") : ("
								<li class='mini_friend_toggle is_not_friend' id='friend_xxx_{$info['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=profile&amp;section=friends&amp;do=add&amp;member_id={$info['member_id']}&amp;secure_key={$this->member->form_hash}", "public",'' ), "", "" ) . "' title='{$this->lang->words['add_friend']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("add_friend") . "</a></li>
							")) . "") : ("")) . "
						" . (($this->memberData['g_use_pm'] AND $this->memberData['member_id'] != $info['member_id'] AND $this->memberData['members_disable_pm'] == 0 AND IPSLib::moduleIsEnabled( 'messaging', 'members' )) ? ("
							<li class='pm_button' id='pm_xxx_{$info['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=messaging&amp;section=send&amp;do=form&amp;fromMemberID={$info['member_id']}", "public",'' ), "", "" ) . "' title='{$this->lang->words['pm_member']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("send_msg") . "</a></li>
						") : ("")) . "
					</ul>
				</td>
			</tr>
		
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- top_posters --*/
function top_posters($rows) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_stats', $this->_funcHooks['top_posters'] ) )
{
$count_0bd960f884f2eb460846ac03520b85ca = is_array($this->functionData['top_posters']) ? count($this->functionData['top_posters']) : 0;
$this->functionData['top_posters'][$count_0bd960f884f2eb460846ac03520b85ca]['rows'] = $rows;
}

if ( ! isset( $this->registry->templateStriping['top_posters'] ) ) {
$this->registry->templateStriping['top_posters'] = array( FALSE, "row1","row2");
}
$IPBHTML .= "" . $this->registry->getClass('output')->getReplacement("header_start") . "<h2 class='maintitle'>{$this->lang->words['todays_posters']}</h2>" . $this->registry->getClass('output')->getReplacement("header_end") . "
<table class='ipb_table ipsMemberList'>
	<tr class='header'>
		<th scope='col' style='width: 3%'>&nbsp;</th>
		<th scope='col'>{$this->lang->words['member']}</th>
		<th scope='col'>{$this->lang->words['member_joined']}</th>
		<th scope='col' class='short'>{$this->lang->words['member_posts']}</th>
		<th scope='col' class='short'>{$this->lang->words['member_today']}</th>
		<th scope='col' class='short'>{$this->lang->words['member_percent']}</th>
		<th scope='col' class='short'>&nbsp;</th>
	</tr>
	" . ((!is_array($rows) OR !count($rows)) ? ("
		<tr>
			<td colspan='7' class='no_messages'>{$this->lang->words['no_info']}</td>
		</tr>
	") : ("
				".$this->__f__6b5e17fd01af9d88ae466677296d01cb($rows)."	")) . "
</table>
" . $this->registry->getClass('output')->getReplacement("box_end") . "";
return $IPBHTML;
}


function __f__6b5e17fd01af9d88ae466677296d01cb($rows)
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $rows as $info )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
			<tr class='" .  IPSLib::next( $this->registry->templateStriping["top_posters"] ) . "'>
				<td>" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'userSmallPhoto' ) ? $this->registry->getClass('output')->getTemplate('global')->userSmallPhoto(array_merge( $info, array( 'alt' => sprintf($this->lang->words['users_photo'], $info['members_display_name']) ) )) : '' ) . "</td>
				<td>" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'userHoverCard' ) ? $this->registry->getClass('output')->getTemplate('global')->userHoverCard($info) : '' ) . "</td>
				<td class='altrow'>
					" . $this->registry->getClass('class_localization')->getDate($info['joined'],"joined", 0) . "
				</td>
				<td class='short'>
					" . $this->registry->getClass('class_localization')->formatNumber( $info['posts'] ) . "
				</td>
				<td class='altrow short'>
					" . $this->registry->getClass('class_localization')->formatNumber( $info['tpost'] ) . "
				</td>
				<td class='short'>
					{$info['today_pct']}%
				</td>
				<td class='altrow short'>
					<ul class='ipsList_inline right'>
						" . (($this->memberData['member_id'] AND $this->memberData['member_id'] != $info['member_id'] && $this->settings['friends_enabled'] AND $this->memberData['g_can_add_friends']) ? ("" . ((IPSMember::checkFriendStatus( $info['member_id'] )) ? ("
								<li class='mini_friend_toggle is_friend' id='friend_xxx_{$info['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=profile&amp;section=friends&amp;do=remove&amp;member_id={$info['member_id']}&amp;secure_key={$this->member->form_hash}", "public",'' ), "", "" ) . "' title='{$this->lang->words['remove_friend']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("remove_friend") . "</a></li>
							") : ("
								<li class='mini_friend_toggle is_not_friend' id='friend_xxx_{$info['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=profile&amp;section=friends&amp;do=add&amp;member_id={$info['member_id']}&amp;secure_key={$this->member->form_hash}", "public",'' ), "", "" ) . "' title='{$this->lang->words['add_friend']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("add_friend") . "</a></li>
							")) . "") : ("")) . "
						" . (($this->memberData['g_use_pm'] AND $this->memberData['member_id'] != $info['member_id'] AND $this->memberData['members_disable_pm'] == 0 AND IPSLib::moduleIsEnabled( 'messaging', 'members' )) ? ("
							<li class='pm_button' id='pm_xxx_{$info['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=messaging&amp;section=send&amp;do=form&amp;fromMemberID={$info['member_id']}", "public",'' ), "", "" ) . "' title='{$this->lang->words['pm_member']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("send_msg") . "</a></li>
						") : ("")) . "
						" . (($info['has_blog'] AND IPSLib::appIsInstalled( 'blog' )) ? ("
							<li><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=blog&amp;module=display&amp;section=blog&amp;mid={$info['member_id']}", "public",'' ), "", "" ) . "' title='{$this->lang->words['view_blog']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("blog_link") . "</a></li>
						") : ("")) . "
						" . (($info['has_gallery'] AND IPSLib::appIsInstalled( 'gallery' )) ? ("
							<li><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=gallery&amp;user={$info['member_id']}", "public",'' ), "{$info['members_seo_name']}", "useralbum" ) . "' title='{$this->lang->words['view_gallery']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("gallery_link") . "</a></li>
						") : ("")) . "
					</ul>
				</td>
			</tr>
		
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- top_reputation --*/
function top_reputation($members) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_stats', $this->_funcHooks['top_reputation'] ) )
{
$count_175f8e989241328116aaaf1b2a88ade6 = is_array($this->functionData['top_reputation']) ? count($this->functionData['top_reputation']) : 0;
$this->functionData['top_reputation'][$count_175f8e989241328116aaaf1b2a88ade6]['members'] = $members;
}

if ( ! isset( $this->registry->templateStriping['top_posters'] ) ) {
$this->registry->templateStriping['top_posters'] = array( FALSE, "row1","row2");
}
$IPBHTML .= "<table class='ipb_table'>
	<caption class='maintitle'>{$this->lang->words['top20rep_title']}</caption>
	<tr class='header'>
		<th scope='col' style='width: 3%'>&nbsp;</th>
		<th scope='col'>{$this->lang->words['member']}</th>
		<th scope='col'>{$this->lang->words['member_joined']}</th>
		<th scope='col' class='short'>{$this->lang->words['member_posts']}</th>
		<th scope='col' class='short'>{$this->lang->words['top20rep_reputation']}</th>
		<th scope='col' class='short'>&nbsp;</th>
	</tr>
	" . ((!is_array($members) OR !count($members)) ? ("
		<tr>
			<td colspan='7' class='no_messages'>{$this->lang->words['no_info']}</td>
		</tr>
	") : ("
				".$this->__f__4a95759b0d117c62b271d479adbe8851($members)."	")) . "
</table>";
return $IPBHTML;
}


function __f__4a95759b0d117c62b271d479adbe8851($members)
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $members as $info )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
			<tr class='" .  IPSLib::next( $this->registry->templateStriping["top_posters"] ) . "'>
				<td>
					<img src='{$info['pp_mini_photo']}' alt=\"{$info['members_display_name']}{$this->lang->words['users_photo']}\" class='photo' width='{$info['pp_mini_width']}' height='{$info['pp_mini_height']}' />
				</td>
				<td>
					" . (($info['member_id'] > 0) ? ("" . ((!$this->settings['top20rep_format']) ? ("
							<a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "showuser={$info['member_id']}", "public",'' ), "{$info['members_seo_name']}", "showuser" ) . "' title='{$this->lang->words['view_profile']}'>{$info['members_display_name']}</a> " . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'user_popup' ) ? $this->registry->getClass('output')->getTemplate('global')->user_popup($info['member_id'], $info['members_seo_name']) : '' ) . "
						") : ("
							" . IPSMember::makeProfileLink(IPSMember::makeNameFormatted( $info['members_display_name'], $info['member_group_id']), $info['member_id']) . "
						")) . "") : ("
						{$info['members_display_name']}
					")) . "
				</td>
				<td class='altrow'>
					" . $this->registry->getClass('class_localization')->getDate($info['joined'],"joined", 0) . "
				</td>
				<td class='short'>
					" . $this->registry->getClass('class_localization')->formatNumber( $info['posts'] ) . "
				</td>
				<td class='short altrow'>
					" . (($info['pp_reputation_points'] > 0) ? ("
						<span class='reputation positive'>
					") : ("")) . "
					" . (($info['pp_reputation_points'] < 0) ? ("
						<span class='reputation negative'>
					") : ("")) . "
					" . (($info['pp_reputation_points'] == 0) ? ("
						<span class='reputation zero'>
					") : ("")) . "
					{$this->registry->getClass('class_localization')->formatNumber($info['pp_reputation_points'])}
					</span>
				</td>
				<td class='short'>
					<ul class='user_controls clear'>
						" . (($this->memberData['member_id'] AND $this->memberData['member_id'] != $info['member_id'] && $this->settings['friends_enabled'] AND $this->memberData['g_can_add_friends']) ? ("" . ((IPSMember::checkFriendStatus( $info['member_id'] )) ? ("
								<li class='mini_friend_toggle is_friend' id='friend_xxx_{$info['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=profile&amp;section=friends&amp;do=remove&amp;member_id={$info['member_id']}&amp;secure_key={$this->member->form_hash}", "public",'' ), "", "" ) . "' title='{$this->lang->words['remove_friend']}'>" . $this->registry->getClass('output')->getReplacement("remove_friend") . "</a></li>
							") : ("
								<li class='mini_friend_toggle is_not_friend' id='friend_xxx_{$info['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=profile&amp;section=friends&amp;do=add&amp;member_id={$info['member_id']}&amp;secure_key={$this->member->form_hash}", "public",'' ), "", "" ) . "' title='{$this->lang->words['add_friend']}'>" . $this->registry->getClass('output')->getReplacement("add_friend") . "</a></li>								
							")) . "") : ("")) . "
						" . (($this->memberData['g_use_pm'] AND $this->memberData['member_id'] != $info['member_id'] AND $this->memberData['members_disable_pm'] == 0 AND IPSLib::moduleIsEnabled( 'messaging', 'members' )) ? ("
							<li class='pm_button' id='pm_xxx_{$info['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=messaging&amp;section=send&amp;do=form&amp;fromMemberID={$info['member_id']}", "public",'' ), "", "" ) . "' title='{$this->lang->words['pm_member']}'>" . $this->registry->getClass('output')->getReplacement("send_msg") . "</a></li>
						") : ("")) . "
						" . (($info['has_blog'] AND IPSLib::appIsInstalled( 'blog' ) AND $info['has_blog'] != 'recache') ? ("
							<li><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=blog&amp;module=display&amp;section=blog&amp;mid={$info['member_id']}", "public",'' ), "", "" ) . "' title='{$this->lang->words['view_blog']}'>" . $this->registry->getClass('output')->getReplacement("blog_link") . "</a></li>
						") : ("")) . "
						" . (($info['has_gallery'] AND IPSLib::appIsInstalled( 'gallery' )) ? ("
							<li><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=gallery&amp;module=user&amp;section=user&amp;user={$info['member_id']}", "public",'' ), "", "" ) . "' title='{$this->lang->words['view_gallery']}'>" . $this->registry->getClass('output')->getReplacement("gallery_link") . "</a></li>
						") : ("")) . "
					</ul>
				</td>
			</tr>
		
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- whoPosted --*/
function whoPosted($tid=0, $title="", $rows=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_stats', $this->_funcHooks['whoPosted'] ) )
{
$count_977189653b1ff278a8821b0d4b13c390 = is_array($this->functionData['whoPosted']) ? count($this->functionData['whoPosted']) : 0;
$this->functionData['whoPosted'][$count_977189653b1ff278a8821b0d4b13c390]['tid'] = $tid;
$this->functionData['whoPosted'][$count_977189653b1ff278a8821b0d4b13c390]['title'] = $title;
$this->functionData['whoPosted'][$count_977189653b1ff278a8821b0d4b13c390]['rows'] = $rows;
}

if ( ! isset( $this->registry->templateStriping['whoposted'] ) ) {
$this->registry->templateStriping['whoposted'] = array( FALSE, "row1","row2");
}
$IPBHTML .= "" . (($this->request['module']=='ajax') ? ("
	<h3>{$this->lang->words['who_farted']} " . IPSText::truncate( $title, 40 ) . "</h3>
") : ("" . $this->registry->getClass('output')->getReplacement("header_start") . "<h3 class='maintitle'>{$this->lang->words['who_farted']} " . IPSText::truncate( $title, 30 ) . "</h3>" . $this->registry->getClass('output')->getReplacement("header_end") . "
")) . "
<div class='fixed_inner'>
	<table class='ipb_table'>
		<tr class='header'>
			<th>{$this->lang->words['whoposted_name']}</th>
			<th>{$this->lang->words['whoposted_posts']}</th>
		</tr>
		" . ((count($rows) AND is_array($rows)) ? ("
						".$this->__f__c3c16609dadf257907f6f19bfd0db69d($tid,$title,$rows)."		") : ("")) . "
	</table>
</div>
" . ((!($this->request['module']=='ajax')) ? ("" . $this->registry->getClass('output')->getReplacement("box_end") . "") : ("")) . "";
return $IPBHTML;
}


function __f__c3c16609dadf257907f6f19bfd0db69d($tid=0, $title="", $rows=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $rows as $row )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
				<tr class='" .  IPSLib::next( $this->registry->templateStriping["whoposted"] ) . "'>
					<td>" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'userHoverCard' ) ? $this->registry->getClass('output')->getTemplate('global')->userHoverCard($row) : '' ) . "</td>
					<td>{$row['pcount']}</td>
				</tr>
			
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}


}


/*--------------------------------------------------*/
/* END OF FILE                                      */
/*--------------------------------------------------*/

?>