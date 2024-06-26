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


class install_address extends ipsCommand
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
		$error = false;
		
		/* Check input? */
		if ( $this->request['do'] == 'check' )
		{
			/* Check Directory */
			if ( ! ( is_dir( $this->request['install_dir'] ) ) )
			{
				$error = true;
				$this->registry->output->addWarning( 'Указанной директории не существует' );
			}
			
			/* Check URL */
			if ( ! $this->request['install_dir'] )
			{
				$error = true;
				$this->registry->output->addWarning( 'Вы не указали URL' );
			}

			if( ! $error )
			{
				/* Save Form Data */
				IPSSetUp::setSavedData('install_dir', preg_replace( "#(//)$#", "", str_replace( '\\', '/', $this->request['install_dir'] ) . '/' ) );
				IPSSetUp::setSavedData('install_url', preg_replace( "#(//)$#", "", str_replace( '\\', '/', $this->request['install_url'] ) . '/' ) );
				
				/* Next Action */
				$this->registry->autoLoadNextAction( 'license' );
			}
		}
		
		/* Guess at directory */
		
		if( !defined('CP_DIRECTORY') )
		{
			define( 'CP_DIRECTORY', 'admin' );
		}

		$dir = str_replace( CP_DIRECTORY . '/install'  , '' , getcwd() );
		$dir = str_replace( CP_DIRECTORY . '\install'  , '' , $dir ); // Windows
		$dir = str_replace( '\\'       , '/', $dir );

		/* Guess at URL */
		$url = str_replace( "/" . CP_DIRECTORY . "/installer/index.php"	, "", $_SERVER['HTTP_REFERER'] );
		$url = str_replace( "/" . CP_DIRECTORY . "/installer/"			, "", $url);
		$url = str_replace( "/" . CP_DIRECTORY . "/installer"			, "", $url);
		$url = str_replace( "/" . CP_DIRECTORY . "/install/index.php"	, "", $_SERVER['HTTP_REFERER'] );
		$url = str_replace( "/" . CP_DIRECTORY . "/install/"			, "", $url);
		$url = str_replace( "/" . CP_DIRECTORY . "/install"				, "", $url);
		$url = str_replace( "/" . CP_DIRECTORY							, "", $url);
		$url = str_replace( "index.php"									, "", $url);
		$url = preg_replace( "!\?(.+?)*!"								, "", $url );	
		$url = "{$url}/";
		
		/* Page Output */
		$this->registry->output->setTitle( "Директории и URLы" );
		$this->registry->output->setNextAction( "address&do=check" );
		$this->registry->output->addContent( $this->registry->output->template()->page_address( $dir, $url ) );
		$this->registry->output->sendOutput();
	}
	
}