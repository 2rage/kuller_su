<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 3               */
/* CACHE FILE: Generated: Wed, 08 May 2013 03:43:51 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_post_3 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['pollBox'] = array('hasPollQuestions','hasPollChoices','hasPollVotes','hasPollMulti','viewPollVoters','allowPublicPoll','pollOnlyChecked','makePollOnly');
$this->_funcHooks['postFormTemplate'] = array('calendarlocale','open_close_perm','pollboxHtml','htmlstatus','tracking','enablesig','mod_options_check','open_time_check','close_time_check','showModOptions','checkShowEdit','showappendedit','showeditreason','edit_options_check','guestCaptcha','logged_in_check','edit_title_check','hazTag','edit_tags_check','statusMsgs','upload_form_check','shareEnabled','cancelposting','hazTag','edit_tags_check');
$this->_funcHooks['preview'] = array('disablelightbox','postpreview');
$this->_funcHooks['topicSummary'] = array('isGuest','ignoringpost','posts','topicsummaryposts');
$this->_funcHooks['uploadForm'] = array('unlimitedSpace','attachNotAllowed','canUseFlash','flashuploadhelp','helpMessage');


}

/* -- attachiFrame --*/
function attachiFrame($JSON, $id) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- errors --*/
function errors($data="") {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- pollBox --*/
function pollBox($data) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_post', $this->_funcHooks['pollBox'] ) )
{
$count_2f56f1e92e6ab30d2c6e0bda4502139e = is_array($this->functionData['pollBox']) ? count($this->functionData['pollBox']) : 0;
$this->functionData['pollBox'][$count_2f56f1e92e6ab30d2c6e0bda4502139e]['data'] = $data;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- postFormTemplate --*/
function postFormTemplate($formData=array(), $form = array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_post', $this->_funcHooks['postFormTemplate'] ) )
{
$count_24d66b9ec888868e2d09e3ac6581959c = is_array($this->functionData['postFormTemplate']) ? count($this->functionData['postFormTemplate']) : 0;
$this->functionData['postFormTemplate'][$count_24d66b9ec888868e2d09e3ac6581959c]['formData'] = $formData;
$this->functionData['postFormTemplate'][$count_24d66b9ec888868e2d09e3ac6581959c]['form'] = $form;
}
$IPBHTML .= "<postingForm>
				" . (($formData['formType'] == 'new' OR ( $formData['formType'] == 'edit')) ? ("" . (($formData['tagBox']) ? ("
{$formData['tagBox']}
					") : ("")) . "") : ("")) . "
	<submitURL><![CDATA[{$this->settings['base_url']}]]></submitURL>
	<st>{$this->request['st']}</st>
	<app>forums</app>
	<module>post</module>
	<section>post</section>
	<do>{$form['doCode']}</do>
	<s>{$this->member->session_id}</s>
	<p>{$form['p']}</p>
	<t>{$form['t']}</t>
	<f>{$form['f']}</f>
	<parent_id>{$form['parent']}</parent_id>
	<attach_post_key>{$form['attach_post_key']}</attach_post_key>
	<auth_key>{$this->member->form_hash}</auth_key>
	<removeattachid>0</removeattachid>
	<return>{$this->request['return']}</return>
	<_from>{$this->request['_from']}</_from>
	{$formData['editor']}
</postingForm>";
return $IPBHTML;
}

/* -- preview --*/
function preview($data="") {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_post', $this->_funcHooks['preview'] ) )
{
$count_a1f70896dd4a9a1d03f43cccad3f0ad0 = is_array($this->functionData['preview']) ? count($this->functionData['preview']) : 0;
$this->functionData['preview'][$count_a1f70896dd4a9a1d03f43cccad3f0ad0]['data'] = $data;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- topicSummary --*/
function topicSummary($posts=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_post', $this->_funcHooks['topicSummary'] ) )
{
$count_60e460ded8b784c52944e108e8349a19 = is_array($this->functionData['topicSummary']) ? count($this->functionData['topicSummary']) : 0;
$this->functionData['topicSummary'][$count_60e460ded8b784c52944e108e8349a19]['posts'] = $posts;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- uploadForm --*/
function uploadForm($post_key="",$type="",$stats=array(),$id="",$forum_id=0) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_post', $this->_funcHooks['uploadForm'] ) )
{
$count_28d27735e079b1a3bc3b8a5c5ad9ad47 = is_array($this->functionData['uploadForm']) ? count($this->functionData['uploadForm']) : 0;
$this->functionData['uploadForm'][$count_28d27735e079b1a3bc3b8a5c5ad9ad47]['post_key'] = $post_key;
$this->functionData['uploadForm'][$count_28d27735e079b1a3bc3b8a5c5ad9ad47]['type'] = $type;
$this->functionData['uploadForm'][$count_28d27735e079b1a3bc3b8a5c5ad9ad47]['stats'] = $stats;
$this->functionData['uploadForm'][$count_28d27735e079b1a3bc3b8a5c5ad9ad47]['id'] = $id;
$this->functionData['uploadForm'][$count_28d27735e079b1a3bc3b8a5c5ad9ad47]['forum_id'] = $forum_id;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}


}


/*--------------------------------------------------*/
/* END OF FILE                                      */
/*--------------------------------------------------*/

?>