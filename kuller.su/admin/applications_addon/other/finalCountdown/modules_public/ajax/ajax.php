<?php

/**
 * @author -RAW-
 * @copyright 2012
 * @link http://rawcodes.net
 * @filesource It's the Final Countdown
 * @version 1.2.0
 */

class public_finalCountdown_ajax_ajax extends ipsAjaxCommand
{
	public function doExecute( ipsRegistry $registry )
	{
		switch( $this->request['do'] )
		{
			case 'serverSync':
				$this->serverSync();
				break;
			default:
				$this->getCountdowns();
				break;
		}
	}
	
	protected function serverSync()
	{
		header("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1 
		header("Expires: Fri, 1 Jan 2010 00:00:00 GMT"); // Date in the past 
		$now = new DateTime(); 
		$this->returnString( $now->format("M j, Y H:i:s O") ); 
	}
	
	protected function getCountdowns()
	{
		$ids = IPSLib::cleanIntArray( $this->request['ids'] );
		
		if ( count( $ids ) )
		{
			if ( ! $this->registry->isClassLoaded( 'finalCountdown_library' ) )
			{
				$classToLoad = IPSLib::loadLibrary( IPSLib::getAppDir( 'finalCountdown' ) . "/sources/library.php", 'finalCountdown_library' );
				$this->registry->setClass( 'finalCountdown_library', new $classToLoad( $this->registry ) );
			}
			
			$this->lang->time_options['TIME'] = '%I:%M %p'; /* Bug in IP.Board 3.2.3 */
			
			$return = array();
			foreach( $ids as $id )
			{
				$countdown	= $this->caches['countdowns'][ $id ];
		
				if ( ! is_array( $countdown ) OR ! count( $countdown ) OR ! $countdown['enabled'] OR ! $countdown['allow_embed'] )
				{
					/* Non-existing, or disabled. Remove from source */
					$return['remove'][] = $id;
					continue;
				}

				/* Allowed to see it? */
				if ( $countdown['groups_perm'] == '*' OR IPSMember::isInGroup( $this->memberData, explode( ',', $countdown['groups_perm'] ) ) )
				{
					$countdown =  $this->registry->getClass( 'finalCountdown_library' )->parseCountdown( $countdown );
					
					/* Remove things we don't need to return to the general public */
					unset( $countdown['groups_perm'], $countdown['view_permissions'], $countdown['allow_embed'], $countdown['position'], $countdown['time'], $countdown['timezone'] );
					$return['parse'][] = $countdown;	
				}
				else
				{
					/* No perm */
					$return['remove'][] = $id;
					continue;
				}
			}
			
			$this->returnJsonArray( $return );
		}
		else
		{
			$this->returnJsonError( 'no_ids' );
		}
	}
}