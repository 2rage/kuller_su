<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Installer: EULA file
 * Last Updated: $LastChangedDate: 2012-11-02 08:18:10 -0400 (Fri, 02 Nov 2012) $
 * </pre>
 *
 * @author 		$Author: mark $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @version		$Rev: 11548 $
 *
 */


class install_db extends ipsCommand
{	
	/**
	 * Execute selected method
	 *
	 * @access	public
	 * @param	object		Registry object
	 * @return	@e void
	 */
	public function doExecute( ipsRegistry $registry ) 
	{
		/* Dealing with the result of the form asking for DB input */
		if ( $this->request['do'] == 'check' )
		{
			/* Make sure the fields were filled out */			
			if ( ! $this->request['overwrite'] AND ( ! $this->request['db_host'] || ! $this->request['db_name'] || ! $this->request['db_user'] ) )
			{
				$this->registry->output->addWarning( 'Необходимо полностью заполнить форму' );
			}
			/* No special characters */
			else if( preg_match( "/[^a-zA-Z0-9_]/", $this->request['db_pre'] ) )
			{
				$this->registry->output->addWarning( 'Нельзя использовать специальные символы в префиске таблиц' );
			}
			else 
			{
				//-----------------------------------------
				// Quick basic check for extensions
				//-----------------------------------------
				
				if( strtolower(IPSSetUp::getSavedData('sql_driver')) == 'mysql' )
				{
					if( !function_exists('mysqli_connect') AND !function_exists('mysql_connect') )
					{
						$this->registry->output->setTitle( "Databases: Error" );
						$this->registry->output->setNextAction( 'db&do=check' );
						$this->registry->output->addWarning( "You do not have the mysql or mysqli PHP extension installed.  You must install one of these PHP extensions before you can continue." );
						$this->registry->output->addContent( $this->fetchContent() );
						$this->registry->output->sendOutput();
						return;
					}
				}

				//-----------------------------------------
				// Load DB driver..
				//-----------------------------------------
				
				require_once( IPS_KERNEL_PATH . 'classDb' . ucwords( IPSSetUp::getSavedData('sql_driver') ) . '.php' );/*noLibHook*/
				
				$classname = "db_driver_".IPSSetUp::getSavedData('sql_driver');
	
				$DB = new $classname;
	
				$DB->obj['sql_database']   = $this->request['db_name'];
				$DB->obj['sql_user']	   = $this->request['db_user'];
				$DB->obj['sql_pass']	   = $_REQUEST['db_pass'];
				$DB->obj['sql_host']	   = $this->request['db_host'];
				$DB->obj['sql_tbl_prefix'] = $this->request['db_pre'];
								
				//--------------------------------------------------
				// Any "extra" configs required for this driver?
				//--------------------------------------------------
	
				if ( is_file( IPS_ROOT_PATH . 'setup/sql/'.IPSSetUp::getSavedData('sql_driver').'_install.php' ) )
				{
					require_once( IPS_ROOT_PATH . 'setup/sql/'.IPSSetUp::getSavedData('sql_driver').'_install.php' );/*noLibHook*/
	
					$extra_install =  new install_extra( $this->registry );
	
					$extra_install->install_form_process();
	
					if ( count( $extra_install->errors ) )
					{
						$this->registry->output->addWarning( implode( "<br />", $extra_install->errors ) );
					}
					
					if ( is_array( $extra_install->info_extra ) and count( $extra_install->info_extra ) )
					{ 
						foreach( $extra_install->info_extra as $k => $v )
						{
							IPSSetUp::setSavedData( '__sql__' . $k, $v );
						}
					}
					
					if ( is_array( $DB->connect_vars ) and count( $DB->connect_vars ) )
					{
						foreach( $DB->connect_vars as $k => $v )
						{
							$DB->connect_vars[ $k ] = $extra_install->info_extra[ $k ];
						}
					}
				}
				
				//-----------------------------------------
				// Error check
				//-----------------------------------------
								
				if ( count( $extra_install->errors ) )
				{
					$this->registry->output->setTitle( "База данных: Ошибка" );
					$this->registry->output->setNextAction( 'db&do=check' );
					$this->registry->output->addContent( $this->fetchContent() );
					$this->registry->output->sendOutput();
					return;
				}
				
				//------------------------------------------
				// Make CONSTANT
				//------------------------------------------
				
				define( 'SQL_DRIVER'              , IPSSetUp::getSavedData('sql_driver') );
				define( 'IPS_MAIN_DB_CLASS_LOADED', TRUE );
	
				//------------------------------------------
				// Try a DB connection
				//------------------------------------------
				
				$DB->return_die = true;
	
				if ( ! $DB->connect() )
				{
					$errors[] = $DB->error;
				}
								
				//-----------------------------------------
				// Error check
				//-----------------------------------------
				
				if ( is_array( $errors ) AND count( $errors ) )
				{
					$this->registry->output->setTitle( "База данных: Ошибка" );
					$this->registry->output->setNextAction( 'db&do=check' );
					$this->registry->output->addWarning( implode( "<br />", $errors ) );
					$this->registry->output->addContent( $this->fetchContent() );
					$this->registry->output->sendOutput();
					return;
				}
				
				/* Save Form Data */
				IPSSetUp::setSavedData('db_host', $_REQUEST['db_host'] );
				IPSSetUp::setSavedData('db_name', $this->request['db_name'] );
				IPSSetUp::setSavedData('db_user', $this->request['db_user'] );
				IPSSetUp::setSavedData('db_pass', $_REQUEST['db_pass'] );
				IPSSetUp::setSavedData('db_pre' , $this->request['db_pre'] );
				
				/* Are we overwriting an IP.Board 2.x or 3.x installation? */
				if ( ! $this->request['overwrite'] )
				{
					if ( $DB->checkForTable( 'upgrade_history' ) )
					{
						/* Get latest version */
						$latest = $DB->buildAndFetch( array( 'select' => '*',
															 'from'   => 'upgrade_history',
															 'where'  => "upgrade_app='core'",
															 'order'  => 'upgrade_version_id DESC',
															 'limit'  => array( 0, 1 ) ) );

						if ( is_array( $latest ) )
						{
							$this->registry->output->setTitle( "База данных: Ошибка" );
							$this->registry->output->setNextAction( 'db&do=check' );
							$this->registry->output->addWarning( "Обнаружена установленная IP.Board " . $latest['upgrade_version_human'] );
							$this->registry->output->addContent( $this->fetchContent( TRUE ) );
							$this->registry->output->sendOutput();
							return;
						}
					}
				}
				
				/* Next Action */
				$this->registry->autoLoadNextAction( 'admin' );
				return;
			}
		}
		
		//--------------------------------------------------
		// DO WE HAVE A DB DRIVER SET?
		//--------------------------------------------------

		IPSSetUp::setSavedData('sql_driver', strtolower( ( IPSSetUp::getSavedData('sql_driver') == "" ) ? $_REQUEST['sql_driver'] : IPSSetUp::getSavedData('sql_driver') ) );

		if ( ! IPSSetUp::getSavedData('sql_driver') )
		{
			//----------------------------------------------
			// Test to see how many DB driver's we've got..
			//----------------------------------------------

			$dh = opendir( IPS_KERNEL_PATH );

			while ( $file = @readdir( $dh ) )
			{
				if ( preg_match( "/^classDb([a-zA-Z0-9]*)\.php/i", $file, $driver ) )
				{
					if ( stristr( $driver[1], 'client' ) OR ! $driver[1] )
					{
						continue;
					}
					
					$drivers[] = $driver[1];
				}
			}

	 		@closedir( $dh );

	 		//----------------------------------------------
	 		// Got more than one?
	 		//----------------------------------------------

	 		if ( count($drivers) > 1 )
	 		{
	 			//------------------------------------------
	 			// Show choice screen first...
	 			//------------------------------------------
				
				/* Page Output */
				$this->registry->output->setTitle( "База данных" );
				$this->registry->output->setNextAction( 'db' );
				$this->registry->output->addContent( $this->registry->output->template()->page_check_db( $drivers ) );
				$this->registry->output->sendOutput();
	 		}
	 		else
	 		{
	 			//------------------------------------------
	 			// Use only driver installed
	 			//------------------------------------------

	 			IPSSetUp::setSavedData( 'sql_driver', strtolower($drivers[0]) );
	 		}
		}
		
		$this->request['db_host'] = ( $this->request['db_host'] ) ? $this->request['db_host'] : 'localhost';
		
		$this->registry->output->setTitle( "База данных" );
		$this->registry->output->setNextAction( 'db&do=check' );
		$this->registry->output->addContent( $this->fetchContent() );
		$this->registry->output->sendOutput();
	}
	
	/**
	 * Fetch content 
	 *
	 * @access	public
	 * @param	bool
	 * @return	string
	 */
	public function fetchContent( $check=FALSE )
	{
		/* Output */
		$content = ( $check === FALSE ) ? $this->registry->output->template()->page_db() : $this->registry->output->template()->page_dbOverride();
		
		/* Driver extras? */
		if ( is_file( IPS_ROOT_PATH . 'setup/sql/'.IPSSetUp::getSavedData('sql_driver').'_install.php' ) )
		{
			require_once( IPS_ROOT_PATH . 'setup/sql/'.IPSSetUp::getSavedData('sql_driver').'_install.php' );/*noLibHook*/
			$extra_install = new install_extra( $this->registry );

			$content = str_replace( '<!--{EXTRA.SQL}-->', $extra_install->install_form_extra(), $content );
		}
		
		return $content;
	}
}