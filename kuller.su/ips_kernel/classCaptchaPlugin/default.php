<?php
/**
 * @file		default.php 	Plugin for the default CAPTCHA GD image
 *~TERABYTE_DOC_READY~
 * $Copyright: (c) 2001 - 2011 Invision Power Services, Inc.$
 * $License: http://www.invisionpower.com/company/standards.php#license$
 * $Author: bfarber $
 * @since		Friday 19th May 2006 17:33
 * $LastChangedDate: 2012-02-10 20:05:52 -0500 (Fri, 10 Feb 2012) $
 * @version		v3.4.2
 * $Revision: 10288 $
 */

/**
 *
 * @class		captchaPlugin
 * @brief		Plugin for the default CAPTCHA GD image
 * @note		This plugin is automatically loaded by classCaptcha class based on the CAPTCHA setting
 *
 */
class captchaPlugin
{
	/**#@+
	 * Registry Object Shortcuts
	 *
	 * @var		object
	 */
	public $registry;
	public $DB;
	public $settings;
	public $member;
	/**#@-*/
	
	/**
	 * String that stores the backgrounds path
	 *
	 * @var		string
	 */
	public $path_background		= '';
	
	/**
	 * String that stores the fonts path
	 *
	 * @var		string
	 */
	public $path_fonts			= '';

	/**
	 * String that stores the captcha key
	 *
	 * @var		string
	 */
	public $captchaKey 			= '';
	
	/**
	 * Constructor
	 *
	 * @param	object		$registry		Registry Object
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry )
	{
		$this->registry	=  $registry;
		$this->DB		=  $this->registry->DB();
		$this->settings	=& $this->registry->fetchSettings();
		$this->member	=  $this->registry->member();
		
		/* Settings */
		$this->path_background	= DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_captcha/captcha_backgrounds';
		$this->path_fonts		= DOC_IPS_ROOT_PATH . PUBLIC_DIRECTORY . '/style_captcha/captcha_fonts';
	}
	
	/**
	 * Returns the captcha template
	 *
	 * @return	@e string
	 *
	 * <b>Example Usage:</b>
	 * @code
	 * $gdImage = $this->getTemplate();
	 * @endcode
	 */
	public function getTemplate()
	{
		//-----------------------------------------
		// Clear old
		//-----------------------------------------
		
		$this->_clearSessions( $this->member->ip_address );
		
		//-----------------------------------------
		// Create new ID
		//-----------------------------------------
		
		$captcha_unique_id = md5( uniqid( time() ) );
		$captcha_string    = "";
		
		//-----------------------------------------
		// Create new string
		//-----------------------------------------

		/**
		 * Array of characters 
		 * Removed: 0, o, O, 1, l, I, i, L (because they're hard to differentiate)
		 */
		$array_of_chars = array( 
								'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'j', 'k', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
								'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
								'2', '3', '4', '5', '6', '7', '8', '9',
								);
		
		/* Get 6 random characters */
		for( $i = 0; $i < 6; $i++ )
		{
			$idx = mt_rand( 0, count( $array_of_chars ) - 1 );
			$captcha_string .= $array_of_chars[ $idx ];
		}		
		
		//-----------------------------------------
		// Add to the DB
		//-----------------------------------------
		
		$this->DB->insert( 'captcha', array( 'captcha_unique_id' => $captcha_unique_id,
											 'captcha_string'    => $captcha_string,
											 'captcha_ipaddress' => $this->member->ip_address,
											 'captcha_date'      => time() ) );
		
		/* Make available */
		$this->captchaKey = $captcha_unique_id;
		
		/* Return template */
		return $this->registry->output->getTemplate('global_other')->captchaGD( $captcha_unique_id );
	}
	
	/**
	 * Validates the entered captcha code, returning true on success and false on failure
	 *
	 * @return	@e boolean
	 *
	 * <b>Example Usage:</b>
	 * @code
	 * $isValid = $this->validate();
	 * @endcode
	 */
	public function validate()
	{
		/* Init vars */
		$captcha_unique_id       = IPSText::alphanumericalClean( $_REQUEST['captcha_unique_id'] );
		$captcha_input_NOT_CLEAN = trim( $_REQUEST['captcha_string'] );
		
		/* Get ID from DB */
		$captcha = $this->DB->buildAndFetch( array( 'select' => '*', 'from' => 'captcha', 'where' => "captcha_unique_id='". addslashes( $captcha_unique_id )."'" ) );
	
		if ( ! $captcha['captcha_unique_id'] )
		{
			return FALSE;
		}
		
		/* Check */
		if ( $captcha['captcha_string'] != $captcha_input_NOT_CLEAN )
		{
			return FALSE;
		}
		else
		{
			$this->_clearSessions( $this->member->ip_address );
			return TRUE;
		}
	}
	
	/**
	 * Generates the captcha image.  Returns false on failure.
	 *
	 * @param	array		$captcha_unique_id		Key 0 of the array contains the Unique ID
	 * @return	@e mixed
	 *
	 * <b>Example Usage:</b>
	 * @code
	 * $captchaImage = $this->showImage( $captcha_unique_id );
	 * @endcode
	 */
	public function showImage( $captcha_unique_id )
	{
		//-----------------------------------------
		// Magic _call method makes an array
		//-----------------------------------------
		
		$captcha_unique_id	= $captcha_unique_id[0];
		
		if ( ! $captcha_unique_id )
		{
			return false;
		}
		
		/* Get the info from the DB */
		$captcha = $this->DB->buildAndFetch( array( 'select' => '*', 'from' => 'captcha', 'where' => "captcha_unique_id='" . $captcha_unique_id . "'" ) );
	
		if ( ! $captcha['captcha_unique_id'] )
		{
			return false;
		}
		
		/* Show it... */
		$this->_showGDImage( $captcha['captcha_string'] );
	}

	/**
	 * Prints captcha image and headers
	 *
	 * @param	string		$content		Key to show in the GD image
	 * @return	@e void
	 *
	 * <b>Example Usage:</b>
	 * @code
	 * $this->_showGDImage( $captcha_string );
	 * @endcode
	 */
	protected function _showGDImage( $content="" )
	{
		//-----------------------------------------
		// Is GD Available?
		//-----------------------------------------
		
		if ( ! extension_loaded('gd') )
		{
			@header( "Content-Type: image/gif" );
			print base64_decode( "R0lGODlhyAA8AJEAAN/f3z8/P8zMzP///yH5BAAAAAAALAAAAADIADwAAAL/nI+py+0Po5y02ouz3rz7D4biSJbmiabqyrbuC8fyTNf2jef6zvf+DwwKh8Si8YhMlgACwEHQXESfzgOzykQAqgMmFMr9Rq+GbHlqAFsFWnFVrfwIAvQAu15P0A14Nn8/ADhXd4dnl2YYCAioGHBgyDbnNzBIV0gYxzEYWdg1iLAnScmFuQdAt2UKZTcl+mip+HoYG+tKOfv3N5l5garnmPt6CwyaFzrranu7i0crObvoaKvMyMhrIQhFuyzcyGwXcOpoLYg7DGsZXk5r6DSN51RNfF0RPU5sy7gpnH5bjLhrk7Y9/RQNisfq2CRJauTR6xUuFyBx/yrWypMMmTlq/9IwQnKWcKG5cvMeShBIMOFIaV9w2eti6SBABAyjvBRFMaZCMaxsqtxl8iShjpj+VfqGCJg4XzOfJCK5DVWliFNXlSIENKjWrVy7ev0KNqzYsWTFwhlFU8waLk+efGF7hi0aSgu3iGmV1cxdoGTinimbiGOeP8SWhps6z3AkeMMWW20mMykqQyuJDbYWdufKBJWc2uWmAJZdO0yOKfTCCqHGiO4E/oKGriTYaBw5g/MDqynNlW9Uhmx66tM2i05dNcM8O6Rg2MHLYKraLTpDcLebTke4APkcduAoku0DWpe24MI96ewZPdiy6Rlx/0Y+XJevlNu/z6vtlHFxZbpv9f9edYkfxgVmjnqSxXYOYPfFVMgXIHGC0ltWDNXYJ6Lsw82AFVpWEk4pEabgbsfBM5FphyDWRh1OLCUgbC06NtNU6UV1T1Jl3YhjjjruyGOPPv4IZJBC6tDXGUDB4UUaK06RhRl/0aWWF3CR4YWESraR1ZCh6dMOiMNIFE2GI/bRJYiIEeULiloyUNSFLzWC3VXcqEJXTBe1qApDpbXUEYxr2tYeQCyyGMuIcxbokHfPvPjHf25mqeWHoLEX0iH0UScmUzSWNxmj20yH6Z+/yNTeM0N1cumkg9E4GHnluLcfeKLm95yLoO5ZKJrhgeaQm4xlFGshcK3pYZ9LradQrmY5nmhVdMm+qqpKYkIqpDyltWkpjJJaaKmd6kXjHUXvDPborOaei2666q7LbrvuvgtvvPLOS2+9YBUAADs=" );
			exit();
		}
				
		//-----------------------------------------
		// INIT
		//-----------------------------------------
		
		$content       = '  '. preg_replace( "/(\w)/", "\\1 ", $content ) .' ';
		$use_fonts     = 0;
		$tmp_x         = 135;
		$tmp_y         = 20;
		$image_x       = 200;
		$image_y       = 60;
		$circles       = 3;
		$continue_loop = TRUE;
		$_started      = FALSE;
		
		//-----------------------------------------
		// Get backgrounds and fonts...
		//-----------------------------------------
		
		$backgrounds = $this->_getBackgrounds();
		$fonts       = $this->_getFonts();

		//-----------------------------------------
		// Got a background?
		//-----------------------------------------
		$_imgs = array();
		
		while ( $continue_loop )
		{
			if ( is_array( $backgrounds ) AND count( $backgrounds ) )
			{
				$i = mt_rand(0, count( $backgrounds ) - 1 );
			
				$background      = $backgrounds[ $i ];
				$_file_extension = preg_replace( "#^.*\.(\w{2,4})$#is", "\\1", strtolower( $background ) );
			
				switch( $_file_extension )
				{
					case 'jpg':
					case 'jpe':
					case 'jpeg':
						if ( ! function_exists('imagecreatefromjpeg') OR ! $im = @imagecreatefromjpeg($background) )
						{
							unset( $backgrounds[ $i ] );
						}
						else
						{
							$_imgs[] = $im;
							
							if( count( $_imgs ) > 2 )
							{
								$continue_loop = FALSE;
								$_started      = TRUE;
							}
						}
						break;
					case 'gif':
						if ( ! function_exists('imagecreatefromgif') OR ! $im = @imagecreatefromgif($background) )
						{
							unset( $backgrounds[ $i ] );
						}
						else
						{
							$_imgs[] = $im;
							
							if( count( $_imgs ) > 2 )
							{
								$continue_loop = FALSE;
								$_started      = TRUE;
							}
						}
						break;
					case 'png':
						if ( ! function_exists('imagecreatefrompng') OR ! $im = @imagecreatefrompng($background) )
						{
							unset( $backgrounds[ $i ] );
						}
						else
						{
							$_imgs[] = $im;
							
							if( count( $_imgs ) > 2 )
							{
								$continue_loop = FALSE;
								$_started      = TRUE;
							}
						}
						break;
				}
			}
			else
			{
				$continue_loop = FALSE;
			}
		}
		
		/* Create a new background */
		if( count( $_imgs > 2 ) )
		{
			/* Setup */
			$strip_count = 8;
			$strips      = ceil( $image_x / $strip_count );
			$im          = imagecreatetruecolor( $image_x, $image_y );	
			$curr_offset = 0;
			$alternate   = 0;
			
			for( $i = 0; $i < $strip_count; $i++ )
			{
				/* Alternate the background */
				$alternate++;
				$alternate = ( $alternate > 2 ) ? 0 : $alternate;
				
				/* Width of the strip */
				$end_strip = ( $i * $strips ) + mt_rand( 1, $strips );
				
				/* Copy the splice */
				imagecopymerge( $im, $_imgs[$alternate], $curr_offset, 0, $curr_offset, 0, $end_strip, $image_y, mt_rand( 1, 100 ) );
				
				/* Increment the offset */
				$curr_offset += $end_strip;
			}
			
			$_started = TRUE;
			
		}
		
		//-----------------------------------------
		// Still not got one? DO OLD FASHIONED
		//-----------------------------------------
		
		if ( $_started !== TRUE )
		{
			$im  = imagecreatetruecolor($image_x, $image_y);
			$tmp = imagecreatetruecolor($tmp_x, $tmp_y);
			
			$white  = ImageColorAllocate($tmp, 255, 255, 255);
			$black  = ImageColorAllocate($tmp, 0, 0, 0);
			$grey   = ImageColorAllocate($tmp, 200, 200, 200 );

			imagefill($tmp, 0, 0, $white);

			for ( $i = 1; $i <= $circles; $i++ )
			{
				$values = array(
								0  => mt_rand(0, $tmp_x - 10),
								1  => mt_rand(0, $tmp_y - 3),
								2  => mt_rand(0, $tmp_x - 10),
								3  => mt_rand(0, $tmp_y - 3),
								4  => mt_rand(0, $tmp_x - 10),
								5  => mt_rand(0, $tmp_y - 3),
								6  => mt_rand(0, $tmp_x - 10),
								7  => mt_rand(0, $tmp_y - 3),
								8  => mt_rand(0, $tmp_x - 10),
								9  => mt_rand(0, $tmp_y - 3),
								10 => mt_rand(0, $tmp_x - 10),
								11 => mt_rand(0, $tmp_y - 3),
						     );

				$randomcolor = imagecolorallocate( $tmp, mt_rand(100,255), mt_rand(100,255), mt_rand(100,255) );
				imagefilledpolygon($tmp, $values, 6, $randomcolor );
			}

			$num     = strlen($content);
			$x_param = 0;
			$y_param = 0;

			for( $i = 0; $i < $num; $i++ )
			{
				$x_param += mt_rand(-1,12);
				$y_param = mt_rand(-3,8);
				
				if( $x_param + 18 > $image_x )
				{
					$x_param -= ceil( $x_param + 18 - $image_x );
				}

				$randomcolor = imagecolorallocate( $tmp, mt_rand(0,150), mt_rand(0,150), mt_rand(0,150) );

				imagestring($tmp, 5, $x_param+1, $y_param+1, $content{$i}, $grey);
				imagestring($tmp, 5, $x_param, $y_param, $content{$i}, $randomcolor);
			}

			//-----------------------------------------
			// Distort by resizing
			//-----------------------------------------

			imagecopyresized($im, $tmp, 0, 0, 0, 0, $image_x, $image_y, $tmp_x, $tmp_y);

			imagedestroy($tmp);
			
			//-----------------------------------------
			// Background dots and lines
			//-----------------------------------------

			$random_pixels = $image_x * $image_y / 10;

			for ($i = 0; $i < $random_pixels; $i++)
			{
				$randomcolor = imagecolorallocate( $im, mt_rand(0,150), mt_rand(0,150), mt_rand(0,150) );
				ImageSetPixel($im, mt_rand(0, $image_x), mt_rand(0, $image_y), $randomcolor);
			}

			$no_x_lines = ($image_x - 1) / 5;

			for ( $i = 0; $i <= $no_x_lines; $i++ )
			{
				ImageLine( $im, $i * $no_x_lines, 0, $i * $no_x_lines, $image_y, $grey );
				ImageLine( $im, $i * $no_x_lines, 0, ($i * $no_x_lines)+$no_x_lines, $image_y, $grey );
			}

			$no_y_lines = ($image_y - 1) / 5;

			for ( $i = 0; $i <= $no_y_lines; $i++ )
			{
				ImageLine( $im, 0, $i * $no_y_lines, $image_x, $i * $no_y_lines, $grey );
			}
		}
		else
		{
			//-----------------------------------------
			// Can we use fonts?
			//-----------------------------------------
			
			if ( function_exists('imagettftext') AND is_array( $fonts ) AND count( $fonts ) )
			{
				if ( function_exists('imageantialias') )
				{
					imageantialias( $im, TRUE );
				}
				
				$num       = strlen($content);
				$x_param   = -10;
				$y_param   = 0;

				for( $i = 0; $i < $num; $i++ )
				{
					/* Random Font */
					$_font       = $fonts[ mt_rand( 0, count( $fonts ) - 1 ) ];
					
					$y_param     = mt_rand( 35, 48 );
					
					# Main color
					$col_r       = mt_rand(50,200);
					$col_g       = mt_rand(0,150);
					$col_b       = mt_rand(50,200);
					# High light
					$col_r_l     = ( $col_r + 50 > 255 ) ? 255 : $col_r + 50;
					$col_g_l     = ( $col_g + 50 > 255 ) ? 255 : $col_g + 50;
					$col_b_l     = ( $col_b + 50 > 255 ) ? 255 : $col_b + 50;
					# Low light
					$col_r_d     = ( $col_r - 50 < 0 ) ? 0 : $col_r - 50;
					$col_g_d     = ( $col_g - 50 < 0 ) ? 0 : $col_g - 50;
					$col_b_d     = ( $col_b - 50 < 0 ) ? 0 : $col_b - 50;
					
					$color_main  = imagecolorallocate( $im, $col_r, $col_g, $col_b );
					$color_light = imagecolorallocate( $im, $col_r_l, $col_g_l, $col_b_l );
					$color_dark  = imagecolorallocate( $im, $col_r_d, $col_g_d, $col_b_d );
					$_slant      = mt_rand( -20, 40 );
					
					if ( $i == 1 OR $i == 3 OR $i == 5 )
					{
						for( $ii = 0 ; $ii < 2 ; $ii++ )
						{
							$a   = $x_param + 50;
							$b   = mt_rand(0,100);
							$c   = $a + 20;
							$d   = $b + 20;
							$e   = ( $i == 3 ) ? mt_rand( 280, 320 ) : mt_rand( -320, -280 );
							
							imagearc( $im, $a  , $b  , $c, $d, 0, $e, $color_light );
							imagearc( $im, $a+1, $b+1, $c, $d, 0, $e, $color_main );
						}
					}
					
					$text_size = mt_rand( 24, 30 ); //24
					
					if ( ! $_result = @imagettftext( $im, $text_size, $_slant, $x_param - 1, $y_param - 1, $color_light, $_font, $content[$i] ) )
					{
						$use_fonts = FALSE;
						break;
					}
					else
					{
						@imagettftext( $im, $text_size, $_slant, $x_param + 1, $y_param + 1, $color_dark, $_font, $content[$i] );
						@imagettftext( $im, $text_size, $_slant, $x_param, $y_param, $color_main, $_font, $content[$i] );
					}
					
					$x_param += mt_rand( 13, 16 ); //15,18
					
					if( $x_param + 18 > $image_x )
					{
						$x_param -= ceil( $x_param + 18 - $image_x );
					}					
				}

				$use_fonts = TRUE;
			}
			
			if ( ! $use_fonts )
			{
				//-----------------------------------------
				// Continue with nice background image
				//-----------------------------------------
			
				$tmp         = imagecreatetruecolor($tmp_x  , $tmp_y  );
				$tmp2        = imagecreatetruecolor($image_x, $image_y);
		
				$white       = imagecolorallocate( $tmp, 255, 255, 255 );
				$black       = imagecolorallocate( $tmp, 0, 0, 0 );
				$grey        = imagecolorallocate( $tmp, 100, 100, 100 );
				$transparent = imagecolorallocate( $tmp2, 255, 255, 255 );
				$_white      = imagecolorallocate( $tmp2, 255, 255, 255 );
			
				imagefill($tmp , 0, 0, $white );
				imagefill($tmp2, 0, 0, $_white);
			
				$num         = strlen($content);
				$x_param     = 0;
				$y_param     = 0;

				for( $i = 0; $i < $num; $i++ )
				{
					if ( $i > 0 )
					{
						$x_param += mt_rand( 6, 12 );
						
						if( $x_param + 18 > $image_x )
						{
							$x_param -= ceil( $x_param + 18 - $image_x );
						}
					}
				
					$y_param  = mt_rand( 0, 5 );
				
					$randomcolor = imagecolorallocate( $tmp, mt_rand(50,200), mt_rand(50,200), mt_rand(50,200) );

					imagestring( $tmp, 5, $x_param + 1, $y_param + 1, $content{$i}, $grey );
					imagestring( $tmp, 5, $x_param    , $y_param    , $content{$i}, $randomcolor );
				}
			
				imagecopyresized($tmp2, $tmp, 0, 0, 0, 0, $image_x, $image_y, $tmp_x, $tmp_y );
			
				$tmp2 = $this->_showGDImageWave( $tmp2, 8, true );
			
				imagecolortransparent( $tmp2, $transparent );
				imagecopymerge( $im, $tmp2, 0, 0, 0, 0, $image_x, $image_y, 100 );
		
				imagedestroy($tmp);
				imagedestroy($tmp2);
			}
		}
		
		//-----------------------------------------
		// Blur?
		//-----------------------------------------
		
		if ( function_exists( 'imagefilter' ) )
		{
			@imagefilter( $im, IMG_FILTER_GAUSSIAN_BLUR );
		}
		
		//-----------------------------------------
		// Render a border
		//-----------------------------------------
		
		$black = imagecolorallocate( $im, 0, 0, 0 );
		
		imageline( $im, 0, 0, $image_x, 0, $black );
		imageline( $im, 0, 0, 0, $image_y, $black );
		imageline( $im, $image_x - 1, 0, $image_x - 1, $image_y, $black );
		imageline( $im, 0, $image_y - 1, $image_x, $image_y - 1, $black );
		
		//-----------------------------------------
		// Show it!
		//-----------------------------------------
		
		@header( "Content-Type: image/jpeg" );
		
		imagejpeg( $im );
		imagedestroy( $im );
		
		exit();
	}

	/**
	 * Create wave effect for GD images
	 *
	 * @param	resources		$im		Image resource
	 * @param	integer			$wave	Wave factor
	 * @return	@e resource
	 *
	 * <b>Example Usage:</b>
	 * @code
	 * $imageResource = $this->_showGDImageWave( $captcha_string );
	 * @endcode
	 */
	protected function _showGDImageWave( $im, $wave=10 )
	{
		$_width  = imagesx( $im );
		$_height = imagesy( $im );

		$tmp = imagecreatetruecolor( $_width, $_height );

		$_direction = ( time() % 2 ) ? TRUE : FALSE;

		for ( $x = 0; $x < $_width; $x++ )
		{
			for ( $y = 0 ; $y < $_height ; $y++ )
			{
				$xo = $wave * sin( 2 * 3.1415 * $y / 128 );
				$yo = $wave * cos( 2 * 3.1415 * $x / 128 );

				$_x = $x - $xo;
				$_y = $y - $yo;
				
				if ( ($_x > 0 AND $_x < $_width) AND ($_y > 0 AND $_y < $_height) )
				{
					$index  = imagecolorat($im, $_x, $_y);
               		$colors = imagecolorsforindex($im, $index);
               		$color  = imagecolorresolve( $tmp, $colors['red'], $colors['green'], $colors['blue'] );
				}
				else
				{
					$color = imagecolorresolve( $tmp, 255, 255, 255 );
				}

				imagesetpixel( $tmp, $x, $y, $color );
			}
		}

		return $tmp;
	}

	/**
	 * Removes extinct captcha sessions or 'dead' entries
	 *
	 * @param	string		$ip_address		Optional IP address to clear out on
	 * @return	@e void
	 *
	 * <b>Example Usage:</b>
	 * @code
	 * $this->_clearSessions( $ip_address );
	 * @endcode
	 */
	protected function _clearSessions( $ip_address='' )
	{
		/* Init vars */
		$time  = time() - 60 * 3600;
		$extra = ( $ip_address ) ? " OR captcha_ipaddress='" . $ip_address . "'" : '';
		
		/* Remove from DB */
		$this->DB->delete( 'captcha', 'captcha_date < ' . $time . $extra );
	}
	
	/**
	 * Retrieves the list of backgrounds from the specified path
	 *
	 * @return	@e array
	 *
	 * <b>Example Usage:</b>
	 * @code
	 * $images = $this->_getBackgrounds();
	 * @endcode
	 */
	protected function _getBackgrounds()
	{
		/* Init vars */
		$images = array();
		$_path  = $this->path_background;
		
		/* Loop */
		if ( $_dir = opendir( $_path ) )
		{
			while( false !== ( $_file = readdir( $_dir ) ) )
			{
				if ( preg_match( "#\.(gif|jpeg|jpg|png)$#i", $_file ) )
				{
					$images[] = $_path . '/' . $_file;
				}
			}
		}

		return $images;
	}

	/**
	 * Retrieves the list of fonts from the specified path
	 *
	 * @return	@e array
	 *
	 * <b>Example Usage:</b>
	 * @code
	 * $fonts = $this->_getFonts();
	 * @endcode
	 */
	protected function _getFonts()
	{
		/* Init vars */
		$fonts  = array();
		$_path  = $this->path_fonts;
		
		/* Loop */
		if ( $_dir = @opendir( $_path ) )
		{
			while( false !== ( $_file = @readdir( $_dir ) ) )
			{
				if ( preg_match( "#\.(ttf)$#i", $_file ) )
				{
					$fonts[] = $_path . '/' . $_file;
				}
			}
		}
		
		return $fonts;
	}
}