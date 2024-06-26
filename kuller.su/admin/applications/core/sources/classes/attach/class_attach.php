<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Attachments
 * Last Updated: $Date: 2012-10-22 06:00:45 -0400 (Mon, 22 Oct 2012) $
 * </pre>
 *
 * <code>
 * Possible Error strings:
 * - upload_no_file		 (No file was selected to upload)
 * - upload_failed        (Upload failed for unspecified reason)
 * - upload_too_big       (Upload is bigger than space left)
 * - invalid_mime_type    (Upload is not allowed)
 * - no_upload_dir        (Upload dir is not installed)
 * - no_upload_dir_perms  (Upload dir is not writeable)
 * </code>
 *
 * @author 		$Author: mmecham $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage  Core 
 * @link		http://www.invisionpower.com
 * @version		$Rev: 11498 $
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

class class_attach
{
	/**
	 * Global html class
	 *
	 * @var		object
	 */
	public $html;
	
	/**
	 * Type of attachment
	 *
	 * @var		string
	 */
	public $type    = '';
	
	/**
	 * Plugin Class
	 *
	 * @var		object
	 */
	public $plugin  = '';
	
	/**
	 * Post key
	 *
	 * @var		string
	 */
	public $attach_post_key		= '';
	
	/**
	 * Relationship ID
	 *
	 * @var		integer
	 */
	public $attach_rel_id		= 0;
	
	/**
	 * Relationship parent ID
	 *
	 * @var		int
	 */
	public $attach_parent_id	= 0;
	
	/**
	 * Return variables
	 *
	 * @var		array 	[ 'allow_uploads', 'space_allowed', 'space_allowed_human', 'space_used', 'space_used_human', 'space_left', 'space_left_human' ]
	 */
	public $attach_stats = array();
	
	/**
	 * Lang array
	 * Internal language array
	 *
	 * @var		array
	 */
	public $language    = array( 'unlimited'   => 'Неограничено',
	 						  'not_allowed' => 'Загружать файлы запрещено' );
	
	/**
	 * Error array
	 *
	 * @var		string
	 */
	public $error = "";
	
	/**
	 * Full upload path
	 *
	 * @var		string
	 */
	public $upload_path = '';
	
	/**
	 * Upload part part (from /uploads)
	 *
	 * @var		string
	 */
	public $upload_dir  = '';
	
	/**
	 * Extra upload form url
	 *
	 * @var		string
	 */
	public $extra_upload_form_url = '';
	
	/**
	 * Custom settings
	 *
	 * @var		array
	 */
	public $attach_settings = array( 
									'siu_thumb'                 => 0,
									'siu_height'                => 0,
									'siu_width'                 => 0,
									'allow_monthly_upload_dirs' => 0,
									'upload_dir'                => '' 
								);

	/**#@+
	 * Registry Object Shortcuts
	 *
	 * @var		object
	 */
	protected $registry;
	protected $DB;
	protected $settings;
	protected $request;
	protected $lang;
	protected $member;
	protected $memberData;
	/**#@-*/

	/**
	 * CONSTRUCTOR
	 *
	 * @param	object		ipsRegistry reference
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry )
	{
		/* Make object */
		$this->registry   = $registry;
		$this->DB         = $this->registry->DB();
		$this->settings   =& $this->registry->fetchSettings();
		$this->request    =& $this->registry->fetchRequest();
		$this->lang       = $this->registry->getClass('class_localization');
		$this->member     = $this->registry->member();
		$this->memberData =& $this->registry->member()->fetchMemberData();
	}

	/**
	 * Initiates class
	 *
	 * @return	@e void
	 */
	public function init()
	{
		//-----------------------------------------
		// Start the settings
		//-----------------------------------------
		
		$this->attach_settings['siu_thumb'] 				= $this->settings['siu_thumb'];
		$this->attach_settings['siu_height'] 				= $this->settings['siu_height'];
		$this->attach_settings['siu_width'] 				= $this->settings['siu_width'];
		$this->attach_settings['allow_monthly_upload_dirs'] = @ini_get("safe_mode") ? 0 : ( $this->settings['safe_mode_skins'] ? 0 : 1 );
		$this->attach_settings['upload_dir'] 				= $this->settings['upload_dir'];
		
		//-----------------------------------------
		// Load plug in
		//-----------------------------------------
		
		if ( $this->type )
		{
			$this->loadAttachmentPlugin();
		}
		
		//-----------------------------------------
		// Finalize the settings
		//-----------------------------------------
		
		foreach( $this->attach_settings as $item => $value )
		{
			$this->attach_settings[ $item ] = ( isset( $this->plugin->mysettings[ $item ] ) ) ? $this->plugin->mysettings[ $item ] : $value;
		}

		//-----------------------------------------
		// Fix up URL tokens
		//-----------------------------------------
		
		foreach( $_GET as $k => $v )
		{
			if ( preg_match( "#^--ff--#", $k ) )
			{
			 	$this->request[ str_replace( '--ff--', '', $k ) ] = $v;
			}
		}
		
		//-----------------------------------------
		// Sort out upload dir
		//-----------------------------------------
		
		$this->upload_path  = $this->attach_settings['upload_dir'];

		$this->_upload_path = $this->upload_path;
	}
	
	/**
	 * Show the attachment (or force download)
	 *
	 * @param	int		Attachment ID (The main attach id)
	 * @return	@e void
	 */
	public function showAttachment( $attach_id )
	{
		/* INIT */
		$sql_data = array();
		
		/* Get attach data... */
		$attachment = $this->DB->buildAndFetch( array( 'select' => '*', 'from' => 'attachments', 'where' => 'attach_id='.intval( $attach_id ) ) );
															
		if( ! $attachment['attach_id'] )
		{
			$this->registry->getClass('output')->showError( 'attach_no_attachment', 10170, false, null, 404 );
		}
	
		/* Load correct plug in... */
		$this->type = $attachment['attach_rel_module'];
		$this->loadAttachmentPlugin();
		
		/* Get SQL data from plugin */
		$attach = $this->plugin->getAttachmentData( $attach_id );
		
		/* Got a reply? */
		if( $attach === FALSE OR ! is_array( $attach ) )
		{
			$this->registry->getClass('output')->showError( 'no_permission_to_download', 10171, null, null, 403 );
		}
		
		/* Got a rel id? */
		if( ! $attach['attach_rel_id'] AND $attach['attach_member_id'] != $this->memberData['member_id'] )
		{
			$this->registry->getClass('output')->showError( 'err_attach_not_attached', 10172, null, null, 403 );
		}
		
		//-----------------------------------------
		// Reset timeout for large attachments
		//-----------------------------------------
		
		if ( @function_exists("set_time_limit") == 1 and SAFE_MODE_ON == 0 )
		{
			@set_time_limit( 0 );
		}
		
		if( is_array( $attach ) AND count( $attach ) )
		{
			/* Got attachment types? */
			if ( ! is_array( $this->registry->cache()->getCache('attachtypes') ) )
			{
				$attachtypes = array();

				$this->DB->build( array( 'select' => 'atype_extension,atype_mimetype', 'from' => 'attachments_type' ) );
				$this->DB->execute();

				while( $r = $this->DB->fetch() )
				{
					$attachtypes[ $r['atype_extension'] ] = $r;
				}
				
				$this->registry->cache()->updateCacheWithoutSaving( 'attachtypes', $attachtypes );
			}

			/* Show attachment */
			$attach_cache       = $this->registry->cache()->getCache('attachtypes');
			$this->_upload_path = ( isset( $this->plugin->mysettings[ 'upload_dir' ] ) ) ? $this->plugin->mysettings[ 'upload_dir' ] : $this->attach_settings[ 'upload_dir' ];

	        $file = $this->_upload_path . "/" . $attach['attach_location'];

			if( is_file( $file ) and ( $attach_cache[ $attach['attach_ext'] ]['atype_mimetype'] != "" ) )
			{
				/* Update the "hits".. */
				$this->DB->buildAndFetch( array( 'update' => 'attachments', 'set' => "attach_hits=attach_hits+1", 'where' => "attach_id={$attach_id}" ) );
				
				/* Open and display the file.. */
				header( "Content-Type: {$attach_cache[ $attach['attach_ext'] ]['atype_mimetype']}" );
				
				$disposition	= $attach['attach_is_image'] ? "inline" : "attachment";
				
				if( in_array( $this->memberData['userAgentKey'], array( 'firefox', 'opera' ) ) )
				{
					@header( 'Content-Disposition: ' . $disposition . "; filename*={$this->settings['gb_char_set']}''" . rawurlencode( IPSText::UNhtmlspecialchars( $attach['attach_file'] ) ) );
				}
				else if( in_array( $this->memberData['userAgentKey'], array( 'explorer' ) ) )
				{
					@header( 'Content-Disposition: ' . $disposition . '; filename="' . rawurlencode( IPSText::UNhtmlspecialchars( $attach['attach_file'] ) ) . '"' );
				}
				else
				{
					@header( 'Content-Disposition: ' . $disposition . '; filename="' . IPSText::UNhtmlspecialchars( $attach['attach_file'] ) . '"' );
				}
				
				if( ( !ini_get('zlib.output_compression') OR ini_get('zlib.output_compression') == 'off' ) AND ini_get('output_handler') != 'ob_gzhandler' )
				{
					header( 'Content-Length: ' . (string) ( filesize( $file ) ) );
				}

				/**
				 * @link	http://community.invisionpower.com/tracker/issue-22011-wrong-way-to-handle-attachments-transfer/
				 */
				if ( function_exists('ob_end_clean') AND ini_get('output_handler') != 'ob_gzhandler' )
				{
					@ob_end_clean();
				}
				
				if( function_exists('readfile') )
				{
					readfile( $file );
				}
				else
				{
					if( $fh = fopen( $file, 'rb' ) )
					{
						while( ! feof( $fh ) )
						{
							echo fread( $fh, 4096 );

							if ( function_exists('ob_get_length') AND function_exists('ob_flush') AND @ob_get_length() )
							{
								@ob_flush();
							}
							else
							{
								@flush();
							}
						}

						@fclose( $fh );
					}
				}

				exit();
			}
			else
			{
				/* File does not exist.. */
				$this->registry->getClass('output')->showError( 'attach_file_missing', 10173 );
			}
		}
		else
		{
			/*  No permission? */
			$this->registry->getClass('output')->showError( 'no_permission_to_download', 10174, null, null, 403 );
		}
	}

	/**
	 * Retrieve the HTML for a single attachment
	 *
	 * @param	mixed 	Array of attachment data, or an attachment ID
	 * @param	string	Skin group to use
	 * @param	bool	Whether to wrap with the attachment block wrapper or not
	 * @return	string	Attachment HTML
	 */
	public function renderSingleAttachment( $attachment, $skin_name='topic', $use_wrapper=false )
	{
		if( is_int($attachment) )
		{
			$row	= $this->DB->buildAndFetch( array( 'select' => '*', 'from' => 'attachments', 'where' => 'attach_id=' . intval($attachment) ) );
		}
		else
		{
			$row	= $attachment;
		}
		
		if( !$row['attach_id'] )
		{
			return '';
		}
		
		$attachtypes	= $this->getAttachTypes();
		$type			= '';

		//-----------------------------------------
		// Is it an image, and are we viewing the image in the post?
		//-----------------------------------------
		
		if ( $this->settings['show_img_upload'] and $row['attach_is_image'] )
		{
			if ( $this->attach_settings['siu_thumb'] AND $row['attach_thumb_location'] AND $row['attach_thumb_width'] )
			{
				//-----------------------------------------
				// Make sure we've not seen this ID
				//-----------------------------------------
				
				$row['_attach_id'] = $row['attach_id'] . '-' . str_replace( array( '.', ' ' ), "-", microtime() );

				$type	= 'thumb';
				$tmp	= $this->registry->getClass('output')->getTemplate( $skin_name )->Show_attachments_img_thumb( array(
																															't_location'	=> $row['attach_thumb_location'],
																															't_width'		=> $row['attach_thumb_width'],
																															't_height'		=> $row['attach_thumb_height'],
																															'o_width'		=> $row['attach_img_width'],
																															'o_height'		=> $row['attach_img_height'],
																															'attach_id'		=> $row['attach_id'],
																															'_attach_id'	=> $row['_attach_id'],
																															'file_size'		=> IPSLib::sizeFormat( $row['attach_filesize'] ),
																															'attach_hits'	=> $row['attach_hits'],
																															'location'		=> $row['attach_file'],
																															'type'			=> $this->type,
																															'notinline'		=> 1,
																															'attach_rel_id'	=> $row['attach_rel_id']
																					)		);
			}
			else
			{
				//-----------------------------------------
				// Standard size..
				//-----------------------------------------
				
				$type	= 'image';
				$tmp	= $this->registry->getClass('output')->getTemplate( $skin_name )->Show_attachments_img( array(
																															'o_location'  => $row['attach_location'],
																															'o_width'		=> $row['attach_img_width'],
																															'o_height'		=> $row['attach_img_height'],
																															'attach_id'		=> $row['attach_id'],
																															'_attach_id'	=> $row['_attach_id'],
																															'file_size'		=> IPSLib::sizeFormat( $row['attach_filesize'] ),
																															'attach_hits'	=> $row['attach_hits'],
																															'location'		=> $row['attach_file'],
																															'type'			=> $this->type,
																															'notinline'		=> 1,
																															'attach_rel_id'	=> $row['attach_rel_id']
																					)	);
			}
		}
		else
		{
			//-----------------------------------------
			// Full attachment thingy
			//-----------------------------------------

			$type	= 'attach';
			$tmp	= $this->registry->getClass('output')->getTemplate( $skin_name )->Show_attachments( array (
																								'attach_hits'	=> $row['attach_hits'],
																								'mime_image'	=> $attachtypes[ $row['attach_ext'] ]['atype_img'],
																								'attach_file'	=> $row['attach_file'],
																								'attach_id'		=> $row['attach_id'],
																								'type'			=> $this->type,
																								'file_size'		=> IPSLib::sizeFormat( $row['attach_filesize'] ),
																					)		);
		}

		//-----------------------------------------
		// Wrap?
		//-----------------------------------------
		
		if ( $use_wrapper )
		{
			switch( $type )
			{
				case 'thumb':
					$tmp	= $this->registry->getClass('output')->getTemplate( $skin_name )->show_attachment_title( $this->lang->words['attach_thumbs'], $tmp, 'thumb' );
				break;
				
				case 'image':
					$tmp	= $this->registry->getClass('output')->getTemplate( $skin_name )->show_attachment_title( $this->lang->words['attach_images'], $tmp, 'image' );
				break;
				
				default:
				case 'attach':
					$tmp	= $this->registry->getClass('output')->getTemplate( $skin_name )->show_attachment_title( $this->lang->words['attach_normal'], $tmp, 'attach' );
				break;
			}
		}

		return $tmp;
	}
	
	/**
	 * Retrieve attachment types from cache
	 *
	 * @return	@e array
	 */
	protected function getAttachTypes()
	{
		//-----------------------------------------
		// Got attachment types?
		//-----------------------------------------

		if ( ! is_array( $this->registry->cache()->getCache('attachtypes') ) )
		{
			$attachtypes = array();
			
			$this->DB->build( array( 'select' => 'atype_extension,atype_mimetype,atype_img', 'from' => 'attachments_type' ) );
			$outer = $this->DB->execute();

			while ( $r = $this->DB->fetch( $outer ) )
			{
				$attachtypes[ $r['atype_extension'] ] = $r;
			}
			
			$this->registry->cache()->updateCacheWithoutSaving( 'attachtypes', $attachtypes );
		}
		else
		{
			$attachtypes	= $this->registry->cache()->getCache('attachtypes');
		}
		
		return $attachtypes;
	}

	/**
	 * Swaps the HTML for the nice attachments.
	 *
	 * @param	array 	Array of HTML blocks to convert: [ rel_id => $html ]
	 * @param	array 	Relationship ids
	 * @param	string	Skin group to use
	 * @return	array 	Array of converted HTML blocks and attach code: [ id => $html ]
	 */
	public function renderAttachments( $htmlArray, $rel_ids=array(), $skin_name='topic' )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$attach_ids              = array();
		$map_attach_id_to_rel_id = array();
		$final_out               = array();
		$final_blocks            = array();
		$returnArray			 = array();
		$_seen                   = 0;
		
		//-----------------------------------------
		// Check..
		//-----------------------------------------
		
		if ( ! is_array( $htmlArray ) )
		{
			$htmlArray = array( 0 => $htmlArray );
		}
		
		//-----------------------------------------
		// Rel ids
		//-----------------------------------------
		
		if ( ! is_array( $rel_ids ) OR ! count( $rel_ids ) )
		{
			$rel_ids = array_keys( $htmlArray );
		}
		
		//-----------------------------------------
		// Parse HTML blocks for attach ids
		// [attachment=32:attachFail.gif]
		//-----------------------------------------

		foreach( $htmlArray as $id => $html )
		{
			$returnArray[ $id ] = array( 'html' => $html, 'attachmentHtml' => '' );

			preg_match_all( '#\[attachment=(\d+?)\:(?:[^\]]+?)\]#is', $html, $match );
			
			if ( is_array( $match[0] ) and count( $match[0] ) )
			{
				for ( $i = 0 ; $i < count( $match[0] ) ; $i++ )
				{
					if ( intval($match[1][$i]) == $match[1][$i] )
					{
						$attach_ids[ $match[1][$i] ]                = $match[1][$i];
						$map_attach_id_to_rel_id[ $match[1][$i] ][] = $id;
					}
				}
			}
		}
		
		//-----------------------------------------
		// Get data from the plug in
		//-----------------------------------------
		
		$rows = $this->plugin->renderAttachment( $attach_ids, $rel_ids, $this->attach_post_key );
				
		//-----------------------------------------
		// Got anything?
		//-----------------------------------------
		
		if ( is_array( $rows ) AND count( $rows ) )
		{
			$attachtypes	= $this->getAttachTypes();

			foreach( $rows as $_attach_id => $row )
			{
				//-----------------------------------------
				// INIT
				//-----------------------------------------
				
				$row = $rows[ $_attach_id ];
				
				/* Make older attachments safe */
				$row['attach_file'] = str_replace( '<', '&lt;', $row['attach_file'] );
				$row['attach_file'] = str_replace( '>', '&gt;', $row['attach_file'] );
				
				/* this is now done at upload */
				//$row['attach_file'] = htmlspecialchars( $row['attach_file'] );
				
				$this->attach_rel_id = $row['attach_rel_id'];
				
				if ( ! isset( $final_blocks[ $row['attach_rel_id'] ] ) )
				{
					$final_blocks[ $row['attach_rel_id'] ] = array( 'attach' => '', 'thumb' => '', 'image' => '' );
				}
				
				//-----------------------------------------
				// Is it an image, and are we viewing the image in the post?
				//-----------------------------------------
				
				if ( $this->settings['show_img_upload'] and $row['attach_is_image'] )
				{
					if ( $this->attach_settings['siu_thumb'] AND $row['attach_thumb_location'] AND $row['attach_thumb_width'] )
					{
						//-----------------------------------------
						// Make sure we've not seen this ID
						//-----------------------------------------
						
						$row['_attach_id'] = $row['attach_id'] . '-' . str_replace( array( '.', ' ' ), "-", microtime() );

						$tmp = $this->registry->getClass('output')->getTemplate( $skin_name )->Show_attachments_img_thumb( array( 't_location'  => $row['attach_thumb_location'],
																														  		  't_width'     => $row['attach_thumb_width'],
																														  		  't_height'    => $row['attach_thumb_height'],
																														          'o_width'     => $row['attach_img_width'],
																														  		  'o_height'    => $row['attach_img_height'],
																														  	      'attach_id'   => $row['attach_id'],
																																  '_attach_id'  => $row['_attach_id'],
																														    	  'file_size'   => IPSLib::sizeFormat( $row['attach_filesize'] ),
																														  		  'attach_hits' => $row['attach_hits'],
																														  		  'location'    => $row['attach_file'],
																																  'type'        => $this->type,
																																  'a_location'  => $row['attach_location'],
																																  'attach_rel_id' => $row['attach_rel_id'] )	);

						//-----------------------------------------
						// Convert HTML
						//-----------------------------------------
						
						if ( isset($map_attach_id_to_rel_id[ $_attach_id ]) AND is_array( $map_attach_id_to_rel_id[ $_attach_id ] ) AND count( $map_attach_id_to_rel_id[ $_attach_id ] ) )
						{
							foreach( $map_attach_id_to_rel_id[ $_attach_id ] as $idx => $_rel_id )
							{
								$_count = substr_count( $htmlArray[ $_rel_id ], '[attachment='.$row['attach_id'].':' );
						
								if ( $_count > 1 )
								{
									# More than 1 of the same thumbnail to show?
									$this->_current = array( 'type'      => $this->type,
															 'row'       => $row,
															 'skin_name' => $skin_name );
							
									$returnArray[ $_rel_id ]['html'] = preg_replace_callback( '#\[attachment='.$row['attach_id'].'\:(?:[^\]]+?)[\n|\]]#is', array( &$this, '_parseThumbnailInline' ), $returnArray[ $_rel_id ]['html'] );
								}
								else if ( $_count )
								{
									# Just the one, then?
									$returnArray[ $_rel_id ]['html'] = preg_replace( '#\[attachment='.$row['attach_id'].'\:(?:[^\]]+?)[\n|\]]#is', $tmp, $returnArray[ $_rel_id ]['html'] );
								}
								else
								{
									$final_blocks[ $_rel_id ]['thumb'][] = $tmp;
								}
							}
						}
						else
						{
							$final_blocks[ $row['attach_rel_id'] ]['thumb'][] = $tmp;
						}
					}
					else
					{
						//-----------------------------------------
						// Standard size..
						//-----------------------------------------
						
						$tmp = $this->registry->getClass('output')->getTemplate( $skin_name )->Show_attachments_img( array( 'o_location'    => $row['attach_location'],
																															'o_width'		=> $row['attach_img_width'],
																															'o_height'		=> $row['attach_img_height'],
																															'attach_id'		=> $row['attach_id'],
																															'_attach_id'	=> $row['_attach_id'],
																															'file_size'		=> IPSLib::sizeFormat( $row['attach_filesize'] ),
																															'attach_hits'	=> $row['attach_hits'],
																															'location'		=> $row['attach_file'],
																															'type'			=> $this->type,
																															'notinline'		=> 1,
																															'a_location'    => $row['attach_location'],
																															'attach_rel_id'	=> $row['attach_rel_id'] ) );
						
						if ( is_array( $map_attach_id_to_rel_id[ $_attach_id ] ) AND count( $map_attach_id_to_rel_id[ $_attach_id ] ) )
						{
							foreach( $map_attach_id_to_rel_id[ $_attach_id ] as $idx => $_rel_id )
							{
								if ( strstr( $htmlArray[ $_rel_id ], '[attachment='.$row['attach_id'].':' ) )
								{
									$returnArray[ $_rel_id ]['html'] = preg_replace( '#\[attachment='.$row['attach_id'].'\:(?:[^\]]+?)[\n|\]]#is', $tmp, $returnArray[ $_rel_id ]['html'] );
								}
								else
								{
									$final_blocks[ $_rel_id ]['image'][] = $tmp;
								}
							}
						}
						else
						{
							$final_blocks[ $row['attach_rel_id'] ]['image'][] = $tmp;
						}
					}
				}
				else
				{
					//-----------------------------------------
					// Full attachment thingy
					//-----------------------------------------
				
					$attach_cache = $this->registry->cache()->getCache('attachtypes');
					
					$tmp = $this->registry->getClass('output')->getTemplate( $skin_name )->Show_attachments( array (
																										'attach_hits'  => $row['attach_hits'],
																										'mime_image'   => $attach_cache[ $row['attach_ext'] ]['atype_img'],
																										'attach_file'  => $row['attach_file'],
																										'attach_id'    => $row['attach_id'],
																										'type'         => $this->type,
																										'file_size'    => IPSLib::sizeFormat( $row['attach_filesize'] ),
																							  )  	  );
					if ( is_array( $map_attach_id_to_rel_id[ $_attach_id ] ) AND count( $map_attach_id_to_rel_id[ $_attach_id ] ) )
					{
						foreach( $map_attach_id_to_rel_id[ $_attach_id ] as $idx => $_rel_id )
						{
							if ( strstr( $htmlArray[ $_rel_id ], '[attachment='.$row['attach_id'].':' ) )
							{
								$returnArray[ $_rel_id ]['html'] = preg_replace( '#\[attachment='.$row['attach_id'].'\:(?:[^\]]+?)[\n|\]]#is', $tmp, $returnArray[ $_rel_id ]['html'] );
							}
							else
							{
								$final_blocks[ $_rel_id ]['attach'][] = $tmp;
							}
						}
					}
					else
					{
						$final_blocks[ $row['attach_rel_id'] ]['attach'][] = $tmp;
					}
				}
			}
			
			//-----------------------------------------
			// Anthing to add?
			//-----------------------------------------
			
			if ( count( $final_blocks ) )
			{
				foreach( $final_blocks as $rel_id => $type )
				{
					$temp_out = "";

					if ( $final_blocks[ $rel_id ]['thumb'] )
					{
						$temp_out .= $this->registry->getClass('output')->getTemplate( $skin_name )->show_attachment_title( $this->lang->words['attach_thumbs'], $final_blocks[ $rel_id ]['thumb'], 'thumb' );
					}

					if ( $final_blocks[ $rel_id ]['image'] )
					{
						$temp_out .= $this->registry->getClass('output')->getTemplate( $skin_name )->show_attachment_title( $this->lang->words['attach_images'], $final_blocks[ $rel_id ]['image'], 'image' );
					}

					if ( $final_blocks[ $rel_id ]['attach'] )
					{
						$temp_out .= $this->registry->getClass('output')->getTemplate( $skin_name )->show_attachment_title( $this->lang->words['attach_normal'], $final_blocks[ $rel_id ]['attach'], 'attach' );
					}
		
					if ( $temp_out )
					{
						$returnArray[ $rel_id ]['attachmentHtml'] = $temp_out;
					}
				}
			}
		}

		return $returnArray;
	}
	
	/**
	 * Archive attachments
	 * Currently this just flags them as archived. It does not physically move the files as
	 * this seems a bit pointless as they have to stay in the file system anyway
	 * 
	 * @param array $archiveIds
	 * @param string $idType
	 */
	public function bulkArchive( $archiveIds=array(), $idType='attach_rel_id' )
	{
		/* Make sure we have some ids */
		if ( ! is_array( $archiveIds ) or ! count( $archiveIds ) )
		{
			return FALSE;
		}
		
		/* Update */
		$this->DB->update( 'attachments', array( 'attach_is_archived' => 1 ), $idType . ' IN (' . implode( ',', $archiveIds ) . ") AND attach_rel_module='" . $this->type . "'" );
	}
	
	/**
	 * Unarchive attachments
	 * Currently this just flags them as unarchived. It does not physically move the files as
	 * this seems a bit pointless as they have to stay in the file system anyway
	 * 
	 * @param array $archiveIds
	 * @param string $idType
	 */
	public function bulkUnarchive( $archiveIds=array(), $idType='attach_rel_id' )
	{
		/* Make sure we have some ids */
		if ( ! is_array( $archiveIds ) or ! count( $archiveIds ) )
		{
			return FALSE;
		}
		
		/* Update */
		$this->DB->update( 'attachments', array( 'attach_is_archived' => 0 ), $idType . ' IN (' . implode( ',', $archiveIds ) . ") AND attach_rel_module='" . $this->type . "'" );
	}
	
	/**
	 * Removes attachment(s)
	 *
	 * @param	array	$remove_ids	Array of attachment ids to remove
	 * @param	string	$id_type	Column to use when deleting, attach_rel_id by default
	 * @return	bool
	 */
	public function bulkRemoveAttachment( $remove_ids=array(), $id_type='attach_rel_id' )
	{
		/* INIT */
		$attachments = array();
		
		/* Make sure we have some ids */
		if ( ! is_array( $remove_ids ) or ! count( $remove_ids ) )
		{
			return FALSE;
		}
		
		/* Check Permissions */
		if( $this->plugin->canBulkRemove( $remove_ids ) === TRUE )
		{
			/* Grab the attachments */
			$this->DB->build( array( 
									'select' => '*', 
									'from'   => 'attachments', 
									'where'  => $id_type . ' IN (' . implode( ',', $remove_ids ) . ") AND attach_rel_module='{$this->type}'"
						)	);
			
			$this->DB->execute();
			
			while( $_row = $this->DB->fetch() )
			{
				$attachments[ $_row['attach_id'] ] = $_row;
			}
			
			/* Loop through and delete them from the filesystem */
			foreach( $attachments as $attach_id => $attachment )
			{
				if ( $attachment['attach_location'] )
				{
					@unlink( $this->_upload_path."/".$attachment['attach_location'] );
				}
				if ( $attachment['attach_thumb_location'] )
				{
					@unlink( $this->_upload_path."/".$attachment['attach_thumb_location'] );
				}
			
				/* Allow the module to clean up any items */										
				$this->plugin->attachmentRemovalCleanup( $attachment );
			}
			
			/* Remove from the DB */
			$this->DB->delete( 'attachments', $id_type . ' IN (' . implode( ',', $remove_ids ) . ") AND attach_rel_module='{$this->type}'" );
			
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	
	/**
	 * Removes an attachment.
	 *
	 * @return	@e void
	 */
	public function removeAttachment()
	{
		//-----------------------------------------
		// Got an ID?
		//-----------------------------------------
		
		if ( ! $this->attach_id )
		{
			return FALSE;
		}
		
		//-----------------------------------------
		// Get DB row
		//-----------------------------------------
		
		$attachment = $this->DB->buildAndFetch( array( 'select' => '*',
																		'from'   => 'attachments',
																		'where'  => 'attach_id='.$this->attach_id." AND attach_rel_module='".$this->type."'" ) );
																		
		if ( ! $attachment['attach_id'] )
		{
			return FALSE;
		}
		
		//-----------------------------------------
		// Make sure we've got permission
		//-----------------------------------------
		
		if ( $this->plugin->canRemove( $attachment ) === TRUE )
		{
			//-----------------------------------------
			// Remove from the DB
			//-----------------------------------------
			
			$this->DB->delete( 'attachments', 'attach_id='.$attachment['attach_id'] );
			
			//-----------------------------------------
			// Remove from the filesystem
			//-----------------------------------------
			
			if ( $attachment['attach_location'] )
			{
				@unlink( $this->_upload_path."/".$attachment['attach_location'] );
			}
			if ( $attachment['attach_thumb_location'] )
			{
				@unlink( $this->_upload_path."/".$attachment['attach_thumb_location'] );
			}
			
			//-----------------------------------------
			// Allow the module to clean up any items
			//-----------------------------------------
															
			$this->plugin->attachmentRemovalCleanup( $attachment );
			
			return TRUE;
		}
		else
		{
			return FALSE;
		}
	}
	
	/**
	 * Converts post-key attachments into rel_id / rel_module attachments
	 * by adding in the correct ID, etc
	 *
	 * @param	array	$args
	 * @return	array
	 */
	public function postProcessUpload( $args=array() )
	{
		if( ! $this->attach_post_key or ! $this->attach_rel_id )
		{
			return FALSE;
		}

		//-----------------------------------------
		// Got any to update?
		//-----------------------------------------
		
		$this->DB->update( 'attachments', array(	'attach_rel_id'		=> $this->attach_rel_id,
													'attach_parent_id'	=> intval($this->attach_parent_id),
			  										'attach_rel_module'	=> $this->type ), "attach_post_key='{$this->attach_post_key}'" );
			
		//-----------------------------------------
		// Update module specific?
		//-----------------------------------------
		
		return $this->plugin->postUploadProcess( $this->attach_post_key, $this->attach_rel_id, $args );
	}
	
	/**
	 * Uploads and saves file
	 *
	 * @return	mixed	void, or the new insert id
	 */
	public function processUpload()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$this->error = '';
		
		$this->getUploadFormSettings();
		
		//-----------------------------------------
		// Check upload dir
		//-----------------------------------------
		
		if ( ! $this->checkUploadDirectory() )
		{
			if ( $this->error )
			{
				return;
			}
		}

		//-----------------------------------------
		// Can upload?
		//-----------------------------------------
		
		if ( ! $this->attach_stats['allow_uploads'] )
		{
			$this->error = 'upload_failed';
			return;
		}

		//-----------------------------------------
		// Got attachment types?
		//-----------------------------------------
		
		if ( ! ( $this->registry->cache()->getCache('attachtypes') ) OR ! is_array( $this->registry->cache()->getCache('attachtypes') ) )
		{
			$attachtypes = array();

			$this->DB->build( array(
									'select'	=> 'atype_extension,atype_mimetype,atype_post,atype_img',
									'from'		=> 'attachments_type',
									'where'		=> "atype_post=1" 
								)	);
			$this->DB->execute();
	
			while ( $r = $this->DB->fetch() )
			{
				$attachtypes[ $r['atype_extension'] ] = $r;
			}
			
			$this->registry->cache()->updateCacheWithoutSaving( 'attachtypes', $attachtypes );
		}
		
		//-----------------------------------------
		// Set up array
		//-----------------------------------------
		
		$attach_data = array( 
							  'attach_ext'            => "",
							  'attach_file'           => "",
							  'attach_location'       => "",
							  'attach_thumb_location' => "",
							  'attach_hits'           => 0,
							  'attach_date'           => time(),
							  'attach_post_key'       => $this->attach_post_key,
							  'attach_member_id'      => $this->memberData['member_id'],
							  'attach_rel_id'         => $this->attach_rel_id,
							  'attach_rel_module'     => $this->type,
							  'attach_filesize'       => 0,
							);
		
		//-----------------------------------------
		// Load the library
		//-----------------------------------------
		
		require_once( IPS_KERNEL_PATH.'classUpload.php' );/*noLibHook*/
		$upload = new classUpload();
		
		//-----------------------------------------
		// Set up the variables
		//-----------------------------------------
		
		$upload->out_file_name    = $this->type . '-' . $this->memberData['member_id'] . '-' . str_replace( array( '.', ' ' ), '-', microtime() );
		$upload->out_file_dir     = $this->upload_path;
		$upload->max_file_size    = $this->attach_stats['max_single_upload'] ? $this->attach_stats['max_single_upload'] : 1000000000;
		$upload->make_script_safe = 1;
		$upload->force_data_ext   = 'ipb';
		
		//-----------------------------------------
		// Populate allowed extensions
		//-----------------------------------------

		if ( is_array( $this->registry->cache()->getCache('attachtypes') ) and count( $this->registry->cache()->getCache('attachtypes') ) )
		{
			/* SKINNOTE: I had to add [attachtypes] to this cache to make it work, may need fixing? */
			//$tmp = $this->registry->cache()->getCache('attachtypes');
			foreach( $this->registry->cache()->getCache('attachtypes') as $idx => $data )
			{
				if ( $data['atype_post'] )
				{
					$upload->allowed_file_ext[] = $data['atype_extension'];
				}
			}
		}
		
		//-----------------------------------------
		// Upload...
		//-----------------------------------------
		
		$upload->process();
		
		//-----------------------------------------
		// Error?
		//-----------------------------------------
		
		if ( $upload->error_no )
		{
			switch( $upload->error_no )
			{
				case 1:
					// No upload
					$this->error = 'upload_no_file';
					return $attach_data;
					break;
				case 2:
					// Invalid file ext
					$this->error = 'invalid_mime_type';
					return $attach_data;
					break;
				case 3:
					// Too big...
					$this->error = 'upload_too_big';
					return $attach_data;
					break;
				case 4:
					// Cannot move uploaded file
					$this->error = 'upload_failed';
					return $attach_data;
					break;
				case 5:
					// Possible XSS attack (image isn't an image)
					$this->error = 'upload_failed';
					return $attach_data;
					break;
			}
		}
					
		//-----------------------------------------
		// Still here?
		//-----------------------------------------

		if ( $upload->saved_upload_name and @is_file( $upload->saved_upload_name ) )
		{
			//-----------------------------------------
			// Strip off { } and [ ]
			//-----------------------------------------
			
			$upload->original_file_name = str_replace( array( '[', ']', '{', '}' ), "", $upload->original_file_name );
			
			$attach_data['attach_filesize']   = @filesize( $upload->saved_upload_name  );
			$attach_data['attach_location']   = $this->upload_dir . $upload->parsed_file_name;
			
			if( IPSText::isUTF8( $upload->original_file_name ) )
			{
				$attach_data['attach_file']       = IPSText::convertCharsets( $upload->original_file_name, "UTF-8", IPS_DOC_CHAR_SET );
			}
			else
			{
				$attach_data['attach_file']       = $upload->original_file_name;
			}
			
			$attach_data['attach_is_image']   = $upload->is_image;
			$attach_data['attach_ext']        = $upload->real_file_extension;
			
			if ( $attach_data['attach_is_image'] == 1 )
			{
				require_once( IPS_KERNEL_PATH . 'classImage.php' );/*noLibHook*/
				require_once( IPS_KERNEL_PATH . 'classImageGd.php' );/*noLibHook*/
				
				/* Main attachment */
				if ( ! empty( $this->settings['attach_img_max_w'] ) AND ! empty( $this->settings['attach_img_max_h'] ) )
				{
					$image = new classImageGd();
					
					$image->init( array( 'image_path' => $this->upload_path, 
				                         'image_file' => $upload->parsed_file_name ) );
    				
					$image->force_resize	= false;
					
					if ( $imgData = $image->resizeImage( $this->settings['attach_img_max_w'], $this->settings['attach_img_max_h'], false, true ) )
					{
						if( !$imgData['noResize'] )
						{
							$image->writeImage( $this->upload_path . '/' . $upload->parsed_file_name );
						}
						
						if ( is_array( $imgData ) )
						{
							$attach_data['attach_img_width']  = $imgData['newWidth'];
							$attach_data['attach_img_height'] = $imgData['newHeight'];
						}
						
						$attach_data['attach_filesize']   = @filesize( $this->upload_path . '/' . $upload->parsed_file_name );
					}
				}
				
				/* Thumb nail */
				$image = new classImageGd();
				$image->force_resize = true;
				
				$image->init( array( 'image_path' => $this->upload_path, 
				                     'image_file' => $upload->parsed_file_name ) );
				
				if ( TRUE ) // $this->attach_settings['siu_thumb'] ) # bug report 36511
				{
					if( $this->attach_settings['siu_width'] < $attach_data['attach_img_width'] OR $this->attach_settings['siu_height'] < $attach_data['attach_img_height'] )
					{
						$_thumbName = preg_replace( '#^(.*)\.(\w+?)$#', "\\1_thumb.\\2", $upload->parsed_file_name );
						
						if( $thumb_data = $image->resizeImage( $this->attach_settings['siu_width'], $this->attach_settings['siu_height'] ) )
						{
							$image->writeImage( $this->upload_path . '/' . $_thumbName );
							
							if ( is_array( $thumb_data ) )
							{
								$thumb_data['thumb_location'] = $_thumbName;
							}
						}
					}
					else
					{
						/* Instead of building a thumb the same size as the main image, just copy the details */
						$thumb_data	= array(
											'thumb_location'	=> $upload->parsed_file_name,
											'newWidth'			=> $attach_data['attach_img_width'],
											'newHeight'			=> $attach_data['attach_img_height'],
											);
					}
				}
				
				if ( $thumb_data['thumb_location'] )
				{
					$attach_data['attach_img_width']      = $thumb_data['originalWidth'];
					$attach_data['attach_img_height']     = $thumb_data['originalHeight'];
					$attach_data['attach_thumb_width']    = $thumb_data['newWidth'];
					$attach_data['attach_thumb_height']   = $thumb_data['newHeight'];
					$attach_data['attach_thumb_location'] = $this->upload_dir . $thumb_data['thumb_location'];
				}			
			}
			
			//-----------------------------------------
			// Make sure we send integers
			// @link	http://community.invisionpower.com/tracker/issue-32511-attachments-mysql-strict-mode
			//-----------------------------------------
			
			$attach_data['attach_img_width']	= intval( $attach_data['attach_img_width'] );
			$attach_data['attach_img_height']	= intval( $attach_data['attach_img_height'] );
			$attach_data['attach_thumb_width']	= intval( $attach_data['attach_thumb_width'] );
			$attach_data['attach_thumb_height']	= intval( $attach_data['attach_thumb_height'] );
			
			//-----------------------------------------
			// Add into Database
			//-----------------------------------------
			
			$this->DB->insert( 'attachments', $attach_data );
			
			$newid = $this->DB->getInsertId();

			return $newid;
		}
	}
	
	/**
	 * Uploads and saves file
	 *
	 * @return	mixed	void, or an array of new insert ids
	 */
	public function processMultipleUploads()
	{
		/* INIT */
		$this->error = '';
		
		$this->getUploadFormSettings();
		
		/* Check the upload directory */
		if( ! $this->checkUploadDirectory() )
		{
			if( $this->error )
			{
				return;
			}
		}

		/* Can Upload */
		if ( ! $this->attach_stats['allow_uploads'] )
		{
			$this->error = 'upload_failed';
			return;
		}

		/* Setup Attachment Types */
		if( ! ( $this->registry->cache()->getCache('attachtypes') ) OR ! is_array( $this->registry->cache()->getCache('attachtypes') ) )
		{
			$attachtypes = array();

			$this->DB->build( array('select'	=> 'atype_extension,atype_mimetype,atype_post,atype_img',
									'from'		=> 'attachments_type',
									'where'		=> "atype_post=1" 
									)	 );
			$this->DB->execute();
	
			while( $r = $this->DB->fetch() )
			{
				$attachtypes[ $r['atype_extension'] ] = $r;
			}
			
			$this->registry->cache()->updateCacheWithoutSaving( 'attachtypes', $attachtypes );
		}
				
		/* Attachment Library */
		$classToLoad = IPSLib::loadLibrary( IPS_KERNEL_PATH . 'classUpload.php', 'classUpload' );
		$upload = new $classToLoad();
		
		/* Set up the library */
		$upload->out_file_dir     = $this->upload_path;
		$upload->max_file_size    = $this->attach_stats['max_single_upload'] ? $this->attach_stats['max_single_upload'] : 1000000000;
		$upload->make_script_safe = 1;
		$upload->force_data_ext   = 'ipb';
		
		/* Populate allowed extensions */
		if( is_array( $this->registry->cache()->getCache('attachtypes') ) and count( $this->registry->cache()->getCache('attachtypes') ) )
		{
			/* SKINNOTE: I had to add [attachtypes] to this cache to make it work, may need fixing? */
			//$tmp = $this->registry->cache()->getCache('attachtypes');
			foreach( $this->registry->cache()->getCache('attachtypes') as $idx => $data )
			{
				if( $data['atype_post'] )
				{
					$upload->allowed_file_ext[] = $data['atype_extension'];
				}
			}
		}
		
		/* Attempt to upload everything int he $_FILES array */
		$upload_results = array();
		
		if( isset( $_FILES ) && is_array( $_FILES ) && count( $_FILES ) )
		{
			foreach( $_FILES as $_field_name => $data )
			{
				if( ! $_FILES[ $_field_name ]['size'] )
				{
					continue;
				}
				
				/* Set File Name */
				$upload->out_file_name = $this->type . '-' . $this->memberData['member_id'] . '-' . time() % $_FILES[ $_field_name ]['size'];
				
				/* Set File Name */
				$upload->upload_form_field = $_field_name;
				
				/* Attachment Data Array */
				$attach_data = array( 
									  'attach_ext'            => "",
									  'attach_file'           => "",
									  'attach_location'       => "",
									  'attach_thumb_location' => "",
									  'attach_hits'           => 0,
									  'attach_date'           => time(),
									  'attach_post_key'       => $this->attach_post_key,
									  'attach_member_id'      => $this->memberData['member_id'],
									  'attach_rel_id'         => $this->attach_rel_id,
									  'attach_rel_module'     => $this->type,
									  'attach_filesize'       => 0,
									);			
				
				/* Upload... */
				$upload->process();
				
				/* Error Check */
				if( $upload->error_no )
				{
					switch( $upload->error_no )
					{
						case 1:
							// No upload
							$upload_results[ $_field_name ] = 'upload_no_file';
						break;
						
						case 2:
							// Invalid file ext
							$upload_results[ $_field_name ] = 'invalid_mime_type';
						break;
						
						case 3:
							// Too big...
							$upload_results[ $_field_name ] = 'upload_too_big';
						break;
						
						case 4:
							// Cannot move uploaded file
							$upload_results[ $_field_name ] = 'upload_failed';
						break;
						
						case 5:
							// Possible XSS attack (image isn't an image)
							$upload_results[ $_field_name ] = 'upload_failed';
						break;
					}
				}
				
				/* Still Here */
				if( $upload->saved_upload_name and @is_file( $upload->saved_upload_name ) )
				{
					/* Strip off { } and [ ] */
					$upload->original_file_name = str_replace( array( '[', ']', '{', '}' ), "", $upload->original_file_name );
					
					$attach_data['attach_filesize'] = @filesize( $upload->saved_upload_name  );
					$attach_data['attach_location'] = $this->upload_dir . $upload->parsed_file_name;
					$attach_data['attach_file']     = $upload->original_file_name;
					$attach_data['attach_is_image'] = $upload->is_image;
					$attach_data['attach_ext']      = $upload->real_file_extension;
					
					if ( $attach_data['attach_is_image'] == 1 )
					{
						require_once( IPS_KERNEL_PATH . 'classImage.php' );/*noLibHook*/
						require_once( IPS_KERNEL_PATH . 'classImageGd.php' );/*noLibHook*/
						
						/* Main attachment */
						if ( ! empty( $this->settings['attach_img_max_w'] ) AND ! empty( $this->settings['attach_img_max_h'] ) )
						{
							$image = new classImageGd();
							
							$image->init( array( 'image_path' => $this->upload_path, 
						                         'image_file' => $upload->parsed_file_name ) );
							
							if ( $imgData = $image->resizeImage( $this->settings['attach_img_max_w'], $this->settings['attach_img_max_h'] ) )
							{
								$image->writeImage( $this->upload_path . '/' . $upload->parsed_file_name );
								
								if ( is_array( $imgData ) )
								{
									$attach_data['attach_img_width']  = $imgData['newWidth'];
									$attach_data['attach_img_height'] = $imgData['newHeight'];
								}
							}
						}
						
						/* Thumb nail */
						$image = new classImageGd();
						$image->force_resize = true;
						
						$image->init( array( 'image_path' => $this->upload_path, 
						                     'image_file' => $upload->parsed_file_name ) );
						
						if ( $this->attach_settings['siu_thumb'] )
						{
							$_thumbName = preg_replace( '#^(.*)\.(\w+?)$#', "\\1_thumb.\\2", $upload->parsed_file_name );
							
							if( $thumb_data = $image->resizeImage( $this->attach_settings['siu_width'], $this->attach_settings['siu_height'] ) )
							{
								$image->writeImage( $this->upload_path . '/' . $_thumbName );
								
								if ( is_array( $thumb_data ) )
								{
									$thumb_data['thumb_location'] = $_thumbName;
								}
							}
						}
						
						if ( $thumb_data['thumb_location'] )
						{
							$attach_data['attach_img_width']      = $thumb_data['originalWidth'];
							$attach_data['attach_img_height']     = $thumb_data['originalHeight'];
							$attach_data['attach_thumb_width']    = $thumb_data['newWidth'];
							$attach_data['attach_thumb_height']   = $thumb_data['newHeight'];
							$attach_data['attach_thumb_location'] = $this->upload_dir . $thumb_data['thumb_location'];
						}
					}
			
					/* Add into Database */
					$this->DB->insert( 'attachments', $attach_data );
	
					$upload_results[ $_field_name ] = $this->DB->getInsertId();
				}
			}
		}
		
		return $upload_results;
	}	
	
	/**
	 * Gets stuff required for the upload form
	 *
	 * @return	@e void
	 */
	public function getUploadFormSettings()
	{
		/* Collect settings from the plug-in */
		$stats = $this->plugin->getSpaceAllowance( $this->attach_post_key );

		/* Fix language strings */
		if( isset($this->lang->words['attach_unlimited']) )
		{
			$this->language['unlimited']	= $this->lang->words['attach_unlimited'];
		}
		
		if( isset($this->lang->words['attach_notallowed']) )
		{
			$this->language['not_allowed']	= $this->lang->words['attach_notallowed'];
		}

		/* Format and return... */
		$this->attach_stats['space_used']                = $stats['space_used'];
		$this->attach_stats['space_used_human']          = IPSLib::sizeFormat( $stats['space_used'] );
		$this->attach_stats['total_space_allowed']       = $stats['total_space_allowed'] ? $stats['total_space_allowed'] : $stats['max_single_upload'];
		$this->attach_stats['max_single_upload']         = $stats['max_single_upload'];
		$this->attach_stats['max_single_upload_human']   = $this->attach_stats['max_single_upload']   ? IPSLib::sizeFormat( $stats['max_single_upload'] )   : $this->language[ 'unlimited' ];
		$this->attach_stats['total_space_allowed_human'] = $this->attach_stats['total_space_allowed'] ? IPSLib::sizeFormat( $this->attach_stats['total_space_allowed'] ) : $this->language[ 'unlimited' ];

		if( $stats['space_allowed'] == 0 )
		{
			/* Unlimited... */
			$this->attach_stats['allow_uploads']             = 1;
			$this->attach_stats['space_allowed']             = 'unlimited';
			$this->attach_stats['space_allowed_human']       = $this->language['unlimited'];
			$this->attach_stats['space_left']                = 'unlimited';
			$this->attach_stats['space_left_human']          = $this->language['unlimited'];
			$this->attach_stats['total_space_allowed_human'] = $this->language['unlimited'];
		}
		else if ( $stats['space_allowed'] == -1 )
		{
			/* None */
			$this->attach_stats['allow_uploads']       = 0;
			$this->attach_stats['space_allowed']       = 'not_allowed';
			$this->attach_stats['space_allowed_human'] = $this->language['not_allowed'];
			$this->attach_stats['space_left']          = 'not_allowed';
			$this->attach_stats['space_left_human']    = $this->language['not_allowed'];
		}
		else
		{
			/* Set figure */
			$this->attach_stats['allow_uploads']       = 1;
			$this->attach_stats['space_left']          = $stats['space_left'];
			$this->attach_stats['space_left_human']    = IPSLib::sizeFormat( $stats['space_left'] );
		}
	}
	
	/**
	 * Checks the upload dir. See above. It's not rocket science
	 *
	 * @return	bool
	 */
	public function checkUploadDirectory()
	{
		/* Check dir exists... */
		if( ! file_exists( $this->upload_path ) )
		{
			if( @mkdir( $this->upload_path, IPS_FOLDER_PERMISSION ) )
			{
				@file_put_contents( $this->upload_path . '/index.html', '' );
				@chmod( $this->upload_path, IPS_FOLDER_PERMISSION );
			}
			else
			{
				$this->error = "no_upload_dir";
				return false;
			}
		}
		else if( ! is_writeable( $this->upload_path ) )
		{
			$this->error = "no_upload_dir_perms";
			return false;
		}
		
		/* Try and create a new monthly dir */
		$this_month = "monthly_" . gmstrftime( "%m_%Y", time() );
		
		/* Already a dir? */
		if( $this->attach_settings['allow_monthly_upload_dirs'] )
		{
			$path = $this->upload_path . '/' . $this_month;

			if( ! file_exists( $path ) )
			{
				if( @mkdir( $path, IPS_FOLDER_PERMISSION ) )
				{
					@file_put_contents( $path . '/index.html', '' );
					@chmod( $path, IPS_FOLDER_PERMISSION );
				
					# Set path and dir correct
					$this->upload_path .= '/' . $this_month;
					$this->upload_dir   = $this_month . '/';
				}
				
				/* Was it really made or was it lying? */
				if( ! file_exists( $path ) )
				{
					$this->upload_path = $this->_upload_path;
					$this->upload_dir  = '/';
				}
			}
			else
			{
				/* Set path and dir correct */
				$this->upload_path .= '/' . $this_month;
				$this->upload_dir   = $this_month . '/';
			}
		}
		
		return true;
	}
	
	/**
	 * Loads child extends class.
	 *
	 * @return	@e void
	 */
	public function loadAttachmentPlugin()
	{
		/* INIT */
		$this->type = IPSText::alphanumericalClean( $this->type );
		
		/* No plugin yet? Load it! */
		if( ! is_object( $this->plugin ) && $this->type )
		{
			/* Load... */
			foreach( IPSLIb::getEnabledApplications() as $app )
			{
				if( is_file( IPSLib::getAppDir( $app['app_directory'] ) . '/extensions/attachments/plugin_' . $this->type . '.php' ) )
				{
					$classToLoad  = IPSLib::loadLibrary( IPSLib::getAppDir( $app['app_directory'] ) . '/extensions/attachments/plugin_' . $this->type . '.php', 'plugin_'.$this->type, $app['app_directory'] );
					$this->plugin = new $classToLoad( $this->registry );
					$this->plugin->getSettings();
					
					/* Found it, stop */
					break;
				}
			}
			
			/* Still here? Error out then.. */
			if ( ! is_object( $this->plugin ) )
			{
				print "Could not locate plugin {$this->type}";
				exit();
			}
		}
	}
	
	/**
	 * Swaps the HTML for the nice attachments.
	 *
	 * @param	array	Array of matches from preg_replace_callback
	 * @return	string	HTML
	 */
	protected function _parseThumbnailInline( $matches )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$row       = $this->_current['row'];
		$skin_name = $this->_current['skin_name'];
		
		//-----------------------------------------
		// Generate random ID
		//-----------------------------------------
		
		$row['_attach_id'] = $row['attach_id'] . '-' . str_replace( array( '.', ' ' ), "-", microtime() );
		
		//-----------------------------------------
		// Build HTML
		//-----------------------------------------
		
		$tmp = $this->registry->getClass('output')->getTemplate( $skin_name )->Show_attachments_img_thumb( array( 't_location'  => $row['attach_thumb_location'],
																							  		 't_width'     => $row['attach_thumb_width'],
																							  		 't_height'    => $row['attach_thumb_height'],
																							         'o_width'     => $row['attach_img_width'],
																							  		 'o_height'    => $row['attach_img_height'],
																							  	     'attach_id'   => $row['attach_id'],
																									 '_attach_id'  => $row['_attach_id'],
																							    	 'file_size'   => IPSLib::sizeFormat( $row['attach_filesize'] ),
																							  		 'attach_hits' => $row['attach_hits'],
																							  		 'location'    => $row['attach_file'],
																									 'type'        => $this->_current['type'],
																						)	);
		
		return $tmp;
	}
}