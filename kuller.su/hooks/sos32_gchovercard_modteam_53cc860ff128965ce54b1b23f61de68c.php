class sos32_gchovercard_modteam extends skin_stats(~id~)
{
    function group_strip($group="", $members=array())
	{
		foreach($members as &$info)
		{
			$info['members_display_name'] = $this->caches['group_cache'][ $info['member_group_id'] ]['prefix'].$info['members_display_name'].$this->caches['group_cache'][ $info['member_group_id'] ]['suffix'];
		}

		return parent::group_strip($group, $members);
	}

    function top_posters($rows)
	{
		foreach($rows as &$info)
		{
			$info['members_display_name'] = $this->caches['group_cache'][ $info['member_group_id'] ]['prefix'].$info['members_display_name'].$this->caches['group_cache'][ $info['member_group_id'] ]['suffix'];
		}

		return parent::top_posters($rows);
	}
}