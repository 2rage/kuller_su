<?php
 
//-----------------------------------------------
// (DP32) Forum Icons
//-----------------------------------------------
//-----------------------------------------------
// MySQL ALTER TABLES & ALTER FIELDS
//-----------------------------------------------
// Author: DawPi
// Site: http://www.ipslink.pl
// Written on: 02 / 08 / 2011
//-----------------------------------------------
// Copyright (C) 2011 DawPi
// All Rights Reserved
//-----------------------------------------------  


/* Forum Icons */

$TABLE[] = "CREATE TABLE dp3_fi_icons (
  i_id 			int(10) 		NOT NULL AUTO_INCREMENT,
  i_fid 		int(10) 		NOT NULL DEFAULT '0',
  i_location 	varchar(255) 	NOT NULL,
  i_enabled		tinyint(1)		NOT NULL DEFAULT '0', 

  PRIMARY KEY (i_id)
)"; 