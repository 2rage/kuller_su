<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 3               */
/* CACHE FILE: Generated: Wed, 08 May 2013 03:43:51 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_register_3 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['completePartialLogin'] = array('reqCfieldDescSpan','custom_required','optCfieldDescSpan','custom_optional','hasAName','partialLoginErrors','fbDNInner','fbDisplayName','partialAllowDnames','partialNoEmail','reqCfields','optCfields','partialCustomFields');
$this->_funcHooks['lostPasswordForm'] = array('lostPasswordErrors');
$this->_funcHooks['registerCoppaForm'] = array('coppaConsentExtra');
$this->_funcHooks['registerCoppaStart'] = array('coppaMRange','coppaDRange','coppaYRange','useCoppa');
$this->_funcHooks['registerForm'] = array('general_errors','statesJs','isCountrySelect','isCountryWords','options','states','statesCountries','isAddressOrPhone','isAddress2','isAddress1','textRequired','textErrorMessage','isText','dropdownRequired','isCountry','dropdownErrorMessage','isDropdown','specialRequired','specialErrorMessage','isSpecial','fields','reqCfieldDescSpan','custom_required','optCfieldDescSpan','custom_optional','registerHasErrors','registerUsingFb','twitterBox','registerServices','registerHasInlineErrors','ieDnameClass','ieDname','ieEmailClass','ieEmail','iePasswordClass','iePassword','hasNexusFields','reqCfields','optCfields','hasCfields','defaultAAE','checkedTOS','ieDnameClass','ieTOS','privvy');
$this->_funcHooks['showLostpassForm'] = array('lostpassFormErrors','lpFormMethodChoose');
$this->_funcHooks['showRevalidateForm'] = array('revalidateError');


}

/* -- completePartialLogin --*/
function completePartialLogin($mid="",$key="",$custom_fields="",$errors="", $reg="", $userFromService=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['completePartialLogin'] ) )
{
$count_98a94166962f6c816818bc3c3cb62c9d = is_array($this->functionData['completePartialLogin']) ? count($this->functionData['completePartialLogin']) : 0;
$this->functionData['completePartialLogin'][$count_98a94166962f6c816818bc3c3cb62c9d]['mid'] = $mid;
$this->functionData['completePartialLogin'][$count_98a94166962f6c816818bc3c3cb62c9d]['key'] = $key;
$this->functionData['completePartialLogin'][$count_98a94166962f6c816818bc3c3cb62c9d]['custom_fields'] = $custom_fields;
$this->functionData['completePartialLogin'][$count_98a94166962f6c816818bc3c3cb62c9d]['errors'] = $errors;
$this->functionData['completePartialLogin'][$count_98a94166962f6c816818bc3c3cb62c9d]['reg'] = $reg;
$this->functionData['completePartialLogin'][$count_98a94166962f6c816818bc3c3cb62c9d]['userFromService'] = $userFromService;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- lostPasswordForm --*/
function lostPasswordForm($errors="") {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['lostPasswordForm'] ) )
{
$count_a65315670acaba5a227f201ce1b552d2 = is_array($this->functionData['lostPasswordForm']) ? count($this->functionData['lostPasswordForm']) : 0;
$this->functionData['lostPasswordForm'][$count_a65315670acaba5a227f201ce1b552d2]['errors'] = $errors;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- lostPasswordWait --*/
function lostPasswordWait($member="") {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- registerCoppaForm --*/
function registerCoppaForm() {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['registerCoppaForm'] ) )
{
$count_c4288328b3c5b1be469d944e867ea1ab = is_array($this->functionData['registerCoppaForm']) ? count($this->functionData['registerCoppaForm']) : 0;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- registerCoppaStart --*/
function registerCoppaStart() {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['registerCoppaStart'] ) )
{
$count_0fde0128fda379a70bc1a995bf38d3d4 = is_array($this->functionData['registerCoppaStart']) ? count($this->functionData['registerCoppaStart']) : 0;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- registerCoppaTwo --*/
function registerCoppaTwo() {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- registerForm --*/
function registerForm($general_errors=array(), $data=array(), $inline_errors=array(), $time_select=array(), $custom_fields=array(), $nexusFields=array(), $nexusStates=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['registerForm'] ) )
{
$count_bcf87cecd964165c81cee72694261e17 = is_array($this->functionData['registerForm']) ? count($this->functionData['registerForm']) : 0;
$this->functionData['registerForm'][$count_bcf87cecd964165c81cee72694261e17]['general_errors'] = $general_errors;
$this->functionData['registerForm'][$count_bcf87cecd964165c81cee72694261e17]['data'] = $data;
$this->functionData['registerForm'][$count_bcf87cecd964165c81cee72694261e17]['inline_errors'] = $inline_errors;
$this->functionData['registerForm'][$count_bcf87cecd964165c81cee72694261e17]['time_select'] = $time_select;
$this->functionData['registerForm'][$count_bcf87cecd964165c81cee72694261e17]['custom_fields'] = $custom_fields;
$this->functionData['registerForm'][$count_bcf87cecd964165c81cee72694261e17]['nexusFields'] = $nexusFields;
$this->functionData['registerForm'][$count_bcf87cecd964165c81cee72694261e17]['nexusStates'] = $nexusStates;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- registerStepBar --*/
function registerStepBar($step) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- show_lostpass_form_auto --*/
function show_lostpass_form_auto($aid="",$uid="") {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- show_lostpass_form_manual --*/
function show_lostpass_form_manual() {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- showAuthorize --*/
function showAuthorize($member="") {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- showLostpassForm --*/
function showLostpassForm($error) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['showLostpassForm'] ) )
{
$count_7c3d1c1d549fbe29bb0eaa17f458ec87 = is_array($this->functionData['showLostpassForm']) ? count($this->functionData['showLostpassForm']) : 0;
$this->functionData['showLostpassForm'][$count_7c3d1c1d549fbe29bb0eaa17f458ec87]['error'] = $error;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- showLostPassWaitRandom --*/
function showLostPassWaitRandom($member="") {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- showManualForm --*/
function showManualForm($type="reg") {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- showPreview --*/
function showPreview($member="") {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- showRevalidated --*/
function showRevalidated() {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- showRevalidateForm --*/
function showRevalidateForm($name="",$error="") {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_register', $this->_funcHooks['showRevalidateForm'] ) )
{
$count_c80ba8f443c5255709c297ba1f9846c7 = is_array($this->functionData['showRevalidateForm']) ? count($this->functionData['showRevalidateForm']) : 0;
$this->functionData['showRevalidateForm'][$count_c80ba8f443c5255709c297ba1f9846c7]['name'] = $name;
$this->functionData['showRevalidateForm'][$count_c80ba8f443c5255709c297ba1f9846c7]['error'] = $error;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}


}


/*--------------------------------------------------*/
/* END OF FILE                                      */
/*--------------------------------------------------*/

?>