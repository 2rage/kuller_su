<?php
/**
 *	It's the Final Countdown
 *
 * @author 		Martin Aronsen
 * @copyright	© 2008 - 2011 Invision Modding
 * @web: 		http://www.invisionmodding.com
 * @IPB ver.:	IP.Board 3.2
 * @version:	1.1.0  (11000)
 *
 */
$TABLE[] = "CREATE TABLE countdowns (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  enabled tinyint(1) NOT NULL DEFAULT '0',
  allow_embed tinyint(1) NOT NULL DEFAULT '0',
  name varchar(255) NOT NULL DEFAULT '',
  view_in varchar(255) NOT NULL DEFAULT '',
  groups_perm varchar(255) NOT NULL DEFAULT '',
  time int(10) NOT NULL DEFAULT '0',
  timezone varchar(50) NOT NULL DEFAULT '',
  after_txt varchar(255) NOT NULL DEFAULT '',
  before_txt varchar(255) NOT NULL DEFAULT '',
  event_msg varchar(255) NOT NULL DEFAULT '',
  position int(10) NOT NULL DEFAULT '0',
  text_style varchar(255) NOT NULL DEFAULT '',
  view_permissions TEXT,
  layout varchar(255) NOT NULL DEFAULT '',
  format varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (id)
);";
