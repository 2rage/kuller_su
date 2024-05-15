<?php
/**
 * @file		auth.php		IPS Connect Auth
 *
 * $Copyright: $
 * $License: $
 * $Author: mark $
 * $LastChangedDate: 2011-04-06 04:34:47 -0400 (Wed, 06 Apr 2011) $
 * $Revision: 8267 $
 * @since 		18th July 2012
 */

/**
 *
 * @class	login_ipsconnect
 * @brief	Logic for using Community Suite as an IPS Connect slave
 *
 */
class login_ipsconnect extends login_core implements interface_login
{
	/**
	 * Login method configuration
	 *
	 * @access	protected
	 * @var		array
	 */
	protected $method_config	= array();
	
	/**
	 * IPS Connect configuration
	 *
	 * @access	protected
	 * @var		array
	 */
	protected $connectConfig	= array();
	
	/**
	 * Constructor
	 *
	 * @access	public
	 * @param	object		ipsRegistry reference
	 * @param	array 		Configuration info for this method
	 * @param	array 		Custom configuration info for this method
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry, $method, $conf=array() )
	{
		$this->method_config	= $method;
		$this->connectConfig	= $conf;
		
		require_once IPS_KERNEL_PATH . 'classFileManagement.php';
		$this->cfm = new classFileManagement();
		
		parent::__construct( $registry );
	}
	
	/**
	 * Authenticate the request
	 *
	 * @access	public
	 * @param	string		Username
	 * @param	string		Email Address
	 * @param	string		Password
	 * @return	boolean		Authentication successful
	 */
	public function authenticate( $username, $email_address, $password )
	{	
		//-----------------------------------------
		// Set basic data
		//-----------------------------------------
			
		$send = array(
			'act'		=> 'login',
			'key'		=> $this->connectConfig['master_key'],
			'password'	=> md5( $password )
			);
			
		//-----------------------------------------
		// Load to check if we have master ID already
		//-----------------------------------------
	
		if ( $username )
		{
			$_member = IPSMember::load( $username, 'all', 'username' );
		}
		else
		{
			$_member = IPSMember::load( $email_address, 'all', 'email' );
		}
		
		if ( $_member['ipsconnect_id'] )
		{
			$send['idType'] = 'id';
			$send['id'] = $_member['ipsconnect_id'];
		}
		else
		{
			if ( $username )
			{
				$send['idType'] = 'username';
				$send['id'] = $username;
			}
			else
			{
				$send['idType'] = 'email';
				$send['id'] = $email_address;
			}
		}
		
		//-----------------------------------------
		// Send API Call
		//-----------------------------------------
		
		$send['key'] = md5( $send['key'] . $send['id'] );
			
		$url = $this->connectConfig['master_url'] . '?' . http_build_query( $send );
		$return = $this->cfm->getFileContents( $url );
		$data = @json_decode( $return, TRUE );
		if ( !isset( $data['connect_status'] ) or !$data['connect_status'] )
		{
			$this->return_code = 'WRONG_AUTH';
			return false;
		}
		
		//-----------------------------------------
		// If unsuccessful, return
		//-----------------------------------------
		
		if ( $data['connect_status'] != 'SUCCESS' )
		{
			$this->return_code = $data['connect_status'];
			if ( $this->return_code == 'ACCOUNT_LOCKED' )
			{
				$this->account_unlock = $data['connect_unlock'];
			}
			if ( $this->return_code == 'VALIDATING' )
			{
				$this->revalidate_url = $data['connect_revalidate_url'];
			}
			return false;
		}
		
		//-----------------------------------------
		// Create or update member accordingly
		//-----------------------------------------
		
		$update = array();
				
		$this->member_data = IPSMember::load( $data['connect_id'], 'all', 'ipsconnect' );
		
		if ( !isset( $this->member_data['member_id'] ) and isset( $_member['member_id'] ) )
		{
			$this->member_data = $_member;
			$update['ipsconnect_id'] = $data['connect_id'];
		}
		
		if ( !isset( $this->member_data['member_id'] ) )
		{
			if( IPSText::mbstrlen( $data['connect_username'] ) > ipsRegistry::$settings['max_user_name_length'] )
			{
				$data['connect_username']	= IPSText::mbsubstr( $data['connect_username'], 0, ipsRegistry::$settings['max_user_name_length'] );
			}

			$this->member_data = $this->createLocalMember( array( 'members' => array( 'name' => $data['connect_username'], 'members_display_name' => $data['connect_displayname'], 'email' => $email_address, 'password' => $password, 'ipsconnect_id' => $data['connect_id'] ) ) );
		}
		else
		{
			if ( $this->member_data['name'] != $data['connect_username'] and !defined( 'CONNECT_NOSYNC_NAMES' ) )
			{
				$update['name'] = $data['connect_username'];
			}
			if ( $this->member_data['members_display_name'] != $data['connect_displayname'] and !defined( 'CONNECT_NOSYNC_NAMES' ) )
			{
				$update['members_display_name'] = $data['connect_displayname'];
			}
			if ( $this->member_data['email'] != $data['connect_email'] )
			{
				$update['email'] = $data['connect_email'];
			}
			
			if ( !empty( $update ) )
			{
				IPSMember::save( $this->member_data['member_id'], array( 'members' => $update ) );
			}
			
			IPSMember::updatePassword( $this->member_data['member_id'], md5( $password ) );
		}
		
		//-----------------------------------------
		// If this is ACP, just log in without SSO
		//-----------------------------------------
		
		if ( $this->is_admin_auth or $this->is_password_check )
		{
			$this->return_code = 'SUCCESS';
			return;
		}
		
		//-----------------------------------------
		// And redirect to log us in centrally
		//-----------------------------------------
						
		$redirect = $this->request['referer'] ? $this->request['referer'] : $this->settings['board_url'];
		if ( strpos( $redirect, '?' ) === FALSE )
		{
			$redirect .= '?';
		}
				
		$this->registry->output->silentRedirect( $url . '&noparams=1&redirect=' . base64_encode( $redirect ) . '&redirectHash=' . md5( $this->connectConfig['master_key'] . base64_encode( $redirect ) ) );
	}
	
	
	/**
	 * Logout callback - called when a user logs out
	 *
	 * @param	array		Member Data
	 */
	public function logoutCallback( $memberData )
	{
		if ( !$memberData['ipsconnect_id'] )
		{
			$memberData['ipsconnect_id'] = $this->_getIpsConnectId( $memberData );
		}
		
		$redirect = base64_encode( $this->request['return'] ? urldecode( $this->request['return'] ) : $this->settings['base_url'] );
		
		$this->registry->output->silentRedirect( $this->connectConfig['master_url'] . '?' . http_build_query( array(
			'act'			=> 'logout',
			'id'			=> $memberData['ipsconnect_id'],
			'key'			=> md5( $this->connectConfig['master_key'] . $memberData['ipsconnect_id'] ),
			'redirect'		=> $redirect,
			'redirectHash'	=> md5( $this->connectConfig['master_key'] . $redirect )
			) ) );
		return;
	}
	
	/**
	 * Check if the username is already in use
	 *
	 * @param	string		User Name
	 * @param	string		Array of member data
	 * @param	srting		Field to check, members_l_username or members_l_display_name
	 * @return	boolean		Authenticate successful
	 */
	public function nameExistsCheck( $username, $memberData, $field )
	{
		if ( defined( 'CONNECT_NOSYNC_NAMES' ) )
		{
			return false;
		}
	
		$this->return_code = 'METHOD_NOT_DEFINED';
		
		if ( $field == 'name' or $field == 'members_l_username' )
		{
			$data = array( 'username' => $username );
		}
		else
		{
			$data = array( 'displayname' => $username ); 
		}
		
		if ( !$memberData['ipsconnect_id'] )
		{
			$memberData['ipsconnect_id'] = $this->_getIpsConnectId( $memberData );
		}
			
		$return = $this->cfm->getFileContents( $this->connectConfig['master_url'] . '?' . http_build_query( array_merge( array( 'act' => 'check', 'key' => $this->connectConfig['master_key'], 'id' => $memberData['ipsconnect_id'] ), $data ) ) );
		if ( $return = @json_decode( $return, TRUE ) )
		{
			if ( $return['status'] == 'SUCCESS' )
			{
				if ( $field == 'name' or $field == 'members_l_username' )
				{
					if ( $return['username'] )
					{
						$this->return_code = 'NAME_NOT_IN_USE';
					}
					else
					{
						$this->return_code = 'WRONG_AUTH';
					}
				}
				else
				{
					if ( $return['displayname'] )
					{
						$this->return_code = 'NAME_NOT_IN_USE';
					}
					else
					{
						$this->return_code = 'WRONG_AUTH';
					}
				}
			}
		}

	}
	
	/**
	 * Check if the email is already in use
	 *
	 * @param	string		Email address
	 * @return	boolean		Authenticate successful
	 */
	public function emailExistsCheck( $email )
	{
		$this->return_code = 'METHOD_NOT_DEFINED';
				
		$return = $this->cfm->getFileContents( $this->connectConfig['master_url'] . '?' . http_build_query( array( 'act' => 'check', 'key' => $this->connectConfig['master_key'], 'email' => $email ) ) );

		if ( $return = @json_decode( $return, TRUE ) )
		{
			if ( $return['status'] == 'SUCCESS' )
			{			
				if ( $return['email'] )
				{
					$this->return_code = 'EMAIL_NOT_IN_USE';
				}
				else
				{
					$this->return_code = 'WRONG_AUTH';
				}
			}
		}
	}
	
	/**
	 * Create a user's account
	 *
	 * @param	array		Array of member information
	 * @return	boolean		Account created successfully
	 */
	public function createAccount( $member )
	{
		$this->return_code = 'FAIL';
			
		$return = $this->cfm->getFileContents( $this->connectConfig['master_url'] . '?' . http_build_query( array(
			'act'			=> 'register',
			'key'			=> $this->connectConfig['master_key'],
			'username'		=> $member['name'],
			'displayname'	=> $member['members_display_name'],
			'password'		=> md5( $member['password'] ),
			'email'			=> $member['email'],
			'revalidateurl'	=> base64_encode( ipsRegistry::getClass('output')->buildUrl( 'app=core&amp;module=global&amp;section=register&amp;do=reval', 'public' ) )
			) ) );
						
		if ( $return = @json_decode( $return, TRUE ) )
		{
			if ( $return['status'] == 'SUCCESS' )
			{
				$this->return_code = 'SUCCESS';
				
				IPSMember::save( $member['member_id'], array( 'members' => array( 'ipsconnect_id' => $return['id'] ) ) );
			}
		}
	}
	
	/**
	 * Change a user's email address
	 *
	 * @param	string		Old Email address
	 * @param	string		New Email address
	 * @return	boolean		Email changed successfully
	 */
	public function changeEmail( $oldEmail, $newEmail )
	{
		$this->return_code = 'FAIL';
		
		$member = IPSMember::load( $oldEmail, 'none', 'email' );
		
		if ( !$member['ipsconnect_id'] )
		{
			$member['ipsconnect_id'] = $this->_getIpsConnectId( $member );
		}
				
		$return = $this->cfm->getFileContents( $this->connectConfig['master_url'] . '?' . http_build_query( array( 'act' => 'change', 'key' => md5( $this->connectConfig['master_key'] . $member['ipsconnect_id'] ), 'id' => $member['ipsconnect_id'], 'email' => $newEmail ) ) );
				
		if ( $return = @json_decode( $return, TRUE ) )
		{
			if ( $return['status'] == 'SUCCESS' )
			{			
				$this->return_code = 'SUCCESS';
			}
		}
	}
	
	/**
	 * Change a user's password
	 *
	 * @param	string		Email address
	 * @param	string		New password
	 * @param	string		Plain Text Password
	 * @param	string		Member Array
	 * @return	boolean		Password changed successfully
	 */
  	public function changePass( $email, $new_pass, $plain_pass, $member )
	{
		$this->return_code = 'FAIL';
		
		if ( !$member['ipsconnect_id'] )
		{
			$member['ipsconnect_id'] = $this->_getIpsConnectId( $member );
		}
							
		$return = $this->cfm->getFileContents( $this->connectConfig['master_url'] . '?' . http_build_query( array( 'act' => 'change', 'key' => md5( $this->connectConfig['master_key'] . $member['ipsconnect_id'] ), 'id' => $member['ipsconnect_id'], 'password' => $new_pass ) ) );
		if ( $return = @json_decode( $return, TRUE ) )
		{
			if ( $return['status'] == 'SUCCESS' )
			{			
				$this->return_code = 'SUCCESS';
			}
		}
	}
	
	/**
	 * Change a login name
	 *
	 * @param	string		Old Name
	 * @param	string		New Name
	 * @param	string		User's email address
	 * @param	array 		Array of Member Data
	 * @param	string		name or members_display_name
	 * @return	boolean		Request was successful
	 */
	public function changeName( $oldName, $newName, $email, $member, $type='name' )
	{
		if ( defined( 'CONNECT_NOSYNC_NAMES' ) )
		{
			return false;
		}
		
		$this->return_code = 'FAIL';
		
		if ( !$member['ipsconnect_id'] )
		{
			$member['ipsconnect_id'] = $this->_getIpsConnectId( $member );
		}
				
		$data = array( 'act' => 'change', 'key' => md5( $this->connectConfig['master_key'] . $member['ipsconnect_id'] ), 'id' => $member['ipsconnect_id'] );
		if ( $type == 'name' )
		{
			$data['username'] = $newName;
		}
		else
		{
			$data['displayname'] = $newName;
		}
											
		$return = $this->cfm->getFileContents( $this->connectConfig['master_url'] . '?' . http_build_query( $data ) );
		if ( $return = @json_decode( $return, TRUE ) )
		{
			if ( $return['status'] == 'SUCCESS' )
			{			
				$this->return_code = 'SUCCESS';
			}
		}
	}
	
	/**
  	 * Validate Account
  	 *
  	 * @param	array	Member data
  	 */
  	public function validateAccount( $member )
  	{
  		$this->return_code = 'FAIL';
		
		if ( !$member['ipsconnect_id'] )
		{
			$member['ipsconnect_id'] = $this->_getIpsConnectId( $member );
		}
							
		$return = $this->cfm->getFileContents( $this->connectConfig['master_url'] . '?' . http_build_query( array( 'act' => 'validate', 'key' => md5( $this->connectConfig['master_key'] . $member['ipsconnect_id'] ), 'id' => $member['ipsconnect_id'] ) ) );
		if ( $return = @json_decode( $return, TRUE ) )
		{
			if ( $return['status'] == 'SUCCESS' )
			{			
				$this->return_code = 'SUCCESS';
			}
		}
  	}
  	
  	/**
  	 * Delete Account
  	 *
  	 * @param	array	Member data
  	 */
  	public function deleteAccount( $id )
  	{
  		$this->return_code = 'FAIL';
  		
  		$ids = array();
  		
  		ipsRegistry::DB()->build( array( 'select' => 'member_id, ipsconnect_id, email', 'from' => 'members', 'where' => ipsRegistry::DB()->buildWherePermission( is_array( $id ) ? $id : array( $id ), 'member_id', FALSE ) ) );
  		ipsRegistry::DB()->execute();
  		while ( $row = ipsRegistry::DB()->fetch() )
  		{
	  		$ids[] = $row['ipsconnect_id'] ? $row['ipsconnect_id'] : $this->_getIpsConnectId( $row );
  		}
		
		$return = $this->cfm->getFileContents( $this->connectConfig['master_url'] . '?' . http_build_query( array( 'act' => 'delete', 'key' => md5( $this->connectConfig['master_key'] . json_encode( $ids ) ), 'id' => $ids ) ) );
		if ( $return = @json_decode( $return, TRUE ) )
		{
			if ( $return['status'] == 'SUCCESS' )
			{			
				$this->return_code = 'SUCCESS';
			}
		}
  	}
	
	/**
	 * Populate IPS Connect ID
	 *
	 * @param	array	Member Data
	 * @return	int		IPS Connect ID
	 */
	protected function _getIpsConnectId( $member )
	{
		$getId = $this->cfm->getFileContents( $this->connectConfig['master_url'] . '?' . http_build_query( array( 'act' => 'login', 'id' => $member['email'], 'idType' => 'email', 'key' => md5( $this->connectConfig['master_key'] . $member['email'] ) ) ) );
		if ( $getId = json_decode( $getId, TRUE ) and isset( $getId['connect_id'] ) )
		{
			IPSMember::save( $member['member_id'], array( 'members' => array( 'ipsconnect_id' => $getId['connect_id'] ) ) );
		
			return $getId['connect_id'];
		}
		else
		{
			return NULL;
		}
	}
	
	
	
}