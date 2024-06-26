<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Email error logs
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
 
class cp_skin_emailerrorlogs
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

/**
 * Show the splash screen for the email error logs
 *
 * @param	array 		Records
 * @param	string		Page links
 * @return	string		HTML
 */
public function emailerrorlogsWrapper( $rows, $links ) {

$form_array 		= array(
							0 => array( 'subject'	, $this->lang->words['erlog_subject']),
							2 => array( 'email_from', $this->lang->words['erlog_fromemail'] ),
							3 => array( 'email_to'	, $this->lang->words['erlog_toemail'] ),
							4 => array( 'error'		, $this->lang->words['erlog_error'] ),
							);
$type_array 		= array(
							0 => array( 'exact'	, $this->lang->words['erlog_exact'] ),
							1 => array( 'loose'	, $this->lang->words['erlog_loose'] ),
						 	);
$form				= array();

$form['type']		= $this->registry->output->formDropdown( "type" , $form_array, $this->request['type'] );
$form['match']		= $this->registry->output->formDropdown( "match", $type_array, $this->request['match'] );
$form['string']		= $this->registry->output->formInput( "string", $this->request['string'] );

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<HTML
<script type='text/javascript' src='{$this->settings['js_main_url']}acp.forms.js'></script>

<div class='section_title'>
	<h2>{$this->lang->words['erlog_title']}</h2>
</div>

<form action='{$this->settings['base_url']}{$this->form_code}' method='post'>
<input type='hidden' name='do' value='remove' />
<input type='hidden' name='_admin_auth_key' value='{$this->registry->adminFunctions->generated_acp_hash}' />
<div class="acp-box">
	<h3>{$this->lang->words['erlog_thelogs']}</h3>
	<table class="ipsTable">
		<tr>
			<th width='25%'>{$this->lang->words['erlog_to']}</th>
			<th width='25%'>{$this->lang->words['erlog_subject']}</th>
			<th width='27%'>{$this->lang->words['erlog_error']}</th>
			<th width='20%'>{$this->lang->words['erlog_date']}</th>
			<th width='3%'><input type='checkbox' title="{$this->lang->words['my_checkall']}" id='checkAll' /></th>
		</tr>
HTML;

if( count($rows) AND is_array($rows) )
{
	foreach( $rows as $row )
	{
		$IPBHTML .= <<<HTML
		<tr>
			<td>{$row['mlog_to']}</td>
			<td><a href='#' onclick='return acp.openWindow("{$this->settings['base_url']}&{$this->form_code_js}&do=viewemail&id={$row['mlog_id']}",400,350,"{$row['mlog_id']}")' title='{$this->lang->words['erlog_reademail']}'>{$row['mlog_subject']}</a></td>
			<td>{$row['mlog_msg']}<br />{$row['mlog_code']}&nbsp;{$row['mlog_smtp_msg']}</td>
			<td>{$row['_date']}</td>
			<td><input type='checkbox' name='id_{$row['mlog_id']}' value='1' class='checkAll' /></td>
		</tr>
HTML;
	}
}
else
{
	$IPBHTML .= <<<HTML
		<tr>
			<td colspan='5' align='center'>{$this->lang->words['erlog_noresults']}</td>
		</tr>
HTML;
}

$IPBHTML .= <<<HTML
	</table>
	<div class="acp-actionbar">
		<div class="right">
			<input type="checkbox" id="checkbox" name="type" value="all" />&nbsp;{$this->lang->words['erlog_removeall']}&nbsp;<input type="submit" value="{$this->lang->words['erlog_removechecked']}" class="button primary" />
		</div>
		<div class="left">{$links}</div>
		<br class='clear' />
	</div>
</div>
</form>
<br />

<form action='{$this->settings['base_url']}{$this->form_code}' method='post'>
	<input type='hidden' name='do' value='list' />
	<input type='hidden' name='_admin_auth_key' value='{$this->registry->adminFunctions->generated_acp_hash}' />

	<div class="acp-box">
		<h3>{$this->lang->words['erlog_search']}</h3>
		<table class='ipsTable double_pad'>
			<tr>
				<td class='field_title'><strong class='title'>{$this->lang->words['erlog_searchwhere']}</strong></td>
				<td class='field_field'>{$form['type']} {$form['match']} {$form['string']}</td>
			</tr>
		</table>
		
		<div class="acp-actionbar">
			<input value="{$this->lang->words['erlog_searchbutton']}" class="button primary" accesskey="s" type="submit" />
		</div>
	</div>
</form>

HTML;

//--endhtml--//
return $IPBHTML;
}

/**
 * Record for an email error log entry
 *
 * @param	array 		Email error log record
 * @return	string		HTML
 */
public function emailerrorlogsEmail( $row ) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<HTML
<div class="acp-box">
	<h3>{$row['mlog_subject']}</h3>
	<table class="ipsTable">
		<tr>
			<td width='15%'>{$this->lang->words['erlog_log_from']}</td>
			<td>&lt;{$row['mlog_from']}&gt;</td>
		</tr>
		<tr>
			<td width='15%'>{$this->lang->words['erlog_log_to']}</td>
			<td>&lt;{$row['mlog_to']}&gt;</td>
		</tr>
		<tr>
			<td width='15%'>{$this->lang->words['erlog_log_sent']}</td>
			<td>{$row['_date']}</td>
		</tr>
		<tr>
			<td width='15%'>{$this->lang->words['erlog_log_subject']}</td>
			<td>{$row['_subject']}</td>
		</tr>	
		<tr>
			<td colspan='2'>{$row['mlog_content']}...</td>
		</tr>
		<tr>
			<td colspan='2'>{$this->lang->words['erlog_ipberror']} {$row['mlog_msg']}
				<br />{$this->lang->words['erlog_smtpcode']} {$row['mlog_code']}
				<br />{$this->lang->words['erlog_smtperror']} {$row['mlog_smtp_error']}
			</td>
		</tr>
	</table>
</div>
<br />
HTML;

//--endhtml--//
return $IPBHTML;
}

}