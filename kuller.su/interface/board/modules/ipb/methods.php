<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Defines the allowed methods a remote server may request and the in/out parameters
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @version		$Rev: 10721 $
 *
 */
												
$ALLOWED_METHODS = array();

$ALLOWED_METHODS['fetchOnlineUsers'] = array(
												   'in'  => array(
																	'api_key'           => 'string',
																	'api_module'        => 'string',
																	'sep_character'     => 'string',
															     ),
												   'out' => array(
																	'response' => 'xmlrpc'
																 )
												 );

$ALLOWED_METHODS['fetchStats'] = array(
												   'in'  => array(
																	'api_key'           => 'string',
																	'api_module'        => 'string',
															     ),
												   'out' => array(
																	'response' => 'xmlrpc'
																 )
												 );
												
$ALLOWED_METHODS['fetchTopics'] = array(
												   'in'  => array(
																	'api_key'           => 'string',
																	'api_module'        => 'string',
																	'forum_ids'    		=> 'string',
																	'order_field'       => 'string',
																	'order_by'       	=> 'string',
																	'offset'       		=> 'integer',
																	'limit'       		=> 'integer',
																	'view_as_guest'     => 'integer',
															     ),
												   'out' => array(
																	'response' => 'xmlrpc'
																 )
												 );
$ALLOWED_METHODS['fetchForums'] = array(
												   'in'  => array(
																	'api_key'           => 'string',
																	'api_module'        => 'string',
																	'forum_ids' 		=> 'string',
																	'view_as_guest'     => 'integer',
															     ),
												   'out' => array(
																	'response' => 'xmlrpc'
																 )
												 );
												
$ALLOWED_METHODS['fetchForumsOptionList'] = array(
												   'in'  => array(
																	'api_key'            => 'string',
																	'api_module'         => 'string',
																	'selected_forum_ids' => 'string',
																	'view_as_guest'      => 'integer',
															     ),
												   'out' => array(
																	'response' => 'xmlrpc'
																 )
												 );
												
$ALLOWED_METHODS['checkMemberExists'] = array(
												   'in'  => array(
																	'api_key'            => 'string',
																	'api_module'         => 'string',
																	'search_type'        => 'string',
																	'search_string'      => 'string',
															     ),
												   'out' => array(
																	'response' => 'xmlrpc'
																 )
												 );

$ALLOWED_METHODS['fetchMember'] = array(
												   'in'  => array(
																	'api_key'            => 'string',
																	'api_module'         => 'string',
																	'search_type'        => 'string',
																	'search_string'      => 'string',
															     ),
												   'out' => array(
																	'response' => 'xmlrpc'
																 )
												 );
												
$ALLOWED_METHODS['postReply'] = array(
												   'in'  => array(
																	'api_key'            => 'string',
																	'api_module'         => 'string',
																	'member_field'       => 'string',
																	'member_key'         => 'string',
																	'topic_id'           => 'integer',
																	'post_content'       => 'string',
															     ),
												   'out' => array(
																	'response' => 'xmlrpc'
																 )
												 );
												
$ALLOWED_METHODS['postTopic'] = array(
												   'in'  => array(
																	'api_key'            => 'string',
																	'api_module'         => 'string',
																	'member_field'       => 'string',
																	'member_key'         => 'string',
																	'forum_id'           => 'integer',
																	'topic_title'		 => 'string',
																	'topic_description'  => 'string',
																	'post_content'       => 'string',
															     ),
												   'out' => array(
																	'response' => 'xmlrpc'
																 )
												 );
												
$ALLOWED_METHODS['helloBoard'] = array(
												   'in'  => array(
																	'api_key'            => 'string',
																	'api_module'         => 'string',
															     ),
												   'out' => array(
																	'response' => 'xmlrpc'
																 )
												 );