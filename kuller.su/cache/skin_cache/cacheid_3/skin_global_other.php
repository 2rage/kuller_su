<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 3               */
/* CACHE FILE: Generated: Wed, 08 May 2013 03:43:51 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_global_other_3 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['ajaxPopUpNoPermission'] = array('msg');
$this->_funcHooks['displayBoardOffline'] = array('isGuest');
$this->_funcHooks['displayPopUpWindow'] = array('donotminifycss','cssImport','popupcssInline','popupmetaTags','popupjavascript','popuprss','popuprss','popupraw','popupdocumentHeadItems','popupheaditemtype','minifycss','csstominify','hasimportcss','popupcssinline','popupmetatags','popupminfiyrlhttpsp','popupminfiyrlhttpss','popupminfyjsrl','popupjsmodules','popuphttpsp','popuprl','popupjsmodules','popuphttpss','popuprl2','popupminifyjs','popupdocumenthead','popupbefriend','istm','istl','popupswfupload','popupfurl');
$this->_funcHooks['Error'] = array('haserrorcode','savedpost');
$this->_funcHooks['facebookPop'] = array('hasFbConnected');
$this->_funcHooks['generateTopicIcon'] = array('topicIsMoved','topicIsClosed','topicReadDot','topicUnreadDot','gotolatestwrap');
$this->_funcHooks['globalTemplateMinimal'] = array('fbcenabled','pagenumberintitle','isLargeTouch','isSmallTouch','mainpageContent','lastvisit','isfloat','sqldebuglink','closesqldebuglink','showdebuglevel');
$this->_funcHooks['inboxList'] = array('loopynotify','hasTopics');
$this->_funcHooks['likeMoreDialogue'] = array('hasVisibleEntries','hasAnonEntries');
$this->_funcHooks['likeSummaryContents'] = array('likeOnlyMembers');
$this->_funcHooks['notificationsList'] = array('loopynotify','hasnotifications','notifications');
$this->_funcHooks['questionAndAnswer'] = array('qadefault');
$this->_funcHooks['quickNavigationPanel'] = array('depth','important','innerAgain','hasTitle','linksisarray','outer');
$this->_funcHooks['quickNavigationWrapper'] = array('active','navTabs','isLargeTouch');
$this->_funcHooks['redirectTemplate'] = array('redirectcssImport','redirctcssInline','redirectjs','redirectrss','redirectrsd','redirectraw','redirectdocumentHeadItemsSub','redirectdocumentHeadItems','redirectfull','redirectcssimport','redirectcssinline','redirectdh','redirectmozfull','redirectlink');
$this->_funcHooks['repButtons'] = array('hasNoLikes','giveRepUp','giveRepDown','canGiveRep','pos','giveRepUp','giveRepDown','canGiveRep','hasNoRep','hasPosRep','hasNegRep','isNotLike','isLike','canRep','reputationBox','giveRepUp','canGiveRep','canGiveRep','giveRepDown','isLike','canRep');
$this->_funcHooks['socialSharePostStrip'] = array('canShareThis','services','canSave','canShare');
$this->_funcHooks['tagCloud'] = array('eachTag');
$this->_funcHooks['tagEntry'] = array('noClass','inSearch','inSearchSub','hasSearchSection');
$this->_funcHooks['tagPrefix'] = array('inSearch','inSearchSub','hasSearchSection');
$this->_funcHooks['tagTextEntryBox'] = array('isClosedField','prefixChecked','canPrefix');


}

/* -- ajaxPopUpNoPermission --*/
function ajaxPopUpNoPermission($msg='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['ajaxPopUpNoPermission'] ) )
{
$count_ba83810fb3b7df56b820f7e50a0755c6 = is_array($this->functionData['ajaxPopUpNoPermission']) ? count($this->functionData['ajaxPopUpNoPermission']) : 0;
$this->functionData['ajaxPopUpNoPermission'][$count_ba83810fb3b7df56b820f7e50a0755c6]['msg'] = $msg;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- captchaGD --*/
function captchaGD($captcha_unique_id) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- captchaKeycaptcha --*/
function captchaKeycaptcha($challenge="") {
$IPBHTML = "";
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- captchaRecaptcha --*/
function captchaRecaptcha($html="") {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- displayBoardOffline --*/
function displayBoardOffline($message="") {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['displayBoardOffline'] ) )
{
$count_2fab5c941aa913ef387e37c85c2d2ba4 = is_array($this->functionData['displayBoardOffline']) ? count($this->functionData['displayBoardOffline']) : 0;
$this->functionData['displayBoardOffline'][$count_2fab5c941aa913ef387e37c85c2d2ba4]['message'] = $message;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- displayPopUpWindow --*/
function displayPopUpWindow($documentHeadItems, $css, $jsLoaderItems, $title="", $output="") {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['displayPopUpWindow'] ) )
{
$count_a0af542f9c95ae87125a68a114e921c8 = is_array($this->functionData['displayPopUpWindow']) ? count($this->functionData['displayPopUpWindow']) : 0;
$this->functionData['displayPopUpWindow'][$count_a0af542f9c95ae87125a68a114e921c8]['documentHeadItems'] = $documentHeadItems;
$this->functionData['displayPopUpWindow'][$count_a0af542f9c95ae87125a68a114e921c8]['css'] = $css;
$this->functionData['displayPopUpWindow'][$count_a0af542f9c95ae87125a68a114e921c8]['jsLoaderItems'] = $jsLoaderItems;
$this->functionData['displayPopUpWindow'][$count_a0af542f9c95ae87125a68a114e921c8]['title'] = $title;
$this->functionData['displayPopUpWindow'][$count_a0af542f9c95ae87125a68a114e921c8]['output'] = $output;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- Error --*/
function Error($message="",$code=0,$ad_email_one="",$ad_email_two="", $title="") {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['Error'] ) )
{
$count_7e63e20dd64911e714f9a7e99c91302f = is_array($this->functionData['Error']) ? count($this->functionData['Error']) : 0;
$this->functionData['Error'][$count_7e63e20dd64911e714f9a7e99c91302f]['message'] = $message;
$this->functionData['Error'][$count_7e63e20dd64911e714f9a7e99c91302f]['code'] = $code;
$this->functionData['Error'][$count_7e63e20dd64911e714f9a7e99c91302f]['ad_email_one'] = $ad_email_one;
$this->functionData['Error'][$count_7e63e20dd64911e714f9a7e99c91302f]['ad_email_two'] = $ad_email_two;
$this->functionData['Error'][$count_7e63e20dd64911e714f9a7e99c91302f]['title'] = $title;
}
$IPBHTML .= "<error>{$message}</error>";
return $IPBHTML;
}

/* -- facebookDone --*/
function facebookDone($user) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- facebookPop --*/
function facebookPop($user=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['facebookPop'] ) )
{
$count_43a6df066fee2c96112da75a7a4d7309 = is_array($this->functionData['facebookPop']) ? count($this->functionData['facebookPop']) : 0;
$this->functionData['facebookPop'][$count_43a6df066fee2c96112da75a7a4d7309]['user'] = $user;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- followUnsubscribe --*/
function followUnsubscribe($data, $meta) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- generateTopicIcon --*/
function generateTopicIcon($imgArray, $unreadUrl) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['generateTopicIcon'] ) )
{
$count_480f59487b6749df2c9acec81a906aa7 = is_array($this->functionData['generateTopicIcon']) ? count($this->functionData['generateTopicIcon']) : 0;
$this->functionData['generateTopicIcon'][$count_480f59487b6749df2c9acec81a906aa7]['imgArray'] = $imgArray;
$this->functionData['generateTopicIcon'][$count_480f59487b6749df2c9acec81a906aa7]['unreadUrl'] = $unreadUrl;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- globalTemplateMinimal --*/
function globalTemplateMinimal($html, $documentHeadItems, $css, $jsModules, $metaTags, array $header_items, $items=array(), $footer_items=array(), $stats=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['globalTemplateMinimal'] ) )
{
$count_f33a0ed5cd5b611a9c6ee3b976b78335 = is_array($this->functionData['globalTemplateMinimal']) ? count($this->functionData['globalTemplateMinimal']) : 0;
$this->functionData['globalTemplateMinimal'][$count_f33a0ed5cd5b611a9c6ee3b976b78335]['html'] = $html;
$this->functionData['globalTemplateMinimal'][$count_f33a0ed5cd5b611a9c6ee3b976b78335]['documentHeadItems'] = $documentHeadItems;
$this->functionData['globalTemplateMinimal'][$count_f33a0ed5cd5b611a9c6ee3b976b78335]['css'] = $css;
$this->functionData['globalTemplateMinimal'][$count_f33a0ed5cd5b611a9c6ee3b976b78335]['jsModules'] = $jsModules;
$this->functionData['globalTemplateMinimal'][$count_f33a0ed5cd5b611a9c6ee3b976b78335]['metaTags'] = $metaTags;
$this->functionData['globalTemplateMinimal'][$count_f33a0ed5cd5b611a9c6ee3b976b78335]['header_items'] = $header_items;
$this->functionData['globalTemplateMinimal'][$count_f33a0ed5cd5b611a9c6ee3b976b78335]['items'] = $items;
$this->functionData['globalTemplateMinimal'][$count_f33a0ed5cd5b611a9c6ee3b976b78335]['footer_items'] = $footer_items;
$this->functionData['globalTemplateMinimal'][$count_f33a0ed5cd5b611a9c6ee3b976b78335]['stats'] = $stats;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- inboxList --*/
function inboxList($topics) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['inboxList'] ) )
{
$count_e8b9b1123316900d8c3a2ec2b215bc19 = is_array($this->functionData['inboxList']) ? count($this->functionData['inboxList']) : 0;
$this->functionData['inboxList'][$count_e8b9b1123316900d8c3a2ec2b215bc19]['topics'] = $topics;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- inlineUploaderComplete --*/
function inlineUploaderComplete($json) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- likeMoreDialogue --*/
function likeMoreDialogue($data, $relId, $cache) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['likeMoreDialogue'] ) )
{
$count_b1dffab55ed0de8b19565dac07fe9ae8 = is_array($this->functionData['likeMoreDialogue']) ? count($this->functionData['likeMoreDialogue']) : 0;
$this->functionData['likeMoreDialogue'][$count_b1dffab55ed0de8b19565dac07fe9ae8]['data'] = $data;
$this->functionData['likeMoreDialogue'][$count_b1dffab55ed0de8b19565dac07fe9ae8]['relId'] = $relId;
$this->functionData['likeMoreDialogue'][$count_b1dffab55ed0de8b19565dac07fe9ae8]['cache'] = $cache;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- likeSetDialogue --*/
function likeSetDialogue($app, $area, $relid, $data) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- likeSummary --*/
function likeSummary($data, $relId, $opts) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- likeSummaryContents --*/
function likeSummaryContents($data, $relId, $opts=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['likeSummaryContents'] ) )
{
$count_9aefe2a206b336301b89b48a89186a11 = is_array($this->functionData['likeSummaryContents']) ? count($this->functionData['likeSummaryContents']) : 0;
$this->functionData['likeSummaryContents'][$count_9aefe2a206b336301b89b48a89186a11]['data'] = $data;
$this->functionData['likeSummaryContents'][$count_9aefe2a206b336301b89b48a89186a11]['relId'] = $relId;
$this->functionData['likeSummaryContents'][$count_9aefe2a206b336301b89b48a89186a11]['opts'] = $opts;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- notificationsList --*/
function notificationsList($notifications) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['notificationsList'] ) )
{
$count_3507ef1310c25aafe26d56a8f13ed77c = is_array($this->functionData['notificationsList']) ? count($this->functionData['notificationsList']) : 0;
$this->functionData['notificationsList'][$count_3507ef1310c25aafe26d56a8f13ed77c]['notifications'] = $notifications;
}
$IPBHTML .= "<template>popoverNotifications</template>
<notifications>
	".$this->__f__9c3d935725fc0ed86e69c16ecf2d73f0($notifications)."</notifications>";
return $IPBHTML;
}


function __f__9c3d935725fc0ed86e69c16ecf2d73f0($notifications)
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $notifications as $notification )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
		<notification>
			<id>{$notification['notify_id']}</id>
			<url><![CDATA[{$notification['notify_url']}]]></url>
			<icon><![CDATA[{$notification['member']['pp_thumb_photo']}]]></icon>
			<text><![CDATA[{$notification['notify_title']}]]></text>
		</notification>
	
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- privacyPolicy --*/
function privacyPolicy($title, $text) {
$IPBHTML = "";
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- questionAndAnswer --*/
function questionAndAnswer($data) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['questionAndAnswer'] ) )
{
$count_66a0b5d6e36c9f47744dc11b574efff5 = is_array($this->functionData['questionAndAnswer']) ? count($this->functionData['questionAndAnswer']) : 0;
$this->functionData['questionAndAnswer'][$count_66a0b5d6e36c9f47744dc11b574efff5]['data'] = $data;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- quickNavigationOffline --*/
function quickNavigationOffline($message) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- quickNavigationPanel --*/
function quickNavigationPanel($data=array(), $currentApp='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['quickNavigationPanel'] ) )
{
$count_911e82574380faf5014c83b6f65a99da = is_array($this->functionData['quickNavigationPanel']) ? count($this->functionData['quickNavigationPanel']) : 0;
$this->functionData['quickNavigationPanel'][$count_911e82574380faf5014c83b6f65a99da]['data'] = $data;
$this->functionData['quickNavigationPanel'][$count_911e82574380faf5014c83b6f65a99da]['currentApp'] = $currentApp;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- quickNavigationWrapper --*/
function quickNavigationWrapper($tabs=array(), $data=array(), $currentApp='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['quickNavigationWrapper'] ) )
{
$count_b790d87bebdfe5ae4a16df3727721c6b = is_array($this->functionData['quickNavigationWrapper']) ? count($this->functionData['quickNavigationWrapper']) : 0;
$this->functionData['quickNavigationWrapper'][$count_b790d87bebdfe5ae4a16df3727721c6b]['tabs'] = $tabs;
$this->functionData['quickNavigationWrapper'][$count_b790d87bebdfe5ae4a16df3727721c6b]['data'] = $data;
$this->functionData['quickNavigationWrapper'][$count_b790d87bebdfe5ae4a16df3727721c6b]['currentApp'] = $currentApp;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- redirectTemplate --*/
function redirectTemplate($documentHeadItems, $css, $jsLoaderItems, $text="",$url="", $full=false) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['redirectTemplate'] ) )
{
$count_ead77725db6482a34252f1b04a27f2f5 = is_array($this->functionData['redirectTemplate']) ? count($this->functionData['redirectTemplate']) : 0;
$this->functionData['redirectTemplate'][$count_ead77725db6482a34252f1b04a27f2f5]['documentHeadItems'] = $documentHeadItems;
$this->functionData['redirectTemplate'][$count_ead77725db6482a34252f1b04a27f2f5]['css'] = $css;
$this->functionData['redirectTemplate'][$count_ead77725db6482a34252f1b04a27f2f5]['jsLoaderItems'] = $jsLoaderItems;
$this->functionData['redirectTemplate'][$count_ead77725db6482a34252f1b04a27f2f5]['text'] = $text;
$this->functionData['redirectTemplate'][$count_ead77725db6482a34252f1b04a27f2f5]['url'] = $url;
$this->functionData['redirectTemplate'][$count_ead77725db6482a34252f1b04a27f2f5]['full'] = $full;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- repButtons --*/
function repButtons($member, $data=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['repButtons'] ) )
{
$count_86f2a687b0a69db7bf2318af6af24250 = is_array($this->functionData['repButtons']) ? count($this->functionData['repButtons']) : 0;
$this->functionData['repButtons'][$count_86f2a687b0a69db7bf2318af6af24250]['member'] = $member;
$this->functionData['repButtons'][$count_86f2a687b0a69db7bf2318af6af24250]['data'] = $data;
}
$IPBHTML .= "" . ((!( $this->settings['reputation_protected_groups'] && in_array( $member['member_group_id'], explode( ',', $this->settings['reputation_protected_groups'] ) ) ) and $this->memberData['member_id']) ? ("" . (($this->settings['reputation_point_types'] == 'like') ? ("" . ((IPSMember::canGiveRep( $data, $member ) !== false) ? ("" . ((IPSMember::canRepUp( $data, $member ) !== false) ? ("
				<likeURL><![CDATA[{$this->settings['base_url']}app=core&amp;module=global&amp;section=reputation&amp;do=add_rating&amp;app_rate={$data['app']}&amp;type={$data['type']}&amp;type_id={$data['primaryId']}&amp;rating=1&amp;secure_key={$this->member->form_hash}&amp;post_return={$data['primaryId']}]]></likeURL>
			") : ("")) . "") : ("")) . "") : ("" . ((IPSMember::canGiveRep( $data, $member ) !== false) ? ("
			<repupURL><![CDATA[{$this->settings['base_url']}app=core&amp;module=global&amp;section=reputation&amp;do=add_rating&amp;app_rate={$data['app']}&amp;type={$data['type']}&amp;type_id={$data['primaryId']}&amp;rating=1&amp;secure_key={$this->member->form_hash}&amp;post_return={$data['primaryId']}]]></repupURL>
		") : ("")) . "
		" . ((IPSMember::canRepDown( $data, $member ) !== false) ? ("
			<repDownURL><![CDATA[{$this->settings['base_url']}app=core&amp;module=global&amp;section=reputation&amp;do=add_rating&amp;app_rate={$data['app']}&amp;type={$data['type']}&amp;type_id={$data['primaryId']}&amp;rating=-1&amp;secure_key={$this->member->form_hash}&amp;post_return={$data['primaryId']}]]></repDownURL>
		") : ("")) . "")) . "") : ("")) . "";
return $IPBHTML;
}

/* -- repMoreDialogue --*/
function repMoreDialogue($data, $relId) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- reputationPopup --*/
function reputationPopup($reps) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- socialSharePostStrip --*/
function socialSharePostStrip($id=null) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['socialSharePostStrip'] ) )
{
$count_b4252adb4e64591a0c59f1e3c4e4eb8e = is_array($this->functionData['socialSharePostStrip']) ? count($this->functionData['socialSharePostStrip']) : 0;
$this->functionData['socialSharePostStrip'][$count_b4252adb4e64591a0c59f1e3c4e4eb8e]['id'] = $id;
}
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- tagCloud --*/
function tagCloud($tags) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['tagCloud'] ) )
{
$count_e3f000a93f53c69cbe4af71b10e24873 = is_array($this->functionData['tagCloud']) ? count($this->functionData['tagCloud']) : 0;
$this->functionData['tagCloud'][$count_e3f000a93f53c69cbe4af71b10e24873]['tags'] = $tags;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- tagEntry --*/
function tagEntry($tag, $noClass=false, $app='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['tagEntry'] ) )
{
$count_05abce6a33cb3430e5c3775f364fef6a = is_array($this->functionData['tagEntry']) ? count($this->functionData['tagEntry']) : 0;
$this->functionData['tagEntry'][$count_05abce6a33cb3430e5c3775f364fef6a]['tag'] = $tag;
$this->functionData['tagEntry'][$count_05abce6a33cb3430e5c3775f364fef6a]['noClass'] = $noClass;
$this->functionData['tagEntry'][$count_05abce6a33cb3430e5c3775f364fef6a]['app'] = $app;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- tagPrefix --*/
function tagPrefix($tag, $app='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['tagPrefix'] ) )
{
$count_61a570a8fb93e317b00ad7d58b55e733 = is_array($this->functionData['tagPrefix']) ? count($this->functionData['tagPrefix']) : 0;
$this->functionData['tagPrefix'][$count_61a570a8fb93e317b00ad7d58b55e733]['tag'] = $tag;
$this->functionData['tagPrefix'][$count_61a570a8fb93e317b00ad7d58b55e733]['app'] = $app;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- tagsAsPopUp --*/
function tagsAsPopUp($tags) {
$IPBHTML = "";
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- tagTextEntryBox --*/
function tagTextEntryBox($tags, $options, $where) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_global_other', $this->_funcHooks['tagTextEntryBox'] ) )
{
$count_b034d85889fe33ec50db5ce5e887aeb0 = is_array($this->functionData['tagTextEntryBox']) ? count($this->functionData['tagTextEntryBox']) : 0;
$this->functionData['tagTextEntryBox'][$count_b034d85889fe33ec50db5ce5e887aeb0]['tags'] = $tags;
$this->functionData['tagTextEntryBox'][$count_b034d85889fe33ec50db5ce5e887aeb0]['options'] = $options;
$this->functionData['tagTextEntryBox'][$count_b034d85889fe33ec50db5ce5e887aeb0]['where'] = $where;
}
$IPBHTML .= "<tagSystemIsEnabled>{$options['isEnabled']}</tagSystemIsEnabled>
<tagSystemIsOpen>{$options['isOpenSystem']}</tagSystemIsOpen>
<prefixesEnabled>{$options['prefixesEnabled']}</prefixesEnabled>
<predefinedTags>
</predefinedTags>";
return $IPBHTML;
}

/* -- twitterDone --*/
function twitterDone($user) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- twitterPop --*/
function twitterPop($user) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}


}


/*--------------------------------------------------*/
/* END OF FILE                                      */
/*--------------------------------------------------*/

?>