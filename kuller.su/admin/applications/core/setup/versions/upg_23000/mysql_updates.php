<?php
/*
+--------------------------------------------------------------------------
|   IP.Board v3.4.2
|   ========================================
|   by Matthew Mecham
|   (c) 2001 - 2004 Invision Power Services
|   http://www.invisionpower.com
|   ========================================
|   Web: http://www.invisionboard.com
|   Email: matt@invisionpower.com
|   Licence Info: http://www.invisionboard.com/?license
+---------------------------------------------------------------------------
*/


$SQL[] = "ALTER TABLE forums CHANGE last_title last_title VARCHAR( 250 ) NULL DEFAULT NULL ,
CHANGE newest_title newest_title VARCHAR( 250 ) NULL DEFAULT NULL ;";

$SQL[] = "CREATE TABLE skin_url_mapping (
	map_id			INT(10) NOT NULL auto_increment,
	map_title		VARCHAR(200) NOT NULL default '',
	map_match_type	VARCHAR(10) NOT NULL default 'contains',
	map_url			VARCHAR(200) NOT NULL default '',
	map_skin_set_id	INT(10) UNSIGNED NOT NULL default '0',
	map_date_added	INT(10) UNSIGNED NOT NULL default '0',
	PRIMARY KEY (map_id)
);";

$SQL[] = "ALTER TABLE mail_queue ADD mail_html_on	INT(1) NOT NULL default '0';";

$SQL[] = "ALTER TABLE skin_templates ADD group_names_secondary TEXT NULL;";

$SQL[] = "CREATE TABLE skin_template_links (
	link_id				INT(10) UNSIGNED NOT NULL auto_increment,
	link_set_id			INT(10) UNSIGNED NOT NULL default '0',
	link_group_name		VARCHAR(255) NOT NULL default '',
	link_template_name	VARCHAR(255) NOT NULL default '',
	link_used_in		VARCHAR(255) NOT NULL default '',
	PRIMARY KEY (link_id)
);";

