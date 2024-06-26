<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Search Engine Spider logs
 * Last Updated: $LastChangedDate: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Core
 * @link		http://www.invisionpower.com
 * @since		27th January 2004
 * @version		$Rev: 10721 $
 */

if ( ! defined( 'IN_ACP' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded 'admin.php'.";
	exit();
}

class admin_core_logs_spiderlogs extends ipsCommand 
{
	/**
	 * Skin object
	 *
	 * @var		object			Skin templates
	 */
	protected $html;
	
	/**
	 * Spider map
	 *
	 * @var		array			Spider keys to values
	 */
	protected $bot_map			= array();
	
	/**
	 * Main class entry point
	 *
	 * @param	object		ipsRegistry reference
	 * @return	@e void		[Outputs to screen]
	 */
	public function doExecute( ipsRegistry $registry )
	{
		/* Load bat names from the useragents cache */
		foreach( $this->cache->getCache( 'useragents' ) as $agent )
		{
			if( $agent['uagent_type'] == 'search' )
			{
				$this->bot_map[ $agent['uagent_key'] ] = $agent['uagent_name'];
			}
		}

		//-----------------------------------------
		// Load skin
		//-----------------------------------------
		
		$this->html			= $this->registry->output->loadTemplate('cp_skin_spiderlogs');
		
		//-----------------------------------------
		// Set up stuff
		//-----------------------------------------
		
		$this->form_code	= $this->html->form_code	= 'module=logs&amp;section=spiderlogs';
		$this->form_code_js	= $this->html->form_code_js	= 'module=logs&section=spiderlogs';
		
		//-----------------------------------------
		// Load lang
		//-----------------------------------------
				
		$this->registry->getClass('class_localization')->loadLanguageFile( array( 'admin_logs' ) );
		
		$this->registry->output->core_nav[]		= array( $this->settings['base_url'] . 'module=logs&section=spiderlogs', $this->lang->words['slog_spider_logs'] );
				
		///----------------------------------------
		// What to do...
		//-----------------------------------------
		
		switch( $this->request['do'] )
		{
			case 'view':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'spiderlogs_view' );
				$this->_view();
			break;
				
			case 'remove':
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'spiderlogs_delete' );
				$this->_remove();
			break;

			default:
				$this->registry->getClass('class_permissions')->checkPermissionAutoMsg( 'spiderlogs_view' );
				$this->_listCurrent();
			break;
		}
		
		/* Output */
		$this->registry->output->html_main .= $this->registry->output->global_template->global_frame_wrapper();
		$this->registry->output->sendOutput();	
	}
	
	/**
	 * View all logs for a given moderator
	 *
	 * @return	@e void		[Outputs to screen]
	 */
	protected function _view()
	{
		///----------------------------------------
		// Basic init
		//-----------------------------------------
		
		$start = intval($this->request['st']) >= 0 ? intval($this->request['st']) : 0;

		$botty	= IPSText::parseCleanValue( urldecode($this->request['bid'] ) );
		$botty	= str_replace( "&#33;", "!", $botty );
	
		///----------------------------------------
		// No bid or search string?
		//-----------------------------------------
		
		if ( !$this->request['search_string'] AND !$this->request['bid'] )
		{
			$this->registry->output->global_message = $this->lang->words['slog_nostring'];
			$this->_listCurrent();
			return;
		}
		
		///----------------------------------------
		// mid?
		//-----------------------------------------
		
		if ( !$this->request['search_string'] )
		{
			$row = $this->DB->buildAndFetch( array( 'select' => 'COUNT(sid) as count', 'from' => 'spider_logs', 'where' => "bot='{$botty}'" ) );

			$row_count = $row['count'];
			
			$query = "&amp;{$this->form_code}&amp;bid=" . $this->request['bid'] . "&amp;do=view";
			
			$this->DB->build( array( 'select'	=> '*',
										'from'	=> 'spider_logs',
										'where'	=> "bot='{$botty}'",
										'order'	=> 'entry_date DESC',
										'limit'	=> array( $start, 20 ) ) );
			$this->DB->execute();
		}
		else
		{
			$this->request['search_string'] =  IPSText::parseCleanValue( urldecode($this->request['search_string'] ) );
			
			$row = $this->DB->buildAndFetch( array( 'select' => 'COUNT(sid) as count', 'from' => 'spider_logs', 'where' => "query_string LIKE '%" . $this->request['search_string'] . "%'" ) );

			$row_count = $row['count'];
			
			$query = "&amp;{$this->form_code}&amp;do=view&amp;search_string=" . urlencode($this->request['search_string']);
			
			$this->DB->build( array( 'select'	=> '*',
										'from'	=> 'spider_logs',
										'where'	=> "(query_string LIKE '%" . $this->request['search_string'] . "%') OR (request_addr LIKE '%" . $this->request['search_string'] . "%')",
										'order'	=> 'entry_date DESC',
										'limit'	=> array( $start, 20 ) ) );
			$this->DB->execute();
		}
		
		///----------------------------------------
		// Page links
		//-----------------------------------------
		
		$links = $this->registry->output->generatePagination( array( 'totalItems'			=> $row_count,
																	 'itemsPerPage'			=> 20,
																	 'currentStartValue'	=> $start,
																	 'baseUrl'				=> $this->settings['base_url'] . $query,
														)
												 );
		
 		///----------------------------------------
		// Get db results
		//-----------------------------------------

		while ( $row = $this->DB->fetch() )
		{
			$extra = "";
			
			if( $row['query_string'] )
			{
				if ( stripos( '#lo-fi#i', $row['query_string'] ) !== false )
				{
					$extra = $this->lang->words['slog_lofi'];
					
					$query_string_html = $extra . ' ' . $row['query_string'];
				}
				else
				{
					$query_string_html = "<a href='" . $this->settings['board_url'] . "/index." . $this->settings['php_ext'] . "?{$row['query_string']}' target='_blank'>" . IPSText::truncate($row['query_string']) . "</a>";
				}
			}
			else
			{
				$query_string_html = "<a href='http://" . $_SERVER['HTTP_HOST'] . "{$row['request_addr']}' target='_blank'>" . IPSText::truncate($row['request_addr']) . "</a>";
			}
			
			$row['_bot_name']		= $this->bot_map[ mb_strtolower($row['bot']) ];
			$row['_query_string']	= $query_string_html;
			$row['_time']			= $this->registry->getClass('class_localization')->getDate( $row['entry_date'], 'LONG' );
			
			$rows[] = $row;
		}

		///----------------------------------------
		// And output
		//-----------------------------------------
		
		$this->registry->output->html .= $this->html->spiderlogsView( $rows, $links );
	}
	
	/**
	 * Remove logs by a moderator
	 *
	 * @return	@e void		[Outputs to screen]
	 */
	protected function _remove()
	{
		if ( $this->request['bid'] == "" )
		{
			$this->registry->output->showError( $this->lang->words['slog_nologs'], 11132 );
		}
		
		$botty	= urldecode($this->request['bid']);
		$botty	= str_replace( "&#33;", "!", $botty );
		
		$this->DB->delete( 'spider_logs', "bot='{$botty}'" );
		
		$this->registry->getClass('adminFunctions')->saveAdminLog($this->lang->words['slog_adminlog']);
		
		$this->registry->output->silentRedirect( $this->settings['base_url']."&amp;{$this->form_code}" );
	}
	
	
	/**
	 * List the current logs with links to view per-admin
	 *
	 * @return	@e void		[Outputs to screen]
	 */
	protected function _listCurrent()
	{
		$spiders = array();

		//-----------------------------------------
		// All bots
		//-----------------------------------------
		
		$this->DB->build( array( 'select'	=> 'count(*) as cnt, bot, max(entry_date) as entry_date',
									'from'	=> 'spider_logs',
									'group'	=> 'bot',
									'order'	=> 'entry_date DESC',
							)		);
		$this->DB->execute();
		
		while ( $r = $this->DB->fetch() )
		{
			$r['_bot_name']		= $this->bot_map[ strtolower($r['bot']) ];
			$r['_time']			= $this->registry->getClass('class_localization')->getDate( $r['entry_date'], 'SHORT' );
			$r['_bot_url']		= urlencode($r['bot']);
			
			$spiders[] = $r;
		}
			
		//-----------------------------------------
		// And output
		//-----------------------------------------
		
		$this->registry->output->html .= $this->html->spiderlogsWrapper( $spiders );
	}
}