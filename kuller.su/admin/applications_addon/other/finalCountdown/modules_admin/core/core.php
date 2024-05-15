<?php

/**
 * @author -RAW-
 * @copyright 2012
 * @link http://rawcodes.net
 * @filesource It's the Final Countdown
 * @version 1.2.0
 */

class admin_finalCountdown_core_core extends ipsCommand
{
	/*
	 * Sections where we can show the countdown on the front-end
	 */
	private $viewIn = array( 
			'top' => 'Top of the page',
			'bottom' => 'Bottom of the page',
			'sidebar' => 'Board index sidebar',
	);
	
	/*
	 * Applications that support the permissions settings
	 */
	private $permApps = array(
		'forums',
		'ccs',
	);
	
	/**
	 * Main executable
	 * 
	 * @see ipsCommand::doExecute()
	 */
	public function doExecute( ipsRegistry $registry )
	{
		// Do we have permission to use this app at all?
		$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'im_fc_global' );
		
		// Load the template
		$this->html         	= $this->registry->output->loadTemplate( 'cp_skin_finalCountdown' );
		$this->html->permApps 	= $this->permApps;
		
		$this->form_code 		= $this->html->form_code    	= 'module=core&amp;section=core';
		$this->form_code_js 	= $this->html->form_code_js 	= 'module=core&section=core';
		
		$this->lang->loadLanguageFile( array( 'admin_core' ) );
		
		if ( ! $this->registry->isClassLoaded( 'finalCountdown_library' ) )
		{
			$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( 'finalCountdown' ) . "/sources/library.php", 'finalCountdown_library' );
			$this->registry->setClass( 'finalCountdown_library', new $classToLoad( $this->registry ) );
		}

		switch ( $this->request['do'] )
		{
			case 'add':
			case 'clone':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'im_fc_canAdd' );
				$this->showForm();
				break;

			case 'doAdd':
			case 'doClone':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'im_fc_canAdd' );
				$this->saveCountdown();
				break;

			case 'edit':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'im_fc_canEdit' );
				$this->showForm();
				break;

			case 'doEdit':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'im_fc_canEdit' );
				$this->saveCountdown();
				break;

			case 'delete':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'im_fc_canDelete' );
				$this->delete();
				break;

			case 'doDelete':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'im_fc_canDelete' );
				$this->doDelete();
				break;

			case 'recache':
				$this->rebuildCountdownCache();
				
				$this->registry->output->global_message	= $this->lang->words['manageRecached'];
				$this->manageCountdowns();
				break;

			default:
			case 'manageCountdowns':
				$this->manageCountdowns();
				break;
		}
		
		/* Output */
		$this->registry->output->html_main .= $this->registry->output->global_template->global_frame_wrapper();
		$this->registry->output->sendOutput();		
	}


	/**
	* List of existing countdowns
	* 
	* @access	protected
	* @return	void
	*/
	protected function manageCountdowns()
	{
		$this->DB->build(
			array(
				'select'	=> '*',
				'from'		=> 'countdowns',
				'order'		=> 'position ASC'
			)
		);
		
		$outer = $this->DB->execute();
		
		$rows = array();
		
		if ( $this->DB->getTotalRows() > 0 )
		{			
			while( $row = $this->DB->fetch( $outer ) )
			{
				$row['formattedTime'] 	= strftime( '%B %d %Y, %I:%M %p', $row['time'] );
				$row['enabledImg']		= $row['enabled'] == 1 ? 'tick.png' : 'cross.png';
				$row['embedImg']		= $row['allow_embed'] == 1 ? 'tick.png' : 'cross.png';
				$permissions			= unserialize( $row['view_permissions'] );
				
				if ( $row['timezone'] == 'local' )
				{
					$row['timezone'] = "<br /><span class='desctext clickable' data-tooltip='{$this->lang->words['manageLocalTimezoneTooltip']}'>{$this->lang->words['manageLocalTimezone']}</span>";
				}
				else
				{
					$row['timezone'] = 'GMT' . $row['timezone'];
				}
				
				/* Viewable on */
				$viewIn = array();
				if ( $row['view_in'] )
				{
					foreach( explode( ',', $row['view_in'] ) as $view )
					{
						$viewIn[] = "<li>{$this->viewIn[ $view ]}</li>";
					}
				}
				
				/* Restricted to apps? */
				foreach( $this->permApps as $app )
				{
					$appKey = ucfirst( $app );
					
					if ( isset( $permissions[ $app ] ) )
					{
						$things = explode( ',', $permissions[ $app ] );
						if ( $permissions[ $app ] != '*' )
						{
							if ( is_array( $things ) AND count( $things ) )
							{
								$toTooltip = array();
								
								if ( $app == 'forums' )
								{
									foreach( $things as $forum )
									{
										if ( $forum == '0' )
										{
											$toTooltip[] = "Board Index";
										}
										else
										{
											$toTooltip[] = $this->registry->getClass( 'class_forums' )->forum_by_id[ $forum ]['name'];
										}
									}
								}
								else if ( $app == 'ccs' )
								{
									foreach( $things as $page )
									{
										$page = $page == '0' ? 'Frontpage' : $page;
										list ( $folder, $page ) = explode( '|', $page );
										$folder = rtrim( $folder, '/' );
										
										$toTooltip[] = $folder . '/' . $page;
									}
								}
								
								$tooltip = implode( ', ', $toTooltip );
								
								$viewIn[] = "<li class='clickable' data-tooltip='{$tooltip}'>" . sprintf( $this->lang->words['manageRestrictedTo' . $appKey ], count( $things ) ) . "</li>";
							}
						}
					}
				}
				
				
				if ( count( $viewIn ) )
				{
					$row['viewIn'] = "<ul>" . implode( '', $viewIn ) . "</ul>";
				}
				else
				{
					$row['viewIn'] = "";
				}
				
				$rows[] = $row;			
			}
		}

		$this->registry->output->html .= $this->html->manageScreen( $rows );
	}

	/**
	* Show form
	* 
	* @access	protected
	* @param	bool	$fromError Did we come here from an error?
	* @return	void
	*/
	protected function showForm( $fromError=0 )
	{

		$id 			= (int)$this->request['id'];
		$clone			= $this->request['do'] == 'clone';
		$data 			= array();
		$form			= array();
		$permissions 	= array();

		if ( $id AND $fromError == FALSE )
		{
			$this->DB->build( array( 'select' => '*', 'from' => 'countdowns', 'where' => 'id='. $id ) );
			$this->DB->execute();
	
			if ( ! $data = $this->DB->fetch() )
			{
				$this->registry->output->global_message = $this->lang->words['error_nocntdwns'];
				$this->manage();
				return;
			}
			
			IPSText::getTextClass( 'bbcode' )->parse_html		= 1;
			IPSText::getTextClass( 'bbcode' )->parse_smilies	= 1;
			IPSText::getTextClass( 'bbcode' )->parse_bbcode		= 1;
	
			$data['txtAfter']  = IPSText::getTextClass( 'bbcode' )->preEditParse( $data['after_txt'] );
			$data['txtBefore'] = IPSText::getTextClass( 'bbcode' )->preEditParse( $data['before_txt'] ); 
			$data['eventMsg']  = IPSText::getTextClass( 'bbcode' )->preEditParse( $data['event_msg'] );
			
			$permissions = unserialize( $data['view_permissions'] );
		}

		/* Group dropdown */
		$groups = array();
	
		$this->DB->build( array( 'select' => '*', 'from' => 'groups', 'order' => 'g_title ASC' ) );
		$this->DB->execute();
		
		while( $row = $this->DB->fetch() )
		{
			if ( $row['g_access_cp'] OR $row['g_is_supmod'] )
			{
				$row['g_title'] .= $this->lang->words['setting_staff_tag'];
			}
			
			$groups[] = array( $row['g_id'], $row['g_title'] );
		}

		/* Timezone dropdown */
		$defaultTZ = false;
		$systemTz = $this->registry->getClass( 'finalCountdown_library' )->timezoneBonanza( $this->settings['time_offset'] );
		foreach( $this->lang->words as $off => $words )
		{
			if ( preg_match( "/^timezone_(.*?)$/", $off, $match ) )
			{
				$zone = str_replace( ':', '.', $match[1] );
				if ( ! $defaultTZ AND $match[1] == $systemTz )
				{
					$defaultTZ = $match[1];
				}
				
				$timezones[ ceil( $zone * 12 ) ] = array( $match[1], $words );
			}
		}
		
		/* Add in the "local timezone" option */
		$timezones[ 1 ] = array( 'local', $this->lang->words['formTimezoneLocal'] );
		
		ksort( $timezones );
	
		/* Where to show the counter */
		$viewIn = array();
		foreach( $this->viewIn as $k => $v )
		{
			$viewIn[] = array( $k, $v );
		}
		
		/* Format and layout default */
		if ( empty( $data['layout'] ) )
		{
			$data['layout'] = "{y<}{yn} {yl}, {y>}{o<}{on} {ol}, {o>}{d<}{dn} {dl}, {d>}{h<}{hn} {hl}, {h>}{m<}{mn} {ml}, {m>}{s<}и {sn} {sl}{s>}";
		}
		
		if ( empty( $data['format'] ) )
		{
			$data['format'] = "yodHMS";
		}
		
		/* Form elements */
		$form['enabled']			= $this->registry->output->formYesNo( "enabled", 				$_POST['enabled'] 				? $_POST['enabled'] 	: $data['enabled'] );
		$form['allow_embed']		= $this->registry->output->formYesNo( "allow_embed", 			$_POST['allow_embed'] 			? $_POST['allow_embed'] : $data['allow_embed'] );
		$form['showOnOtherApps']	= $this->registry->output->formYesNo( "showOnOtherApps", 		$_POST['showOnOtherApps'] 		? $_POST['showOnOtherApps'] : ( isset( $permissions['showOnOtherApps'] ) ? $permissions['showOnOtherApps'] : 1 ) );
		$form['name']				= $this->registry->output->formInput( "name", 					$_POST['name'] 					? $_POST['name'] 		: htmlspecialchars( $data['name'], ENT_QUOTES ) );
		$form['date']				= $this->registry->output->formInput( "date", 					$_POST['date'] 					? $_POST['date'] 		: ( $data['time'] ? strftime( '%B %d %Y, %I:%M %p', $data['time'] ) : '' ) );
		$form['groupPermAll']		= $this->registry->output->formCheckbox( 'all_groups',			$_POST['all_groups'] 			? $_POST['all_groups'] 	: ( $permissions['groups'] == '*' ? true : false ) );
		
		/* Several field with similar setup. Feeling lazy */
		foreach( array( 'txtBefore', 'txtAfter', 'eventMsg', 'text_style', 'format' ) as $field )
		{
			$form[ $field ]			= $this->registry->output->formInput( $field, 					$_POST[ $field ] 				? $_POST[ $field ] 		: str_replace( "'", "&#39;", $data[ $field ] ) );
		}
		$form['layout']				= $this->registry->output->formTextarea( 'layout',				$_POST['layout'] 				? $_POST['layout'] 		: str_replace( "'", "&#39;", $data['layout'] ), 'layout', 4 );
		$form['viewIn']				= $this->registry->output->formMultiDropdown( "view_in[]", 		$viewIn, 	$_POST['view_in']	? $_POST['view_in'] 	: explode( ",", $data['view_in'] ), 5, 'view_in' );
		$form['groupPerm']			= $this->registry->output->formMultiDropdown( "groupPerm[]", 	$groups, 	$_POST['groupPerm'] ? $_POST['groupPerm'] 	: explode( ",", $data['groups_perm'] ), 5, 'groupPerm' );
		$form['timezone']			= $this->registry->output->formDropdown( "timezone", 			$timezones, $_POST['timezone'] 	? $_POST['timezone'] 	: ( $data['timezone'] ? $data['timezone'] : $defaultTZ ) );

		
		/* APP restrictions */
		
		/* Loop trough supported apps */
		foreach( $this->permApps as $app )
		{
			if( IPSLib::appIsInstalled( $app ) )
			{
				$appKey = ucfirst( $app );
				$form['app' . $appKey ]				= $this->registry->output->formYesNo( 'app' . $appKey, 				$_POST['app' . $appKey ] 		? $_POST['app' . $appKey ] 	: isset( $permissions[ $app ] ) );
				
				$methodName = "_build{$appKey}Wrapper";
				if ( method_exists( $this, $methodName ) )
				{
					$form['wrapper' . $appKey ] = $this->$methodName( $permissions );
				}
			}
		}
		
		/* Remove the ID if we're cloning */
		if ( $clone )
		{
			$data['id'] = "";
		}
		
		/* Output */
		$this->registry->output->html .= $this->html->countdownForm( ( $id ? ( $clone ? 'clone' : 'edit' ) : 'add' ), $data, $form );
	}
	
	protected function _buildCcsWrapper( $data )
	{
		$pages = $this->registry->getClass( 'finalCountdown_library' )->getCcsFoldersAndPages();

		$form = "<select name='ccsPages[]' class='textinput' size='15' multiple='multiple'>\n";
		$form .= "<option value='all' " . ( $data['ccs'] == '*' ? "selected='selected'" : '' ) . ">{$this->lang->words['formAllPages']}</option>\n";
		$form .= "<option value='frontpage' " . ( strstr( "," . $data['ccs'] . ",", ",0," ) ? "selected='selected'" : '' ) . ">{$this->lang->words['formCcsFrontpage']}</option>\n";
		
		foreach( $pages as $folder => $page )
		{
			$form .= "<optgroup label='{$folder}'>\n";
			foreach( $page as $p )
			{
				if( strstr( ",{$data['ccs']},", ",{$folder}|{$p[0]}," ) AND $data['ccs'] != '*' )
				{
					$selected = ' selected="selected"';
				}
				else
				{
					$selected = "";
				}
				$form .= "<option value='{$folder}|{$p[0]}'{$selected}>{$p[1]}</option>\n";
			}
			$form .= "</optgroup>\n";
		}
		
		return $form;
	}
	
	protected function _buildForumsWrapper( $data )
	{
		/* Forums dropdown */
		require_once( IPSLib::getAppDir( 'forums' ) .'/sources/classes/forums/class_forums.php' );/*noLibHook*/
		$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( 'forums' ) . '/sources/classes/forums/admin_forum_functions.php', 'admin_forum_functions', 'forums' );
		
		$aff = new $classToLoad( $this->registry );
		$aff->forumsInit();
		$forum_jump = $aff->adForumsForumData();
		
		/* Build forum multiselect */
		$form['forums'] = "<select name='forums[]' class='textinput' size='15' multiple='multiple'>\n";
		
		$form['forums'] .= "<option value='all' " . ( $data['forums'] == '*' ? "selected='selected'" : '' ) . ">{$this->lang->words['formAllForums']}</option>\n";
		
		$form['forums'] .= "<option value='idx' " . ( strstr( "," . $data['forums'] . ",", ",0," ) ? "selected='selected'" : '' ) . ">{$this->lang->words['formBoardIndex']}</option>\n";
			
		foreach( $forum_jump as $i )
		{
			if( strstr( "," . $data['forums'] . ",", "," . $i['id'] . "," ) AND $data['forums'] != '*' )
			{
				$selected = ' selected="selected"';
			}
			else
			{
				$selected = "";
			}
			
			if( !empty( $i['redirect_on'] ) )
			{
				continue;
			}
			
			$fporum_jump[] = array( $i['id'], $i['depthed_name'] );
			
			$form['forums']  .= "<option value=\"{$i['id']}\" $selected>{$i['depthed_name']}</option>\n";
		}
		
		$form['forums'] .= "</select>";
		
		return $form['forums'];
	}

	/**
	* Save an edited countdown
	* 
	* @access	protected
	* @return	void
	*/
	protected function saveCountdown()
	{
		$id = (int)$this->request['id'];
		$permissions = array();


		if ( empty( $this->request['name'] ) )
		{
			$this->registry->output->global_message = $this->lang->words['errorNoName'];
			$this->showForm(1);
			return;
		}
		
		/* We want our times based on GTM/UTC */
		date_default_timezone_set( 'UTC' );
		
		/* Get and parse date */
		$date = IPSText::parseCleanValue( trim( urldecode( IPSText::stripslashes( $this->request['date'] ) ) ) );
		
		if( preg_match( '/\d{2}-\d{2}-\d{4}/', $date ) )
		{	
			$_tmp = explode( '-', $date );
			
			$timestamp = mktime( $this->request['hour'], $this->request['min'], $this->request['sec'], $_tmp[0], $_tmp[1], $_tmp[2] );
		}
		else
		{
			$timestamp 	= strtotime( $date );
		}
		
		$classToLoad = IPSLib::loadLibrary( IPS_ROOT_PATH . 'sources/classes/editor/composite.php', 'classes_editor_composite' );
		$this->editor	= new $classToLoad();

		/* There have to be some text in front of or after the countdown */
		if ( empty( $this->request['txtBefore'] ) AND empty( $this->request['txtAfter'] ) )
		{
			$this->registry->output->global_message = $this->lang->words['errorNoText'];
			$this->showForm(1);
			return;
		}

		$viewIn 		= ( is_array( $_POST['view_in'] ) ) 	? implode( ',', $_POST['view_in'] ) 	: '';
		$groups_perm 	= ( is_array( $_POST['groupPerm'] ) ) 	? implode( ',', $_POST['groupPerm'] ) 	: '';
		$groups_perm	= ( $this->request['all_groups'] == 1 ) ? '*' : $groups_perm;
		
		$permissions['showOnOtherApps'] = (bool) ( $this->request['showOnOtherApps'] == 1 );
		
		/* Get data from app restrictions */
		foreach( $this->permApps as $app )
		{
			$appKey = ucfirst( $app );
			if ( isset( $this->request['app' . $appKey ] ) AND $this->request['app' . $appKey ] == 1 )
			{
				$methodName = '_getSelected' . $appKey;
				
				if ( method_exists( $this, $methodName ) )
				{
					$permissions[ $app ] = $this->$methodName();
				}
			}
		}
		
		/* Set a default timezone if none are specified */
		$timezone = empty( $this->request['timezone'] ) ? '+00:00' : $this->request['timezone'];
		
		IPSText::getTextClass( 'bbcode' )->parse_html		= 1;
		IPSText::getTextClass( 'bbcode' )->parse_smilies	= 1;
		IPSText::getTextClass( 'bbcode' )->parse_bbcode		= 1;
		
		$data = array(
			'enabled'			=> (int)$this->request['enabled'],
			'allow_embed'		=> (int)$this->request['allow_embed'],
			'view_in'			=> $viewIn,
			'name'				=> $this->request['name'],
			'time'				=> (int)$timestamp,
			'timezone'			=> $timezone,
			'groups_perm'		=> $groups_perm,
			'before_txt'		=> IPSText::getTextClass( 'bbcode' )->preDbParse( $this->editor->process( $_POST['txtBefore'] ) ),
			'after_txt'			=> IPSText::getTextClass( 'bbcode' )->preDbParse( $this->editor->process( $_POST['txtAfter'] ) ),
			'event_msg'			=> IPSText::getTextClass( 'bbcode' )->preDbParse( $this->editor->process( $_POST['eventMsg'] ) ),
			'text_style'		=> trim( IPSText::safeslashes( $_POST['text_style'] ) ),
			'view_permissions'	=> serialize( $permissions ),
			'format'			=> $this->request['format'],
			'layout'			=> $this->request['layout'],
		);
		
		if ( $id > 0 )
		{
    		$this->DB->update( 'countdowns', $data, 'id=' . $id  );
		}
		else
		{
			$max = $this->DB->buildAndFetch( array( 'select' => 'MAX(position) as position', 'from' => 'countdowns' ) );
			
			$data['position'] = $max['position'] + 1;
			$this->DB->insert( 'countdowns', $data );
		}

		//Update the cache
		$this->cache->rebuildCache( 'countdowns', 'finalCountdown' );

		// Redirect back to the home page
		$this->registry->output->redirect( $this->settings['base_url'] . "&amp;" . $this->form_code, $this->lang->words[ ( $id ? 'redirEdited' : 'redirAdded' ) ] );
	}
	
	/**
	 * Get selected forums from form element
	 *
	 * @access	protected
	 * @return	string	Comma separated list of forum ids
	 */ 
    protected function _getSelectedForums()
    {
    	/* INI */
		$forumids = array();
    	
		/* Check for the forums array */
    	if( is_array( $_POST['forums'] )  )
    	{
    		/* Add All Forums */
    		if( in_array( 'all', $_POST['forums'] ) )
    		{
    			return '*';
    		}
    		/* Add selected Forums */
    		else
    		{
				/* Loop through the selected forums */
				foreach( $_POST['forums'] as $l )
				{
					if( $this->registry->class_forums->forum_by_id[ $l ] )
					{
						$forumids[] = intval( $l );
					}
					else if ( $l == 'idx' )
					{
						$forumids[] = 0;
					}
				}
				
				if( ! count( $forumids  ) )
				{
					return;
				}
    		}
		}
		/* Not an array */
		else
		{
			/* All Forums */
			if ( $this->request['forums'] == 'all' )
			{
				return '*';
			}
			else
			{
				/* Anything selected? */
				if( $this->request['forums'] != "" )
				{
					$l = intval( $this->request['forums'] );
					
					/* Single Forum */
					if( $this->registry->class_forums->forum_by_id[ $l ] )
					{
						$forumids[] = intval( $l );
					}
					else if ( $l == 'idx' )
					{
						$forumids[] = 0;
					}
				}
			}
		}
		
		return implode( ",", $forumids );
    }
    
	/**
	 * Get selected IP.Content pages from form element
	 *
	 * @access	protected
	 * @return	string	Comma separated list of pages with their corresponding folder
	 */ 
    protected function _getSelectedCcs()
    {
    	/* INI */
		$pages = array();
    	
		/* Check for the pages array */
    	if( is_array( $_POST['ccsPages'] )  )
    	{
    		/* Add All pages */
    		if( in_array( 'all', $_POST['ccsPages'] ) )
    		{
    			return '*';
    		}
    		/* Add selected pages */
    		else
    		{
				/* Loop through the selected pages */
				foreach( $_POST['ccsPages'] as $l )
				{
					if ( $l == 'frontpage' )
					{
						$pages[] = 0;
					}
					else
					{
						$pages[] = $l;
					}
				}
				
				if( ! count( $pages ) )
				{
					return;
				}
    		}
		}
		/* Not an array */
		else
		{
			/* All Forums */
			if ( $this->request['ccsPages'] == 'all' )
			{
				return '*';
			}
			else
			{
				/* Anything selected? */
				if( $this->request['ccsPages'] != "" )
				{
					/* Single Page */
					if ( $l == 'frontpage' )
					{
						$pages[] = 0;
					}
					else
					{
						$pages[] = $l;
					}
				}
			}
		}
		
		return implode( ",", $pages );
    }
	
	/**
	* Delete a countdown?
	* 
	* @access	protected
	* @return	void
	*/
	protected function delete()
	{
		$id = (int)$this->request['id'];
		
		if ( ! $id )
		{
			$this->registry->output->global_message = $this->lang->words['errorEmptyId'];
			$this->manage();
			return;
		}
		
		/* Are you re-he-he-heally sure we want to do this, Isabelle? */
		$this->registry->output->html .= $this->html->deleteForm( $id, $this->caches['countdowns'][ $id ]['name'] );
	}
	
	/**
	* Get rid of it!
	* 
	* @access	protected
	* @return	void
	*/
	protected function doDelete()
	{
		$id = (int)$this->request['id'];
		
		if ( ! $id )
		{
			$this->registry->output->global_message = $this->lang->words['errorEmptyId'];
			$this->manage();
			return;
		}
		else
		{
			/* Delete, rebuild, and redirect */
			$this->DB->delete( 'countdowns', 'id=' . $id );
			
			$this->cache->rebuildCache( 'countdowns', 'finalCountdown' );

			$this->registry->output->redirect( $this->settings['base_url'] . "&amp;" . $this->form_code, $this->lang->words['redirDeleted'] );
		}

	}
	
	/**
	* Rebuild the countdown cache
	* 
	* @access	public
	* @return	void
	*/
	public function rebuildCountdownCache()
	{
		$rows = array();
		$enableSidebarHook = false;
		
		$this->DB->build( array( 'select' => '*', 'from' => 'countdowns', 'order' => 'position ASC' ) );
		$this->DB->execute();

		if ( $this->DB->getTotalRows() )
		{
			while( $row = $this->DB->fetch() )
			{
				if ( strstr( ",{$row['view_in']},", ",sidebar," ) )
				{
					$enableSidebarHook = true;
				}
				
				$rows[ $row['id'] ] = $row;			
			}
		}
		
		$this->cache->setCache( 'countdowns', $rows, array( 'array' => 1, 'donow' => 1 ) );
		
		$this->DB->update( 'core_hooks', array( 'hook_enabled' => $enableSidebarHook ), 'hook_key="im_finalCountdown_sidebar"' );
		$this->cache->rebuildCache( 'hooks', 'global' );
	}
}