<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * RSS output plugin :: posts
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Forums
 * @link		http://www.invisionpower.com
 * @since		6/24/2008
 * @version		$Revision: 10721 $
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

class furlRedirect_members
{	
	/**
	 * Key type: Type of action (topic/forum)
	 *
	 * @var		string
	 */
	protected $_type = '';
	
	/**
	 * Key ID
	 *
	 * @var		int
	 */
	protected $_id = 0;
	
	/**
	* Constructor
	*
	*/
	public function __construct( ipsRegistry $registry )
	{
		$this->registry =  $registry;
		$this->DB       =  $registry->DB();
		$this->settings =& $registry->fetchSettings();
	}

	/**
	 * Set the key ID
	 * <code>furlRedirect_forums::setKey( 'topic', 12 );</code>
	 *
	 * @param	string	Type
	 * @param	mixed	Value
	 */
	public function setKey( $name, $value )
	{
		$this->_type = $name;
		$this->_id   = $value;
	}
	
	/**
	 * Set up the key by URI
	 *
	 * @param	string		URI (example: index.php?showtopic=5&view=getlastpost)
	 * @return	@e void
	 */
	public function setKeyByUri( $uri )
	{
		$uri = str_replace( '&amp;', '&', $uri );
		
		if ( strstr( $uri, '?' ) )
		{
			list( $_chaff, $uri ) = explode( '?', $uri );
		}
		
		foreach( explode( '&', $uri ) as $bits )
		{
			list( $k, $v ) = explode( '=', $bits );
			
			if ( $k )
			{
				if ( $k == 'showuser' )
				{
					$this->setKey( 'user', intval( $v ) );
					return TRUE;
				}
			}
		}
		
		return FALSE;
	}
	
	/**
	* Return the SEO title
	*
	* @return	string		The SEO friendly name
	*/
	public function fetchSeoTitle()
	{
		switch ( $this->_type )
		{
			default:
				return FALSE;
			break;
			case 'user':
				return $this->_fetchSeoTitle_user();
			break;
		}
	}

	/**
	* Return the SEO title for a user
	*
	* @return	string		The SEO friendly name
	*/
	public function _fetchSeoTitle_user()
	{
		$member = IPSMember::load( intval( $this->_id ), 'core' );
												
		if ( $member['member_id'] )
		{
			if ( IPB_USE_ONLY_ID_FURL ) 
			{
				return ( $member['members_seo_name'] ) ? $member['members_seo_name'] : IPSText::makeSeoTitle( $member['member_id'] );
			}
			else
			{
			return ( $member['members_seo_name'] ) ? $member['members_seo_name'] : IPSText::makeSeoTitle( $member['members_display_name'] );
			}
		}
		
		return FALSE;
	}
}