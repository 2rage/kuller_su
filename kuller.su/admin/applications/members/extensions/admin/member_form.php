<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Member form manipulation
 * Last Updated: $Date: 2012-08-22 10:47:20 -0400 (Wed, 22 Aug 2012) $
 * </pre>
 *
 * @author 		$Author: mmecham $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Members
 * @link		http://www.invisionpower.com
 * @since		1st march 2002
 * @version		$Revision: 11250 $
 *
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

class admin_member_form__members implements admin_member_form
{

	/**
	 * Tab name
	 * This can be left blank and the application title will
	 * be used
	 *
	 * @var		string			Tab name
	 */
	public $tab_name = "";
	
	/**
	 * Returns sidebar links for this tab
	 * You may return an empty array or FALSE to not have
	 * any links show in the sidebar for this block.
	 *
	 * The links must have 'section=xxxxx&module=xxxxx[&do=xxxxxx]'. The rest of the URL
	 * is added automatically.
	 *
	 * The image must be a full URL or blank to use a default image.
	 *
	 * Use the format:
	 * $array[] = array( 'img' => '', 'url' => '', 'title' => '' );
	 *
	 * @author	Matt Mecham
	 * @param	array 			Member data
	 * @return	array 			Array of links
	 */
	public function getSidebarLinks( $member=array() )
	{
		
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'admin_members' ), 'members' );

		$array = array();

		if( ipsRegistry::getClass('class_permissions')->checkPermission( 'membertools_delete_pms', 'members', 'members' ) )
		{
			$array[] = array( 'img'   => '', 
							  'url'   => 'section=tools&amp;module=members&amp;do=deleteMessages',
							  'title' => ipsRegistry::getClass('class_localization')->words['form_deletepms'] );
		}
		
		if( ipsRegistry::getClass('class_permissions')->checkPermission( 'membertools_ip', 'members', 'members' ) )
		{
			$array[] = array( 'img'   => '', 
							  'url'   => 'section=tools&amp;module=members&amp;do=show_all_ips',
							  'title' => ipsRegistry::getClass('class_localization')->words['form_showallips'] );
		}

		if( ipsRegistry::getClass('class_permissions')->checkPermission( 'member_suspend', 'members', 'members' ) )
		{
			if( $member['temp_ban'] )
			{
				$array[] = array( 'img'   => '', 
								  'url'   => 'section=members&amp;module=members&amp;do=unsuspend',
								  'title' => ipsRegistry::getClass('class_localization')->words['form_unsuspendmem'] );
			}
			else
			{
				$array[] = array( 'img'   => '', 
								  'url'   => 'section=members&amp;module=members&amp;do=banmember',
								  'title' => ipsRegistry::getClass('class_localization')->words['form_suspendmem'] );	
			}
		}
		
		if( ipsRegistry::getClass('class_permissions')->checkPermission( 'members_merge', 'members', 'members' ) )
		{
			$array[] = array( 'img'   => '', 
							  'url'   => 'section=tools&amp;module=members&amp;do=merge',
							  'title' => ipsRegistry::getClass('class_localization')->words['form_mergemember'] );
		}
		
		$array[] = array( 'img'   => '', 
						  'url'   => "<a href='" . ipsRegistry::getClass('output')->buildSeoUrl( "showuser={$member['member_id']}", 'public', $member['members_seo_name'], 'showuser' ) . "' target='_blank'>" . ipsRegistry::getClass('class_localization')->words['form_profilemember'] . '</a>',
						  'title' => '' );
							  
		

		return $array;
	}
	
	/**
	 * Returns content for the page.
	 *
	 * @author	Matt Mecham
	 * @param	array 				Member data
	 * @return	array 				Array of tabs, content
	 */
	public function getDisplayContent( $member=array(), $tabsUsed=5 )
	{
		return array( 'tabs' => '', 'content' => '', 'tabsUsed' => 0 );
	}
	
	/**
	 * Process the entries for saving and return
	 *
	 * @author	Brandon Farber
	 * @return	array 				Multi-dimensional array (core, extendedProfile) for saving
	 */
	public function getForSave()
	{
		return array( 'core' => array(), 'extendedProfile' => array() );
	}

}