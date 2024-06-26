<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Profile AJAX Tab Loader
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Members
 * @link		http://www.invisionpower.com
 * @since		Tuesday 1st March 2005 (11:52)
 * @version		$Revision: 10721 $
 *
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

class public_members_ajax_rate extends ipsAjaxCommand 
{
	/**
	 * Class entry point
	 *
	 * @param	object		Registry reference
	 * @return	@e void		[Outputs to screen]
	 */
	public function doExecute( ipsRegistry $registry ) 
	{
    	//-----------------------------------------
    	// INIT
    	//-----------------------------------------
    	
		$rating_id	= intval($this->request['rating']);
		$rating_id	= $rating_id > 5 ? 5 : $rating_id;
		$rating_id	= $rating_id < 0 ? 0 : $rating_id;
		$member_id	= intval($this->request['member_id']);
		$member		= array();
		$type		= 'new';
		$md5_check	= IPSText::md5Clean( $this->request['md5check'] );
		$error 		= array();
		
    	//-----------------------------------------
    	// Check
    	//-----------------------------------------
    	
    	if ( ! $this->settings['pp_allow_member_rate'] )
    	{
			$error['error_key'] = 'user_rate_no_perm';
			$this->returnJsonArray( $error );
		}    	
    	
    	if ( ! $member_id OR ! $this->memberData['member_id'] OR $member_id == $this->memberData['member_id'] )
    	{
			$error['error_key'] = 'user_rate_no_perm';
			$this->returnJsonArray( $error );
    	}
    	
		//-----------------------------------------
		// MD5 check
		//-----------------------------------------
		
		if (  $md5_check != $this->member->form_hash )
    	{
			$error['error_key'] = 'user_rate_no_perm3';
			$this->returnJsonArray( $error );
    	}
    	
    	$member = IPSMember::load( $member_id, 'extendedProfile,groups' );
    	
    	if ( ! $member['member_id'] )
    	{
			$error['error_key'] = 'user_rate_no_perm4';
			$this->returnJsonArray( $error );
    	}
    	
    	//-----------------------------------------
    	// Have we already rated?
    	//-----------------------------------------
    			
		$rating = $this->DB->buildAndFetch( array(	'select'	=> '*',
															'from'		=> 'profile_ratings',
															'where'		=> "rating_for_member_id={$member_id} AND rating_by_member_id=" . $this->memberData['member_id'] ) );
    	
		//-----------------------------------------
		// Already rated?
		//-----------------------------------------
		
		if ( $rating['rating_id'] )
		{
			//-----------------------------------------
			// Do we allow re-ratings?
			//-----------------------------------------
			
			if ( $rating_id != $rating['rating_value'] )
			{
				$member['pp_rating_value'] = intval( $member['pp_rating_value'] );
				$member['pp_rating_value'] = ( $member['pp_rating_value'] + $rating_id ) - $rating['rating_value'];
				
				$this->DB->update( 'profile_ratings', array( 'rating_value' => $rating_id ), 'rating_id=' . $rating['rating_id'] );
				
				$this->DB->update( 'profile_portal', array(	'pp_rating_value'	=> $member['pp_rating_value'],
				 												'pp_rating_real'	=> round( $member['pp_rating_value'] / $member['pp_rating_hits'] ) ), 'pp_member_id=' . $member_id );
				
				$type = 'update';
			}
		}
		
		//-----------------------------------------
		// NEW RATING!
		//-----------------------------------------
		
		else
		{
			$member['pp_rating_value']	= intval($member['pp_rating_value']) + $rating_id;
			$member['pp_rating_hits']	= intval($member['pp_rating_hits'])  + 1;
			
			$this->DB->insert( 'profile_ratings', array( 'rating_for_member_id'	=> $member_id,
															'rating_by_member_id'	=> $this->memberData['member_id'],
															'rating_value'			=> $rating_id,
															'rating_ip_address'		=> $this->member->ip_address ) );
																    
			$this->DB->update( 'profile_portal', array(	'pp_rating_hits'	=> intval($member['pp_rating_hits']),
															'pp_rating_value'	=> intval($member['pp_rating_value']),
															'pp_rating_real'	=> round( $member['pp_rating_value'] / $member['pp_rating_hits'] ) ), 'pp_member_id=' . $member_id );

			
		}
    	
		$member['pp_rating_real'] = round( $member['pp_rating_value'] / $member['pp_rating_hits'] );

	   	$return	= array(
	   					'rating'	=> $member['pp_rating_value'],
	   					'total'		=> $member['pp_rating_real'],
	   					'average'	=> $member['pp_rating_real'],
	   					'rated'		=> $type
	   					);

		$this->outputResult( $return, $member );
	}
	
	/**
	 * Utility method to make hooking into file easier
	 *
	 * @param	array 		Data to return
	 * @param	array 		Member data
	 * @return	@e void
	 */
	protected function outputResult( $return, $member )
	{
		$this->returnJsonArray( $return );
	}
}