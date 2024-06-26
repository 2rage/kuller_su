<?php
/**
 * @file		warnings.php 	Task to optimize database tables daily
 * $Copyright: © 2011 Invision Power Services, Inc.$
 * $License: http://www.invisionpower.com/company/standards.php#license$
 * $Author: mark $
 * @since		-
 * $LastChangedDate: 2012-09-17 11:58:03 -0400 (Mon, 17 Sep 2012) $
 * @version		v3.4.2
 * $Revision: 11341 $
 */

if ( ! defined( 'IN_IPB' ) )
{
	print "<h1>Incorrect access</h1>You cannot access this file directly. If you have recently upgraded, make sure you upgraded all the relevant files.";
	exit();
}

/**
 *
 * @class		task_item
 * @brief		Task to optimize database tables daily
 *
 */
class task_item
{	
	/**
	 * Object that stores the parent task manager class
	 *
	 * @var		$class
	 */
	protected $class;
	
	/**
	 * Array that stores the task data
	 *
	 * @var		$task
	 */
	protected $task = array();
	
	/**
	 * Registry Object Shortcuts
	 *
	 * @var		$registry
	 * @var		$DB
	 * @var		$lang
	 */
	protected $registry;
	protected $DB;
	protected $lang;
	
	/**
	 * Constructor
	 *
	 * @param	object		$registry		Registry object
	 * @param	object		$class			Task manager class object
	 * @param	array		$task			Array with the task data
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry, $class, $task )
	{
		/* Make registry objects */
		$this->registry	= $registry;
		$this->DB		= $this->registry->DB();
		$this->lang		= $this->registry->getClass('class_localization');
		
		$this->class	= $class;
		$this->task		= $task;
	}
	
	/**
	 * Run this task
	 * 
	 * @return	@e void
	 */
	public function runTask()
	{
		//-----------------------------------------
		// Do it
		//-----------------------------------------
		
		$this->DB->build( array(
			'select'	=> '*',
			'from'		=> 'members_warn_logs',
			'where'		=> 'wl_expire>0 AND wl_expire_date>0 AND wl_expire_date<=' . time(),
			'order'		=> 'wl_date ASC',
			'limit'		=> array( 0, 250 )
			) );
		$e = $this->DB->execute();
		while ( $r = $this->DB->fetch( $e ) )
		{
			$this->DB->update( 'members', "warn_level=warn_level-{$r['wl_points']}", "member_id={$r['wl_member']}", FALSE, TRUE );
			$this->DB->update( 'members_warn_logs', array( 'wl_expire_date' => 0 ), "wl_id={$r['wl_id']}" );
		}
		
		//-----------------------------------------
		// Check we haven't done anything silly
		//-----------------------------------------
		
		$this->DB->update( 'members', array( 'warn_level' => 0 ), "warn_level<0" );
		
		//-----------------------------------------
		// Finish
		//-----------------------------------------
		
		/* Log to log table - modify but dont delete */
		$this->registry->getClass('class_localization')->loadLanguageFile( array( 'public_global' ), 'core' );
		$this->class->appendTaskLog( $this->task, $this->lang->words['task__warnings'] );
		
		/* Unlock Task: DO NOT MODIFY! */
		$this->class->unlockTask( $this->task );
	}
}