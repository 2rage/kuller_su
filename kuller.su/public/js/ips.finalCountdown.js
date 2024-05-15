FCJQuery(document).ready( function($)
{
	function finalCountdown_serverTime() 
	{ 
	    var time = null; 
	    $.ajax({
	    	url: ipb.vars['base_url'] + "app=finalCountdown&module=ajax&section=ajax&do=serverSync&md5check=" + ipb.vars['secure_hash'],
	    	async: false, 
	    	dataType: 'text', 
	    	success: function(text) 
	    	{ 
	    		time = new Date(text); 
	    	}, 
	    	error: function(http, message, exc) 
	    	{ 
	    		time = new Date(); 
	    	}
	    }); 
	    
	    return time; 
	}
	
	//$.countdown.setDefaults({ serverSync: finalCountdown_serverTime });
	
	$(window).load( function()
	{
		//Debug.dir(  window  );
		/* Find unparsed countdowns in content */
		var pattern = new RegExp( 'countdown(\\d)' );
		var ids		= [];
		$$( '.countdown' ).each( function( elem )
		{
			if ( ! $( elem ).hasClass( 'hasCountdown' ) )
			{
				$(elem).attr('class').split(' ').each( function( className )
				{
					if ( pattern.match( className ) )
					{
						id = className.replace( 'countdown', '' );
						
						ids.push( id );
					}
				});
			}
		});
		
		ids = ids.uniq();
		
		if ( ids.length > 0 )
		{
			$.ajax({
				url: ipb.vars['base_url'] + "app=finalCountdown&module=ajax&section=ajax&md5check=" + ipb.vars['secure_hash'],
				data: { ids: ids },
				success: function(data)
				{
					if ( data['parse'] )
					{
						data['parse'].each( function( ctData )
						{
							$( '.countdown' + ctData['id'] ).each( function()
							{
								if ( ! $( this ).hasClass( 'hasCountdown' ) )
								{
									
									$( this ).prev( '.before_txt' ).html( ctData['before_txt'] + " " );
									$( this ).next( '.after_txt' ).html( " " + ctData['after_txt'] );
									
									if ( ctData['text_style'] )
									{
										$( this ).closest( '.styleHolder' ).attr( 'style', ctData['text_style'] );
									}
									
									$( this ).closest( '.countdownInnerWrapper' ).show();
									
									Debug.dir( ctData );
									
									$( this ).countdown(
									{
										until: new Date( ctData['jstime'] ),
										timezone: ctData['jstimezone'],
										format: ( ctData['format'] || 'yodHMS' ),
										layout: ( ctData['layout'] || '{y<}{yn} {yl}, {y>}{o<}{on} {ol}, {o>}{d<}{dn} {dl}, {d>}{h<}{hn} {hl}, {h>}{m<}{mn} {ml}, {m>}{s<}and {sn} {sl}{s>}' ),
										alwaysExpire: true,
										expiryText: ctData['event_msg'],
										onExpiry: function()
										{
											$( this ).next( '.after_txt' ).hide();
											$( this ).prev( '.before_txt' ).hide();
										}
									});
								}
							});
						});
					}

					$( '.countdownsLoading' ).hide();
					
					if ( data['remove'] )
					{
						data['remove'].each( function( id )
						{
							$( '.countdown' + id ).each( function()
							{
								$( this ).closest( '.countdownWrapper' ).remove();
							});
						});
					}
				}
			});
		}
	});
});