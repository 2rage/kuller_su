<?php

/**
 * @author -RAW-
 * @copyright 2012
 * @link http://rawcodes.net
 * @filesource It's the Final Countdown
 * @version 1.2.0
 */

class finalCountdown_hookGateway
{
	public function __construct( ipsRegistry $registry )
	{
		/* Make object */
		$this->registry 	=  $registry;
		$this->DB       	=  $this->registry->DB();
		$this->settings 	=& $this->registry->fetchSettings();
		$this->request  	=& $this->registry->fetchRequest();
		$this->member		=  $this->registry->member();
		$this->memberData	=& $this->registry->member()->fetchMemberData();
		$this->cache		=  $this->registry->cache();
		$this->caches		=& $this->registry->cache()->fetchCaches();
		$this->lang			=  $this->registry->getClass('class_localization');
		
		if ( ! $this->registry->isClassLoaded( 'finalCountdown_library' ) )
		{
			$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( 'finalCountdown' ) . "/sources/library.php", 'finalCountdown_library' );
			$this->registry->setClass( 'finalCountdown_library', new $classToLoad( $this->registry ) );
		}
	}
	
	public function getCountdowns( $position )
	{
		if ( is_array( $this->caches['countdowns'] ) AND count( $this->caches['countdowns'] ) )
		{
			$countdowns = array();
			$this->lang->time_options['TIME'] = '%I:%M %p'; /* Bug in <= 3.2.3 */
			
			if ( ! isset( $this->request['app'] ) )
			{
				$this->request['app'] = IPS_DEFAULT_PUBLIC_APP;
			}
			
			foreach( $this->caches['countdowns'] as $countdown )
			{
				if ( $countdown['enabled'] )
				{
					if ( strstr( ',' . $countdown['view_in'] . ',', ',' . $position . ',' ) )
					{
						if ( $countdown['groups_perm'] == '*' OR IPSMember::isInGroup( $this->memberData, explode( ',', $countdown['groups_perm'] ) ) )
						{
							/* Restrict to various things */
							$permissions = unserialize( $countdown['view_permissions'] );
							
							$goodToGo = false;
							switch( $this->request['app'] )
							{
								case 'forums':
									if ( isset( $permissions['forums'] ) )
									{
										$goodToGo = ( $permissions['forums'] == '*' OR strstr( ',' . $permissions['forums'] . ',', ',' . $this->request['f'] . ',' ) );
									}
									else if ( $permissions['showOnOtherApps'] == TRUE )
									{
										$goodToGo = true;
									}
									break;
									
								case 'ccs':
									if ( isset( $permissions['ccs'] ) )
									{
										/* Are we on the frontpage, etc */
										if ( strstr( ",{$permissions['ccs']},", ',0,' ) AND ! isset( $this->request['page'] ) )
										{
											$goodToGo = true;
										}
										else if ( isset( $this->request['folder'] ) AND isset( $this->request['page'] ) )
										{
											if ( strstr( ",{$permissions['ccs']},", ",{$this->request['folder']}|{$this->request['page']}," ) )
											{
												$goodToGo = true;
											}
										}
									}
									/* No restrictions for IP.Content set */
									else if ( $permissions['showOnOtherApps'] == TRUE )
									{
										$goodToGo = true;
									}
									break;
								
								default:
									if ( $permissions['showOnOtherApps'] == TRUE )
									{
										$goodToGo = true;
									}
									break;
							}
							
							/* Board index sidebar is exempted from all these checks */
							if ( $position == 'sidebar' OR $goodToGo )
							{
								$countdowns[ $countdown['id'] ] = $this->registry->getClass( 'finalCountdown_library' )->parseCountdown( $countdown );		
							}
						}
					}
				}
			}
			
			/* Return template if we have any countdowns */
			if ( count( $countdowns ) )
			{
				$this->lang->loadLanguageFile( array( 'public_core' ), 'finalCountdown' );
				
				$templateName = 'finalCountdown_' . $position;
				
				/* See if the template exists, and show a softer error if not */
				if ( method_exists( $this->registry->getClass( 'output' )->getTemplate( 'finalCountdown' ), $templateName ) )
				{
					return $this->registry->output->getTemplate( 'finalCountdown' )->$templateName( $countdowns );
				}
				else
				{
					if ( $this->memberData['g_access_cp'] )
					{
						return "<div class='clearfix'>Failed to load template '{$templateName}' from group 'skin_finalCountdown'</div>";
					}
				}
			}
		}
	}
}