<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 2               */
/* CACHE FILE: Generated: Wed, 08 May 2013 03:43:51 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_mlist_2 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['member_alpha_ru'] = array('selected','letterdefault','letterquickjump');
$this->_funcHooks['member_list_show'] = array('customfields','filterdefault','filter','sortdefault','sort_key','orderdefault','sort_order','limitdefault','max_results','selected','letterdefault','chars','weAreSupmod','addfriend','notus','sendpm','blog','gallery','rate1','rate2','rate3','rate4','rate5','rating','norep','posrep','negrep','repson','filterViews','members','calendarlocale','namebox_begins','namebox_contains','photoonly','rating0','rating1','rating2','rating3','rating4','canFilterRate','hascfields','posts_ltmt_lt','posts_ltmt_mt','joined_ltmt_lt','joined_ltmt_mt','lastpost_ltmt_lt','lastpost_ltmt_mt','lastvisit_ltmt_lt','lastvisit_ltmt_mt','letterquickjump','filtermembers','filterposts','filterjoined','showmembers','members','showmembers','letterdefault','selected','chars','members','showmembers');


}

/* -- member_alpha_ru --*/
function member_alpha_ru($url='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_mlist', $this->_funcHooks['member_alpha_ru'] ) )
{
$count_166023b3fa40362e1ec0179a6be4f181 = is_array($this->functionData['member_alpha_ru']) ? count($this->functionData['member_alpha_ru']) : 0;
$this->functionData['member_alpha_ru'][$count_166023b3fa40362e1ec0179a6be4f181]['url'] = $url;
}
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- member_list_show --*/
function member_list_show($members, $pages="", $dropdowns=array(), $defaults=array(), $custom_fields=null, $url='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_mlist', $this->_funcHooks['member_list_show'] ) )
{
$count_22869f78362c03fd17acb8d28380694c = is_array($this->functionData['member_list_show']) ? count($this->functionData['member_list_show']) : 0;
$this->functionData['member_list_show'][$count_22869f78362c03fd17acb8d28380694c]['members'] = $members;
$this->functionData['member_list_show'][$count_22869f78362c03fd17acb8d28380694c]['pages'] = $pages;
$this->functionData['member_list_show'][$count_22869f78362c03fd17acb8d28380694c]['dropdowns'] = $dropdowns;
$this->functionData['member_list_show'][$count_22869f78362c03fd17acb8d28380694c]['defaults'] = $defaults;
$this->functionData['member_list_show'][$count_22869f78362c03fd17acb8d28380694c]['custom_fields'] = $custom_fields;
$this->functionData['member_list_show'][$count_22869f78362c03fd17acb8d28380694c]['url'] = $url;
}

if ( ! isset( $this->registry->templateStriping['memberStripe'] ) ) {
$this->registry->templateStriping['memberStripe'] = array( FALSE, "row1","row2");
}
$IPBHTML .= "<div class='master_list' id='member_list'>
	
	<h2>{$this->lang->words['mlist_header']}</h2>
	<div class='controls'>
<div class=\"buttons\">
<a class=\"button page-button\" id=\"filter-option\">Filter &raquo;</a></div>
<div id=\"filter-letters\">
		".$this->__f__54d8cdac202005065548dd2073959dec($members,$pages,$dropdowns,$defaults,$custom_fields,$url)."</div>
</div>
	" . ((is_array( $members ) and count( $members )) ? ("
				".$this->__f__301bee0e123fa0f658bd569a1913a53e($members,$pages,$dropdowns,$defaults,$custom_fields,$url)."	") : ("
		<div class='no_messages'>
			{$this->lang->words['no_results']}
		</div>
	")) . "
	
	<div class='controls'><div class=\"buttons\">
		{$pages}
	</div></div>
</div>";
return $IPBHTML;
}


function __f__54d8cdac202005065548dd2073959dec($members, $pages="", $dropdowns=array(), $defaults=array(), $custom_fields=null, $url='')
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( range(65,90) as $char )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
			" . (($letter = strtoupper(chr($char))) ? ("") : ("")) . "
				" . ((strtoupper( $this->request['quickjump'] ) == $letter) ? ("
					<span class='letter-page active'><strong>{$letter}</strong></span>&nbsp;
				") : ("
					<span class=\"letter-page\"><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;{$url}&amp;quickjump={$letter}", "public",'' ), "false", "" ) . "' title='{$this->lang->words['mlist_view_start_title']} {$letter}'>{$letter}</a></span>&nbsp;
				")) . "
		
";
	}
	$_ips___x_retval .= '<!--hook.foreach.skin_mlist.member_list_show.chars.outer.post-->';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__301bee0e123fa0f658bd569a1913a53e($members, $pages="", $dropdowns=array(), $defaults=array(), $custom_fields=null, $url='')
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $members as $member )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
			<div class='row touch-row' id=\"mem-{$member['member_id']}\">
				<div class='icon'>
					<a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "showuser={$member['member_id']}", "public",'' ), "{$member['members_seo_name']}", "showuser" ) . "' title='{$this->lang->words['view_profile']}'><img src='{$member['pp_mini_photo']}' alt=\"" . sprintf($this->lang->words['users_photo'],$member['members_display_name']) . "\" class='photo' /></a>	
				</div>
				<strong><a class='title' href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "showuser={$member['member_id']}", "public",'' ), "{$member['members_seo_name']}", "showuser" ) . "' title='{$this->lang->words['view_profile']}'>{$member['members_display_name']}</a></strong>
				<br />
				<span class='subtext'>" . $this->registry->getClass('class_localization')->formatNumber( $member['posts'] ) . " {$this->lang->words['member_posts']} &middot; {$this->lang->words['member_group']}: " . IPSMember::makeNameFormatted( $member['group'], $member['member_group_id'] ) . "
				 &middot; <a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=search&amp;do=user_activity&amp;mid={$member['member_id']}", "public",'' ), "", "" ) . "'>" . $this->registry->getClass('output')->getReplacement("find_topics_link") . " {$this->lang->words['gbl_find_my_content']}</a></span>
			</div>
		
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