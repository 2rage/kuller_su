<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Installer: EULA file
 * Last Updated: $LastChangedDate: 2012-09-27 06:09:08 -0400 (Thu, 27 Sep 2012) $
 * </pre>
 *
 * @author 		$Author: mark $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @version		$Rev: 11386 $
 *
 */


class install_install extends ipsCommand
{
	/**
	 * Step count
	 *
	 * @access	private
	 * @var		int
	 */
	private $_stepCount = 0;

	/**
	 * Total number of steps
	 *
	 * @access	private
	 * @var		int
	 */
	private $_totalSteps = 13;

	/**
	 * Skin keys
	 * Now we could do some fancy method that grabs the keys from an XML file or whatever
	 * But as they are unlikely to change with any frequency, this should suffice.
	 *
	 * @access	private
	 * @var		array
	 */
	private $_skinKeys = array( 1 => 'default', 'xmlskin', 'lofi' );
	private $_skinIDs  = array( 1, 2, 3 );

	/** 
	 * Default Application Orders
	 *
	 * @var		array
	 */
	private $forcePositions = array(
		'core'		=> 1,
		'forums'	=> 2,
		'members'	=> 3
		);

	/**
	 * Execute selected method
	 * SQL > APPLICATIONS -> MODULES -> SETTINGS  > TEMPLATES > TASKS > LANGUAGES > PUBLIC LANGUAGES > BBCODE > ACP HELP OTHER [ Email Templates ] > Build Caches
	 *
	 * @access	public
	 * @param	object		Registry object
	 * @return	@e void
	 */
	public function doExecute( ipsRegistry $registry )
	{
		//-----------------------------------------
		// Any "extra" configs required for this driver?
		//-----------------------------------------
		
		foreach( IPSSetUp::getSavedDataAsArray() as $k => $v )
		{
			if ( preg_match( "#^__sql__#", $k ) )
			{
				$k = str_replace( "__sql__", "", $k );

				IPSSetUp::setSavedData( $k, $v );
			}
		}
		
		/* Switch */
		switch( $this->request['do'] )
		{
			case 'sql':
				$this->_stepCount = 1;
				$this->install_sql();
			break;

			case 'sql_steps':
				$this->_stepCount = 2;
				$this->install_sql_steps();
			break;

			case 'applications':
				$this->_stepCount = 3;
				$this->install_applications();
			break;

			case 'modules':
				$this->_stepCount = 4;
				$this->install_modules();
			break;

			case 'settings':
				$this->_stepCount = 5;
				$this->install_settings();
			break;

			case 'templates':
				$this->_stepCount = 6;
				$this->install_templates();
			break;

			case 'tasks':
				$this->_stepCount = 7;
				$this->install_tasks();
			break;

			case 'languages':
				$this->_stepCount = 8;
				$this->install_languages();
			break;

			case 'clientlanguages':
				$this->_stepCount = 9;
				$this->install_client_languages();
			break;

			case 'bbcode':
				$this->_stepCount = 10;
				$this->install_bbcode();
			break;

			case 'acphelp':
				$this->_stepCount = 11;
				$this->install_acphelp();
			break;

			case 'other':
				$this->_stepCount = 12;
				$this->install_other();
			break;

			case 'caches':
				$this->_stepCount = 13;
				$this->install_caches();
			break;

			default:
				/* Output */
				$this->registry->output->setTitle( "Установка" );
				$this->registry->output->setNextAction( 'install&do=sql' );
				$this->registry->output->setHideButton( TRUE );
				$this->registry->output->addContent( $this->registry->output->template()->page_install() );
				$this->registry->output->sendOutput();
			break;
		}
	}

	/**
	 * Installs SQL schematic
	 *
	 * @return void
	 */
	public function install_sql()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];
		$skip     = $_REQUEST['_skip'];

		//-----------------------------------------
		// Write config
		//-----------------------------------------

		if ( ! $previous AND ! $skip )
		{
			/* Write Configuration Files */
			$output[] = 'Запись файлов конфигурации<br />';

			$test = IPSInstall::writeConfiguration();

			//-----------------------------------
			// Check that it wrote
			//-----------------------------------

			if ( ! is_file( IPSSetUp::getSavedData('install_dir') . '/conf_global.php' ) )
			{
				$this->registry->output->setTitle( "Установка: Ошибка" );
				$this->registry->output->setNextAction( 'install&do=sql' );
				$this->registry->output->setHideButton( TRUE );
				$this->registry->output->addError( "Невозможна запись конфигурации в файл conf_global.php.  Пожалуйста, убедитесь, что файл имеет полный доступ на чтение и запись." );
				$this->registry->output->addContent( "" );
				$this->registry->output->sendOutput();

				exit();
			}
			else
			{
				$INFO = array();

				require( IPSSetUp::getSavedData('install_dir') . '/conf_global.php' );/*noLibHook*/

				if( ! $INFO['sql_driver'] )
				{
					$this->registry->output->setTitle( "Установка: Ошибка" );
					$this->registry->output->setNextAction( 'install&do=sql' );
					$this->registry->output->setHideButton( TRUE );
					$this->registry->output->addError( "Невозможна запись конфигурации в файл conf_global.php.  Пожалуйста, убедитесь, что файл имеет полный доступ на чтение и запись." );
					$this->registry->output->addContent( "" );
					$this->registry->output->sendOutput();

					exit();
				}
			}
		}

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );
		
		//-----------------------------------------
		// Import System Templates
		// We have to do this here un case we counter a driver error
		//-----------------------------------------
		
		require_once( IPS_ROOT_PATH . 'sources/classes/output/systemTemplates.php' );/*noLibHook*/
		$systemTemplates = new systemTemplates();
		$systemTemplates->writeDefaults();

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '', $this->settings['gb_char_set'] );

		if ( $next['key'] )
		{
			//-----------------------------------------
			// INIT
			//-----------------------------------------

			$_PATH = IPSLib::getAppDir( $next['key'] ) . '/setup/versions/install/sql/';
			$_FILE = $_PATH . $next['key'] . '_' . strtolower( IPSSetUp::getSavedData('sql_driver') );

			//-----------------------------------------
			// Tables
			//-----------------------------------------

			if ( is_file( $_FILE . '_tables.php' ) )
			{
				$TABLE = array();
				include( $_FILE . '_tables.php' );/*noLibHook*/

				if ( is_array( $TABLE ) and count( $TABLE ) )
				{
					$output[] = $next['title'] . ": Создание таблиц";
				
					foreach( $TABLE as $q )
					{
						preg_match("/CREATE TABLE (\S+)(\s)?\(/", $q, $match);

						if ( $match[1] )
						{
							$this->DB->dropTable( str_replace( IPSSetUp::getSavedData('db_pre'), '', $match[1] ) );
						}

						if ( $extra_install AND method_exists( $extra_install, 'process_query_create' ) )
						{
							 $q = $extra_install->process_query_create( $q );
						}

						$this->DB->allow_sub_select 	= 1;
						$this->DB->error				= '';

						$this->DB->query( $q );

						if ( $this->DB->error )
						{
							$this->registry->output->addError( nl2br( $q ) . "<br /><br />".$this->DB->error );
						}
					}
				}
			}

			//---------------------------------------------
			// Create the fulltext index...
			//---------------------------------------------

			if ( $this->DB->checkFulltextSupport() )
			{
				if ( is_file( $_FILE . '_fulltext.php' ) )
				{
					$INDEX = array();
					include( $_FILE . '_fulltext.php' );/*noLibHook*/

					if( is_array($INDEX) AND count($INDEX) )
					{
						$output[] = $next['title'] . ": Создание индексов";

						foreach( $INDEX as $q )
						{
							//---------------------------------------------
							// Pass to handler
							//---------------------------------------------

							if ( $extra_install AND method_exists( $extra_install, 'process_query_index' ) )
							{
								 $q = $extra_install->process_query_index( $q );
							}

							//---------------------------------------------
							// Pass query
							//---------------------------------------------

							$this->DB->allow_sub_select 	= 1;
							$this->DB->error				= '';

							$this->DB->query($q);

							if ( $this->DB->error )
							{
								$this->registry->output->addError( nl2br( $q ) . "<br /><br />".$this->DB->error );
							}
						}
					}
				}
			}

			//-----------------------------------------
			// INSERTS
			//-----------------------------------------

			if ( is_file( $_FILE . '_inserts.php' ) )
			{
				$INSERT = array();
				include( $_FILE . '_inserts.php' );/*noLibHook*/

				if ( is_array($INSERT) && count($INSERT) )
				{
					$output[] = $next['title'] . ": Наполнение таблиц";
					
					foreach( $INSERT as $q )
					{
						$q = str_replace( "<%time%>", time(), $q );
						$q = str_replace( '<%admin_name%>'   , IPSSetUp::getSavedData('admin_user'), $q );
						$q = str_replace( '<%admin_seoname%>', IPSText::makeSeoTitle( IPSSetUp::getSavedData('admin_user') ), $q );
	
						//---------------------------------------------
						// Pass to handler
					 	//---------------------------------------------
	
					 	if ( $extra_install AND method_exists( $extra_install, 'process_query_insert' ) )
					 	{
							$q = $extra_install->process_query_insert( $q );
						}
	
						$this->DB->allow_sub_select 	= 1;
						$this->DB->error				= '';
	
						$this->DB->query( $q );
	
						if ( $this->DB->error )
						{
							$this->registry->output->addError( nl2br( $q ) . "<br /><br />".$this->DB->error );
						}
					}
				}
			}
		
			//-----------------------------------------
			// Sort out groups
			// This has to be here so the applications
			// can populate group settings appropriately
			//-----------------------------------------
			
			if ( $next['key'] == 'core' )
			{

				$output[] = "Добавление информации о группах...";
				$xml    = new classXML( IPSSetUp::charSet );
	
				if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
				{
					 $q = $extra_install->before_inserts_run( 'groups' );
				}
	
				$xml->load( IPS_ROOT_PATH . 'setup/xml/groups.xml' );
	
				foreach( $xml->fetchElements( 'row' ) as $xmlelement )
				{
					$data = $xml->fetchElementsFromRecord( $xmlelement );
					
					$this->DB->insert( 'groups', $data );
				}
	
				if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
				{
					 $q = $extra_install->after_inserts_run( 'groups' );
				}
			
			}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$output = ( is_array( $output ) AND count( $output ) ) ? $output : array( 0 => $next['title'] . ": Наполнение таблиц завершено" );

			$this->_finishStep( $output, "Установка: SQL", 'install&do=sql&previous=' . $next['key'] );
		}
		else
		{
			//-----------------------------------------
			// NO MORE TO INSTALL
			//-----------------------------------------

			$output[] = "Действия SQL завершены";

			IPSInstall::createAdminAccount();

			//-----------------------------------------
			// Next...
			//-----------------------------------------

			$output = ( is_array( $output ) AND count( $output ) ) ? $output : array( 0 => $next['title'] . ": Наполнение таблиц завершено" );

			$this->_finishStep( $output, "Установка: SQL", 'install&do=sql_steps' );
		}
	}

	/**
	 * Installs extra sql statements
	 *
	 * @return void
	 */
	public function install_sql_steps()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$output    = array();
		$errors    = array();
		$id        = intval( $this->request['id'] );
		$sql_files = array();
		$previous  = $_REQUEST['previous'];
		$skip      = $_REQUEST['_skip'];
		$next      = IPSSetUp::fetchNextApplication( $previous, '', $this->settings['gb_char_set'] );

		//-----------------------------------------
		// Got one to run?
		//-----------------------------------------

		if( $next['key'] )
		{
			$path = IPSLib::getAppDir( $next['key'] ) . '/setup/versions/install';
			$id   = ( $id < 1 ) ? 1 : $id;

			if ( is_file( $path . '/sql/' .$next['key'] . '_' . strtolower( IPSSetUp::getSavedData('sql_driver') )  . '_sql_' . $id .'.php' ) )
			{
				/* Set up DB driver */
				$extra_install = $this->_setUpDBDriver( FALSE );

				/* Increment ID */
				$new_id = $id + 1;
				$count  = 0;

				/* Get the SQL File */
				$SQL = array();
				require_once( $path . '/sql/' . $next['key'] . '_' . strtolower( IPSSetUp::getSavedData('sql_driver') )  . '_sql_' . $id .'.php' );/*noLibHook*/
				
				if ( is_array( $SQL ) && count( $SQL ) )
				{
					/* Loop through the queries */
					foreach( $SQL as $query )
					{
						/* Setup */
						$this->DB->allow_sub_select 	= 1;
						$this->DB->error				= '';
	
						$query = str_replace( "<%time%>", time(), $query );
	
						/* Process the query */
					 	if ( $extra_install AND method_exists( $extra_install, 'process_query_insert' ) )
					 	{
							$query = $extra_install->process_query_insert( $query );
						}
	
						/* Run the query */
						$this->DB->query( $query );
	
						if ( $this->DB->error )
						{
							$this->registry->output->addError( $query."<br /><br />".$this->DB->error );
						}
						else
						{
							$count++;
						}
					}
	
					$output[] = "$count запросов выполнено";
				}
				else
				{
					$output[] = "Нет SQL запросов на данном шаге...";
				}

				$previous = $_REQUEST['previous'];
			}
			else
			{
				$previous = $next['key'];
			}

			$output = ( is_array( $output ) AND count( $output ) ) ? $output : array( 0 => $next['title'] . ": SQL запросы выполнены" );

			$this->_finishStep( $output, "Установка: SQL", 'install&do=sql_steps&amp;previous=' . $previous . '&amp;id=' . $new_id );
		}
		else
		{
			$output[] = "Все SQL запросы выполнены";

			$this->_finishStep( $output, "Установка: SQL", 'install&do=applications' );
		}
	}

	/**
	 * Install Applications
	 *
	 * @return void
	 */
	public function install_applications()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];
		$num      = intval( $_REQUEST['num'] ) + 1;

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		//-----------------------------------------
		// Install APP Data
		//-----------------------------------------

		if ( $next['key'] )
		{
			$output[]     = $next['title'] . ": Добавление данных приложений";
			$_PATH        = IPSLib::getAppDir( $next['key'] ) .  '/xml/';
			$_protected   = ( in_array( $next['key'], array( 'core', 'forums', 'members' ) ) ) ? 1 : 0;
			$version      = '1.0.0';
			$long_version = '10000';
			$_versions    = array();

			if ( is_file( $_PATH . 'versions.xml' ) )
			{
				require_once( IPS_KERNEL_PATH . 'classXML.php' );/*noLibHook*/
				$xml    = new classXML( IPSSetUp::charSet );

				$xml->load( $_PATH . 'versions.xml' );

				foreach( $xml->fetchElements( 'version' ) as $xmlelement )
				{
					$data = $xml->fetchElementsFromRecord( $xmlelement );

					$_versions[ $data['long'] ] = $data;
				}

				krsort( $_versions );

				$_this_version = current( $_versions );
				$version       = $_this_version['human'];
				$long_version  = $_this_version['long'];
			}

			if ( is_file( $_PATH . 'information.xml' ) )
			{
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
				{
					 $q = $extra_install->before_inserts_run( 'applications' );
				}

				//-----------------------------------------
				// Continue
				//-----------------------------------------

				$appData = IPSSetUp::fetchXmlAppInformation( $next['key'], $this->settings['gb_char_set'] );

				//-----------------------------------------
				// Insert...
				//-----------------------------------------
				
				$this->DB->insert( 'core_applications', array(  'app_title'			=> $appData['name'],
																'app_public_title'	=> ( $appData['public_name'] ) ? $appData['public_name'] : '',	// Allow blank in case it's an admin-only app
																'app_description'	=> $appData['description'],
																'app_author'		=> $appData['author'],
																'app_hide_tab'		=> intval($appData['hide_tab']),
																'app_version'		=> $version,
																'app_long_version'	=> $long_version,
																'app_directory'		=> $next['key'],
																'app_added'			=> time(),
																'app_position'		=> isset( $this->forcePositions[ $next['key'] ] ) ? $this->forcePositions[ $next['key'] ] : $num,
																'app_protected'		=> $_protected,
																'app_location'		=> IPSLib::extractAppLocationKey( $next['key'] ),
																'app_enabled'		=> $appData['disabledatinstall'] ? 0 : 1,
																'app_website'		=> $appData['website'],
																'app_update_check'	=> $appData['update_check'],
																'app_global_caches'	=> $appData['global_caches'],
															   ) );
																
				$this->DB->insert( 'upgrade_history', array('upgrade_version_id'	=> $long_version,
															'upgrade_version_human'	=> $version,
															'upgrade_date'			=> 0,
															'upgrade_mid'			=> 0,
															'upgrade_notes'			=> '',
															'upgrade_app'			=> $next['key']
													)	);

				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
				{
					 $q = $extra_install->after_inserts_run( 'applications' );
				}
			}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: Приложения", 'install&do=applications&amp;previous=' . $next['key'] . '&num=' . $num );
		}
		else
		{
			//-----------------------------------------
			// Next...
			//-----------------------------------------

			$output[] = "Приложения установлены";

			$this->_finishStep( $output, "Установка: Приложения", 'install&do=modules' );
		}
	}

	/**
	 * Install Modules
	 *
	 * @return	@e void
	 */
	public function install_modules()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		//-----------------------------------------
		// Install SYSTEM Templates
		//-----------------------------------------

		$fields = array( 'sys_module_title'    , 'sys_module_application', 'sys_module_key'   , 'sys_module_description', 'sys_module_version', 
						 'sys_module_protected', 'sys_module_visible'    , 'sys_module_position', 'sys_module_admin' );
						 
		if ( $next['key'] )
		{
			$output[]	= $next['title'] . ": Добавление модулей";
			$modules	= IPSSetUp::fetchXmlAppModules( $next['key'], $this->settings['gb_char_set'] );
			
			if( is_array($modules) AND count($modules) )
			{
				if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
				{
					 $q = $extra_install->before_inserts_run( 'modules' );
				}
				
				foreach( $modules as $module )
				{
					foreach( $module as $k => $v )
					{
						if ( ! in_array( $k, $fields ) )
						{
							unset( $module[ $k ] );
						}
					}
			
					$this->DB->insert( 'core_sys_module', $module );
				}
				
				if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
				{
					 $q = $extra_install->after_inserts_run( 'modules' );
				}
			}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: Модули", 'install&do=modules&previous=' . $next['key'] );
		}
		else
		{
			//-----------------------------------------
			// Next...
			//-----------------------------------------

			$output[] = "Все модули добавлены";

			$this->_finishStep( $output, "Установка: Модули", 'install&do=settings' );
		}
	}

	/**
	 * Installs Settings schematic
	 *
	 * @return void
	 */
	public function install_settings()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '{app}_settings.xml', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		//-----------------------------------------
		// Install settings
		//-----------------------------------------

		if ( $next['key'] )
		{
			$output[]      = $next['title'] . ": Добавление настроек";
			$_PATH         = IPSLib::getAppDir( $next['key'] ) .  '/xml/';
			$knownSettings = array();
			
			if ( is_file( $_PATH . $next['key'] . '_settings.xml' ) )
			{
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
				{
					 $q = $extra_install->before_inserts_run( 'settings' );
				}

				//-----------------------------------------
				// Continue
				//-----------------------------------------

				require_once( IPS_ROOT_PATH . 'applications/core/modules_admin/settings/settings.php' );/*noLibHook*/
				$settings =  new admin_core_settings_settings();
				$settings->makeRegistryShortcuts( $this->registry );

				$this->request['app_dir'] = $next['key'];

				//-----------------------------------------
				// Known settings
				//-----------------------------------------

				if ( substr( IPSSetUp::getSavedData('install_url'), -1 ) == '/' )
				{
					IPSSetUp::setSavedData('install_url', substr( IPSSetUp::getSavedData('install_url'), 0, -1 ) );
				}
				
				if ( substr( IPSSetUp::getSavedData('install_dir'), -1 ) == '/' )
				{
					IPSSetUp::setSavedData('install_dir', substr( IPSSetUp::getSavedData('install_dir'), 0, -1 ) );
				}
				
				/* Fetch known settings  */
				if ( is_file( IPSLib::getAppDir( $next['key'] ) . '/setup/versions/install/knownSettings.php' ) )
				{
					require( IPSLib::getAppDir( $next['key'] ) . '/setup/versions/install/knownSettings.php' );/*noLibHook*/
				}
				
				$this->request['app_dir'] = $next['key'];
				$settings->importAllSettings( 1, 1, $knownSettings );
				
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
				{
					 $q = $extra_install->after_inserts_run( 'settings' );
				}
			}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: Настройки", 'install&do=settings&previous=' . $next['key'] );
		}
		else
		{
			//-----------------------------------------
			// Next...
			//-----------------------------------------

			$output[] = "Настройки добавлены";

			$this->_finishStep( $output, "Установка: Настройки", 'install&do=templates' );
		}
	}

	/**
	 * Install templates
	 *
	 * @return void
	 */
	public function install_templates()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		/* Got any skin sets? */
		$count = $this->DB->buildAndFetch( array( 'select' => 'count(*) as count',
												  'from'   => 'skin_collections' ) );

		if ( ! $count['count'] )
		{
			//-----------------------------------------
			// Next...
			//-----------------------------------------

			$output[] = "Добавление шаблонов стилей";

			require_once( IPS_KERNEL_PATH . 'classXML.php' );/*noLibHook*/
			$xml    = new classXML( IPSSetUp::charSet );

			//-----------------------------------------
			// Adjust the table?
			//-----------------------------------------

			if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
			{
				 $q = $extra_install->before_inserts_run( 'skinset' );
			}

			/* Skin Set Data */
			$xml->load( IPS_ROOT_PATH . 'setup/xml/skins/setsData.xml' );
			
			$order = 0;
			
			foreach( $xml->fetchElements( 'set' ) as $xmlelement )
			{
				$data = $xml->fetchElementsFromRecord( $xmlelement );
				
				/* Ensure we have an order */
				$data['set_order'] = intval( $order );
				
				$order++;
				
				$this->DB->insert( 'skin_collections', $data );
			}

			//-----------------------------------------
			// Adjust the table?
			//-----------------------------------------

			if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
			{
				 $q = $extra_install->after_inserts_run( 'skinset' );
			}
		}

		/* Load skin classes */
		require_once( IPS_ROOT_PATH . 'sources/classes/skins/skinFunctions.php' );/*noLibHook*/
		require_once( IPS_ROOT_PATH . 'sources/classes/skins/skinCaching.php' );/*noLibHook*/
		require_once( IPS_ROOT_PATH . 'sources/classes/skins/skinImportExport.php' );/*noLibHook*/

		$skinFunctions = new skinImportExport( $this->registry );

		/* Grab skin data */
		$this->DB->build( array( 'select' => '*',
								 'from'   => 'skin_collections' ) );

		$this->DB->execute();

		while( $row = $this->DB->fetch() )
		{
			/* Bit of jiggery pokery... */
			if ( $row['set_key'] == 'default' )
			{
				$row['set_key'] = 'root';
				$row['set_id']  = 0;
			}

			$skinSets[ $row['set_key'] ] = $row;
		}

		//-----------------------------------------
		// InstallTemplates
		//-----------------------------------------

		if ( $next['key'] )
		{
			foreach( $skinSets as $skinKey => $skinData )
			{
				$_PATH    = IPSLib::getAppDir( $next['key'] ) .  '/xml/';

				$output[] = $next['title'] . ": Добавлены шаблоны {$skinData['set_name']}";

				if ( is_file( $_PATH . $next['key'] . '_' . $skinKey . '_templates.xml' ) )
				{
					//-----------------------------------------
					// Adjust the table?
					//-----------------------------------------

					if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
					{
						 $q = $extra_install->before_inserts_run( 'templates' );
					}

					//-----------------------------------------
					// Install
					//-----------------------------------------

					$return = $skinFunctions->importTemplateAppXML( $next['key'], $skinKey, $skinData['set_id'], TRUE );

					$output[] = $next['title'] . ": " . intval( $return['insertCount'] ) . " шаблонов добавлено";

					//-----------------------------------------
					// Adjust the table?
					//-----------------------------------------

					if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
					{
						 $q = $extra_install->after_inserts_run( 'templates' );
					}
				}

				if ( is_file( $_PATH . $next['key'] . '_' . $skinKey . '_css.xml' ) )
				{
					//-----------------------------------------
					// Adjust the table?
					//-----------------------------------------

					if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
					{
						 $q = $extra_install->before_inserts_run( 'css' );
					}

					//-----------------------------------------
					// Install
					//-----------------------------------------

					$return = $skinFunctions->importCSSAppXML( $next['key'], $skinKey, $skinData['set_id'] );

					$output[] = $next['title'] . ": " . intval( $return['insertCount'] ) . " CSS файлов {$skinData['set_name']} добавлено";

					//-----------------------------------------
					// Adjust the table?
					//-----------------------------------------

					if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
					{
						 $q = $extra_install->after_inserts_run( 'css' );
					}
				}
			}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: Шаблоны", 'install&do=templates&previous=' . $next['key'] );
 		}
		else
		{
			//-----------------------------------------
			// Recache templates
			//-----------------------------------------

			$output[] = "Добавление макросов";

			foreach( $skinSets as $skinKey => $skinData )
			{	
				/* Replacements */
				$skinFunctions->importReplacementsXMLArchive( file_get_contents( IPS_ROOT_PATH . 'setup/xml/skins/replacements_' . $skinKey . '.xml' ), $skinKey );
			}

			$skinFunctions->rebuildSkinSetsCache();

			$output[] = "Шаблоны установлены";

			$this->_finishStep( $output, "Установка: Шаблоны", 'install&do=tasks' );
		}
	}


	/**
	 * Install Tasks
	 *
	 * @return void
	 */
	public function install_tasks()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '{app}_tasks.xml', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		//-----------------------------------------
		// Insert tasks
		//-----------------------------------------

		if ( $next['key'] )
		{
			$output[] = $next['title'] . ": Добавление задач";
			$_PATH        = IPSLib::getAppDir( $next['key'] ) .  '/xml/';

			if ( is_file( $_PATH . $next['key'] . '_tasks.xml' ) )
			{
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
				{
					 $q = $extra_install->before_inserts_run( 'tasks' );
				}

				//-----------------------------------------
				// Continue
				//-----------------------------------------

				require_once( IPS_ROOT_PATH . 'applications/core/modules_admin/system/taskmanager.php' );/*noLibHook*/
				$tasks = new admin_core_system_taskmanager();
				$tasks->makeRegistryShortcuts( $this->registry );

				$tasks->tasksImportFromXML( $_PATH . $next['key'] . '_tasks.xml', 1 );

				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
				{
					 $q = $extra_install->after_inserts_run( 'tasks' );
				}
			}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: Задачи", 'install&do=tasks&previous=' . $next['key'] );
		}
		else
		{
			//-----------------------------------------
			// Next...
			//-----------------------------------------

			$output[] = "Задачи добавлены";

			$this->_finishStep( $output, "Установка: Задачи", 'install&do=languages' );
		}
	}

	/**
	 * Install Languages
	 *
	 * @return void
	 */
	public function install_languages()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		//-----------------------------------------
		// Install Languages
		//-----------------------------------------

		if ( $next['key'] )
		{
			$output[] = $next['title'] . ": Добавление языков админцентра";
			$_PATH        = IPSLib::getAppDir( $next['key'] ) .  '/xml/';

			//-----------------------------------------
			// Get the language stuff
			//-----------------------------------------

			require_once( IPS_ROOT_PATH . 'applications/core/modules_admin/languages/manage_languages.php' );/*noLibHook*/
			$lang            =  new admin_core_languages_manage_languages();
			$lang->makeRegistryShortcuts( $this->registry );

			/* Loop through the xml directory and look for lang packs */
			try
			{
				foreach( new DirectoryIterator( $_PATH ) as $f )
				{
					if( preg_match( "#admin_(.+?)_language_pack.xml#", $f->getFileName() ) )
					{
						//-----------------------------------------
						// Adjust the table?
						//-----------------------------------------
            	
						if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
						{
							 $q = $extra_install->before_inserts_run( 'languages' );
						}
            	
						//-----------------------------------------
						// Import and cache
						//-----------------------------------------
            	
						$this->request['file_location'] = $_PATH . $f->getFileName();
						$lang->imprtFromXML( true, true, true, $next['key'], false, 1 );
            	
						//-----------------------------------------
						// Adjust the table?
						//-----------------------------------------
            	
						if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
						{
							 $q = $extra_install->after_inserts_run( 'languages' );
						}
					}
				}
			} catch ( Exception $e ) {}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: Языки админцентра", 'install&do=languages&previous=' . $next['key'] );
		}
		else
		{
			//-----------------------------------------
			// Next...
			//-----------------------------------------

			$output[] = "Языки админцентра установлены";

			$this->_finishStep( $output, "Установка: Языки админцентра", 'install&do=clientlanguages' );
		}
	}

	/**
	 * Install Public Languages
	 *
	 * @return void
	 */
	public function install_client_languages()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		//-----------------------------------------
		// Install Languages
		//-----------------------------------------

		if ( $next['key'] )
		{
			$output[] = $next['title'] . ": Добавление языков";
			$_PATH        = IPSLib::getAppDir( $next['key'] ) .  '/xml/';

			//-----------------------------------------
			// Get the language stuff
			//-----------------------------------------

			require_once( IPS_ROOT_PATH . 'applications/core/modules_admin/languages/manage_languages.php' );/*noLibHook*/
			$lang            =  new admin_core_languages_manage_languages();
			$lang->makeRegistryShortcuts( $this->registry );

			/* Loop through the xml directory and look for lang packs */
			try
			{
				foreach( new DirectoryIterator( $_PATH ) as $f )
				{
					if( preg_match( "#public_(.+?)_language_pack.xml#", $f->getFileName() ) )
					{
						//-----------------------------------------
						// Adjust the table?
						//-----------------------------------------
            	
						if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
						{
							 $q = $extra_install->before_inserts_run( 'languages' );
						}
            	
						//-----------------------------------------
						// Import and cache
						//-----------------------------------------
            	
						$this->request['file_location'] = $_PATH . $f->getFileName();
						$lang->imprtFromXML( true, true, true, $next['key'], false, 1 );
            	
						//-----------------------------------------
						// Adjust the table?
						//-----------------------------------------
            	
						if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
						{
							 $q = $extra_install->after_inserts_run( 'languages' );
						}
					}
				}
			} catch ( Exception $e ) {}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: Языки", 'install&do=clientlanguages&previous=' . $next['key'] );
		}
		else
		{
			//-----------------------------------------
			// Next...
			//-----------------------------------------

			$output[] = "Добавление языков завершено";

			$this->_finishStep( $output, "Установка: Языки", 'install&do=bbcode' );
		}
	}

	/**
	 * Install BBCode
	 *
	 * @return void
	 */
	public function install_bbcode()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '{app}_bbcode.xml', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		//-----------------------------------------
		// Install Languages
		//-----------------------------------------

		if ( $next['key'] )
		{
			$output[] = $next['title'] . ": Добавление BB-кодов";
			$_PATH        = IPSLib::getAppDir( $next['key'] ) .  '/xml/';

			if ( is_file( $_PATH . $next['key'] . '_bbcode.xml' ) )
			{
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
				{
					 $q = $extra_install->before_inserts_run( 'bbcode' );
				}

				//-----------------------------------------
				// Continue
				//-----------------------------------------

				require_once( IPS_ROOT_PATH . 'applications/core/modules_admin/posts/bbcode.php' );/*noLibHook*/
				$bbcode = new admin_core_posts_bbcode();
				$bbcode->makeRegistryShortcuts( $this->registry );

				$_contents	= file_get_contents( $_PATH . $next['key'] . '_bbcode.xml' );
				
				if ( $_contents )
				{
					$bbcode->bbcodeImportDo( $_contents );
				}

				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
				{
					 $q = $extra_install->after_inserts_run( 'bbcode' );
				}
			}

			$output[] = $next['title'] . ": Добавление медиа тегов";
			$_PATH        = IPSLib::getAppDir( $next['key'] ) .  '/xml/';

			if ( is_file( $_PATH . $next['key'] . '_mediatag.xml' ) )
			{
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
				{
					 $q = $extra_install->before_inserts_run( 'media' );
				}

				//-----------------------------------------
				// Continue
				//-----------------------------------------

				require_once( IPS_ROOT_PATH . 'applications/core/modules_admin/posts/media.php' );/*noLibHook*/
				$bbcode = new admin_core_posts_media();
				$bbcode->makeRegistryShortcuts( $this->registry );

				$bbcode->doMediaImport( file_get_contents( $_PATH . $next['key'] . '_mediatag.xml' ) );

				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
				{
					 $q = $extra_install->after_inserts_run( 'media' );
				}
			}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: BB-коды", 'install&do=bbcode&previous=' . $next['key'] );
		}
		else
		{
			//-----------------------------------------
			// Next...
			//-----------------------------------------

			$output[] = "Все BB-коды установлены";

			$this->_finishStep( $output, "Установка: BB-коды", 'install&do=acphelp' );
		}
	}

	/**
	 * Install ACP Help
	 *
	 * @return void
	 */
	public function install_acphelp()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '{app}_help.xml', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		require_once( IPS_KERNEL_PATH . 'classXML.php' );/*noLibHook*/
		$xml    = new classXML( IPSSetUp::charSet );

		//-----------------------------------------
		// Install Languages
		//-----------------------------------------

		if ( $next['key'] )
		{
			$output[] = $next['title'] . ": Добавление разделов помощи";
			$_PATH        = IPSLib::getAppDir( $next['key'] ) .  '/xml/';
			
			if ( is_file( $_PATH . $next['key'] . '_help.xml' ) )
			{
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
				{
					 $q = $extra_install->before_inserts_run( 'faq' );
				}

				//-----------------------------------------
				// Do it..
				//-----------------------------------------

				require_once( IPS_ROOT_PATH . 'applications/core/modules_admin/tools/help.php' );/*noLibHook*/
				$help = new admin_core_tools_help();
				$help->makeRegistryShortcuts( $this->registry );

				$done = $help->helpFilesXMLImport_app( $next['key'] );
				
				$output[] = $next['title'] . ": Добавлено " . $done['added'] . " файлов помощи";
				
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
				{
					 $q = $extra_install->after_inserts_run( 'faq' );
				}
			}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: Система помощи", 'install&do=acphelp&previous=' . $next['key'] );
		}
		else
		{
			//-----------------------------------------
			// Next...
			//-----------------------------------------

			$output[] = "Все файлы помощи добавлены";

			$this->_finishStep( $output, "Установка: Система помощи", 'install&do=other' );
		}
	}

	/**
	 * Install Other stuff
	 *
	 * @return void
	 */
	public function install_other()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$previous = $_REQUEST['previous'];
		
		//-----------------------------------------
		// HOOKS: Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, 'hooks.xml', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		//-----------------------------------------
		// Insert tasks
		//-----------------------------------------

		if ( $next['key'] )
		{
			$output[] = $next['title'] . ": Добавление модификаций";
			$_PATH        = IPSLib::getAppDir( $next['key'] ) .  '/xml/';

			if ( is_file( $_PATH . 'hooks.xml' ) )
			{
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
				{
					 $q = $extra_install->before_inserts_run( 'hooks' );
				}

				//-----------------------------------------
				// Continue
				//-----------------------------------------

				require_once( IPS_ROOT_PATH . 'applications/core/modules_admin/applications/hooks.php' );/*noLibHook*/
				$hooks = new admin_core_applications_hooks();
				$hooks->makeRegistryShortcuts( $this->registry );

				$result = $hooks->installAppHooks( $next['key'] );
				
				$output[] = "Модификации " . $next['title'] . ": " . $result['inserted'] . " добавлено";
				
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
				{
					 $q = $extra_install->after_inserts_run( 'hooks' );
				}
			}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: Модификации", 'install&do=other&previous=' . $next['key'] );
		}
		else
		{
			require_once( IPS_KERNEL_PATH . 'classXML.php' );/*noLibHook*/

			//-----------------------------------------
			// ****** LOG IN MODULES
			//-----------------------------------------

			$output[] = "Добавление модулей авторизации";
			$xml    = new classXML( IPSSetUp::charSet );

			//-----------------------------------------
			// Adjust the table?
			//-----------------------------------------

			if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
			{
				 $q = $extra_install->before_inserts_run( 'login' );
			}

			//-----------------------------------------
			// Continue
			//-----------------------------------------

			$xml->load( IPS_ROOT_PATH . 'setup/xml/loginauth.xml' );

			foreach( $xml->fetchElements( 'login_methods' ) as $xmlelement )
			{
				$data = $xml->fetchElementsFromRecord( $xmlelement );

				unset( $data['login_id'] );
				unset( $data['login_date'] );
				
				$this->DB->insert( 'login_methods', $data );
			}

			//-----------------------------------------
			// Adjust the table?
			//-----------------------------------------

			if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
			{
				 $q = $extra_install->after_inserts_run( 'login' );
			}

			//-----------------------------------------
			// ****** USER AGENTS
			//-----------------------------------------

			$output[] = "Добавление user-agent`ов по-умолчанию";
			$xml    = new classXML( IPSSetUp::charSet );

			if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
			{
				 $q = $extra_install->before_inserts_run( 'useragents' );
			}

			require_once( IPS_ROOT_PATH . 'sources/classes/useragents/userAgentFunctions.php' );/*noLibHook*/
			$userAgentFunctions = new userAgentFunctions( $this->registry );

			$userAgentFunctions->rebuildMasterUserAgents();

			if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
			{
				 $q = $extra_install->after_inserts_run( 'useragents' );
			}

			//-----------------------------------------
			// ****** ATTACHMENTS
			//-----------------------------------------

			$output[] = "Добавление типов прикрепляемых файлов";

			if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
			{
				 $q = $extra_install->before_inserts_run( 'attachments' );
			}

			$xml    = new classXML( IPSSetUp::charSet );

			$xml->load( IPS_ROOT_PATH . 'setup/xml/attachments.xml' );

			foreach( $xml->fetchElements( 'attachtype' ) as $xmlelement )
			{
				$data = $xml->fetchElementsFromRecord( $xmlelement );

				unset( $data['atype_id'] );

				$this->DB->insert( 'attachments_type', $data );
			}

			if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
			{
				 $q = $extra_install->after_inserts_run( 'attachments' );
			}

			//-----------------------------------------
			// Build Calendar RSS
			//-----------------------------------------

			if( IPSLib::appIsInstalled('calendar') )
			{
				require_once( IPSLib::getAppDir('calendar') . '/modules_admin/calendar/calendars.php' );/*noLibHook*/
				$cal = new admin_calendar_calendar_calendars();
				$cal->makeRegistryShortcuts( $this->registry );

				$output[] = "Обновление RSS календаря";
				$cal->calendarRSSCache();
			}
		
			/* If this is windows, change the locale for the language pack */
			if( strpos( strtolower( PHP_OS ), 'win' ) === 0 )
			{
				$this->DB->update( 'core_sys_lang', array( 'lang_short' => 'Russian_Russia.65001' ), 'lang_id=1' );
			}
			else
			{
				$this->DB->update( 'core_sys_lang', array( 'lang_short' => 'ru_RU.UTF-8' ), 'lang_id=1' );
			}
			
		}

		//-----------------------------------------
		// Next...
		//-----------------------------------------

		$this->_finishStep( $output, "Установка: Другие данные", 'install&do=caches' );
	}

	/**
	 * Install Caches
	 *
	 * @return void
	 */
	public function install_caches()
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------

		$this->settings['base_url']			= IPSSetUp::getSavedData('install_url');
		$this->settings['ipb_reg_number']	= IPSSetUp::getSavedData('lkey');

		$previous = $_REQUEST['previous'];

		//-----------------------------------------
		// Fetch next 'un
		//-----------------------------------------

		$next = IPSSetUp::fetchNextApplication( $previous, '', $this->settings['gb_char_set'] );

		/* Set up DB driver */
		$extra_install = $this->_setUpDBDriver( FALSE );

		//-----------------------------------------
		// Install SYSTEM Templates on first cycle
		//-----------------------------------------

		if( !$previous )
		{
			//-----------------------------------------
			// Global caches...
			//-----------------------------------------

			# Grab cache master file
			require_once( IPS_ROOT_PATH . 'extensions/coreVariables.php' );/*noLibHook*/

			/* Add handle */
			$_tmp = new coreVariables();
			$_cache = $_tmp->fetchCaches();
			$CACHE  = $_cache['caches'];

			//-----------------------------------------
			// Adjust the table?
			//-----------------------------------------

			if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
			{
				 $q = $extra_install->before_inserts_run( 'caches' );
			}

			//-----------------------------------------
			// Continue
			//-----------------------------------------

			if ( is_array( $CACHE ) )
			{
				foreach( $CACHE as $cs_key => $cs_data )
				{
					$output[] = "Обновление {$cs_key}...";

					ipsRegistry::cache()->rebuildCache( $cs_key, 'global' );
				}
			}

			//-------------------------------------------------------------
			// Systemvars
			//-------------------------------------------------------------

			$output[] = "Обновление кеша системных переменных";

			$cache = array( 'mail_queue'    => 0,
							'task_next_run' => time() + 3600 );

			ipsRegistry::cache()->setCache( 'systemvars', $cache, array( 'array' => 1 ) );

			//-------------------------------------------------------------
			// Stats
			//-------------------------------------------------------------

			$output[] = "Обновление кеша статистики";

			$cache = array( 'total_replies' => 0,
							'total_topics'  => 1,
							'mem_count'     => 1,
							'last_mem_name' => IPSSetUp::getSavedData('admin_user'),
							'last_mem_id'   => 1 );


			ipsRegistry::cache()->setCache( 'stats', $cache, array( 'array' => 1 ) );

			//-----------------------------------------
			// Adjust the table?
			//-----------------------------------------

			if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
			{
				 $q = $extra_install->after_inserts_run( 'caches' );
			}

			$output[] = "Все кеши обновлены";
			
			//-----------------------------------------
			// Recache skins: Moved here so they are
			// build after hooks are added
			//-----------------------------------------
			
			/* Load skin classes */
			require_once( IPS_ROOT_PATH . 'sources/classes/skins/skinFunctions.php' );/*noLibHook*/
			require_once( IPS_ROOT_PATH . 'sources/classes/skins/skinCaching.php' );/*noLibHook*/
			require_once( IPS_ROOT_PATH . 'sources/classes/skins/skinImportExport.php' );/*noLibHook*/

			$skinFunctions = new skinImportExport( $this->registry );

			/* Grab skin data */
			$this->DB->build( array( 'select' => '*',
									 'from'   => 'skin_collections' ) );

			$this->DB->execute();

			while( $row = $this->DB->fetch() )
			{
				/* Bit of jiggery pokery... */
				if ( $row['set_key'] == 'default' )
				{
					$row['set_key'] = 'root';
					$row['set_id']  = 0;
				}

				$skinSets[ $row['set_key'] ] = $row;
			}
			
			foreach( $skinSets as $skinKey => $skinData )
			{
				/* Bit of jiggery pokery... */
				if ( $skinData['set_key'] == 'root' )
				{
					$skinData['set_key'] = 'default';
					$skinData['set_id']  = 1;
					$skinKey             = 'default';
				}

				$skinFunctions->rebuildPHPTemplates( $skinData['set_id'] );

				if ( $skinFunctions->fetchErrorMessages() !== FALSE )
				{
					$this->registry->output->addWarning( implode( "<br />", $skinFunctions->fetchErrorMessages() ) );
				}

				$skinFunctions->rebuildCSS( $skinData['set_id'] );

				if ( $skinFunctions->fetchErrorMessages() !== FALSE )
				{
					$this->registry->output->addWarning( implode( "<br />", $skinFunctions->fetchErrorMessages() ) );
				}

				$skinFunctions->rebuildReplacementsCache( $skinData['set_id'] );

				if ( $skinFunctions->fetchErrorMessages() !== FALSE )
				{
					$this->registry->output->addWarning( implode( "<br />", $skinFunctions->fetchErrorMessages() ) );
				}
			}

			$skinFunctions->rebuildSkinSetsCache();
			
			$output[] = "Кеш стиля обновлен";
			
			/* Rebuild FURL & GLOBAL caches */
			try
			{
				IPSLib::cacheFurlTemplates();
				IPSLib::cacheGlobalCaches();
			}
			catch( Exception $error )
			{
			}
		}

		//-----------------------------------------
		// Now install other caches
		//-----------------------------------------
		
		if ( $next['key'] )
		{
			$_PATH    = IPSLib::getAppDir( $next['key'] ) . '/extensions/';

			if ( is_file( $_PATH . 'coreVariables.php' ) )
			{
				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'before_inserts_run' ) )
				{
					 $q = $extra_install->before_inserts_run( 'caches' );
				}

				# Grab cache master file
				require_once( $_PATH . 'coreVariables.php' );/*noLibHook*/

				if ( is_array( $CACHE ) )
				{
					foreach( $CACHE as $cs_key => $cs_data )
					{
						$output[] = $next['title'] . ": Обновление {$cs_key}...";

						ipsRegistry::cache()->rebuildCache( $cs_key, $next['key'] );
					}
				}
				else
				{
					$output[] = $next['title'] . ": Нет кешей для обновления...";
				}

				//-----------------------------------------
				// Adjust the table?
				//-----------------------------------------

				if ( $extra_install AND method_exists( $extra_install, 'after_inserts_run' ) )
				{
					 $q = $extra_install->after_inserts_run( 'caches' );
				}
			}
			else
			{
				$output[] = $next['title'] . ": Нет кешей для обновления...";
			}

			//-----------------------------------------
			// Done.. so get some more!
			//-----------------------------------------

			$this->_finishStep( $output, "Установка: кеш", 'install&do=caches&previous=' . $next['key'] );
		}
		else
		{
			$this->_finishStep( $output, "Установка: кеш", 'done' );
		}
	}

	/**
	 * Set up DB driver
	 *
	 * @access	private
	 * @param	bool		Whether the DB driver returns with an error or not
	 * @return	@e void
	 */
	private function _setUpDBDriver( $returnDie=TRUE )
	{
		$extra_install = '';

		//--------------------------------------------------
		// Any "extra" configs required for this driver?
		//--------------------------------------------------

		if ( is_file( IPS_ROOT_PATH .'setup/sql/' . strtolower( IPSSetUp::getSavedData('sql_driver') ) . '_install.php' ) )
		{
			require_once( IPS_ROOT_PATH .'setup/sql/' . strtolower( IPSSetUp::getSavedData('sql_driver') ) . '_install.php' );/*noLibHook*/

			$extra_install = new install_extra( $this->registry );
		}

		//-----------------------------------------
		// Set DB Handle
		//-----------------------------------------

		$this->registry->loadConfGlobal();
		$this->registry->setDBHandle();
		$this->DB = $this->registry->DB();

		/* Return error? */
		if ( $returnDie === TRUE )
		{
			$this->DB->return_die = 1;
		}

		return $extra_install;
	}

	/**
	 * Finish Step
	 * Configures the output engine
	 *
	 * @access	private
	 * @param	string	output
	 * @param	string	title
	 * @param	string	next step
	 * @return	@e void
	 */
	private function _finishStep( $output, $title, $nextStep )
	{
		if ( $this->_stepCount )
		{
			$this->registry->output->setInstallStep( $this->_stepCount, $this->_totalSteps );
		}

		$this->registry->output->setTitle( $title );
		$this->registry->output->setNextAction( $nextStep );
		$this->registry->output->setHideButton( TRUE );
		$this->registry->output->addContent( $this->registry->output->template()->page_refresh( $output ) );
		$this->registry->output->sendOutput();
	}
}