<?php

/**
 *	It's the Final Countdown
 *
 * @author 		Martin Aronsen
 * @copyright	© 2008 - 2011 Invision Modding
 * @web: 		http://invisionmodding.com
 * @IPB ver.:	IP.Board 3.2
 * @version:	1.1.0  (11000)
 *
 */

class version_upgrade
{
	private $_output = '';
	
	public function fetchOutput()
	{
		/* Return */
		return $this->_output;
	}
	
	public function doExecute( ipsRegistry $registry ) 
	{
		/* Make registry objects */
		$this->registry = $registry;
		$this->DB       = $this->registry->DB();
		
		/* INIT */
		$mem_counts = array();
		
		/* Add new fields */
		$this->DB->addField( "countdowns", "view_permissions", "text", '' );
		$this->DB->addField( 'countdowns', 'layout', 'varchar(255)', '' );
		$this->DB->addField( 'countdowns', 'format', 'varchar(10)', '' );
		
		/* Find article counts */
		$this->DB->build( array( 'select' => '*', 'from' => 'countdowns' ) );
		$outer = $this->DB->execute();
		
		while ( $r = $this->DB->fetch( $outer ) )
		{
			$permissions = array();
			
			if ( $r['forums'] )
			{
				$permissions['forums'] = $r['forums'];
			}
			
			$this->DB->update( 'countdowns', array( 'view_permissions' => serialize( $permissions ) ), 'id=' . $r['id'] );
		}
		
		$this->DB->dropField( 'countdowns', 'forums' );
		
		/* Continue with upgrade */
		return true;
	}	
}