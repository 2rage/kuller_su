<?php
/*
+--------------------------------------------------------------------------
|   IP.Board v3.4.2
|   ========================================
|   by Matthew Mecham
|   (c) 2001 - 2009 Invision Power Services
|   http://www.invisionpower.com
|   ========================================
|   Web: http://www.invisionboard.com
|   Email: matt@invisionpower.com
|   Licence Info: http://www.invisionboard.com/?license
+---------------------------------------------------------------------------
*/

# 3.0.1

$SQL[] = "ALTER TABLE  core_sys_lang CHANGE  lang_title  lang_title VARCHAR( 255 ) NOT NULL;";

# PM bug
$SQL[] = "DELETE FROM message_topic_user_map WHERE map_user_active=0 AND map_is_system=0 AND map_user_banned=0 AND map_is_starter=1;";

?>