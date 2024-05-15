<?php
/**
 * <pre>
 * Invision Power Services / IPBmafia.Ru
 * IP.Board v3.4.0 / darkLicenseActivationEmulator 1.0
 * License emulator
 * 
 * Last Updated: $LastChangedDate: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: _Dark_ $
 * @copyright	(c) 2012 IPBmafia.Ru
 * @package		IP.Board
 * @link		http://www.ipbmafia.ru
 * @version		1.1
 *
 */
class darkLAE {

	public static $settings = array(
		/*
		 * если TRUE копирайт IP.Board будет отображен в футере страницы
		 * если FALSE копирайт IP.Board будет скрыт
		 */
		'ipboard_copyright_showing' => TRUE,
	);

	private static $licenseKey = 'darkLAE 1.1 (_Dark_, IPBmafia.Ru)';

	public static function activateLicense() { 
		$response = array(
			'result' => 'ok'
		);
		return json_encode($response);
	}

	public static function getLicenseKey() {
		return self::$licenseKey;
	}

	public static function getLicenseData() {
		$licenseData =
			array(
				'key' => array(
					'_expires' => '9999999998',
		            'status_icon' => 'medal.png',
		            'status' => 'Ok',
		            'name' => 'Master License Key',
		            'msg' => 'Активировано darkLAE',
		            'expires' => '9999999999'
				),
				'addons' => array(
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'accept.png',
						'status' => 'Ok',
						'name' => 'IP.Board',
						'msg' => ''
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'accept.png',
						'status' => 'Ok',
						'name' => 'IP.Nexus',
						'msg' => ''
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'accept.png',
						'status' => 'Ok',
						'name' => 'IP.Content',
						'msg' => ''
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'accept.png',
						'status' => 'Ok',
						'name' => 'IP.Gallery',
						'msg' => ''
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'accept.png',
						'status' => 'Ok',
						'name' => 'IP.Blog',
						'msg' => ''
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'accept.png',
						'status' => 'Ok',
						'name' => 'IP.Downloads',
						'msg' => ''
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'cross.png',
						'status' => 'Inactive',
						'name' => 'IP.Chat',
						'msg' => "К сожалению, вы не можете использовать IP.Chat с nulled версией."
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'accept.png',
						'status' => 'Ok',
						'name' => 'Отключение копирайта',
						'msg' => 'Если вы хотите отключить копирайт отредактируйте файл /admin/sources/base/darkLAE.php на 20 строчке.'
					)
				),
				'ipbMain' => array(
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'information.png',
						'status' => 'Inactive',
						'name' => 'Поддержка',
						'msg' => "Вы не можете обратиться в тех.поддержку IPS, однако вы можете получить помощь по адресу <a href='http://www.ipbmafia.ru' target='_blank'>IPBmafia.Ru</a>"
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'information.png',
						'status' => 'Inactive',
						'name' => 'Загрузка новых версий',
						'msg' => "Вы не можете загружать новые версии из клиент-центра IPS, однако вы можете загрузить новые версии по адресу <a href='http://www.ipbmafia.ru' target='_blank'>IPBmafia.Ru</a>"
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'cross.png',
						'status' => 'Inactive',
						'name' => 'Система анти-спам мониторинга',
						'msg' => "К сожалению, система анти-спам мониторинга не работает с nulled версией."
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'cross.png',
						'status' => 'Inactive',
						'name' => 'Мобильные уведомления',
						'msg' => "К сожалению, мобильные уведомления не работают с nulled версией."
					),
					array(
						'expires' => '',
						'_expires' => 0,
						'status_icon' => 'accept.png',
						'status' => 'Ok',
						'name' => 'Visual Skin Editor',
						'msg' => ''
					)
				),
			    'skinGen' => 1,
			    'iphoneNotifications' => 0,
			    'cr' => (int) !self::$settings['ipboard_copyright_showing']
			);
		return $licenseData;
	}

	public static function getVisualSkinEditorJsonData() {
		$json = <<<_Dark_
			var IPS_SKIN_GEN_DATA = {"skinGroups":{"app_calendar":["App: Calendar",["app_calendar_td_selected","app_calendar_td_hover","app_calendar_td_blank","app_calendar_td_today"]],"app_gallery":["App: Gallery",["albumDetailTable_td"]],"global":["Global Styles",["body","a","content","desc","desclighter"]],"tables":["Table Content",["row1","row2","unread","unreadalt","tableheader","tableheader_a","ipb_table"]],"other":["Other Styles",["ipsbox","Bar Header","postblock","NoMessages","fieldsetSubmit","general_box","general_box_h3","ipsboxcontainer","maintitle","sideMenuActive","ipsVerticalTabbed_tabs_li","ipsVerticalTabbed_tabs_li_a","ipsVerticalTabbed_tabs_li_a_hover","ipsVerticalTabbed_tabs_li_active","ipsfilterbar_item","ipsfilterbar_active"]],"buttons":["Button Styles",["but_submit","but_submit_alt","but_topic","but_secondary"]],"header":["Header Elements",["registerLink","header","primarynav","primarynav_inactive","primarynav_active","searchbutton"]],"pagination":["Pagination",["paginationBackForward","paginationBackForwardHover","paginationBackActive"]],"sidebar":["Sidebar",["ipsSideBlock","ipsSideBlock_h3"]],"profiles":["Profile Page",["statusupdate"]],"app_blog":["App: Blog",["entry_header"]]},"colorizeGroups":{"base":["app_calendar_td_selected","app_calendar_td_hover","app_calendar_td_blank","app_calendar_td_today","albumDetailTable_td","body","content","row1","row2","unread","unreadalt","ipsbox","Bar Header","tableheader","tableheader_a","postblock","NoMessages","but_submit_alt","fieldsetSubmit","registerLink","header","primarynav","primarynav_inactive","primarynav_active","general_box","general_box_h3","ipsboxcontainer","maintitle","desc","desclighter","ipb_table","ipsVerticalTabbed_tabs_li","ipsVerticalTabbed_tabs_li_a","ipsVerticalTabbed_tabs_li_a_hover","ipsVerticalTabbed_tabs_li_active","ipsfilterbar_item","ipsfilterbar_active","but_secondary","paginationBackForward","ipsSideBlock","ipsSideBlock_h3","statusupdate","entry_header"],"text":["a"],"secondary":["but_submit","searchbutton","but_topic"],"tertiary":["sideMenuActive","paginationBackForwardHover","paginationBackActive"]},"classes":{"app_calendar_td_selected":["#calendar_table td.selected","Calendar Selected Cell","Used for selected cells in the monthly calendar",{"background":["#E2E9F0",""],"shadow":["#E2E9F0",""]}],"app_calendar_td_hover":["#calendar_table td.normal:hover","Calendar Cell Hover","Used for hovering over cells in the monthly calendar",{"background":["#EDF1F5",""]}],"app_calendar_td_blank":["#calendar_table td.blank","Calendar Blank Cell","Used for blank cells in the monthly calendar",{"background":["#dbe2e8",""],"border":["#dbe2e8",""]}],"app_calendar_td_today":["#calendar_table td.today","Calendar Today Cell","Used for todays cell in the monthly calendar",{"background":["#f1f6ec",""],"border":["#6f8f52",""],"color":["#6f8f52",""]}],"albumDetailTable_td":["#albumDetailTable td","Album Detail Table","Thick border for detail table",{"border":["#ebf0f3",""]}],"body":["html, body","Body","The page background",{"background":["#d8dde8",""],"color":["#5a5a5a",""]}],"a":["a","Links","Basic links",{"color":["#225985",""]}],"content":["#content","Main Content Area","The area that contains all page content",{"background":["#fff",""]}],"row1":[".row1, .post_block.row1","Table Row 1","Generic table row color 1",{"background":["#fff",""]}],"row2":[".row2, .post_block.row2","Table Row 2","Generic table row color 2",{"background":["#f1f6f9",""]}],"unread":[".unread","Unread Row","Unread row colour",{"background":["#f7fbfc",""]}],"unreadalt":[".unread .altrow, .unread.altrow","Unread Row (Alt)","Darker version of unread row, used to highlight certain table columns",{"background":["#E2E9F0",""]}],"ipsbox":[".ipsBox","Content Box","Used to wrap most content sections",{"background":["#ebf0f3",""]}],"Bar Header":[".bar","Bar Header","Used in post forms, etc",{"background":["#eff4f7",""]}],"tableheader":[".header","Table Header","Used for table headings",{"background":["#b6c7db",""],"color":["#1d3652",""]}],"tableheader_a":["body .ipb_table .header a,\tbody .topic_options a","Table Header Link","Used for links in table headings",{"color":["#1d3652",""]}],"postblock":[".post_block","Post Block","An individual post wrapper",{"background":["#fff",""],"border":["#D6E2EB",""]}],"NoMessages":[".no_messages","No Messages Box","Box for 'no data' type messages",{"background":["#f6f8fa",""],"border":false}],"but_submit":[".input_submit","Submit Button","The primary button that submits forms",{"background":["#212121",""],"border":["#5c5c5c",""],"color":["#fff",""],"boxshadow":["#5c5c5c"," inset 0 1px 0 0 "]}],"but_submit_alt":[".input_submit.alt","Alternate Submit Button","Secondary buttons for forms",{"background":["#e2e9f0",""],"border":["#dae2ea",""],"color":["#464646",""],"boxshadow":["#eff3f8"," inset 0 1px 0 0 "]}],"fieldsetSubmit":["body#ipboard_body fieldset.submit,body#ipboard_body p.submit","Submit\/Button Strip","Used in forms where the submit buttons are located",{"background":["#d1ddea",""]}],"registerLink":["#user_navigation #register_link","Create Account Link","The create accoun tbutton",{"background":["#7ba60d",""],"border":["#7ba60d",""],"color":["#fff",""],"boxshadow":false}],"header":["#branding","Header Bar","Bar containing logo, global search etc.",{"background":["#0f3854",""],"border":["#1b3759",""]}],"primarynav":["#primary_nav","Primary Nav Bar","Primary navigation bar (with app tabs)",{"background":["#204066",""]}],"primarynav_inactive":["#primary_nav a","Inactive App Tab","An inactive tab in the Primary Nav bar",{"background":["#1c3b5f",""],"color":["#c5d5e2",""]}],"primarynav_active":["#primary_nav .active a","Active App Tab","An active tab in the Primary Nav bar",{"background":["#fff",""],"color":["#0b5794",""]}],"searchbutton":["#search .submit_input","Search Button","The submit button for the global search bar",{"background":["#7ba60d",""],"border":["#7ba60d",""]}],"general_box":[".general_box","General Box Container","Used to contain contents of general boxes such as used on profile page",{"background":["#fcfcfc",""]}],"general_box_h3":[".general_box h3","General Box Container H3","Used to contain contents of general boxes title",{"background":["#DBE2EC",""],"color":["#204066",""]}],"ipsboxcontainer":[".ipsBox_container","Content Box Container","Used to contain contents of Content Box",{"background":["#fff",""],"border":["#dbe4ef",""]}],"maintitle":[".maintitle","Main Title","Bar used for block titles, filter bars etc.",{"background":["#2c5687",""],"color":["#fff",""],"border":["#528cbc",""],"boxshadow":["#528cbc"," inset 0px 1px 0 "]}],"desc":[".desc, .desc.blend_links a, p.posted_info","Description text","Used for small text throughout",{"color":["#777777",""]}],"desclighter":[".desc.lighter, .desc.lighter.blend_links a","Description text (lighter)","Used for small lighter text throughout",{"color":["#a4a4a4",""]}],"ipb_table":["table.ipb_table td","Tabular Data Rows","Used where there is tabular data",{"border":["#f3f3f3",""]}],"sideMenuActive":[".ipsSideMenu ul li.active a","Side Menu Active","A selected entry in a side menu",{"background":["#af286d",""],"color":["#fff",""]}],"ipsVerticalTabbed_tabs_li":[".ipsVerticalTabbed_tabs li","Vertical Tab","Used on profile page and other UserCP when veritcal tabs are needed",{"background":["#f6f8fb",""],"color":["#808080",""],"border":["#DBE4EF",""]}],"ipsVerticalTabbed_tabs_li_a":[".ipsVerticalTabbed_tabs li a","Vertical Tab Link","Link on a vertical tab",{"color":["#8d8d8d",""]}],"ipsVerticalTabbed_tabs_li_a_hover":[".ipsVerticalTabbed_tabs li a:hover","Vertical Tab Link Hover","Hover over a vertical tab",{"background":["#eaeff5",""],"color":["#808080",""]}],"ipsVerticalTabbed_tabs_li_active":[".ipsVerticalTabbed_tabs li.active a","Vertical Tab Active","An active tab",{"background":["#fff",""],"color":["#353535",""],"border":["#fff",""]}],"ipsfilterbar_item":[".ipsFilterbar li a","Filter Bar Item","Used for tabs in a filter bar",{"color":["#fff",""]}],"ipsfilterbar_active":[".ipsFilterbar li.active a","Filter Bar Active Item","Used for active tabs in a filter bar",{"background":["#244156",""],"color":["#fff",""]}],"but_topic":[".topic_buttons li.important a, .topic_buttons li.important span, .ipsButton .important,.topic_buttons li a, .topic_buttons li span, .ipsButton","Primary Button","Button used for main actions, such as New Topic",{"background":["#212121",""],"border":["#212121",""],"color":["#fff",""],"boxshadow":["#5c5c5c"," inset 0 1px 0 0 "]}],"but_secondary":[".ipsButton_secondary","Secondary Button","Secondary button, used normally for Follow actions",{"background":["#f6f6f6",""],"border":["#dbdbdb",""],"color":["#616161",""]}],"paginationBackForward":[".pagination .back a,.pagination .forward a","Pagination Next\/Foward","Next, back, forward buttons",{"background":["#eaeaea",""],"color":["#5a5a5a",""]}],"paginationBackForwardHover":[".pagination .back a:hover,\t.pagination .forward a:hover","Pagination Next\/Foward Hover","Next, back, forward buttons when hovered",{"background":["#af286d",""],"color":["#fff",""]}],"paginationBackActive":[".pagination .pages li.active","Pagination Page Active","Selected page",{"background":["#7BA60D",""],"color":["#fff",""]}],"ipsSideBlock":[".ipsSideBlock","Sidebar Block","Sidebar block background color",{"background":["#F7FBFC",""]}],"ipsSideBlock_h3":[".ipsSideBlock h3","Sidebar Block Header","Sidebar block Header",{"background":["#DBE2EC",""],"color":["#204066",""]}],"statusupdate":[".status_update","Status Update Block","Status update background",{"background":["#71a5c9",""],"color":["#fff",""]}],"entry_header":[".entry.featured .entry_header, .entry.featured .entry_footer","Blog Entry Header\/Footer\/Featured","Header for blog entry",{"background":["#f5faf7",""]}]}}
_Dark_;
		return $json;
	}
}
?>