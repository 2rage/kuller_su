<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Skin Caching Functions
 * Last Updated: $Date: 2012-12-20 07:24:24 -0500 (Thu, 20 Dec 2012) $
 * </pre>
 *
 * Owner: Matt
 * @author 		$Author: mark $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @since		9th July 2008
 * @version		$Revision: 11738 $
 *
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

/**
* Ensure that class functions is loaded
*/
if ( ! class_exists( 'skinFunctions' ) )
{
	require_once( dirname( __FILE__ ) . '/skinFunctions.php' );/*noLibHook*/
}

class skinCaching extends skinFunctions
{
	/**#@+
	 * Registry objects
	 *
	 * @access	protected
	 * @var		object
	 */	
	protected $registry;
	protected $DB;
	protected $settings;
	protected $request;
	protected $lang;
	protected $member;
	protected $memberData;
	protected $cache;
	protected $caches;
	/**#@-*/

	/**
	 * Array of CSS needing to be rebuilt
	 *
	 * @access	protected
	 * @var		array
	 */	
	protected $_cssNeedToRebuildArray = array();
	
	/**
	 * Ignore children when recaching ...
	 * @var boolean
	 */
	protected $_ignoreChildrenWhenRecaching = false;
	
	/**
	 * Recache skin sets on shutdown
	 * @var	bool
	 */
 	protected $_recacheSkinsCache	= false;
 	
 	/**
 	 * Remember which skins we've already flagged for recache
 	 * @var	array
 	 */
 	protected $_flaggedForRecache	= array();
	
	/**
	 * Constructor
	 *
	 * @access	public
	 * @param	object		Registry object
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry )
	{
		/* Make object */
		parent::__construct( $registry );
	}
	
	/**
	 * Set ignore children when recaching
	 * @param boolean $val
	 */
	public function setIgnoreChildrenWhenRecaching( $val )
	{
		$this->_ignoreChildrenWhenRecaching = ( ! empty( $val ) ) ? true : false;
	}
	
	/**
	 * Get ignore children when recaching
	 * @return boolean
	 */
	public function getIgnoreChildrenWhenRecaching()
	{
		return $this->_ignoreChildrenWhenRecaching;
	}
	
	/**
	 * Rebuild Replacements cache
	 *
	 * @access	public
	 * @param	int		Skin set id to rebuild
	 * @return	boolean
	 */
	public function rebuildReplacementsCache( $setID )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
	
		$skinSetData = $this->fetchSkinData( $setID );
		
		$this->_resetErrorHandle();
		$this->_resetMessageHandle();
		
		//-----------------------------------------
		// Push the current skin set ID onto the beginnging
		//-----------------------------------------

		if ( is_numeric( $setID ) )
		{
			array_unshift( $skinSetData['_childTree'], $setID );
		}
		else
		{
			array_unshift( $skinSetData['_childTree'], 0 );
		}
		
		//-----------------------------------------
		// Remove current caches
		//-----------------------------------------
		
		$this->DB->delete( 'skin_cache', 'cache_type=\'replacements\' AND cache_set_id IN (' . implode( ",", $skinSetData['_childTree'] ) . ')' );
		
		//-----------------------------------------
		// Loop through and rebuild
		//-----------------------------------------
		
		foreach( $skinSetData['_childTree'] as $_setID )
		{
			/* Bit of a fiddle here... */
			if ( ! is_numeric( $setID ) AND $_setID == 0 )
			{
				/* We mean a master set, then */
				$_setID = $setID;
			}
			
			/* If this is a child skin, just flag for recache */
			if ( $_setID != $setID )
			{
				if ( $this->getIgnoreChildrenWhenRecaching() === false )
				{
					$this->flagSetForRecache( $_setID, true );
				}
				
				continue;
			}
			
			$__replacements = $this->fetchReplacements( $_setID );
			$_replacements  = array();
			
			/* Strip out unneeded stuff */
			foreach( $__replacements as $id => $data )
			{
				$_replacements[ $data['replacement_key'] ] = $data['replacement_content'];
			}
			
			/* Update skin cache */
			$this->DB->insert( 'skin_cache', array( 'cache_updated' => time(),
													'cache_set_id'  => $_setID,
												 	'cache_type'    => 'replacements',
													'cache_content' => serialize( $_replacements ) ) );

			$this->cache->putWithCacheLib( 'Skin_Store_' . $_setID, array(), 1 );
		}
		
		return TRUE;
	}
	
	/**
	 * Rebuild PHP Templates
	 *
	 * @access	public
	 * @param	int			Skin set ID
	 * @param	string		[Optional: Rebuild only selected skin group template file]
	 * @return	array 		Messages
	 */
	public function rebuildPHPTemplates( $setID, $groupOnly='' )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
	
		$skinSetData = $this->fetchSkinData( $setID );
		
		$skinSetData['set_image_dir'] = ( $skinSetData['set_image_dir'] ) ? $skinSetData['set_image_dir'] : 'master';
		
		/* These are not always set up correctly */
		$this->settings['img_url']		    = ( $this->settings['img_url'] )        ? $this->settings['img_url'] : $this->settings['_original_base_url'] . '/' . PUBLIC_DIRECTORY . '/style_images/' . $skinSetData['set_image_dir'];
		$this->settings['img_url_no_dir']	= ( $this->settings['img_url_no_dir'] ) ? $this->settings['img_url_no_dir'] : $this->settings['_original_base_url'] . '/' . PUBLIC_DIRECTORY . '/style_images/';

		/* Remove dead template caches */
		$this->removeDeadPHPCaches( $setID );
		
		$this->_resetErrorHandle();
		$this->_resetMessageHandle();

		//-----------------------------------------
		// Push the current skin set ID onto the beginnging
		//-----------------------------------------
	
		array_unshift( $skinSetData['_childTree'], $setID );

		//-----------------------------------------
		// Loop through and rebuild
		//-----------------------------------------
	
		foreach( $skinSetData['_childTree'] as $_setID )
		{
			/* If this is a child skin, just flag for recache */
			if ( $_setID != $setID )
			{
				if ( $this->getIgnoreChildrenWhenRecaching() === false )
				{
					$this->flagSetForRecache( $_setID, true );
				}
				
				continue;
			}
			
			//-----------------------------------------
			// Get template set titles
			//-----------------------------------------
			
			$groupTitles = $this->fetchTemplates( $_setID, 'groupNames' );
			$allHooks    = $this->fetchSkinHooks();
			
			/* Update DB row */
			$this->DB->update( 'skin_collections', array( 'set_updated' => time() ), 'set_id=' . intval( $_setID ) );
				
			foreach ( $groupTitles as $name => $group )
			{
				/* Separated $out into two variables, needed to build the sections independently to fix bug #21574 */
				$fileHead	= '';
				$fileBody	= '';
				
				//-----------------------------------------
				// Skip if we're only updating one group..
				//-----------------------------------------
				
				if ( $groupOnly != '' )
				{
					if ( $groupOnly != $group['template_group'] )
					{
						continue;
					}
				}
				
				$fileHead  = "class {$group['template_group']}_{$_setID} extends skinMaster{\n\n";
				$fileHead .= <<<EOF
/**
* Construct
*/
function __construct( ipsRegistry \$registry )
{
	parent::__construct( \$registry );
	
EOF;
				
				$templates = $this->fetchTemplates( $_setID, 'groupTemplates', $group['template_group'] );

				foreach ($templates as $func_name => $data )
				{
					$this->registry->templateEngine->setWorkingGroup( $group['template_group'] );
					
					$fileBody .= $this->registry->templateEngine->convertHtmlToPhp( $data['template_name'], $data['template_data'], $data['template_content'] ) ."\n";
				}
				
				//-----------------------------------------
				// Function Hooks
				//------------------------------------------
				$funcHooks = '$this->_funcHooks = array();' . "\n";
		
				if( is_array( $this->registry->templateEngine->_hookIds[ $group['template_group'] ] ) )
				{
					foreach( $this->registry->templateEngine->_hookIds[ $group['template_group'] ] as $func_name => $hookIds )
					{
						if( is_array( $hookIds ) && count( $hookIds ) )
						{
							$funcHooks .= "\$this->_funcHooks['{$func_name}'] = array(".implode( ',', $hookIds ).");\n";
						}
					}
				}
				
				$fileHead	.= "\n\n{$funcHooks}\n\n}\n\n";
				$out		 = $fileHead . $fileBody . "\n}\n";

				/* This would be better off within the templateEngine really cos $out now contains the entire class */
				$out = $this->stripUnneededHooks( $out, $allHooks[ $group['template_group'] ] );
				
				//-----------------------------------------
				// Update DB Cache
				//-----------------------------------------
				
				$this->DB->delete( 'skin_cache', 'cache_set_id=' . $_setID . " AND cache_type='phptemplate' AND cache_value_1='" . $group['template_group'] . "'" );
				
				$this->DB->insert( 'skin_cache', array( 'cache_updated' => time(),
														   'cache_type'    => 'phptemplate',
														   'cache_set_id'  => $_setID,
														   'cache_key_1'   => 'group',
														   'cache_value_1' => $group['template_group'],
														   'cache_content' => $out ) );
														   
				
				//-----------------------------------------
				// Write to the flatfile
				//-----------------------------------------
				
				$start  = '<'.'?'."php\n";
				$start .= "/*--------------------------------------------------*/\n";
				$start .= "/* FILE GENERATED BY INVISION POWER BOARD 3         */\n";
				$start .= "/* CACHE FILE: Skin set id: {$_setID}               */\n";
				$start .= "/* CACHE FILE: Generated: ".gmdate( 'D, d M Y H:i:s \G\M\T' )." */\n";
				$start .= "/* DO NOT EDIT DIRECTLY - THE CHANGES WILL NOT BE   */\n";
				$start .= "/* WRITTEN TO THE DATABASE AUTOMATICALLY            */\n";
				$start .= "/*--------------------------------------------------*/\n\n";
				
				$end    = "\n\n/*--------------------------------------------------*/\n";
				$end   .= "/* END OF FILE                                      */\n";
				$end   .= "/*--------------------------------------------------*/\n";
				$end   .= "\n?".">";
				
				if ( $this->fetchErrorMessages() === FALSE )
				{
					$this->_writePHPTemplate( $_setID, $group['template_group'], $start.$out.$end );
				}
				
				$this->cache->putWithCacheLib( 'Skin_Store_' . $_setID, array(), 1 );
			}
			
			$this->_addMessage( sprintf( $this->lang->words['finishedcachinghtml'], $_setID ) );
		}
		
		/* Rebuild skin cache */
		$this->rebuildSkinSetsCache();
		
		return TRUE;
	}
	
	/**
	 * Removes dead PHP cache files
	 *
	 * @access	public
	 * @param	int		Set ID
	 * @return	int		No. files unlinked
	 */
	public function removeDeadPHPCaches( $setID )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$phpKeep   = array();
		$phpThrow  = array();
		$phpUnlink = array();

		//-----------------------------------------
		// Get skin set data
		//-----------------------------------------
		
		$skinSetData = $this->fetchSkinData( $setID );
		
		$tree = array_merge( $skinSetData['_parentTree'], $skinSetData['_childTree'] );
		
		array_unshift( $tree, $setID );
		
		//-----------------------------------------
		// Get PHP
		//-----------------------------------------
		
		$this->DB->build( array( 'select' => '*',
									   'from'   => 'skin_collections',
									   'where'  => 'set_id IN (' . implode( ",", $tree ) . ")" ) );
									
		$i = $this->DB->execute();
		
		while( $row = $this->DB->fetch( $i ) )
		{
			$_php = $this->fetchTemplates( $row['set_id'], 'groupNames' );

			foreach( $_php as $name => $php )
			{
				$phpKeep[ $row['set_id'] ][ $name ] = $name;
			}
		}
		
		//-----------------------------------------
		// Get cached PHP
		//-----------------------------------------
		
		$this->DB->build( array( 'select' => '*',
									   'from'   => 'skin_cache',
									   'where'  => "cache_type='phptemplate' AND cache_set_id IN (" . implode( ",", $tree ) . ")" ) );
									
		$this->DB->execute();
		
		while( $row = $this->DB->fetch() )
		{
			if ( ( is_array( $phpKeep[ $row['cache_set_id'] ] ) ) AND ( ! in_array( $row['cache_value_1'], $phpKeep[ $row['cache_set_id'] ] ) ) )
			{
				$phpThrow[] = $row['cache_id'];
			}
		}
		
		//-----------------------------------------
		// Delete...
		//-----------------------------------------
		
		if ( count( $phpThrow ) )
		{
			$this->DB->delete( 'skin_cache', 'cache_id IN (' . implode( ",", $phpThrow ) . ')' );
		}
		
		//-----------------------------------------
		// Check flat files...
		//-----------------------------------------
		
		foreach( $phpKeep as $_setID => $data )
		{
			if ( ( $_setID != $setID ) && $this->getIgnoreChildrenWhenRecaching() === true )
			{
				continue;
			}
				
			$_path = IPS_CACHE_PATH . 'cache/skin_cache/cacheid_' . $_setID;
			
			if ( is_dir( $_path ) )
			{
				try
				{
					foreach( new DirectoryIterator( $_path ) as $file )
					{
						if ( ! $file->isDot() AND ! $file->isDir() )
						{
							$_name = $file->getFileName();
					
							if ( substr( $_name, -4 ) == '.php' )
							{
								$phpName = substr( $_name, 0, -4 );
							
								if ( ( is_array( $phpKeep[ $_setID ] ) ) AND ! in_array( $phpName, $phpKeep[ $_setID ] ) )
								{
									$phpUnlink[] = $_path . '/' . $_name;
								}
							}
						}
					}
				} catch ( Exception $e ) {}
			}
		}
		
		//-----------------------------------------
		// Unlink...
		//-----------------------------------------
		
		if ( count( $phpUnlink ) )
		{
			foreach( $phpUnlink as $path )
			{
				@unlink( $path );
			}
		}
		
		return count( $phpUnlink );
	}
	
	/**
	 * Removes dead CSS cache files
	 *
	 * @access	public
	 * @param	int		Set ID
	 * @return	int		No. files unlinked
	 */
	public function removeDeadCSSCaches( $setID )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$cssKeep   = array();
		$cssThrow  = array();
		$cssUnlink = array();
		
		//-----------------------------------------
		// Get skin set data
		//-----------------------------------------
		
		$skinSetData = $this->fetchSkinData( $setID );
		
		$tree = array_merge( $skinSetData['_parentTree'], $skinSetData['_childTree'] );
		
		array_unshift( $tree, $setID );
		
		//-----------------------------------------
		// Get CSS
		//-----------------------------------------
		
		$this->DB->build( array( 'select' => '*',
									   'from'   => 'skin_collections',
									   'where'  => 'set_id IN (' . implode( ",", $tree ) . ")" ) );
									
		$i = $this->DB->execute();
		
		while( $row = $this->DB->fetch( $i ) )
		{
			$_css = $this->fetchCSS( $row['set_id'] );

			foreach( $_css as $name => $css )
			{
				$cssKeep[ $row['set_id'] ][ $css['css_group'] ] = $css['css_group'];
			}
		}
		
		//-----------------------------------------
		// Get cached CSS
		//-----------------------------------------
		
		$this->DB->build( array( 'select' => '*',
									   'from'   => 'skin_cache',
									   'where'  => "cache_type='css' AND cache_set_id IN (" . implode( ",", $tree ) . ")" ) );
									
		$this->DB->execute();
		
		while( $row = $this->DB->fetch() )
		{
			if ( ( is_array( $cssKeep[ $row['cache_set_id'] ] ) ) AND ( ! in_array( $row['cache_value_1'], $cssKeep[ $row['cache_set_id'] ] ) ) )
			{
				$cssThrow[] = $row['cache_id'];
			}
		}
		
		//-----------------------------------------
		// Delete...
		//-----------------------------------------
		
		if ( count( $cssThrow ) )
		{
			$this->DB->delete( 'skin_cache', 'cache_id IN (' . implode( ",", $cssThrow ) . ')' );
		}
		
		//-----------------------------------------
		// Check flat files...
		//-----------------------------------------
		
		foreach( $cssKeep as $_setID => $data )
		{
			if ( ( $_setID != $setID ) && $this->getIgnoreChildrenWhenRecaching() === true )
			{
				continue;
			}
			
			$_path = DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/css_' . $_setID;
			
			if ( is_dir( $_path ) )
			{
				try
				{
					foreach( new DirectoryIterator( $_path ) as $file )
					{
						if ( ! $file->isDot() AND ! $file->isDir() )
						{
							$_name = $file->getFileName();
					
							if ( substr( $_name, -4 ) == '.css' )
							{
								$cssName = substr( $_name, 0, -4 );
							
								if ( ( is_array( $cssKeep[ $_setID ] ) ) AND ! in_array( $cssName, $cssKeep[ $_setID ] ) )
								{
									$cssUnlink[] = $_path . '/' . $_name;
								}
							}
						}
					}
				} catch ( Exception $e ) {}
			}
			
			$this->cache->putWithCacheLib( 'Skin_Store_' . $_setID, array(), 1 );
		}
		
		//-----------------------------------------
		// Unlink...
		//-----------------------------------------
		
		if ( count( $cssUnlink ) )
		{
			foreach( $cssUnlink as $path )
			{
				@unlink( $path );
			}
		}
		
		return count( $cssUnlink );
	}
	
	
	/**
	 * Rebuild CSS cache, skin set cache and writes out any flat files
	 *
	 * @access	public
	 * @param	int		[Optional Skin set id to rebuild. If no value given, all skin sets are rebuilt]
	 * @param	boolean	Force rebuild regardless of if it requires it
	 * @return	@e void
	 */
	public function rebuildCSS( $setID, $forceRebuild=FALSE )
	{
		//-----------------------------------------
		// Rebuild CSS cache
		//-----------------------------------------
		
		$this->rebuildCSSCache( $setID, $forceRebuild );
		
		//-----------------------------------------
		// Rewrite CSS files
		//-----------------------------------------
		
		$this->rebuildCSSFlatFiles( $setID, $forceRebuild );
	}
	
	/**
	 * Rebuild CSS flat files
	 *
	 * @access	public
	 * @param	int		[Optional Skin set id to rebuild. If no value given, all skin sets are rebuilt]
	 * @param	boolean	Force rebuild regardless of if it requires it
	 * @return	boolean
	 */
	public function rebuildCSSFlatFiles( $setID, $forceRebuild=FALSE )
	{
		$skinSetData = $this->fetchSkinData( $setID );
		
		$this->_resetErrorHandle();
		$this->_resetMessageHandle();
		
		//-----------------------------------------
		// Push the current skin set ID onto the beginnging
		//-----------------------------------------
		
		if ( is_numeric( $setID ) )
		{
			array_unshift( $skinSetData['_childTree'], $setID );
		}
		
		//-----------------------------------------
		// Fetch CSS that needs to be rebuilt
		//-----------------------------------------
		
		$needToRebuild = $this->_CSSNeedToRebuild( $skinSetData['_childTree'], $setID, $forceRebuild );
		
		if ( ! count( $needToRebuild ) )
		{
			return TRUE;
		}
		
		//-----------------------------------------
		// Get the data from the cache...
		//-----------------------------------------
		
		$this->DB->build( array( 'select' => '*',
								 'from'   => 'skin_cache',
								 'where'  => 'cache_type=\'css\' AND cache_set_id IN (' . implode( ",", $skinSetData['_childTree'] ) . ')',
								 'order'  => 'cache_set_id ASC' ) );
		
		$i = $this->DB->execute();
		
		while( $css = $this->DB->fetch( $i ) )
		{
			$_setID = $css['cache_set_id'];
			$_group = $css['cache_value_1'];
			$_css   = $css['cache_content'];
			
			if ( ! count( $needToRebuild[ $_setID ] ) )
			{
				return TRUE;
			}
			
			$_keys	= array_keys( $needToRebuild[ $_setID ] );
			
			if ( ! count( $_keys ) )
			{
				return TRUE;
			}
			
			if ( ! in_array( $_group, $_keys ) )
			{
				continue;
			}
			
			/* If this is a child skin, just flag for recache */
			if ( $_setID != $setID )
			{
				if ( $this->getIgnoreChildrenWhenRecaching() === false )
				{
					$this->flagSetForRecache( $_setID, true );
				}
				
				continue;
			}
			
			IPSDebug::addLogMessage( "Attempting to write CSS " . $_setID . ", " . $_group . ".css", 'css' );
			
			$this->_writeCSSFile( $_setID, $_group, $_css );
			
			/* Any problems?  */
			if ( $this->fetchErrorMessages() !== FALSE )
			{
				/* Flag as using inline */
				$this->flagSetAsNonCachedCSS( $_setID );
				return FALSE;
			}
			
			IPSDebug::addLogMessage( "Written CSS " . $_setID . ", " . $_group . ".css", 'css' );
		}
		
		return TRUE;
	}
	
	/**
	 * Rebuild CSS cache
	 *
	 * @access	public
	 * @param	int		Skin set id to rebuild
	 * @param	boolean	Force rebuild regardless of if it requires it
	 * @return	boolean
	 */
	public function rebuildCSSCache( $setID, $forceRebuild=FALSE )
	{	
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$cssSkinCollections 		= array();
		$skinSetData        		= $this->fetchSkinData( $setID );
		$cachedCSS					= array();
		$thisCSS					= array();
		$needToRebuild				= array();
		
		$this->_resetErrorHandle();
		$this->_resetMessageHandle();
		
		//-----------------------------------------
		// Push the current skin set ID onto the beginnging
		//-----------------------------------------
		
		if ( is_numeric( $setID ) )
		{
			array_unshift( $skinSetData['_childTree'], $setID );
		}
		
		//-----------------------------------------
		// Fetch CSS that needs to be rebuilt
		//-----------------------------------------
	
		$needToRebuild = $this->_CSSNeedToRebuild( $skinSetData['_childTree'], $setID, $forceRebuild );

		IPSDebug::addLogMessage( "Set ID: " . $setID . " - " . serialize( $needToRebuild ), 'css' );
		
		//-----------------------------------------
		// Loop through and rebuild
		//-----------------------------------------
		
		foreach( array_keys( $needToRebuild ) as $_setID )
		{
			$_css			= $this->fetchCSS( $_setID );
			$_skinSetData	= $this->fetchSkinData( $_setID );
			
			/* If this is a child skin, just flag for recache */
			if ( $_setID != $setID )
			{
				if ( $this->getIgnoreChildrenWhenRecaching() === false )
				{
					$this->flagSetForRecache( $_setID, true );
				}
				
				continue;
			}
			
			foreach( $_css as $name => $css )
			{
				if ( ! in_array( $name, array_keys( $needToRebuild[ $_setID ] ) ) )
				{
					continue;
				}
								
				$this->DB->delete( 'skin_cache', 'cache_type=\'css\' AND cache_set_id=' . $_setID . " AND cache_value_1='" . addslashes( $name ) . "'" );
				
				/* Build skin set row*/
				$cssSkinCollections[ $_setID ][ $css['css_position'] . '.' . $css['css_id'] ] = array( 'css_group' => $css['css_group'], 'css_position' => $css['css_position'] );
				
				/* Update skin cache */
				$this->DB->insert( 'skin_cache', array( 'cache_updated' => time(),
														'cache_set_id'  => $_setID,
													 	'cache_type'    => 'css',
														'cache_key_1'   => 'name',
														'cache_value_1' => $css['css_group'],
														'cache_key_2'   => 'position',
														'cache_value_2' => $css['css_position'],
														'cache_key_3'   => 'setBy',
														'cache_value_3' => $css['css_set_id'],
														'cache_key_4'   => 'appInfo',
														'cache_value_4' => $css['css_app'] . '-' . $css['css_app_hide'],
														'cache_key_5'   => 'attributes',
														'cache_value_5' => $css['css_attributes'],
														'cache_key_6'   => 'modules',
														'cache_value_6' => $css['css_modules'],
														'cache_content' => $this->_CSS_fromDBtoFile( $css['css_content'], $_skinSetData )
														//'cache_content' => $css['css_content']
														) ) ;
			}
			
			$this->cache->putWithCacheLib( 'Skin_Store_' . $_setID, array(), 1 );
		}
		
		//-----------------------------------------
		// Finally, remove any cached items that no
		// longer 'exist' (since been deleted, etc)
		//-----------------------------------------
		
		$_css = $this->fetchCSS( $setID );
		$_del = array();
		
		/* Get cached items */
		$this->DB->build( array( 'select' => '*',
								 'from'   => 'skin_cache',
								 'where'  => 'cache_type=\'css\' AND cache_set_id=' . $setID ) );
		$this->DB->execute();
		
		while( $row = $this->DB->fetch() )
		{
			if ( ! $_css[ $row['cache_value_1'] ] )
			{
				$_del[] = $row['cache_value_1'];
			}
		}
		
		if ( count( $_del ) )
		{
			$this->DB->delete( 'skin_cache', 'cache_type=\'css\' AND cache_set_id=' . $setID . " AND cache_value_1 IN('" . implode( "','", $_del ) . "')" );
		}
		
		//-----------------------------------------
		// Update skin sets
		//-----------------------------------------
	
		if ( count( $cssSkinCollections ) )
		{
			foreach( $cssSkinCollections as $setID => $data )
			{
				$this->DB->update( 'skin_collections', array( 'set_css_groups' => serialize( $cssSkinCollections[ $setID ] ) ), 'set_id='. $setID );
				
				$this->cache->putWithCacheLib( 'Skin_Store_' . $setID, array(), 1 );
			}
		}
		
		/* Recache skin sets */
		$this->rebuildSkinSetsCache();
				
		return TRUE;
	}
	
	/**
	 * Flag skin as not able to serve cached CSS
	 *
	 * @access	public
	 * @return	boolean
	 */
	public function flagSetAsNonCachedCSS( $setId=null )
	{
		/* Update DB row */
		if ( $setId !== null )
		{
			$this->DB->update( 'skin_collections', array( 'set_css_inline' => 1 ), 'set_id=' . intval( $setId ) );
		}
		
		/* Build cache */
		$this->rebuildSkinSetsCache();
		
		return TRUE;
	}
	
	/**
	 * Rebuild master replacements from cache/skin_cache/master_skin/_replacements.inc
	 *
	 * @access	public
	 * @return	bool
	 */
	public function rebuildMasterReplacements( $setId=0 )
	{
		/* Set directory */
		$setId		  = is_numeric( $setId ) ? intval( $setId ) : trim( $setId );
		$dir          = IPS_CACHE_PATH . 'cache/skin_cache/' . $this->remapData['templates'][ $setId ];
		$messages     = array();
		
		//-----------------------------------------
		// Master file exists?
		//-----------------------------------------
		
		if ( ! is_file( $dir . '/_replacements.inc' ) )
		{
			return FALSE;
		}
		
		//-----------------------------------------
		// Remove current CSS
		//-----------------------------------------
		
		if ( ! is_numeric( $setId ) )
		{
			$this->DB->delete( 'skin_replacements', "replacement_master_key='" . $setId . "'" );
		}
		else
		{
			$this->DB->delete( 'skin_replacements', "replacement_set_id='" . intval($setId) . "'" );
		}
		
		//-----------------------------------------
		// Grab file
		//-----------------------------------------
		
		$replacements = array();
		include( $dir . '/_replacements.inc' );/*noLibHook*/
		
		if ( !is_array($replacements) || !count($replacements) )
		{
			return FALSE;
		}
		
		//-----------------------------------------
		// Get proper set key/id
		//-----------------------------------------
		
		$set_id		= ( is_numeric( $setId ) ) ? $setId : $this->fetchSetIdByKey( $setId );
		$set_key	= '';
		
		if( $this->isMasterSet( $setId ) )
		{
			$set_key	= ( is_numeric( $setId ) ) ? $this->fetchSetKeyById( $setId ) : $setId;
		}
		
		//-----------------------------------------
		// Insert
		//-----------------------------------------
		
		foreach( $replacements as $k => $v )
		{
			$messages[] = $this->lang->words['basicimportedpre'] . $k;
			
			$this->DB->insert( 'skin_replacements', array( 'replacement_key'        => $k,
							   							   'replacement_content'    => $v,
							   							   'replacement_master_key' => $set_key,
														   'replacement_set_id'     => $set_id,
														   'replacement_added_to'   => 0 ) );
		}
		
		$this->cache->putWithCacheLib( 'Skin_Store_' . $setId, array(), 1 );
		
		return $messages;
	}
	
	/**
	 * Rebuild master CSS from the .css files in /public/style_css/master_skin/
	 *
	 * @access	public
	 * @param	int		Skin set ID
	 * @return	array 	Array of messages
	 * Exception Codes:
	 * NOT_MASTER_SKIN:	Set ID is not linked to a master skin directory
	 * NO_SUCH_DIR:		{master_skin_dir} directory cannot be found
	 */
	public function rebuildMasterCSS( $setId=0 )
	{
		/* Set directory */
		$setId		  = is_numeric( $setId ) ? intval( $setId ) : trim( $setId );
		$cssDir   = DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/' . $this->remapData['css'][ $setId ];
		$messages = array();
		$css      = array();
		
		/* Got the master skin dir? */
		if ( ! $this->remapData['css'][ $setId ] )
		{
			throw new Exception( "NOT_MASTER_SKIN" );
		}
		
		if ( ! is_dir( $cssDir ) )
		{
			throw new Exception( "NO_SUCH_DIR" );
		}
		
		if ( ! is_readable($cssDir) )
		{
			throw new Exception( "CANNOT_READ" );
		}
		
		/* Remove current CSS... */
		if ( is_numeric( $setId ) )
		{
			$this->DB->delete( 'skin_css', 'css_set_id=' . $setId );
		}
		else
		{
			$this->DB->delete( 'skin_css', 'css_master_key=\'' . $setId . '\'' );
		}
		
		/* Fetch all template bits. NOW */
		if ( is_numeric( $setId ) AND $setId > 0 )
		{
			$css = $this->fetchCSS( $setId );
		}
		
		//-----------------------------------------
		// Set key and ID
		//-----------------------------------------
		
		$set_id		= ( is_numeric( $setId ) ) ? $setId : $this->fetchSetIdByKey( $setId );
		$set_key	= '';
		
		if( $this->isMasterSet( $setId ) )
		{
			$set_key	= ( is_numeric( $setId ) ) ? $this->fetchSetKeyById( $setId ) : $setId;
		}
		
		//-----------------------------------------
		// Recurse over the directory
		//-----------------------------------------
		try
		{
			foreach( new DirectoryIterator( $cssDir ) as $file )
			{
				if ( ! $file->isDot() AND ! $file->isDir() )
				{
					$_name = $file->getFileName();
					
					if ( substr( $_name, -4 ) == '.css' )
					{
						$cssName		= substr( $_name, 0, -4 );
						$cssContent		= @file_get_contents( $cssDir . '/' . $_name );
						$_css_added_to	= 0;
						$cssContent		= str_replace( array( "\r\n", "\r" ), "\n", $cssContent );
						
						/* Encode */
						$cssContent		= IPSText::encodeForXml( $cssContent );
					
						$messages[]		= $this->lang->words['basicimportedpre'] . $cssName;
							
						$cssData		= $this->_CSS_fetchImportBlock( $cssContent );
						$cssContent		= $this->_CSS_fromFileToDB( $cssContent );
						
						/* 'Master' bit? */
						if ( ! $css[ $cssName ] )
						{
							$_css_added_to = $set_id;
						}
						
						$this->DB->insert( 'skin_css', array( 'css_updated'		=> time(),
															  'css_set_id'		=> $set_id,
															  'css_added_to'	=> $_css_added_to,
															  'css_app'			=> $cssData['css_app'],
															  'css_app_hide'	=> intval( $cssData['css_app_hide'] ),
															  'css_modules'		=> trim( $cssData['css_modules'] ),
															  'css_position'	=> intval( $cssData['css_position'] ),
															  'css_attributes'	=> $cssData['css_attributes'],
															  'css_master_key'	=> $set_key,
															  'css_group'		=> $cssName,
															  'css_content'		=> $cssContent ) );
					}
				}
			}
		} catch ( Exception $e ) {}
		
		/* Recache */
		if ( is_numeric( $setId ) AND $setId )
		{
			$this->rebuildCSS( $setId );
			$this->removeDeadCSSCaches( $setId );
			
			$this->cache->putWithCacheLib( 'Skin_Store_' . $setId, array(), 1 );
		}
		
		return $messages;
	}
	
	/**
	 * Rebuilds the master 0 skin from the PHP files in /cache/{master_skin_dir}/
	 *
	 * @access 	public
	 * @param	int			Set ID to rebuild from
	 * @return	array 		Array of messages
	 * <code>
	 * Exception Codes:
	 * NOT_MASTER_SKIN:	Set ID is not linked to a master skin directory
	 * NO_SUCH_DIR:		{master_skin_dir} directory cannot be found
	 * CANNOT_READ:		cannot read the {master_skin_dir} directory
	 * </code>
	 */
	public function rebuildMasterFromPHP( $setId=0 )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$setId		  = is_numeric( $setId ) ? intval( $setId ) : trim( $setId );
		$script_token = 0;
		$script_jump  = 0;
		$skin_dir     = IPS_CACHE_PATH . "cache/skin_cache/" . $this->remapData['templates'][ $setId ];
		$flag         = 0;
		$messages     = array();
		$templates	  = array();
		
		/* Got the master skin dir? */
		if ( ! $this->remapData['templates'][ $setId ] )
		{
			throw new Exception( "NOT_MASTER_SKIN" );
		}
		
		if ( ! is_dir( $skin_dir ) )
		{
			throw new Exception( "NO_SUCH_DIR" );
		}
		
		if ( ! is_readable($skin_dir) )
		{
			throw new Exception( "CANNOT_READ" );
		}
		
		/* Remove current templates... */
		if ( is_numeric( $setId ) )
		{
			$this->DB->delete( 'skin_templates', 'template_set_id=' . $setId );
		}
		else
		{
			$this->DB->delete( 'skin_templates', 'template_master_key=\'' . $setId . '\'' );
		}
		
		/* Fetch all template bits. NOW */
		if ( is_numeric( $setId ) AND $setId > 0 )
		{
			$templates = $this->fetchTemplates( $setId, 'allTemplates' );
		}
		
		//-----------------------------------------
		// Set key and ID
		//-----------------------------------------
		
		$set_id		= ( is_numeric( $setId ) ) ? $setId : $this->fetchSetIdByKey( $setId );
		$set_key	= '';
		
		if( $this->isMasterSet( $setId ) )
		{
			$set_key	= ( is_numeric( $setId ) ) ? $this->fetchSetKeyById( $setId ) : $setId;
		}
				
		/* Loop through the directory */
		try
		{
			foreach( new DirectoryIterator( $skin_dir ) as $file )
			{
				if ( ! $file->isDot() AND ! $file->isDir() )
				{
					$_name = $file->getFileName();
										
					if ( substr( $_name, -4 ) == '.php' )
					{
						$name  = substr( $_name, 0, -4 );
						$fdata = @file_get_contents( $skin_dir . "/" . $_name );
						
						if ( ! $fdata )
						{
							$messages[] = sprintf( $this->lang->words['couldnotopenfile'], $_name );
							continue;
						}
						
						$fdata = str_replace( "\r", "\n", $fdata );
						$fdata = str_replace( "\n\n", "\n", $fdata );
						
						if ( ! preg_match( "/\n/", $fdata ) )
						{
							$messages[] = sprintf( $this->lang->words['couldnotfindlineeol'], $_name );
							continue;
						}
						
						$farray		= explode( "\n", $fdata );
						$functions	= array();
						$added		= 0;
						$updated	= 0;
						
						foreach( $farray as $f )
						{
							//-----------------------------------------
							// Skip javascript functions...
							//-----------------------------------------
							
							if ( stristr( $f, '<script' ) )
							{
								$script_token = 1;
								$script_jump  = 0;
							}
							
							if ( stristr( $f, '</script>' ) )
							{
								$script_token = 0;
								$script_jump  = 0;
							}
							
							//-----------------------------------------
							// If, in the middle?
							//-----------------------------------------
							
							if ( $script_token AND $script_jump == 0 )
							{
								if ( preg_match( '#<if test=[\'\"]#', $f ) )
								{
									$script_jump  = 1;
									$script_token = 0;
								}
							}
							
							if ( $script_token == 0 AND $script_jump == 1 )
							{
								if ( preg_match( "#</if>#", $f ) )
								{
									$script_jump  = 0;
									$script_token = 1;
								}
							}
							
							//-----------------------------------------
							// NOT IN JS
							//-----------------------------------------
							
							if ( ! $script_token )
							{
								if ( preg_match( '/^function\s*([\w\_]+)\s*\((.*)\)/i', $f, $matches ) )
								{
									$functions[ $matches[1] ]   = '';
									$config[ $matches[1] ]      = $matches[2];
									$flag                       = $matches[1];
									continue;
								}
							}
							//-----------------------------------------
							// ARE IN JS
							//-----------------------------------------
							else
							{
								# Make JS safe (UBE - Ugly, but effective)
								$f = preg_replace( '#if\s+?\(#is'  , "i~f~(~"   , $f );
								$f = str_ireplace( 'else'      , "e~lse~"   , $f );
								$f = preg_replace( '#else\s+?if#is', "e~lse~i~f", $f );
							}
								
							if ( $flag )
							{
								$functions[ $flag ] .= $f."\n";
								continue;
							}
						}
						
						$final = "";
						$flag  = 0;
						
						foreach( $functions as $fname => $ftext )
						{
							preg_match( "#//--starthtml--//(.+?)//--endhtml--//#s", $ftext, $matches );

							$content = $this->registry->templateEngine->convertPhpToHtml($matches[1]);
							
							//-----------------------------------------
							// Unconvert JS
							//-----------------------------------------
							
							$content = str_replace( "i~f~(~"   , "if ("   , $content );
							$content = str_replace( "e~lse~"   , "else"   , $content );
							$content = str_replace( "e~lse~i~f", "else if", $content );
							
							/* Encode */
							$content = IPSText::encodeForXml( $content );
								
							/* Build array */
							$array = array( 'template_set_id'     => $set_id,
											'template_group'      => $name,
											'template_content'    => $content,
											'template_name'       => $fname,
											'template_data'       => trim($config[$fname]),
											'template_updated'    => time(),
											'template_removable'  => ( is_numeric( $setId ) AND $setId ) ? 1 : 0,
											'template_master_key' => $set_key,
											'template_added_to'   => $set_id );
																		
							
							if ( ! $setId )
							{
								$added++;

								/* All new bits go to 'master' skin */
								$array['template_set_id']		= 0;
								$array['template_added_to']		= 0;
								$array['template_master_key']	= 'root';

								$this->DB->insert( 'skin_templates', $array );
							}
							else
							{
								/* Compare for changes? */
								if ( IPSText::contentToMd5( $templates[ $name ][ strtolower( $fname ) ]['template_content'] ) != IPSText::contentToMd5( $content ) )
								{
									/* It's changed, so update. We create a new row as it might be inherited */
									$updated++;
									$this->DB->insert( 'skin_templates', $array );
								}
							}
						}
					
						$messages[] = sprintf( $this->lang->words['tplbitimported'], $name, $added, $updated );
						$functions  = array();
					}
				}
			}
		} catch ( Exception $e ) {}

		/* Recache */
		if ( is_numeric( $setId ) AND $setId )
		{
			$this->rebuildPHPTemplates( $setId );
			$this->removeDeadPHPCaches( $setId );
			
			$this->cache->putWithCacheLib( 'Skin_Store_' . $setId, array(), 1 );
		}
		
		if ( $set_key == 'mobile' )
		{
			$this->rebuildMobileSkinUserAgentsFromSetDataXml();
		}
		
		/* Return */
		$messages[] = $this->lang->words['cpltrebuildfromcaches'];
		
		return $messages;
	}
	
	/**
	 * Flag skin as needing recache
	 *
	 * @param	int		Set ID
	 * @param	bool	Skip rebuild skin sets cache
	 * @return	boolean
	 */
	public function flagSetForRecache( $setId=null, $skipRebuild=false )
	{
		/* If we're already flagged, just return
			@link	http://community.invisionpower.com/tracker/issue-31472-skin-recaching-optimizations */
		$_key	= md5( $setId . $skipRebuild );
		
		if ( isset($this->_flaggedForRecache[ $_key ]) )
		{
			return true;
		}
		
		$this->_flaggedForRecache[ $_key ]	= 1;
		
		/* Update DB row */
		if ( $setId !== null )
		{
			$this->DB->update( 'skin_collections', array( 'set_updated' => -2 ), 'set_id=' . intval( $setId ) );
		}
		else
		{
			$this->DB->update( 'skin_collections', array( 'set_updated' => -2 ) );
		}
		
		/* Build cache */
		if( ! $skipRebuild )
		{
			$this->rebuildSkinSetsCache();
		}
		
		return TRUE;
	}
	
	/**
	 * Flag skin as needing recache
	 *
	 * @access	public
	 * @return	boolean
	 */
	public function flagSetAsRecaching( $setId=null )
	{
		/* Update DB row */
		if ( $setId !== null )
		{
			$this->DB->update( 'skin_collections', array( 'set_updated' => -1 ), 'set_id=' . intval( $setId ) );
		}
		else
		{
			$this->DB->update( 'skin_collections', array( 'set_updated' => -1 ) );
		}
		
		/* Build cache */
		$this->rebuildSkinSetsCache();
		
		return TRUE;
	}
	
	
	/**
	 * We set a flag to rebuild the skin sets cache on shutdown.  We do it this way to ensure we only rebuild the cache once per page load.
	 *
	 * @link	http://community.invisionpower.com/tracker/issue-31472-skin-recaching-optimizations
	 * @access	public
	 * @return	boolean
	 */
	public function rebuildSkinSetsCache()
	{
		if( !$this->_recacheSkinsCache )
		{
			$this->_recacheSkinsCache	= true;
			
			register_shutdown_function( array( $this, '__rebuildSkinSetsCache' ) );
		}
	}
	
	/**
	 * Rebuild skinsets cache in the cache_store table
	 *
	 * @access	public
	 * @return	boolean
	 */
	public function __rebuildSkinSetsCache()
	{		
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$cache = array();
		
		//-----------------------------------------
		// Get skins
		//-----------------------------------------
		
		$this->DB->build( array( 'select' => '*',
								 'from'   => 'skin_collections',
								 'order'  => 'set_order, set_id' ) );
		$this->DB->execute();
		
		while( $row = $this->DB->fetch() )
		{
			$cache[ $row['set_id'] ] = $row;
		}

		//-----------------------------------------
		// Save the cache
		//-----------------------------------------
		
		$this->cache->setCache( 'skinsets', $cache, array( 'array' => 1, 'donow' => 1 ) );
		
		//-----------------------------------------
		// Set that it's done
		//-----------------------------------------
		
		$this->DB->update( 'skin_collections', array( 'set_updated' => time() ) );
		
		//-----------------------------------------
		// Flush IPS CDN
		//-----------------------------------------
		
		$this->flushipscdn();
		
		return TRUE;
	}
	
	/**
	 * Recache output formats
	 *
	 * @access	public
	 * @return	boolean
	 */
	public function rebuildOutputFormatCaches()
	{
		$formats = $this->fetchOutputFormats();
		
		$this->registry->cache()->setCache( 'outputformats', $formats, array( 'donow' => 1, 'array' => 1 ) );
		
		return TRUE;
	}
	
	/**
	 * Recache URL remaps
	 *
	 * @access	public
	 * @return	boolean
	 */
	public function rebuildURLMapCache()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$cache = array();
		
		$this->DB->build( array( 'select' => '*',
							     'from'   => 'skin_url_mapping' ) );
		
		$this->DB->execute();
		
		while( $r = $this->DB->fetch() )
		{
			$cache[ $r['map_id'] ] = $r;
		}
		
		$this->registry->cache()->setCache( 'skin_remap', $cache, array( 'donow' => 1, 'array' => 1 ) );
		
		return TRUE;
	}
	
	/**
	 * Fetch Directory CSS
	 * Fetchs and parses directory straight from the directory
	 * Used for IN_DEV skins currently.
	 *
	 * @access	public
	 * @param	string		Dir to read from
	 * @return	array 		Array of data
	 */
	public function fetchDirectoryCSS( $dir )
	{
		/* Set directory */
		$css	  = array();
		$cssDir   = DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/' . $dir;
		$messages = array();

		if ( ! is_dir( $cssDir ) )
		{
			return $css;
		}

		if ( ! is_readable($cssDir) )
		{
			return $css;
		}

		//-----------------------------------------
		// Recurse over the directory
		//-----------------------------------------

		try
		{
			foreach( new DirectoryIterator( $cssDir ) as $file )
			{
				if ( ! $file->isDot() AND ! $file->isDir() )
				{
					$_name = $file->getFileName();
        	
					if ( substr( $_name, -4 ) == '.css' )
					{
						$cssName    = substr( $_name, 0, -4 );
						$cssContent = @file_get_contents( $cssDir . '/' . $_name );
        	
						$cssContent = str_replace( array( "\r\n", "\r" ), "\n", $cssContent );
        	
						$messages[] = $this->lang->words['basicimportedpre'] . $cssName;
        	
						$cssData    = $this->_CSS_fetchImportBlock( $cssContent );
						$cssContent = $this->_CSS_fromFileToDB( $cssContent );
        	
						$css[ $cssName ] = array( 'css_updated'    => time(),
												  'css_set_id'     => 0,
												  'css_added_to'   => 0,
												  'css_app'        => $cssData['css_app'],
												  'css_app_hide'   => intval( isset( $cssData['css_app_hide'] ) ? $cssData['css_app_hide'] : 0 ),
												  'css_position'   => intval( isset( $cssData['css_position'] ) ? $cssData['css_position'] : 0 ),
												  'css_modules'    => isset( $cssData['css_modules'] )    ? $cssData['css_modules'] : '',
												  'css_attributes' => isset( $cssData['css_attributes'] ) ? $cssData['css_attributes'] : '',
												  'css_group'      => $cssName,
												  'css_content'    => $cssContent );
					}
				}
			}
		} catch ( Exception $e ) {}

		return $css;
	}
	
	/**
	 * Write out skin templates in the master format
	 * IN_DEV tool, currently.
	 *
	 * @access	public
	 * @param	int			Skin ID to write out
	 * @param	string		Directory to write into. Directory must be in /public/style_css/
	 * @return	array 		Array of messages
	 * Exception Codes:
	 * IN_DEV_OFF				IN_DEV constant is not enabled
	 * NO_SUCH_SKIN_SET			Skin set of $id does not exist
	 * DIR_DOES_NOT_EXIST		Directory does not exist in /cache/skin_cache
	 * CANNOT_WRITE_DIR			Directory cannot be written into
	 */
	public function writeMasterSkinCss( $id, $dir )
	{
		/* Checkin' */
		if ( ! IN_DEV )
		{
			throw new Exception( 'IN_DEV_OFF' );
		}
		
		if ( ! is_numeric( $id ) )
		{
			$id = $this->fetchSetIdByKey( $id, true );
		}
		
		$setData = $this->fetchSkinData( $id );
		
		$path    = DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/' . $dir;
		$msgs    = array();
		
		if ( ! isset( $setData['set_id'] ) )
		{
			throw new Exception( 'NO_SUCH_SKIN_SET' );
		}
		
		if ( ! is_dir( $path ) )
		{
			throw new Exception( 'DIR_DOES_NOT_EXIST' );
		}
		
		if ( ! is_writeable( $path ) )
		{
			throw new Exception( 'CANNOT_WRITE_DIR' );
		}
		
		/* Fetch CSS */
		$css = $this->fetchCSS( $id, FALSE );
	
		/* Write it.. */
		if ( is_array( $css ) )
		{
			foreach( $css as $group => $data )
			{
				$_block = $this->_masterWrite_createCssBlock( $data );
				
				/**
				 * @link	http://community.invisionpower.com/tracker/issue-36016-exported-master-css-files-are-compressed/
				 */
				$setData['set_minify'] = 0;
				
				if ( @file_put_contents( $path . '/' . $data['css_group'] . '.css', $_block . $this->_CSS_fromDBtoFile( $data['css_content'], $setData ) ) )
				{
					$msgs[] = $this->lang->words['basicwrittenpre'] . $data['css_group'] . '.css';
				}
				else
				{
					$msgs[] = $this->lang->words['basiccouldnotwrite'] . $data['css_group'] . '.css';
				}
			}
		}
		
		return $msgs;
	}
	
	/**
	 * Write out replacements in the master format
	 * IN_DEV tool, currently.
	 *
	 * @access	public
	 * @param	int			Skin ID to write out
	 * @param	string		Directory to write into. Directory must be in /public/style_css/
	 * @return	array 		Array of messages
	 * Exception Codes:
	 * IN_DEV_OFF				IN_DEV constant is not enabled
	 * NO_SUCH_SKIN_SET			Skin set of $id does not exist
	 * DIR_DOES_NOT_EXIST		Directory does not exist in /cache/skin_cache
	 * CANNOT_WRITE_DIR			Directory cannot be written into
	 */
	public function writeMasterSkinReplacements( $id, $dir )
	{
		/* Checkin' */
		if ( ! IN_DEV )
		{
			throw new Exception( 'IN_DEV_OFF' );
		}
		
		if ( ! is_numeric( $id ) )
		{
			$id = $this->fetchSetIdByKey( $id, true );
		}
		
		$setData = $this->fetchSkinData( $id );
		
		$path    = IPS_CACHE_PATH . 'cache/skin_cache/' . $dir;
		$msgs    = array();
		
		if ( ! isset( $setData['set_id'] ) )
		{
			throw new Exception( 'NO_SUCH_SKIN_SET' );
		}
		
		if ( ! is_dir( $path ) )
		{
			throw new Exception( 'DIR_DOES_NOT_EXIST' );
		}
		
		if ( ! is_writeable( $path ) )
		{
			throw new Exception( 'CANNOT_WRITE_DIR' );
		}
		
		/* Fetch Replacements */
		$replacements = $this->fetchReplacements( $id );

		/* Write it.. */
		if ( is_array( $replacements ) )
		{
			$content = "<" . "?php\n\n\$replacements = array(\n\n";
			
			foreach( $replacements as $k => $data )
			{
				$content .= "\n'" . $k . "'				=> \"" . str_replace( '"', '\\"', $data['replacement_content'] ) . '",';
			}
			
			$content .= "\n);\n\n?>";
			
			if ( @file_put_contents( $path . '/_replacements.inc', $content ) )
			{
				$msgs[] = $this->lang->words['basicwrittenpre'] . $path . '/_replacements.inc';
			}
			else
			{
				$msgs[] = $this->lang->words['basiccouldnotwrite'] . $path . '/_replacements.inc';
			}
		}
		
		return $msgs;
	}
	
	/**
	 * Write out skin templates in the master format
	 * IN_DEV tool, currently.
	 *
	 * @access	public
	 * @param	int			Skin ID to write out
	 * @param	string		Directory to write into. Directory must be in /cache/skin_cache/
	 * @return	array 		Array of messages
	 * Exception Codes:
	 * IN_DEV_OFF				IN_DEV constant is not enabled
	 * NO_SUCH_SKIN_SET			Skin set of $id does not exist
	 * DIR_DOES_NOT_EXIST		Directory does not exist in /cache/skin_cache
	 * CANNOT_WRITE_DIR			Directory cannot be written into
	 */
	public function writeMasterSkin( $id, $dir )
	{
		/* Checkin' */
		if ( ! IN_DEV )
		{
			throw new Exception( 'IN_DEV_OFF' );
		}
		
		if ( ! is_numeric( $id ) )
		{
			$id = $this->fetchSetIdByKey( $id, true );
		}
		
		$setData = $this->fetchSkinData( $id );
		
		$path    = IPS_CACHE_PATH . 'cache/skin_cache/' . $dir;
		$msgs    = array();
		
		if ( ! isset( $setData['set_id'] ) )
		{
			throw new Exception( 'NO_SUCH_SKIN_SET' );
		}
		
		if ( ! is_dir( $path ) )
		{
			throw new Exception( 'DIR_DOES_NOT_EXIST' );
		}
		
		if ( ! is_writeable( $path ) )
		{
			throw new Exception( 'CANNOT_WRITE_DIR' );
		}
		
		/* Fetch all template bits. NOW */
		$templates = $this->fetchTemplates( $id, 'allTemplates' );
		
		/* Loop through */
		foreach( $templates as $group => $data )
		{
			$_file    = $group . '.php';
			$_content = '';
			
			foreach( $templates[ $group ] as $_name => $_data )
			{
				$_content .= $this->_masterWrite_format( $_data );
			}
			
			if ( $_content )
			{
				$_content = $this->_masterWrite_wrap( $_content );
				
				if ( ! @file_put_contents( $path . '/' . $_file, $_content ) )
				{
					$msgs[] = $this->lang->words['basiccouldnotwrite'] . $path . '/' . $_file;
				}
				else
				{
					@chmod( $path . '/' . $_file, IPS_FILE_PERMISSION );
					$msgs[] = $this->lang->words['basicwrittenpre'] . $path . '/' . $_file;
				}
			}
			else
			{
				$msgs[] = $this->lang->words['basicnothingtowritepre'] . $path . '/' . $_file;
			}
		}
		
		return $msgs;
	}
	
	/**
	 * Creates CSS master block 
	 * 
	 * @access	protected
	 * @param	array  		Array  of CSS data from the DB
	 * @return	string
	 */
	protected function _masterWrite_createCssBlock( $data )
	{
		$block = array();
		
		if ( isset( $data['css_position'] ) )
		{
			$block[] = "<css_position>" . $data['css_position'] . "</css_position>";
		}
		
		if ( isset( $data['css_app'] ) )
		{
			$block[] = "<css_app>" . $data['css_app'] . "</css_app>";
		}
		
		if ( isset( $data['css_modules'] ) )
		{
			$block[] = "<css_modules>" . $data['css_modules'] . "</css_modules>";
		}
		
		if ( isset( $data['css_app_hide'] ) )
		{
			$block[] = "<css_app_hide>" . $data['css_app_hide'] . "</css_app_hide>";
		}
		
		if ( isset( $data['css_attributes'] ) )
		{
			$block[] = "<css_attributes>" . $data['css_attributes'] . "</css_attributes>";
		}
		
		if ( count( $block ) )
		{
			$_block  = implode( "\n", $block );
			$content = <<<EOF
/*<IPS_IMPORT_BLOCK>
DO NOT REMOVE OR ALTER THIS PLEASE. IT IS REMOVED AUTOMATICALLY BY THE IMPORT ROUTINE.
$_block
</IPS_IMPORT_BLOCK>*/

EOF;
			return $content;
		}
	}
	
	/**
	 * Wrap content for a master skin function
	 *
	 * @access	protected
	 * @param	array		Template bit data
	 * @param	string		Content
	 */
	protected function _masterWrite_format( $data )
	{
		$_open  = '<<<EOF';
		$_close = 'EOF';
		$return = <<<EOF
//===========================================================================
// Name: {$data['template_name']}
//===========================================================================
function {$data['template_name']}({$data['template_data']}) {
\$IPBHTML = "";
//--starthtml--//
\$IPBHTML .= $_open
{$data['template_content']}
$_close;
//--endhtml--//
return \$IPBHTML;
}


EOF;
		return $return;
	}
	
	/**
	 * Wrap content for a master skin class
	 *
	 * @access	protected
	 * @param	string		Content
	 * @param	string		Content
	 */
	protected function _masterWrite_wrap( $content )
	{
		$_date  = gmdate( 'r' );
		$return = <<<EOF
<?php
/**
 * Master skin file
 * Written: $_date
 */
class skin_global_1 extends output {
$content
}
?>
EOF;
		return $return;
	}
	
	/**
	 * Write a CSS cache file
	 *
	 * @access	protected
	 * @param	int			Skin set ID
	 * @param	string		Group  Name
	 * @param	string		CSS content
	 * @return	@e void
	 */
	protected function _writeCSSFile( $setID, $css_group, $css_content )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$skinSetData = $this->fetchSkinData( $setID );
		$css_content = $this->_CSS_fromDBtoFile( $css_content, $skinSetData );
		$return     = 0;
		$good_to_go = 0;

		if ( ! SAFE_MODE_ON )
		{
			$good_to_go = 1;

			if ( is_writeable( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/' ) === TRUE )
			{
				$good_to_go = 1;

				if ( ! is_dir( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/css_' . $setID ) )
				{
					if ( ! @ mkdir( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/css_' . $setID, IPS_FOLDER_PERMISSION ) )
					{
						$this->_addErrorMessage( sprintf( $this->lang->words['couldnotcreatecssdir'], $setID ) );
						return $this->_errorMsgs;
					}
					else
					{
						@file_put_contents( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/css_' . $setID . '/index.html', '' );
						@chmod( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/css_'.$setID, IPS_FOLDER_PERMISSION );
						$good_to_go = 1;
					}
				}
				else
				{
					if ( is_writable( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/css_' . $setID ) !== TRUE )
					{
						$this->_addErrorMessage( sprintf( $this->lang->words['cssdirnotwritaaaable'], $setID ) );
						$good_to_go = 0;
					}
					else if ( is_file( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/css_'.$setID.'/'.$css_group.'.css' ) )
					{
						if ( is_writable( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/css_'.$setID.'/'.$css_group.'.css' ) !== TRUE )
						{
							$this->_addErrorMessage( sprintf( $this->lang->words['cssfilenotwriteable'], $setID, $css_group ) );
							$good_to_go = 0;
						}
						else
						{
							$good_to_go = 1;
						}
					}
					else
					{
						$good_to_go = 1;
					}
				}
			}
			else
			{
				$this->_addErrorMessage( sprintf( $this->lang->words['fatalnotwreite'], DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY ) );
				$good_to_go = 0;
			}
		}
		else
		{
			$this->_addErrorMessage( $this->lang->words['safemodeenablednow'] );
			$good_to_go = 0;
		}

		//-----------------------------------------
		// Write...
		//-----------------------------------------

		if ( $good_to_go )
		{
			if ( $FH = @fopen( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/css_'.$setID.'/'.$css_group.'.css', 'w' ) )
			{
				fwrite( $FH, $css_content, strlen($css_content) );
				fclose( $FH );
				@chmod( DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_css/css_'.$setID.'/'.$css_group.'.css', IPS_FILE_PERMISSION );

				$this->_addMessage( $this->lang->words['basicwrittenpre']. "skin_cache/css_{$setID}/{$css_group}.css" );
			}
			else
			{
				$this->_addErrorMessage( sprintf( $this->lang->words['cssfilenotwriteable'], $setID, $css_group ) );
			}
		}
	}
		
	/**
	 * Write a PHP template cache file
	 *
	 * @access	protected
	 * @param	int			Skin set ID
	 * @param	string		Group  Name
	 * @param	string		Template content
	 * @return	array 		Array of messages
	 */
	protected function _writePHPTemplate( $setID, $groupName, $content )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$return     = 0;
		$good_to_go = 0;
	
		if ( ! SAFE_MODE_ON )
		{
			$good_to_go = 1;
			
			if ( IPSLib::isWritable( IPS_CACHE_PATH.'cache/skin_cache/' ) === TRUE )
			{
				$good_to_go = 1;
				
				if ( ! is_dir( IPS_CACHE_PATH.'cache/skin_cache/cacheid_'.$setID ) )
				{
					if ( ! @ mkdir( IPS_CACHE_PATH.'cache/skin_cache/cacheid_'.$setID, IPS_FOLDER_PERMISSION ) )
					{
						$this->_addErrorMessage( sprintf( $this->lang->words['fatalnotemplatew'], $setID ) );
						return;
					}
					else
					{
						@file_put_contents( IPS_CACHE_PATH.'cache/skin_cache/cacheid_' . $setID . '/index.html', '' );
						@chmod( IPS_CACHE_PATH.'cache/skin_cache/cacheid_'.$setID, IPS_FOLDER_PERMISSION );
						$good_to_go = 1;
					}
				}
				else
				{
					if ( is_file( IPS_CACHE_PATH.'cache/skin_cache/cacheid_'.$setID.'/'.$groupName.'.php' ) )
					{
						if ( IPSLib::isWritable( IPS_CACHE_PATH.'cache/skin_cache/cacheid_'.$setID.'/'.$groupName.'.php' ) !== TRUE )
						{
							$this->_addErrorMessage( sprintf( $this->lang->words['templatefilenowrite'], $setID, $groupName ) );
							$good_to_go = 0;
						}
						else
						{
							$good_to_go = 1;
						}
					}
					else
					{
						$good_to_go = 1;
					}
				}
			}
			else
			{
				$this->_addErrorMessage( sprintf( $this->lang->words['fatalnotemplsafe'], IPS_CACHE_PATH ) );
			}
		}
		
		//-----------------------------------------
		// Write...
		//-----------------------------------------
		
		if ( $good_to_go )
		{
			if ( $FH = @fopen( IPS_CACHE_PATH.'cache/skin_cache/cacheid_'.$setID.'/'.$groupName.'.php', 'w' ) )
			{
				fwrite( $FH, $content, strlen($content) );
				fclose( $FH );
				@chmod( IPS_CACHE_PATH.'cache/skin_cache/cacheid_'.$setID.'/'.$groupName.'.php', IPS_FILE_PERMISSION );
				
				$this->_addMessage( $this->lang->words['basicwrittenpre'] . "skin_cache/cacheid_{$setID}/{$groupName}.php" );
			}
			else
			{
				$this->_addErrorMessage( sprintf( $this->lang->words['templatefilenowrite'], $setID, $groupName ) );
			}
		}
	}
	
	/**
	 * Strip all unneeded hooks
	 *
	 * @access	public
	 * @param	string			Template HTML
	 * @param	array 			Array of hook data
	 * @return	string			Processed template HTML
	 */
	public function stripUnneededHooks( $html, $hooks )
	{
		if ( is_array( $hooks ) and count( $hooks ) )
		{ 
			/* First, make safe hooks we want to keep */
			foreach( $hooks as $hook )
			{ 
				if ( $hook['_commentTag'] )
				{
					$html = str_replace( '<!--hook.' . $hook['_commentTag'] . '-->', '{!--hook.' . $hook['_commentTag'] . '--}', $html );
				}
			}
			
			/* Remove all hooks */
			$html = preg_replace( '#<!--hook\.([^\>]+?)-->#', '', $html );
			
			/* Restore saved hooks */
			foreach( $hooks as $hook )
			{
				if ( $hook['_commentTag'] )
				{
					$html = str_replace( '{!--hook.' . $hook['_commentTag'] . '--}', '<!--hook.' . $hook['_commentTag'] . '-->', $html );
				}
			}
		}
		else
		{
			/* No hooks, so remove all */
			$html = preg_replace( '#<!--hook\.([^\>]+?)-->#', '', $html );
		}
		
		return $html;
	}
	
	/**
	 * Fetch inline data from a master CSS
	 *
	 * @access	protected
	 * @param	string		Raw CSS
	 * @return	array
	 */
	protected function _CSS_fetchImportBlock( $cssContent )
	{
		$return = array( 'css_app'      => '',
						 'css_app_hide' => 0 );
						
		/*<IPS_IMPORT_BLOCK>
		DO NOT REMOVE OR ALTER THIS PLEASE. IT IS REMOVED AUTOMATICALLY BY THE IMPORT ROUTINE.
		<css_app>blog</css_app>
		<css_app_hide>1</css_app_hide>
		</IPS_IMPORT_BLOCK>*/
		
		/* Fetch the data block */
		if ( strstr( $cssContent, '<IPS_IMPORT_BLOCK>' ) ) 
		{
			preg_match( '#/\*<IPS_IMPORT_BLOCK>(.+?)</IPS_IMPORT_BLOCK>\*/#is', $cssContent, $match );
			
			if ( $match[0] )
			{
				preg_match( "#<css_app>(.+?)</css_app>#", $match[0], $cssAppMatch );
				$return['css_app'] = trim( $cssAppMatch[1] );
			
				preg_match( "#<css_app_hide>(.+?)</css_app_hide>#", $match[0], $cssAppHide );
				$return['css_app_hide'] = intval( trim( $cssAppHide[1] ) );
				
				preg_match( "#<css_position>(.+?)</css_position>#", $match[0], $cssPosition );
				$return['css_position'] = intval( trim( $cssPosition[1] ) );
				
				preg_match( "#<css_attributes>(.+?)</css_attributes>#", $match[0], $cssAttr );
				$return['css_attributes'] = trim( $cssAttr[1] );
				
				preg_match( "#<css_modules>(.+?)</css_modules>#", $match[0], $cssModules );
				$return['css_modules'] = isset( $cssModules[1] ) ? trim( $cssModules[1] ) : '';
			}
		}
		
		return $return;
	}
	
	/**
	 * Convert CSS from flatfiles to the DB version
	 *
	 * @access	protected
	 * @param	string		Raw CSS
	 * @return	string		Processed CSS
	 */
	protected function _CSS_fromFileToDB( $cssContent )
	{
		/* Fetch the data block */
		if ( strstr( $cssContent, '<IPS_IMPORT_BLOCK>' ) ) 
		{
			preg_match( '#/\*<IPS_IMPORT_BLOCK>(.+?)</IPS_IMPORT_BLOCK>\*/#is', $cssContent, $match );
			
			if ( $match[0] )
			{
				/* And remove it */
				$cssContent = trim( str_replace( $match[0], '', $cssContent ) );
			}
		}
		
		/* remove phpdoc style comments */
		$cssContent = preg_replace( '#/\*\*(\s+?)(.+?)\n(\s+?)?\*/#s', '', $cssContent );
		
		$cssContent = preg_replace( '#url\((\"|\')?.+?style_images/([\d\w]+?)/#i', "url(\\1{style_images_url}/", $cssContent );
		$cssContent = preg_replace( '#url\((\"|\')?/style_images/([\d\w]+?)#i'  , "url(\\1{style_images_url}/", $cssContent );
		
		return $cssContent;
	}
	
	/**
	 * Convert CSS from DB to the flatfiles version
	 *
	 * @access	protected
	 * @param	string		Raw CSS
	 * @return	string		Processed CSS
	 */
	protected function _CSS_fromDBtoFile( $cssContent, $skinData )
	{
		$skinData['set_image_dir'] = ( $skinData['set_image_dir'] ) ? $skinData['set_image_dir'] : 'master';
		
		/* These are not always set up correctly */
		$this->settings['img_url']		    = ( $this->settings['img_url'] )        ? $this->settings['img_url'] : $this->settings['_original_base_url'] . '/' . PUBLIC_DIRECTORY . '/style_images/' . $skinData['set_image_dir'];
		$this->settings['img_url_no_dir']	= ( $this->settings['img_url_no_dir'] ) ? $this->settings['img_url_no_dir'] : $this->settings['_original_base_url'] . '/' . PUBLIC_DIRECTORY . '/style_images/';

		//-----------------------------------------
		// Fix up style images stuff
		//-----------------------------------------
		
		$cssContent = preg_replace( '#([\(|\s*|\'])(style_images/)#', '\\1{style_images_url}', $cssContent );
		$cssContent = str_replace( '{style_images_url}', $this->settings['img_url_no_dir'] . $skinData['set_image_dir'], $cssContent );
		
		//-----------------------------------------
		// And honor image url
		//-----------------------------------------
	
		if ( $this->settings['ipb_img_url'] )
		{
			if ( ! preg_match( "#/$#", $this->settings['ipb_img_url'] ) )
			{
				$this->settings['ipb_img_url'] .= '/';
			}

			$cssContent = preg_replace( '#url\((\'|\")?\.\./\.\./style_images/#', "url(\\1" . $this->settings['ipb_img_url'] . "/style_images/", $cssContent );
		}

		//-----------------------------------------
		// Minify CSS?
		//-----------------------------------------
		
		if ( $skinData['set_minify'] )
		{
			$cssContent = $this->minify( $cssContent, 'css' );
		}
		
		return $cssContent;
	}
	
	/**
	 * Determine which CSS files need rebuilding
	 *
	 * @access	protected
	 * @param	array 		Array of child skins (including current setID)
	 * @param	int 		Set ID we're recaching
	 * @param	boolean 	Force all css sets to recache
	 * @return	array 		Array of items to rebuild
	 */
	protected function _CSSNeedToRebuild( $childTree, $setID, $forceRebuild=FALSE )
	{
		//-----------------------------------------
		// Already been 'ere?
		//-----------------------------------------
		
		if ( is_array( $this->_cssNeedToRebuildArray[ $setID ] ) )
		{
			return $this->_cssNeedToRebuildArray[ $setID ];
		}
		
		$cachedCSS		= array();
		$thisCSS		= array();
		$needToRebuild	= array();
		
		//-----------------------------------------
		// Fetch cached CSS data - need to add parent tree and select parent css first
		//-----------------------------------------
		
		/* Do we need a parent? */
		$setData = $this->fetchSkinData( $setID );
	
		if ( count( $setData['_parentTree'] ) )
		{
			/* Allow parent data to be overwritten by child data */
			$this->DB->build( array( 'select' => '*',
								 	 'from'   => 'skin_cache',
								 	 'where'  => "cache_type='css' AND cache_set_id IN (" . implode( ',', $setData['_parentTree'] ) . ')' ) );
									
			$this->DB->execute();
			
			while( $row = $this->DB->fetch() )
			{
				$row['cache_content'] = md5( $row['cache_content'] );
				$cachedCSS[ $row['cache_set_id'] ][ $row['cache_value_1'] ] = $row;
			}
		}
		
		$this->DB->build( array( 'select' => '*',
								 'from'   => 'skin_cache',
								 'where'  => "cache_type='css' AND cache_set_id IN (" . implode( ',', $childTree ) . ')' ) );
									
		$this->DB->execute();
		
		while( $row = $this->DB->fetch() )
		{
			$row['cache_content'] = md5( $row['cache_content'] );
			$cachedCSS[ $row['cache_set_id'] ][ $row['cache_value_1'] ] = $row;
		}
	
		//-----------------------------------------
		// Fetch all CSS data for this skin set and master
		//-----------------------------------------
		
		$this->DB->build( array( 'select' => '*',
								 'from'   => 'skin_css',
								 'where'  => "css_set_id IN( 0, " . $setID . ' )' ) );
									
		$this->DB->execute();
		
		while( $row = $this->DB->fetch() )
		{
			$row['css_content'] = md5( $row['css_content'] );
			
			$thisCSS[ $row['css_set_id'] ][ $row['css_group'] ] = $row;
		}
		
		/* Add in parent skins */
		if ( count( $setData['_parentTree'] ) )
		{
			$childTree = array_merge( $childTree, $setData['_parentTree'] );
		}
		
		//-----------------------------------------
		// First off, any caches missing?
		//-----------------------------------------

		foreach( $childTree as $_setID )
		{
			if ( $_setID > 0 AND is_array( $thisCSS[ $_setID ] ) )
			{
				foreach( $thisCSS[ $_setID ] as $group => $data )
				{
					if ( ! is_array( $cachedCSS[ $_setID ][ $group ] ) OR $forceRebuild === TRUE )
					{
						/* Not currently cached. Needs to be recached */
						$needToRebuild[ $_setID ][ $group ] = 2;
						continue;
					}
				}
			}
			
			if ( $_setID > 0 )
			{
				/* We have no caches at all... */
				if ( is_array( $thisCSS[0] ) )
				{
					foreach( $thisCSS[0] as $group => $data )
					{
						if ( ! is_array( $cachedCSS[ $_setID ][ $group ] ) OR $forceRebuild === TRUE )
						{
							/* Not currently cached. Needs to be recached */
							$needToRebuild[ $_setID ][ $group ] = 2;
							continue;
						}
					}
				}
			}
		}
	
		//-----------------------------------------
		// Forcing the issue?
		//-----------------------------------------
		
		if ( $forceRebuild === TRUE )
		{
			$this->_cssNeedToRebuildArray[ $setID ] = $needToRebuild;
			
			return $needToRebuild;
		}
		
		//-----------------------------------------
		// Now check to see if there are any that
		// inherit directly from any CSS in this set
		//-----------------------------------------
		
		if( is_array($cachedCSS) AND count($cachedCSS) )
		{
			foreach( $cachedCSS as $_setID => $_data )
			{
				foreach( $_data as $group => $cacheData )
				{
					if ( $cacheData['cache_key_3'] != 'setBy' )
					{ 
						$needToRebuild[ $_setID ][ $group ] = 1;
					}
					else if ( $cacheData['cache_set_id'] == $setID )
					{
						/* This CSS is from our skin set, so recache */
						$needToRebuild[ $_setID ][ $group ] = 1;
					}
					else if ( $cacheData['cache_set_id'] == $_setID )
					{
						/* This CSS is from our child tree, so recache */
						$needToRebuild[ $_setID ][ $group ] = 1;
					}
					else if ( $cacheData['cache_value_3'] == $setID )
					{
						/* This CSS inherits our skin set, so recache */
						$needToRebuild[ $_setID ][ $group ] = 1;
					}
					
					/* Now lets see if there are any parent CSS that need to be added */
					if ( count( $setData['_parentTree'] ) )
					{
						foreach( $setData['_parentTree'] as $id )
						{
							if ( $cacheData['cache_key_3'] == 'setBy' && $cacheData['cache_value_3'] == $id )
							{ 
								/* Add to current set id */
								$needToRebuild[ $setID ][ $group ] = 1;
							}
						}
					}
				}
			}
		}
		
		/* Finally, we don't want to recache parents so remove them */
		if ( count( $setData['_parentTree'] ) )
		{
			foreach( $setData['_parentTree'] as $id )
			{
				if ( is_array( $needToRebuild[ $id ] ) )
				{
					unset( $needToRebuild[ $id ] );
				}
			}
		}

		$this->_cssNeedToRebuildArray[ $setID ] = $needToRebuild;
		
		return $needToRebuild;
	}
	
}