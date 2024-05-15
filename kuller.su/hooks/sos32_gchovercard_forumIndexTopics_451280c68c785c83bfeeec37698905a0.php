class sos32_gchovercard_forumIndexTopics extends skin_forum(~id~)
{
    function topic($data, $forum_data, $other_data, $inforum)
	{
		$topicc = IPSMember::load( $data['starter_id'] );
 		$lastp  = IPSMember::load( $data['last_poster_id'] );
 		
		$starter 	= $this->caches['group_cache'][ $topicc['member_group_id'] ]['prefix'].$data['starter_name'].$this->caches['group_cache'][ $topicc['member_group_id'] ]['suffix'];
		$lastposter = $this->caches['group_cache'][ $lastp['member_group_id'] ]['prefix'].$data['last_poster_name'].$this->caches['group_cache'][ $lastp['member_group_id'] ]['suffix'];

		$data['starter'] 	 = IPSMember::makeProfileLink($starter   , $data['starter_id']    , $topicc['members_seo_name']);
		$data['last_poster'] = IPSMember::makeProfileLink($lastposter, $data['last_poster_id'], $lastposter['members_seo_name']);

		return parent::topic($data, $forum_data, $other_data, $inforum);
	}

    function forumIndexTemplate($forum_data, $announce_data, $topic_data, $other_data, $multi_mod_data, $sub_forum_data, $footer_filter, $active_user_data, $mod_data, $inforum=1)
	{
 		if ( $forum_data['sub_can_post'] == 0 )
 		{
			return parent::forumIndexTemplate($forum_data, $announce_data, $topic_data, $other_data, $multi_mod_data, $sub_forum_data, $footer_filter, $active_user_data, $mod_data, $inforum);
		}

		foreach($announce_data as &$adata)
		{
			$adata['member_name'] = $this->caches['group_cache'][ $adata['member_group_id'] ]['prefix'].$adata['member_name'].$this->caches['group_cache'][ $adata['member_group_id'] ]['suffix'];
		}

		return parent::forumIndexTemplate($forum_data, $announce_data, $topic_data, $other_data, $multi_mod_data, $sub_forum_data, $footer_filter, $active_user_data, $mod_data, $inforum);
	}
}