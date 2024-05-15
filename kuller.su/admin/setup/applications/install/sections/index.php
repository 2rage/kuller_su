<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Installer: Index file
 * Last Updated: $LastChangedDate: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @version		$Rev: 10721 $
 *
 */


class install_index extends ipsCommand
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
		/* INIT */
		$filesOK       = NULL;
		$extensions    = get_loaded_extensions();
		$extensionsOK  = TRUE;
		$extensionData = array();
		
		/* Test Extensions */
		$INSTALLDATA = array();
		include( IPS_ROOT_PATH . 'setup/xml/requiredextensions.php' );/*noLibHook*/
		
		if ( is_array( $INSTALLDATA ) && count( $INSTALLDATA ) )
		{
			foreach( $INSTALLDATA as $data )
			{
				if ( ! in_array( $data['testfor'], $extensions ) )
				{
					//-----------------------------------------
					// Added 'nohault' key which will show a
					// warning but not prohibit installation
					//-----------------------------------------
					
					if( $data['nohault'] )
					{
						$data['_ok']	= 1;		// Anything but true or false
						$extensionsOK	= 1;		// Anything but true or false
					}
					else
					{
						$extensionsOK = FALSE;
					}
				}
				else
				{
					$data['_ok'] = TRUE;
				}
				
				$extensionData[] = $data;
			}
		}
		
		/* Check for conf_global.dist.php */
		if ( is_file( DOC_IPS_ROOT_PATH . 'conf_global.dist.php') AND ! is_file( DOC_IPS_ROOT_PATH.'conf_global.php') )
		{
			if ( ! @rename( DOC_IPS_ROOT_PATH.'conf_global.dist.php', DOC_IPS_ROOT_PATH.'conf_global.php' ) )
			{
				$filesOK = FALSE;
				$this->registry->output->addError( "<strong>Вы должны переименовать файл 'conf_global.<b style='color:red'>dist.php</b>' в 'conf_global.<b style='color:red'>php</b>' перед продолжением.</strong>
							  						 Этот файл можно найти в корневой директории IP.Board." );
			}
		}
		
		/* All extensions loaded OK? */
		if ( $extensionsOK == TRUE AND $filesOK === NULL )
		{
			$filesOK = FALSE;
		
			/* Fetch core writeable files */
			require_once( IPS_KERNEL_PATH . 'classXML.php' );/*noLibHook*/
			$xml    = new classXML( IPSSetUp::charSet );
		
			try
			{
				$xml->load( IPS_ROOT_PATH . 'setup/xml/writeablefiles.xml' );
			
				foreach( $xml->fetchElements( 'file' ) as $xmlelement )
				{
					$data = $xml->fetchElementsFromRecord( $xmlelement );

					if ( $data['path'] )
					{
						$_path = DOC_IPS_ROOT_PATH . $data['path'];
					
						if ( ! file_exists( $_path ) )
						{
							if ( $data['dir'] )
							{
								if ( ! @mkdir( $_path, IPS_FOLDER_PERMISSION, TRUE ) )
								{
									$this->registry->output->addError( 'Директория "' . $data['path'] . '" не существует, создайте ее' );
								}
							}
							else
							{
								$this->registry->output->addError( 'Файл "' . $data['path'] . '" не существует, создайте его' );
							}
						}
					
						if ( ! is_writeable( $_path ) )
						{
							if ( ! @chmod( $_path, is_dir( $_path ) ? IPS_FOLDER_PERMISSION : IPS_FILE_PERMISSION ) )
							{
								if ( is_dir( $_path ) )
								{
									$this->registry->output->addError( 'Запись в директорию: "' . $data['path'] . '" невозможна , измените права доступа' );
								}
								else
								{
									$this->registry->output->addError( 'Запись в файл "' . $data['path'] . '" невозможна, измените права доступа' );
								}
							}
						}
					}
				}
			
				if ( ! count( $this->registry->output->fetchErrors() ) )
				{
					$filesOK = TRUE;
				}
			}
			catch( Exception $error )
			{
				$filesOK = FALSE;
				$this->registry->output->addError( "Файл " . IPS_ROOT_PATH . 'setup/xml/writeablefiles.xml не найден' );
			}
		}
		
		/* Hide buttons? */
		if ( $filesOK !== TRUE OR $extensionsOK != TRUE )
		{
			$this->registry->output->setNextAction( '' );
			$this->registry->output->setHideButton( TRUE );
		}

		/* Simply return the requirements page */
		$this->registry->output->setTitle( "Требования" );
		$this->registry->output->addContent( $this->registry->output->template()->page_requirements( $filesOK, $extensionsOK, $extensionData ) );
		$this->registry->output->sendOutput();
	}
}