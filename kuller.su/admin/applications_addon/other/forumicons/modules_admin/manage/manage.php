<?php

//-----------------------------------------------
// (DP32) Forum Icons
//-----------------------------------------------
//-----------------------------------------------
// Application
//-----------------------------------------------
// Author: DawPi
// Site: http://www.ipslink.pl
// Written on: 02 / 08 / 2011
//-----------------------------------------------
// Copyright (C) 2011 DawPi
// All Rights Reserved
//-----------------------------------------------   

class admin_forumicons_manage_manage extends ipsCommand
{
	public $html;
	public $printed   = 0;
	public $skins     = array();
	public $type      = "";		

	public function doExecute( ipsRegistry $registry )
	{
		/* Load skin */
		
		$this->html               = $this->registry->output->loadTemplate( 'forumicons_cp' );		
		$this->html->form_code    = 'module=manage&amp;section=manage';
		$this->html->form_code_js = 'module=manage&section=manage';	
		
		/* Check ACP restrictions */
		
		$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'manage' );	
		
		/* Init forums */
		
        ipsRegistry::getClass('class_forums')->strip_invisible = 0;
		ipsRegistry::getClass('class_forums')->forumsInit();				
		
		/* What we should to do? */

		switch ( $this->request['do'] )
		{
			/** Icons stuff **/

			case 'check':
				$this->doCheck();
			break;

			case 'edit':
				$this->form();
			break;

			case 'updateCache':
				$this->doUpdateCache();
			break;
			
			case 'delete':
				$this->doDelete();
			break;	

			/** Default stuff **/
			
			case 'view':												
			default:
				$this->viewMain();
			break;
		}

		$this->registry->output->html_main 	.= $this->registry->output->global_template->global_frame_wrapper();

		$this->registry->output->html 		.= $this->registry->fiLibrary->c_acp();

		$this->registry->output->sendOutput();
	}


	public function viewMain()
	{		
		/* INIT */

		if ( ! $this->html )
		{
			$this->html = $this->registry->output->loadTemplate( 'forumicons_cp' );
		}
		
		/* Add header */
		
		$this->registry->output->html .= $this->html->renderForumHeader();
		
		/* Manage forums */

		if ( $this->type == 'manage' )
		{
			foreach( $this->caches['skinsets'] as $id => $data )
			{
				$this->skins[ $id ] = $data['set_name'];
			}
		}
				
		$temp_html	= "";
		$fid		= intval( $this->request['f'] );

		/* Show root forums */
		
		if ( ! $fid )
		{
			$seen_count  = 0;
			$total_items = 0;
			if( is_array( $this->registry->getClass('class_forums')->forum_cache[ 'root' ] ) AND count( $this->registry->getClass('class_forums')->forum_cache[ 'root' ] ) )
			{
				foreach( $this->registry->getClass('class_forums')->forum_cache[ 'root' ] as $forum_data )
				{
					$cat_data    = $forum_data;
					$depth_guide = "";
					$temp_html	 = "";
					
					if ( isset( $this->registry->getClass('class_forums')->forum_cache[ $forum_data['id'] ] ) AND is_array( $this->registry->getClass('class_forums')->forum_cache[ $forum_data['id'] ] ) )
					{
						foreach( $this->registry->getClass('class_forums')->forum_cache[ $forum_data['id'] ] as $forum_data )
						{					
							$temp_html .= $this->renderForum( $forum_data, $depth_guide );
						}
					}
					
					if( ! $temp_html )
					{
						$temp_html = $this->html->renderNoForums( $cat_data['id'] );
					}				
					
					$this->registry->output->html .= $this->forumShowCat( $temp_html, $cat_data );
					
					unset( $temp_html );
				}
			}
		}
		
		/* Show per ID forums  */
		
		else
		{
			$cat_data		= array();
			$depth_guide	= "";

			if ( is_array( $this->registry->getClass('class_forums')->forum_cache[ $fid ] ) )
			{
				$cat_data    = $this->registry->getClass('class_forums')->forum_by_id[ $fid ];
				$depth_guide = "";
				
				foreach( $this->registry->getClass('class_forums')->forum_cache[ $fid ] as $forum_data )
				{			
					$temp_html .= $this->renderForum( $forum_data, $depth_guide );
				}
			}
			
			if( ! $temp_html )
			{
				$temp_html = $this->html->renderNoForums( $cat_data['id'] );
			}
			
			$this->registry->output->html .= $this->forumShowCat( $temp_html, $this->registry->getClass('class_forums')->forum_by_id[ $fid ] );
			
			unset( $temp_html );
		}
		
		/* Add footer */
		
		$this->registry->output->html .= $this->html->renderForumFooter();
	}


	public function forumShowCat( $content, $r )
	{
		$this->printed++;
		
		$no_root = count( $this->registry->getClass('class_forums')->forum_cache['root'] );

		$this->registry->output->html .= $this->html->forumWrapper( $content, $r );
	}


	public function renderForum( $r, $depth_guide = "" )
	{
		/* INIT */

		$desc       = "";
		$mod_string = "";
		
		$r['skin_id'] = isset( $r['skin_id'] ) ? $r['skin_id'] : '';
		
		/* Make icon */
		
		if( $this->caches['fi_icons'][ $r['id'] ]['i_location'] )
		{
			$r['forum_icon'] = $this->registry->fiLibrary->makeForumIcon( $this->caches['fi_icons'][ $r['id'] ]['i_location'] );	
		}

		/* Show main forums... */
		
		$children = $this->registry->getClass('class_forums')->forumsGetChildren( $r['id'] );
	
		$sub		= array();
		$subforums	= "";
		$count		= 0;
		
		/* Build sub-forums link */
		
		if ( count( $children ) )
		{
			$r['name'] = "<a href='{$this->settings['base_url']}f={$r['id']}'>" . $r['name'] . "</a>";
			
			foreach ( $children as $cid )
			{
				$count++;
				
				$cfid = $cid;
				
				if ( $count == count( $children ) )
				{
					//-----------------------------------------
					// Last subforum, link to parent
					// forum...
					//-----------------------------------------
					
					if ( ! isset( $children[ $count - 2 ] ) OR ! $cfid = $children[ $count - 2 ] )
					{
						$cfid = $r['id'];
					}
				}
				
				$sub[] = "<a href='{$this->settings['base_url']}f={$this->registry->getClass('class_forums')->forum_by_id[$cid]['parent_id']}'>" . $this->registry->getClass('class_forums')->forum_by_id[ $cid ]['name'] . "</a>";
			}
		}
		
		if ( count( $sub ) )
		{
			$subforums = '<fieldset class="subforums"><legend>' . $this->lang->words['acp_subforum_legend'] . '</legend>' . implode( ", ", $sub ) . '</fieldset>';
		}

		$desc = "{$r['description']}{$subforums}";
		
		/* Print */
		
		$this->skins[ $r['skin_id'] ] = ! empty( $this->skins[ $r['skin_id'] ] ) ? $this->skins[ $r['skin_id'] ] : '';

		return $this->html->renderForumRow( $desc, $r, $depth_guide, $this->skins[ $r['skin_id'] ] );		
	}
	
					
	public function form()
	{
		/* INIT */
		
		$data		= array();
		
		$formData	= array();
		
		$st	    	= $this->request['st'];	
		
		$id			= intval( $this->request['f'] );
		
		/* Do we have ID? */
		
		if( $id )
		{
			$button            	= $this->lang->words['edit_item_button'];
											
			$formData['formDo'] = $this->lang->words['editing_item'];	
		
			/* Get data from SQL */
			
			$data = $this->DB->buildAndFetch( array(
											'select'	=> 't.*',
											'from'		=> array( 'dp3_fi_icons' => 't' ), 
											'where'	 	=> 't.i_fid = ' . $id,									
			)	);							
		}
		else
		{
			$this->registry->output->showError( $this->lang->words['error_no_forum_id'], '' );				
		}

		/** Build standard fields **/

		/* Forum name */
		
		$formData['forum_name']		= $this->registry->getClass('class_forums')->forum_by_id[ $id ]['name'];
				
		/* Forum ID */
			
		$formData['i_fid']   		= $data['i_fid'] ? $data['i_fid'] : $id;
		
		/* Enabled */
						
		$formData['i_enabled']		= $this->registry->output->formYesNo( 'i_enabled', isset( $data['i_enabled'] ) ? $data['i_enabled'] : 0 );	
		
		/* Upload form */
		
		$formData['icon']			= $this->registry->output->formUpload( 'icon' );
		
		/* Current image */
		
		$formData['curr_image']		= $this->registry->fiLibrary->makeForumIcon( $data['i_location'] );					
							
		/* Add to output */
	
		$this->registry->output->html .= $this->html->itemForm( $formData, $button, $st );			
	}

	
	public function doCheck()
	{	
		/* Cancel? */
		
		if( $this->request['cancel_operation'] && isset( $this->request['cancel_operation'] ) )
		{
			self::viewMain();
			return;
		}
			
		/* INIT */
		
		$id 		= intval( $this->request['f'] );
		$enabled	= intval( $this->request['i_enabled'] );
		
		/* Get info about current icon */
						
		$current	= $this->DB->buildAndFetch( array( 'select' => 'i_id, i_location', 'from' => 'dp3_fi_icons', 'where' => 'i_fid=' . $id ) ); 
												
		/* Build array with data */
		
		$saveArray = array(
							'i_fid'			=> $id,
							'i_enabled'		=> $enabled,
			    );
			    
		/* Play with uploaded file */
			    
		$fileInfo	= $this->registry->fiLibrary->uploadFile( 'icon', $id );

		if( $fileInfo['status'] != 'fail' )
		{
			/* Delete current logo */
			
			$this->registry->fiLibrary->doDeleteFile( $current['i_location'] );
							
			/* Save info */
			
			$saveArray['i_location'] = $fileInfo['record_location'];
		}
		else
		{
			if( $fileInfo['error'] != 'upload_no_choosen_file' )
			{
				$this->registry->output->showError( $this->lang->words[ 'error_number__' . $fileInfo['error'] ], '' );	
			}			
		}
	 		  
		if( $current['i_id'] )
		{
			/* Update! */
	
			$this->DB->update( 'dp3_fi_icons', $saveArray, 'i_fid = ' . $id );
		}
		else
		{
			/* Insert! */
			
			$this->DB->insert( 'dp3_fi_icons', $saveArray );
		} 
	
		/* Update cache */
		
		$this->cache->rebuildCache( 'fi_icons', 'forumicons' );

		/* Set message */
			
		$this->registry->output->global_message = $this->lang->words['redirectedit_item'];	
								
		/* Redirect */
			
		$this->registry->output->silentRedirectWithMessage( $this->settings['base_url'] . $this->html->form_code . '&amp;st=' . $this->request['st'] );						
	}


	public function doUpdateCache()
	{
		/* Update cache */
			
		$this->cache->rebuildCache( 'fi_icons', 'forumicons' );
			
		/* Set message */
		
		$this->registry->output->global_message = $this->lang->words['success_cache_updated'];	
						
		/* Redirect */	
		  
		$this->registry->output->silentRedirectWithMessage( $this->settings['base_url'] . $this->html->form_code );				
	}
	
	public function doDelete()
	{
		/* Get ID */
		
		$id = intval( $this->request['f'] );
		
		if ( ! $id )
		{
			$this->registry->output->showError( $this->lang->words['error_no_forum_id'], '' );		
		}
		
		/* Get image name */
		
		$img = $this->DB->buildAndFetch( array( 'select' => 'i_location', 'from' => 'dp3_fi_icons', 'where' => 'i_fid = ' . $id ) );
		
		/* Delete it */
		
		$this->DB->delete( 'dp3_fi_icons', 'i_fid = ' . $id );
		
		/* Delete image if exists */
		
		$this->registry->fiLibrary->doDeleteFile( $img['i_location'] );
				
		/* Update cache */
			
		$this->cache->rebuildCache( 'fi_icons', 'forumicons' );
		
		/* Set message */
		
		$this->registry->output->global_message = $this->lang->words['success_icon_deleted'];							
				
		/* Redirect */
		
		$this->registry->output->silentRedirectWithMessage( $this->settings['base_url'] . $this->html->form_code  );			
	}		
}// End of class