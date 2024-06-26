<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * User agent (browser and spider) mappings
 * Last Updated: $Date: 2013-01-02 18:34:31 -0500 (Wed, 02 Jan 2013) $
 * </pre>
 *
 * @author 		$Author: AndyMillne $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @version		$Rev: 11774 $
 * @since		3.0.0
 *
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

// Default mobile skin matched agents */
$MOBILESKIN = array(
	'groups'  => array(),
	'uagents' => array(
						'android'      => '',
						'blackberry'   => '',
						'iphone'       => '',
						'ipodtouch'    => '',
						'sonyericsson' => '',
						'nokia'        => '',
						'motorola'     => '',
						'samsung'      => '',
						'htc'          => '',
						'lg'		   => '',
						'palm' 		   => '',
						'windows7'     => '',
						'operamini'    => '' )
);


//-----------------------------------------
// Mobile devices. These go first so they are matched
// http://en.wikipedia.org/wiki/List_of_user_agents_for_mobile_phones
//-----------------------------------------

$BROWSERS['transformer'] = array(
							  'b_title' => "Transformer Tablet",
							  'b_regex' => array( ";\s+?Transformer\s+?" => "0" )
							);

$BROWSERS['android'] = array(
							  'b_title' => "Android",
							  'b_regex' => array( "\sandroid\s+?([A-Za-z0-9.]{1,10}).+?mobile" => "1" )
							);

$BROWSERS['androidtablet'] = array(
							  'b_title' => "Android",
							  'b_regex' => array( "\sandroid\s+?([A-Za-z0-9.]{1,10})" => "1" )
							);
							
$BROWSERS['blackberry'] = array(
							  'b_title' => "Blackberry",
							  'b_regex' => array( "blackberry\s?(\d+?)[\/;]" => "1" )
							);
							
$BROWSERS['iphone'] = array(
							  'b_title' => "iPhone",
							  'b_regex' => array( "iphone;" => "0" )
							);
							
$BROWSERS['ipodtouch'] = array(
							  'b_title' => "iPod Touch",
							  'b_regex' => array( "ipod;" => "0" )
							);

$BROWSERS['iPad'] = array(
							  'b_title' => "iPad",
							  'b_regex' => array( "iPad;" => "0" )
							);
														
$BROWSERS['sonyericsson'] = array(
							  'b_title' => "Sony Ericsson",
							  'b_regex' => array( "^SonyEricsson[A-Za-z0-9]" => "0" )
							);
							
$BROWSERS['nokia'] = array(
							  'b_title' => "Nokia",
							  'b_regex' => array( "Nokia[A-Za-z0-9]" => "0" )
							);
							
$BROWSERS['motorola'] = array(
							  'b_title' => "Motorola",
							  'b_regex' => array( "^mot-[A-Za-z0-9]" => "0" )
							);
							
$BROWSERS['samsung'] = array(
							  'b_title' => "Samsung",
							  'b_regex' => array( "^samsung-[A-Za-z0-9]" => "0" )
							);
							
$BROWSERS['siemens'] = array(
							  'b_title' => "Siemens (Openwave)",
							  'b_regex' => array( "^sie-[A-Za-z0-9]" => "0" )
							);
							
$BROWSERS['htc'] = array(
							  'b_title' => "Nexus(Google)/HTC",
							  'b_regex' => array( "(htc-|htc_)([A-Za-z0-9.]{1,10})" => "2" )
							);
							
$BROWSERS['lg'] = array(
							  'b_title' => "LG",
							  'b_regex' => array( "^(lg|lge)-[A-Za-z0-9]" => "0" )
							);
							
$BROWSERS['palm'] = array(
							  'b_title' => "Palm",
							  'b_regex' => array( "(palmsource/| pre/[0-9.]{1,10}|palm webos)" => "0" )
							);

$BROWSERS['operamini'] = array(
							  'b_title' => "Opera Mobile/Mini",
							  'b_regex' => array( "opera (mobi|mini)" => "0" )
							);
							
$BROWSERS['windows7'] = array(
							  'b_title' => "Windows 7",
							  'b_regex' => array( "Windows Phone OS ([^;]+);" => "1" )
							);

$BROWSERS['windows8'] = array(
							  'b_title' => "Windows Phone 8",
							  'b_regex' => array( "Windows Phone ([^;]+);" => "1" )
							);
						  					
//-----------------------------------------
// Browsers
//-----------------------------------------

$BROWSERS['amaya'] = array(
							  'b_title' => "Amaya",
							  'b_regex' => array( "amaya/([0-9.]{1,10})" => "1" )
							);

$BROWSERS['aol'] = array(
							  'b_title' => "AOL",
							  'b_regex' => array( "aol[ /\-]([0-9.]{1,10})" => "1" )
							);
													
$BROWSERS['camino'] = array(
							  'b_title' => "Camino",
							  'b_regex' => array( "camino/([0-9.+]{1,10})" => "1" )
							);
$BROWSERS['chimera'] = array(
							  'b_title' => "Chimera",
							  'b_regex' => array( "chimera/([0-9.+]{1,10})" => "1" )
							);
							
$BROWSERS['chrome'] = array(
							  'b_title' => "Chrome",
							  'b_regex' => array( "Chrome/([0-9.]{1,10})" => "1" )
							);
							
$BROWSERS['curl'] = array(
							  'b_title' => "Curl",
							  'b_regex' => array( "curl[ /]([0-9.]{1,10})" => "1" )
							);

$BROWSERS['firebird'] = array(
							  'b_title' => "Firebird",
							  'b_regex' => array( "Firebird/([0-9.+]{1,10})" => "1" )
							);
$BROWSERS['firefox'] = array(
							  'b_title' => "Firefox",
							  'b_regex' => array( "Firefox/([0-9.+]{1,10})" => "1" )
							);
$BROWSERS['lotus'] = array(
							  'b_title' => "Lotus Notes",
							  'b_regex' => array( "Lotus[ \-]?Notes[ /]([0-9.]{1,10})" => "1" )
							);
$BROWSERS['konqueror'] = array(
							  'b_title' => "Konqueror",
							  'b_regex' => array( "konqueror/([0-9.]{1,10})" => "1" )
							);
$BROWSERS['lynx'] = array(
							  'b_title' => "Lynx",
							  'b_regex' => array( "lynx/([0-9a-z.]{1,10})" => "1" )
							);
$BROWSERS['maxthon'] = array(
							  'b_title' => "Maxthon",
							  'b_regex' => array( " Maxthon[\);]" => "" )
							);
$BROWSERS['omniweb'] = array(
							  'b_title' => "OmniWeb",
							  'b_regex' => array( "omniweb/[ a-z]?([0-9.]{1,10})$" => "1" )
							);
$BROWSERS['opera'] = array(
							  'b_title' => "Opera",
							  'b_regex' => array( "opera[ /]([0-9.]{1,10})" => "1" )
							);
							
$BROWSERS['safari'] = array(
							  'b_title' => "Safari",
							  'b_regex' => array( "version/([0-9.]{1,10})\s+?safari/([0-9.]{1,10})" => "1" )
							);

							
$BROWSERS['webtv'] = array(
							  'b_title' => "Webtv",
							  'b_regex' => array( "webtv[ /]([0-9.]{1,10})" => "1" )
							);
$BROWSERS['explorer'] = array(
							  'b_title'    => "Explorer",
							  'b_regex'    => array( "\(compatible; MSIE[ /]([0-9.]{1,10})" => "1" ),
							  'b_position' => 5000,
							);
$BROWSERS['netscape'] = array(
							  'b_title' => "Netscape",
							  'b_regex' => array( "^mozilla/([0-4]\.[0-9.]{1,10})" => "1" )
							);
$BROWSERS['mozilla'] = array(
							  'b_title' => "Mozilla",
							  'b_regex' => array( "^mozilla/([5-9]\.[0-9a-z.]{1,10})" => "1" )
							);
$BROWSERS['xbox'] = array(
							  'b_title' => "Xbox",
							  'b_regex' => array( "\(compatible; MSIE[ /]([0-9.]{1,10})(.*)Xbox" => "1" )
							);
											
//-----------------------------------------
// SEARCH ENGINES
//-----------------------------------------

$ENGINES['about'] = array(
							'b_title' => "About",
							'b_regex' => array( "Libby[_/ ]([0-9.]{1,10})" => "1" )
						  );
$ENGINES['alexa'] = array(
							'b_title' => "Alexa",
							'b_regex' => array( "^ia_archive" => "0" )
						  );
$ENGINES['altavista'] = array(
							'b_title' => "Altavista",
							'b_regex' => array( "Scooter[ /\-]*[a-z]*([0-9.]{1,10})" => "1" )
						  );
$ENGINES['ask'] = array(
							'b_title' => "Ask Jeeves",
							'b_regex' => array( "Ask[ \-]?Jeeves" => "0" )
						  );

$ENGINES['excite'] = array(
							'b_title' => "Excite",
							'b_regex' => array( "Architext[ \-]?Spider" => "0" )
						  );
$ENGINES['google'] = array(
							'b_title' => "Google",
							'b_regex' => array( "Googl(e|ebot)(-Image)?/([0-9.]{1,10})" => "\\\\3","Googl(e|ebot)(-Image)?/" => "" )
						  );
$ENGINES['googlemobile'] = array(
							'b_title' => "Google Mobile",
							'b_regex' => array( "Googl(e|ebot)(-Mobile)?/([0-9.]{1,10})" => "\\\\3","Googl(e|ebot)(-Mobile)?/" => "" )
						  );						  

$ENGINES['facebook'] = array(
							'b_title' => "Facebook",
							'b_regex' => array( "facebookexternalhit/([0-9.]{1,10})" => "\\\\1" )
						  );
						  
$ENGINES['infoseek'] = array(
							'b_title' => "Infoseek",
							'b_regex' => array( "SideWinder[ /]?([0-9a-z.]{1,10})" => "1","Infoseek" => "" )
						  );
$ENGINES['inktomi'] = array(
							'b_title' => "Inktomi",
							'b_regex' => array( "slurp@inktomi\.com" => "" )
						  );
$ENGINES['internetseer'] = array(
							'b_title' => "InternetSeer",
							'b_regex' => array( "^InternetSeer\.com" => "" )
						  );
$ENGINES['look'] = array(
							'b_title' => "Look",
							'b_regex' => array( "www\.look\.com" => "" )
						  );
$ENGINES['looksmart'] = array(
							'b_title' => "Looksmart",
							'b_regex' => array( "looksmart-sv-fw" => "" )
						  );
$ENGINES['lycos'] = array(
							'b_title' => "Lycos",
							'b_regex' => array( "Lycos_Spider_" => "" )
						  );

$ENGINES['msproxy'] = array(
							'b_title' => "MSProxy",
							'b_regex' => array( "MSProxy[ /]([0-9.]{1,10})" => "1" )
						  );

$ENGINES['bingbot'] = array(
							'b_title' => "Bing",
							'b_regex' => array( "bingbot[ /]([0-9.]{1,10})" => "1" )
						  );
											
$ENGINES['webcrawl'] = array(
							'b_title' => "WebCrawl",
							'b_regex' => array( "webcrawl\.net" => "" )
                          );
$ENGINES['websense'] = array(
							'b_title' => "Websense",
							'b_regex' => array( "(Sqworm|websense|Konqueror/3\.(0|1)(\-rc[1-6])?; i686 Linux; 2002[0-9]{4})" => "" )
						  );

$ENGINES['yahoo'] = array(
							'b_title' => "Yahoo",
							'b_regex' => array( "Yahoo(.*?)(Slurp|FeedSeeker)" => "" )
						  );
$ENGINES['AdSense'] = array(
							'b_title' => "Mediapartners(AdSense)",
							'b_regex' => array( "Mediapartners-Google" => "" )
						  );
$ENGINES['BrandWatch'] = array(
							'b_title' => "BrandWatch",
							'b_regex' => array( "magpie-crawler[ /]([0-9.]{1,10})" => "1" )
						  );
$ENGINES['Ahrefs'] = array(
							'b_title' => "Ahrefs",
							'b_regex' => array( "AhrefsBot[ /]([0-9.]{1,10})" => "1" )
						  );
$ENGINES['MSNMedia'] = array(
							'b_title' => "MSN",
							'b_regex' => array( "msnbot-media[ /]([0-9.]{1,10})" => "1" )
						  );
$ENGINES['integrome'] = array(
							'b_title' => "Integrome",
							'b_regex' => array( "www\.integromedb\.org/Crawler" => "" )
						  );
$ENGINES['Baidu'] = array(
							'b_title' => "Baidu",
							'b_regex' => array( "Baiduspider[ /]([0-9.]{1,10})" => "1" )
						  );
$ENGINES['Solomono'] = array(
							'b_title' => "Solomono",
							'b_regex' => array( "SolomonoBot[ /]([0-9.]{1,10})" => "1" )
						  );
$ENGINES['Ezoom'] = array(
							'b_title' => "Ezoom!",
							'b_regex' => array( "Ezoom[ /]([0-9.]{1,10})" => "1" )
						  );
						  
//Russian Search Engine Crawlers

$ENGINES['yandex'] = array(
							'b_title' => "Yandex",
							'b_regex' => array( "Yandex(Blogs|Blog|Bot|Images|Video|Media|Favicons|Webmaster|Pagechecker|ImageResizer|Direct|Metrika|News|Newslinks|Catalog|Antivirus|Zakladki|Sitelinks|Vertis)?[ /]([0-9.]{1,10})" => "2" )
						  );
$ENGINES['rambler'] = array(
							'b_title' => "Rambler",
							'b_regex' => array( "StackRambler[ /]([0-9.]{1,10})" => "1" )
						  );
$ENGINES['aport'] = array(
							'b_title' => "Aport",
							'b_regex' => array( "Aport" => "" )
						  );
$ENGINES['nigma'] = array(
							'b_title' => "Nigma",
							'b_regex' => array( "Nigma[ /]([0-9.]{1,10})" => "1" )
						  );
$ENGINES['webalta'] = array(
							'b_title' => "Webalta",
							'b_regex' => array( "Webalta([ /]Crawler)?" => "" )
						  );
$ENGINES['mailru'] = array(
							'b_title' => "Mail.ru",
							'b_regex' => array( "Mail.(RU|ru|Ru)[ /]([0-9.]{1,10})" => "2" )
						  );						  