<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 3               */
/* CACHE FILE: Generated: Wed, 08 May 2013 03:43:51 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_profile_3 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['acknowledgeWarning'] = array('valueIsPermanent','hasValue','options','memberNote','hasReasonAndContent','hasContent','hasReason','hasExpireDate','hasExpiration','hasPoints','isVerbalWarning');
$this->_funcHooks['addWarning'] = array('reasons','canUseAsBanGroup','banGroups','hasOtherOption','currentMq','currentRpa','currentSuspend');
$this->_funcHooks['customField__gender'] = array('male','female','nottelling','gender_set');
$this->_funcHooks['customField__generic'] = array('genericIsArray');
$this->_funcHooks['customFieldGroup__contact'] = array('cfieldgroups','cf_icon','cf_skype','cf_jabber','cf_website','cf_icq','cf_yahoo','cf_msn','cf_aim','cf_array','contact_field');
$this->_funcHooks['customizeProfile'] = array('hasBackgroundColor','backgroundIsFixed','hasBackgroundImage','hasBodyCustomization');
$this->_funcHooks['dnameWrapper'] = array('records','isAjaxModule','hasDnameHistory');
$this->_funcHooks['explainPoints'] = array('reasons','valueIsPermanent','hasValue','options','actions','hasActions');
$this->_funcHooks['friendsList'] = array('norep','posrep','negrep','repson','weAreSupmod','addfriend','notus','sendpm','blog','gallery','norep','posrep','negrep','repson','loopOnPending','friendsList','friendListPages','tabIsList','tabIsPending','friendListNone','hasFriendsList','friendListPagesBottom');
$this->_funcHooks['listWarnings'] = array('hasReason','warnings','paginationTop','canWarn','hasPaginationOrWarn','noWarnings','paginationBottom');
$this->_funcHooks['photoEditor'] = array('canHasUpload','canHasURL','allowGravatars','hasTwitter','hasFacebook');
$this->_funcHooks['profileModern'] = array('tabactive','tabs','warnClickable','warnPopup','warnIsSet','warnsLoop','pcfieldsLoop','pcfieldsOtherLoopCheckInner','pcfieldsOtherLoopCheck2','pcfieldsOtherLoopCheck','pcfieldsOtherLoop','cfields','friendsLoop','visitorismember','latest_visitors_loop','jsIsFriend','friendsEnabled','hasCustomization','weAreSupmod','weAreOwner','supModCustomization','canEditUser','canEditPic','haswarn','hasWarns','onlineDetails','userStatus','rate1','rate2','rate3','rate4','rate5','rated1','rated2','rated3','rated4','rated5','hasrating','noRateYourself','allowRate','isFriend','noFriendYourself','pmlink','member_title','member_age','member_bday_year','member_birthday','pcfields','pcfieldsOther','showContactHead','isadmin','member_contact_fields','hasContactFields','RepPositive','RepNegative','RepZero','RepText','RepImage','ourReputation','authorspammerinner','authorspammer','dnameHistory','supModCustomizationDisable','checkModTools','hasFriends','has_visitors','latest_visitors','thisIsNotUs','tabs','pmlink');
$this->_funcHooks['reputationPage'] = array('isTheActiveApp','apps','hasMoreThanOneApp','hasResults');
$this->_funcHooks['showCard'] = array('cardRepPos','cardRepNeg','cardRepZero','cardRep','cardSendPm','cardStatus','cardOnline','cardWhere','isadmin','authorspammerinner','authorspammer','cardIsFriend','cardFriend','cardBlog','cardGallery');
$this->_funcHooks['statusReplies'] = array('canDelete','innerLoop','noWrapperTop','noWrapperBottom','canDelete');
$this->_funcHooks['statusUpdates'] = array('isUs','moderated','forSomeoneElse','noLocked','cImg','creatorText','canDelete','isLocked','canLock','isUnapproved','addReturn','hasMore','hasReplies','canReply','maxReplies','statusApproved','outerLoop','canDelete','outerLoop');
$this->_funcHooks['statusUpdatesPage'] = array('tabactive','tabactive2','updateTwitter','updateFacebook','update','canCreate','hasUpdates','hasPagination');
$this->_funcHooks['tabFriends'] = array('friends','friends_loop','friends','friends');
$this->_funcHooks['tabReputation'] = array('isTheActiveApp','apps','hasMoreThanOneApp','currentIsGiven','canViewRep','currentIsReceived','hasResults','bottomPagination');
$this->_funcHooks['tabReputation_calendar'] = array('postMid','postMember','postMid','postMember');
$this->_funcHooks['tabReputation_posts'] = array('notLastFtAsForum','topicsForumTrail','postMid','postMember','hasForumTrail');
$this->_funcHooks['tabSingleColumn'] = array('singleColumnUrl','singleColumnTitle','date');
$this->_funcHooks['tabStatusUpdates'] = array('updateTwitter','updateFacebook','update','canCreate','leave_comment','hasUpdates','canCreate','leave_comment','hasUpdates');


}

/* -- acknowledgeWarning --*/
function acknowledgeWarning($warning) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['acknowledgeWarning'] ) )
{
$count_10df7e1b7618d8690d6a144839c5492d = is_array($this->functionData['acknowledgeWarning']) ? count($this->functionData['acknowledgeWarning']) : 0;
$this->functionData['acknowledgeWarning'][$count_10df7e1b7618d8690d6a144839c5492d]['warning'] = $warning;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- addWarning --*/
function addWarning($member, $reasons, $errors, $editor) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['addWarning'] ) )
{
$count_79249e7ae453a28925902280f104e370 = is_array($this->functionData['addWarning']) ? count($this->functionData['addWarning']) : 0;
$this->functionData['addWarning'][$count_79249e7ae453a28925902280f104e370]['member'] = $member;
$this->functionData['addWarning'][$count_79249e7ae453a28925902280f104e370]['reasons'] = $reasons;
$this->functionData['addWarning'][$count_79249e7ae453a28925902280f104e370]['errors'] = $errors;
$this->functionData['addWarning'][$count_79249e7ae453a28925902280f104e370]['editor'] = $editor;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- customField__gender --*/
function customField__gender($f) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['customField__gender'] ) )
{
$count_5119f0c675b2f3af0ca18d80ddfde981 = is_array($this->functionData['customField__gender']) ? count($this->functionData['customField__gender']) : 0;
$this->functionData['customField__gender'][$count_5119f0c675b2f3af0ca18d80ddfde981]['f'] = $f;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- customField__generic --*/
function customField__generic($f) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['customField__generic'] ) )
{
$count_7ee85eb14951f71a44ed2b9beb0e36d6 = is_array($this->functionData['customField__generic']) ? count($this->functionData['customField__generic']) : 0;
$this->functionData['customField__generic'][$count_7ee85eb14951f71a44ed2b9beb0e36d6]['f'] = $f;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- customFieldGroup__contact --*/
function customFieldGroup__contact($f) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['customFieldGroup__contact'] ) )
{
$count_a83aaa60ae16772a30227560c8fceba8 = is_array($this->functionData['customFieldGroup__contact']) ? count($this->functionData['customFieldGroup__contact']) : 0;
$this->functionData['customFieldGroup__contact'][$count_a83aaa60ae16772a30227560c8fceba8]['f'] = $f;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- customizeProfile --*/
function customizeProfile($member) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['customizeProfile'] ) )
{
$count_9a7a025e3e79dac1941a2662c82bfab4 = is_array($this->functionData['customizeProfile']) ? count($this->functionData['customizeProfile']) : 0;
$this->functionData['customizeProfile'][$count_9a7a025e3e79dac1941a2662c82bfab4]['member'] = $member;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- dnameWrapper --*/
function dnameWrapper($member_name="",$records=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['dnameWrapper'] ) )
{
$count_1e8dac0cd403681975eecfe66c7a251b = is_array($this->functionData['dnameWrapper']) ? count($this->functionData['dnameWrapper']) : 0;
$this->functionData['dnameWrapper'][$count_1e8dac0cd403681975eecfe66c7a251b]['member_name'] = $member_name;
$this->functionData['dnameWrapper'][$count_1e8dac0cd403681975eecfe66c7a251b]['records'] = $records;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- explainPoints --*/
function explainPoints($reasons, $actions) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['explainPoints'] ) )
{
$count_3c86cf6d2f79ba4954dbdac465ab9bf9 = is_array($this->functionData['explainPoints']) ? count($this->functionData['explainPoints']) : 0;
$this->functionData['explainPoints'][$count_3c86cf6d2f79ba4954dbdac465ab9bf9]['reasons'] = $reasons;
$this->functionData['explainPoints'][$count_3c86cf6d2f79ba4954dbdac465ab9bf9]['actions'] = $actions;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- friendsList --*/
function friendsList($friends, $pages) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['friendsList'] ) )
{
$count_2a477ad6d850713d4995307db77ed9a1 = is_array($this->functionData['friendsList']) ? count($this->functionData['friendsList']) : 0;
$this->functionData['friendsList'][$count_2a477ad6d850713d4995307db77ed9a1]['friends'] = $friends;
$this->functionData['friendsList'][$count_2a477ad6d850713d4995307db77ed9a1]['pages'] = $pages;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- listWarnings --*/
function listWarnings($member, $warnings, $pagination, $reasons, $canWarn) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['listWarnings'] ) )
{
$count_0b5a41ff168b028854f0629075343714 = is_array($this->functionData['listWarnings']) ? count($this->functionData['listWarnings']) : 0;
$this->functionData['listWarnings'][$count_0b5a41ff168b028854f0629075343714]['member'] = $member;
$this->functionData['listWarnings'][$count_0b5a41ff168b028854f0629075343714]['warnings'] = $warnings;
$this->functionData['listWarnings'][$count_0b5a41ff168b028854f0629075343714]['pagination'] = $pagination;
$this->functionData['listWarnings'][$count_0b5a41ff168b028854f0629075343714]['reasons'] = $reasons;
$this->functionData['listWarnings'][$count_0b5a41ff168b028854f0629075343714]['canWarn'] = $canWarn;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- photoEditor --*/
function photoEditor($data, $member) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['photoEditor'] ) )
{
$count_dd2fd9b448bac03096d77e296c49647e = is_array($this->functionData['photoEditor']) ? count($this->functionData['photoEditor']) : 0;
$this->functionData['photoEditor'][$count_dd2fd9b448bac03096d77e296c49647e]['data'] = $data;
$this->functionData['photoEditor'][$count_dd2fd9b448bac03096d77e296c49647e]['member'] = $member;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- profileModern --*/
function profileModern($tabs=array(), $member=array(), $visitors=array(), $default_tab='status', $default_tab_content='', $friends=array(), $status=array(), $warns=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['profileModern'] ) )
{
$count_07a452672639558424134b4dfe9b1a95 = is_array($this->functionData['profileModern']) ? count($this->functionData['profileModern']) : 0;
$this->functionData['profileModern'][$count_07a452672639558424134b4dfe9b1a95]['tabs'] = $tabs;
$this->functionData['profileModern'][$count_07a452672639558424134b4dfe9b1a95]['member'] = $member;
$this->functionData['profileModern'][$count_07a452672639558424134b4dfe9b1a95]['visitors'] = $visitors;
$this->functionData['profileModern'][$count_07a452672639558424134b4dfe9b1a95]['default_tab'] = $default_tab;
$this->functionData['profileModern'][$count_07a452672639558424134b4dfe9b1a95]['default_tab_content'] = $default_tab_content;
$this->functionData['profileModern'][$count_07a452672639558424134b4dfe9b1a95]['friends'] = $friends;
$this->functionData['profileModern'][$count_07a452672639558424134b4dfe9b1a95]['status'] = $status;
$this->functionData['profileModern'][$count_07a452672639558424134b4dfe9b1a95]['warns'] = $warns;
}
$IPBHTML .= "<template>profileView</template>
<profileData>
	<id>{$member['member_id']}</id>
	<name><![CDATA[{$member['members_display_name']}]]></name>
	<memberTitle><![CDATA[{$member['title']}]]></memberTitle>
	<reputation>{$member['pp_reputation_points']}</reputation>
	<postCount>{$member['posts']}</postCount>
	<avatar><![CDATA[{$member['pp_main_photo']}]]></avatar>	
</profileData>
<tab><![CDATA[{$default_tab}]]></tab>
" . (($default_tab == 'core:info') ? ("" . ((($member['member_id'] != $this->memberData['member_id']) AND $this->memberData['g_use_pm'] AND $this->memberData['members_disable_pm'] == 0 AND IPSLib::moduleIsEnabled( 'messaging', 'members' ) AND $member['members_disable_pm'] == 0) ? ("
<pmMeLink><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=messaging&amp;section=send&amp;do=form&amp;fromMemberID={$member['member_id']}", "public",'' ), "", "" ) . "]]></pmMeLink>
") : ("")) . "
<viewMyContent><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=search&amp;do=user_activity&amp;mid={$member['member_id']}", "public",'' ), "", "" ) . "]]></viewMyContent>
<profileTabs>
	".$this->__f__fa5c9d28b1e545285c897f9808f323ac($tabs,$member,$visitors,$default_tab,$default_tab_content,$friends,$status,$warns)."</profileTabs>") : ("
	{$default_tab_content}
")) . "";
return $IPBHTML;
}


function __f__fa5c9d28b1e545285c897f9808f323ac($tabs=array(), $member=array(), $visitors=array(), $default_tab='status', $default_tab_content='', $friends=array(), $status=array(), $warns=array())
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $tabs as $tab )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
		<profileTab>
			<name><![CDATA[{$tab['_lang']}]]></name>
			<url><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "showuser={$member['member_id']}&amp;tab={$tab['plugin_key']}", "public",'' ), "{$member['members_seo_name']}", "showuser" ) . "]]></url>
		</profileTab>
	
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- reputationPage --*/
function reputationPage($langBit, $currentApp='', $supportedApps=array(), $processedResults='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['reputationPage'] ) )
{
$count_4b41512594901538ce3c5e6d4223a36d = is_array($this->functionData['reputationPage']) ? count($this->functionData['reputationPage']) : 0;
$this->functionData['reputationPage'][$count_4b41512594901538ce3c5e6d4223a36d]['langBit'] = $langBit;
$this->functionData['reputationPage'][$count_4b41512594901538ce3c5e6d4223a36d]['currentApp'] = $currentApp;
$this->functionData['reputationPage'][$count_4b41512594901538ce3c5e6d4223a36d]['supportedApps'] = $supportedApps;
$this->functionData['reputationPage'][$count_4b41512594901538ce3c5e6d4223a36d]['processedResults'] = $processedResults;
}
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- showCard --*/
function showCard($member, $download=0) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['showCard'] ) )
{
$count_a432494c7cb36881136f1cf20d9045de = is_array($this->functionData['showCard']) ? count($this->functionData['showCard']) : 0;
$this->functionData['showCard'][$count_a432494c7cb36881136f1cf20d9045de]['member'] = $member;
$this->functionData['showCard'][$count_a432494c7cb36881136f1cf20d9045de]['download'] = $download;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- statusReplies --*/
function statusReplies($replies=array(), $no_wrapper=false) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['statusReplies'] ) )
{
$count_eec66f39ae49af184f81236819ed02c4 = is_array($this->functionData['statusReplies']) ? count($this->functionData['statusReplies']) : 0;
$this->functionData['statusReplies'][$count_eec66f39ae49af184f81236819ed02c4]['replies'] = $replies;
$this->functionData['statusReplies'][$count_eec66f39ae49af184f81236819ed02c4]['no_wrapper'] = $no_wrapper;
}
$IPBHTML .= "<commentReplies>
	".$this->__f__ce5049ccbb68957bfe8471763e55fb9c($replies,$no_wrapper)."</commentReplies>";
return $IPBHTML;
}


function __f__ce5049ccbb68957bfe8471763e55fb9c($replies=array(), $no_wrapper=false)
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $replies as $reply )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
		<commentReply>
			<author><![CDATA[{$reply['members_display_name']}]]></author>
			<avatar><![CDATA[{$reply['pp_main_photo']}]]></avatar>	
			<reply><![CDATA[{$reply['reply_content']}]]></reply>
			<date>{$reply['reply_date_formatted']}</date>
			<canDelete>" . (($reply['_canDelete']) ? ("1") : ("0")) . "</canDelete>
			<deleteURL><![CDATA[{$this->settings['base_url']}app=members&amp;module=profile&amp;section=status&amp;do=deleteReply&amp;status_id={$reply['reply_status_id']}&amp;reply_id={$reply['reply_id']}&amp;k={$this->member->form_hash}]]></deleteURL>
		</commentReply>
	
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- statusUpdates --*/
function statusUpdates($updates=array(), $smallSpace=0, $latestOnly=0) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['statusUpdates'] ) )
{
$count_6235d41dfca53b5ab391c90875e0a41b = is_array($this->functionData['statusUpdates']) ? count($this->functionData['statusUpdates']) : 0;
$this->functionData['statusUpdates'][$count_6235d41dfca53b5ab391c90875e0a41b]['updates'] = $updates;
$this->functionData['statusUpdates'][$count_6235d41dfca53b5ab391c90875e0a41b]['smallSpace'] = $smallSpace;
$this->functionData['statusUpdates'][$count_6235d41dfca53b5ab391c90875e0a41b]['latestOnly'] = $latestOnly;
}
$IPBHTML .= "<profileComments>".$this->__f__fe04ba810a2d8a9728694e6caf5a9c6d($updates,$smallSpace,$latestOnly)."</profileComments>";
return $IPBHTML;
}


function __f__fe04ba810a2d8a9728694e6caf5a9c6d($updates=array(), $smallSpace=0, $latestOnly=0)
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $updates as $id => $status )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
		<profileComment>
			<author><![CDATA[{$status['members_display_name']}]]></author>
			<avatar><![CDATA[{$status['pp_main_photo']}]]></avatar>	
			<reply><![CDATA[{$status['status_content']}]]></reply>
			<date>{$status['status_date_formatted']}</date>
			<canDelete>" . (($status['_canDelete']) ? ("1") : ("0")) . "</canDelete>
			<deleteURL><![CDATA[{$this->settings['base_url']}app=members&amp;module=profile&amp;section=status&amp;do=deleteReply&amp;status_id={$status['status_status_id']}&amp;reply_id={$status['status_id']}&amp;k={$this->member->form_hash}]]></deleteURL>
			" . (($status['status_replies'] AND count( $status['replies'] )) ? ("
				" . ( method_exists( $this->registry->getClass('output')->getTemplate('profile'), 'statusReplies' ) ? $this->registry->getClass('output')->getTemplate('profile')->statusReplies($status['replies'], 1) : '' ) . "
			") : ("")) . "
			" . (($status['_userCanReply']) ? ("
					<replyURL><![CDATA[{$this->settings['base_url']}app=members&amp;module=profile&amp;section=status&amp;do=reply&amp;status_id={$status['status_id']}&amp;k={$this->member->form_hash}&amp;id={$this->memberData['member_id']}]]></replyURL>
			") : ("")) . "
		</profileComment>
	
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- statusUpdatesPage --*/
function statusUpdatesPage($updates=array(), $pages='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['statusUpdatesPage'] ) )
{
$count_feef91b85b1167975d8d97b3f1a5afae = is_array($this->functionData['statusUpdatesPage']) ? count($this->functionData['statusUpdatesPage']) : 0;
$this->functionData['statusUpdatesPage'][$count_feef91b85b1167975d8d97b3f1a5afae]['updates'] = $updates;
$this->functionData['statusUpdatesPage'][$count_feef91b85b1167975d8d97b3f1a5afae]['pages'] = $pages;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- tabFriends --*/
function tabFriends($friends=array(), $member=array(), $pagination='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['tabFriends'] ) )
{
$count_b21e3c3f7c4fd02330e839398c8f6801 = is_array($this->functionData['tabFriends']) ? count($this->functionData['tabFriends']) : 0;
$this->functionData['tabFriends'][$count_b21e3c3f7c4fd02330e839398c8f6801]['friends'] = $friends;
$this->functionData['tabFriends'][$count_b21e3c3f7c4fd02330e839398c8f6801]['member'] = $member;
$this->functionData['tabFriends'][$count_b21e3c3f7c4fd02330e839398c8f6801]['pagination'] = $pagination;
}
$IPBHTML .= "<pagination>{$pagination}</pagination>
<friends>
	".$this->__f__01b6678ad3cddd4c7568625148a1567f($friends,$member,$pagination)."</friends>";
return $IPBHTML;
}


function __f__01b6678ad3cddd4c7568625148a1567f($friends=array(), $member=array(), $pagination='')
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $friends as $friend )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
		<friend>
			<url><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "showuser={$friend['member_id']}", "public",'' ), "{$friend['members_seo_name']}", "showuser" ) . "]]></url>
			<avatar><![CDATA[{$friend['pp_small_photo']}]]></avatar>
			<name><![CDATA[{$friend['members_display_name']}]]></name>
			<memberTitle><![CDATA[{$friend['member_title']}]]></memberTitle>
		</friend>
	
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- tabNoContent --*/
function tabNoContent($langkey) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- tabPosts --*/
function tabPosts($content) {
$IPBHTML = "";
$IPBHTML .= "<posts>
	{$content}
</posts>";
return $IPBHTML;
}

/* -- tabReputation --*/
function tabReputation($member, $currentApp='', $type='', $supportedApps=array(), $processedResults='', $pagination='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['tabReputation'] ) )
{
$count_745655733b9fcadf3212b2014f48b419 = is_array($this->functionData['tabReputation']) ? count($this->functionData['tabReputation']) : 0;
$this->functionData['tabReputation'][$count_745655733b9fcadf3212b2014f48b419]['member'] = $member;
$this->functionData['tabReputation'][$count_745655733b9fcadf3212b2014f48b419]['currentApp'] = $currentApp;
$this->functionData['tabReputation'][$count_745655733b9fcadf3212b2014f48b419]['type'] = $type;
$this->functionData['tabReputation'][$count_745655733b9fcadf3212b2014f48b419]['supportedApps'] = $supportedApps;
$this->functionData['tabReputation'][$count_745655733b9fcadf3212b2014f48b419]['processedResults'] = $processedResults;
$this->functionData['tabReputation'][$count_745655733b9fcadf3212b2014f48b419]['pagination'] = $pagination;
}
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- tabReputation_calendar --*/
function tabReputation_calendar($results) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['tabReputation_calendar'] ) )
{
$count_187cdfbda6c1606346e5193d8455626a = is_array($this->functionData['tabReputation_calendar']) ? count($this->functionData['tabReputation_calendar']) : 0;
$this->functionData['tabReputation_calendar'][$count_187cdfbda6c1606346e5193d8455626a]['results'] = $results;
}
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- tabReputation_posts --*/
function tabReputation_posts($results) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['tabReputation_posts'] ) )
{
$count_6f92944ee1e8d7196ff28f883abbe49f = is_array($this->functionData['tabReputation_posts']) ? count($this->functionData['tabReputation_posts']) : 0;
$this->functionData['tabReputation_posts'][$count_6f92944ee1e8d7196ff28f883abbe49f]['results'] = $results;
}
$IPBHTML .= "<!--no data in this master skin-->";
return $IPBHTML;
}

/* -- tabSingleColumn --*/
function tabSingleColumn($row=array(), $read_more_link='', $url='', $title='') {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['tabSingleColumn'] ) )
{
$count_b9c0840256752c2304501da47a30e220 = is_array($this->functionData['tabSingleColumn']) ? count($this->functionData['tabSingleColumn']) : 0;
$this->functionData['tabSingleColumn'][$count_b9c0840256752c2304501da47a30e220]['row'] = $row;
$this->functionData['tabSingleColumn'][$count_b9c0840256752c2304501da47a30e220]['read_more_link'] = $read_more_link;
$this->functionData['tabSingleColumn'][$count_b9c0840256752c2304501da47a30e220]['url'] = $url;
$this->functionData['tabSingleColumn'][$count_b9c0840256752c2304501da47a30e220]['title'] = $title;
}
$IPBHTML .= "<post>
<title><![CDATA[" . IPSText::truncate( $title, 90 ) . "]]></title>
<url><![CDATA[{$url}]]></url>
<text><![CDATA[{$row['post']}]]></text>
<date>" . $this->registry->getClass('class_localization')->getDate($row['_raw_date'],"long", 0) . "</date>
</post>";
return $IPBHTML;
}

/* -- tabStatusUpdates --*/
function tabStatusUpdates($updates=array(), $actions, $member=array()) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_profile', $this->_funcHooks['tabStatusUpdates'] ) )
{
$count_e23cdb26c3a0f8f16841c7e83ff3fc43 = is_array($this->functionData['tabStatusUpdates']) ? count($this->functionData['tabStatusUpdates']) : 0;
$this->functionData['tabStatusUpdates'][$count_e23cdb26c3a0f8f16841c7e83ff3fc43]['updates'] = $updates;
$this->functionData['tabStatusUpdates'][$count_e23cdb26c3a0f8f16841c7e83ff3fc43]['actions'] = $actions;
$this->functionData['tabStatusUpdates'][$count_e23cdb26c3a0f8f16841c7e83ff3fc43]['member'] = $member;
}
$IPBHTML .= "" . (($this->memberData['member_id'] AND ( $this->memberData['member_id'] == $member['member_id'] ) AND $this->registry->getClass('memberStatus')->canCreate( $member )) ? ("
<newStatusURL><![CDATA[{$this->settings['base_url']}app=members&amp;module=profile&amp;section=status&amp;do=new&amp;k={$this->member->form_hash}&amp;id={$this->memberData['member_id']}&amp;forMemberId={$member['member_id']}]]>
</newStatusURL>
") : ("")) . "
" . (($this->memberData['member_id'] && $this->memberData['member_id'] != $member['member_id'] && $member['pp_setting_count_comments']) ? ("
<profileCommentURL>
<![CDATA[{$this->settings['base_url']}app=members&amp;module=profile&amp;section=status&amp;do=new&amp;k={$this->member->form_hash}&amp;id={$this->memberData['member_id']}&amp;forMemberId={$member['member_id']}]]>
</profileCommentURL>
") : ("")) . "

" . ((count( $updates )) ? ("
	" . ( method_exists( $this->registry->getClass('output')->getTemplate('profile'), 'statusUpdates' ) ? $this->registry->getClass('output')->getTemplate('profile')->statusUpdates($updates) : '' ) . "
") : ("
<commentReplies>
	<commentReply>
		<reply><![CDATA[{$this->lang->words['status_updates_none']}]]></reply>
	</commentReply>
</commentReplies>
")) . "";
return $IPBHTML;
}

/* -- tabTopics --*/
function tabTopics($content) {
$IPBHTML = "";
$IPBHTML .= "<posts>
		{$content}
<posts>";
return $IPBHTML;
}


}


/*--------------------------------------------------*/
/* END OF FILE                                      */
/*--------------------------------------------------*/

?>