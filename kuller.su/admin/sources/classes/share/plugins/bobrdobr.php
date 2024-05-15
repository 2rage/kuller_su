<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.1.0 Beta 2
 * Bobrdobr plug in for share links library.
 * This is just the basic fallback bobrdobr share, the front end has JS to do something more fancy
 *
 * Created by Matt Mecham
 * Last Updated: $Date: 2010-01-25 13:21:25 +0000 (Mon, 25 Jan 2010) $
 * </pre>
 *
 * @author 		$Author: matt $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/community/board/license.html
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @version		$Rev: 5746 $
 *
 */

/* Class name must be in the format of:
   sl_{key}
   Where {key}, place with the value of: core_share_links.share_key
 */
class sl_bobrdobr
{
	/**#@+
	* Registry Object Shortcuts
	*
	* @access	protected
	* @var		object
	*/
	protected $DB;
	protected $settings;
	protected $lang;
	protected $member;
	protected $memberData;
	protected $cache;
	protected $caches;
	/**#@-*/
	
	/**
	 * Construct.
	 * @access	public
	 * @param	object		Registry
	 * @return	void
	 */
	public function __construct( $registry )
	{
		/* Make object */
		$this->registry   =  $registry;
		$this->DB         =  $this->registry->DB();
		$this->settings   =& $this->registry->fetchSettings();
		$this->request    =& $this->registry->fetchRequest();
		$this->lang       =  $this->registry->getClass('class_localization');
		$this->member     =  $this->registry->member();
		$this->memberData =& $this->registry->member()->fetchMemberData();
		$this->cache      =  $this->registry->cache();
		$this->caches     =& $this->registry->cache()->fetchCaches();
	}
	
	/**
	 * Requires a permission check
	 *
	 * @access	public
	 * @param	array		Data array
	 * @return	boolean
	 */
	public function requiresPermissionCheck( $array )
	{
		return false;
	}

	/**
	 * Redirect to Twitter
	 * Exciting, isn't it.
	 *
	 * @access	private
	 * @param	string		Plug in
	 */
	public function share( $title, $url )
	{
		$title = IPSText::convertCharsets( $title, IPS_DOC_CHAR_SET, 'utf-8' );
		$url   = "http://bobrdobr.ru/addext.html?url=" . urlencode( $url ) . '&title=' . urlencode( $title );
		
		$this->registry->output->silentRedirect( $url );
	}

		
}