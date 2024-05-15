<?php

//-----------------------------------------------
// (DP33) Forum Icons
//-----------------------------------------------
//-----------------------------------------------
// Application Library
//-----------------------------------------------
// Author: DawPi
// Site: http://www.ipslink.pl
// Written on: 02 / 08 / 2011
//-----------------------------------------------
// Copyright (C) 2011 DawPi
// All Rights Reserved
//-----------------------------------------------  

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

class fiLibrary
{
	protected $registry;
	
	public function __construct( ipsRegistry $registry )
	{		
		/* Make registry objects */
		$this->registry   =  $registry;
		$this->DB         =  $this->registry->DB();
		$this->settings   =& $this->registry->fetchSettings();
		$this->request    =& $this->registry->fetchRequest();
		$this->lang       =  $this->registry->getClass('class_localization');
		$this->member     =  $this->registry->member();
		$this->memberData =& $this->registry->member()->fetchMemberData();
		$this->cache      =  $this->registry->cache();
		$this->caches     =& $this->registry->cache()->fetchCaches();
		
		
		/* Set path */
		
		$this->path = $this->settings['upload_dir'] . '/' . $this->settings['dp3_fi_dir'];					
	}

	
	public function checkAccess( $data = array() )
	{
		/* Mod is enabled? */

		if( ! $this->settings['dp3_adt_enable'] )
		{
			return false;	
		}
		
		/* Still here? */
		
		return true;
	}


	public function cleanArray( $arr = array() )
	{
		$arrOk = array();
		
		if( is_array( $arr ) )
		{
			foreach( $arr as $k => $v )
			{
				if( $v )
				{
					$arrOk[] = $v;
				}
			}
		}
		
		return $arrOk;
	}
		
	public function updateCache()
	{
		/* INIT */
		
		$cache 	= array();
		
		/* Get content from DB */
						 
		$this->DB->build( array(
							'select'	=> '*',
							'from'		=> 'dp3_fi_icons',																													
		)	);							 
									 
		/* Execute */
		
		$query = $this->DB->execute();
		
		/* Parse */
		
		if ( $this->DB->getTotalRows( $query ) )
		{			
			while ( $row = $this->DB->fetch( $query ) )
			{
				$cache[ $row['i_fid'] ] 		= $row;
			}
		}
		
		/* Update cache */

		$this->cache->setCache( 'fi_icons', $cache, array( 'array' => 1, 'donow' => 0, 'deletefirst' => 1 ) );	
	}
	
	
	public function convertForum( $forum = array() )
	{
		/* Do we have anything? */
		
		if( ! count( $forum ) )
		{
			return false;
		}
		
		/* Do we have forum icon? */
		
		if( ! $forum['icon'] )
		{
			return false;
		}
		
		/* Make icon path */
		
		$iconPath = IPS_PUBLIC_PATH . 'forumicons/' . $forum['icon'] . '.gif';

		/* Ok, do we have a icon? */
		
		if( is_file( $iconPath ) )
		{
			/* Check forum - we want convert only empty forums */
			
			if( ! $this->caches['fi_icons'][ $forum['id'] ]['i_location'] )
			{
				/* Make new icon name */
				
				$newName = $forum['id'] . '-icon-'. md5( uniqid( microtime(), true ) ) . '.gif';
				
				/* Try copy icon to the new directory */
				
				$ok = @copy( $iconPath, $this->path . $newName );
				
				/* Insert info and update forums info */
				
				if( $ok )
				{
					$this->DB->insert( 'dp3_fi_icons', array( 'i_location' => $newName, 'i_enabled' => 1, 'i_fid' => $forum['id'] ) );
					$this->DB->update( 'forums', array( 'icon' => '' ), 'id = ' . $forum['id'] );
				}
			} 	
		}
		else
		{
			return false;
		}
	}


	public function uploadFile( $fileFieldName = 'icon', $forumId = 0 )
	{
		/* INIT */
		
		$arr				= array();
		
		$allowedExtensions 	= ( count( explode( ',', $this->settings['dp3_fi_allowed_ext'] ) ) ) ? explode( ',', $this->settings['dp3_fi_allowed_ext'] ) : array();
		
		$maxFileSize		= $this->settings['dp3_fi_max_filesize'] * 1024;
		
		$uploadPath			= $this->path;
		
		$uploadFormField	= $fileFieldName;

		/* Load upload library */
		
		require_once( IPS_KERNEL_PATH . 'classUpload.php' );
		$upload = new classUpload();
		
		/* Set values */
		
		$upload->out_file_name			= $forumId . '-icon-' . md5( uniqid( microtime(), true ) );
		
		$upload->upload_form_field		= $uploadFormField;
		
		$upload->make_script_safe		= 1;
		
		$upload->max_file_size			= $maxFileSize;
		
		$upload->allowed_file_ext		= $allowedExtensions;
		
		$upload->out_file_dir			= $uploadPath;

		/* Do we have file? */
	
		if ( $_FILES[ $uploadFormField ]['name'] == "" || ! $_FILES[ $uploadFormField ]['name'] || ( $_FILES[ $uploadFormField ]['name'] == "none" ) )
		{
			$arr['status'] = 'fail';
			$arr['error']  = 'upload_no_choosen_file';
			return $arr;
		}
				
		/* Upload */
		
		$upload->process();
		
		if ( $upload->error_no )
		{
			switch( $upload->error_no )
			{
				case 1:
					# No upload
					$arr['status'] = 'fail';
					$arr['error']  = 'upload_failed_no_upload';
				break;
				
				case 2:
					# Invalid file ext
					$arr['status'] = 'fail';
					$arr['error']  = 'invalid_file_extension';
				break;
				
				case 3:
					# Too big...
					$arr['status'] = 'fail';
					$arr['error']  = 'upload_to_big';
				break;
				
				case 4:
					# Cannot move uploaded file
					$arr['status'] = 'fail';
					$arr['error']  = 'upload_failed_cant_move';
				break;
				
				case 5:
					# Possible XSS attack (image isn't an image)
					$arr['status'] = 'fail';
					$arr['error']  = 'upload_failed_possible_xss';
				break;
			}
			
			return $arr;
		}		

		/* Get maximum dimensions */
		
		list( $max_width, $max_height ) = explode( 'x', $this->settings['dp3_fi_max_dims'] );
		
		/* Do we have both values? */
		
		if( $max_width && $max_height && ! $filePath )
		{		
			/* Rebuild logo stuff */
			
			require_once( IPS_KERNEL_PATH . 'classImage.php' );
			require_once( IPS_KERNEL_PATH . 'classImageGd.php' );
			
			$image = new classImageGd();

			$image->init( array( 'image_path' => $this->path, 'image_file' => $upload->parsed_file_name ) );

			$image_data = $image->resizeImage( $max_width, $max_height );

			$image->writeImage( $this->path . $upload->parsed_file_name );	
		}
		
		/* Play with thumbnail */
		
		list( $max_thumb_width, $max_thumb_height ) = explode( 'x', $this->settings['dp3_cards_logo_max_dims_thumb'] );		
		
		/* Do we have both values? */
		
		if( $max_thumb_width && $max_thumb_height )
		{
			/* Init new image */
			
			$thumb 				= new classImageGd();
	
			if( $thumb->init( array( 'image_path' => $this->path, 'image_file' => $upload->parsed_file_name ) ) )
			{
				$thumb->resizeImage( $max_thumb_width, $max_thumb_height );
				
				$thumb->writeImage( $this->path . $upload->parsed_file_name );
			}			
		}
								
		/* Prepare array to return */
		
		return $arr	= array(
							'record_location' => $upload->parsed_file_name,
							'record_realname' => $upload->original_file_name,							
		);	
	}
	
	
	public function doDeleteFile( $name = '' )
	{
		/* INIT */
		
		$return = false;
		
		/* Check path */
		
		if( ! $name )
		{
			return $return;
		}
		
		/* Create path */
		    
		$filePath = $this->path . $name;
		
				
		/* Check and delete */
		
		if( is_file( $filePath ) )
		{
			unlink( $filePath ); 
			
			$return = true;
		}
				
		return $return;	
	}
	
	public function makeForumIcon( $icon = '', $ligher = false, $center = false )
	{
		if( ! $icon )
		{
			return '';
		}
		
		$c1 = $center ? '<center>' : '';
		$c2 = $center ? '</center>' : '';
		
		$l 	= $ligher ? "style='opacity:0.5;filter:alpha(opacity=50)'" : '';
		
		return $c1 . "<img src='" . $this->settings['upload_url'] . '/' . $this->settings['dp3_fi_dir'] . $icon . "' {$l} />" . $c2;
	}
	
			
	/**
	 * Add Copyright Statement
	 *
	 * @access	public
	 * @author	DawPi
	 * @return	string	Processed HTML
	 */
	 
	public function c_acp()
	{
		return "<div id='footer' style='margin: 0px; text-align: center;-moz-border-radius:5px;'>Перевод <a target='_blank' href='http://www.ipbzona.ru'>" . $this->caches['app_cache']['forumicons']['app_title'] . " " . $this->caches['app_cache']['forumicons']['app_version'] . "</a> &copy; 2009-" . date( 'Y' ) . " <a target='_blank' href='http://www.ipbzona.ru' title='Моды, хуки, стили, локализации.'>IpbZona.ru</a></div>";
	}
	
	public function small_c_acp()
	{
		return "<br /><div id='footer_utilities'><p id='copyright' class='right'>Перевод <a target='_blank' href='http://www.ipbzona.ru'>" . $this->caches['app_cache']['forumicons']['app_title'] . " " . $this->caches['app_cache']['forumicons']['app_version'] . "</a> &copy; <a target='_blank' href='http://www.ipbzona.ru' title='Моды, хуки, стили, локализации.'>IpbZona.ru</a></p></div>";
	}		
}// End of class