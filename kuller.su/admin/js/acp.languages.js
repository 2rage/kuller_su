/************************************************/
/* IPB3 Javascript								*/
/* -------------------------------------------- */
/* acp.languages.js - ACP Languages				*/
/* (c) IPS, Inc 2009							*/
/* -------------------------------------------- */
/* Author: Matt Mecham  						*/
/************************************************/

var _languages = window.IPBACP;
_languages.prototype.languages = {
	
	init: function()
	{
		Debug.write("Initializing acp.languages.js");
		document.observe("dom:loaded", function(){
			/* Set up the handles */
			$('sel__none').observe( 'click', acp.languages.selectNone );
			$('sel__all').observe( 'click', acp.languages.selectAll );
			$('sel__modified').observe( 'click', acp.languages.selectModified );
			$('langKill').observe( 'click', acp.languages.kill );
		});
	},
	
	/**
	 * Select all
	 */
	selectAll: function( e )
	{
		Event.stop(e);
		$$('.cbox' ).each( function(elem){
			$( elem ).checked = true;
		});
	},
	
	/**
	 * Select none
	 */
	selectNone: function( e )
	{
		Event.stop(e);
		$$('.cbox' ).each( function(elem){
			$( elem ).checked = false;
		});
	},
	
	/**
	 * Select modified
	 */
	selectModified: function( e )
	{
		acp.languages.selectNone(e);
		
		$$('.cbox.selected' ).each( function(elem){
			$( elem ).checked = true;
		});
	},
	
	/**
	 * Murder, death...
	 */
	kill: function( e )
	{
		Event.stop(e);
		if ( confirm( "Нажатие кнопки OK удалит все файлы из директории перевода, а также завершит сессию перевода.\nВНИМАНИЕ - убедитесь что вы импортировали все изменения из файлов." ) )
		{
			window.location = ipb.vars['base_url'] + 'app=core&module=languages&section=manage_languages&do=translateKill';
		}
	}
};

acp.languages.init();