<?php

/**
 * Product Title:		Group Name Indicator
 * Product Version:		1.1.0
 * Author:				Michael McCune
 * Website:				Invision focus
 * Website URL:			http://invisionfocus.com/
 * Email:				michael.mccune@gmail.com
 */

if ( !defined( 'IN_ACP' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly.";
	exit();
}

class admin_members_groupNameIndicator_groupNameIndicator extends ipsCommand
{
	private $html;
	private $form_code;
	private $form_code_js;
	
	public function doExecute( ipsRegistry $registry ) 
	{
		/* Load skin */
		$this->html = $this->registry->output->loadTemplate('cp_skin_group_name_indicator');
		
		/* Set up stuff */
		$this->form_code	= $this->html->form_code	= 'module=groupNameIndicator&amp;section=groupNameIndicator';
		$this->form_code_js	= $this->html->form_code_js	= 'module=groupNameIndicator&section=groupNameIndicator';
		
		/* Load lang */
		$this->lang->loadLanguageFile( array( 'admin_group_name_indicator' ) );
		
		/* Check permission */
		$this->registry->class_permissions->checkPermissionAutoMsg( 'gni_manage' );
		
		/* What to do? */
		switch( $this->request['do'] )
		{
			case 'group_manage_position':
				$this->groupManagePosition();
			break;
			
			case 'group_toggle':
				$this->groupToggle();
			break;
			
			default:
				$this->_orderPage();
			break;
		}
		
		/* Pass to CP output hander */
		$this->registry->output->html_main .= $this->registry->output->global_template->global_frame_wrapper();
		$this->registry->output->sendOutput();
	}
	
	private function _orderPage()
	{
		/* INIT */
		$shown  = array();
		$hidden = array();
		
		/* Loop through each group */
		foreach ( $this->caches['group_cache'] as $id => $group )
		{
			/* Filter out Guest group */
			if ( $group['g_id'] != $this->settings['guest_group'] )
			{
				/* Shown or hidden? */
				if ( isset( $group['g_display'] ) && $group['g_display'] )
				{
					$shown[ $group['g_display'] ] = $group;
				}
				else
				{
					$hidden[ $id ] = $group;
				}
			}
		}
		
		/* Sort */
		ksort( $shown );
		
		/* Return HTML */
		$this->registry->output->html .= $this->html->order_list( $shown, $hidden );
	}
	
	private function groupManagePosition()
	{
		/* INIT */
		require_once( IPS_KERNEL_PATH . 'classAjax.php' );
		$ajax = new classAjax();
		
		/* Checks... */
		if ( $this->registry->adminFunctions->checkSecurityKey( $this->request['md5check'], true ) === false )
		{
			$ajax->returnString( $this->lang->words['postform_badmd5'] );
			exit();
		}
 		
 		/* Save new position */
 		$position = 1;
 		
 		if ( is_array( $this->request['group'] ) && count( $this->request['group'] ) )
 		{
 			foreach ( $this->request['group'] as $this_id )
 			{
				if ( $this_id != $this->settings['guest_group'] )
				{
	 				$this->DB->update( 'groups', array( 'g_display' => $position ), 'g_id=' . $this_id );
	 				$position++;
				}
 			}
 		}
		
		/* Recache */
		$this->rebuildGroupCache();
		
		/* Return */
 		$ajax->returnString( 'OK' );
 		exit();
	}
	
	private function groupToggle()
	{
		/* INIT */
		$group_id = intval( $this->request['group_id'] );
		$group    = $this->caches['group_cache'][ $group_id ];
		
		/* Can't mess with Guests */
		if ( $group_id == $this->settings['guest_group'] )
		{
			$this->registry->output->global_message = $this->lang->words['no_toggle_guest'];
			$this->_orderPage();
			return;
		}
		
		/* Toggle off */
		if ( $group['g_display'] )
		{
			$toggle = $this->lang->words['g_hidden'];
			$this->DB->force_data_type['g_display'] = 'null';
			$this->DB->update( 'groups', array( 'g_display' => 0 ), 'g_id=' . $group_id );
		}
		
		/* Toggle on */
		else
		{
			$toggle = $this->lang->words['g_shown'];
			$max = 0;
			
			foreach ( $this->caches['group_cache'] as $id => $group )
			{
				/* No guests! */
				if ( $id != $this->settings['guest_group'] )
				{
					if ( isset( $group['g_display'] ) && $group['g_display'] > $max )
					{
						$max = $group['g_display'];
					}
				}
			}
			
			$max++;
			$this->DB->update( 'groups', array( 'g_display' => $max ), 'g_id=' . $group_id );
		}

		/* Recache */
		$this->rebuildGroupCache();		
		$this->rebuildOrder();
		
		/* Redirect */
		$this->registry->output->global_message = $this->lang->words['g_successfully'] . $toggle;
		$this->_orderPage();
	}
	
	private function rebuildGroupCache()
	{
		/* Force guests to have a null here */
		$this->DB->update( 'groups', 'g_display=NULL', 'g_id='.$this->settings['guest_group'], false, true );
		
		/* INIT */
		$cache = array();
		
		/* Query for all group fields */
		$this->DB->build( array( 'select' => '*', 'from' => 'groups' ) );
		$this->DB->execute();
		
		/* Set the values */
		while ( $i = $this->DB->fetch() )
		{
			$cache[ $i['g_id'] ] = $i;
		}
		
		/* Update the cache */
		$this->cache->setCache( 'group_cache', $cache, array( 'array' => 1, 'deletefirst' => 1 ) );
	}
	
	private function rebuildOrder()
	{
		/* INIT */
		$shown = array();
		$position = 1;
		
		/* Loop... */
		foreach ( $this->caches['group_cache'] as $id => $group )
		{
			/* Filter out guests */
			if ( $id != $this->settings['guest_group'] )
			{
				if ( $group['g_display'] > 0 )
				{
					$shown[ $group['g_display'] ] = $group;
				}
			}
		}
		
		/* Sort */
		ksort( $shown );
 		
		/* Set the position for all shown */
 		if ( count( $shown ) )
 		{
 			foreach ( $shown as $id => $group )
 			{
				$this->DB->update( 'groups', array( 'g_display' => $position ), 'g_id=' . $group['g_id'] );
				$position++;
 			}
 		}
		
		/* Rebuild the cache */
		$this->rebuildGroupCache();
	}
}