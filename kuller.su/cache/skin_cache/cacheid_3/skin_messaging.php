<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 3               */
/* CACHE FILE: Generated: Wed, 08 May 2013 03:43:51 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_messaging_3 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['messengerDisabled'] = array('notByAdmin');
$this->_funcHooks['messengerTemplate'] = array('isMemberPartOpen','isMemberPartFloat','isMemberPartClose','userIsStarter','lastReadTime','messageIsDeleted','notification','blockUserLink','unbanUserLink','systemMessage','topicUnavailable','userIsBanned','userIsActive','participants','protectedFolder','allFolder','unprotectedFolder','dirs','PMDisabled','changeNotifications','unlimitedInvites','inviteMoreParticipants','hasParticipants','myDirectories','almostFull','storageBar','inlineError');
$this->_funcHooks['sendNewPersonalTopicForm'] = array('newtopicerrors','newTopicPreview','newTopicError','formReloadInvite','formReloadCopy','newTopicInvite','newTopicUploads');
$this->_funcHooks['sendReplyForm'] = array('replyerrors','replyForm','previewPm','formHeaderText','formErrors','attachmentForm','replyOptions','replyForm');
$this->_funcHooks['showConversation'] = array('hasAuthorId','authorOnline','accessModCP','authorPrivateIp','authorIpAddress','viewSigs','quickReply','reportPm','canEdit','canDelete','replies','disablelightbox','canReplyEditor','allAlone','reportPm','canEdit','canDelete','quickReply','replies','canReplyEditor');
$this->_funcHooks['showConversationForArchive'] = array('replies');
$this->_funcHooks['showFolder'] = array('folderLastPage','messagePages','hasStarterPhoto','folderNotifications','folderDrafts','folderNotificationsIgnore','folderStarter','folderToMember','folderFixPlural','folderMultipleUsers','folderNew','folderPages','folderBannedIndicator','hasPosterPhoto','folderToMember','folderBannedUser','folderMessages','folderNotDrafts','folderMessages','folderMultiOptions','folderJumpHtml','messages');
$this->_funcHooks['showSearchResults'] = array('folderNotifications','folderStarter','folderToMember','folderFixPlural','folderMultipleUsers','folderNew','folderBannedIndicator','folderBannedUser','messages','searchError','hasPagination','searchMessages');


}

/* -- messengerDisabled --*/
function messengerDisabled() {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_messaging', $this->_funcHooks['messengerDisabled'] ) )
{
$count_198a22be6a1f7a767944dc38bd771a9a = is_array($this->functionData['messengerDisabled']) ? count($this->functionData['messengerDisabled']) : 0;
}
$IPBHTML .= "<error>Messanger Disabled</error>";
return $IPBHTML;
}

/* -- messengerTemplate --*/
function messengerTemplate($html, $jumpmenu, $dirData, $totalData=array(), $topicParticipants=array(), $inlineError='', $deletedTopic=0) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_messaging', $this->_funcHooks['messengerTemplate'] ) )
{
$count_96de801ed9e6c8a571710f9cb8356e2e = is_array($this->functionData['messengerTemplate']) ? count($this->functionData['messengerTemplate']) : 0;
$this->functionData['messengerTemplate'][$count_96de801ed9e6c8a571710f9cb8356e2e]['html'] = $html;
$this->functionData['messengerTemplate'][$count_96de801ed9e6c8a571710f9cb8356e2e]['jumpmenu'] = $jumpmenu;
$this->functionData['messengerTemplate'][$count_96de801ed9e6c8a571710f9cb8356e2e]['dirData'] = $dirData;
$this->functionData['messengerTemplate'][$count_96de801ed9e6c8a571710f9cb8356e2e]['totalData'] = $totalData;
$this->functionData['messengerTemplate'][$count_96de801ed9e6c8a571710f9cb8356e2e]['topicParticipants'] = $topicParticipants;
$this->functionData['messengerTemplate'][$count_96de801ed9e6c8a571710f9cb8356e2e]['inlineError'] = $inlineError;
$this->functionData['messengerTemplate'][$count_96de801ed9e6c8a571710f9cb8356e2e]['deletedTopic'] = $deletedTopic;
}
$IPBHTML .= "{$html}";
return $IPBHTML;
}

/* -- PMQuickForm --*/
function PMQuickForm($toMemberData) {
$IPBHTML = "";
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- sendNewPersonalTopicForm --*/
function sendNewPersonalTopicForm($displayData) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_messaging', $this->_funcHooks['sendNewPersonalTopicForm'] ) )
{
$count_c5faea885fd8cdb1eef8ed4c67526b5f = is_array($this->functionData['sendNewPersonalTopicForm']) ? count($this->functionData['sendNewPersonalTopicForm']) : 0;
$this->functionData['sendNewPersonalTopicForm'][$count_c5faea885fd8cdb1eef8ed4c67526b5f]['displayData'] = $displayData;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- sendReplyForm --*/
function sendReplyForm($displayData) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_messaging', $this->_funcHooks['sendReplyForm'] ) )
{
$count_30212efc6df71db62615c9980306d7ff = is_array($this->functionData['sendReplyForm']) ? count($this->functionData['sendReplyForm']) : 0;
$this->functionData['sendReplyForm'][$count_30212efc6df71db62615c9980306d7ff]['displayData'] = $displayData;
}
$IPBHTML .= "<postingForm>
	<msgID>{$displayData['msgID']}</msgID>
	<topicID>{$displayData['topicID']}</topicID>
	<postKey>{$displayData['postKey']}</postKey>
	{$displayData['editor']}
	<authKey>{$this->member->form_hash}</authKey>
	
	" . (($displayData['type'] == 'reply') ? ("
			<submitURL><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "module=messaging&amp;section=send&amp;do=sendReply", "publicWithApp",'' ), "", "" ) . "]]></submitURL>
	") : ("
			<submitURL><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "module=messaging&amp;section=send&amp;do=sendEdit", "publicWithApp",'' ), "", "" ) . "]]></submitURL>
	")) . "
	
</postingForm>";
return $IPBHTML;
}

/* -- showConversation --*/
function showConversation($topic, $replies, $members, $jump="") {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_messaging', $this->_funcHooks['showConversation'] ) )
{
$count_4300e78dd26ace5a37ec5c4c4bc75163 = is_array($this->functionData['showConversation']) ? count($this->functionData['showConversation']) : 0;
$this->functionData['showConversation'][$count_4300e78dd26ace5a37ec5c4c4bc75163]['topic'] = $topic;
$this->functionData['showConversation'][$count_4300e78dd26ace5a37ec5c4c4bc75163]['replies'] = $replies;
$this->functionData['showConversation'][$count_4300e78dd26ace5a37ec5c4c4bc75163]['members'] = $members;
$this->functionData['showConversation'][$count_4300e78dd26ace5a37ec5c4c4bc75163]['jump'] = $jump;
}
$IPBHTML .= "<template>messageView</template>
<pagination>{$topic['_pages']}</pagination>
" . (($topic['_canReply']) ? ("
<AssessoryButtonURL><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=messaging&amp;section=send&amp;do=sendReply&amp;topicID={$topic['mt_id']}", "public",'' ), "", "" ) . "]]></AssessoryButtonURL>
") : ("")) . "
<message>
	<title><![CDATA[{$topic['mt_title']}]]></title>
	".$this->__f__94bc5699a5952814eb980edb0c6f9375($topic,$replies,$members,$jump)."</message>";
return $IPBHTML;
}


function __f__94bc5699a5952814eb980edb0c6f9375($topic, $replies, $members, $jump="")
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $replies as $msg_id => $msg )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
		<messageReply>
			<user>
				<id>{$msg['msg_author_id']}</id>
				<name><![CDATA[{$members[ $msg['msg_author_id'] ]['members_display_name']}]]></name>
				<date>" . $this->registry->getClass('class_localization')->getDate($msg['msg_date'],"DATE", 0) . "</date>
				<avatar><![CDATA[{$members[ $msg['msg_author_id'] ]['pp_thumb_photo']}]]></avatar>
				<url><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "showuser={$msg['msg_author_id']}", "public",'' ), "{$members[ $msg['msg_author_id'] ]['members_seo_name']}", "showuser" ) . "]]></url>
			</user>	
			<date>" . $this->registry->getClass('class_localization')->getDate($msg['post']['post_date'],"DATE", 0) . "</date>
			<text><![CDATA[{$msg['msg_post']}
			{$msg['attachmentHtml']}]]></text>
			<options>
			" . (($topic['_canReport'] and $this->memberData['member_id']) ? ("
				<reportURL><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=reports&amp;rcom=messages&amp;topicID={$this->request['topicID']}&amp;st={$this->request['st']}&amp;msg={$msg['msg_id']}", "public",'' ), "", "" ) . "]]></reportURL>
			") : ("")) . "
			
			" . (($msg['_canEdit'] === TRUE) ? ("
				<editURL><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "module=messaging&amp;section=send&amp;do=editMessage&amp;topicID={$topic['mt_id']}&amp;msgID={$msg['msg_id']}", "publicWithApp",'' ), "", "" ) . "]]></editURL>
			") : ("")) . "
			
			" . (($msg['_canDelete'] === TRUE && $msg['msg_is_first_post'] != 1) ? ("
				<deleteURL><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "module=messaging&amp;section=send&amp;do=deleteReply&amp;topicID={$topic['mt_id']}&amp;msgID={$msg['msg_id']}&amp;authKey={$this->member->form_hash}", "publicWithApp",'' ), "", "" ) . "]]></deleteURL>
			") : ("")) . "
			
			" . (($topic['_canReply'] AND empty( $topic['_everyoneElseHasLeft'] )) ? ("
				<replyURL><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "module=messaging&amp;section=send&amp;do=replyForm&amp;topicID={$topic['mt_id']}&amp;msgID={$msg['msg_id']}", "publicWithApp",'' ), "", "" ) . "]]></replyURL>
			") : ("")) . "
				</options>							
		</messageReply>
	
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- showConversationForArchive --*/
function showConversationForArchive($topic, $replies, $members) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_messaging', $this->_funcHooks['showConversationForArchive'] ) )
{
$count_ed57354f9690152021afe3d22f752010 = is_array($this->functionData['showConversationForArchive']) ? count($this->functionData['showConversationForArchive']) : 0;
$this->functionData['showConversationForArchive'][$count_ed57354f9690152021afe3d22f752010]['topic'] = $topic;
$this->functionData['showConversationForArchive'][$count_ed57354f9690152021afe3d22f752010]['replies'] = $replies;
$this->functionData['showConversationForArchive'][$count_ed57354f9690152021afe3d22f752010]['members'] = $members;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}

/* -- showFolder --*/
function showFolder($messages, $dirname, $pages, $currentFolderID, $jumpFolderHTML) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_messaging', $this->_funcHooks['showFolder'] ) )
{
$count_bd9f0f2cd8a74f7cbe4f12433600e23d = is_array($this->functionData['showFolder']) ? count($this->functionData['showFolder']) : 0;
$this->functionData['showFolder'][$count_bd9f0f2cd8a74f7cbe4f12433600e23d]['messages'] = $messages;
$this->functionData['showFolder'][$count_bd9f0f2cd8a74f7cbe4f12433600e23d]['dirname'] = $dirname;
$this->functionData['showFolder'][$count_bd9f0f2cd8a74f7cbe4f12433600e23d]['pages'] = $pages;
$this->functionData['showFolder'][$count_bd9f0f2cd8a74f7cbe4f12433600e23d]['currentFolderID'] = $currentFolderID;
$this->functionData['showFolder'][$count_bd9f0f2cd8a74f7cbe4f12433600e23d]['jumpFolderHTML'] = $jumpFolderHTML;
}
$IPBHTML .= "<template>popoverMessages</template>
<messages>
	".$this->__f__5f820551a061dfb92c74d86dda941e5f($messages,$dirname,$pages,$currentFolderID,$jumpFolderHTML)."</messages>";
return $IPBHTML;
}


function __f__5f820551a061dfb92c74d86dda941e5f($messages, $dirname, $pages, $currentFolderID, $jumpFolderHTML)
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $messages as $message )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
		<message>
			<id>{$message['msg_topic_id']}</id>
			<title>{$message['mt_title']}</title>
			<url><![CDATA[" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=members&amp;module=messaging&amp;section=view&amp;do=showConversation&amp;topicID={$message['msg_topic_id']}", "public",'' ), "", "" ) . "]]></url>
			<SenderName><![CDATA[{$message['_starterMemberData']['members_display_name']}]]></SenderName>
			<icon><![CDATA[{$message['_starterMemberData']['pp_mini_photo']}]]></icon>
		</message>
	
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}

/* -- showSearchResults --*/
function showSearchResults($messages, $pages, $error) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_messaging', $this->_funcHooks['showSearchResults'] ) )
{
$count_f674df98abb3c06a532ac2e4a9d59435 = is_array($this->functionData['showSearchResults']) ? count($this->functionData['showSearchResults']) : 0;
$this->functionData['showSearchResults'][$count_f674df98abb3c06a532ac2e4a9d59435]['messages'] = $messages;
$this->functionData['showSearchResults'][$count_f674df98abb3c06a532ac2e4a9d59435]['pages'] = $pages;
$this->functionData['showSearchResults'][$count_f674df98abb3c06a532ac2e4a9d59435]['error'] = $error;
}
$IPBHTML .= "<!-- NoData -->";
return $IPBHTML;
}


}


/*--------------------------------------------------*/
/* END OF FILE                                      */
/*--------------------------------------------------*/

?>