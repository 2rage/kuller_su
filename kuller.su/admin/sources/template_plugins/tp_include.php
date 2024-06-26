<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Template Pluging: Include
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
class tp_include extends output implements interfaceTemplatePlugins
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
	 * @param	string	The initial data from the tag
	 * @param	array	Array of options
	 * @return	string	Processed HTML
	 */
	public function runPlugin( $data, $options )
	{
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$return = '';
		
		//-----------------------------------------
		// Make life easier...
		//-----------------------------------------
		
		$data = str_replace( '#IPS_ROOT_PATH#'    , IPS_ROOT_PATH    , $data );
		$data = str_replace( '#IPS_DOC_ROOT_PATH#', IPS_DOC_ROOT_PATH, $data );
		$data = str_replace( '#ROOT#'             , IPS_DOC_ROOT_PATH, $data );
		
		//-----------------------------------------
		// Attempt to get data
		//-----------------------------------------
		
		$return = <<<EOF
ob_start();
include( "$data" );/*noLibHook*/
\$data = ob_get_contents();
ob_end_clean();
EOF;
		
		return "<!--included content-->\n\";\n {$return} \$IPBHTML .= \$data . \"\n<!--/ included content-->";
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
					  'usage'   => '{parse include="/path/to/file"}',
					  'options' => array() );
	}
}