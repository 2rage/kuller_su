<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 2               */
/* CACHE FILE: Generated: Wed, 08 May 2013 03:43:51 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_register_2 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['completePartialLogin'] = array('reqCfieldDescSpan','custom_required','optCfieldDescSpan','custom_optional','hasAName','partialLoginErrors','fbDNInner','fbDisplayName','partialAllowDnames','partialNoEmail','reqCfields','optCfields','partialCustomFields','reqCfieldDesc','reqCfieldDescSpan','custom_required','optCfieldDesc','optCfieldDescSpan','custom_optional','partialLoginErrors','partialAllowDnames','partialNoEmail','reqCfields','optCfields','partialCustomFields');
$this->_funcHooks['lostPasswordForm'] = array('lostPasswordErrors','lostPasswordErrors');
$this->_funcHooks['registerCoppaForm'] = array('coppaConsentExtra','coppaConsentExtra');
$this->_funcHooks['registerCoppaStart'] = array('coppaMRange','coppaDRange','coppaYRange','useCoppa');
$this->_funcHooks['registerForm'] = array('general_errors','statesJs','isCountrySelect','isCountryWords','options','states','statesCountries','isAddressOrPhone','isAddress2','isAddress1','textRequired','textErrorMessage','isText','dropdownRequired','isCountry','dropdownErrorMessage','isDropdown','specialRequired','specialErrorMessage','isSpecial','fields','reqCfieldDescSpan','custom_required','optCfieldDescSpan','custom_optional','registerHasErrors','registerUsingFb','twitterBox','registerServices','registerHasInlineErrors','ieDnameClass','ieDname','ieEmailClass','ieEmail','iePasswordClass','iePassword','hasNexusFields','reqCfields','optCfields','hasCfields','defaultAAE','checkedTOS','ieDnameClass','ieTOS','privvy','general_errors','reqCfieldDescSpan','custom_required','optCfieldDescSpan','custom_optional','registerHasErrors','ieDname','ieDname','ieEmail','ieEmail','iePassword','iePassword','reqCfields','optCfields','hasCfields','defaultAAE','useCoppa');
$this->_funcHooks['showLostpassForm'] = array('lostpassFormErrors','lpFormMethodChoose','lostpassFormErrors','lpFormMethodChoose');
$this->_funcHooks['showRevalidateForm'] = array('revalidateError','revalidateError');


}

/* -- completePartialLogin --*/
function completePartialLogin($mid="",$key="",$custom_fields="",$errors="", $reg="", $userFromService=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['completePartialLogin'] ) )
{
$count_a1bffcf5eb89786faa5301472538e2cc = is_array($this->functionData['completePartialLogin']) ? count($this->functionData['completePartialLogin']) : 0;
$this->functionData['completePartialLogin'][$count_a1bffcf5eb89786faa5301472538e2cc]['mid'] = $mid;
$this->functionData['completePartialLogin'][$count_a1bffcf5eb89786faa5301472538e2cc]['key'] = $key;
$this->functionData['completePartialLogin'][$count_a1bffcf5eb89786faa5301472538e2cc]['custom_fields'] = $custom_fields;
$this->functionData['completePartialLogin'][$count_a1bffcf5eb89786faa5301472538e2cc]['errors'] = $errors;
$this->functionData['completePartialLogin'][$count_a1bffcf5eb89786faa5301472538e2cc]['reg'] = $reg;
$this->functionData['completePartialLogin'][$count_a1bffcf5eb89786faa5301472538e2cc]['userFromService'] = $userFromService;
}
$IPBHTML .= "" . ((isset( $errors ) && $errors) ? ("
	<p class='message error'>
		<strong>{$this->lang->words['errors_found']}</strong><br />
		{$errors}
	</p>
") : ("")) . "
<form action=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=global&amp;section=register&amp;do=complete_login_do&amp;key=$key&amp;mid=$mid", "public",'' ), "", "" ) . "\" method=\"POST\">
	<input type=\"hidden\" name=\"termsread\" value=\"1\" />
	<input type=\"hidden\" name=\"agree_to_terms\" value=\"1\" />
	
	<h2>{$this->lang->words['clogin_title']}</h2>
	<p class='message'>{$this->lang->words['clogin_text']}</p>
	<br />
	<div class='post_form'>
		<h3 class='bar'>{$this->lang->words['complete_form']}</h3>
		" . (($this->settings['auth_allow_dnames'] == 1) ? ("
			<fieldset class='row2'>
				<ul>
					<li class='field'>
						<label for='dname'>{$this->lang->words['dname_name']}</label>
						<input id='dname' type=\"text\" size=\"50\" maxlength=\"64\" value=\"{$this->request['members_display_name']}\" name=\"members_display_name\" />
					</li>
				</ul>
			</fieldset>
		") : ("")) . "
		" . ((! $reg['partial_email_ok']) ? ("
			<fieldset class='row1'>
				<ul>
					<li class='field'>
						<label for='email'>{$this->lang->words['email_address']}</label>
						<input id='email' type=\"text\" size=\"25\" maxlength=\"50\" value=\"{$this->request['EmailAddress']}\" name=\"EmailAddress\" />
					</li>
					<li class='field'>
						<label for='email_confirm'>{$this->lang->words['email_address_confirm']}</label>
						<input id='email_confirm' type=\"text\" size=\"25\" maxlength=\"50\"  value=\"{$this->request['EmailAddress_two']}\" name=\"EmailAddress_two\" />
					</li>
				</ul>
			</fieldset>
		") : ("")) . "
		" . (($custom_fields != '') ? ("<fieldset class='row1'>
				<ul>
				" . ((is_array( $custom_fields['required'] ) && count( $custom_fields['required'] )) ? ("
					".$this->__f__d4ea9ed781fbd314a861633b460df7d5($mid,$key,$custom_fields,$errors,$reg,$userFromService)."				") : ("")) . "
				
				" . ((is_array( $custom_fields['optional'] ) && count( $custom_fields['optional'] )) ? ("
					".$this->__f__171f62ff7a5fc3d2e07d2fbd3f194d37($mid,$key,$custom_fields,$errors,$reg,$userFromService)."				") : ("")) . "
			</fieldset>") : ("")) . "
		<fieldset class='submit'>
			<input type='submit' value='{$this->lang->words['clogin_submit']}' class='input_submit' />
		</fieldset>
	</div>
</form>";
return $IPBHTML;
}


function __f__d4ea9ed781fbd314a861633b460df7d5($mid="",$key="",$custom_fields="",$errors="", $reg="", $userFromService=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $custom_fields['required'] as $_field )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
						" . (($_field['desc'] == '') ? ("
							<li class='field nodesc required {$_field['type']}'>
						") : ("
							<li class='field required {$_field['type']}'>
						")) . "
								<label for='cprofile_{$_field['id']}'>{$_field['name']}</label>
								{$_field['field']}
								" . (($_field['desc'] != '') ? ("<span class='desc'>{$_field['desc']}</span>") : ("")) . "
							</li>
					
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__171f62ff7a5fc3d2e07d2fbd3f194d37($mid="",$key="",$custom_fields="",$errors="", $reg="", $userFromService=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $custom_fields['optional'] as $_field )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
						" . (($_field['desc'] == '') ? ("
							<li class='field nodesc optional {$_field['type']}'>
						") : ("
							<li class='field optional {$_field['type']}'>
						")) . "
								<label for='cprofile_{$_field['id']}'>{$_field['name']}</label>
								{$_field['field']}
								" . (($_field['desc'] != '') ? ("<span class='desc'>{$_field['desc']}</span>") : ("")) . "
							</li>
					
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- lostPasswordForm --*/
function lostPasswordForm($errors="") {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['lostPasswordForm'] ) )
{
$count_3a3127e77194fad0d836187cb96c37af = is_array($this->functionData['lostPasswordForm']) ? count($this->functionData['lostPasswordForm']) : 0;
$this->functionData['lostPasswordForm'][$count_3a3127e77194fad0d836187cb96c37af]['errors'] = $errors;
}
$IPBHTML .= "<h2>{$this->lang->words['lost_pass_form']}</h2>
" . ((isset( $errors ) && $errors) ? ("
	<p class='message error'>
		<strong>{$this->lang->words['errors_found']}</strong><br />
		{$errors}
	</p>
") : ("")) . "
<p class='message unspecific'>
	{$this->lang->words['lost_your_password']}
	{$this->lang->words['lp_text']}
</p>
<form action=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&module=global&section=lostpass", "public",'' ), "", "" ) . "\" method=\"post\">
<input type=\"hidden\" name=\"do\" value=\"11\" />
<div class='generic_bar'></div>
<div id='lost_pass_form' class='post_form'>
	<fieldset>
		<h3 class='bar'>{$this->lang->words['recover_password']}</h3>
		<ul>
			<li class='field'>
				<label for='member_name'>{$this->lang->words['lp_user_name']}</label>
				<input type=\"text\" size=\"32\" name=\"member_name\" id='member_name' class='input_text' />
			</li>
			<li class='field'>
				<label for='email_addy'>{$this->lang->words['lp_email_or']}</label>
				<input type=\"text\" size=\"32\" name=\"email_addy\" id='email_addy' class='input_text' />
			</li>
		</ul>
	</fieldset>
	<!--{REG.ANTISPAM}-->
	<fieldset class='submit'>
			<input class='input_submit' type=\"submit\" value=\"{$this->lang->words['lp_send']}\" /> {$this->lang->words['or']} <a href='{$this->settings['board_url']}' title='{$this->lang->words['cancel']}' class='cancel'>{$this->lang->words['cancel']}</a>
	</fieldset>
</div>
</form>";
return $IPBHTML;
}

/* -- lostPasswordWait --*/
function lostPasswordWait($member="") {
$IPBHTML = "";
$IPBHTML .= "<h2>{$this->lang->words['lpf_title']}</h2>
<p class='message'>
	{$this->lang->words['lpass_text']}
</p>";
return $IPBHTML;
}

/* -- registerCoppaForm --*/
function registerCoppaForm() {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['registerCoppaForm'] ) )
{
$count_17a2fd84bf5fac49e6d5782b72e02a91 = is_array($this->functionData['registerCoppaForm']) ? count($this->functionData['registerCoppaForm']) : 0;
}
$IPBHTML .= "<html>
	<head>
		<meta http-equiv=\"content-type\" content=\"text/html; charset=<% CHARSET %>\" />
		<title>{$this->lang->words['cpf_title']}</title>
	</head>
	
	<body>
	<h2>{$this->settings['board_name']}: {$this->lang->words['cpf_title']}</h2>
	" . (($this->settings['coppa_consent_extra']) ? ("
		<div>
			<b>{$this->lang->words['coppa_additional_info']}</b>
			<div>{$this->settings['coppa_consent_extra']}</div>
		</div>
	") : ("")) . "
	<hr />
	<div>
		<b>{$this->lang->words['cpf_perm_parent']}</b>
		<div style='padding:8px;'>{$this->lang->words['cpf_fax']} <u>{$this->settings['coppa_fax']}</u></div>
		<div style='padding:8px;'>{$this->lang->words['cpf_address']}<br />
			<address>{$this->settings['coppa_address']}</address>
		</div>
	</div>
	<hr />
	<div>	
		<table class='ipbtable' cellspacing=\"1\" cellpadding='8'>
			<tr>
				<td width=\"40%\">{$this->lang->words['user_name']}</td>
				<td style='text-decoration:underline;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td width=\"40%\">{$this->lang->words['password']}</td>
				<td style='text-decoration:underline;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td width=\"40%\">{$this->lang->words['email_address']}</td>
				<td style='text-decoration:underline;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
		</table>
	</div>
	<hr />
	<div>
		<b>{$this->lang->words['cpf_sign']}</b>
	</div>
	<br />
	<div>
		<table class='ipbtable' cellspacing=\"1\" cellpadding='8'>
			<tr>
				<td width=\"40%\">{$this->lang->words['cpf_name']}</td>
				<td style='text-decoration:underline;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td width=\"40%\">{$this->lang->words['cpf_relation']}</td>
				<td style='text-decoration:underline;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td width=\"40%\">{$this->lang->words['cpf_signature']}</td>
				<td style='text-decoration:underline;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td width=\"40%\">{$this->lang->words['cpf_email']}</td>
				<td style='text-decoration:underline;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td width=\"40%\">{$this->lang->words['cpf_phone']}</td>
				<td style='text-decoration:underline;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td width=\"40%\">{$this->lang->words['cpf_date']}</td>
				<td style='text-decoration:underline;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
		</table>
	</div>
	<hr />
	<div><b>{$this->lang->words['coppa_admin_reminder']}</b>
		<div>{$this->lang->words['coppa_admin_remtext']}</div>
	</div>
	</body>
</html>";
return $IPBHTML;
}

/* -- registerCoppaStart --*/
function registerCoppaStart() {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['registerCoppaStart'] ) )
{
$count_9d19e06096a02bd371eb002ae33196df = is_array($this->functionData['registerCoppaStart']) ? count($this->functionData['registerCoppaStart']) : 0;
}
$IPBHTML .= "<form action='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=global&amp;section=register&amp;do=coppa_two&amp;coppa=1", "public",'' ), "", "" ) . "' method='post'>
	<div class='master_list'>
		<h2>{$this->lang->words['register']}</h2>
		<div class='row post line_spacing'>
			{$this->lang->words['confirm_over_thirteen']}
		</div>
	
		<div class='submit'>
			<input type='submit' value='{$this->lang->words['coppa_continue_button']}' class='button' /> &nbsp;&nbsp;
			<a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=global&amp;section=register&amp;do=coppa_two", "public",'' ), "", "" ) . "' title='{$this->lang->words['coppa_under_thirteen']}' class='cancel'>{$this->lang->words['coppa_under_thirteen']}</a>
		</div>
	</div>
</form>";
return $IPBHTML;
}

/* -- registerCoppaTwo --*/
function registerCoppaTwo() {
$IPBHTML = "";
$IPBHTML .= "<div class='master_list'>
	<h2>{$this->lang->words['register']}</h2>
	<h3>{$this->lang->words['cp2_title']}</h3>
	
	<div class='row line_spacing'>
		{$this->lang->words['cp2_text']}<br /><br />
		<strong><a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=global&amp;section=register&amp;do=12", "public",'' ), "", "" ) . "' title='Print form'>{$this->lang->words['coppa_clickhere']}</a></strong>
		<br />
		{$this->lang->words['coppa_form_text']} <a href=\"mailto:{$this->settings['email_in']}\">{$this->settings['email_in']}</a>
	</div>
	<div class='submit'>
		<a href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=global&amp;section=register&amp;do=coppa_one", "public",'' ), "", "" ) . "' title='{$this->lang->words['cancel']}' class='cancel'>{$this->lang->words['cancel']}</a>
	</div>
</div>";
return $IPBHTML;
}

/* -- registerForm --*/
function registerForm($general_errors=array(), $data=array(), $inline_errors=array(), $time_select=array(), $custom_fields=array(), $nexusFields=array(), $nexusStates=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['registerForm'] ) )
{
$count_f0dc72cf98e3d505c2de0bda0772cdf8 = is_array($this->functionData['registerForm']) ? count($this->functionData['registerForm']) : 0;
$this->functionData['registerForm'][$count_f0dc72cf98e3d505c2de0bda0772cdf8]['general_errors'] = $general_errors;
$this->functionData['registerForm'][$count_f0dc72cf98e3d505c2de0bda0772cdf8]['data'] = $data;
$this->functionData['registerForm'][$count_f0dc72cf98e3d505c2de0bda0772cdf8]['inline_errors'] = $inline_errors;
$this->functionData['registerForm'][$count_f0dc72cf98e3d505c2de0bda0772cdf8]['time_select'] = $time_select;
$this->functionData['registerForm'][$count_f0dc72cf98e3d505c2de0bda0772cdf8]['custom_fields'] = $custom_fields;
$this->functionData['registerForm'][$count_f0dc72cf98e3d505c2de0bda0772cdf8]['nexusFields'] = $nexusFields;
$this->functionData['registerForm'][$count_f0dc72cf98e3d505c2de0bda0772cdf8]['nexusStates'] = $nexusStates;
}
$IPBHTML .= "" . (($this->settings['use_coppa'] && (!$this->request['coppa'] && !IPSCookie::get('coppa'))) ? ("
	" . ( method_exists( $this->registry->getClass('output')->getTemplate('register'), 'registerCoppaStart' ) ? $this->registry->getClass('output')->getTemplate('register')->registerCoppaStart() : '' ) . "
") : ("" . ((!$this->request['agree_tos']) ? ("
		<div class='master_list'>
			<h2>{$this->lang->words['reg_terms_popup_title']}</h2>
			<div class='row post line_spacing'>
				{$this->settings['_termsAndConditions']}
			</div>
			<div class='submit'>
				<a class='button secondary' href='" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=global&amp;section=register&amp;agree_tos=1", "public",'' ), "", "" ) . "'>{$this->lang->words['mobile_agree_to_tos']}</a>
			</div>
		</div>
	") : ("<div class='master_list'>
			<h2>{$this->lang->words['register']}</h2>
			" . ((is_array( $general_errors ) && count( $general_errors )) ? ("
				<div class='message error'>
					<strong>{$this->lang->words['following_errors']}</strong><br />
					".$this->__f__3cb818d614debbbc48310d69411d856f($general_errors,$data,$inline_errors,$time_select,$custom_fields,$nexusFields,$nexusStates)."				</div>
			") : ("")) . "
	
			<form class='ipsForm_vertical' action=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=global&amp;section=register", "public",'' ), "", "" ) . "\" method=\"post\" name=\"REG\" id='register'>
				<input type=\"hidden\" name=\"termsread\" value=\"1\" />
				<input type=\"hidden\" name=\"agree_to_terms\" value=\"1\" />
				<input type=\"hidden\" name=\"agree_tos\" value=\"1\" />
				<input type=\"hidden\" name=\"do\" value=\"process_form\" />
				<input type=\"hidden\" name=\"coppa_user\" value=\"{$data['coppa_user']}\" />
				<input type='hidden' name='nexus_pass' value='1' />
		
				<h3>{$this->lang->words['reg_step1']}</h3>
				<div class='ipsField'>
					<label for='display_name' class='ipsField_title'>{$this->lang->words['reg_choose_dname']}</label>
					<input type='text' class='input_text " . (($inline_errors['dname']) ? ("error") : ("")) . "' id='display_name' size='30' maxlength='{$this->settings['max_user_name_length']}' value='{$this->request['members_display_name']}' name='members_display_name' /><br />
					<span class='desc'>" . (($inline_errors['dname']) ? ("<span class='error'>{$inline_errors['dname']}<br /></span>") : ("")) . "" . sprintf( $this->lang->words['dname_desc'], $this->settings['max_user_name_length']) . "</span>
				</div>
		
				<div class='ipsField'>
					<label for='email_1' class='ipsField_title'>{$this->lang->words['reg_enter_email']}</label>
					<input type='text' id='email_1' class='input_text email " . (($inline_errors['email']) ? ("error") : ("")) . "' size='30' maxlength='150' name='EmailAddress' value='{$this->request['EmailAddress']}' /><br />
					<span class='desc'>" . (($inline_errors['email']) ? ("<span class='error'>{$inline_errors['email']}<br /></span>") : ("")) . "{$this->lang->words['reg_enter_email_desc']}</span>
				</div>
	
		
				<div class='ipsField'>
					<label for='password_1' class='ipsField_title'>{$this->lang->words['reg_choose_password']}</label>
					<input type='password' id='password_1' class='input_text password " . (($inline_errors['password']) ? ("error") : ("")) . "' size='30' maxlength='32' value='{$this->request['PassWord']}' name='PassWord' /><br />
					<span class='desc'>" . (($inline_errors['password']) ? ("<span class='error'>{$inline_errors['password']}<br /></span>") : ("")) . "{$this->lang->words['reg_choose_password_desc']}</span>
				</div>
		
				<div class='ipsField'>
					<label for='password_2' class='ipsField_title'>{$this->lang->words['reg_reenter_password']}</label>
					<input type='password' id='password_2' class='input_text password' size='30' maxlength='32' value='{$this->request['PassWord_Check']}' name='PassWord_Check' />
				</div>
		
				" . ((( is_array( $custom_fields['required'] ) && count( $custom_fields['required'] ) ) || ( is_array( $custom_fields['optional'] ) && count( $custom_fields['optional'] ) )) ? ("<div class='row line_spacing'>
						" . ((is_array( $custom_fields['required'] ) && count( $custom_fields['required'] )) ? ("
							".$this->__f__1204ca98cecae74ee2d0c0fe2a890735($general_errors,$data,$inline_errors,$time_select,$custom_fields,$nexusFields,$nexusStates)."						") : ("")) . "
				
						" . ((is_array( $custom_fields['optional'] ) && count( $custom_fields['optional'] )) ? ("
							".$this->__f__d081c3a8d165cf9a45d0230211e43f3d($general_errors,$data,$inline_errors,$time_select,$custom_fields,$nexusFields,$nexusStates)."						") : ("")) . "
						<!--IBF.MODULES.EXTRA-->
					</div>") : ("")) . "
		
				" . (($data['captchaHTML'] || $data['qandaHTML']) ? ("
					<h3>{$this->lang->words['reg_step3_spam']}</h3>
					{$data['qandaHTML']}
					{$data['captchaHTML']}
				") : ("")) . "
			
				<div class='ipsField ipsField_checkbox'>
					<input type=\"checkbox\" name=\"allow_admin_mail\" id=\"allow_admin_mail\" value=\"1\" class=\"input_check\" " . (($this->request['allow_admin_mail'] || !isset( $this->request['allow_admin_mail'] )) ? ("checked='checked'") : ("")) . " />
					<p class='ipsField_content'>{$this->lang->words['receive_admin_emails']}</p>
				</div>
				<div class='submit'>
					<input type='submit' class='button' value='{$this->lang->words['register']}' />
				</div>
			</form>
	
		</div>")) . "")) . "";
return $IPBHTML;
}


function __f__3cb818d614debbbc48310d69411d856f($general_errors=array(), $data=array(), $inline_errors=array(), $time_select=array(), $custom_fields=array(), $nexusFields=array(), $nexusStates=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $general_errors as $r )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
						{$r}<br />
					
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__1204ca98cecae74ee2d0c0fe2a890735($general_errors=array(), $data=array(), $inline_errors=array(), $time_select=array(), $custom_fields=array(), $nexusFields=array(), $nexusStates=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $custom_fields['required'] as $_field )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
								{$_field['name']}<br />
								{$_field['field']}<br />
								" . (($_field['desc'] != '') ? ("<span class='desc'>{$_field['desc']}</span><br />") : ("")) . "
								<br />
							
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

function __f__d081c3a8d165cf9a45d0230211e43f3d($general_errors=array(), $data=array(), $inline_errors=array(), $time_select=array(), $custom_fields=array(), $nexusFields=array(), $nexusStates=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $custom_fields['optional'] as $_field )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
								{$_field['name']}<br />
								{$_field['field']}<br />
								" . (($_field['desc'] != '') ? ("<span class='desc'>{$_field['desc']}</span><br />") : ("")) . "
								<br />
							
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- registerStepBar --*/
function registerStepBar($step) {
$IPBHTML = "";
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- show_lostpass_form_auto --*/
function show_lostpass_form_auto($aid="",$uid="") {
$IPBHTML = "";
$IPBHTML .= "<input type=\"hidden\" name=\"uid\" value=\"{$uid}\" />
<input type=\"hidden\" name=\"aid\" value=\"{$aid}\" />";
return $IPBHTML;
}

/* -- show_lostpass_form_manual --*/
function show_lostpass_form_manual() {
$IPBHTML = "";
$IPBHTML .= "<h3 class='bar'>{$this->lang->words['lpf_title']}</h3>
	<ul>
		<li class='field'>
			<label for='user_id'>{$this->lang->words['user_id']}</label>
			<input type=\"text\" size=\"32\" maxlength=\"32\" name=\"uid\" id='user_id' class='input_text' />
		</li>
		<li class='field'>
			<label for='aid'>{$this->lang->words['val_key']}</label>
			<input type=\"text\" size=\"32\" maxlength=\"50\" name=\"aid\" id='aid' class='input_text' />
		</li>
	</ul>";
return $IPBHTML;
}

/* -- showAuthorize --*/
function showAuthorize($member="") {
$IPBHTML = "";
$IPBHTML .= "<h2>{$this->lang->words['registration_process']}</h2>
<div class='master_list'>
	<div class='row post line_spacing'>	
		" . sprintf( $this->lang->words['auth_text'], $member['members_display_name'], $member['email'] ) . "
	</div>
</div>";
return $IPBHTML;
}

/* -- showLostpassForm --*/
function showLostpassForm($error) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['showLostpassForm'] ) )
{
$count_4dfdc30bb58a5e7d1424c92d386da312 = is_array($this->functionData['showLostpassForm']) ? count($this->functionData['showLostpassForm']) : 0;
$this->functionData['showLostpassForm'][$count_4dfdc30bb58a5e7d1424c92d386da312]['error'] = $error;
}
$IPBHTML .= "<h2>{$this->lang->words['dumb_header']}</h2>
<div class='ipsType_pageinfo'>
	{$this->lang->words['dumb_text']}
</div>
" . ((!empty( $error )) ? ("
	<p class='message error'>
		{$error}
	</p>
") : ("")) . "
<form action=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&module=global&section=lostpass", "public",'' ), "", "" ) . "\" method=\"post\">
<input type=\"hidden\" name=\"do\" value=\"03\" />
<input type=\"hidden\" name=\"type\" value=\"lostpass\" />
<div class='generic_bar'></div>
	<div class='post_form'>
		<!--IBF.INPUT_TYPE-->
		<h3 class='bar'>{$this->lang->words['new_password']}</h3>
		" . (($this->settings['lp_method'] == 'choose') ? ("
			<ul>
				<li class='field'>
					<label for=\"pass1\">{$this->lang->words['lpf_pass1']}</label>
					<input type=\"password\" size=\"32\" maxlength=\"32\" name=\"pass1\" id='pass1' class='input_text' />
					<br /><span class='desc'>{$this->lang->words['lpf_pass11']}</span>
				</li>
				<li class='field'>
					<label for=\"pass2\">{$this->lang->words['lpf_pass2']}</label>
					<input type=\"password\" size=\"32\" maxlength=\"32\" name=\"pass2\" id='pass2' class='input_text' />
					<br /><span class='desc'>{$this->lang->words['lpf_pass22']}</span>
				</li>
			</ul>
		") : ("
			<p class='field'>
		 		{$this->lang->words['lp_random_pass']}
			</p>
		")) . "
		<!--{REG.ANTISPAM}-->
		<fieldset class='submit'>
			<input class='input_submit' type=\"submit\" value=\"{$this->lang->words['dumb_submit']}\" />
		</fieldset>
	</div>
</form>";
return $IPBHTML;
}

/* -- showLostPassWaitRandom --*/
function showLostPassWaitRandom($member="") {
$IPBHTML = "";
$IPBHTML .= "<h2>{$this->lang->words['lpf_title']}</h2>
<p class='message'>
	{$this->lang->words['lpass_text_random']}
</p>";
return $IPBHTML;
}

/* -- showManualForm --*/
function showManualForm($type="reg") {
$IPBHTML = "";
$IPBHTML .= "<h2>{$this->lang->words['dumb_header']}</h2>
<form action=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "", "public",'' ), "", "" ) . "\" method=\"post\" name=\"REG\">
<input type=\"hidden\" name=\"app\" value=\"core\" />
<input type=\"hidden\" name=\"module\" value=\"global\" />
<input type=\"hidden\" name=\"section\" value=\"register\" />
<input type=\"hidden\" name=\"do\" value=\"auto_validate\" />
<input type=\"hidden\" name=\"type\" value=\"$type\" />
<div class='generic_bar'></div>
<div class='post_form'>
	<fieldset class='row1'>
		<h3 class='bar'>{$this->lang->words['complete_form']}</h3>
		<ul>
			<li class='field'>
				<label for='userid'>{$this->lang->words['user_id']}</label>
				<input type=\"text\" size=\"32\" maxlength=\"32\" name=\"uid\" id='userid' class='input_text' />
			</li>
			<li class='field'>
				<label for='valkey'>{$this->lang->words['val_key']}</label>
				<input type=\"text\" size=\"32\" maxlength=\"50\" name=\"aid\" id='valkey' class='input_text' />
			</li>
		</ul>
	</fieldset>
	<fieldset class='submit'>
		<input class='input_submit' type=\"submit\" value=\"{$this->lang->words['dumb_submit']}\" />
	</fieldset>
</div>
</form>";
return $IPBHTML;
}

/* -- showPreview --*/
function showPreview($member="") {
$IPBHTML = "";
$IPBHTML .= "<h2>{$this->lang->words['registration_process']}</h2>
<p class='message'>
	{$this->lang->words['thank_you']} {$member['members_display_name']}. {$this->lang->words['preview_reg_text']}
</p>";
return $IPBHTML;
}

/* -- showRevalidated --*/
function showRevalidated() {
$IPBHTML = "";
$IPBHTML .= "<h2>{$this->lang->words['rv_title']}</h2>
<p class='message'>
	{$this->lang->words['rv_process']}<br />
	{$this->lang->words['rv_done']}
</p>";
return $IPBHTML;
}

/* -- showRevalidateForm --*/
function showRevalidateForm($name="",$error="") {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['showRevalidateForm'] ) )
{
$count_5dfdcd1d500d53dbfbc3790b0fe89a8c = is_array($this->functionData['showRevalidateForm']) ? count($this->functionData['showRevalidateForm']) : 0;
$this->functionData['showRevalidateForm'][$count_5dfdcd1d500d53dbfbc3790b0fe89a8c]['name'] = $name;
$this->functionData['showRevalidateForm'][$count_5dfdcd1d500d53dbfbc3790b0fe89a8c]['error'] = $error;
}
$IPBHTML .= "<h2>{$this->lang->words['rv_title']}</h2>
" . (($error) ? ("
<p class='message error'>{$this->lang->words[$error]}</p>
<br />
") : ("")) . "
<form action=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=global&amp;section=register", "public",'' ), "", "" ) . "\" method=\"post\" name=\"REG\">
<input type=\"hidden\" name=\"do\" value=\"reval2\" />
	<p class='message unspecific'>
		{$this->lang->words['rv_ins']}
	</p>
	
	<div class='post_form'>
		<fieldset class='general_box'>
			<h3>{$this->lang->words['rv_bar_title']}</h3>
			<label for='username'>{$this->lang->words['rv_name']}</label>
			<input type=\"text\" class='input_text' id='username' size=\"32\" maxlength=\"64\" name=\"username\" value=\"$name\" />
		</fieldset>
		<fieldset class='submit'>
			<input class='input_submit' type=\"submit\" value=\"{$this->lang->words['rv_go']}\" /> {$this->lang->words['or']} <a href='{$this->settings['board_url']}' title='{$this->lang->words['cancel']}' class='cancel'>{$this->lang->words['cancel']}</a>
		</fieldset>
	</div>
</form>";
return $IPBHTML;
}


}


/*--------------------------------------------------*/
/* END OF FILE                                      */
/*--------------------------------------------------*/

?>