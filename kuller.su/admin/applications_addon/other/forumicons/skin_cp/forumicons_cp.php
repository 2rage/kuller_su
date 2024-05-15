<?php

//-----------------------------------------------
// (DP32) Forum Icons
//-----------------------------------------------
//-----------------------------------------------
// ACP Skin Content
//-----------------------------------------------
// Author: DawPi
// Site: http://www.ipslink.pl
// Written on: 02 / 08 / 2011
//-----------------------------------------------
// Copyright (C) 2011 DawPi
// All Rights Reserved
//----------------------------------------------- 

class forumicons_cp extends output
{

/**
 * Prevent our main destructor being called by this class
 *
 * @access	public
 * @return	void
 */
public function __destruct()
{
}

public function renderForumHeader() {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<HTML
<div class='section_title'>
	<h2>{$this->lang->words['forumicons_overview']}</h2>
	<ul class='context_menu'>						
		<li>
			<a href='{$this->settings['base_url']}{$this->form_code}&amp;do=updateCache' title='{$this->lang->words['update_cache']}'>
				<img src='{$this->settings[ 'skin_app_url']}/images/update.png' alt='' />
				{$this->lang->words['update_cache']}
			</a>
		</li>
	</ul>
</div>

<div class='acp-box'>
	<h3>{$this->lang->words['forums']}</h3>
	<div class='ipsExpandable' id='forum_wrapper'>
HTML;

//--endhtml--//
return $IPBHTML;
}


public function renderForumFooter() {
		
$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<HTML
	</div>
</div>
HTML;

//--endhtml--//
return $IPBHTML;
}

public function forumWrapper( $content, $r ) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<HTML
	<div id='cat_{$r['id']}'>
		<div class='root_item item category clearfix ipsControlRow'>
			<div class='item_info'>
				<img src='{$this->settings['skin_acp_url']}/images/icons/folder.png' />
				&nbsp;&nbsp;<strong class='larger_text'>{$r['name']}</strong>
			</div>
		</div>
		<div id='cat_wrap_{$r['id']}' class='item_wrap'>
			{$content}
		</div>
	</div>
HTML;
//--endhtml--//
return $IPBHTML;
}

public function renderForumRow( $desc, $r, $depth_guide, $skin ) {

$IPBHTML = "";
//--starthtml--//

if( $depth_guide )
{
	$IPBHTML .= <<<HTML
	<div class='item parent ipsControlRow' id='forum_{$r['id']}'>
HTML;
}
else
{
	$IPBHTML .= <<<HTML
	<div class='item ipsControlRow' id='forum_{$r['id']}'>
HTML;
}

$IPBHTML .= <<<HTML
		<div class='item_info'>
			<strong class='forum_name'>{$r['forum_icon']} {$r['name']}</strong>
			<br />
			<span class='desctext'>{$desc}</span>
		</div>
		<div class='col_buttons right'>
			<ul class='ipsControlStrip'>
				<li class='i_edit'>
					<a href='{$this->settings['base_url']}&amp;{$this->form_code}&amp;do=edit&amp;f={$r['id']}'>{$this->lang->words['edit_settings']}</a>
				</li>
HTML;
	if( $r['forum_icon'] )
	{				
$IPBHTML .= <<<HTML
		 		<li class='i_delete'> 
					<a href='#' onclick='return acp.confirmDelete("{$this->settings['base_url']}&amp;{$this->form_code}&amp;do=delete&f={$r['id']}");' title='{$this->lang->words['delete_icon']}'>{$this->lang->words['delete_icon']}</a>
				</li>
HTML;
	}				 
$IPBHTML .= <<<HTML
			</ul>
		</div>
	</div>
HTML;

//--endhtml--//
return $IPBHTML;
}

public function renderNoForums( $parent_id ) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<HTML
<div class='item parent ipsControlRow' id='forum_none{$parent_id}'>
	<strong style='font-size:11px;color:red;'>{$this->lang->words['noforums']}</strong>
</div>
HTML;

//--endhtml--//
return $IPBHTML;
}


public function itemForm( $form, $button, $st ) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<HTML
<div class='section_title'>
	<h2>{$form['formDo']}
HTML;
	if( $form['forum_name'] )
	{
$IPBHTML .= <<<HTML
: {$form['forum_name']}
HTML;
	}	
$IPBHTML .= <<<HTML
	</h2>
</div>
HTML;

$IPBHTML .= <<<HTML
<form action='{$this->settings['base_url']}{$this->form_code}&amp;do=check&amp;f={$form['i_fid']}&amp;st={$st}' method='post' name='theAdminForm'  id='theAdminForm' enctype='multipart/form-data'>
	<input type='hidden' name='_admin_auth_key' value='{$this->registry->adminFunctions->getSecurityKey()}' />
	
	<div class='acp-box'>
		<h3>{$form['formDo']}</h3>
		<table class='ipsTable double_pad'>
			<tr>
				<th colspan='2'>{$this->lang->words['main_informations']}</th>
			</tr>
			<tr>
				<td class='field_title'><strong class='title'>{$this->lang->words['i_enabled']}</strong></td>
				<td class='field_field'>
					{$form['i_enabled']}<br />
					<span class='desctext'>{$this->lang->words['i_enabled_desc']}</span>
				</td>	
			</tr>
HTML;
			if( $form['curr_image'] )
			{
$IPBHTML .= <<<HTML
			<tr>
				<td class='field_title'><strong class='title'>{$this->lang->words['current_image']}</strong></td>
				<td class='field_field'>
					{$form['curr_image']}
				</td>	
			</tr>			
HTML;
			}
$IPBHTML .= <<<HTML
			<tr>
				<td class='field_title'><strong class='title'>{$this->lang->words['icon']}</strong></td>
				<td class='field_field'>
					{$form['icon']}<br />
					<span class='desctext'>{$this->lang->words['icon_desc']}</span>
				</td>	
			</tr>
						
		</table>

		<div class='acp-actionbar'>
			<input type='submit' value='{$button}' class='button' accesskey='s'> {$this->lang->words['oror']} <input type='submit' value='{$this->lang->words['cancel_operation']}' name='cancel_operation' value='1' class='button' accesskey='s'>
		</div>
	</div>
</form>
HTML;

//--endhtml--//
return $IPBHTML;
}

public function toolsSplash( $form ) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<HTML
<div class='section_title'>
	<h2>{$this->lang->words['tools_list']}</h2>	
</div>

<form action='{$this->settings['base_url']}{$this->form_code}' method='post' name='theAdminForm'  id='theAdminForm'>
	<input type='hidden' name='do' value='convert' />
	<input type='hidden' name='_admin_auth_key' value='{$this->registry->adminFunctions->generated_acp_hash}' />
	
	<div class='acp-box'>
		<h3>{$this->lang->words['convert_tool_title']}</h3>

		<table class='ipsTable double_pad'>
			<tr>
				<td class='field_title'><strong class='title'>{$this->lang->words['convert_tool_title']}</strong></td>
				<td class='field_field'>{$form['pergo']}&nbsp;{$this->lang->words['re_percycle']}<br /><span class='desctext'>{$this->lang->words['convert_tool_title_desc']}</span></td>
			</tr>
		</table>
		<div class='acp-actionbar'>
			<input type='submit' value='{$this->lang->words['run_tool']}' class='button primary' accesskey='s'>
		</div>	
	</div>
</form>
HTML;
//--endhtml--//
return $IPBHTML;
}

}// End of class