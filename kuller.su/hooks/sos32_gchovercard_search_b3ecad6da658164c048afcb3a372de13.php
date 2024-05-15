class sos32_gchovercard_search extends skin_search(~id~)
{
    function asForumTopics($data)
	{
		$topicc = IPSMember::load( $data['starter_id'] );
 		$lastp  = IPSMember::load( $data['last_poster_id'] );
 		
		$starter 	= $this->caches['group_cache'][ $topicc['member_group_id'] ]['prefix'].$data['starter_name'].$this->caches['group_cache'][ $topicc['member_group_id'] ]['suffix'];
		$lastposter = $this->caches['group_cache'][ $lastp['member_group_id'] ]['prefix'].$data['last_poster_name'].$this->caches['group_cache'][ $lastp['member_group_id'] ]['suffix'];
		$data['starter'] 	 = IPSMember::makeProfileLink($starter   , $data['starter_id']    , $topicc['members_seo_name']);
		$data['last_poster'] = IPSMember::makeProfileLink($lastposter, $data['last_poster_id'], $lastposter['members_seo_name']);
	
		return parent::asForumTopics($data);
	}
}