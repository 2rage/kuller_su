<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 3               */
/* CACHE FILE: Generated: Wed, 08 May 2013 03:43:51 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_modcp_3 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['deletedPosts'] = array('post_data','disablelightbox','hasPosts');
$this->_funcHooks['deletedTopics'] = array('hastopics');
$this->_funcHooks['editUserForm'] = array('editusercfielddesc','custom_fields','displaynamehistory','modPreview','postingRestricted','suspended','hasRestrictions','groupCanStatus','editusercfields');
$this->_funcHooks['latestWarnLogs'] = array('warningloop','haswarnings');
$this->_funcHooks['memberLookup'] = array('canEditMember');
$this->_funcHooks['membersList'] = array('weAreSupmod','memberwarn','sendpm','blog','gallery','norep','posrep','negrep','repson','isnotbanned','isnotbanned2','members','showmembers');
$this->_funcHooks['membersModIPForm'] = array('modIpIe');
$this->_funcHooks['membersModIPFormMembers'] = array('ipMembers','modIPMembers');
$this->_funcHooks['membersModIPFormPosts'] = array('ipPosts','modFindMemberPosts');
$this->_funcHooks['modAnnounceForm'] = array('buttonlang','announceMessage','buttonlang');
$this->_funcHooks['modAnnouncements'] = array('announce_forums','notactive','notactive','announceHasForums','announceForum','announcements','hasAnnouncements');
$this->_funcHooks['modcpMessage'] = array('hasMessage');
$this->_funcHooks['modCPpost'] = array('reputation','noRep','posRep','negRep','repIgnored','postMid','postMember','postAdmin','postIp','postIsHardDeleted','canSoftDelete','canHardDelete','hasDeletedReasonRow','hasDeletedReason','showReason','postDeletedReason','isDeleted','canEdit','approveUnapprove','approvePost','canDelete','reportedPostData','isUnapproved','postEditByReason','postEditBy','reportedPostData');
$this->_funcHooks['modCPtopic'] = array('haslastpage','pages','isLink','isLinkEnd','multipages','hasStarterId','isntLink','hasDeletedReason','showReason','topicDeletedReason','replylang','isntLink3','tidRestoreLink','canHardDeleteLinkFromDb','topicIsHardDeleted','tidRestore','canHardDeleteFromDb','isntLink4','canSoftDelete','canHardDelete','topics');
$this->_funcHooks['portalPage'] = array('tabs','accessRC');
$this->_funcHooks['subTabLoop'] = array('subTabs','isMainTab','findTab');
$this->_funcHooks['unapprovedPosts'] = array('post_data','disablelightbox','hasPosts');
$this->_funcHooks['unapprovedTopics'] = array('hastopics');


}

/* -- deletedPosts --*/
function deletedPosts($posts, $other_data=array(), $pagelinks='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['deletedPosts'] ) )
{
$count_1c70585fcb258433cd5eecdac8b071c2 = is_array($this->functionData['deletedPosts']) ? count($this->functionData['deletedPosts']) : 0;
$this->functionData['deletedPosts'][$count_1c70585fcb258433cd5eecdac8b071c2]['posts'] = $posts;
$this->functionData['deletedPosts'][$count_1c70585fcb258433cd5eecdac8b071c2]['other_data'] = $other_data;
$this->functionData['deletedPosts'][$count_1c70585fcb258433cd5eecdac8b071c2]['pagelinks'] = $pagelinks;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- deletedTopics --*/
function deletedTopics($topics, $sdelete=array(), $pagelinks='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['deletedTopics'] ) )
{
$count_ecd02c4860ab790cf688680349d5efdb = is_array($this->functionData['deletedTopics']) ? count($this->functionData['deletedTopics']) : 0;
$this->functionData['deletedTopics'][$count_ecd02c4860ab790cf688680349d5efdb]['topics'] = $topics;
$this->functionData['deletedTopics'][$count_ecd02c4860ab790cf688680349d5efdb]['sdelete'] = $sdelete;
$this->functionData['deletedTopics'][$count_ecd02c4860ab790cf688680349d5efdb]['pagelinks'] = $pagelinks;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- editUserForm --*/
function editUserForm($profile, $custom_fields=null) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['editUserForm'] ) )
{
$count_de5f6e095e8957f16daaf4a3f5a51fe0 = is_array($this->functionData['editUserForm']) ? count($this->functionData['editUserForm']) : 0;
$this->functionData['editUserForm'][$count_de5f6e095e8957f16daaf4a3f5a51fe0]['profile'] = $profile;
$this->functionData['editUserForm'][$count_de5f6e095e8957f16daaf4a3f5a51fe0]['custom_fields'] = $custom_fields;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- inlineModIPMessage --*/
function inlineModIPMessage($msg='') {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- latestWarnLogs --*/
function latestWarnLogs($warnings, $pagelinks) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['latestWarnLogs'] ) )
{
$count_55e5c1e16e8fa0aa85878ca5842cb5d4 = is_array($this->functionData['latestWarnLogs']) ? count($this->functionData['latestWarnLogs']) : 0;
$this->functionData['latestWarnLogs'][$count_55e5c1e16e8fa0aa85878ca5842cb5d4]['warnings'] = $warnings;
$this->functionData['latestWarnLogs'][$count_55e5c1e16e8fa0aa85878ca5842cb5d4]['pagelinks'] = $pagelinks;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- memberLookup --*/
function memberLookup() {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['memberLookup'] ) )
{
$count_c4208308c23216c6a2b5e9a3185cc4bd = is_array($this->functionData['memberLookup']) ? count($this->functionData['memberLookup']) : 0;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- membersList --*/
function membersList($type, $members, $pagelinks='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['membersList'] ) )
{
$count_0b928a830535cdb2c891d28c0d7afa06 = is_array($this->functionData['membersList']) ? count($this->functionData['membersList']) : 0;
$this->functionData['membersList'][$count_0b928a830535cdb2c891d28c0d7afa06]['type'] = $type;
$this->functionData['membersList'][$count_0b928a830535cdb2c891d28c0d7afa06]['members'] = $members;
$this->functionData['membersList'][$count_0b928a830535cdb2c891d28c0d7afa06]['pagelinks'] = $pagelinks;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- membersModIPForm --*/
function membersModIPForm($ip="", $inlineMsg='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['membersModIPForm'] ) )
{
$count_1f3f28a44f694aec7e9247c7e9162cad = is_array($this->functionData['membersModIPForm']) ? count($this->functionData['membersModIPForm']) : 0;
$this->functionData['membersModIPForm'][$count_1f3f28a44f694aec7e9247c7e9162cad]['ip'] = $ip;
$this->functionData['membersModIPForm'][$count_1f3f28a44f694aec7e9247c7e9162cad]['inlineMsg'] = $inlineMsg;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- membersModIPFormMembers --*/
function membersModIPFormMembers($pages="",$members) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['membersModIPFormMembers'] ) )
{
$count_ff4b7dd865e60f369307dfb572d0645c = is_array($this->functionData['membersModIPFormMembers']) ? count($this->functionData['membersModIPFormMembers']) : 0;
$this->functionData['membersModIPFormMembers'][$count_ff4b7dd865e60f369307dfb572d0645c]['pages'] = $pages;
$this->functionData['membersModIPFormMembers'][$count_ff4b7dd865e60f369307dfb572d0645c]['members'] = $members;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- membersModIPFormPosts --*/
function membersModIPFormPosts($count=0, $pageLinks='', $results) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['membersModIPFormPosts'] ) )
{
$count_94aadbf7339e7a293e0057ce87fc928b = is_array($this->functionData['membersModIPFormPosts']) ? count($this->functionData['membersModIPFormPosts']) : 0;
$this->functionData['membersModIPFormPosts'][$count_94aadbf7339e7a293e0057ce87fc928b]['count'] = $count;
$this->functionData['membersModIPFormPosts'][$count_94aadbf7339e7a293e0057ce87fc928b]['pageLinks'] = $pageLinks;
$this->functionData['membersModIPFormPosts'][$count_94aadbf7339e7a293e0057ce87fc928b]['results'] = $results;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- modAnnounceForm --*/
function modAnnounceForm($announce,$forum_html,$type,$editor_html,$msg="") {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['modAnnounceForm'] ) )
{
$count_a00291e3a2d565a13921cdd6dc96eb06 = is_array($this->functionData['modAnnounceForm']) ? count($this->functionData['modAnnounceForm']) : 0;
$this->functionData['modAnnounceForm'][$count_a00291e3a2d565a13921cdd6dc96eb06]['announce'] = $announce;
$this->functionData['modAnnounceForm'][$count_a00291e3a2d565a13921cdd6dc96eb06]['forum_html'] = $forum_html;
$this->functionData['modAnnounceForm'][$count_a00291e3a2d565a13921cdd6dc96eb06]['type'] = $type;
$this->functionData['modAnnounceForm'][$count_a00291e3a2d565a13921cdd6dc96eb06]['editor_html'] = $editor_html;
$this->functionData['modAnnounceForm'][$count_a00291e3a2d565a13921cdd6dc96eb06]['msg'] = $msg;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- modAnnouncements --*/
function modAnnouncements($announcements) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['modAnnouncements'] ) )
{
$count_e2e584d6f88c3d81d9c0c9c234d7c2d9 = is_array($this->functionData['modAnnouncements']) ? count($this->functionData['modAnnouncements']) : 0;
$this->functionData['modAnnouncements'][$count_e2e584d6f88c3d81d9c0c9c234d7c2d9]['announcements'] = $announcements;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- modcpMessage --*/
function modcpMessage($message='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['modcpMessage'] ) )
{
$count_935f18d155754ef3137eff87ff6d20b6 = is_array($this->functionData['modcpMessage']) ? count($this->functionData['modcpMessage']) : 0;
$this->functionData['modcpMessage'][$count_935f18d155754ef3137eff87ff6d20b6]['message'] = $message;
}
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- modCPpost --*/
function modCPpost($post, $displayData, $topic, $type) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['modCPpost'] ) )
{
$count_8ae2eb5309b02337ac09ed79570f1a99 = is_array($this->functionData['modCPpost']) ? count($this->functionData['modCPpost']) : 0;
$this->functionData['modCPpost'][$count_8ae2eb5309b02337ac09ed79570f1a99]['post'] = $post;
$this->functionData['modCPpost'][$count_8ae2eb5309b02337ac09ed79570f1a99]['displayData'] = $displayData;
$this->functionData['modCPpost'][$count_8ae2eb5309b02337ac09ed79570f1a99]['topic'] = $topic;
$this->functionData['modCPpost'][$count_8ae2eb5309b02337ac09ed79570f1a99]['type'] = $type;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- modCPtopic --*/
function modCPtopic($topics, $pagelinks, $type, $sdelete=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['modCPtopic'] ) )
{
$count_7f17e831a2de7f7fd9f8057805e0eeea = is_array($this->functionData['modCPtopic']) ? count($this->functionData['modCPtopic']) : 0;
$this->functionData['modCPtopic'][$count_7f17e831a2de7f7fd9f8057805e0eeea]['topics'] = $topics;
$this->functionData['modCPtopic'][$count_7f17e831a2de7f7fd9f8057805e0eeea]['pagelinks'] = $pagelinks;
$this->functionData['modCPtopic'][$count_7f17e831a2de7f7fd9f8057805e0eeea]['type'] = $type;
$this->functionData['modCPtopic'][$count_7f17e831a2de7f7fd9f8057805e0eeea]['sdelete'] = $sdelete;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- portalPage --*/
function portalPage($output, $tabs=array(), $_activeNav=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['portalPage'] ) )
{
$count_eca29146f0d6bed754eb041fb3fe0e7b = is_array($this->functionData['portalPage']) ? count($this->functionData['portalPage']) : 0;
$this->functionData['portalPage'][$count_eca29146f0d6bed754eb041fb3fe0e7b]['output'] = $output;
$this->functionData['portalPage'][$count_eca29146f0d6bed754eb041fb3fe0e7b]['tabs'] = $tabs;
$this->functionData['portalPage'][$count_eca29146f0d6bed754eb041fb3fe0e7b]['_activeNav'] = $_activeNav;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- subTabLoop --*/
function subTabLoop() {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['subTabLoop'] ) )
{
$count_3e1f1376638b85aa604bf88bfff104fe = is_array($this->functionData['subTabLoop']) ? count($this->functionData['subTabLoop']) : 0;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- unapprovedPosts --*/
function unapprovedPosts($posts, $pagelinks) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['unapprovedPosts'] ) )
{
$count_3cf3fe7fe0ee7152806f2df870716931 = is_array($this->functionData['unapprovedPosts']) ? count($this->functionData['unapprovedPosts']) : 0;
$this->functionData['unapprovedPosts'][$count_3cf3fe7fe0ee7152806f2df870716931]['posts'] = $posts;
$this->functionData['unapprovedPosts'][$count_3cf3fe7fe0ee7152806f2df870716931]['pagelinks'] = $pagelinks;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- unapprovedTopics --*/
function unapprovedTopics($topics, $pagelinks) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_modcp', $this->_funcHooks['unapprovedTopics'] ) )
{
$count_dc899a9e3ed07e4b987816a37fe8bd1f = is_array($this->functionData['unapprovedTopics']) ? count($this->functionData['unapprovedTopics']) : 0;
$this->functionData['unapprovedTopics'][$count_dc899a9e3ed07e4b987816a37fe8bd1f]['topics'] = $topics;
$this->functionData['unapprovedTopics'][$count_dc899a9e3ed07e4b987816a37fe8bd1f]['pagelinks'] = $pagelinks;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}


}


/*--------------------------------------------------*/
/* END OF FILE                                      */
/*--------------------------------------------------*/

?>