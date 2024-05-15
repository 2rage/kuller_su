<?php
/**
 * (TB) Show Reputation in User Info
 * @file		tbShowRepInUserInfo.php 	Template Hook (userInfoPane)
 *
 * @copyright	(c) 2006 - 2012 Invision Byte
 * @link		http://www.invisionbyte.net/
 * @author		Terabyte
 * @since		10/07/2009
 * @updated		12/05/2012
 * @version		3.1.0 (31000)
 */
class tbShowRepInUserInfo
{
	public $registry;
	public $settings;
	
	public function __construct()
	{
		/* Make registry objects */
		$this->registry   =  ipsRegistry::instance();
		$this->settings   =& $this->registry->fetchSettings();
	}
	
	public function getOutput()
	{
		return '';
	}
	
	public function replaceOutput( $output, $key )
	{
		/* Do we have it enabled? =O */
		if( $this->registry->member()->getProperty('g_mem_info') > 0 && $this->settings['reputation_enabled'] && $this->settings['reputation_show_profile'] && is_array($this->registry->output->getTemplate('global')->functionData['userInfoPane']) AND count($this->registry->output->getTemplate('global')->functionData['userInfoPane']) )
		{
			/* Cleanup our variable */
			$this->settings['reputation_protected_groups'] = IPSText::cleanPermString($this->settings['reputation_protected_groups']);
			
			/* Init some vars */
			$tag	= '<!--hook.' . $key . '-->';
			$tagStr	= strlen( $tag );
			$last	= 0;
			$notSee = empty($this->settings['reputation_protected_groups']) ? array() : explode(',', $this->settings['reputation_protected_groups']);
			
			foreach( $this->registry->output->getTemplate('global')->functionData['userInfoPane'] as $_id => $_data )
			{
				$pos = strpos( $output, $tag, $last );
				
				if( $pos !== FALSE )
				{
					$string	= ( !isset($_data['author']['pp_reputation_points']) || IPSMember::isInGroup($_data['author'], $notSee) ) ? '' : $this->registry->getClass('output')->getTemplate('global')->tbSruiHook( $_data['author'] );
					$output	= substr_replace( $output, $string . $tag, $pos, $tagStr );
					$last	= $pos + strlen( $string . $tag );
				}
				else
				{
					/* Not found, useless to go on... */
					break;
				}
			}
		}
		
		return $output;
	}
}