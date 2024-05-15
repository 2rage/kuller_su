<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Error log skin file
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Core
 * @link		http://www.invisionpower.com
 * @since		Friday 19th May 2006 17:33
 * @version		$Revision: 10721 $
 */
 
class cp_skin_spamlogs
{
	/**
	 * Registry Object Shortcuts
	 *
	 * @var		$registry
	 * @var		$DB
	 * @var		$settings
	 * @var		$request
	 * @var		$lang
	 * @var		$member
	 * @var		$memberData
	 * @var		$cache
	 * @var		$caches
	 */
	protected $registry;
	protected $DB;
	protected $settings;
	protected $request;
	protected $lang;
	protected $member;
	protected $memberData;
	protected $cache;
	protected $caches;
	
	/**
	 * Constructor
	 *
	 * @param	object		$registry		Registry object
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry )
	{
		$this->registry 	= $registry;
		$this->DB	    	= $this->registry->DB();
		$this->settings		=& $this->registry->fetchSettings();
		$this->request		=& $this->registry->fetchRequest();
		$this->member   	= $this->registry->member();
		$this->memberData	=& $this->registry->member()->fetchMemberData();
		$this->cache		= $this->registry->cache();
		$this->caches		=& $this->registry->cache()->fetchCaches();
		$this->lang 		= $this->registry->class_localization;
	}

public function spamServiceTest( $result )
{
$IPBHTML = "";

if( $result == 'DEBUG_MODE_SUCCESFUL_API_TEST' )
{
$IPBHTML .= <<<HTML
<div class='information-box'>
	<b>{$this->lang->words['slog_api_connected']}</b>
</div>
HTML;
}
else
{
$IPBHTML .= <<<HTML
<div class='information-box warning'>
	<b>{$this->lang->words['slog_api_failed']}: {$result}</b>
</div>
HTML;
}

return $IPBHTML;
}

/**
 * Spam log wrapper
 *
 * @param	array 		Rows
 * @param	string		Page links
 * @return	string		HTML
 */
public function spamlogsWrapper( $rows, $links ) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<HTML
<form action='{$this->settings['base_url']}{$this->form_code}' method='post' class='information-box'>
	<p><label for="search_term">{$this->lang->words['spamlog_searchlabel']}</label> <input type='text' name='search_term' id='search_term' class='input_text' value='{$this->request['search_term']}' /> <input type='submit' class='input_submit' value='{$this->lang->words['spamlog_searchbutton']}' /></p>
</form>
<br />
<script type='text/javascript' src='{$this->settings['js_main_url']}acp.forms.js'></script>
<form action='{$this->settings['base_url']}{$this->form_code}' method='post'>
<input type='hidden' name='do' value='remove' />
<input type='hidden' name='_admin_auth_key' value='{$this->registry->adminFunctions->generated_acp_hash}' />
<div class="acp-box">
	<h3>{$this->lang->words['slog_spamlogs']}</h3>
	<table class='ipsTable'>
		<tr>
			<th width='5%'>{$this->lang->words['slog_list_id']}</th>
			<th width='25%'>{$this->lang->words['slog_list_date']}</th>
			<th width='15%'>{$this->lang->words['slog_list_code']}</th>
			<th width='25%'>{$this->lang->words['slog_list_msg']}</th>
			<th width='15%'>{$this->lang->words['slog_list_email']}</th>
			<th width='10%'>{$this->lang->words['slog_list_ip']}</th>
			<th width='3%'><input type='checkbox' title="{$this->lang->words['my_checkall']}" id='checkAll' /></th>
		</tr>
HTML;

if( count( $rows ) AND is_array( $rows ) )
{
	foreach( $rows as $row )
	{
		$IPBHTML .= <<<HTML
		<tr>
			<td>{$row['id']}</td>
			<td>{$row['_time']}</td>
			<td>{$row['log_code']}: {$this->lang->words['slog_response_'.$row['log_code']]}</td>
			<td>{$row['log_msg']}</td>
			<td>{$row['email_address']}</td>
			<td>{$row['ip_address']}</td>
			<td><input type='checkbox' name='id_{$row['id']}' value='1' class='checkAll' /></td>
		</tr>
HTML;
	}
}
else
{
	$IPBHTML .= <<<HTML
		<tr>
			<td colspan='7' align='center'>{$this->lang->words['sslog_noresults']}</td>
		</tr>
HTML;
}

$IPBHTML .= <<<HTML
	</table>
	<div class='acp-actionbar'>
        <div class='right'>
			<input type="checkbox" id="checkbox" name="type" value="all" />&nbsp;{$this->lang->words['erlog_removeall']}&nbsp;<input type="submit" value="{$this->lang->words['erlog_removechecked']}" class="button primary" />
        </div>
        <div class='left'>{$links}</div>
        <br class='clear' />
	</div>
</div>
</form>
HTML;

//--endhtml--//
return $IPBHTML;
}

}