<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * SQL installation methods
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		Matt Mecham
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @since		1st December 2008
 * @version		$Revision: 10721 $
 *
 */

class install_extra
{
	/**
	 * Errors
	 *
	 * @access	public
	 * @var		array
	 */
	public $errors		= array();
	
	/**
	 * Extra info
	 *
	 * @access	public
	 * @var		array
	 */	
	public $info_extra	= array();
	
	/**
	 * Set Prefix
	 *
	 * @access	public
	 * @var		string
	 */	
	public $prefix		= '';
	
	/**
	 * Constructor
	 *
	 * @access	public
	 * @param	object	Registry reference
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry )
	{
		/* Make registry objects */
		$this->registry = $registry;
		$this->DB       = $this->registry->DB();
		$this->settings =& $this->registry->fetchSettings();
		$this->request  =& $this->registry->fetchRequest();
	}
	
	/**
	 * Set db prefix
	 *
	 * @access	public
	 * @param	object	Registry reference
	 * @return	@e void
	 */
	public function setDbPrefix( $prefix='' )
	{
		if( $prefix )
		{
			$this->prefix	= $prefix;
			return;
		}
		else if( class_exists( 'IPSSetUp' ) )
		{
			if ( IPSSetUp::getSavedData('db_pre') )
			{
				$this->prefix	= IPSSetUp::getSavedData('db_pre');
				return;
			}
		}
		
		/* Still 'ere? */
		$this->prefix	= $this->settings['sql_tbl_prefix'];
	}
	
	/**
	 * before_inserts_run
	 * Allows one to run SQL commands before any inserts are run
	 *
	 * Use ipsRegistry::DB()->query("") to run queries
	 *
	 * @access	public
	 * @param	string	Type of inserts to run
	 * @return	@e void
	 */
	public function before_inserts_run( $type )
	{
		switch( $type )
		{
			case 'applications':
			case 'modules':
			case 'settings':
			case 'system_templates':
			case 'content_templates':
			case 'tasks':
			case 'bbcode':
			case 'media':
			case 'languages':
			case 'login':
			case 'groups':
			case 'staff_roles':
			case 'attachments':
			case 'skinset':
			case 'email_templates':
			case 'caches':
			break;
		}
	}
	
	/**
	 * after_inserts_run
	 * Allows one to run SQL commands AFTER any inserts are run
	 *
	 * Use ipsRegistry::DB()->query("") to run queries
	 *
	 * @access	public
	 * @param	string	Type of inserts to run
	 * @return	@e void
	 */
	public function after_inserts_run( $type )
	{
		switch( $type )
		{
			case 'applications':
			case 'modules':
			case 'settings':
			case 'system_templates':
			case 'content_templates':
			case 'tasks':
			case 'bbcode':
			case 'media':
			case 'languages':
			case 'login':
			case 'groups':
			case 'staff_roles':
			case 'attachments':
			case 'skinset':
			case 'email_templates':
			case 'caches':
			break;
		}
	}
	
	/**
	 * Alter create table statements before being run
	 *
	 * @access	public
	 * @param	string	Query
	 * @return	string	Query
	 */
	public function process_query_create( $query )
	{
		$this->setDbPrefix();

		//-----------------------------------------
		// Tack on the end the chosen table type
		//-----------------------------------------
	
		if ( $this->prefix )
		{
			$query = preg_replace( "#^(CREATE TABLE\s+(?:IF NOT EXISTS\s+)?)(\S+?)#s", "\\1 " . $this->prefix."\\2", $query );
			$query = preg_replace( "#^INSERT INTO(?:\s+?)?(\S+?)#s" , "INSERT INTO "  . $this->prefix."\\1" , $query );
			$query = preg_replace( "#^REPLACE INTO(?:\s+?)?(\S+?)#s", "REPLACE INTO " . $this->prefix."\\1", $query );
			$query = preg_replace( "#^ALTER TABLE(?:\s+?)?(\S+?)#s" , "ALTER TABLE "  . $this->prefix."\\1" , $query );
			$query = preg_replace( "#^DELETE FROM(?:\s+?)?(\S+?)#s" , "DELETE FROM "  . $this->prefix."\\1" , $query );
			$query = preg_replace( "#^UPDATE(?:\s+?)?(\S+?)#s" , "UPDATE "  . $this->prefix."\\1" , $query );
		}
		
		$table_type = $this->settings['mysql_tbl_type'] ? $this->settings['mysql_tbl_type'] : 'MyISAM';
		
		return preg_replace( "#\);$#", ") ENGINE=".$table_type.";", $query );
	}
	
	/**
	 * Alter create index statements before being run
	 *
	 * @access	public
	 * @param	string	Query
	 * @return	string	Query
	 */
	public function process_query_index( $query )
	{
		$this->setDbPrefix();
		
		//-----------------------------------------
		// Tack on the end the chosen table type
		//-----------------------------------------
		
		if ( $this->prefix )
		{
			$query = preg_replace( "#^(CREATE TABLE\s+(?:IF NOT EXISTS\s+)?)(\S+?)#s", "\\1 " . $this->prefix."\\2", $query );
			$query = preg_replace( "#^INSERT INTO(?:\s+?)?(\S+?)#s" , "INSERT INTO "  . $this->prefix."\\1" , $query );
			$query = preg_replace( "#^REPLACE INTO(?:\s+?)?(\S+?)#s", "REPLACE INTO " . $this->prefix."\\1", $query );
			$query = preg_replace( "#^ALTER TABLE(?:\s+?)?(\S+?)#s" , "ALTER TABLE "  . $this->prefix."\\1" , $query );
			$query = preg_replace( "#^DELETE FROM(?:\s+?)?(\S+?)#s" , "DELETE FROM "  . $this->prefix."\\1" , $query );
			$query = preg_replace( "#^UPDATE(?:\s+?)?(\S+?)#s" , "UPDATE "  . $this->prefix."\\1" , $query );
		}
		
		return $query;
	}
	
	/**
	 * Alter insert statements before being run
	 *
	 * @access	public
	 * @param	string	Query
	 * @return	string	Query
	 */
	public function process_query_insert( $query )
	{
		$this->setDbPrefix();
		
		//-----------------------------------------
		// Tack on the end the chosen table type
		//-----------------------------------------
		
		if ( $this->prefix )
		{
			$query = preg_replace( "#^(CREATE TABLE\s+(?:IF NOT EXISTS\s+)?)(\S+?)#s", "\\1 " . $this->prefix."\\2", $query );
			$query = preg_replace( "#^INSERT INTO(?:\s+?)?(\S+?)#s" , "INSERT INTO "  . $this->prefix."\\1" , $query );
			$query = preg_replace( "#^REPLACE INTO(?:\s+?)?(\S+?)#s", "REPLACE INTO " . $this->prefix."\\1", $query );
			$query = preg_replace( "#^ALTER TABLE(?:\s+?)?(\S+?)#s" , "ALTER TABLE "  . $this->prefix."\\1" , $query );
			$query = preg_replace( "#^DELETE FROM(?:\s+?)?(\S+?)#s" , "DELETE FROM "  . $this->prefix."\\1" , $query );
			$query = preg_replace( "#^UPDATE(?:\s+?)?(\S+?)#s" , "UPDATE "  . $this->prefix."\\1" , $query );
		}
		
		return $query;
	}
	
	/**
	 * Return additional HTML to show on install form
	 *
	 * @access	public
	 * @return	string	HTML
	 */
	public function install_form_extra()
	{
		$extra = "<tr>
					<td class='title'><b>Тип таблиц MySQL</b><div style='color:gray'>Используйте MyISAM если не уверены</div></td>
					<td class='content'><select name='mysql_tbl_type' class='sql_form'><option value='MyISAM'>MYISAM</option><option value='INNODB'>INNODB</option></td>
				  </tr>";
	
		return $extra;
	
	}
	
	/**
	 * Save additional info from install form
	 *
	 * @access	public
	 * @return	@e void
	 */
	public function install_form_process()
	{
		//-----------------------------------------
		// When processed, return all vars to save
		// in conf_global in the array $this->info_extra
		// This will also be saved into $INFO[] for
		// the installer
		//-----------------------------------------
		
		if ( ! $_REQUEST['mysql_tbl_type'] )
		{
			$this->errors[] = 'Вы должны заполнить все необходимые поля!';
			return;
		}
		
		$this->info_extra['mysql_tbl_type'] = $_REQUEST['mysql_tbl_type'];
	}

}