/************************************************/
/* It's the Final Countdown						*/
/* -------------------------------------------- */
/* acp.finalCountdown.js						*/
/* (c) Rawcodes.net 2012					    */
/* -------------------------------------------- */
/* Author: -RAW-					         	*/
/************************************************/

var _finalCountdown = window.IPBACP;
_finalCountdown.prototype.finalCountdown = 
{
	/*------------------------------*/
	/* Constructor 					*/
	init: function()
	{
		Debug.write("Initializing acp.finalCountdown.js");
		
		document.observe("dom:loaded", function()
		{
			acp.finalCountdown.initEvents();
		});
	},
	
	initEvents: function()
	{
		if ( $( 'view_in' ) )
		{
			if ( $F( 'view_in' ).indexOf( 'top' ) !== -1 || $F( 'view_in' ).indexOf( 'bottom' ) !== -1 )
			{
				$( 'appRestrictions' ).show();
			}
			
			$( 'view_in' ).observe( 'change', function()
			{
				if ( $F( 'view_in' ).indexOf( 'top' ) !== -1 || $F( 'view_in' ).indexOf( 'bottom' ) !== -1 )
				{
					$( 'appRestrictions' ).appear({duration:0.2});
				}
				else if ( $F( 'view_in' ).indexOf( 'top' ) == -1 && $F( 'view_in' ).indexOf( 'bottom' ) == -1 )
				{
					$( 'appRestrictions' ).fade({duration:0.2});
				}
			});
			
			['Forums', 'Ccs'].each( function( app )
			{
				if ( $( 'app' + app + '_yes' ) )
				{
					Debug.write(  jQ( 'input[name=app' + app + ']:checked' ).val()  );
					if ( jQ( 'input[name=app' + app + ']:checked' ).val() == '1' )
					{
						$( 'wrapper' + app ).show();
					}

					jQ( 'input[name=app' + app + ']' ).change( function()
					{
						$( 'wrapper' + app )[ jQ( 'input[name=app' + app + ']:checked' ).val() == '1' ? 'appear' : 'fade' ]({duration:0.3});
					});
				}
			});
		}
		
		if ( $( 'all_groups' ) )
		{
			$( 'groupPerm' )[ ( $( 'all_groups' ).checked ? 'disable' : 'enable' ) ]();
			
			$( 'all_groups' ).observe( 'click', function()
			{
				$( 'groupPerm' )[ ( $( 'all_groups' ).checked ? 'disable' : 'enable' ) ]();
			});
		}
		
		if( $( 'date' ) && $( 'date_date_icon' ) )
		{
			$( 'date_date_icon' ).observe( 'click', function()
			{
				new CalendarDateSelect( $( 'date' ), { year_range: 10, time: true, minute_interval: 1, popup: 'force' } );
			});
			
			$( 'date' ).writeAttribute( 'readonly', 'readonly' );
			
			$( 'date' ).observe( 'click', function()
			{
				new CalendarDateSelect( $( 'date' ), { year_range: 10, time: true, minute_interval: 1, popup: 'force' } );
			});
		}
		
		if ( $( 'adform' ) )
		{
			$( 'adform' ).observe( 'submit', acp.finalCountdown.validateForm );
		}
		
		
		if ( $$( '.toggle' ).length > 0 )
		{
			ipb.delegate.register( '.toggle', acp.finalCountdown.quickToggle );
		}
	},
	
	quickToggle: function(e)
	{
		Event.stop(e);
		elem = Event.findElement( e, 'img' );
		
		id = $( elem ).up( 'tr' ).id.replace( 'item_', '' );
		toggle = $( elem ).id.replace( '_' + id, '' );
		
		Debug.write( $( elem ).id );
		Debug.write( id );
		Debug.write( toggle );
		var _url = ipb.vars['base_url'] + '&app=finalCountdown&module=ajax&do=quickToggle&secure_key=' + ipb.vars['md5_hash'];
		new Ajax.Request( _url.replace( '&amp;', '&' ),
		{
			method: 'post',
			evalJSON: 'force',
			parameters: {
				id: id,
				toggle: toggle
			},
			onSuccess: function(t)
			{
				Debug.dir( t );
				if ( t.responseJSON['error'] )
				{
					alert( 'Failure' );
					return false;
				}
				else
				{
					$( elem ).writeAttribute( 'src', t.responseJSON['img'] );
				}
			}
		});
	},
	
	validateForm: function( e )
	{
		Event.stop(e);
		msg = "";
		
		if ( $F( 'name' ).blank() )
		{
			msg += "<li>Имя не задано</li>";
		}
		
		if ( $F( 'date' ).blank() )
		{
			msg += "<li>Отсутствие даты отсчета</li>";
		}
		
		if ( $F( 'txtBefore' ).blank() && $F( 'txtAfter' ).blank() )
		{
			msg += "<li>Вы должны написать текст, чтобы показать, до или после отсчета времени</li>";
		}
		
		if ( msg != "" )
		{
			$( 'formWarningBox' ).update( "Обнаружены следующие ошибки:<br /><ul>" + msg + "</ul>" ).show().pulsate({ duration: 1.0 });
			window.scroll( 0, 0 );
		}
		else
		{
			$( 'adform' ).submit();
		}
	}
};

acp.finalCountdown.init();