<?php

class sos32_gchovercard_boardIndex extends class_forums
{
	public function getForumList()
	{
		/* Get the forums */			
		$this->DB->build( array( 
								'select'   => 'f.*',
								'from'     => array( 'forums' => 'f' ),
							//	'order'    => 'f.parent_id, f.position',
								'add_join' => array(
													array( 'select' => 'm.member_group_id as last_poster_group_id',
														   'from'   => array( 'members' => 'm' ),
														   'where'  => "m.member_id = f.last_poster_id",
														   'type'   => 'left' ),
													array( 'select' => 'p.*',
															'from'   => array( 'permission_index' => 'p' ),
															'where'  => "p.perm_type='forum' AND p.app='forums' AND p.perm_type_id=f.id",
															'type'   => 'left' ) ) ) );
						
		$q = $this->DB->execute();
		
		/* Loop through and build an array of forums */
		$forums_list	= array();
		$update_seo		= array();
		$tempForums     = array();
		
		while( $f = $this->DB->fetch( $q ) )
		{
			$tempForums[ $f['parent_id'] . '.' . $f['position'] . '.' . $f['id'] ] = $f;
		}

		/* Sort in PHP */
		$tempForums = IPSLib::knatsort( $tempForums );
		
		foreach( $tempForums as $posData => $f )
		{
			$fr = array();
			
			/**
			 * This is here in case the SEO name isn't stored for some reason.
			 * We'll parse it and then update the forums table - should only happen once
			 */
			if ( ! $f['name_seo'] )
			{
				/* SEO name */
				$f['name_seo'] = IPSText::makeSeoTitle( $f['name'] );
				
				$update_seo[ $f['id'] ]	= $f['name_seo'];
			}

			/* Last Post Info (author stuff!) */
			$f['last_poster_name'] = $this->caches['group_cache'][ $f['last_poster_group_id'] ]['prefix'].$f['last_poster_name'].$this->caches['group_cache'][ $f['last_poster_group_id'] ]['suffix'];
			
			/* Reformat the array for a category */
			if ( $f['parent_id'] == -1 )
			{
				$fr['id']				    = $f['id'];
				$fr['sub_can_post']         = $f['sub_can_post'];
				$fr['name'] 		        = $f['name'];
				$fr['name_seo'] 			= $f['name_seo'];
				$fr['parent_id']	        = $f['parent_id'];
				$fr['skin_id']		        = $f['skin_id'];
				$fr['permission_showtopic'] = $f['permission_showtopic'];
				$fr['forums_bitoptions']    = $f['forums_bitoptions'];
				$fr['hide_last_info']		= 0;
				$fr['can_view_others']		= 0;
				$fr['password']				= $f['password'];
				
				/* Permission index columns */
				$fr['app']					= $f['app'];
				$fr['perm_id']				= $f['perm_id'];
				$fr['perm_type']			= $f['perm_type'];
				$fr['perm_type_id']			= $f['perm_type_id'];
				$fr['perm_view']			= $f['perm_view'];
				$fr['perm_2']				= $f['perm_2'];
				$fr['perm_3']				= $f['perm_3'];
				$fr['perm_4']				= $f['perm_4'];
				$fr['perm_5']				= $f['perm_5'];
				$fr['perm_6']				= $f['perm_6'];
				$fr['perm_7']				= $f['perm_7'];
				$fr['owner_only']			= $f['owner_only'];
				$fr['friend_only']			= $f['friend_only'];
				$fr['authorized_users']		= $f['authorized_users'];
			}
			else
			{
				$fr = $f;

				$fr['description'] = isset( $f['description'] ) ? $f['description'] : '';
			}
			
			$fr = array_merge( $fr, $this->registry->permissions->parse( $f ) );

			/* Unpack bitwise fields */
			$_tmp = IPSBWOptions::thaw( $fr['forums_bitoptions'], 'forums', 'forums' );

			if ( count( $_tmp ) )
			{
				foreach( $_tmp as $k => $v )
				{
					/* Trigger notice if we have DB field */
					if ( isset( $fr[ $k ] ) )
					{
						trigger_error( "Thawing bitwise options for FORUMS: Bitwise field '$k' has overwritten DB field '$k'", E_USER_WARNING );
					}

					$fr[ $k ] = $v;
				}
			}
			
			/* Add... */
			$forums_list[ $fr['id'] ] = $fr;
		}

		$this->allForums	= $forums_list;
		
		/**
		 * Update forums table if SEO name wasn't cached yet
		 */
		if( count($update_seo) )
		{
			foreach( $update_seo as $k => $v )
			{
				$this->DB->update( 'forums', array( 'name_seo' => $v ), 'id=' . $k );
			}
		}
		
		return $forums_list;
	}
}