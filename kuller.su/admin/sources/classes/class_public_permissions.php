<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Manages public permissions
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		Joshua Williams
 * @package		IP.Board
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @link		http://www.invisionpower.com
 * @since		Wednesday 14th May 2008 14:00
 */

class classPublicPermissions
{
	/**#@+
	 * Registry objects
	 *
	 * @var		object
	 */
	protected $registry;
	protected $lang;
	protected $member;
	protected $memberData;
	/**#@-*/
	
	/**
	 * Array of permission mappings for each app/type
	 *
	 * @var		array
	 */
	protected $mappings = array();
	
	/**
	 * Ability to set a different member for permission checks, etc
	 * @var array
	 */
	protected $_memberData     = array();
	
	/**
	 * Constructer
	 *
	 * @param	object	ipsRegistry $registry
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry )
	{
		/* Make object */
		$this->registry   = $registry;
		$this->lang       = $this->registry->getClass('class_localization');
		$this->member     = $this->registry->member();
		$this->memberData =& $this->registry->member()->fetchMemberData();
		
		/* Set default memberData */
		$this->setMemberData( $this->memberData );
	}
	
	/**
	 * @return the $_memberData
	 */
	public function getMemberData( $k='' )
	{
		return ( ! empty( $k ) ) ? $this->_memberData[ $k ] : $this->_memberData;
	}

	/**
	 * @param	string	key
	 * @param	string	value
	 */
	public function setMemberData( $k, $v='' )
	{
		if ( is_integer( $k ) )
		{
			$this->_memberData = empty( $k ) ? IPSMember::setUpGuest() : IPSMember::load( $k, 'all' );
		}
		else if ( is_string($k) && $k == intval($k) )
		{
			$this->_memberData = empty( $k ) ? IPSMember::setUpGuest() : IPSMember::load( $k, 'all' );
		}
		else if ( is_array( $k ) )
		{
			$this->_memberData = $k;
		}
		else if ( ! empty( $k ) )
		{
			$this->_memberData[ $k ] = $v;
		}
		
		/* Set perm ids and that */
		if ( $this->memberData['member_id'] == $this->_memberData['member_id'] )
		{
			$this->_memberData['_perm_id_array'] = $this->member->perm_id_array;
		}
		else
		{
			/* Force to guest for now */
			$permId = ( ! empty( $this->_memberData['org_perm_id'] ) ) ? $this->_memberData['org_perm_id'] : $this->_memberData['g_perm_id'];
			$this->_memberData['_perm_id_array'] = array_unique( explode( ",", $permId ) );
		}	
	}
	
	/**
	 * Retuns a string for use in the where condition of a query
	 *
	 * @param	string	[$alias]		Alias of the permissiont able, p by default
	 * @param	string	[$perm_column]	Permission column to check against
	 * @return	string
	 */
	public function buildPermQuery( $alias='p', $perm_column='perm_view' )
	{
		return $this->registry->DB()->buildRegexp( "{$alias}.{$perm_column}", ipsRegistry::member()->perm_id_array );
	}

	/**
	 * Check a permission
	 *
	 * @param   mixed   $perm  		The permission to check, string or array of permission to check
	 * @param   array   $row   		Permission row from permission_index
	 * @param	array 	$otherMasks	Masks to check (defaults to current viewer)
	 * @return  bool
	 */
	public function check( $perm, $row, $otherMasks=array() )
	{
		if( is_array( $perm ) )
		{
			foreach( $perm as $p )
			{
				if( ! $this->_help_check( $p, $row, $otherMasks ) )
				{
					return false;
				}				
			}
			
			return true;			
		}
		else
		{
			return $this->_help_check( $perm, $row, $otherMasks );
		}
	}
	
	/**
	 * Parses the perm_X columsn into the type specific format, Ex: perm_2 becomes perm_read for forums
	 *
	 * @param   array   $row   Permission row from permission_index
	 * @return  array
	 */	
	public function parse( $row )
	{
		/* INI */
		$parsed_perms = array();
		
		/* Make sure we have a permission type */
		if( ! $row['perm_type'] )
		{
			return array();
		}
		
		/* Load Mapping */
		if( ! isset( $this->mappings[$row['app']][$row['perm_type']] ) || ! is_array( $this->mappings[$row['app']][$row['perm_type']] ) && ! count( $this->mappings[$row['app']][$row['perm_type']] ) )
		{
			$this->load_mapping( $row );
		}
		
		/* Loop through the mappings */
		
		if( is_array($this->mappings[$row['app']]) AND count($this->mappings[$row['app']]) )
		{
			foreach( $this->mappings[$row['app']][$row['perm_type']] as $k => $v )
			{
				$parsed_perms[ 'perm_' . $k] = ( $row[$v] == '*' ) ? $row[$v] : IPSText::cleanPermString( $row[$v] );
			}
		}
		
		/* Return */
		return $parsed_perms;
		
	}

	/**
	 * Internal function to handle checking a permission
	 *
	 * @param   mixed   $perm  		The permission to check, string or array of permission to check
	 * @param   array   $row   		Permission row from permission_index
	 * @param	array 	$otherMasks	Masks to check (defaults to current viewer)
	 * @return  bool
	 */	
	protected function _help_check( $perm, $row, $otherMasks=array() )
	{
		/* Permission column */
		$perm_column = '';
		
		/* Masks to check */
		$masks	= count($otherMasks) ? $otherMasks : $this->_memberData['_perm_id_array'];
		
		if( $perm == 'view' )
		{
			$perm_column = 'perm_view';
		}
		else
		{
			/* Load Mapping */
			if(  ! isset( $this->mappings[$row['app']][$row['perm_type']] ) OR ( ! is_array( $this->mappings[$row['app']][$row['perm_type']] ) && ! count( $this->mappings[$row['app']][$row['perm_type']] ) ) )
			{
				$this->load_mapping( $row );
			}

			$perm_column = isset( $this->mappings[ $row['app'] ][ $row['perm_type'] ][ $perm ] ) ? $this->mappings[ $row['app'] ][ $row['perm_type'] ][ $perm ] : '';
		}
		
		if( ! isset( $row[$perm_column] ) )
		{
			return false;
		}
		
		/* Check the permission */
		if( $row[$perm_column] == '*' )
		{
			return true;
		}
		else
		{
			foreach( $masks as $mask_id )
			{ 
				//-----------------------------------------
				// Prevent empty mask id from matching as "yes"
				//-----------------------------------------
				
				if( !$mask_id )
				{
					continue;
				}

				if( in_array( $mask_id, explode( ',', $row[$perm_column] ) ) )
				{
					return true;
				}
			}
		}
	
		/* Return false by default */
		return false;			
	}

	/**
	 * Create a permissions matrix for ACP
	 *
	 * @param   string		Map class
	 * @param   array 		Items
	 * @param	int			Set ID
	 * @param	string		Application
	 * @param	string		Type
	 * @return  string		HTML
	 */	
	public function adminItemPermMatrix( $map_class, $items, $set_id, $app, $type )
	{
		/* INI */
		$app          = ( $app ) ? $app : ipsRegistry::$current_application;
		$perm_names   = array();
		$perm_matrix  = array();
		$perm_checked = array();
		$perm_map     = array();
		$items        = is_array( $items ) ? $items : array();
		$html         = ipsRegistry::getClass( 'output' )->loadTemplate( 'cp_skin_permissions', 'members' );

		/* Get Mappings */
		$perm_names = $map_class->getPermNames();
		$perm_map   = $map_class->getMapping();
		
		/* Language... */
		$this->lang->loadLanguageFile( array( 'admin_' . $app ), $app );
		
		foreach( $perm_names as $key => $perm )
		{
			$perm_names[ $key ]	= ipsRegistry::getClass('class_localization')->words['perm_' . $app . '_' . $key ] ? ipsRegistry::getClass('class_localization')->words['perm_' . $app . '_' . $key ] : $perm;
		}

		/* Loop through items */
		foreach( $items as $id => $data )
		{
			/* Reset row */
			$matrix_row = array();
			
			if( ! $id )
			{
				continue;
			}
						
			/* Loop through the permissions */
			foreach( $perm_names as $key => $perm )
			{
				/* Restrict to one perm? */
				if( $data['restrict'] != '' && $data['restrict'] != $perm_map[ $key ] )
				{					
					continue;
				}
				
				/* Checked? */
				$checked = '';
				if( $data[ $perm_map[ $key ] ] == '*' )
				{
					$checked = " checked='checked'";
				}
				else if( in_array( $set_id, explode( ',', IPSText::cleanPermString( $data[ $perm_map[ $key ] ] ) ) ) )
				{
					$checked = " checked='checked'";
				}
				
				$perm_checked[ $id ][ $key ] = $checked;
								
				$matrix_row[$key] = $perm;
			}
			
			 $data['title'] = str_replace( '%', '&#37;', $data['title'] );

			 if( !empty($data['_noconfig']) )
			 {
			 	$matrix_row['_noconfig']	= $data['_noconfig'];
			 }
			
			/* Add row to matrix */
			$perm_matrix[ $id . '%' . $data['title'] ] = $matrix_row;			
		}

		/* Return the matrix */
		return $html->permissionSetMatrix( $perm_names, $perm_matrix, $perm_checked, $map_class->getPermColors(), $app, $type );
	}
	
	/**
	 * Builds a permission selection matrix
	 *
	 * @param	string		$type			The permission type to build
	 * @param	array		$default		Current permissions
	 * @param	string		$app			App that the type belongs too, default is the current app
	 * @param	string		$only_perm		Only show this permission
	 * @param	boolean		$addOutsideBox	Add or not the outside acp-box
	 * @return	@e string	HTML
	 */
	public function adminPermMatrix( $type, $default, $app='', $only_perm='', $addOutsideBox=true )
	{
		/* INI */
		$app          = ( $app ) ? $app : ipsRegistry::$current_application;
		$map_class    = $app .'PermMapping' . ucfirst( $type );
		$perm_names   = array();
		$perm_matrix  = array();
		$perm_checked = array();
		$perm_map     = array();
		$html         = ipsRegistry::getClass( 'output' )->loadTemplate( 'cp_skin_permissions', 'members' );
		
		ipsRegistry::getClass('class_localization')->loadLanguageFile( array( 'admin_permissions' ), 'members' );
		
		/* Get Mappings */
		$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( $app ) . '/extensions/coreExtensions.php', $map_class, $app );
		$mapping     = new $classToLoad();
		$perm_names  = $mapping->getPermNames();
		$perm_map    = $mapping->getMapping();
		
		/* Language... */
		$this->lang->loadLanguageFile( array( 'admin_' . $app ), $app );
		
		foreach( $perm_names as $key => $perm )
		{
			$perm_names[ $key ]	= ipsRegistry::getClass('class_localization')->words['perm_' . $app . '_' . $key ] ? ipsRegistry::getClass('class_localization')->words['perm_' . $app . '_' . $key ] : $perm;
		}
		
		/* Single Perm? */
		if( $only_perm )
		{
			$new_perm_array = array();			
			$new_perm_array[$only_perm] = $perm_names[$only_perm];
			$perm_names = $new_perm_array;
		}
		
		/* Loop through the masks */		
		$this->registry->DB()->build( array( 'select' => '*', 'from' => 'forum_perms', 'order' => "perm_name ASC" ) );
		$this->registry->DB()->execute();

		while( $data = $this->registry->DB()->fetch() )
		{
			/* Reset row */
			$matrix_row = array();
			
			/* Loop through the permissions */
			foreach( $perm_names as $key => $perm )
			{
				/* Restrict? */
				if( $only_perm && $key != $only_perm )
				{
					continue;
				}
				
				/* Checked? */
				$checked = '';
				if( $default[ $perm_map[ $key ] ] == '*' )
				{
					$checked = " checked='checked'";
					
					/* Add the global flag */
					$perm_checked['*'][$key] = $checked;
				}
				else if( in_array( $data['perm_id'], explode( ',', IPSText::cleanPermString( $default[ $perm_map[ $key ] ] ) ) ) )
				{
					$checked = " checked='checked'";
				}
				
				$perm_checked[ $data['perm_id'] ][ $key ] = $checked;
				$matrix_row[$key] = $perm;
			}
			
			$data['perm_name'] = str_replace( '%', '&#37;', $data['perm_name'] );
		
			/* Add row to matrix */
			$perm_matrix[$data['perm_id'].'%'.$data['perm_name']] = $matrix_row;
		}
		
		/* Return the matrix */
		return $html->permissionMatrix( $perm_names, $perm_matrix, $perm_checked, $mapping->getPermColors(), $type, $addOutsideBox );
	}

	/**
	 * Builds a permission selection matrix
	 *
	 * @param	array 	Input perm matrix
	 * @param	int		Set ID
	 * @param	array 	Applications originally on the form
	 * @return	@e void
	 */
	public function saveItemPermMatrix( $perm_matrix, $set_id, $applications=array() )
	{
		//print_r($applications);exit;
		/* Loop through all the applications originally on the form */
		foreach( $applications as $app => $types )
		{
			/* Loop through the types */
			foreach( $types as $type => $confirmed )
			{
				/* Reset the ID Array */
				$_perm_row = array();
				
				/* We need the mappings for this application */
				$map_class     = $app . 'PermMapping' . $type;
				$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( $app ) . '/extensions/coreExtensions.php', $map_class, $app );
				
				/* Create the mapping object */
				$mapping       = new $classToLoad();
				$mapping_array = $mapping->getMapping();				

				/* Loop through each perm in this app */		
				if( count($perm_matrix[ $app ][ $type ]) AND is_array($perm_matrix[ $app ][ $type ]) )
				{
					/* Loop through the perms in this app that we submitted */
					foreach( $perm_matrix[ $app ][ $type ] as $perm => $ids )
					{
						/* Build the ID Array */
						foreach( $ids as $k => $v )
						{
							/* Add the id to the array, this id can be a forum id, a gallery category id, etc */
							if( $v == 1 )
							{
								$_perm_row[ intval( $k ) ][$mapping_array[$perm]] = $set_id;
							}
						}
					}
				}

				/* Now we need to query all the existing permission rows for this type, so tha we can add in the other sets */
				$this->registry->DB()->build( array( 
													'select' => '*', 
													'from'   => 'permission_index', 
													'where'  => "app='{$app}' AND perm_type='".strtolower( $type )."'" 
										) 	);
				$outer = $this->registry->DB()->execute();

				/* Now to loop through those results and merge the existing permission set with the new modified ones */
				while( $r = $this->registry->DB()->fetch( $outer ) )
				{
					/* Our new permissions for this set */
					$new_set_perm = $_perm_row[$r['perm_type_id']];
					$perm_id      = $r['perm_id'];
					
					foreach( $mapping_array as $k => $v )
					{
						/* Create an array from this permission */
						$_perm_arr = explode( ',', IPSText::cleanPermString( $r[ $v ] ) );
						
						/* Should this perm be active? */
						if( $new_set_perm[$v] == $set_id )
						{
							/* Yes, it should, is it already there? */
							if( !( $r[$v] == '*' || in_array( $set_id, $_perm_arr ) ) )
							{
								/* It wasn't, so we need to add it */
								$_perm_arr[] = $set_id;
							}
						}
						/* It wasn't checked, so we may need to remove it */
						else
						{
							/* IF this was global, that has to be updated */
							if( $r[$v] == '*' )
							{
								/* Okay...so this means we need a list of every set id but the one being removed */
								$this->registry->DB()->build( array( 'select' => 'perm_id', 'from' => 'forum_perms', 'where' => "perm_id <> $set_id" ) );
								$this->registry->DB()->execute();
								
								/* Reset this, to remove the '*' */
								$_perm_arr = array();
								
								/* And now add all those other ids to the array */
								while( $p = $this->registry->DB()->fetch() )
								{
									$_perm_arr[] = $p['perm_id'];
								}
								
							}
							/* IF this permission was in the list, it needs to be removed */
							else if( in_array( $set_id, $_perm_arr ) )
							{
								unset( $_perm_arr[ array_search( $set_id, $_perm_arr ) ] );
							}
						}
						
						/* Set the new perm column */
						$r[$v] = ( $_perm_arr[0] == '*' ) ? '*' : ',' . implode( ',', $_perm_arr ) . ',';
					}
					
					unset( $r['perm_id'] );
					
					/* Update the record here */
					$this->registry->DB()->update( 'permission_index', $r, "perm_id=" . $perm_id );

					unset( $_perm_row[ $r['perm_type_id'] ] );
				}
				
				/* Left overs? */
				if( isset( $_perm_row ) && is_array( $_perm_row ) && count( $_perm_row ) )
				{
					/* Ok, there are leftovers, this means that there is no existing permission row, we need to add one */
					foreach( $_perm_row as $new_perm_type_id => $_new_perm_s )
					{
						$_new_insert = array(
												'app'          => $app,
												'perm_type'    => strtolower( $type ),
												'perm_type_id' => $new_perm_type_id
											);
											
						$_new_insert = array_merge( $_new_insert, $_new_perm_s );
						
						$this->registry->DB()->insert( 'permission_index', $_new_insert );
					}
				}
			}
		}
	}
	
	/**
	 * Saves a permission matrix to the database
	 *
	 * @param	string	Type of permission being saved. Ex: forum
	 * @param	int		ID of the type for this permission row. EX: forum_id for a forum
	 * @param	string	The permission type to build
	 * @param	string	App that the type belongs too, default is the current app
	 * @return	bool
	 */	
	public function savePermMatrix( $perm_matrix, $type_id, $type, $app='' )
	{
		/* INI */
		$app           = ( $app ) ? $app : ipsRegistry::$current_application;
		$map_class     = $app . 'PermMapping' . ucfirst( $type );
		$mapping_array = array();
		$perm_save_row = array();
		
		/* Get Mappings */
		$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( $app ) . '/extensions/coreExtensions.php', $map_class, $app );
		$mapping     = new $classToLoad();
		$mapping_array = $mapping->getMapping();
		$customTable   = ( method_exists( $mapping, 'getCustomTable' ) ) ? $mapping->getCustomTable() : false;

		/* Loop through mapping and build save array */
		foreach( $mapping_array as $k => $col )
		{
			/* Setup the column */
			$perm_save_row[$col] = '';
			
			/* Check the matrix for this perm */			
			if( $perm_matrix[$type . $k] )
			{
				/* Global? */
				if( !empty( $perm_matrix[$type . $k]['*'] ) )
				{
					$perm_save_row[$col] = '*';
				}
				else
				{
					/* Do we have permissions? */
					if( is_array( $perm_matrix[$type . $k] ) && count( $perm_matrix[$type . $k] ) )
					{
						/* Loop through the permissions */
						$perm_save_row[$col] = ',';
						
						foreach( $perm_matrix[$type . $k] as $mask => $v )
						{
							if( $v == 1 )
							{
								$perm_save_row[$col] .= "{$mask},";
							}
						}						
					}
				}
			}
		}

		if ( ! $customTable )
		{
			/* Ensure all text fields have a default value */
			for ( $i = 2 ; $i < 8 ; $i++ )
			{
				if ( ! isset( $perm_save_row['perm_' . $i ] ) )
				{
					$perm_save_row['perm_' . $i ] = '';
				}
			}
				
			/* build the rest of the save array */
			$perm_save_row['app']          = $app;
			$perm_save_row['perm_type']    = $type;
			$perm_save_row['perm_type_id'] = $type_id;
			
			/* Save */
			$this->registry->DB()->delete( 'permission_index', "app='{$app}' AND perm_type='{$type}' AND perm_type_id={$type_id}" );
			$this->registry->DB()->insert( 'permission_index', $perm_save_row );
		}
		else
		{
			$this->registry->DB()->update( $customTable['table'], $perm_save_row, $customTable['primaryKey'] . '=' . $type_id );	
		}
		
		return true;
	}
	
	/**
	 * Loads the mapping for a permission type
	 *
	 * @param   array   $row   Permission row from permission_index
	 * @return  bool
	 */	
	protected function load_mapping( $row )
	{
		if( !isset($row['app']) OR !$row['app'] )
		{
			return false;
		}

		/* Mapping Class */
		$classToLoad = $row['app'] . 'PermMapping' . ucfirst( $row['perm_type'] );
		
		/* Check for the class */
		if( ! class_exists( $classToLoad ) )
		{
			/* Check for the file */
			if( is_file( IPSLib::getAppDir( $row['app'] ) . '/extensions/coreExtensions.php' ) )
			{
				$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( $row['app'] ) . '/extensions/coreExtensions.php', $classToLoad, $row['app'] );
			}
			else
			{
				return false;
			}
		}

		/* Load the mapping */
		if( class_exists( $classToLoad ) )
		{
			$mapping = new $classToLoad();
			$this->mappings[$row['app']][$row['perm_type']] = $mapping->getMapping();
		}
		
		return true;
	}	
}