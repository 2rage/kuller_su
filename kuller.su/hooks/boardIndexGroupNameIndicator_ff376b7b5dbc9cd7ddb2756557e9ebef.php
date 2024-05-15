<?php

class boardIndexGroupNameIndicator
{
	protected $registry;
	protected $settings;
	protected $caches;
	
	public function __construct()
	{
		/* Make registry objects */
		$this->registry =  ipsRegistry::instance();
		$this->settings =& $this->registry->fetchSettings();
		$this->caches   =& $this->registry->cache()->fetchCaches();
	}
	
	public function getOutput()
	{
		/* INIT */
		$data = array();
		
		/* Loop through each group */
		foreach ( $this->caches['group_cache'] as $id => $group )
		{
			/* Displaying?  Filter out Guest group */
			if ( isset( $group['g_display'] ) && $group['g_display'] && $id != $this->settings['guest_group'] )
			{
				/* Link, or just text? */
				if ( $group['g_hide_from_list'] )
				{
					$data[ $group['g_display'] ] = IPSMember::makeNameFormatted( $group['g_title'], $id );
				}
				else
				{
					$data[ $group['g_display'] ] = "<a href='" . $this->registry->getClass( 'output' )->buildUrl( 'app=members&amp;section=view&amp;module=list&amp;filter='.$id, 'public' ) . "'>" . IPSMember::makeNameFormatted( $group['g_title'], $id ) . "</a>";
				}
			}
		}
		
		/* Put in Group Name Indicator order */
		ksort( $data );
		
		/* Return */
		return $this->registry->output->getTemplate('boards')->hookGroupNameIndicator( $data );
	}
}