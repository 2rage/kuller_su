<?php

/**
 * Product Title:		Group Name Indicator
 * Product Version:		1.1.0
 * Author:				Michael McCune
 * Website:				Invision focus
 * Website URL:			http://invisionfocus.com/
 * Email:				michael.mccune@gmail.com
 */

class cp_skin_group_name_indicator extends output
{
	public function __destruct()
	{
	}

	public function order_list( $shown=array(), $hidden=array() )
	{
		$IPBHTML .= <<<EOF
<style type="text/css">
td.groupcell span {
	opacity: 1 !important;
	background-image: none !important;
	position: relative !important;
}
</style>
<div class="section_title">
	<h2>{$this->lang->words['group_name_indicator']}</h2>
</div>
<div class="acp-box">
	<h3>{$this->lang->words['m_display_order']}</h3>
	<div>
		<table class="ipsTable">
			<tr>
				<th>&nbsp;</th>
				<th style="width: 85%;">{$this->lang->words['g_title']}</th>
				<th style="width: 13%; text-align: right;">{$this->lang->words['enabled']}</th>
			</tr>

EOF;
		
		if ( count( $shown ) )
		{
			$IPBHTML .= <<<EOF
			<tr>
				<td class="no_pad" colspan="3">
					<table id="handle" class="ipsTable ui-sortable">
						<tr class="ipsControlRow">
							<th class="subhead">&nbsp;</th>
							<th class="subhead">{$this->lang->words['shown_groups']}</th>
							<th class="subhead">&nbsp;</th>
						</tr>

EOF;
		
			foreach( $shown as $shown_group )
			{
				$shown_group['g_title'] = IPSMember::makeNameFormatted( $shown_group['g_title'], $shown_group['g_id'] );
				
				$IPBHTML .= <<<EOF
						<tr class="ipsControlRow isDraggable sortable" id="group_{$shown_group['g_id']}">
							<td class="col_drag">
								<div class="draghandle">Drag</div>
							</td>
							<td class="groupcell" style="width: 85%;">{$shown_group['g_title']}</td>
							<td style="width: 13%;" class="col_buttons">
								<ul class="ipsControlStrip">
									<li class="i_delete">
										<a title="{$this->lang->words['disable']}" href="{$this->settings['base_url']}&amp;{$this->form_code}&amp;do=group_toggle&amp;group_id={$shown_group['g_id']}">{$this->lang->words['disable']}</a>
									</li>
								</ul>
							</td>
						</tr>

EOF;
			}
			
			$IPBHTML .= <<<EOF
					</table>
				</td>
			</tr>

EOF;
		}
		
		if ( count( $hidden ) )
		{
			$IPBHTML .= <<<EOF
			<tr>
				<td class="no_pad" colspan="3">
					<table class="ipsTable">
						<tr class="ipsControlRow">
							<th class="subhead">&nbsp;</th>
							<th class="subhead">{$this->lang->words['hidden_groups']}</th>
							<th class="subhead">&nbsp;</th>
						</tr>

EOF;
			
			foreach ( $hidden as $hidden_group )
			{
				$hidden_group['g_title'] = IPSMember::makeNameFormatted( $hidden_group['g_title'], $hidden_group['g_id'] );
				
				$IPBHTML .= <<<EOF
						<tr class="ipsControlRow">
							<td class="col_drag">&nbsp;</td>
							<td class="groupcell" style="width: 85%;">{$hidden_group['g_title']}</td>
							<td style="width: 13%;" class="col_buttons">
								<ul class="ipsControlStrip">
									<li class="i_add">
										<a title="{$this->lang->words['enable']}" href="{$this->settings['base_url']}&amp;{$this->form_code}&amp;do=group_toggle&amp;group_id={$hidden_group['g_id']}">{$this->lang->words['enable']}</a>
									</li>
								</ul>
							</td>
						</tr>

EOF;
			}
			
			$IPBHTML .= <<<EOF
					</table>
				</td>
			</tr>

EOF;
		}
			
			$IPBHTML .= <<<EOF
		</table>
	</div>
</div>
<script type="text/javascript">
//<![CDATA[
	jQ("#handle").ipsSortable('table', { items: "tr.sortable", url: "{$this->settings['base_url']}&{$this->form_code_js}&do=group_manage_position&md5check={$this->registry->adminFunctions->getSecurityKey()}".replace( /&amp;/g, '&' )});
//]]>
</script>
EOF;

		//--endhtml--//
		return $IPBHTML;
	}
}