class sos32_gchovercard extends skin_global(~id~)
{
	function userHoverCard($member=array())
	{
		$formatted = $this->caches['group_cache'][ $member['member_group_id'] ]['prefix'].$member['members_display_name'].$this->caches['group_cache'][ $member['member_group_id'] ]['suffix'];
		
		if($member['members_display_name'] != $formatted)
		{
			$member['members_display_name'] = $formatted;
		}

		return parent::userHoverCard($member);
	}
}