<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 0               */
/* CACHE FILE: Generated: Fri, 24 May 2013 01:43:10 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_online_0 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['showOnlineList'] = array('username','userid','viewanon','anonymous','showip','wheretextseo','wheretext','detailslink','wheretextseo','enddetailslink','nomoreenddetailslink','moredetails','nowhere','addfriend','notus','sendpm','blog','gallery','options','online','defaultsort','sort_key','defaultfilter','show_mem','defaultorder','sort_order','onlineusers');


}

/* -- showOnlineList --*/
function showOnlineList($rows, $links="", $defaults=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_online', $this->_funcHooks['showOnlineList'] ) )
{
$count_e17ca9a5989b67ccb7efd9a2875b5817 = is_array($this->functionData['showOnlineList']) ? count($this->functionData['showOnlineList']) : 0;
$this->functionData['showOnlineList'][$count_e17ca9a5989b67ccb7efd9a2875b5817]['rows'] = $rows;
$this->functionData['showOnlineList'][$count_e17ca9a5989b67ccb7efd9a2875b5817]['links'] = $links;
$this->functionData['showOnlineList'][$count_e17ca9a5989b67ccb7efd9a2875b5817]['defaults'] = $defaults;
}

if ( ! isset( $this->registry->templateStriping['online'] ) ) {
$this->registry->templateStriping['online'] = array( FALSE, "row1","row2");
}
$IPBHTML .= "<div class='topic_controls'>
	{$links}
</div>
<h2 class='maintitle'>{$this->lang->words['online_page_title']}</h2>
<div class='ipsBox'>
	<div class='ipsBox_container'>
		<table class='ipb_table ipsMemberList' summary=\"{$this->lang->words['users_online']}\">
			<tr class='header'>
				<th scope='col' width='55'>&nbsp;</th>
				<th scope='col'>{$this->lang->words['member_name']}</th>
				<th scope='col'>{$this->lang->words['where']}</th>
				<th scope='col'>{$this->lang->words['time']}</th>
				<th scope='col'>&nbsp;</th>
			</tr>
			" . ((count($rows)) ? ("
								".$this->__f__c3c592258758a083cd207153d8df784c($rows,$links,$defaults)."			") : ("")) . "
		</table>
	</div>
</div>
<div id='forum_filter' class='ipsForm_center ipsPad'>
	<form method=\"post\" action=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;section=online&amp;module=online", "public",'' ), "", "" ) . "\">
		<label for='sort_key'>{$this->lang->words['s_by']}</label>
		<select name=\"sort_key\" id='sort_key' class='input_select'>
			".$this->__f__a1225833f88377f153853223e124c7a3($rows,$links,$defaults)."		</select>
		<select name=\"show_mem\" class='input_select'>
			".$this->__f__bb4d16025cd759862f76894a9970b368($rows,$links,$defaults)."		</select>
		<select name=\"sort_order\" class='input_select'>
			".$this->__f__d962d3b8bb43a138f6b165703a90069c($rows,$links,$defaults)."		</select>
		<input type=\"submit\" value=\"{$this->lang->words['s_go']}\" class=\"input_submit alt\" />
	</form>
</div>
<br />
<div class='topic_controls'>
	{$links}
</div>";
return $IPBHTML;
}


function __f__c3c592258758a083cd207153d8df784c($rows, $links="", $defaults=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $rows as $session )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
					<tr class='" .  IPSLib::next( $this->registry->templateStriping["online"] ) . "'>
						<td>" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'userSmallPhoto' ) ? $this->registry->getClass('output')->getTemplate('global')->userSmallPhoto(array_merge( $session['_memberData'], array( 'alt' => sprintf($this->lang->words['users_photo'], $session['_memberData']['members_display_name'] ? $session['_memberData']['members_display_name'] : $this->lang->words['global_guestname']) ) )) : '' ) . "</td>
						<td>
							" . (($session['_memberData']['member_id']) ? ("
								" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'userHoverCard' ) ? $this->registry->getClass('output')->getTemplate('global')->userHoverCard(array_merge( $session['_memberData'], array( 'members_display_name' => IPSMember::makeNameFormatted( $session['_memberData']['members_display_name'], $session['_memberData']['member_group_id'] ) ) )) : '' ) . "
							") : ("" . (($session['member_name']) ? ("
									" . IPSMember::makeNameFormatted( $session['member_name'], $session['member_group'] ) . "
								") : ("
									{$this->lang->words['global_guestname']}
								")) . "")) . "
							" . (($session['login_type'] == 1) ? ("" . (($this->memberData['g_access_cp'] || $session['_memberData']['member_id'] == $this->memberData['member_id']) ? ("*") : ("")) . "") : ("")) . "
							" . (($this->memberData['g_access_cp']) ? ("
								<br />
								<span class='ip desc lighter ipsText_smaller'>({$session['ip_address']})</span>
							") : ("")) . "
						</td>
						<td>
							" . ((!$session['where_line'] || $session['in_error']) ? ("
								{$this->lang->words['board_index']}
							") : ("" . (($session['where_link'] AND !$session['where_line_more']) ? ("" . (($session['_whereLinkSeo']) ? ("
										<a href='{$session['_whereLinkSeo']}'>
									") : ("
										<a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "{$session['where_link']}", "public",'' ), "", "" ) . "'>
									")) . "") : ("")) . "
								{$session['where_line']} 
								" . (($session['where_line_more']) ? ("&nbsp;
									" . (($session['_whereLinkSeo']) ? ("
										<a href='{$session['_whereLinkSeo']}'>
									") : ("" . (($session['where_link']) ? ("<a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "{$session['where_link']}", "public",'' ), "", "" ) . "'>") : ("")) . "")) . "
									{$session['where_line_more']}
									" . (($session['where_link']) ? ("</a>") : ("")) . "") : ("" . (($session['where_link']) ? ("</a>") : ("")) . "")) . "")) . "
						</td>
						<td>
							" . $this->registry->getClass('class_localization')->getDate($session['running_time'],"long", 1) . "
						</td>
						<td>
							" . (($session['member_id'] AND $session['member_name']) ? ("<ul class='ipsList_inline ipsList_nowrap right'>
									" . (($this->memberData['member_id'] AND $this->memberData['member_id'] != $session['member_id'] && $this->settings['friends_enabled'] AND $this->memberData['g_can_add_friends']) ? ("" . ((IPSMember::checkFriendStatus( $session['member_id'] )) ? ("
											<li class='mini_friend_toggle is_friend' id='friend_online_{$session['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=profile&amp;section=friends&amp;do=remove&amp;member_id={$session['member_id']}&amp;secure_key={$this->member->form_hash}", "public",'' ), "", "" ) . "' title='{$this->lang->words['remove_friend']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("remove_friend") . "</a></li>
										") : ("
											<li class='mini_friend_toggle is_not_friend' id='friend_online_{$session['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=profile&amp;section=friends&amp;do=add&amp;member_id={$session['member_id']}&amp;secure_key={$this->member->form_hash}", "public",'' ), "", "" ) . "' title='{$this->lang->words['add_friend']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("add_friend") . "</a></li>								
										")) . "") : ("")) . "
									" . (($this->memberData['member_id'] AND $this->memberData['member_id'] != $session['member_id'] AND $this->memberData['g_use_pm'] AND $this->memberData['members_disable_pm'] == 0 AND IPSLib::moduleIsEnabled( 'messaging', 'members' )) ? ("
										<li class='pm_button' id='pm_online_{$session['member_id']}'><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=messaging&amp;section=send&amp;do=form&amp;fromMemberID={$session['member_id']}", "public",'' ), "", "" ) . "' title='{$this->lang->words['pm_member']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("send_msg") . "</a></li>
									") : ("")) . "
									" . (($session['memberData']['has_blog'] AND IPSLib::appIsInstalled( 'blog' )) ? ("
										<li><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=blog&amp;module=display&amp;section=blog&amp;show_members_blogs={$session['member_id']}", "public",'' ), "", "" ) . "' title='{$this->lang->words['view_blog']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("blog_link") . "</a></li>
									") : ("")) . "
									" . (($session['memberData']['has_gallery'] AND IPSLib::appIsInstalled( 'gallery' )) ? ("
										<li><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=gallery&amp;user={$session['member_id']}", "public",'' ), "{$session['memberData']['members_seo_name']}", "useralbum" ) . "' title='{$this->lang->words['view_gallery']}' class='ipsButton_secondary'>" . $this->registry->getClass('output')->getReplacement("gallery_link") . "</a></li>
									") : ("")) . "
								</ul>") : ("
								<span class='desc'>{$this->lang->words['no_options_available']}</span>
							")) . "
						</td>
					</tr>
				
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__a1225833f88377f153853223e124c7a3($rows, $links="", $defaults=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( array( 'click', 'name' ) as $sort )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
				<option value='{$sort}'" . (($defaults['sort_key'] == $sort) ? (" selected='selected'") : ("")) . ">{$this->lang->words['s_sort_key_' . $sort ]}</option>
			
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__bb4d16025cd759862f76894a9970b368($rows, $links="", $defaults=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( array( 'reg', 'guest', 'all' ) as $filter )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
				<option value='{$filter}'" . (($defaults['show_mem'] == $filter) ? (" selected='selected'") : ("")) . ">{$this->lang->words['s_show_mem_' . $filter ]}</option>
			
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__d962d3b8bb43a138f6b165703a90069c($rows, $links="", $defaults=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( array( 'desc', 'asc' ) as $order )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
				<option value='{$order}'" . (($defaults['sort_order'] == $order) ? (" selected='selected'") : ("")) . ">{$this->lang->words['s_sort_order_' . $order ]}</option>
			
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