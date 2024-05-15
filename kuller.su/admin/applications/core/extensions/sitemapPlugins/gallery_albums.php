<?php

if(!IN_IPB)
{
	die('This file is not designed to be accessed directly.');
}

class sitemap_core_gallery_albums extends ipseoSitemapPlugin
{
	public function generate()
	{
		$galleryClassFile = IPSLib::getAppDir('gallery') . '/sources/classes/gallery.php';
		
		if(!IPSLib::appIsInstalled('gallery') || $this->settings['sitemap_priority_gallery_albums'] == 0 || !is_file($galleryClassFile))
		{
			return;
		}
		
		$classToLoad = IPSLib::loadLibrary( $galleryClassFile, 'ipsGallery', 'gallery' );
		$this->registry->setClass( 'gallery', new $classToLoad( $this->registry ) );
		
		$limitCount = 0;																
		while(1)
		{
			if(ipSeo_SitemapGenerator::isCronJob())
			{
				sleep(0.5);
			}
			
			$filters = array( 
								'sortOrder'		=> 'desc', 
								'sortKey'		=> 'date',
								'offset'		=> $limitCount, 
								'limit'			=> 100, 
								'isViewable'	=> true, 
								'memberData'	=> array( 'member_id' => 0 ) 
							);
			
			$albums = $this->registry->gallery->helper('albums')->fetchAlbumsByFilters( $filters );
			
			foreach($albums as $album)
			{
				$addedCount = $this->sitemap->addUrl($album['selfSeoUrl'], $album['album_last_img_date'], $this->settings['sitemap_priority_gallery_albums']);
			}
			
			$limitCount += 100;
			
			if(count($albums) < 100)
			{
				break;
			}
		}
	}
}