<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * XML Handler: Rewritten for PHP5
 * By Matt Mecham
 * Last Updated: $Date: 2012-07-27 11:43:25 -0400 (Fri, 27 Jul 2012) $
 * </pre>
 *
 * @author 		$Author: mark $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @subpackage	Kernel
 * @link		http://www.invisionpower.com
 * @since		25th February 2004
 * @version		$Revision: 11149 $
 *
 *
 * Example Usage:
 * <code>
 * <productlist name="myname" version="1.0">
 *  <productgroup name="thisgroup">
 *   <product id="1.0">
 *    <description>This is a descrption</description>
 *    <title>Baked Beans</title>
 *    <room store="1">103</room>
 *   </product>
 *	 <product id="2.0">
 *    <description>This is another descrption</description>
 *    <title>Green Beans</title>
 *    <room store="2">104</room>
 *   </product>
 *  </productgroup>
 * </productlist>
 * 	
 * Creating...
 * $xml = new classXML( 'utf-8' );
 * $xml->newXMLDocument();
 * 
 * /* Create a root element * /
 * $xml->addElement( 'productlist', '', array( 'name' => 'myname', 'version' => '1.0' ) );
 * /* Add a child.... * /
 * $xml->addElement( 'productgroup', 'productlist', array( 'name' => 'thisgroup' ) );
 * $xml->addElementAsRecord( 'productgroup',
 * 									array( 'product', array( 'id' => '1.0' ) ),
 * 											array( 'description' => array( 'This is a description' ),
 * 												   'title'		 => array( 'Baked Beans' ),
 * 												   'room'		 => array( '103', array( 'store' => 1 ) )
 * 												)
 * 						);
 * $xml->addElementAsRecord( 'productgroup',
 * 									array( 'product', array( 'id' => '2.0' ) ),
 * 											array( 'description' => array( 'This is another description' ),
 * 												   'title'		 => array( 'Green Beans' ),
 * 												   'room'		 => array( '104', array( 'store' => 2 ) )
 * 												)
 * 						);
 * 						
 * $xmlData = $xml->fetchDocument();
 * 
 * /*Convering XML into an array * /
 * $xml->loadXML( $xmlData );
 * 
 * /* Grabbing specific data values from all 'products'... * /
 * foreach( $xml->fetchElements('product') as $products )
 * {
 * 	print $xml->fetchItem( $products, 'title' ) . "\\";
 * }
 * 
 * /* Prints... * /
 * Baked Beans
 * Green Beans
 * 
 * /* Print all array data - auto converts XML_TEXT_NODE and XML_CDATA_SECTION_NODE into #alltext for brevity * /
 * print_r( $xml->fetchXMLAsArray() );					
 * 
 * /* Prints * /
 * Array
 * (
 *     [productlist] => Array
 *         (
 *             [@attributes] => Array
 *                 (
 *                     [name] => myname
 *                     [version] => 1.0
 *                 )
 *             [productgroup] => Array
 *                 (
 *                     [@attributes] => Array
 *                         (
 *                             [name] => thisgroup
 *                         )
 *                     [product] => Array
 *                         (
 *                             [0] => Array
 *                                 (
 *                                     [@attributes] => Array
 *                                         (
 *                                             [id] => 1.0
 *                                         )
 *                                     [description] => Array
 *                                         (
 *                                             [#alltext] => This is a description
 *                                         )
 *                                     [title] => Array
 *                                         (
 *                                             [#alltext] => Baked Beans
 *                                         )
 *                                     [room] => Array
 *                                         (
 *                                             [@attributes] => Array
 *                                                 (
 *                                                     [store] => 1.0
 *                                                 )
 *                                             [#alltext] => 103
 *                                         )
 *                                 )
 *                             [1] => Array
 *                                 (
 *                                     [@attributes] => Array
 *                                         (
 *                                             [id] => 2.0
 *                                         )
 *                                     [description] => Array
 *                                         (
 *                                             [#alltext] => This is another description
 *                                         )
 *                                     [title] => Array
 *                                         (
 *                                             [#alltext] => Green Beans
 *                                         )
 *                                     [room] => Array
 *                                         (
 *                                             [@attributes] => Array
 *                                                 (
 *                                                     [store] => 1.0
 *                                                 )
 *                                             [#alltext] => 104
 *                                         )
 *                                 )
 *                         )
 *                 )
 *         )
 * )
 * 
 * </code>
 *
 */
 
class classXML
{
	/**
	 * Document character set
	 *
	 * @var		string
	 */
	protected $_docCharSet = 'utf-8';
	
	/**
	 * Current document object
	 *
	 * @var		object
	 */
	protected $_dom;
	
	/**
	 * Array of DOM objects
	 *
	 * @var		array
	 */
	protected $_domObjects = array();
	
	/**
	 * XML array
	 *
	 * @var		array
	 */
	protected $_xmlArray = array();
	
	/**
	 * Conversion class
	 *
	 * @var		object
	 */
	protected static $classConvertCharset;
	
	/**
	 * Constructor
	 *
	 * @param	string	Character Set
	 * @return	@e void
	 */
	public function __construct( $charSet )
	{
		$this->_docCharSet = strtolower( $charSet );
	}
	
	/**
	 * Create new document
	 *
	 * @return	@e void
	 */
	public function newXMLDocument()
	{
		$this->_dom = new DOMDocument( '1.0', 'utf-8' );
	}
	
	/**
	 * Fetch the document
	 *
	 * @return	@e string
	 */
	public function fetchDocument()
	{
		$this->_dom->formatOutput = TRUE;
		return $this->_dom->saveXML();
	}
	
	/**
	 * Add element into the document
	 *
	 * @param	string		Name of tag to create
	 * @param	string		[Name of parent tag (optional)]
	 * @param	array		[Attributes]
	 * @param	string		[Namespace URI]
	 * @return	@e void
	 */
	public function addElement( $tag, $parentTag='', $attributes=array(), $namespaceUri='' )
	{
		$this->_domObjects[ $tag ] = $this->_node( $parentTag )->appendChild( new DOMElement( $tag, '', $namespaceUri ) );
		$this->addAttributes( $tag, $attributes );
	}
	
	/**
	 * Add element into the document as a record row
	 * You can pass $tag as either a string or an array
	 *
	 * $xml->addElementAsRecord( 'parentTag', 'myTag', $data );
	 * $xml->addElementAsRecord( 'parentTag', array( 'myTag', array( 'attr' => 'value' ) ), $data );
	 *
	 * @param	string		Name of parent tag
	 * @param	mixed		Tag wrapper
	 * @param	array 		Array of data to add
	 * @param	string		[Namespace URI]
	 * @return	@e void
	 */
	public function addElementAsRecord( $parentTag, $tag, $data, $namespaceUri='' )
	{
		/* A little set up if you please... */
		$_tag      = $tag;
		$_tag_attr = array();
		
		if ( is_array( $tag ) )
		{
			$_tag      = $tag[0];
			$_tag_attr = $tag[1];
		}
		
		$record = $this->_node( $parentTag )->appendChild( new DOMElement( $_tag, ( is_array( $data ) ? NULL : $data ), $namespaceUri ) );
		
		if ( is_array( $_tag_attr ) AND count( $_tag_attr ) )
		{
			foreach( $_tag_attr as $k => $v )
			{
				$record->appendChild( new DOMAttr( $k, $v ) );
			}
		}
			
		/* Now to add the data */
		if ( is_array( $data ) AND count( $data ) )
		{
			foreach( $data as $rowTag => $rowData )
			{
				/* You can pass an array.. or not if you don't need attributes */
				if ( ! is_array( $rowData ) )
				{
					$rowData = array( 0 => $rowData );
				}
				
				if ( preg_match( "/['\"\[\]<>&]/", $rowData[0] ) )
				{
					$_child = $record->appendChild( new DOMElement( $rowTag ) ); 
					$_child->appendChild( new DOMCDATASection( $this->_inputToXml( $rowData[0] ) ) );
				}
				else
				{
					$_child = $record->appendChild( new DOMElement( $rowTag, $this->_inputToXml( $rowData[0] ) ) );
				}
				
				if ( $rowData[1] )
				{
					foreach( $rowData[1] as $_k => $_v )
					{
						$_child->appendChild( new DOMAttr( $_k, $_v ) );
					}
				}
				
				unset( $_child );
			}
		}
	}
	
	/**
	 * Add attributes to a node
	 *
	 * @param	string		Name of tag
	 * @param	array 		Array of attributes in key => value format
	 * @return	@e void
	 */
	public function addAttributes( $tag, $data )
	{
		if ( is_array( $data ) AND count( $data ) )
		{
			foreach( $data as $k => $v )
			{
				$this->_node( $tag )->appendChild( new DOMAttr( $k, $v ) );
			}
		}
	}
	
	/**
	 * Load a document from a file
	 *
	 * @param	string 		File name
	 * @return	@e void
	 */
	public function load( $filename )
	{
		$this->_dom = new DOMDocument;
		$this->_dom->load( $filename );
	}
	
	/**
	 * Load a document from a string
	 *
	 * @param	string 		XML Data
	 * @return	@e bool
	 */
	public function loadXML( $xmlData )
	{
		$this->_dom = new DOMDocument;
		
		if( defined('LIBXML_PARSEHUGE') )
		{
			return @$this->_dom->loadXML( $xmlData, LIBXML_PARSEHUGE );
		}
		else
		{
			return @$this->_dom->loadXML( $xmlData );
		}
	}
	
	/**
	 * Wrapper function: Fetch elements based on tag name
	 *
	 * @param	string		Tag  Name to fetch from the DOM tree
	 * @param	object		Node to start from
	 * @return	@e array
	 */
	public function fetchElements( $tag, $node=null )
	{
		$start		= $node ? $node : $this->_dom;
		$_elements = $start->getElementsByTagName( $tag );
		
		return ( $_elements->length ) ? $_elements : array();
	}
	
	/**
	 * Wrapper function: Fetch all items within a parent tag
	 *
	 * @param	object		DOM object as returned from getElementsByTagName
	 * @param	array 		array of node names to skip
	 * @return	@e array
	 */
	public function fetchElementsFromRecord( $dom, $skip=array() )
	{
		$array = array();
		
		foreach( $dom->childNodes as $node )
		{
			if ( $node->nodeType == XML_ELEMENT_NODE )
			{
				if ( is_array( $skip ) )
				{
					if ( in_array( $node->nodeName, $skip ) )
					{
						continue;
					}
				}

				$array[ $node->nodeName ] = $this->_xmlToOutput( $node->nodeValue );
			}
		}
		
		return $array;
	}
	
	/**
	 * Wrapper function: Fetch items from an element node
	 *
	 * @param	object		DOM object as returned from getElementsByTagName
	 * @param	string 		[Optional: Tag name if the DOM is a parent]
	 * @return	@e string
	 */
	public function fetchItem( $dom, $tag='' )
	{
		if ( $tag )
		{
			$_child = $dom->getElementsByTagName( $tag );
			return $this->_xmlToOutput( $_child->item(0)->firstChild->nodeValue );
		}
		else
		{
			return $this->_xmlToOutput( $dom->nodeValue );
		}
	}
	
	/**
	 * Wrapper function: Fetch attributes from an element node's item
	 *
	 * @param	object		DOM object as returned from getElementsByTagName
	 * @param	string 		Attribute name required...
	 * @param	string 		[Optional: Tag name if the DOM is a parent]
	 * @return	@e string
	 */
	public function fetchAttribute( $dom, $attribute, $tag='' )
	{
		if ( $tag )
		{
			$_child = $dom->getElementsByTagName( $tag );
			return $_child->item(0)->getAttribute( $attribute );
		}
		else
		{
			return $dom->getAttribute( $attribute );
		}
	}
	
	/**
	 * Wrapper function: Fetch all attributes from an element node's item
	 *
	 * @param	object		DOM object as returned from getElementsByTagName
	 * @param	string 		Tag name to fetch attribute from
	 * @return	@e array
	 */
	public function fetchAttributesAsArray( $dom, $tag )
	{
		$attrs      = array();
		$_child     = $dom->getElementsByTagName( $tag );
		$attributes = $_child->item(0)->attributes;
		
		foreach( $attributes as $val )
		{
			$attrs[ $val->nodeName ] = $val->nodeValue;
		}
		
		return $attrs;
	}
	
	/**
	 * Fetch entire DOM tree into a single array
	 *
	 * @return	@e array
	 */
	public function fetchXMLAsArray()
	{
		return $this->_fetchXMLAsArray( $this->_dom );
	}
	
	/**
	 * Internal function to recurse through and collect nodes and data
	 *
	 * @param	DOM object 		Node element
	 * @return	@e array
	 */
	protected function _fetchXMLAsArray( $node )
	{
		$_xmlArray = array();
		
		if ( $node->nodeType == XML_TEXT_NODE )
		{
			$_xmlArray = $this->_xmlToOutput( $node->nodeValue );
		}
		else if ( $node->nodeType == XML_CDATA_SECTION_NODE )
		{
			$_xmlArray = $this->_xmlToOutput( $node->nodeValue );
		}
		else
		{
			if ( $node->hasAttributes() )
			{
				$attributes = $node->attributes;
				
				if ( ! is_null( $attributes ) )
				{
					foreach( $attributes as $index => $attr )
					{
						$_xmlArray['@attributes'][ $attr->name ] = $attr->value;
					}
				}
			}
			
			if ( $node->hasChildNodes() )
			{
				$children  = $node->childNodes;
				$occurance = array();

				foreach( $children as $nc)
			    {
					if ( $nc->nodeName != '#text' AND $nc->nodeName != '#cdata-section' )
					{
			    		$occurance[ $nc->nodeName ]	= isset($occurance[ $nc->nodeName ]) ? $occurance[ $nc->nodeName ] + 1 : 1;
					}
			    }
				
				for( $i = 0 ; $i < $children->length ; $i++ )
				{
					$child = $children->item( $i );
					$_name = $child->nodeName;
					
					if ( $child->nodeName == '#text' OR $child->nodeName == '#cdata-section' )
					{
						$_name = '#alltext';
					}
					
					if ( isset($occurance[ $child->nodeName ]) AND $occurance[ $child->nodeName ] > 1 )
					{
						$_xmlArray[ $_name ][] = $this->_fetchXMLAsArray( $child );
					}
					else
					{
						$_xmlArray[ $_name ] = $this->_fetchXMLAsArray( $child );
					}
				}
			}
		}
		
		return $_xmlArray;
	}
	
	/**
	 * Encode CDATA XML attribute (Make safe for transport)
	 *
	 * @param	string		Raw data
	 * @return	@e string
	 */
	protected function _xmlConvertSafecdata( $v )
	{
		$v = str_replace( "<![CDATA[", "<!#^#|CDATA|", $v );
		$v = str_replace( "]]>"      , "|#^#]>"      , $v );
		
		return $v;
	}

	/**
	 * Decode CDATA XML attribute (Make safe for transport)
	 *
	 * @param	string		Raw data
	 * @return	@e string
	 */
	protected function _xmlUnconvertSafecdata( $v )
	{
		$v = str_replace( "<!#^#|CDATA|", "<![CDATA[", $v );
		$v = str_replace( "|#^#]>"      , "]]>"      , $v );
		
		return $v;
	}
	
	/**
	 * Return a tag object
	 *
	 * @param	string		Name of tag
	 * @return	@e object		
	 */
	protected function _node( $tag )
	{
		if ( isset($this->_domObjects[ $tag ]) )
		{
			return $this->_domObjects[ $tag ];
		}
		else
		{
			return $this->_dom;
		}
	}
	
	/**
	 * Convert from native to UTF-8 for saving XML
	 *
	 * @param	string		Input Text
	 * @return	@e string
	 */
	protected function _inputToXml( $text )
	{
		/* Do we need to make safe on CDATA? */
		if ( preg_match( "/['\"\[\]<>&]/", $text ) )
		{
			$text = $this->_xmlConvertSafecdata( $text );
		}
		
		/* Using UTF-8 */
		if ( $this->_docCharSet == 'utf-8' )
		{
			return $text;
		}
		/* Are we using the most common ISO-8559-1... */
		else if ( $this->_docCharSet == 'iso-8859-1' )
		{
			return utf8_encode( $text );
		}
		else
		{
			return $this->_convertCharsets( $text, $this->_docCharSet, 'utf-8' );
		}
	}
	
	/**
	 * Convert from UTF-8 to native for saving XML
	 *
	 * @param	string		Input Text
	 * @return	@e string
	 */
	protected function _xmlToOutput( $text )
	{
		/* Unconvert cdata */
		$text = $this->_xmlUnconvertSafecdata( $text );
		
		/* Using UTF-8 */
		if ( $this->_docCharSet == 'utf-8' )
		{
			return $text;
		}
		/* Are we using the most common ISO-8559-1... */
		else if ( $this->_docCharSet == 'iso-8859-1' )
		{
			return utf8_decode( $text );
		}
		else
		{
			return $this->_convertCharsets( $text, 'utf-8', $this->_docCharSet );
		}
	}
	
	/**
	 * Convert a string between charsets. XML will always be UTF-8
	 *
	 * @param	string		Input String
	 * @param	string		Current char set
	 * @param	string		Destination char set
	 * @return	@e string
	 * @todo 	[Future] If an error is set in classConvertCharset, show it or log it somehow
	 */
	protected function _convertCharsets( $text, $original_cset, $destination_cset="UTF-8" )
	{
		$original_cset    = strtolower($original_cset);
		$destination_cset = strtolower( $destination_cset );
		$t                = $text;

		//-----------------------------------------
		// Not the same?
		//-----------------------------------------

		if ( $destination_cset == $original_cset )
		{
			return $t;
		}

		if ( ! is_object( self::$classConvertCharset ) )
		{
			require_once( dirname(__FILE__) . '/classConvertCharset.php' );/*noLibHook*/
			self::$classConvertCharset = new classConvertCharset();
			
			//-----------------------------------------
			// Ok, mb functions only support limited number
			// of charsets, so if mb functions are enabled
			// but using e.g. windows-1250, no conversion
			// ends up happening.  Let's force internal.
			//-----------------------------------------
			
			//if ( function_exists( 'mb_convert_encoding' ) )
			//{
			//	self::$classConvertCharset->method = 'mb';
			//}
			//else if ( function_exists( 'iconv' ) )
			//{
			//	self::$classConvertCharset->method = 'iconv';
			//}
			//else if ( function_exists( 'recode_string' ) )
			//{
			//	self::$classConvertCharset->method = 'recode';
			//}
			//else
			//{
				self::$classConvertCharset->method = 'internal';
			//}
		}

		$text = self::$classConvertCharset->convertEncoding( $text, $original_cset, $destination_cset );

		return $text ? $text : $t;
	}
}