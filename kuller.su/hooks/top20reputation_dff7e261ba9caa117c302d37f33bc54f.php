<?php

/**
 * Product Title:		(SOS32) TOP 20 Reputation Points
 * Product Version:		3.0.0
 * Author:				Adriano Faria
 * Website:				SOS Invision
 * Website URL:			http://forum.sosinvision.com.br/
 * Email:				administracao@sosinvision.com.br
 */
 
class top20reputation extends public_forums_extras_stats
{
    public function doExecute( ipsRegistry $registry )
    {
        switch( $this->request['do'] )
        {
			case 'reputation':
				$this->_showTopReputacao();
			break;
        }

        parent::doExecute( $registry );
    }

	private function _showTopReputacao()
 	{
		ipsRegistry::getClass( 'class_localization')->loadLanguageFile( array( 'public_stats' ) );
		
		$where = array();
		
		$where[] = 'pp.pp_reputation_points > 0';
		
		/* Banned users ? */
		if ( !$this->settings['top20rep_banned'] )
		{
			$where[] = "member_banned = 0 AND member_group_id != {$this->settings['banned_group']}";
		}
		
		if ( count( $where ) )
		{
			$condition = join( ' AND ', $where );
        }

		/* Top users */
        $this->DB->build(array( 'select'   => 'm.*',
                                'from'     => array('members' => 'm'),
                                'add_join' => array(
                                0 => array( 'select' => 'pp.*',
						  	  				'from'   => array( 'profile_portal' => 'pp' ),
										  	'where'  => 'pp.pp_member_id=m.member_id',
							  				'type'   => 'left' ),
                                ),
                                'where'	 => $condition,
                                'order'  => "pp.pp_reputation_points DESC, m.member_id",
   								'limit'  => array( 0, 20 ),
        ) );
		
		$query = $this->DB->execute();

		while( $r = $this->DB->fetch( $query ) )
		{
			$r = IPSMember::buildProfilePhoto( $r );
			$members[ $r['member_id'] ] = $r;
		}
		
		$this->output .= $this->registry->getClass('output')->getTemplate('stats')->top_reputation( $members );
		
		$this->registry->output->setTitle( $this->lang->words['top20rep_title'] );
		$this->registry->output->addNavigation( $this->lang->words['top20rep_title'], '' );

		$this->registry->output->addContent( $this->output );
        $this->registry->output->sendOutput();
	}
}