----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 Date: Sun, 19 May 2013 14:37:48 +0000
 Error: 1054 - Unknown column 'location' in 'field list'
 IP Address: 178.65.80.66 - /index.php
 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 mySQL query error: INSERT INTO sessions (`id`,`member_name`,`seo_name`,`member_id`,`ip_address`,`browser`,`running_time`,`login_type`,`location`,`member_group`,`in_error`,`location_1_type`,`location_1_id`,`location_2_type`,`location_2_id`,`current_appcomponent`,`current_module`,`current_section`,`uagent_key`,`uagent_version`,`uagent_type`,`uagent_bypass`,`search_thread_id`,`search_thread_time`,`isgenerated`) VALUES('46792f3d6257ffe6323111a9513e36d7','m1k','m1k',10,'178.65.80.66','Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 2.0.50727; Zune 2.0)',1368973599,0,'',3,0,'',0,'',0,'core','search','','safari',4,'browser',0,0,0,1)
 .--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------.
 | File                                                                       | Function                                                                      | Line No.          |
 |----------------------------------------------------------------------------+-------------------------------------------------------------------------------+-------------------|
 | hooks/trafficGenerator_0aee25e739d9f6522e15612f497cff57.php                | [db_main_mysql].insert                                                        | 248               |
 '----------------------------------------------------------------------------+-------------------------------------------------------------------------------+-------------------'
 | hooks/trafficGenerator_0aee25e739d9f6522e15612f497cff57.php                | [trafficGenerator].generateTraffic                                            | 9                 |
 '----------------------------------------------------------------------------+-------------------------------------------------------------------------------+-------------------'
 | admin/sources/base/ipsController.php                                       | [trafficGenerator].doExecute                                                  | 306               |
 '----------------------------------------------------------------------------+-------------------------------------------------------------------------------+-------------------'