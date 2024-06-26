<?php

 /**
 * @author -RAW-
 * @copyright 2012
 * @link http://rawcodes.net
 * @filesource It's the Final Countdown
 * @version 1.2.0
 */


if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded 'admin.php'.";
	exit();
}

/**
 *
 * @class		plugin_finalCountdown_countdown
 * @brief		Provide ability to share a countdown via editor
 */
class plugin_finalCountdown_countdown
{
	/**
	 * Registry Object Shortcuts
	 *
	 * @var		$registry
	 * @var		$DB
	 * @var		$settings
	 * @var		$request
	 * @var		$lang
	 * @var		$member
	 * @var		$memberData
	 * @var		$cache
	 * @var		$caches
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

	/**
	 * Constructor
	 *
	 * @param	object		$registry		Registry object
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry ) 
	{
		//-----------------------------------------
		// Make shortcuts
		//-----------------------------------------

		$this->registry		= $registry;
		$this->DB			= $this->registry->DB();
		$this->settings		=& $this->registry->fetchSettings();
		$this->request		=& $this->registry->fetchRequest();
		$this->member		= $this->registry->member();
		$this->memberData	=& $this->registry->member()->fetchMemberData();
		$this->cache		= $this->registry->cache();
		$this->caches		=& $this->registry->cache()->fetchCaches();
		$this->lang			= $this->registry->class_localization;
		
		$this->lang->loadLanguageFile( array( 'public_core' ), 'finalCountdown' );
	}
	
	/**
	 * Return the tab title
	 *
	 * @return	@e string
	 */
	public function getTab()
	{
		if( $this->memberData['member_id'] )
		{
			return $this->lang->words['finalCountdown_sharedMediaTab'];
		}
	}
	
	/**
	 * Return the HTML to display the tab
	 *
	 * @return	@e string
	 */
	public function showTab( $string )
	{
		//-----------------------------------------
		// Are we a member?
		//-----------------------------------------
		
		if( ! $this->memberData['member_id'] )
		{
			return '';
		}

		//-----------------------------------------
		// How many approved events do we have?
		//-----------------------------------------
		
		$st		= intval($this->request['st']);
		$each	= 30;
		$where	= '';
		
		if( $string )
		{
			$where	= " AND ( name LIKE '%{$string}%' )";
		}
		
		$myGroups    = array( $this->memberData['member_group_id'] );

 		if ( $this->memberData['mgroup_others'] )
 		{
	 		$myGroups = array_diff( array_merge( $myGroups, explode( ",", IPSText::cleanPermString( $this->memberData['mgroup_others']  ) ) ), array('') );
 		}
 		
		$where .= " AND " . $this->DB->buildWherePermission( $myGroups, 'groups_perm', true );
		
		$count	= $this->DB->buildAndFetch( array( 'select' => 'COUNT(*) as total', 'from' => 'countdowns', 'where' => "enabled=1 AND allow_embed=1" . $where ) );
		$rows	= array();
		
		$pages	= $this->registry->output->generatePagination( array(	'totalItems'		=> $count['total'],
																		'itemsPerPage'		=> $each,
																		'currentStartValue'	=> $st,
																		'seoTitle'			=> '',
																		'method'			=> 'nextPrevious',
																		'noDropdown'		=> true,
																		'ajaxLoad'			=> 'mymedia_content',
																		'baseUrl'			=> "app=core&amp;module=ajax&amp;section=media&amp;do=loadtab&amp;tabapp=finalCountdown&amp;tabplugin=countdown&amp;search=" . urlencode($string) ) );

		$this->DB->build( array( 	'select' 	=> '*', 
									'from' 		=> 'countdowns', 
									'where' 	=> "enabled=1 AND allow_embed=1" . $where, 
									'order' 	=> 'position DESC', 
									'limit' 	=> array( $st, $each ) ) );
		$outer	= $this->DB->execute();
		
		while( $r = $this->DB->fetch($outer) )
		{
			$rows[]	= array(
							'image'		=> $this->settings['public_dir'] . '/style_extra/finalCountdown/sharedmedia/countdown.png',
							'width'		=> 0,
							'height'	=> 0,
							'title'		=> IPSText::truncate( $r['name'], 25 ),
							'desc'		=> $this->lang->formatTime( $r['time'], 'long' ),
							'insert'	=> "finalCountdown:countdown:" . $r['id'],
							);
		}

		return $this->registry->output->getTemplate( 'finalCountdown' )->mediaCountdownWrapper( $rows, $pages, 'finalCountdown', 'countdown' );
	}

	/**
	 * Return the HTML output to display
	 *
	 * @param	int		$eventId	Event ID to show
	 * @return	@e string
	 */
	public function getOutput( $id=0 )
	{
		$id	= intval($id);
		
		if( ! $id )
		{
			return '';
		}

		$countdown	= $this->caches['countdowns'][ $id ];
		
		if ( ! is_array( $countdown ) OR ! count( $countdown ) )
		{
			return '';
		}
		
		if ( ! $countdown['enabled'] OR ! $countdown['allow_embed'] )
		{
			return '';
		}
		
		return $this->registry->output->getTemplate( 'finalCountdown' )->bbCodeCountdown( $countdown );
	}
	
	/**
	 * Verify current user has permission to post this
	 *
	 * @param	int		$eventId	Event ID to show
	 * @return	@e bool
	 */
	public function checkPostPermission( $id )
	{
		$id	= intval($id);

		if( ! $id )
		{
			return '';
		}
		
		if( $this->memberData['g_is_supmod'] OR $this->memberData['is_mod'] )
		{
			return '';
		}

		$countdown	= $this->caches['countdowns'][ $id ];
		
		if ( is_array( $countdown ) AND count( $countdown ) )
		{
			if ( $countdown['enabled'] AND $countdown['allow_embed'] )
			{
				if( $countdown['groups_perm'] == '*' OR IPSMember::isInGroup( $this->memberData, explode( ',', $countdown['groups_perm'] ) ) )
				{
					return '';
				}
			}
		}
		return 'no_permission_shared';
	}
}