<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * XML Archive Hanlder: Can create XML Archives (gzips) of multiple files, binary and ascii
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Kernel
 * @link		http://www.invisionpower.com
 * @since		25th February 2004
 * @version		$Revision: 10721 $
 *
 *
 * Example Usage:
 * <code>
 * Sample file set:
 *
 * someDir/
 * someDir/index.html
 * someDir/file.html
 * someDir/images/
 * someDir/images/pic.jpg
 * anotherDir/
 * anotherDir/anotherFile.html
 *
 * # READING ARCHIVE
 * $archive = new classXMLArchive();
 * try
 * {
 *	$archive->read( "/path/to/archive.xml" );
 * }
 * catch ( Exception $err ) {}
 *
 * print $archive->getFile('someDir/file.html');
 * print_r( $archive->asArray() );
 *
 * # CREATING ARCHIVE
 *
 * $archive = new classXMLArchive();
 *
 * try
 * {
 *	$archive->add( "someDir" );
 *  $archive->add( "anotherDir/anotherFile.html" );
 *  $archive->add( "Create a new file from scratch!", "anotherDir/brandNewFile.html" );
 * }
 * catch ( Exception $err ) {}
 *
 * # Save gzipped
 * $archive->saveGZIP( "/path/to/archive.xml.gzip" );
 * # Save normally
 * $archive->save( "/path/to/archive.xml" );
 * # Just return the data
 * $archive->getArchiveContents();
 * </code>
 *
 *
 * Exception Codes:
 * <ul>
 * <li>FILE_OR_DIR_NOT_EXISTS: No such directory or file
 * <li>NOT_A_DIR: Not a directory
 * <li>CANNOT_WRITE_TO_DISK: Could not write archive to disk
 * <li>NOTHING_TO_SAVE: No XML document to save
 * <li>COULD_NOT_LOAD_XML_DATA: Could not load xml data
 * <li>WRITE_NOT_VALID_INPUT: The input (XML or filename) is not valid
 * <li>NO_FILES_TO_WRITE: The archive contains nothing to write back
 * </ul>
 *
 */

class classXMLArchive
{
	/**
	 * XML Object
	 *
	 * @var 		object
	 */
	protected $_xml				= null;
	
	/**
	 * File array
	 *
	 * @var 		array
	 */
	public $_fileArray		= array();
	
	/**
	 * Error number
	 *
	 * @var 		integer
	 */
	public $error_number  	= 0;
	
	/**
	 * Error message
	 *
	 * @var 		string
	 */
	public $error_message 	= "";
	
	/**
	 * Work files
	 *
	 * @var 		array
	 */
	public $_workFiles	= array();
	
	/**
	 * Non binary file extensions
	 *
	 * @var 		string
	 */
	public $non_binary		= 'txt htm html xml css js cgi php php3';
	
	/**
	 * Strip path
	 *
	 * @var 		string
	 */
	public $_stripPathString		= "";
	
	/**
	 * Allow hidden files
	 *
	 * @var		boolean
	 */
	protected $_allowHiddenFiles  = FALSE;
	
	/**
	 * Root tag values
	 *
	 * @var		array
	 */
	protected $_defaultRootValues = array();
	
	/**
	 * Constructor
	 *
	 * @param	string		Script root path
	 * @return	@e void
	 */
	public function __construct()
	{
		//-----------------------------------
		// Get the XML class
		//-----------------------------------
		
		require_once( dirname( __FILE__ ) . '/classXML.php' );/*noLibHook*/
		$this->_xml = new classXML( IPS_DOC_CHAR_SET );
		
		/* Set up the root values */
		$this->_defaultRootValues = array( 'generator' => 'IPS_KERNEL', 'created' => time() );
		
		$this->error_number = 0;
	}
	
	/**
	 * Adds values to the root tag
	 *
	 * @return	@e void
	 */
	public function addRootTagValues( $array=array() )
	{
		if ( is_array( $array ) AND count( $array ) )
		{
			foreach( $array as $k => $v )
			{
				if ( $k and $v != '' )
				{
					$this->_defaultRootValues[ $k ] = $v;
				}
			}
		}
	}

	/**
	 * Allow hidden files to be added when using addDir
	 *
	 * @return	@e void
	 */
	public function allowHiddenFiles()
	{
		$this->_allowHiddenFiles = TRUE;
	}
	
	/**
	 * Set the path to 'strip' from the path data
	 *
	 * @param	string		Full path to remove
	 * @return	@e void
	 */
	public function setStripPath( $path )
	{
		/* Ensure that there is no trailing slash */
		$path = rtrim( $path, '/' );
		
		$this->_stripPathString = $path;
	}
	
	/**
	 * Return file data as array
	 *
	 * @return	@e array
	 */
	public function asArray()
	{
		return $this->_fileArray;
	}
	
	/**
	 * Return a file from the fileArray
	 *
	 * @param	string	Key
	 * @return	@e string
	 */
	public function getFile( $key )
	{
		if ( isset( $this->_fileArray[ $key ] ) )
		{
			return $this->_fileArray[ $key ]['content'];
		}
		else
		{
			return '';
		}
	}
	
	/**
	 * Return number of files contained in the expanded archive
	 *
	 * @return	@e integer
	 */
	public function countFileArray()
	{
		return intval( count( $this->_fileArray ) );
	}
	
	/**
	 * Read an XML document from disk
	 *
	 * @param	string	File name
	 * @return	@e void
	 */
	public function read( $filename )
	{
		if ( is_file( $filename ) )
		{
			if ( strstr( $filename, '.gz' ) )
			{
				if ( $FH = @gzopen( $filename, 'r' ) )
				{
					$data = @gzread( $FH, $filename );
					@gzclose( $FH );
				}
				else
				{
					throw new Exception( "COULD_NOT_LOAD_XML_DATA" );
				}
			}
			else
			{
				if ( $FH = @fopen( $filename, 'r' ) )
				{
					$data = @fread( $FH, filesize( $filename ) );
					@fclose( $FH );
				}
				else
				{
					throw new Exception( "COULD_NOT_LOAD_XML_DATA" );
				}
			}
			
			$this->readXML( $data );
		}
		else
		{
			throw new Exception( "FILE_OR_DIR_NOT_EXISTS" );
		}
	}
	
	/**
	 * Read an XML document from passed data
	 *
	 * @param	string	Raw XML Data
	 * @return	@e void
	 */
	public function readXML( $data )
	{
		if ( $data )
		{
			$this->_xml->loadXML( $data );
			
			foreach( $this->_xml->fetchElements('file') as $file )
			{
				$_file = $this->_xml->fetchElementsFromRecord( $file );
				$_file['content'] = base64_decode( preg_replace( "/\s/", "", $_file['content'] ) );
				
				$this->_fileArray[ ltrim( $_file['path'] . '/' . $_file['filename'], '/' ) ] = $_file;
			}
		}
	}
	
	/**
	 * Write out the XML document as a GZIP file
	 *
	 * @param	string	Filename
	 * @return	@e void
	 */
	public function saveGZIP( $filename )
	{
		$this->_create();
		
		if ( $this->_xml->fetchDocument() )
		{
			if ( $FH = @gzopen( $filename, 'wb' ) )
			{
				@gzwrite( $FH, $this->_xml->fetchDocument() );
				@gzclose( $FH );
			}
			else
			{
				throw new Exception( "CANNOT_WRITE_TO_DISK" );
			}
		}
		else
		{
			throw new Exception( "NOTHING_TO_SAVE" );
		}
	}
	
	/**
	 * Write out the XML document as a normal file
	 *
	 * @param	string	FIlename
	 * @return	@e void
	 */
	public function save( $filename )
	{
		$this->_create();
		
		$_doc = $this->_xml->fetchDocument();
		
		if ( $_doc )
		{
			if ( $FH = @fopen( $filename, 'wb' ) )
			{
				@fwrite( $FH, $_doc );
				@fclose( $FH );
			}
			else
			{
				throw new Exception( "CANNOT_WRITE_TO_DISK" );
			}
		}
		else
		{
			throw new Exception( "NOTHING_TO_SAVE" );
		}
	}
	
	/**
	 * Method of getting XML document from this class
	 *
	 * @return	string	XML document
	 */
	public function getArchiveContents()
	{
		$this->_create();
		return $this->_xml->fetchDocument();
	}
	
	/**
	 * Write the archive back to disk
	 *
	 * Note: Ensure that if you intend to make XMLArchives available for others
	 * that you create it with setStripPath otherwise you may get unexpected results!
	 *
	 * @param	mixed		Filename (must end with .xml or .gz) or raw data
	 * @param	string		Base path to write to
	 * @return	@e boolean
	 * @throws	Exception
	 *
	 * Exception Codes:
	 * WRITE_NOT_VALID_INPUT		The input (XML or filename) is not valid
	 * NO_FILES_TO_WRITE			The archive contains nothing to write back
	 */
	public function write( $input, $basePath='/' )
	{
		/* Gather the data */
		if ( substr( $input, -3 ) == '.gz' OR substr( $input, -3 ) == '.xml' )
		{
			try
			{
				$this->read( $input );
			}
			catch( Exception $e )
			{
				return $e->getMessage();
			}
		}
		else if ( strstr( $input, '<xmlarchive' ) )
		{
			$this->readXML( $input );
		}
		else
		{
			throw new Exception( "WRITE_NOT_VALID_INPUT" );
		}
		
		/* Did we get anything? */
		if ( ! $this->countFileArray() )
		{
			throw new Exception( "NO_FILES_TO_WRITE" );
		}
		
		$basePath = rtrim( $basePath, '/' );
		
		/* So, write 'em! */
		$files = $this->asArray();
		
		foreach( $files as $path => $data )
		{
			$path = trim( $path, '/' );
			
			if ( $this->_writeContents( $basePath . '/' . $path, $data['content'] ) !== TRUE )
			{
				return FALSE;
			}
		}
		
		/* Done */
		return TRUE;
	}
	
	/**
	 * Main "Add" function  handles a lot of stuff.
	 * It's good like that!
	 *
	 * @param	string		Filename or data
	 * @param	string		File to store as
	 * @return	@e mixed
	 */
	public function add( $data, $saveName='' )
	{
		/* Is this just data? */
		if ( $saveName )
		{
			return $this->addData( $data, $saveName );
		}
		else if ( is_dir( $data ) )
		{
			return $this->addDirectory( $data );
		}
		else
		{
			return $this->addFile( $data );
		}
	}
	
	/**
	 * Shorthand function
	 *
	 * @return	@e mixed
	 * @see		addDirectory()
	 */
	public function addDir( $dir )
	{
		return $this->addDirectory( $dir );
	}
	
	/**
	 * Add directory to archive
	 *
	 * @param	string		Directory to add
	 * @return	@e mixed
	 * @throws	Exception
	 */
	public function addDirectory( $dir )
	{
		//-----------------------------------
		// Got dir?
		//-----------------------------------
		
		if ( ! is_dir($dir) )
		{
			throw new Exception( "FILE_OR_DIR_NOT_EXISTS" );
			return false;
		}
		
		$dir = rtrim( $dir, '/' );
		
		//-----------------------------------
		// Populate this->workfiles
		//-----------------------------------
		
		$this->_workFiles = array();
		$this->_getDirContents( $dir );
		
		//-----------------------------------
		// Add them into the file array
		//-----------------------------------
		
		foreach ( $this->_workFiles as $f )
		{
			$this->addFile( $f );
		}
		
		$this->_workFiles = array();
	}
	
	/**
	 * Add file to archive
	 *
	 * @param	string		File to add
	 * @param	array 		Extra tags
	 * @return	@e mixed
	 */
	public function addFile( $filename, $extra_tags=array() )
	{
		//-----------------------------------
		// Kill hidden files
		//-----------------------------------
		
		$_temp = explode( '/', $filename );
		
		$actual_file = array_pop( $_temp );
		
		if ( in_array( strtolower($actual_file), array( '.ds_store', 'thumbs.db' ) ) )
		{
			return false;
		}

		if ( file_exists( $filename ) )
		{
			if ( $FH = @fopen( $filename, 'rb' ) )
			{
				$data = @fread( $FH, filesize( $filename ) );
				@fclose( $FH );
			}
			
			$this->addData( $data, $filename, $extra_tags );
		}
		else
		{
			throw new Exception( "FILE_OR_DIR_NOT_EXISTS" );
		}
	}

	/**
	 * Add filecontents to archive
	 *
	 * @param	string		File data
	 * @param	string		File name
	 * @param	array 		Extra tags
	 * @return	@e void
	 */
	public function addData( $data, $filename, $extra_tags=array() )
	{
		$ext = preg_replace( "/.*\.(.+?)$/", "\\1", $filename );
		
		$binary = 1;
		
		//-----------------------------------
		// ASCII?
		//-----------------------------------
		
		if ( strstr( ' ' . $this->non_binary . ' ', ' '.$ext.' ' ) )
		{
			$binary = 0;
		}
		
		//-----------------------------------
		// Get dir / filename
		//-----------------------------------
		
		$dir_path = array();
		$dir_path = explode( "/", $filename );
		
		if ( count( $dir_path ) )
		{
			$real_filename = array_pop( $dir_path );
		}
		
		$real_filename = $real_filename ? $real_filename : $filename;
		
		$path = implode( "/", $dir_path );
		
		$path = $this->_stripPath( $path );
		
		$this_array = array(
							'filename'	=> $real_filename,
							'content'	=> $data,
							'path'		=> $path,
							'binary'	=> $binary
						  );
						  
		foreach( $extra_tags as $k => $v )
		{
			if ( $k and ! in_array( $k, array_keys($this_array) ) )
			{
				$this_array[ $k ] = $v;
			}
		}
		
		$this->_fileArray[] = $this_array;
	}
	
	/**
	 * Create the XML archive
	 *
	 * @return	@e void
	 */
	protected function _create()
	{
		$this->_xml->newXMLDocument();
		$this->_xml->addElement( 'xmlarchive', '', (array)$this->_defaultRootValues );
		$this->_xml->addElement( 'fileset', 'xmlarchive' );
		
		foreach( $this->_fileArray as $f )
		{
			$f['content'] = chunk_split(base64_encode($f['content']));
			
			$this->_xml->addElementAsRecord( 'fileset', 'file', $f );
		}
	}
	
	/**
	 * Write contents of a file to disk
	 * Creates directories, etc as it goes
	 *
	 * @param	string		Path with filename to write to
	 * @param	string		Data to write
	 * @return	@e boolean
	 */
	protected function _writeContents( $path, $content )
	{
		$path      = $this->_stripPath( $path );
		$_path     = DOC_IPS_ROOT_PATH;
		$_dirParts = explode( '/', str_replace( DOC_IPS_ROOT_PATH, '', $path ) );
		$file      = array_pop( $_dirParts );

		foreach( $_dirParts as $_p )
		{
			$_path .= '/' . $_p;
			
			if ( ! is_dir( $_path ) )
			{
				if ( ! @mkdir( $_path, IPS_FOLDER_PERMISSION ) )
				{
					return FALSE;
				}
				else
				{
					@chmod( $_path, IPS_FOLDER_PERMISSION );
				}
			}
		}
		
		if ( ! @file_put_contents( $_path . '/' . $file, $content ) )
		{
			return FALSE;
		}
		
		@chmod( $_path . '/' . $file, IPS_FILE_PERMISSION );
		
		return TRUE;
	}
	
	/**
	 * Strip path information from the real path
	 *
	 * @param	string		Input path
	 * @return	@e string
	 */
	protected function _stripPath( $path )
	{
		if ( $this->_stripPathString )
		{
			$path = trim( str_ireplace( $this->_stripPathString, '', $path ), '/' );
		}
	
		return $path;
	}
	
	/**
	 * Get directory contents
	 *
	 * @param	string		Directory
	 * @return	@e boolean
	 */
	protected function _getDirContents( $dir )
	{
		if ( file_exists( $dir ) AND is_dir( $dir ) )
		{
			try
			{
				foreach( new DirectoryIterator( $dir ) as $file )
				{
					if ( ! $file->isDot() )
					{
						$filename = $file->getFileName();
            	
						/* Allow files? */
						if ( $this->_allowHiddenFiles !== TRUE )
						{
							if ( substr( $filename, 0, 1 ) == '.' )
							{
								continue;
							}
						}
            	
						if ( is_dir( $dir."/".$filename ) )
						{
							$this->_getDirContents( $dir . "/" . $filename );
						}
						else
						{
							$this->_workFiles[] = $dir . "/" . $filename;
						}
					}
				}
			} catch ( Exception $e ) {}
				
			return true;
		}
		else
		{
			throw new Exception( "FILE_OR_DIR_NOT_EXISTS" );
			return false;
		}
	}
}
