<?php

/**
 * @author -RAW-
 * @copyright 2012
 * @link http://rawcodes.net
 * @filesource It's the Final Countdown
 * @version 1.2.0
 */

class cp_skin_finalCountdown extends output
{

/**
* Prevent our main destructor being called by this class
*/
function __destruct()
{
}

public function manageScreen( array $data = array() )
{
	$IPBHTML = "";

	$IPBHTML .= <<< HTML
<style type="text/css">
	/************************************************************************/
	/* TOOLTIPS */
	
	.ipsTooltip { padding: 5px; z-index: 25000;}
	.ipsTooltip_inner {
		padding: 8px;
		background: #333333;
		border: 1px solid #333333;
		color: #fff;
		-webkit-box-shadow: 0px 2px 4px rgba(0,0,0,0.3), 0px 1px 0px rgba(255,255,255,0.1) inset;
		-moz-box-shadow: 0px 2px 4px rgba(0,0,0,0.3), 0px 1px 0px rgba(255,255,255,0.1) inset;
		box-shadow: 0px 2px 4px rgba(0,0,0,0.3), 0px 1px 0px rgba(255,255,255,0.1) inset;
		-moz-border-radius: 4px;
		-webkit-border-radius: 4px;
		border-radius: 4px;
		font-size: 12px;
		text-align: center;
		max-width: 250px;
	}
		.ipsTooltip_inner a { color: #fff; }
		.ipsTooltip_inner span { font-size: 11px; color: #d2d2d2 }
		.ipsTooltip.top 	{ background: url({$this->settings['img_url']}/stems/tooltip_top.png) no-repeat bottom center; }
			.ipsTooltip.top_left 	{ background-position: bottom left; }
		.ipsTooltip.bottom	{ background: url({$this->settings['img_url']}/stems/tooltip_bottom.png) no-repeat top center; }
		.ipsTooltip.left 	{ background: url({$this->settings['img_url']}/stems/tooltip_left.png) no-repeat center right; }
		.ipsTooltip.right	{ background: url({$this->settings['img_url']}/stems/tooltip_right.png) no-repeat center left; }
</style>

<script type='text/javascript' src='{$this->settings['js_app_url']}acp.finalCountdown.js?_v=11000'></script>
<div class='section_title'>
	<h2>{$this->lang->words['globalTitle']}</h2>
	
	<div class='ipsActionBar clearfix'>
		<ul>
			<li class='ipsActionButton'>
				<a href='{$this->settings['base_url']}&amp;module=core&amp;do=add'><img src='{$this->settings['skin_acp_url']}/images/icons/add.png' alt='' /> {$this->lang->words['manageAdd']}</a>
			</li>
			<li class='ipsActionButton right'>
				<a href='{$this->settings['base_url']}&amp;module=core&amp;do=recache'><img src='{$this->settings['skin_acp_url']}/images/icons/arrow_refresh.png' alt='' /> {$this->lang->words['manageRecache']}</a>
			</li>
		</ul>
	</div>
</div>

<div class='acp-box'>
 	<h3>{$this->lang->words['manageTitle']}</h3>
 	
	<table class="ipsTable" id="countdownList">
		<tr>
			<th style='width: 3%'>&nbsp;</th>
			<th style='width: 10%'>{$this->lang->words['manageName']}</th>
			<th style='width: 20%'>{$this->lang->words['manageTime']}</th>
			<th style='width: 6%; text-align: center;'>{$this->lang->words['manageEnabled']}</th>
			<th style='width: 10%; text-align: center;'>{$this->lang->words['manageEmbed']}</th>
			<th style='width: 10%;'>Visible on</th>
			<th width='11%'>&nbsp;</td>
		</tr>
HTML;


	if( count( $data ) > 0 )
	{
		foreach( $data as $d )
		{			
			$IPBHTML .= <<< HTML
				<tr class="ipsControlRow isDraggable" id="item_{$d['id']}">
					<td><span class='draghandle'>&nbsp;</span></td>
					<td>
						{$d['name']}
					</td>
					<td>
						{$d['formattedTime']} {$d['timezone']}
					</td>
					<td style='text-align: center;'>
						<img data-tooltip="{$this->lang->words['manageToggleTooltip']}" src='{$this->settings['skin_acp_url']}/images/icons/{$d['enabledImg']}' id="enabled_{$d['id']}" class='clickable toggle enabled' />
					</td>
					<td style='text-align: center;'>
						<img data-tooltip="{$this->lang->words['manageToggleTooltip']}" src='{$this->settings['skin_acp_url']}/images/icons/{$d['embedImg']}' id="allow_embed_{$d['id']}" class='clickable toggle embed' />
					</td>
					<td>
						{$d['viewIn']}
					</td>
					<td>
						<ul class="ipsControlStrip">
							<li class="i_edit">
								<a href='{$this->settings['base_url']}&amp;{$this->form_code}&amp;do=edit&amp;id={$d['id']}'>{$this->lang->words['manageEdit']}</a>
							</li>
							<li class='ipsControlStrip_more'>
								<a href='#' id="menu{$d['id']}" class='ipbmenu'>{$this->lang->words['frm_options']}</a>
							</li>
						</ul>	
						<ul class='acp-menu' id='menu{$d['id']}_menucontent' style='display: none'>
							<li class="icon add">
								<a href='{$this->settings['base_url']}&amp;{$this->form_code}&amp;do=clone&amp;id={$d['id']}' title='{$this->lang->words['manageCloneCountdown']}'>
									{$this->lang->words['manageCloneCountdown']}
								</a>
							</li>
							<li class='icon delete'>
								<a href='#' onclick='acp.confirmDelete("{$this->settings['base_url']}&{$this->form_code_js}&do=delete&_admin_auth_key={$this->registry->getClass('adminFunctions')->_admin_auth_key}&id={$d['id']}");'>
									{$this->lang->words['manageDel']}
								</a>
							</li>
						</ul>
					</td>
				</tr>
HTML;
		}
	}
	else
	{
		$IPBHTML .= <<< HTML
			<tr>
				<td colspan="6" class='no_messages'>
					There are no countdowns to show. <a href='{$this->settings['base_url']}&amp;module=core&amp;do=add' class='mini_button'>Add Countdown</a>
				</td>
			</tr>
HTML;
	}

	$IPBHTML .= <<<EOF
	</table>
</div>
<script type='text/javascript'>
	jQ("#countdownList").ipsSortable( 'table', 
	{
		url: "{$this->settings['base_url']}&module=ajax&do=reorder&md5check={$this->member->form_hash}".replace( /&amp;/g, '&' )
	});
</script>
EOF;


return $IPBHTML;
}

public function testCountdown( $data )
{
$IPBHTML = "";

$IPBHTML .= <<< EOF
<script type="text/javascript" src="{$this->settings['public_dir']}/js/finalCountdown/jquery.countdown.js?_v=11000"></script>
<div class='section_title'>
	<h2>{$this->lang->words['testCountdownsTitle']}</h2>
</div>
EOF;

if( is_array( $data ) AND count( $data ) > 0 )
{
	$IPBHTML .= <<< EOF
	<br clear='all' />
	<div class='acp-box'>
		<h3>{$this->lang->words['countdownHeadertitle']}</h3>
		<table cellpadding='0' class='ipsTable double_pad alternate_rows' cellspacing='0' border='0' width='100%'>
			<tr>
				<td id="countdownsLoading" align="center"><em>Loading countdowns</em></td>
			</tr>
EOF;

	foreach ( $data as $countdown )
	{	

		$IPBHTML .= <<< EOF
			<tr>
				<td style="display:none;" align="center">
					<ul>
						<li>Name: <strong>{$countdown['name']}</strong></li>
						<li>
							<span class="styleHolder" style="{$countdown['text_style']}">
								<span class='after_txt'>{$countdown['before_txt']} </span>
								<span id="countdown{$countdown['id']}"></span>
								<span class='after_txt'> {$countdown['after_txt']}</span>
							</span>
						</li>
					</ul>
				</td>
			</tr>
EOF;
	}
	
	$IPBHTML .= <<< EOF
		</table>
	</div>
<script type="text/javascript">
	(function($) 
	{
		$(document).ready( function()
		{
			$( '#countdownsLoading' ).hide();
EOF;
	foreach( $data as $countdown )
	{
		$IPBHTML .= <<< EOF
			$( '#countdown{$countdown['id']}' ).countdown(
			{
				until: new Date( '{$countdown['jstime']}' ),
				timezone: {$countdown['jstimezone']},
				format: ( '{$countdown['format']}' || 'yodHMS' ),
				layout: ( '{$countdown['layout']}' || '{y<}{yn} {yl}, {y>}{o<}{on} {ol}, {o>}{d<}{dn} {dl}, {d>}{h<}{hn} {hl}, {h>}{m<}{mn} {ml}, {m>}{s<}и {sn} {sl}{s>}' ),
				alwaysExpire: true,
				expiryText: "{$countdown['event_msg']}",
				onExpiry: function()
				{
					$( '#countdown{$countdown['id']}' ).next( '.after_txt' ).hide();
					$( '#countdown{$countdown['id']}' ).prev( '.before_txt' ).hide();
				}
			});
			
			$( '#countdown{$countdown['id']}' ).closest( 'td' ).show();
			
EOF;
	
	}
	$IPBHTML .= "
		});	
	})(jQuery);
</script>";
}

return $IPBHTML;
}

function countdownForm( $type="add", array $data = array(), array $form = array() )
{
	$form_code			= $type == 'edit' ? 'doEdit' : ( $type == 'clone' ? 'doClone' : 'doAdd' );
	$button				= $type == 'edit' ? $this->lang->words['formSave'] 	: 	( $type == 'clone' ? $this->lang->words['formClone']	: $this->lang->words['formAdd'] );
	$title				= $type == 'edit' ? $this->lang->words['editTitle'] : 	( $type == 'clone' ? $this->lang->words['cloneTitle']	: $this->lang->words['addTitle'] );
	
	/* I want the save button to always be visible when we're editing */
	$saveButtonAttr = "id='finish' style='display:none;'";
	if ( $type == 'edit' )
	{
		$saveButtonAttr = "style='text-align:center !important;'";
	}
	
	
$IPBHTML = "";

$IPBHTML .= <<< EOF
<style type="text/css">
	/************************************************************************/
	/* TOOLTIPS */
	
	.ipsTooltip { padding: 5px; z-index: 25000;}
	.ipsTooltip_inner {
		padding: 8px;
		background: #333333;
		border: 1px solid #333333;
		color: #fff;
		-webkit-box-shadow: 0px 2px 4px rgba(0,0,0,0.3), 0px 1px 0px rgba(255,255,255,0.1) inset;
		-moz-box-shadow: 0px 2px 4px rgba(0,0,0,0.3), 0px 1px 0px rgba(255,255,255,0.1) inset;
		box-shadow: 0px 2px 4px rgba(0,0,0,0.3), 0px 1px 0px rgba(255,255,255,0.1) inset;
		-moz-border-radius: 4px;
		-webkit-border-radius: 4px;
		border-radius: 4px;
		font-size: 12px;
		text-align: center;
		max-width: 250px;
	}
		.ipsTooltip_inner a { color: #fff; }
		.ipsTooltip_inner span { font-size: 11px; color: #d2d2d2 }
		.ipsTooltip.top 	{ background: url({$this->settings['img_url']}/stems/tooltip_top.png) no-repeat bottom center; }
			.ipsTooltip.top_left 	{ background-position: bottom left; }
		.ipsTooltip.bottom	{ background: url({$this->settings['img_url']}/stems/tooltip_bottom.png) no-repeat top center; }
		.ipsTooltip.left 	{ background: url({$this->settings['img_url']}/stems/tooltip_left.png) no-repeat center right; }
		.ipsTooltip.right	{ background: url({$this->settings['img_url']}/stems/tooltip_right.png) no-repeat center left; }
</style>
<script type='text/javascript' src='{$this->settings['js_app_url']}acp.finalCountdown.js?_v=11000'></script>
<script type='text/javascript' src='{$this->settings['public_dir']}js/3rd_party/calendar_date_select/calendar_date_select.js'></script>
<style type="text/css" media="all">@import url( "{$this->settings['skin_app_url']}calendar_select.css" );</style>

<div class='warning' id="formWarningBox" style="display:none;">
</div>
<br />

<div class="section_title">
	<h2>{$title}</h2>
</div>	

<form action='{$this->settings['base_url']}&amp;{$this->form_code}&amp;do={$form_code}' method='post' id='adform' name='adform'>
	<input type='hidden' name='id' value='{$data['id']}' />
	<div class="ipsSteps_wrap">
		<div class='ipsSteps clearfix' id='steps_bar'>
			<ul>
				<li class='steps_active' id='step_basic'>
					<strong class='steps_title'>{$this->lang->words['admin_step']} 1</strong>
					<span class='steps_desc'>{$this->lang->words['formStepBasic']}</span>
					<span class='steps_arrow'>&nbsp;</span>
				</li>
				<li id='step_perms'>
					<strong class='steps_title'>{$this->lang->words['admin_step']} 2</strong>
					<span class='steps_desc'>{$this->lang->words['formStepPerms']}</span>
					<span class='steps_arrow'>&nbsp;</span>
				</li>
			</ul>
		</div>
		
		<div class='ipsSteps_wrapper' id='ipsSteps_wrapper'>
			<div id='step_basic_content' class='steps_content'>
				<div class='acp-box'>
					<h3>{$this->lang->words['formStepBasic']}</h3>
					
					<table class='ipsTable alternate_rows double_pad'>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formEnable']}</strong>
							</td>
							<td class='field_field'>
								{$form['enabled']}
							</td>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formAllowEmbed']}</strong>
							</td>
							<td class='field_field'>
								{$form['allow_embed']}
							</td>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formName']}<span class='required'>*</span></strong>
							</td>
							<td class='field_field'>
								{$form['name']}
							</td>
						</tr>
						<tr>
							<th colspan="2">Date & Time</th>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formTime']}<span class='required'>*</span></strong>
							</td>
							<td class='field_field'>
								{$form['date']} <img src='{$this->settings['img_url']}/date.png' alt='{$this->lang->words['generic_date']}' id='date_date_icon' class='clickable' />
							</td>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formTimezone']}<span class='required'>*</span></strong>
							</td>
							<td class='field_field'>
								{$form['timezone']}<br />
								<span class='desctext'>{$this->lang->words['formTimezoneDesc']}</span>
							</td>
						</tr>
						<tr>
							<th colspan="2">Text</th>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formTextBefore']}</strong>
							</td>
							<td class='field_field'>
								{$form['txtBefore']}<br />
								<span class='desctext'>{$this->lang->words['formTextBeforeDesc']}</span>
							</td>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formTextAfter']}</strong>
							</td>
							<td class='field_field'>
								{$form['txtAfter']}<br />
								<span class='desctext'>{$this->lang->words['formTextAfterDesc']}</span>
							</td>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formEventMsg']}</strong>
							</td>
							<td class='field_field'>
								{$form['eventMsg']}<br />
								<span class='desctext'>{$this->lang->words['formEventMsgDesc']}</span>
							</td>
						</tr>
						<tr>
							<th colspan='2'>Expert Only</th>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formTextStyle']}</strong>
							</td>
							<td class='field_field'>
								{$form['text_style']}<br />
								<span class='desctext'>{$this->lang->words['formTextStyleDesc']}</span>
							</td>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formLayout']}</strong>
							</td>
							<td class='field_field'>
								{$form['layout']}<br />
								<span class='desctext'>{$this->lang->words['formLayoutDesc']}</span>
							</td>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formFormat']}</strong>
							</td>
							<td class='field_field'>
								{$form['format']}<br />
								<span class='desctext'>{$this->lang->words['formFormatDesc']}</span>
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div id='step_perms_content' style='display: none'>
				<div class='acp-box'>
					<h3>View restrictions</h3>
					<table class="ipsTable alternate_rows double_pad">
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formGroup']}</strong>
							</td>
							<td class='field_field'>
								{$form['groupPerm']}<br />
								{$form['groupPermAll']} {$this->lang->words['formAllGroups']}
							</td>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formViewIn']}</strong>
							</td>
							<td class='field_field'>
								{$form['viewIn']}
							</td>
						</tr>
						<tr>
							<td class='field_title'>
								<strong class='title'>{$this->lang->words['formShowOnOtherApps']}</strong>
							</td>
							<td class='field_field'>
								{$form['showOnOtherApps']}<br />
								<span class='desctext'>{$this->lang->words['formShowOnOtherAppsDesc']}</span>
							</td>
						</tr>
						<tbody id="appRestrictions" style="display: none;">
EOF;
						foreach( $this->permApps as $app )
						{
							$appKey = ucfirst( $app );
							
							if ( ! $form['wrapper' . $appKey ] )
							{
								continue;
							}
							$IPBHTML .= <<<EOF
							<tr>
								<td class="field_title">
									<strong class='title'>{$this->lang->words['formRestrictTo' . $appKey ]}</strong>
								</td>
								<td class="field_field">
									{$form['app' . $appKey ]}
								</td>
							</tr>
							<tr id="wrapper{$appKey}" style="display: none;">
								<div>
									<td class='field_title'>
										<strong class='title'>{$this->lang->words['formViewIn' . $appKey]}</strong>
									</td>
									<td class='field_field'>
										{$form['wrapper' . $appKey ]}<br />
										<span class='desctext'>{$this->lang->words['form' . $appKey . 'Desc']}</span>
									</td>
								</div>
							</tr>
EOF;
						}
						$IPBHTML .= <<<EOF
						</tbody>
						
					</table>
				</div>
			</div>
		</div>
		
		<div id='steps_navigation' class='clearfix' style='margin-top: 10px;'>
			<input type='button' class='realbutton right' value='{$this->lang->words['wiz_prev']}' id='prev' />
			<input type='button' class='realbutton right' value='{$this->lang->words['wiz_next']}' id='next' />
			<p class='left'{$saveButtonAttr}>
				<input type='submit' class='realbutton' value='{$button}' />
			</p>
		</div>
		<script type='text/javascript'>
			jQ( "#steps_bar" ).ipsWizard( { allowJumping: true, allowGoBack: false } );
		</script>
	</div>
</form>
EOF;

return $IPBHTML;
}

public function deleteForm( $id, $name )
{
$IPBHTML = "";
//--starthtml--//

$title	= sprintf( $this->lang->words['delTitle'], $name );

$IPBHTML .= <<<HTML
<div class='section_title'>
	<h2>{$title}</h2>
</div>

<form action='{$this->settings['base_url']}&amp;{$this->form_code}' method='post' name='theAdminForm'  id='theAdminForm'>
	<input type='hidden' name='do' value='doDelete' />
	<input type='hidden' name='id' value='{$id}' />
	<input type='hidden' name='_admin_auth_key' value='{$this->registry->adminFunctions->getSecurityKey()}' />
	
	<div class='acp-box'>
		<h3 style="text-align: center;">{$this->lang->words['formDeleteConf']}</h3>
	</div>
		
	<div class='acp-actionbar'>
		<div class='centeraction'>
			<input type='submit' value='{$this->lang->words['formDelete']}' class='button primary' accesskey='s'>
		</div>
	</div>
</form>
HTML;

//--endhtml--//
return $IPBHTML;	
}

}