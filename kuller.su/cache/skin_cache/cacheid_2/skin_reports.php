<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 2               */
/* CACHE FILE: Generated: Wed, 08 May 2013 03:43:51 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_reports_2 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['reportsIndex'] = array('statuses','isUnread','statusesLoop','indexReportUrl','reports','noviewall','hasPages','indexHasReports','accessACP','statuses','isUnread','statusesLoop','indexReportUrl','reports','noviewall','hasPages','indexHasReports','accessACP');
$this->_funcHooks['viewReport'] = array('setStatus','statuses','viewReports','canJoinPm','handlePmSpecial','statusesLoop','hasReports','disablelightbox','setStatus','statuses','viewReports','canJoinPm','handlePmSpecial','statusesLoop','hasReports','disablelightbox');


}

/* -- basicReportForm --*/
function basicReportForm($name="", $url="", $extra_data="", $captchaHTML="") {
$IPBHTML = "";
$IPBHTML .= "<h2 class='maintitle'>{$this->lang->words['report_basic_title']}</h2>
<div class='generic_bar'></div>
<form action=\"{$this->settings['base_url']}app=core&amp;module=reports&amp;rcom={$this->request['rcom']}&amp;send=1\" method=\"post\" name=\"REPLIER\">
	<input type='hidden' name='k' value='{$this->member->form_hash}' />
	<div class='post_form'>
		<fieldset>
			<h3 class='bar'>{$this->lang->words['reporting_title']} <a href=\"{$url}\" title='{$this->lang->words['view_content']}'>{$name}</a></h3>
			<ul>
				<li class='field'>
					<label for='message'>{$this->lang->words['report_basic_enter']}</label>
					<textarea id='message' class='input_text' name='message' cols='60' rows='8'></textarea><br />
						<span class='desc'>{$this->lang->words['report_basic_desc']}</span>
				</li>
				{$extra_data}
				{$captchaHTML}
			</ul>
		</fieldset>
		<fieldset class='submit'>
			<input type=\"submit\" class='input_submit' value=\"{$this->lang->words['report_basic_submit']}\" accesskey='s' /> {$this->lang->words['or']} <a href='{$url}' title='{$this->lang->words['cancel']}' class='cancel'>{$this->lang->words['cancel']}</a>
		</fieldset>
	</div>
</form>";
return $IPBHTML;
}

/* -- reportsIndex --*/
function reportsIndex($reports=array(), $acts="", $pages="", $statuses=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_reports', $this->_funcHooks['reportsIndex'] ) )
{
$count_8f023b631e47bfb1db3f91b943ccec23 = is_array($this->functionData['reportsIndex']) ? count($this->functionData['reportsIndex']) : 0;
$this->functionData['reportsIndex'][$count_8f023b631e47bfb1db3f91b943ccec23]['reports'] = $reports;
$this->functionData['reportsIndex'][$count_8f023b631e47bfb1db3f91b943ccec23]['acts'] = $acts;
$this->functionData['reportsIndex'][$count_8f023b631e47bfb1db3f91b943ccec23]['pages'] = $pages;
$this->functionData['reportsIndex'][$count_8f023b631e47bfb1db3f91b943ccec23]['statuses'] = $statuses;
}

if ( ! isset( $this->registry->templateStriping['reportsTable'] ) ) {
$this->registry->templateStriping['reportsTable'] = array( FALSE, "row1","row2");
}
$IPBHTML .= "" . $this->registry->getClass('output')->addJSModule("reports", "0" ) . "
" . ((!$this->request['showall']) ? ("
	<p class='message'>{$this->lang->words['only_active_note']}  <a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=reports&amp;do=index&amp;showall=1", "public",'' ), "", "" ) . "'>{$this->lang->words['click_here_link']}</a> {$this->lang->words['to_view_allrep']}</p>
") : ("")) . "
" . (($pages) ? ("
	<div class='topic_controls'>
		{$pages}
	</div>
") : ("")) . "
<br class='clear' />
<form method=\"post\" action=\"{$this->settings['base_url']}app=core&amp;module=reports&amp;do=process&amp;st={$this->request['st']}\">
<input type='hidden' name='k' value='{$this->member->form_hash}' />
<table class='ipb_table report_center' summary='{$this->lang->words['reported_content_summary']}'>
	<caption class='maintitle'>{$this->lang->words['list_title']}</caption>
	<tr class='header'>
		<th scope='col' class='col_r_icon'>&nbsp;</th>
		<th scope='col' class='col_r_title'>{$this->lang->words['list_header_title']}</th>
		<th scope='col' class='col_r_section'>{$this->lang->words['list_header_section']}</th>
		<th scope='col' class='col_r_total short'>{$this->lang->words['list_header_reports']}</th>
		<th scope='col' class='col_r_comments short'>{$this->lang->words['list_header_comments']}</th>
		<th scope='col' class='col_r_updated'>{$this->lang->words['list_header_updated_by']}</th>
		<th scope='col' class='col_r_mod short'><input type='checkbox' id='checkAllReports' title='{$this->lang->words['select_all_reports']}' class='input_check' /></th>
	</tr>
	" . ((count($reports)) ? ("
				".$this->__f__5d3319455f3e0dcbe289ff7dbd70263c($reports,$acts,$pages,$statuses)."	") : ("
		<tr>
			<td colspan='7' class='no_messages row1'>
				{$this->lang->words['no_reports']}
			</td>
		</tr>
	")) . "
</table>
<div id='topic_mod' class='moderation_bar rounded with_action clear'>
	<a href='#' class='ipsButton_secondary left' id='prune_reports'>{$this->lang->words['report_option_prune']}</a>
	<span class='desc'>{$this->lang->words['r_with_selected']}</span>
	<select name=\"newstatus\" id=\"report_actions\">
		<option value=\"x\">---</option>
		" . (($this->memberData['g_access_cp']) ? ("<optgroup label=\"{$this->lang->words['report_actions']}\"  style=\"font-style: normal;\">
			" . (($this->memberData['g_access_cp']) ? ("<option value=\"d\">{$this->lang->words['report_option_delete']}</option>") : ("")) . "
			</optgroup>") : ("")) . "
		<optgroup label=\"{$this->lang->words['report_actions_mark_optgroup']}\" style=\"font-style: normal;\">
		{$acts}
		</optgroup>
	</select>
	<label for='pruneDayBox' id='pruneDayLabel'>{$this->lang->words['older_than']}</label>
	<input type=\"text\" name=\"pruneDays\" id=\"pruneDayBox\" class='input_text' size=\"3\" value=\"\" />
	<span id='pruneDayLang'>{$this->lang->words['report_prune_days_box']}</span>
	<input type=\"submit\" id='report_mod' class=\"input_submit alt\" value=\"{$this->lang->words['r_go']}\" />
</div>
</form>
<div id='prune_reports_form' style='display: none'>
	<div class='ipsPad ipsForm_center'>
		<form method=\"post\" action=\"{$this->settings['base_url']}app=core&amp;module=reports&amp;do=process&amp;st={$this->request['st']}\">
		<input type='hidden' name='k' value='{$this->member->form_hash}' />
		<input type='hidden' name='newstatus' value='p' />
		{$this->lang->words['report_prune_1']} <input type=\"text\" name=\"pruneDays\" id=\"pruneDayBox\" class='input_text' size=\"3\" value=\"\" /> {$this->lang->words['report_prune_2']}&nbsp;&nbsp;
		<input type=\"submit\" id='report_mod' class=\"input_submit alt\" value=\"{$this->lang->words['r_go']}\" />
	</div>
</div>
<script type='text/javascript'>
	$('prune_reports').observe('click', function(e){
		Event.stop(e);
		
		if( ipb.reports.prunePopup ){
			ipb.reports.prunePopup.show();
		}
		else
		{
			ipb.reports.prunePopup = new ipb.Popup( 'prune', { type: 'balloon',
													initial: $('prune_reports_form').show(),
													stem: true,
													hideClose: true,
													hideAtStart: false,
													attach: { target: $('prune_reports'), position: 'auto', 'event': 'click' },
													w: '350px' }
												);
			
		}
	});
</script>";
return $IPBHTML;
}


function __f__d8d837b895ceccce6f2e89f4336c56a0($reports=array(), $acts="", $pages="", $statuses=array(),$report='')
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $statuses as $status_id => $status )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
								<li class='{$status_id} " . (($status_id == $report['status']) ? ("status-selected") : ("")) . "'><a href=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=reports&amp;section=reports&amp;do=process&amp;report_ids[{$report['id']}]={$report['id']}&amp;newstatus={$status_id}&amp;k={$this->member->form_hash}", "public",'' ), "", "" ) . "\" title='{$this->lang->words['change_status_title']}' class='change-status' id='{$report['id']}:{$status_id}'>{$this->lang->words['mark_status_as']} <strong>{$status['title']}</strong></a></li>
							
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__5d3319455f3e0dcbe289ff7dbd70263c($reports=array(), $acts="", $pages="", $statuses=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $reports as $report )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
			<tr class='" .  IPSLib::next( $this->registry->templateStriping["reportsTable"] ) . "'>
				<td class='short altrow'>
					" . ((empty($report['_isRead'])) ? ("
						" . $this->registry->getClass('output')->getReplacement("t_unread") . "
					") : ("")) . "
					<a href=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=reports&amp;section=reports&amp;do=process&amp;report_ids[{$report['id']}]={$report['id']}&amp;newstatus=2&amp;k={$this->member->form_hash}", "public",'' ), "", "" ) . "\" title='{$this->lang->words['change_current_status']}' class='ipbmenu' id='change_status-{$report['id']}'><span id=\"rstat-{$report['id']}\">{$report['status_icon']}</span></a>
				</td>
				<td>
					<a href=\"{$this->settings['base_url']}&amp;app=core&amp;module=reports&amp;do=show_report&amp;rid={$report['id']}\" title='{$this->lang->words['view_report']}'>{$report['title']}</a>
					" . ((is_array( $statuses ) && count( $statuses )) ? ("
						<ul class='ipbmenu_content' id='change_status-{$report['id']}_menucontent'>
							".$this->__f__d8d837b895ceccce6f2e89f4336c56a0($reports,$acts,$pages,$statuses,$report)."						</ul>
					") : ("")) . "
				</td>
				<td class='altrow'>
					" . (($report['section']['url']) ? ("" . ((!$report['section']['title']) ? ("
							<a href=\"{$report['section']['url']}\" title='{$this->lang->words['go_to_section']}' class='desc blend_links'>{$this->lang->words['report_no_title']}</a>
						") : ("
							<a href=\"{$report['section']['url']}\" title='{$this->lang->words['go_to_section']}'>{$report['section']['title']}</a>
						")) . "") : ("" . ((!$report['section']['title']) ? ("
							{$this->lang->words['report_no_title']}
						") : ("
							{$report['section']['title']}
						")) . "")) . "
				</td>
				<td class='short'>{$report['num_reports']}</td>
				<td class='short altrow'>{$report['num_comments']}</td>
				<td>
					<a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "showuser={$report['updated_by']}", "public",'' ), "{$report['member']['members_seo_name']}", "showuser" ) . "' class='ipsUserPhotoLink left'>
						<img src='{$report['member']['pp_small_photo']}' class='ipsUserPhoto ipsUserPhoto_mini' />
					</a>
					<ul class='last_post ipsType_small'>
						<li>{$this->lang->words['by_ucfirst']} " . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'userHoverCard' ) ? $this->registry->getClass('output')->getTemplate('global')->userHoverCard($report['member']) : '' ) . "</li>
						<li>" . $this->registry->getClass('class_localization')->getDate($report['date_updated'],"date", 0) . "</li>
					</ul>
				</td>
				<td class='short altrow'>
					<input type='checkbox' id='report_check_{$report['id']}' class='input_check checkall' name='report_ids[]' value='{$report['id']}' />
				</td>
			</tr>
		
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- statusIcon --*/
function statusIcon($img, $width, $height) {
$IPBHTML = "";
$IPBHTML .= "<img src='{$this->settings['public_dir']}{$img}' alt='{$this->lang->words['status']}' />";
return $IPBHTML;
}

/* -- viewReport --*/
function viewReport($options=array(), $reports=array(), $comments=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_reports', $this->_funcHooks['viewReport'] ) )
{
$count_bafb98e5f3f27bbc3e5235ab34fc73fb = is_array($this->functionData['viewReport']) ? count($this->functionData['viewReport']) : 0;
$this->functionData['viewReport'][$count_bafb98e5f3f27bbc3e5235ab34fc73fb]['options'] = $options;
$this->functionData['viewReport'][$count_bafb98e5f3f27bbc3e5235ab34fc73fb]['reports'] = $reports;
$this->functionData['viewReport'][$count_bafb98e5f3f27bbc3e5235ab34fc73fb]['comments'] = $comments;
}
$IPBHTML .= "" . $this->registry->getClass('output')->addJSModule("reports", "0" ) . "
<div class='message'>
	{$this->lang->words['report_about_intro']} " . (($options['class'] == 'messages') ? ("{$this->lang->words['report_about_pm']} {$options['title']}
		" . ((in_array( $this->memberData['member_group_id'], explode( ',', $this->registry->getClass('reportLibrary')->plugins['messages']->_extra['plugi_messages_add'] ) )) ? ("
			<a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=reports&amp;section=reports&amp;do=showMessage&amp;topicID={$options['topicID']}", "public",'' ), "", "" ) . "'>{$this->lang->words['report_join_pm']}</a>
		") : ("")) . "") : ("
		<a href=\"{$options['url']}\" title=\"{$this->lang->words['report_view_reported']}\">{$options['title']}</a>
	")) . "
</div>
<br />
<div class='topic_controls'>
	<ul class='topic_buttons'>
		" . (($this->memberData['g_access_cp']) ? ("<li><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=reports&amp;section=reports&amp;do=process&amp;report_ids[{$options['rid']}]={$options['rid']}&amp;newstatus=d&amp;k={$this->member->form_hash}", "public",'' ), "", "" ) . "' title='{$this->lang->words['delete_report']}' data-confirmaction=\"true\"><img src='{$this->settings['img_url']}/delete.png' alt='' id='delete_report' /> {$this->lang->words['delete_report']}</a></li>") : ("")) . "
		<li><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=reports&amp;section=reports&amp;do=process&amp;report_ids[{$options['rid']}]={$options['rid']}&amp;newstatus=2&amp;k={$this->member->form_hash}", "public",'' ), "", "" ) . "' title='{$this->lang->words['change_current_status']}' class='ipbmenu' id='change_status'>{$options['status_icon']} {$this->lang->words['current_status']} <strong>{$options['status_text']}</strong></a></li>
	</ul>
</div>
" . ((is_array( $options['statuses'] ) && count( $options['statuses'] )) ? ("
	<ul class='ipbmenu_content' id='change_status_menucontent'>
		".$this->__f__865392a6aaa0daa9e6443269d811c376($options,$reports,$comments)."	</ul>
") : ("")) . "
<br />
<div class='topic hfeed'>
<h2 class='maintitle'>{$this->lang->words['reports_h2']}</h2>
<div class='generic_bar'></div>
" . ((is_array($reports) AND count($reports)) ? ("
	".$this->__f__703533845df790d1f52b8334dcb9a2b7($options,$reports,$comments)."") : ("")) . "
</div>
<br /><hr /><br />
<div class='ipsBox'>
	<div class='ipsBox_container ipsPad'>
		<h2 class='ipsType_subtitle'>{$comments['count']} {$this->lang->words['comments_h2']}</h2>
		<div>
			{$comments['html']}
		</div>
	</div>
</div>
" . ((!$this->settings['disable_lightbox']) ? ("
" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'include_lightbox' ) ? $this->registry->getClass('output')->getTemplate('global')->include_lightbox() : '' ) . "
") : ("")) . "
" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'include_highlighter' ) ? $this->registry->getClass('output')->getTemplate('global')->include_highlighter(1) : '' ) . "";
return $IPBHTML;
}


function __f__865392a6aaa0daa9e6443269d811c376($options=array(), $reports=array(), $comments=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $options['statuses'] as $status_id => $status )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
			" . (($status_id != $options['status_id']) ? ("
				<li><a href=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=reports&amp;section=reports&amp;do=process&amp;report_ids[{$options['rid']}]={$options['rid']}&amp;newstatus={$status_id}&amp;k={$this->member->form_hash}", "public",'' ), "", "" ) . "\" title='{$this->lang->words['change_status_title']}' />{$this->lang->words['mark_status_as']} <strong>{$status['title']}</strong></a></li>
			") : ("")) . "
		
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__703533845df790d1f52b8334dcb9a2b7($options=array(), $reports=array(), $comments=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $reports as $report )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
		<div class='post_block  hentry clear'>
			<div class='post_wrap'>
				<h3>" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'userHoverCard' ) ? $this->registry->getClass('output')->getTemplate('global')->userHoverCard($report['author']) : '' ) . "</h3>
				<div class='author_info'>
					" . ( method_exists( $this->registry->getClass('output')->getTemplate('global'), 'userInfoPane' ) ? $this->registry->getClass('output')->getTemplate('global')->userInfoPane($report['author'], 'mreport', array( 'id2' => $report['rid'] )) : '' ) . "
				</div>
				<div class='post_body'>
					<p class='posted_info'>{$this->lang->words['posted_prefix']} " . $this->registry->getClass('class_localization')->getDate($report['date_reported'],"long", 0) . "</p>
					<div class='post entry-content'>{$report['report']}</div>
				</div>
			</div>
			<br class='clear' />
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