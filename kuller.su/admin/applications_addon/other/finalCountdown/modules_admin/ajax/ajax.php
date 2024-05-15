<?php

/**
 * @author -RAW-
 * @copyright 2012
 * @link http://rawcodes.net
 * @filesource It's the Final Countdown
 * @version 1.2.0
 */

class admin_finalCountdown_ajax_ajax extends ipsAjaxCommand
{
	public function doExecute( ipsRegistry $registry )
	{
		$this->lang->loadLanguageFile( array( 'admin_core' ) );

		switch ( $this->request['do'] )
		{
			case 'reorder':
				$this->sortEntries();
				break;

			case 'quickToggle':
				$this->quickToggle();
				break;
		}
	}
	
	/**
	* Sort the countdown per AJAX request
	* 
	* @access	private
	* @return	void
	*/
	protected function sortEntries()
	{
		//-----------------------------------------
		// Save new position
		//-----------------------------------------
		if ( is_array( $this->request['item'] ) AND count( $this->request['item'] ) )
		{
			$position = 1;
            foreach ( $this->request['item'] as $this_id )
            {
                $this->DB->update( 'countdowns', array( 'position' => $position ), 'id=' . $this_id );
                
                $position++;
            }
			
			$this->cache->rebuildCache( 'countdowns', 'finalCountdown' );
        }
		
		$this->returnString( 'OK' );
	}
	
	protected function quickToggle()
	{
		$id 	= $this->request['id'];
		$toggle = $this->request['toggle'] == 'enabled' ? 'enabled' : 'allow_embed';
		
		if ( is_array( $this->caches['countdowns'][ $id ] ) )
		{
			$newValue = $this->caches['countdowns'][ $id ][ $toggle ] == 1 ? 0 : 1;
			$this->DB->update( 'countdowns', array( $toggle => $newValue ), 'id=' . $id );
			$this->cache->rebuildCache( 'countdowns', 'finalCountdown' );
			
			$this->returnJsonArray( array(
				'img' => $this->settings['skin_acp_url'] . '/images/icons/' . ( $newValue == 1 ? 'tick.png' : 'cross.png' ),
				'newValue' => $newValue,
				'oldValue' => $this->caches[ $id ][ $toggle ]
			));
		}
		
		$this->returnJsonError( 'failure' );
	}
}