<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * User CP: Handles form display / saving as well as custom events
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		MattMecham
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @since		Wednesday 28th May 2008 16:42 GMT
 * @version		$Revision: 10721 $
 *
 */

interface interface_usercp
{
	
	/**
	 * Return links for this tab
	 * You may return an empty array or FALSE to not have
	 * any links show in the tab.
	 *
	 * The links must have 'area=xxxxx'. The rest of the URL
	 * is added automatically.
	 * 'area' can only be a-z A-Z 0-9 - _
	 *
	 * @access	public
	 * @author	Matt Mecham
	 * @return	array 	Array of links
	 */
	public function getLinks();
	
	/**
	 * Initiates the module. You can put any global set-up in this section!
	 *
	 * @access	public
	 * @author	Matt mecham
	 * @return	@e void
	 */
	public function init();
	
    /**
	 * Run custom event
	 *
	 * If you pass a 'do' in the URL / post form that is not either:
	 * save / save_form or show / show_form then this function is loaded
	 * instead. You can return a HTML chunk to be used in the UserCP (the
	 * tabs and footer are auto loaded) or redirect to a link.
	 *
	 * If you are returning HTML, you can use $this->hide_form_and_save_button = 1;
	 * to remove the form and save button that is automatically placed there.
	 *
	 * @access	public
	 * @author	Matt Mecham
	 * @param	string			The current area as retrieved from 'area=xxxx' in the URL
	 * @return	mixed			html or void
	 */
	public function runCustomEvent( $currentArea );
	
	/**
	 * UserCP Form Show
	 *
	 * @access	public	
	 * @author	Matt Mecham
	 * @param	string	Current area as defined by 'getLinks'
	 * @param	array	Error array
	 * @return	string	Processed HTML
	 */
	public function showForm( $current_area, $errors=array() );
	
	/**
	 * UserCP Form Save
	 *
	 * @access	public
	 * @author	Matt Mecham
	 * @param	string	Current area as defined by 'getLinks'
	 * @return	@e void
	 */
	public function saveForm( $current_area );

}