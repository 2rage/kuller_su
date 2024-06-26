<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Template Plugin: Add to head
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @version		$Rev: 10721 $
 */

/**
* Main loader class
*/
class tp_addtohead extends output implements interfaceTemplatePlugins
{
	/**
	 * Prevent our main destructor being called by this class
	 *
	 * @access	public
	 * @return	@e void
	 */
	public function __destruct()
	{
	}
	
	/**
	 * Run the plug-in
	 *
	 * @access	public
	 * @author	Matt Mecham
	 * @param	string   The initial data from the tag
	 * @param	array    Array of options
	 * @return	string   Processed HTML
	 */
	public function runPlugin( $data, $options )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$return    = '';

		switch( $options['type'] )
		{
			case 'javascript':
			case 'js':
				return '" . ' . "\$this->registry->getClass('output')->addToDocumentHead( 'javascript', \"" .$data . '" )' . ' . "';
			break;
			case 'inlinecss':
				return '" . ' . "\$this->registry->getClass('output')->addToDocumentHead( 'inlinecss', \"" .$data . '" )' . ' . "';
			break;
			case 'importcss':
				return '" . ' . "\$this->registry->getClass('output')->addToDocumentHead( 'importcss', \"" .$data . '" )' . ' . "';
			break;
			case 'raw':
				return '" . ' . "\$this->registry->getClass('output')->addToDocumentHead( 'raw', \"" .$data . '" )' . ' . "';
			break;
		}
			
		return '';
	}
	
	/**
	 * Return information about this modifier.
	 *
	 * It MUST contain an array  of available options in 'options'. If there are no allowed options, then use an empty array.
	 * Failure to keep this up to date will most likely break your template tag.
	 *
	 * @access	public
	 * @author	Matt Mecham
	 * @return	array
	 */
	public function getPluginInfo()
	{
		//-----------------------------------------
		// Return the data, it's that simple...
		//-----------------------------------------
		
		return array( 'name'    => 'addtohead',
					  'author'  => 'IPS, Inc.',
					  'usage'   => '{parse addtohead="{$this->settings[\'public_dir\']}js/myJS.js" type="javascript"}',
					  'options' => array( 'type' ) );
	}
}