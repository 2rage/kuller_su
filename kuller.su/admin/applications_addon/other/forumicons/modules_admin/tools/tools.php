<?php

//-----------------------------------------------
// (DP32) Forum Icons
//-----------------------------------------------
//-----------------------------------------------
// Application
//-----------------------------------------------
// Author: DawPi
// Site: http://www.ipslink.pl
// Written on: 25 / 06 / 2011
//-----------------------------------------------
// Copyright (C) 2011 DawPi
// All Rights Reserved
//-----------------------------------------------  

if ( ! defined( 'IN_ACP' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded 'admin.php'.";
	exit();
}

class admin_forumicons_tools_tools extends ipsCommand
{

	public $registry;
	public $html;
		
	public function doExecute( ipsRegistry $registry ) 
	{
		/* Load skin */
		
		$this->html               = $this->registry->output->loadTemplate( 'forumicons_cp' );		
		$this->html->form_code    = 'module=tools&amp;section=tools';
		$this->html->form_code_js = 'module=tools&section=tools';	
		
		/* What we should to do? */
			
		switch ( $this->request['do'] )
		{
			case 'convert':
				if( ! $this->DB->checkForField( 'icon', 'forums' ) )
				{
					$this->registry->output->showError( $this->lang->words['error_no_icon_field'], '' );
				}
				$this->doConvert();
			break;		
												
			case 'view':																
			default:
				$this->viewMain();
				break;
		}
		
		$this->registry->output->html_main .= $this->registry->output->global_template->global_frame_wrapper();
		
		$this->registry->output->html 	   .= $this->registry->fiLibrary->c_acp();
		$this->registry->output->sendOutput();
	}

	
	public function viewMain()
	{
		/* INIT */
		
		$formData 			= array();
		
		/* Set form data */
		
		$formData['pergo']  = $this->registry->output->formSimpleInput( 'pergo', '10', 5 );
											
		/* Add to output */
		
		$this->registry->output->html .= $this->html->toolsSplash( $formData );				
	}

	
	public function doConvert()
	{
		/* INIT */

		$done   = 0;
		$start  = intval( $this->request['st'] ) >= 0 ? intval( $this->request['st'] )    : 0;
		$end    = intval( $this->request['pergo'] )   ? intval( $this->request['pergo'] ) : 100;
		$dis    = $end + $start;
		$output = array();

		/* Got any more? */

		$tmp = $this->DB->buildAndFetch( array( 'select' => 'count(*) as count', 'from' => 'forums', 'limit' => array( $dis, 1 )  ) );
		$max = intval( $tmp['count'] );

		/* Avoid limit... */

		$this->DB->build( array( 'select' => 'name, id, icon', 'from' => 'forums', 'order' => 'id ASC', 'limit' => array( $start, $end ) ) );
		$outer = $this->DB->execute();

		/* Process... */

		while( $r = $this->DB->fetch( $outer ) )
		{
			$this->registry->fiLibrary->convertForum( $r );
			$output[] = sprintf( $this->lang->words['rebuild_process_f'], $r['name'] );
			$done++;
		}

		/* Finish - or more?... */
		
		if ( ! $done and ! $max )
		{
			/* Done.. */

			$text = $this->lang->words['re_rebuildcomp'] . '<br />' . implode( "<br />", $output );
			$url  = "{$this->settings['base_url']}{$this->html->form_code}";
			
			/* Update cache */
			
			$this->cache->rebuildCache( 'fi_icons', 'forumicons' );
		}
		else
		{
			/* More.. */
			
			$thisgoeshere = sprintf( $this->lang->words['re_thisgoeshere'], $dis );
			$text = $thisgoeshere . '<br />' . implode( "<br />", $output );
			$url  = "{$this->settings['base_url']}{$this->html->form_code}&do={$this->request['do']}&pergo={$this->request['pergo']}&st={$dis}";
		}

		/* Bye.... */

		$this->_specialRedirect( $url, $text );		
	}
	
	protected function _specialRedirect( $url, $text )
	{
		$this->registry->output->html	.= $this->registry->output->global_template->temporaryRedirect( $url, $text );
	}		
}// End of class