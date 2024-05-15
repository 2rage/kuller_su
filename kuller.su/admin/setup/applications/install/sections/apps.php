<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Installer: EULA file
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


class install_apps extends ipsCommand
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
		/* Check input? */
		if( $this->request['do'] == 'check' )
		{
			/* Check Directory */
			if ( ! is_array( $_POST['apps'] ) OR ! count( $_POST['apps'] ) )
			{
				$this->registry->output->addError( 'Нужно выбрать хотя бы одно приложение' );
			}
			else 
			{
				/* Save Form Data */
				IPSSetUp::setSavedData('install_apps', implode( ',', array_keys( $_POST['apps'] ) ) );
				
				/* Check writeable files */
				foreach( array_keys( $_POST['apps'] ) as $appDir )
				{
					$info = IPSSetUp::fetchXmlAppWriteableFiles( $appDir );
					
					if ( count( $info['notexist'] ) )
					{
						foreach( $info['notexist'] as $path )
						{
							$this->registry->output->addWarning( 'Файл или директория "' . $path . '" не существует, создайте ее' );
						}
					}
					
					if ( count( $info['notwrite'] ) )
					{
						foreach( $info['notwrite'] as $path )
						{
							$this->registry->output->addWarning( 'Запись в "' . $path . '" невозможна, измените права доступа' );
						}
					}
					
					/**
					 * Custom errors
					 */
					if ( count( $info['other'] ) )
					{
						foreach( $info['other'] as $error )
						{
							$this->registry->output->addWarning( $error );
						}
					}
				}
				
				/* Do we have errors? */
				if ( ! count( $this->registry->output->fetchWarnings() ) )
				{
					/* Next Action */
					$this->registry->autoLoadNextAction( 'address' );
				}
			}
		}
						
		/* Generate apps... */
		$apps   = array( 'core' => array(), 'ips' => array(), 'other' => array() );
		
		foreach( array( 'applications', 'applications_addon/ips', 'applications_addon/other' ) as $_pBit )
		{
			$path   = IPS_ROOT_PATH . $_pBit;
			$handle = opendir( $path );
		
			while ( ( $file = readdir( $handle ) ) !== FALSE )
			{
				if ( ! preg_match( "#^\.#", $file ) )
				{
					if ( is_dir( $path . '/' . $file ) )
					{
						//-----------------------------------------
						// Get it!
						//-----------------------------------------
					
						if ( ! is_file( IPS_ROOT_PATH . $_pBit . '/' . $file . '/xml/information.xml' ) )
						{
							continue;		
						}
						
						$data = IPSSetUp::fetchXmlAppInformation( $file, $this->settings['gb_char_set'] );
						
						switch( $_pBit )
						{
							case 'applications':
								$apps['core'][ $file ] = $data;
							break;
							case 'applications_addon/ips':
								$apps['ips'][ $file ] = $data;
							break;
							case 'applications_addon/other':
								$apps['other'][ $file ] = $data;
							break;
						}
					}
				}
			}
		
			closedir( $handle );
		}
		
		/* Reorder the array so that core is first */
		$new_array = array();
		$new_array['core'] = $apps['core']['core'];
		
		foreach( $apps['core'] as $app => $data )
		{
			if( $app == 'core' )
			{
				continue;
			}
			
			$new_array[$app] = $data;
		}
		
		$apps['core'] = $new_array;
		
		/* Page Output */
		$this->registry->output->setTitle( "Приложения" );
		$this->registry->output->setNextAction( 'apps&do=check' );
		$this->registry->output->addContent( $this->registry->output->template()->page_apps( $apps ) );
		$this->registry->output->sendOutput();
	}
}