<?php
/*--------------------------------------------------*/
/* FILE GENERATED BY INVISION POWER BOARD 3         */
/* CACHE FILE: Skin set id: 2               */
/* CACHE FILE: Generated: Wed, 08 May 2013 03:43:51 GMT */
/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */
/* WRITTEN TO THE DATABASE AUTOMATICALLY            */
/*--------------------------------------------------*/

class skin_help_2 extends skinMaster{

/**
* Construct
*/
function __construct( ipsRegistry $registry )
{
	parent::__construct( $registry );
	

$this->_funcHooks = array();
$this->_funcHooks['helpShowSection'] = array('notajax','isajax','notajax','notajax','isajax','notajax');
$this->_funcHooks['helpShowTopics'] = array('helpfiles','helpfiles');


}

/* -- helpShowSection --*/
function helpShowSection($one_text="",$two_text="",$three_text="", $text) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_help', $this->_funcHooks['helpShowSection'] ) )
{
$count_2cfc0cc5d0722190cf3ae8e0ad668b9b = is_array($this->functionData['helpShowSection']) ? count($this->functionData['helpShowSection']) : 0;
$this->functionData['helpShowSection'][$count_2cfc0cc5d0722190cf3ae8e0ad668b9b]['one_text'] = $one_text;
$this->functionData['helpShowSection'][$count_2cfc0cc5d0722190cf3ae8e0ad668b9b]['two_text'] = $two_text;
$this->functionData['helpShowSection'][$count_2cfc0cc5d0722190cf3ae8e0ad668b9b]['three_text'] = $three_text;
$this->functionData['helpShowSection'][$count_2cfc0cc5d0722190cf3ae8e0ad668b9b]['text'] = $text;
}
$IPBHTML .= "" . ((!$this->request['xml']) ? ("
<div class='topic_controls'>
	<ul class='topic_buttons'>
		<li><a href=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=help", "public",'' ), "", "" ) . "\" title=\"{$this->lang->words['help_back_list_title']}\">{$this->lang->words['help_return_list']}</a></li>
	</ul>
</div>
") : ("")) . "
" . (($this->request['xml']) ? ("
<br />
") : ("")) . "
" . ((!$this->request['xml']) ? ("
	<h1 class='ipsType_pagetitle'>{$one_text}: {$three_text}</h1>
") : ("
	<h1 class='ipsType_subtitle'>{$one_text}: {$three_text}</h1>
")) . "
<br />
<div class='row2 help_doc ipsPad bullets'>
	{$text}
</div>
<br />";
return $IPBHTML;
}

/* -- helpShowTopics --*/
function helpShowTopics($one_text="",$two_text="",$three_text="",$rows) {
$IPBHTML = "";
if( IPSLib::locationHasHooks( 'skin_help', $this->_funcHooks['helpShowTopics'] ) )
{
$count_d77ba812107caa06c589d7c5a9a7e3e0 = is_array($this->functionData['helpShowTopics']) ? count($this->functionData['helpShowTopics']) : 0;
$this->functionData['helpShowTopics'][$count_d77ba812107caa06c589d7c5a9a7e3e0]['one_text'] = $one_text;
$this->functionData['helpShowTopics'][$count_d77ba812107caa06c589d7c5a9a7e3e0]['two_text'] = $two_text;
$this->functionData['helpShowTopics'][$count_d77ba812107caa06c589d7c5a9a7e3e0]['three_text'] = $three_text;
$this->functionData['helpShowTopics'][$count_d77ba812107caa06c589d7c5a9a7e3e0]['rows'] = $rows;
}

if ( ! isset( $this->registry->templateStriping['help'] ) ) {
$this->registry->templateStriping['help'] = array( FALSE, "row1","row2");
}
$IPBHTML .= "" . $this->registry->getClass('output')->addJSModule("help", "0" ) . "
<p class='message unspecific'>{$two_text}</p>
<h2 class='maintitle'>{$this->lang->words['help_topics']}</h2>
<div class='generic_bar'></div>
<ol id='help_topics'>
		" . ((count($rows)) ? ("".$this->__f__2a2f15c8f39e134a9d5c7fcd9764bc3a($one_text,$two_text,$three_text,$rows)."	") : ("
		<li class='no_messages'>{$this->lang->words['no_help_topics']}</li>
	")) . "
</ol>";
return $IPBHTML;
}


function __f__2a2f15c8f39e134a9d5c7fcd9764bc3a($one_text="",$two_text="",$three_text="",$rows)
{
	$_ips___x_retval = '';
	$__iteratorCount = 0;
	foreach( $rows as $entry )
	{
		
		$__iteratorCount++;
		$_ips___x_retval .= "
		<li class='" .  IPSLib::next( $this->registry->templateStriping["help"] ) . " helpRow'>
			<h3><a href=\"" . $this->registry->getClass('output')->formatUrl( $this->registry->getClass('output')->buildUrl( "app=core&amp;module=help&amp;do=01&amp;HID={$entry['id']}", "public",'' ), "", "" ) . "\" title=\"{$this->lang->words['help_read_document']}\">{$entry['title']}</a></h3>
			<p>
				{$entry['description']}
			</p>
		</li>
		
";
	}
	$_ips___x_retval .= '';
	unset( $__iteratorCount );
	return $_ips___x_retval;
}


}


/*--------------------------------------------------*/
/* END OF FILE                                      */
/*--------------------------------------------------*/

?>