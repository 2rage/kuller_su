<?php

/**
 * @author -RAW-
 * @copyright 2012
 * @link http://rawcodes.net
 * @filesource It's the Final Countdown
 * @version 1.2.0
 */

class finalCountdown_library
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
	}
	
	public function parseCountdown( $countdown )
	{
		foreach( array( 'before_txt', 'after_txt', 'event_msg' ) as $field )
		{
			$find = array( '{date}', '{time}' );
			$replace = array( 
				$this->lang->formatTime( $countdown['time'], 'date', 0 ),
				$this->lang->formatTime( $countdown['time'], 'time', 0 ),
			);
			
			$countdown[ $field ] = str_replace( $find, $replace, $countdown[ $field ] );
		}
		
		$countdown['after_txt']  = IPSText::getTextClass( 'bbcode' )->preDisplayParse( $countdown['after_txt'] );
		$countdown['before_txt'] = IPSText::getTextClass( 'bbcode' )->preDisplayParse( $countdown['before_txt'] ); 
		$countdown['event_msg']  = IPSText::getTextClass( 'bbcode' )->preDisplayParse( $countdown['event_msg'] );
		
		$countdown['layout'] = str_replace( array( '&gt;', '&lt;' ), array( '>', '<' ), $countdown['layout'] );
		if ( $countdown['timezone'] == 'local' )
		{
			$this->memberData['time_offset'] = ( isset( $this->memberData['time_offset'] ) ) ? $this->memberData['time_offset'] : $this->settings['time_offset'];
			$countdown['timezone'] = $this->timezoneBonanza( $this->memberData['time_offset'] );
		}
		

		$date = new DateTime( date( 'Y-m-d\TH:i:s', $countdown['time'] ) . "{$countdown['timezone']}" );
		
		$countdown['jstime'] 		= $date->format( "M j, Y H:i:s" );
		$countdown['jstimezone'] 	= $date->getTimezone()->getOffset( $date ) / 60;
		
		$countdowns[ $countdown['id'] ] = $countdown;		
						
		
		return $countdown;
	}
	
	/**
	 * Convert the system default to the format we use
	 * 
	 * @access	protected
	 * @param	int	$systemDefault	Systems default timezone
	 * @return	int	System timezone in our format
	 */
	public function timezoneBonanza( $systemDefault )
	{
		$tz = array(  
			'-12' 	=> '-12:00',
			'-11' 	=> '-11:00',
			'-10' 	=> '-10:00',
			'-9.5' 	=> '-09:30',
			'-9' 	=> '-09:00',
			'-8' 	=> '-08:00',
			'-7' 	=> '-07:00',
			'-6' 	=> '-06:00',
			'-5' 	=> '-05:00',
			'-4' 	=> '-04:00',
			'-3.5' 	=> '-03:30',
			'-3'	=> '-03:00',
			'-2' 	=> '-02:00',
			'-1' 	=> '-01:00',
			'0' 	=> '+00:00',
			'1' 	=> '+01:00',
			'2' 	=> '+02:00',
			'3' 	=> '+03:00',
			'3.5' 	=> '+03:30',
			'4' 	=> '+04:00',
			'4.5' 	=> '+04:30',
			'5' 	=> '+05:00',
			'5.5' 	=> '+05:30',
			'5.75' 	=> '+05:45',
			'6' 	=> '+06:00',
			'6.5' 	=> '+06:30',
			'7' 	=> '+07:00',
			'8' 	=> '+08:00',
			'8.75' 	=> '+08:45',
			'9' 	=> '+09:00',
			'9.5' 	=> '+09:30',
			'10' 	=> '+10:00',
			'10.5' 	=> '+10:30',
			'11' 	=> '+11:00',
			'11.5' 	=> '+11:30',
			'12' 	=> '+12:00',
			'12.75'	=> '+12:45',
			'13' 	=> '+13:00',
			'14' 	=> '+14:00',
		);
		
		return $tz[ $systemDefault ];
	}
	
	public function getCcsFoldersAndPages()
	{
		if ( IPSLib::appIsInstalled( 'ccs' ) )
		{
			$this->DB->build( array(
				'select' 	=> '*',
				'from'		=> 'ccs_pages',
				'order'		=> 'page_folder ASC'
			));
			$this->DB->execute();
			
			$pages = array();
			while( $r = $this->DB->fetch() )
			{
				$r['page_folder'] = !empty( $r['page_folder'] ) ? $r['page_folder'] : '/';
				
				$pages[ $r['page_folder'] ][] = array( $r['page_seo_name'], $r['page_name'] );
			}
			
			return $pages;
		}
		
		return false;
	}
}