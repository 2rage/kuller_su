<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Upgrade Class
 *
 * Class to add options and notices for IP.Board upgrade
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 * 
 * @author		Matt Mecham <matt@invisionpower.com>
 * @version		$Rev: 10721 $
 * @since		3.0
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @link		http://www.invisionpower.com
 * @package		IP.Board
 */ 

class version_class_core_30001
{
	/**
	 * Constructor
	 *
	 * @param	object		$registry		Registry object
	 * @return	@e void
	 */
	public function __construct( ipsRegistry $registry ) 
	{
		/* Make object */
		$this->registry =  $registry;
		$this->DB       =  $this->registry->DB();
		$this->settings =& $this->registry->fetchSettings();
		$this->request  =& $this->registry->fetchRequest();
		$this->cache    =  $this->registry->cache();
		$this->caches   =& $this->registry->cache()->fetchCaches();
	}
	
	/**
	 * Add pre-upgrade options: Form
	 * 
	 * @return	string	 HTML block
	 */
	public function preInstallOptionsForm()
	{
return <<<EOF
	<ul>
		<li>
			<input type='checkbox' name='exportSkins' value='1' />
			Экспортировать текущие шаблоны и CSS? (Будут сохранены в директории /cache/previousSkinFiles)
		</li>
		<li>
			<input type='checkbox' name='exportLangs' value='1' />
			Скопировать старые директории языков в /cache/previousLangFiles ?
		</li>
		<li>
			<input type='checkbox' name='skipPms' value='1' />
			<strong>Пропустить</strong> конвертацию личных сообщений? Старые сообщения будут оставлены, вы в любой момент сможете сконвертировать ЛС при помощи shell или утилиты в админцентре.
		</li>
		<li>
			<input type='checkbox' name='rootAdmins' value='1' />
			<strong>Запретить доступ в АЦ для неглавных администраторов?</strong> В систему распеределния прав в IP.Board 3 внесены изменения, поэтому больше нет необходимости разделять администраторов и главных администраторов на разные группы.
			Вы можете сохранить доступ в АЦ только для главных администраторов и вручную выставить права доступа. Если опция отключена, то
			все администраторы получат доступ в АЦ независимо от типа.
		</li>
	</ul>
EOF;
		
	}
	
	/**
	 * Add pre-upgrade options: Save
	 *
	 * Data will be saved in saved data array as: appOptions[ app ][ versionLong ] = ( key => value );
	 * 
	 * @return	array	 Key / value pairs to save
	 */
	public function preInstallOptionsSave()
	{
		/* Return */
		return array( 'exportSkins' => intval( $_REQUEST['exportSkins'] ),
					  'exportLangs' => intval( $_REQUEST['exportLangs'] ),
					  'skipPms'     => intval( $_REQUEST['skipPms'] )
					);
		
	}
	
	/**
	 * Return any post-installation notices
	 * 
	 * @return	array	 Array of notices
	 */
	public function postInstallNotices()
	{
		$options    = IPSSetUp::getSavedData('custom_options');
		$_doSkin    = $options['core'][30001]['exportSkins'];
		$_doLang    = $options['core'][30001]['exportLangs'];
		$rootAdmins = $options['core'][30001]['rootAdmins'];
		$skipPms    = $options['core'][30001]['skipPms'];
		
		$notices   = array();
		
		if ( $_doSkin )
		{
			$notices[] = "Все старые стили сохранены в 'cache/previousSkinFiles'";
		}
		
		if ( $_doLang )
		{
			$notices[] = "Все старые языки сохранены в 'cache/previousLangFiles'";
		}
		
		if ( $skipPms )
		{
			$notices[] = "Конвертация личных сообщений пропущена. Для конвертации личных сообщений в будущем воспользуйтесь shell-скриптом из директории 'tools' дистрибутива";
		}
		
		/* Notice about post content */
		$notices[] = "Теперь вам необходимо обновить содержимое всех сообщений через админцентр (Система &gt; Пересчет и обновление). <br />";
		
		/* Notice about admin restrictions */
		$notices[] = "Из-за изменений в системе прав доступа. Все администраторы, имевшие ограничения, будут лишены доступа ко всем модулям, пока вы не измените права.";
		
		/* Notice about admin restrictions */
		if ( $rootAdmins )
		{
			$notices[] = "Были сброшены все ограничения для доступа в админцентр Вы можете восстановить их через АЦ.<br />";
		}
		else
		{
			$notices[] = "Все администраторы получили полный доступ к админцентру. Вы можете ограничить их доступ через АЦ.<br />";
		}
			
		/* Notice about custom time settings */
		$notices[] = "Формат показа времени изменен в настройках.<br />";
		
		/* Notice about FURLs */
		$notices[] = "Для использования Friendly URLs (ЧПУ), добавьте в ваш conf_global.php строчку: \$INFO['use_friendly_urls'] = '1';.";
		
		return $notices;
	}
	
	
	/**
	 * Return any pre-installation notices
	 * 
	 * @return	array	 Array of notices
	 */
	public function preInstallNotices()
	{
		$notices = array();
		
		$notices[] = "Skins made for prior versions will not be compatible with this version. The default skin will be restored.";
		
		return $notices;
		
	}
}
	
