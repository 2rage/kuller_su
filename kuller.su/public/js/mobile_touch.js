document.observe("dom:loaded", function() 
{
	$$("#secondary_navigation a").each( function(e) { Event.observe(e, "click", loadUrl ); } );	
	$$(".touch-row").each(function(e) { Event.observe(e, "click", touchRowClick); addArrow(e); });
	$$("a.prev:not(.disabled), a.next:not(.disabled)").invoke("on", "click", loadUrl);
	$$(".post").each(function(e) { Event.observe(e, "click", postClick); });
	$$('.sd_content').invoke('on', 'click', '.sd_content', toggleDeletedContent);
	Event.observe($('options-button'), "click", openNavigation);
	if($('filter-option')) {Event.observe($('filter-option'), "click", openFilter);}
	$('options-button').setStyle({'display': 'block'});
	if( $('nav_markread') ){
		$('nav_markread').down('a').observe('click', markAsRead);
	};

	parseQuoteBoxes();
	
	if ( $('full_version') )
	{
		$('full_version').on( 'click', function( e, elem )
		{
			Event.stop(e);
			
			var url = ipb.vars['base_url'] + 'app=core&module=ajax&section=skin&do=change&skinId=fullVersion&secure_key=' + ipb.vars['secure_hash'];
			
			Debug.write( url );
			new Ajax.Request(	url,
								{
									method: 'get',
									onSuccess: function(t)
									{
										/*
										 * Get an error?
										 */
										if( t.responseJSON['status'] == 'ok' )
										{
											window.location = window.location;
											window.location.reload(true);
										}
										else
										{
											ipb.global.errorDialogue( ipb.lang['ajax_failure'] );
										}
									}
								}
							);
			} );
	}
	if( $('show_langs') ){
		$('show_langs').on('click', function(e){
			$('show_langs').hide();
			$('show_langs_box').show();
			Event.stop(e);
			return false;
		});
	}
	
	/* Set this here to 'toggle' works later */
	$('shade').setStyle({'display': 'none'});
	
	if ( $('filter-letters') ){
		$('filter-letters').toggleClassName('hidden');
	}
	
	// Set up user nav box
	var items = $("user_navigation").down("ul").select("li").size();
	var diff = 3 - (items % 3);
	
	/* Ensure loading box isn't visible */
	if ( $('loadingBox') )
	{
		$('loadingBox').remove();
	}
	
	resizeEmbeds();
	
	for(i=0; i<diff; i++){
		$("user_navigation").down("ul").insert({bottom: new Element("li").addClassName("dummy").insert( new Element("span") ) });
	}
});

/* Ensure embedded videos are sized nicely */
function resizeEmbeds()
{
	$$('embed').each( function( embed )
	{
		if ( embed.src && embed.width && embed.height )
		{
			var pct = 0;
			
			while ( embed.width > 440 )
			{
				pct += 10;
				
				embed.width = embed.width - ( ( embed.width / 100 ) * pct );
			}
			
			if ( pct > 0 )
			{
				embed.height = embed.height - ( ( embed.height / 100 ) * pct );
			}
		}
	} );
}

function toggleDeletedContent(e, element)
{
	Event.stop(e);
	
	var id = element.id.replace('seeContent_', '');
	
	$('postsDelete-' + id).hide();
	$('post-' + id).show();	
}

function markAsRead(e)
{
	if( !confirm( ipb.lang['clear_markboard'] ) ){
		Event.stop(e);
	}	
}

function mobileFilter( e, element )
{
	Event.stop(e);
	
	// Does the pane exist?
	if( !$( element.id + '_pane' ) ){
		return;
	}
	
	$('shade').toggle();
	$( element.id + '_pane' ).show();
}

function closePane( e, element )
{
	Event.stop(e);
	$(element).up(".ipsFilterPane").hide();
	$('shade').hide();
}

/**
 * Add the touch arrow */
function addArrow(e)
{
	d = e.getDimensions();
	t = ( d.height / 2 ) - 18;
	
	if ( ! e.inspect().match( '<h2' ) )
	{
		e.insert( { 'top' : new Element( 'div', { 'class': 'touch-row-arrow', 'style': 'margin-top:' + t + 'px !important' } ) } );
	}
}

function touchRowClick()
{
	$$('#' + this.id + ' a.title').each(function(e) { loadUrl( e ); });
}

function loadUrl( e )
{
	/* Show loading box */
	var content = LOADING_TEMPLATE.evaluate();
	
	$('ipbwrapper').insert( { 'after' : content } );
	positionCenter( $('loadingBox') );
	
	window.location = e.href;
}

function postClick()
{
	if( $(this.id + '-controls') ){
		$(this.id + '-controls').toggleClassName('visible');
	}
}

function openNavigation()
{
	//vp = document.viewport.getDimensions();
	
	var elem = $( document.body ).getLayout();
	$('user_navigation').toggle();
	$('user_navigation').setStyle( { 'position': 'absolute', 'width': elem.get('margin-box-width') + 'px' } );
	$('shade').toggle();
}

function openFilter()
{
	if ( $('filter-letters') )
	{
		$('filter-letters').toggleClassName('hidden');
	}
	
	$('filter-option').setStyle({'display': 'none'});
}

function positionCenter( elem, dir )
{
	if( !$(elem) ){ return; }
	elem_s = $(elem).getDimensions();
	window_s = document.viewport.getDimensions();
	window_offsets = document.viewport.getScrollOffsets();

	center = { 	left: ((window_s['width'] - elem_s['width']) / 2),
				 top: ((window_s['height'] - elem_s['height']) / 2)
			};

	if ( window_offsets['top'] )
	{
		center['top'] += window_offsets['top'];
	}
	
	if( typeof(dir) == 'undefined' || ( dir != 'h' && dir != 'v' ) )
	{
		$(elem).setStyle('top: ' + center['top'] + 'px; left: ' + center['left'] + 'px');
	}
	else if( dir == 'h' )
	{
		$(elem).setStyle('left: ' + center['left'] + 'px');
	}
	else if( dir == 'v' )
	{
		$(elem).setStyle('top: ' + center['top'] + 'px');
	}
	
	$(elem).setStyle('position: fixed');
}

var Debug = {
	write: function( text ){
		if( !Object.isUndefined(window.console) ){
			console.log( text );
		}
		/*else if( jsDebug )
		{
			if( !$('_inline_debugging') ){
				var _inline_debug =  new Element('div', { id: '_inline_debugging' }).setStyle('background: rgba(0,0,0,0.7); color: #fff; padding: 10px; width: 97%; height: 150px; position: absolute; bottom: 0; overflow: auto; z-index: 50000').show();
				
				if( !Object.isUndefined( $$('body')[0] ) ){
					$$('body')[0].insert( _inline_debug );
				}
			}
			
			try {
				$('_inline_debugging').innerHTML += "<br />" + text;
			} catch(err){}
		}*/
	},
	dir: function( values ){
		if( jsDebug && !Object.isUndefined(window.console) && ! Prototype.Browser.IE && ! Prototype.Browser.Opera ){
			console.dir( values );
		}
	},
	error: function( text ){
		if( jsDebug && !Object.isUndefined(window.console) ){
			console.error( text );
		}
	},
	warn: function( text ){
		if( jsDebug && !Object.isUndefined(window.console) ){
			console.warn( text );
		}
	},
	info: function( text ){
		if( jsDebug && !Object.isUndefined(window.console) ){
			console.info( text );
		}
	}
};

function parseQuoteBoxes()
{
	$$('blockquote.ipsBlockquote').each( function( el )
	{
		if ( ! $(el).hasClassName('built') )
		{
			var author    = '';
			var cid       = '';
			var time      = 0;
			var date      = '';
			var collapsed = 0;
			var _extra    = '';
			var _a        = new Element('span');
			
			try {
				author    = $(el).getAttribute( 'data-author' )    ? $(el).getAttribute( 'data-author' )    : '';
				cid       = $(el).getAttribute( 'data-cid' )       ? $(el).getAttribute( 'data-cid' )       : '';
				time      = $(el).getAttribute( 'data-time' )      ? $(el).getAttribute( 'data-time' )      : 0;
				date      = $(el).getAttribute( 'data-date' )      ? $(el).getAttribute( 'data-date' )      : '';
				collapsed = $(el).getAttribute( 'data-collapsed' ) ? $(el).getAttribute( 'data-collapsed' ) : 0;
			} catch( aCold ) { }
			
			if ( author )
			{
				_extra = author + ',';
			}
			
			if ( date )
			{
				_extra += ' ' + ipb.lang['quote_on'] + ' ' + date;
			}
			else if ( time )
			{
				if ( time == parseInt( time ) && time.length == 10 )
				{
					var _date = new Date().getDateAndTime( time );
					time      = _date['date'] + ' ' + _date['monthName'] + ' ' + _date['year'] + ' - ' + _date['hour'] + ':' + _date['min'];
				}
				
				_extra += ' ' + ipb.lang['quote_on'] + ' ' + time;
			}
			
			if ( _extra )
			{
				_extra += ', ' + ipb.lang['quote_said'] + ':';
			}
			
			/* finally.. */
			if ( _extra.length == 0 )
			{
				_extra = ipb.lang['quote_title'];
			}
			
			if ( cid && parseInt( cid ) == cid )
			{
				_a = new Element( 'a', { 'class': 'snapback right', rel: 'citation', href: ipb.vars['board_url'] + '/index.php?app=forums&module=forums&section=findpost&pid=' + cid } );
				_a.update( new Element( 'img', { src: ipb.vars['img_url'] + '/snapback.png' } ) );
			}
			
			el.insert( { before: new Element( 'p', { 'class': 'citation' } ).update( _extra ).insert( _a ) } );
			el.addClassName( 'built' );
			
			if ( collapsed )
			{
				el.down('p').hide();
				el.insert( new Element( 'p', { 'class': '___x clickable' } ).update( ipb.lang['quote_expand'] ) );
				
				el.down('p.___x').on( 'click', function( e, elem )
				{
					elem.up('blockquote').down('p').show();
					elem.hide();
				} );
			}
		}
	} );
}

function warningPopup( elem, id )
{
	window.location = ipb.vars['base_url'] + '&app=members&module=profile&section=warnings&do=acknowledge&id=' + id
}


// Extend date object to return date and time as object
Date.prototype.getDateAndTime = function( unix )
{
	 var a      = new Date( unix * 1000);
	 var months = ipb.lang['gbl_months'].split(',');
	 var year   = a.getFullYear();
	 var month  = months[a.getMonth()];
	 var date   = a.getDate();
	 var hour   = a.getHours();
	 var min    = a.getMinutes();
	 var sec    = a.getSeconds();
	
	 return { year    : year,
		 	 monthName: month,
		 	 month    : ( '0' + a.getMonth() + 1 ).slice( -2 ),
		 	 date     : ( '0' + date ).slice( -2 ),
		 	 hour     : ( '0' + hour ).slice( -2 ),
		 	 min      : ( '0' + min ).slice( -2 ),
		 	 sec      : ( '0' + sec ).slice( -2 ) };
};