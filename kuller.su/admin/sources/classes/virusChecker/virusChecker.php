<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Virus scanner
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @since		Tue. 17th August 2004
 * @version		$Rev: 10721 $
 * 
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

class virusChecker
{
	/**
	 * Directory separator
	 *
	 * @access	public
	 * @var		string
	 */
	public $dir_split		= "/";
	
	/**
	 * Dodgy files
	 * 
	 * @access	public
	 * @var		array
	 */
	public $bad_files		= array();
	
	/**
	 * Checked folders
	 *
	 * @access	public
	 * @var		string
	 */
	public $checked_folders	= array();
	
	/**
	 * Known names
	 *
	 * @access	public
	 * @var		string
	 */
	public $known_names		= array();
	
	/**#@+
	 * Registry Object Shortcuts
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
	 * Constructor
	 * 
	 * @access	public
	 * @param	object		ipsRegistry reference
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry )
	{
		//-----------------------------------------
		// Make object references
		//-----------------------------------------
		
		$this->registry	= $registry;
		$this->DB       = $registry->DB();
		$this->settings = $registry->settings();
		$this->member   = $registry->member();
		$this->memberData =& $registry->member()->fetchMemberData();
		$this->cache    = $registry->cache();
		$this->caches   =& $registry->cache()->fetchCaches();
		$this->request  = $registry->request();
		
		set_time_limit(0);
		
		if( strpos( strtolower( PHP_OS ), 'win' ) === 0 )
		{
			$this->dir_split = "\\";
		}
		
		//-----------------------------------------
		// Known names
		//-----------------------------------------
		$KNOWN_NAMES = array();
		require( IPS_ROOT_PATH . 'sources/classes/virusChecker/lib_known_names.php' );/*noLibHook*/
		
		$this->known_names = $KNOWN_NAMES;
	}

	/**
	 * Runs the scan
	 * All suspicious files are entered into
	 * $this->bad_files array
	 *
	 * @access	public
	 * @return	@e void
	 */
	public function runScan()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$expected	= array();
		$root_dir 	= preg_replace( "#^(.+?)\/$#", "\\1", DOC_IPS_ROOT_PATH );
		$skin_dirs  = array();

		//-----------------------------------------
		// Get libs
		//-----------------------------------------
		$WRITEABLE_DIRS = array();
		require( IPS_ROOT_PATH . 'sources/classes/virusChecker/lib_writeable_dirs.php' );/*noLibHook*/
		
		//-----------------------------------------
		// Sort out directory separator
		//-----------------------------------------
		
		if ( $this->dir_split != '/' )
		{
			$_WRITEABLE_DIRS = $WRITEABLE_DIRS;
			$WRITEABLE_DIRS  = array();
			
			foreach( $_WRITEABLE_DIRS as $dir )
			{
				$WRITEABLE_DIRS[] = str_replace( '/' , $this->dir_split, $dir );
			}
		}
		
		//-----------------------------------------
		// Get language directories
		//-----------------------------------------
				
		if ( ipsRegistry::cache()->getCache('lang_data') AND is_array( ipsRegistry::cache()->getCache('lang_data') ) && count( ipsRegistry::cache()->getCache('lang_data') ) )
		{
			foreach( ipsRegistry::cache()->getCache('lang_data') as $v )
			{
				$WRITEABLE_DIRS[] = 'cache' . $this->dir_split . 'lang_cache' . $this->dir_split . $v['lang_id'];
			}
		}
		else
		{
			$this->DB->build( array( 'select' => 'lang_id', 'from' => 'core_sys_lang' ) );
			$this->DB->execute();
			
			while( $v = $this->DB->fetch() )
			{
				$WRITEABLE_DIRS[] = 'cache' . $this->dir_split . 'lang_cache' . $this->dir_split . $v['lang_id'];			
			}
		}
		
		ipsRegistry::DB()->build( array( 'select' => 'lang_id, word_app, word_pack', 'from' => 'core_sys_lang_words' ) );
		ipsRegistry::DB()->execute();
		
		while( $r = ipsRegistry::DB()->fetch() )
		{
			$expected[ $r['word_app'] . '_' . $r['word_pack'] ] = 'cache' . $this->dir_split . 'lang_cache' . $this->dir_split . $r['lang_id'] . $this->dir_split . $r['word_app'] . '_' . $r['word_pack'] . '.php';
		}
		
		//-----------------------------------------		
		// Get skin directories
		//-----------------------------------------
				
		if ( is_array( ipsRegistry::cache()->getCache('skinsets') ) && count( ipsRegistry::cache()->getCache('skinsets') ) )
		{
			foreach( ipsRegistry::cache()->getCache('skinsets') as $k => $v )
			{
				if ( $k == 1 && !IN_DEV )
				{
					continue;
				}
				
				$WRITEABLE_DIRS[] = 'cache' . $this->dir_split . 'skin_cache' . $this->dir_split . 'cacheid_' . $v['set_id'];
				$skin_dirs[] = $v['set_id'];
			}
		}
		else
		{
			$this->DB->build( array( 'select' => 'set_id', 'from' => 'skin_collections' ) );
			$this->DB->execute();
			
			while( $v = $this->DB->fetch() )
			{
				$WRITEABLE_DIRS[] = 'cache' . $this->dir_split . 'skin_cache' . $this->dir_split . 'cacheid_' . $v['set_id '];
				$skin_dirs[] = $v['set_id'];
			}
		}
		
		//-----------------------------------------		
		// Get skin files
		//-----------------------------------------
		
		$this->DB->build( array( 'select'	=> $this->DB->buildDistinct( 'template_group' ),
										'from'	=> 'skin_templates',
										'group'	=> 'template_group'
							)		);
		$this->DB->execute();
	
		while( $v = $this->DB->fetch() )
		{
			foreach( $skin_dirs as $dir )
			{
				$expected[] = 'cache' . $this->dir_split . 'skin_cache' . $this->dir_split . 'cacheid_' . $dir . $this->dir_split . $v['template_group'] . '.php';
			}
		}
		
		//-----------------------------------------
		// Alright, do it!
		//-----------------------------------------
		
		$WRITEABLE_DIRS = array_unique($WRITEABLE_DIRS);
		
		foreach( $WRITEABLE_DIRS as $dir_to_check )
		{
			if ( $dir_to_check == 'uploads' OR $dir_to_check == 'style_emoticons' )
			{
				# Leave this 'til later
				continue;
			}
			
			if ( file_exists( $root_dir . $this->dir_split . $dir_to_check ) )
			{
				$this->checked_folders[] = $root_dir . $this->dir_split . $dir_to_check;
				
				$dh = opendir( $root_dir . $this->dir_split . $dir_to_check );
				
				while ( false !== ( $file = readdir($dh) ) )
				{ 
					if ( preg_match( "#.*\.(php|js|html|htm|cgi|pl|perl|php3|php4|php5|php6)$#i", $file ) )
					{
						if ( ! in_array( $dir_to_check . $this->dir_split . $file, $expected ) AND $file != "index.html" AND $file != 'lang_javascript.js' )
						{
							$score = intval( $this->_scoreFile( $root_dir . $this->dir_split . $dir_to_check . $this->dir_split . $file ) );
							
							$this->bad_files[] = array( 'file_path' => $root_dir . $this->dir_split . $dir_to_check . $this->dir_split . $file,
														'file_name' => $file,
														'score'     => $score );
						}
					}
				}
			
				@closedir($dh);
			}
		}
		
		//-----------------------------------------
		// Check 'blog' dir
		//-----------------------------------------
		
		if ( file_exists( $root_dir . $this->dir_split . 'blog' ) )
		{
			$this->deepScan( $root_dir . $this->dir_split . 'blog', 'all', array( 'index.php' ) );
		}
		
		//-----------------------------------------
		// Check 'html' dir
		//-----------------------------------------
		
		if ( file_exists( $root_dir . $this->dir_split . 'html' ) )
		{
			$this->deepScan( $root_dir . $this->dir_split . 'html', 'all', array( 'index.php' ) );
		}
		
		//-----------------------------------------
		// Check 'Skin' dir
		//-----------------------------------------
		
		if ( file_exists( $root_dir . $this->dir_split . 'Skin' ) )
		{
			$this->deepScan( $root_dir . $this->dir_split . 'Skin', 'all' );
		}
		
		//-----------------------------------------
		// Check emoticons
		//-----------------------------------------
		
		$this->deepScan( $root_dir . $this->dir_split . PUBLIC_DIRECTORY . '/style_emoticons', 'all' );
		
		//-----------------------------------------
		// Check image directories
		//-----------------------------------------
		
		$this->deepScan( $root_dir . $this->dir_split . PUBLIC_DIRECTORY . '/style_images', '(php|cgi|pl|perl|php3|php4|php5|php6|phtml|shtml)' );
		
		//-----------------------------------------
		// Check upload directories
		//-----------------------------------------
		
		$this->deepScan( $this->settings['upload_dir'] );
	}

	/**
	 * Score a file
	 *
	 * Return a score from 0 being harmless to 10 being, well the complete opposite to harmless.
	 *
	 * Score information:
	 * Name 3 chars or less + 2
	 * '- Name 2 chars or less + 4
	 * Size over 65k + 3
	 * '- Size over 100k + 4
	 * User nobody + 3
	 * Modified in the 30 days + 1
	 * In non PHP folder + 3
	 *
	 * @access	protected
	 * @param	string	Full file path and name
	 * @param	array 	stat info
	 * @return	int 	Score (0 - 10 )
	 */
	protected function _scoreFile( $file_name, $stat=array() )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$SCORE         = 0; 
		$name          = preg_replace( "#^(.*)/(.+?)$#is" , "\\2", $file_name );
		$name_sans_ext = preg_replace( "#^(.*)\.(.+?)$#si", "\\1", $name );
		
		//-----------------------------------------
		// Check
		//-----------------------------------------
	
		if ( ! $file_name )
		{
			return -1;
		}
		
		if ( ! is_array( $stat ) OR ! count( $stat ) )
		{
			$stat = stat( $file_name );
		}
		
		//-----------------------------------------
		// Alright...
		//-----------------------------------------
		
		if ( in_array( $file_name, $this->known_names ) )
		{
			$SCORE += 7;
		}
		
		//-----------------------------------------
		// User nobody?
		//-----------------------------------------
		
		if ( $stat['uid'] == 99 )
		{
			$SCORE += 3;
		}
		
		if ( strlen( $name_sans_ext ) < 3 )
		{
			$SCORE += 4;
		}
		else if ( $name_sans_ext == 'temp' OR $name_sans_ext == 'test' )
		{
			$SCORE +=2;
		}
		else if ( strlen( $name_sans_ext ) < 4 )
		{
			$SCORE += 2;
		}
		
		//-----------------------------------------
		// Size
		//-----------------------------------------
		
		if ( $stat['size'] > 100 * 1024 )
		{
			$SCORE += 4;
		}
		else if ( $stat['size'] > 65 * 1024 )
		{
			$SCORE += 3;
		}
		
		//-----------------------------------------
		// Last modified...
		//-----------------------------------------
		
		if ( $stat['mtime'] > time() - 86400 * 30 )
		{
			$SCORE += 1;
		}
		
		//-----------------------------------------
		// Non PHP folder...
		//-----------------------------------------
		
		if ( preg_match( "#(?:style_images|style_emoticons|uploads|default|1|skin_acp|html|skin)/#i", $file_name ) )
		{
			$SCORE += 3;
		}
		
		//-----------------------------------------
		// Run any plugins
		//-----------------------------------------
		
		if( is_dir( IPS_ROOT_PATH . '/sources/classes/virusChecker/plugins' ) )
		{
			try
			{
				foreach( new DirectoryIterator( IPS_ROOT_PATH . '/sources/classes/virusChecker/plugins' ) as $file )
				{
					if ( $file->isFile() )
					{
						$_name = $file->getFileName();
            	
						if( strpos( $_name, '.php' ) )
						{
							$classToLoad = IPSLib::loadLibrary( $file->getPathname(), 'virusScannerPlugin_' . str_replace( '.php', '', $_name ) );
							
							if( class_exists( $classToLoad ) )
							{
								$plugin	= new $classToLoad( $this->registry );
								
								if( method_exists( $plugin, 'run' ) )
								{
									$SCORE	+= $plugin->run( $file_name );
								}
							}
						}
					}
				}
			} catch ( Exception $e ) {}
		}
		
		//-----------------------------------------
		// Return
		//-----------------------------------------
	
		return $SCORE > 10 ? 10 : $SCORE;
	}

	/**
	 * Deep scan
	 *
	 * All suspicious files are entered into
	 * $this->bad_files array
	 *
	 * @access	public
	 * @param	string		Directory
	 * @param	string		Regex to look for
	 * @param	array 		Files to ignore
	 */
	public function deepScan( $dir, $look_for='(php|js|html|htm|cgi|pl|perl|php3|php4|php5|php6|htaccess|so|phtml|shtml)', $ignore_files=array() )
	{	
		//-----------------------------------------
		// Short-hand
		//-----------------------------------------
		
		if ( $look_for == 'all' )
		{
			$look_for = '(php|js|html|htm|cgi|pl|perl|php3|php4|php5|php6|htaccess|so|phtml|shtml)';
		}
		
		//-----------------------------------------
		// Add into checked folders
		//-----------------------------------------
		
		$this->checked_folders[] = $dir . $this->dir_split;
		
		$dh = @opendir( $dir );
		if ( $dh === FALSE )
		{
			return;
		}
		
		while ( false !== ( $file = readdir($dh) ) )
		{
			if ( IN_DEV )
			{
				if ( $file == '.' or $file == '..' or $file == '.svn' or $file == '.DS_store' or $file == 'index.html' )
				{
					continue;
				}
			}
			else
			{
				if ( $file == '.' or $file == '..' )
				{
					continue;
				}
			}
			
			if ( is_dir( $dir . $this->dir_split . $file ) )
			{
				$this->deepScan( $dir . $this->dir_split . $file, $look_for );
			}
			else
			{
				if ( in_array( $dir . $this->dir_split . $file, $ignore_files ) )
				{
					continue;
				}
				
				if ( preg_match( "#^(.*)?\." . $look_for . "(?:\..+?)?$#i", $file ) )
				{ 
					$score = intval( $this->_scoreFile( $dir . $this->dir_split . $file ) );
					
					$this->bad_files[] = array( 'file_path' => $dir . $this->dir_split . $file,
												'file_name' => $file,
												'score'     => $score );
				}
			}
		}
	}
}