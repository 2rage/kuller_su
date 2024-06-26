<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Permissions management
 * Last Updated: $Date: 2012-12-21 13:31:16 -0500 (Fri, 21 Dec 2012) $
 * </pre>
 *
 * @author 		$Author: AndyMillne $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Members
 * @link		http://www.invisionpower.com
 * @version		$Revision: 11748 $
 */

if ( ! defined( 'IN_ACP' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded 'admin.php'.";
	exit();
}


class admin_members_groups_permissions extends ipsCommand
{
	/**
	 * Skin object
	 *
	 * @var		object			Skin templates
	 */
	protected $html;
	
	/**
	 * Shortcut for url
	 *
	 * @var		string			URL shortcut
	 */
	protected $form_code;
	
	/**
	 * Shortcut for url (javascript)
	 *
	 * @var		string			JS URL shortcut
	 */
	protected $form_code_js;
	
	/**
	 * Main class entry point
	 *
	 * @param	object		ipsRegistry reference
	 * @return	@e void		[Outputs to screen]
	 */
	public function doExecute( ipsRegistry $registry ) 
	{
		/* Load Skin and Lang */
		$this->html	= $this->registry->output->loadTemplate('cp_skin_permissions');
		$this->registry->class_localization->loadLanguageFile( array( 'admin_permissions' ) );
		
		/* URL Bits */
		$this->form_code	= $this->html->form_code	= 'module=groups&amp;section=permissions&amp;';
		$this->form_code_js	= $this->html->form_code_js	= 'module=groups&section=permissions&';
		
		/* What to do */
		switch( $this->request['do'] )
		{
			case 'delete_set':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'perms_delete' );
				$this->_doDeleteSet();
			break;
			
			case 'do_create_set':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'perms_manage' );
				$this->_doCreatePermissionSet();
			break;
			
			case 'do_edit_set':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'perms_manage' );
				$this->_permissionSaveForm();
			break;
			
			case 'edit_set_form':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'perms_manage' );
				$this->_permissionSetForm();
			break;
			
			case 'view_perm_users':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'perms_manage' );
				$this->permissionSetUsers();
			break;	
			
			case 'remove_mask':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'perms_manage' );
				$this->removePermissionSet();
			break;					
			
			case 'overview':
			default:
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'perms_manage' );
				$this->_mainScreen();
			break;
		}
		
		/* Output */
		$this->registry->getClass('output')->html_main .= $this->registry->getClass('output')->global_template->global_frame_wrapper();
		$this->registry->getClass('output')->sendOutput();
	}
	
	
	/**
	 * Removes permission set(s) from a user
	 *
	 * @return	@e void
	 */
	public function removePermissionSet()
	{
		/* INI */
		$member_id = intval( $this->request['id'] );
		$perm_id   = $this->request['pid'];
		
		if( ! $member_id )
		{
			$this->registry->output->showError( $this->lang->words['per_memid'], 11338 );
		}
		
		/* Get the member */
		$this->DB->build( array( 'select' => 'member_id, members_display_name, org_perm_id', 'from' => 'members', 'where' => "member_id={$member_id}" ) );
		$this->DB->execute();
		
		if( ! $mem = $this->DB->fetch() )
		{
			$this->registry->output->showError( $this->lang->words['per_memid'], 11339 );
		}
		
		/* Remove all permission sets */
		if( $perm_id == 'all' )
		{
			$this->DB->update( 'members', array( 'org_perm_id' => 0 ), "member_id={$member_id}" );
		}
		/* Remove specific permission set */
		else
		{
			/* Make Safe */
			$perm_id = intval( $perm_id );
			
			/* Get an array of permission ids */
			$pid_array = explode( ",", IPSText::cleanPermString( $mem['org_perm_id'] ) );
			
			/* If there's only one, then we can just remove it */
			if( count( $pid_array ) < 2 )
			{
				$this->DB->update( 'members', array( 'org_perm_id' => 0 ), "member_id={$member_id}" );
			}
			else
			{
				/* Remove the specified element */
				unset( $pid_array[ array_search( $perm_id, $pid_array ) ] );
				
				/* Update the database */
				$this->DB->update( 'members', array( 'org_perm_id' => implode( ",", $pid_array ) ), "member_id={$member_id}" );
			}	
		}
			
		/* Output */
		$this->registry->output->html .= $this->html->permissionSetRemoveDone( $mem['members_display_name'] );
		$this->registry->output->printPopupWindow();
	}	
	
	/**
	 * Show users that are assigned the specified permission set
	 *
	 * @return	@e void
	 */
	public function permissionSetUsers()
	{
		/* Check ID */
		$perm_id = intval( $this->request['id'] );
		
		if( ! $perm_id )
		{
			$this->registry->output->showError( $this->lang->words['per_setid'], 11340 );
		}
		
		/* Query the permission set */
		$this->DB->build( array( 'select' => '*', 'from' => 'forum_perms', 'where' => "perm_id={$perm_id}" ) );
		$this->DB->execute();
		
		if ( ! $perms = $this->DB->fetch() )
		{
			$this->registry->output->showError( $this->lang->words['per_setid'], 11341 );
		}
		
		/* Query the users who have this set */
		$this->DB->build( array( 
									'select' => 'member_id, members_display_name, email, posts, org_perm_id',
									'from'   => 'members',
									'where'  => "(org_perm_id IS NOT NULL AND org_perm_id != '')",
									'order'  => 'name' 
							)	 );
		$outer = $this->DB->execute();
		
		/* Loop through the users */
		$rows = array();
		
		while( $r = $this->DB->fetch( $outer ) )
		{
			/* Arrayize the perm ids */
			$exp_pid = explode( ",", IPSText::cleanPermString( $r['org_perm_id'] ) );
		
			/* Loop through the ids */
			foreach( $exp_pid as $pid )
			{
				/* Is the perm id we are looking for? */
				if( $pid == $perm_id )
				{
					/* What other sets is this member using? */
					if( count( $exp_pid ) > 1 )
					{
						/* INI the extra field */
						$extra = "<em style='color:red'>";
						
						/* Query the set names */
						$this->DB->build( array( 
												'select' => '*', 
												'from'   => 'forum_perms', 
												'where'  => "perm_id IN (" . IPSText::cleanPermString( $r['org_perm_id'] ) . ") AND perm_id <> {$perm_id}" 
										)	);
						$this->DB->execute();
						
						/* Add each set to the extra field */
						while( $mr = $this->DB->fetch() )
						{
							$extra .= $mr['perm_name'].",";
						}
						
						/* Finish the extra field */
						$extra = rtrim( $extra, ',' );						
						$extra .= "</em>";
					}
					/* No other sets in use */
					else
					{
						$extra = "";
					}
					
					/* Add to array */
					$r['_extra'] = $extra;
					
					$rows[] = $r;
				}
			}
		}
		
		/* Output */
		$this->registry->output->html .= $this->html->permissionSetUsers( $perm_id, $perms['perm_name'], $rows );
		$this->registry->output->printPopupWindow();
	}	
	
	/**
	 * Deletes a permission set
	 *
	 * @return	@e void		[Outputs to screen]
	 */
	protected function _doDeleteSet()
	{
		/* INIT */
		$id  = $this->request['id'];
		
		/* Permissions Class */
		$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/classes/class_public_permissions.php', 'classPublicPermissions' );
		$perm_obj    = new $classToLoad( $this->registry );
		
		/* Loop through applications */
		$where = array();
		
		foreach( $this->registry->getApplications() as $app )
		{
			/* Check to see if there is a permission map */
			$_file = IPSLib::getAppDir( $app['app_directory'] ) . '/extensions/coreExtensions.php';
			
			if( is_file( $_file ) )
			{
				/* Get the permission mappings */
				$_PERM_CONFIG = array();
				require_once( $_file );/*noLibHook*/
				
				/* Check for a config array */
				if( is_array( $_PERM_CONFIG ) && count( $_PERM_CONFIG ) )
				{
					/* Loop through the types */
					foreach( $_PERM_CONFIG as $perm_type )
					{
						$where[] = " app='{$app['app_directory']}' AND perm_type='" . strtolower( $perm_type ) . "' ";
					}
				}
			}
		}

		/* Query Permission Rows */
		$this->DB->build( array( 'select' => '*', 'from' => 'permission_index', 'where' => implode( ' OR ', $where ) ) );
		$outer = $this->DB->execute();
		
		while( $r = $this->DB->fetch( $outer ) )
		{
			foreach( array( 'perm_view', 'perm_2', 'perm_3', 'perm_4', 'perm_5', 'perm_6', 'perm_7' ) as $p )
			{
				if( $r[$p] != '*' )
				{
					$_perm_arr = explode( ',', IPSText::cleanPermString( $r[$p] ) );
					
					if( in_array( $id, $_perm_arr ) )
					{
						unset( $_perm_arr[ array_search( $id, $_perm_arr ) ] );
					}
					
					$r[$p] = ',' . implode( ',', $_perm_arr ) . ',';
				}
			}
			
			$update = $r;
			
			unset( $update['perm_id'] );
			
			/* Update */
			$this->DB->update( 'permission_index', $update, "perm_id={$r['perm_id']}" );
		}
		
		/* Delete */
		$this->DB->delete( 'forum_perms', "perm_id=" . $id );

		/* Fire callbacks */
		$this->_fireAppCallbacks();
		
		/* Done */
		$this->registry->output->global_message	= $this->lang->words['per_removed'];
		$this->registry->output->silentRedirectWithMessage( $this->settings['base_url'] . $this->form_code );
	}
	
	/**
	 * Creates a nwe permission set
	 *
	 * @return	@e void		[Outputs to screen]
	 */	
	protected function _doCreatePermissionSet()
	{
		/* INIT */
		$set_name = $this->request['new_perm_name'];
		$base_on  = $this->request['new_perm_copy'];
		
		if( ! $set_name )
		{
			$this->registry->output->global_message = $this->words['err_specify_set_name'];
			$this->_mainScreen();
			return;
		}
		
		/* Permissions Class */
		$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/classes/class_public_permissions.php', 'classPublicPermissions' );
		$perm_obj    = new $classToLoad( $this->registry );
		
		/* Loop through applications */
		$where = array();
		
		foreach( $this->registry->getApplications() as $app )
		{
			/* Check to see if there is a permission map */
			$_file = IPSLib::getAppDir( $app['app_directory'] ) . '/extensions/coreExtensions.php';
			
			if( is_file( $_file ) )
			{
				/* Get the permission mappings */
				$_PERM_CONFIG = array();
				require_once( $_file );/*noLibHook*/
				
				/* Check for a config array */
				if( is_array( $_PERM_CONFIG ) && count( $_PERM_CONFIG ) )
				{
					/* Loop through the types */
					foreach( $_PERM_CONFIG as $perm_type )
					{
						$where[] = " app='{$app['app_directory']}' AND perm_type='" . strtolower( $perm_type ) . "' ";
					}
				}
			}
		}
		
		/* Create the set */
		$this->DB->insert( 'forum_perms', array( 'perm_name' => $set_name ) );
		$new_set_id = $this->DB->getInsertId();
			
		/* Query Permission Rows */
		$this->DB->build( array( 'select' => '*', 'from' => 'permission_index', 'where' => implode( ' OR ', $where ) ) );
		$outer = $this->DB->execute();
		
		while( $r = $this->DB->fetch( $outer ) )
		{
			$perm_id = $r['perm_id'];
			
			foreach( array( 'perm_view', 'perm_2', 'perm_3', 'perm_4', 'perm_5', 'perm_6', 'perm_7' ) as $p )
			{
				if( $r[$p] != '*' )
				{
					if( in_array( $base_on, explode( ',', IPSText::cleanPermString( $r[$p] ) ) ) )
					{
						$r[$p] .= $new_set_id . ',';
					}
					
				}
			}
			
			/* Unset main ID */
			unset( $r['perm_id'] );
			
			/* Update */
			$this->DB->update( 'permission_index', $r, "perm_id=" . $perm_id );
		}
		
		/* Fire callbacks */
		$this->_fireAppCallbacks();
		
		/* Done */
		$this->registry->output->global_message	= $this->lang->words['per_saved'];
		$this->registry->output->silentRedirectWithMessage( $this->settings['base_url'] . $this->form_code . 'do=edit_set_form&amp;id=' . $new_set_id );
	}
	
	/**
	 * Saves the global permission set form
	 *
	 * @return	@e void		[Outputs to screen]
	 */
	protected function _permissionSaveForm()
	{
		/* ID */
		$id        = intval( $this->request['id'] );
		$matricies = array();
		
		/* Query Set Name */
		$set_data = $this->DB->buildAndFetch( array( 'select' => '*', 'from' => 'forum_perms', 'where' => "perm_id={$id}" ) );
		
		/* Permissions Class */
		$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/classes/class_public_permissions.php', 'classPublicPermissions' );
		$perm_obj    = new $classToLoad( $this->registry );
		
		/* Save */
		$perm_obj->saveItemPermMatrix( $this->request['perms'], $id, $this->request['apps'] );
		
		if( $this->request['perm_name'] != $set_data['perm_name'] )
		{
			$this->DB->update( 'forum_perms', array( 'perm_name' => $this->request['perm_name'] ), "perm_id={$id}" );
		}
		
		/* Fire callbacks */
		$this->_fireAppCallbacks();
		
		/* Done */
		$this->registry->output->global_message	= $this->lang->words['per_saved'];
		$this->registry->output->silentRedirectWithMessage( $this->settings['base_url'] . $this->form_code . '&amp;_from=' . $this->request['_from'] );
	}	
	
	/**
	 * Form for modifying a permission set
	 *
	 * @return	@e void		[Outputs to screen]
	 */
	protected function _permissionSetForm()
	{
		/* ID */
		$id			= intval( $this->request['id'] );
		$matricies	= array();
		$apps		= array();
		
		/* Query Set Name */
		$set_data = $this->DB->buildAndFetch( array( 'select' => '*', 'from' => 'forum_perms', 'where' => "perm_id={$id}" ) );
		
		/* Permissions Class */
		$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/classes/class_public_permissions.php', 'classPublicPermissions' );
		$perm_obj    = new $classToLoad( $this->registry );
		
		/* Loop through applications */
		foreach( $this->registry->getApplications() as $app )
		{
			/* Check to see if there is a permission map */
			$_file = IPSLib::getAppDir( $app['app_directory'] ) . '/extensions/coreExtensions.php';
			
			if( is_file( $_file ) )
			{
				/* Get the permission mappings */
				$_PERM_CONFIG = array();
				require_once( $_file );/*noLibHook*/
				
				/* Check for a config array */
				if( is_array( $_PERM_CONFIG ) && count( $_PERM_CONFIG ) )
				{
					/* Loop through the types */
					foreach( $_PERM_CONFIG as $perm_type )
					{
						/* Check for a class */
						$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( $app['app_directory'] ) . '/extensions/coreExtensions.php', $app['app_directory'] . 'PermMapping' . $perm_type, $app['app_directory'] );

						if( class_exists( $classToLoad ) )
						{
							/* Create the object */
							$perm_map = new $classToLoad;
							
							/* Make sure the function exists */
							if( method_exists( $perm_map, 'getPermItems' ) )
							{
								$_key	= count($_PERM_CONFIG) > 1 ? $app['app_title'] . ' ' . $perm_type : $app['app_title'];
								$matricies[ $_key ]				= $perm_obj->adminItemPermMatrix( $perm_map, $perm_map->getPermItems(), $id, $app['app_directory'], $perm_type );
								$apps[$app['app_directory']][ $perm_type ]	= $perm_type;
							}
						}
					}
				}
			}
		}

		/* Output */
		$this->registry->output->extra_nav[] = array( "{$this->settings['base_url']}&amp;{$this->form_code}", $this->lang->words['menu__manage_perms'] );
		$this->registry->output->html .= $this->html->permissionEditor( $set_data['perm_name'], $matricies, $id, $apps );
	}	
	
	/**
	 * List permission masks
	 *
	 * @return	@e void		[Outputs to screen]
	 */
	protected function _mainScreen()
	{
		/* INIT */
		$perms   = array();
		$mems    = array();
		$groups  = array();
		$dlist   = "";
		$content = "";
				
		/* Get the names for the perm masks w/id */
		$this->DB->build( array( 'select' => '*', 'from' => 'forum_perms', 'order' => 'perm_name ASC' ) );
		$this->DB->execute();
		
		while( $r = $this->DB->fetch() )
		{
			$perms[ $r['perm_id'] ] = $r['perm_name'];
		}
		
		/* Number of users using this mask as an override */
		$this->DB->build( array( 'select'	=> 'COUNT(member_id) as count, org_perm_id',
										'from'	=> 'members',
										'where'	=> "(org_perm_id " . $this->DB->buildIsNull( false ) . " AND org_perm_id != '')",
										'group'	=> 'org_perm_id',
							)		);
		$this->DB->execute();
		
		while( $r = $this->DB->fetch() )
		{
			if ( strstr( $r['org_perm_id'] , "," ) )
			{
				foreach( explode( ",", $r['org_perm_id'] ) as $pid )
				{
					$mems[ $pid ]  = ! isset( $mems[ $pid ] ) ? 0 : $mems[ $pid ];
					$mems[ $pid ] += $r['count'];
				}
			}
			else
			{
				$mems[ $r['org_perm_id'] ] += $r['count'];
			}
			
		}
	
		/* Groups using this mask */
		$this->DB->build( array( 'select' => 'g_id, g_title, g_perm_id', 'from' => 'groups' ) );
		$this->DB->execute();
		
		while( $r = $this->DB->fetch() )
		{
			if ( strstr( $r['g_perm_id'] , "," ) )
			{
				foreach( explode( ",", $r['g_perm_id'] ) as $pid )
				{
					$groups[ $pid ][] = $r['g_title'];
				}
			}
			else
			{
				$groups[ $r['g_perm_id'] ][] = $r['g_title'];
			}
		}
		
		/* Build the output data */
		$display_groups = array();
		
		foreach( $perms as $id => $name )
		{
			$groups_used = "";
			$mems_used   = 0;
			$is_active   = 0;
			$dlist      .= "<option value='$id'>$name</option>\n";
			
			if ( isset( $groups[ $id ] ) AND is_array( $groups[ $id ] ) )
			{
				foreach( $groups[ $id ] as $g_title )
				{
					$groups_used .= '&middot; ' . $g_title . "<br />";
				}
				
				$is_active = 1;
			}
			else
			{
				$groups_used = "{$this->lang->words['per_none']}";
			}			
			
			if ( !empty($mems[ $id ]) )
			{
				$is_active = 1;
			}
			
			$r['id']       = $id;
			$r['name']     = $name;
			$r['isactive'] = $is_active;
			$r['groups']   = $groups_used;
			$r['mems']     = isset( $mems[ $id ] ) ? intval( $mems[ $id ] ) : 0;
			
			$display_groups[] = $r;
		}
		
		/**
		 * Wow this is convoluted...
		 */
		if( $this->request['_from'] )
		{
			$from	= explode( '-', $this->request['_from'] );
			
			if( $from[1] )
			{
				$this->registry->class_localization->loadLanguageFile( array( 'admin_groups' ), 'members' );
				$this->registry->output->html .= $this->html->groupAdminConfirm( $from[1] );
			}
		}
		
		$this->registry->output->html .= $this->html->permissionsSplash( $display_groups, $dlist );
	}
	
	/**
	 * Fire any application callbacks as needed
	 *
	 * @return	@e void
	 */
	protected function _fireAppCallbacks()
	{
		//-----------------------------------------
		// Loop through each application
		//-----------------------------------------
		
		foreach( $this->registry->getApplications() as $app )
		{
			// Let's skip the app_enabled check to be sure everything is always recached!
			
			//-----------------------------------------
			// Check for callback file
			//-----------------------------------------
			
			$_file = IPSLib::getAppDir( $app['app_directory'] ) . '/extensions/permissionsSync.php';
			
			if( is_file( $_file ) )
			{
				$classToLoad	= IPSLib::loadLibrary( $_file, $app['app_directory'] . 'PermissionsSync', $app['app_directory'] );
				$_callback		= new $classToLoad( $this->registry );
		
				$_callback->updatePermissions();
			}
		}
	}
}