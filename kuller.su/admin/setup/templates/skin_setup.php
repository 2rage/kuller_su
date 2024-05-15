<?php
/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Setup skin file
 * Last Updated: $Date: 2013-01-03 20:08:10 -0500 (Thu, 03 Jan 2013) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @since		Friday 19th May 2006 17:33
 * @version		$Revision: 11784 $
 */
 
class skin_setup extends output
{
	/**
	 * Show no button
	 *
	 */
	 private $_showNoButtons = FALSE;
	 
	 
public function page_convert(){

$IPBHTML .= <<<EOF
	<div class='message error'>
		<h2>Неправильная кодировка базы данных!</h2>
		<p>
			Кодировка таблиц базы данных должна быть установлена в utf8(utf8_general_ci).
 			<br />
			Продолжение обновления невозможно. Требуется конвертация базы данных.
			<br />
			Выполните запрос "ALTER DATABASE `<b><Имя БД></b>` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci" для базы данных
			<br />
			И запрос "ALTER TABLE `<b>Таблица</b>` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci, CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci" 
			для каждой таблицы с нессответствующей кодировкой
		</p>

	</div>
EOF;

return $IPBHTML;

}
	 
	 
	 
	 
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
 * CSS for the database checker
 *
 * @access	public
 * @return	@e void
 */
public function db_checker_css()
{
$IPBHTML = "";
//--starthtml--//


$IPBHTML .= <<<EOF
<style type='text/css'>
.section_title {
	margin-bottom: 10px;
}

.warning, .information-box {
	padding: 10px 10px 10px 30px;
}

.warning {
	background: #f7e5e8 url( ../skin_cp/images/icons/exclamation.png ) no-repeat 9px 10px;
	border: 1px solid #f0c1cb;
	color: #92394d;
}

	.warning h4 {
		color: #802200;
		font-weight: bold;
	}
	
.information-box {
	background: #f0f6e2 url( ../skin_cp/images/icons/information.png ) no-repeat 9px 10px;
	border: 1px solid #d7e9a8;
	color: #5d8005;
}

	.information-box h4 {
		color: #6c6141;
	}

.acp-box h3 {
	font-size: 15px;
	font-weight: bold;
}

.ipsTable {
	width: 100%;
}

.ipsTable th {
	font-weight: bold;
	padding: 4px 4px 4px 0px;
	min-width: 50px;
}

	.ipsTable th:nth-child(2) {
		text-align: center;
	}

.ipsTable td {
	padding-top: 3px;
	padding-bottom: 3px;
}

	.ipsTable td:nth-child(2) {
		text-align: center;
	}

</style>

EOF;

return $IPBHTML;
}

/**
 * Show install complete page
 *
 * @access	public
 * @param	array
 * @return	string		HTML
 */
public function upgrade_complete( $options ) {

$IPBHTML = "";
//--starthtml--//

$_productName    = $this->registry->fetchGlobalConfigValue('name');

$IPBHTML .= <<<EOF
<div class='message unspecified'>
EOF;
	foreach( $options as $app => $_bleh )
	{
		foreach( $options[ $app ] as $num => $data )
		{
			if ( ! $data['out'] )
			{
				continue;
			}
			
			if ( $data['app']['key'] == 'core' )
			{
				$data['app']['name'] = 'IP.Board';
			}
			
			$IPBHTML .= <<<EOF
				<strong style='font-weight:bold; font-size:14px'>Сообщения</strong>
				<p>{$data['out']}</p>
EOF;

		}
	}

$IPBHTML .= <<<EOF
<p>Поздравляем, <a href='../../index.php'>ваш форум!</a> обновлен</p>
</div>
<br />
<span class='done_text'>Обновление завершено!</span>
EOF;

$IPBHTML .= <<<EOF
    <ul id='links'>
        <li><img src='{$this->registry->output->imageUrl}/link.gif' align='absmiddle' /> <a href='../index.php'>Админ-центр</a></li>
        <li><img src='{$this->registry->output->imageUrl}/link.gif' align='absmiddle' /> <a href='http://ipbmafia.ru/'>IPBmafia.Ru</a></li>
    </ul>
EOF;

return $IPBHTML;
}

/**
 * Show the page to manually run log query, with option to prune and run instead
 *
 * @access	public
 * @return	string		HTML
 */
public function upgrade_manual_queries_logs( $queries, $id=1, $TABLE='' ) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
<h3>Пожалуйста выполните следующие запросы прежде чем продолжить</h3>
<div class='message unspecified'>
	Вы можете <a href='index.php?app=upgrade&amp;section=upgrade&amp;s={$this->request['s']}&amp;do=appclass&amp;workact=logs{$id}&amp;pruneAndRun=1'>нажать здесь</a> чтобы очистить таблицу-журнал '{$TABLE}' и мастер сам внесет изменения в структуру
	<br />
	<b>ИЛИ</b> 
	<br />
	Запустите следующие запросы сами:
	<textarea style="width:100%; height: 300px">
EOF;

if ( $queries )
{
	$IPBHTML .= "\n" . $queries;
}

$IPBHTML .= <<<EOF
	</textarea>
</div>
EOF;

return $IPBHTML;
}

/**
 * Show the install start page
 *
 * @access	public
 * @return	string		HTML
 */
public function upgrade_manual_queries( $queries, $sourceFile='' ) {

$IPBHTML = "";
//--starthtml--//

$or = '';

$IPBHTML .= <<<EOF
<h3>Выполните следующие SQL запросы перед продолжением</h3>
<div class='message unspecified'>
EOF;
	if ( $sourceFile )
	{
		$or = '<u>ИЛИ</u> ';
		
		$IPBHTML .= <<<EOF
		<strong>Запустите этот файл</strong>
		<input type='text' size='100' style='width:98%' value='source {$sourceFile};' />
		<br />
EOF;
	}
$IPBHTML .= <<<EOF
	<strong>{$or}отдельные запросы</strong>
	<textarea style="width:100%; height: 300px">
EOF;

if ( $queries )
{
	$IPBHTML .= "\n" . $queries;
}

$IPBHTML .= <<<EOF
	</textarea>
</div>
EOF;

return $IPBHTML;
}


/**
 * Show the install start page
 *
 * @access	public
 * @return	string		HTML
 */
public function upgrade_ready( $name, $current, $latest) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
Готовы начать обновление <strong>$name</strong>
<br />Текущая версия: v{$current}
<br />Последняя версия: v{$latest}
<br />
<div class='message unspecified'>
	<strong>Опции обновления</strong>
	<ul>
		<li>
			<input type='checkbox' name='man' value='1' />
			Показывать SQL запросы для запуска вручную. <b>ВНИМАНИЕ:</b> Если вы выберите эту опцию, то вам будут показаны SQL запросы, которые необходмо выполнить в командной строке mysql. Если вы не уверены в своих силах, то свяжитесь с нашей службой поддержки.
		</li>
		<li>
			<input type='checkbox' name='helpfile' value='1' checked="checked" />
			Обновлять разделы помощи, если будут найдены различия
		</li>
	</ul>
</div>
<br />

<div style='float: right'>
	<input type='submit' class='nav_button' value='Начать обновление'>
</div>
EOF;

return $IPBHTML;
}

/**
 * Show the upgrade app options
 *
 * @access	public
 * @return	string		HTML
 */
public function upgrade_appsOptions( $options ) {
$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
Опции обновления:
<div class='message unspecified'>
EOF;
	foreach( $options as $app => $_bleh )
	{
		foreach( $options[ $app ] as $num => $data )
		{
			if ( $data['app']['key'] == 'core' )
			{
				$data['app']['name'] = 'IP.Board';
			}
			
			$IPBHTML .= <<<EOF
				<strong style='font-weight:bold; font-size:15px'>{$data['app']['name']} {$data['long']}</strong>
				{$data['out']}<br />
EOF;
		}
	}

$IPBHTML .= <<<EOF
</div>
EOF;

return $IPBHTML;
}

/**
 * Show the DB override page
 *
 * @access	public
 * @return	string		HTML
 */
public function upgrade_previousSession( $session=array() ) {

$IPBHTML = "";
//--starthtml--//

$url = IPSSetUp::getSavedData('install_url');

$date = gmdate( 'r', $session['session_start_time'] );

$IPBHTML .= <<<EOF
	<div class='message error'>
		<h2>Обнаружено прерванное обновление</h2>
		<p>
			Обнаружено прерванное обновление от <em>{$date} GMT</em>.
			<br />Обновляется секция '{$session['session_section']} - {$session['_session_get']['do']}' приложение '{$session['_sd']['install_apps']}', сейчас обновляется '{$session['_sd']['appdir']}'
			<br />
			<br />
			Вы можете продолжить с места остановки нажав <a href='index.php?app=upgrade&amp;s={$this->request['s']}&section=apps&do=rcontinue'>здесь</a> или можете нажать кнопку продолжить и обновление будет начато заново.
		</p>

	</div>
EOF;

return $IPBHTML;
}

/**
 * Show the upgrader applications page
 *
 * @access	public
 * @param	array 		Applications
 * @return	string		HTML
 */
public function upgrade_apps( $apps, $notices ) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
<div class='message' style='margin-top: 4px;'>
	Выберите приложения для обновления.
</div>
EOF;
	foreach( array( 'core', 'ips', 'other' ) as $type )
	{
		switch( $type )
		{
			case 'core':
				$title = "Приложения по-умолчанию";
			break;
			case 'ips':
				$title = "Приложения IPS";
			break;
			case 'other':
				$title = "Приложения сторонних разработчиков";
			break;
		}
		
		if ( count( $apps[ $type ] ) )
		{
			$IPBHTML .= <<<EOF
			<fieldset>
                <legend>{$title}</legend>
EOF;
		
		
			foreach( $apps[ $type ] as $key => $data )
			{
				if ( $type == 'core' )
				{
					if ( $key == 'core' )
					{
						$data['name'] = 'IP.Board';
					}
					else
					{
						continue;
					}
				}
				
				$_upav    = ( $data['_vnumbers']['current'][0] >= $data['_vnumbers']['latest'][0] ) ? 0 : 1;
				$upgrade  = ( ! $_upav ) ? "Обновлено" : "Обновить до {$data['_vnumbers']['latest'][1]}";
				$_checked = ( $_upav and $data['_vnumbers']['current'][0] ) ? ' checked="checked"' : '';
				$_style   = ( ! $data['_vnumbers']['current'][0] OR ( ! $_upav ) ) ? 'display:none' : '';
				
				/* Not installed? */
				if ( ! $data['_vnumbers']['current'][0] )
				{
					$upgrade = "Приложение не установлено.";
					$data['_vnumbers']['current'][1] = '';
				}

//-----------------------------------------
// Yes, I know this wouldn't work for "core"
// apps, but we can just use the global folder
// for them so it's irrelevant
//-----------------------------------------

$img = is_file( IPSLib::getAppDir( $key ) . '/skin_cp/appIcon.png' ) ? $this->settings['base_url'] . '/' . CP_DIRECTORY . '/applications_addon/' . $type . '/' . $key . '/skin_cp/appIcon.png' : "../skin_cp/images/applications/{$key}.png";

$IPBHTML .=  <<<EOF
					<table style='width: 100%; border: 0px; padding:0px' cellspacing='0'>
					<tr>
						<td width='7%' valign='top' style='padding:4px'>
							<input type='checkbox' name='apps[{$key}]' value='1' {$_checked} style="{$_style}" />
						</td>
						<td width='1%' valign='top' style='padding:4px'>
							<img src='{$img}' />
						</td>
       		 	        <td width='50%' class='content'>
                    		<strong style='font-size:12px'>{$data['name']}</strong> <span style='color:gray'>{$data['_vnumbers']['current'][1]}</span>
                    	</td>
						<td width='49%' style='padding:4px'>
							$upgrade
						</td>
                	</tr>
					</table>
EOF;
				if ( count( $notices[ $key ] ) )
				{
					$IPBHTML .= "<div class='warning'><ul>";
					foreach ( $notices[ $key ] as $n )
					{
						$IPBHTML .= "<li>{$n}</li>";
					}
					$IPBHTML .= "</ul></div>";
				}
			
			}
		
		
		$IPBHTML .=  <<<EOF
		    </fieldset>
EOF;
		}
	}

	return $IPBHTML;
}

/**
 * Show the upgrade overview page
 *
 * @access	public
 * @param	bool		Files ok
 * @param	bool		Extensions ok
 * @param	array 		Extensions
 * @return	string		HTML
 */
public function upgrade_overview( $filesOK, $extensionsOK, $extensions=array()) {

$minPHP = IPSSetUp::minPhpVersion;
$minSQL = IPSSetUp::minDb_mysql;

$prefPHP = IPSSetUp::prefPhpVersion;
$prefSQL = IPSSetUp::prefDb_mysql;

/* Memory warning */
$_memLimit	= null;
$_recLimit	= 128;

if( @ini_get('memory_limit') )
{
	$_memLimit	= @ini_get('memory_limit');
}

$_filesOK      = ( $filesOK === NULL )       ? "<span style='color:gray'>Не проверено</span>" : ( ( $filesOK === FALSE ) ? "<span style='color:red'>Нет</span>" : "<span style='color:green'>Есть</span>" );
$_extensionsOK = ( $extensionsOK === FALSE ) ? "<span style='color:red'>Нет</span>" : "<span style='color:green'>Есть</span>";

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
<div class='message unspecified'>
	<strong>Системные требования</strong>
	<br />
	<strong>PHP:</strong> v{$minPHP} или выше<br />
	<strong>SQL:</strong> MySQL v{$minSQL} ({$prefSQL} или выше предпочтительнее)
	<br />
	<br />
EOF;
$_mbstringVar	= @ini_get('mbstring.func_overload');
if( $_mbstringVar == '0' )
{
$IPBHTML .= <<<EOF
	<strong>Конфигурация mbstrings:</strong>
	<br />
	<span style='color:green;'>Значение mbstring.func_overload на вашей системе:</strong> {$_mbstringVar} <br /></span>
	<br />
	<br />
EOF;
}
else
{
$IPBHTML .= <<<EOF
	<strong>Конфигурация mbstrings:</strong>
	<br />
	<span style='color:red; font-weight: bold;'>Значение mbstring.func_overload на вашей системе: {$_mbstringVar} <br />
	Продолжение обновления приведет к ошибкам в работе форума! <br />
	Пожалуйста свяжитесь с вашим хостинг-провайдером для утановки этого параметра = 0<br />
	</span>
	<br />
	<br />
EOF;
}

if( $_memLimit )
{
	$_intLimit	= $_memLimit;
	$_intRec	= $_recLimit * 1024 * 1024;
	
	preg_match( '#^(\d+)(\w+)$#', strtolower($_intLimit), $match );
	
	if( $match[2] == 'g' )
	{
		$_intLimit = intval( $_intLimit ) * 1024 * 1024 * 1024;
	}
	else if ( $match[2] == 'm' )
	{
		$_intLimit = intval( $_intLimit ) * 1024 * 1024;
	}
	else if ( $match[2] == 'k' )
	{
		$_intLimit = intval( $_intLimit ) * 1024;
	}
	else
	{
		$_intLimit = intval( $_intLimit );
	}
	
	if( $_intLimit >= $_intRec )
	{
		$IPBHTML .= <<<EOF
		<strong>Memory Limit (конфигурация PHP):</strong> рекомендуется {$_recLimit}M или более<br />
		<span style='color:green;'>Значение на вашей системе: {$_memLimit}</span>
EOF;
	}
	else
	{
		$IPBHTML .= <<<EOF
		<strong>Memory Limit (конфигурация PHP):</strong> <em>рекомендуется</em> {$_recLimit}M или более<br />
		<span style='color:orange; font-weight: bold;'>Значение на вашей системе: {$_memLimit}.<br />Пожалуйста свяжитесь с вашим хостинг-провайдером для увеличения параметра до {$_recLimit}M.</span>
EOF;
	}
}
else
{
	$IPBHTML .= <<<EOF
	<strong>Memory Limit (конфигурация PHP):</strong> рекомендуется {$_recLimit}M или более<br />
	<span style='color:orange;'>Внимание: не удалось определить значени параметра на вашей системе.</span>
EOF;
}


//-----------------------------------------
// Suhosin
//-----------------------------------------

if( extension_loaded( 'suhosin' ) )
{
	$_postMaxVars	= @ini_get('suhosin.post.max_vars');
	$_reqMaxVars	= @ini_get('suhosin.request.max_vars');
	$_getMaxLen		= @ini_get('suhosin.get.max_value_length');
	$_postMaxLen	= @ini_get('suhosin.post.max_value_length');
	$_reqMaxLen		= @ini_get('suhosin.request.max_value_length');
	$_reqMaxVar		= @ini_get('suhosin.request.max_varname_length');
	
	$_indPMV		= $_postMaxVars < 4096 ? "orange; font-weight: bold" : "green";
	$_indRMV		= $_reqMaxVars < 4096 ? "orange; font-weight: bold" : "green";
	$_indGML		= $_getMaxLen < 2000 ? "orange; font-weight: bold" : "green";
	$_indPML		= $_postMaxLen < 1000000 ? "orange; font-weight: bold" : "green";
	$_indRML		= $_reqMaxLen < 1000000 ? "orange; font-weight: bold" : "green";
	$_indRMVL		= $_reqMaxVar < 350 ? "orange; font-weight: bold" : "green";
	
	$IPBHTML .= <<<EOF
	<br />
	<br />
	<strong>Suhosin:</strong><br />
	<span style='color:orange;'>Некоторые значения не удовлетворяют рекомендуемым.</span><br />
	
	<strong>suhosin.post.max_vars:</strong> 4096 или более<br />
	<span style='color:{$_indPMV};'>Значение на вашей системе: {$_postMaxVars}.<br />Может привести к проблемам при сохранении форм (особенно в админ-центре).</span><br />
	
	<strong>suhosin.request.max_vars:</strong> 4096 или более<br />
	<span style='color:{$_indRMV};'>Значение на вашей системе: {$_reqMaxVars}.<br />Может привести к проблемам при сохранении форм (особенно в админ-центре).</span><br />
	
	<strong>suhosin.get.max_value_length:</strong> 2000 или более<br />
	<span style='color:{$_indGML};'>Значение на вашей системе: {$_getMaxLen}.<br />Может привести к проблемам при работе с длинными URL.</span><br />
	
	<strong>suhosin.post.max_value_length:</strong> 1000000 или более<br />
	<span style='color:{$_indPML};'>Значение на вашей системе: {$_postMaxLen}.<br />Может привести к проблемам при сохранении больших сообщений или подобной информации.</span><br />
	
	<strong>suhosin.request.max_value_length:</strong> 1000000 или более<br />
	<span style='color:{$_indRML};'>Значение на вашей системе: {$_reqMaxLen}.<br />Может привести к проблемам при сохранении больших сообщений или подобной информации.</span><br />
	
	<strong>suhosin.request.max_varname_length:</strong> 350 или более<br />
	<span style='color:{$_indRMVL};'>Значение на вашей системе: {$_reqMaxVar}.<br />Может привести к проблемам при работе с ЧПУ.</span><br />
EOF;
}

$IPBHTML .= <<<EOF
	<br />
	<br />
	<strong>Проверка перед установкой: Файлы</strong>
	<br />
	<em>Требуемые файлы:</em> {$_filesOK}
	<br />
	<br />
	<strong>Проверка перед установкой: PHP-расширения</strong>
	<br />
	<em>Обзор PHP-расширений:</em> {$_extensionsOK}
EOF;
	
foreach( $extensions as $xt )
{
	if ( $xt['_ok'] !== TRUE )
	{
		if ( $xt['_ok'] !== 1 )
		{
			$IPBHTML .= "<br />{$xt['prettyname']} ({$xt['extensionname']}): <span style='color:red; font-weight: bold;'>Отсутствует</span> (<a href='{$xt['helpurl']}' target='_blank'>Подробнее</a>)";
		}
		else
		{
			$IPBHTML .= "<br />{$xt['prettyname']} ({$xt['extensionname']}) <span style='font-style: italic;'>Рекомендуется</span>: <span style='color:orange'>ВНИМАНИЕ</span> (<a href='{$xt['helpurl']}' target='_blank'>Подробнее</a>)";
		}
	}
	else
	{
		$IPBHTML .= "<br />{$xt['prettyname']} ({$xt['extensionname']}): <span style='color:green'>Есть</span>";
	}
}

$IPBHTML .= <<<EOF
</div>
EOF;

return $IPBHTML;
}

/**
 * Log in page
 *
 * @access	public
 * @return	string		HTML
 */
public function upgrade_login_200plus( $loginType ) {

$IPBHTML = "";
//--starthtml--//

$label = ( $loginType == 'username' ) ? 'Имя пользователя' : 'Email адрес';

$IPBHTML .= <<<EOF
	<input type='hidden' name='do' value='login' />
	<div class='ipsType_sectiontitle'>Добро пожаловать в систему обновления.</div>
	<p class='ipsType_pagedesc'>Мастер обновления проведет вас через все необходимые шаги.</p>
	<br />
	  <fieldset>
      <legend>Авторизация</legend>
      <table style='width: 100%; border: 0px; padding:0px' cellspacing='0'>
          <tr>
              <td width='30%' class='title'>{$label}:</td>
              <td width='70%' class='content'><input type='text' class='input_text'  name='username' value=''></td>
          </tr>

      	<tr>
              <td width='30%' class='title'>Пароль</td>
              <td width='70%' class='content'><input type='password'class='input_text'  name='password' value=''></td>
          </tr>
      </table>
  </fieldset>
EOF;

return $IPBHTML;
}

/**
 * Log in page
 *
 * @access	public
 * @return	string		HTML
 */
public function upgrade_login_300plus( $additional_data, $replace_form, $loginType='username' ) {

$IPBHTML = "";
//--starthtml--//

switch( $loginType )
{
	case 'either':
		$loginString = "Имя пользователя или email";
		break;
	case 'email':
		$loginString = "Email";
		break;
	default:
	case 'username':
		$loginString = "Имя пользователя";
		break;
}

if( $replace_form )
{
	$IPBHTML .= $additional_data[0];
}
else
{
	$IPBHTML .= <<<EOF
	<input type='hidden' name='do' value='login' />
EOF;

	if ( $this->request['_acpRedirect'] )
	{
		$IPBHTML .= <<<EOF
	<div class='message error'>
		Обнаружена новая версия приложения.<br />
		Вам <strong>необходимо</strong> запустить мастер обновления, прежде чем вы сможете зайти в админ-центр.
	</div>
EOF;
	}
	else
	{
		$IPBHTML .= <<<EOF
	<div class='ipsType_sectiontitle'>Добро пожаловать в систему обновления.</div>
	<p class='ipsType_pagedesc'>Мастер обновления проведет вас через все необходимые шаги.</p>
EOF;
	}
	
	$IPBHTML .= <<<EOF
	<br />
	  <fieldset>
      <legend>Авторизация</legend>
		<div id='login_controls'>
			<label for='username'>{$loginString}</label>
			<input type='text' size='20' id='username' class='input_text' name='username' value=''>

			<label for='password'>Пароль</label>
			<input type='password' size='20' id='password' class='input_text'  name='password' value=''>
EOF;

		if( count($additional_data) > 0 )
		{
			foreach( $additional_data as $form_html )
			{
				$IPBHTML .= $form_html;
			}
		}
		
$IPBHTML .= <<<EOF
      </div>
  </fieldset>
EOF;
}

return $IPBHTML;
}

/**
 * Show error page
 *
 * @access	public
 * @param	string		Error message
 * @return	string		HTML
 */
public function page_error($msg) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
	<div class='message error'>
		{$msg}
	</div>
EOF;

return $IPBHTML;
}

/**
 * Show locked page
 *
 * @access	public
 * @return	string		HTML
 */
public function page_locked() {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
	<div class='message error'>
		УСТАНОВЩИК ЗАБЛОКИРОВАН<br />Для продолжения удалите файл "cache/installer_lock.php".
	</div>
EOF;

return $IPBHTML;
}

/**
 * Show install complete page
 *
 * @access	public
 * @param	bool		Installer was locked successfully
 * @return	string		HTML
 */
public function page_installComplete( $installLocked ) {

$IPBHTML = "";
//--starthtml--//

$_productName    = $this->registry->fetchGlobalConfigValue('name');

if ( ! $installLocked )
{
	$extra = "<div class='message error'>
                УСТАНОВЩИК НЕ ЗАБЛОКИРОВАН<br />Немедленно удалите файл 'admin/install/index.php' !
			  </div>";
}

$IPBHTML .= <<<EOF
	<br />

    <span class='done_text'>Установка завершена!</span><Br /><Br />
    Поздравляем, <a href='../../index.php'>{$_productName}</a> установлен и готов к использованию! Ниже приведено
    несколько полезных ссылок.<br /><br /><br />
    {$extra}
    <ul id='links'>
        <li><img src='{$this->registry->output->imageUrl}/link.gif' align='absmiddle' /> <a href='../index.php'>Админ-центр</a></li>
        <li><img src='{$this->registry->output->imageUrl}/link.gif' align='absmiddle' /> <a href='http://ipbmafia.ru/'>IPBmafia.Ru</a></li>
    </ul>
EOF;

return $IPBHTML;
}

/**
 * Show the install start page
 *
 * @access	public
 * @return	string		HTML
 */
public function page_install() {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
	Готовы начать установку IP.Board. Нажмите <strong>Начать</strong> для запуска установки!<br /><br />


	      <div style='float: right'>
           <input type='submit' class='nav_button' value='Начать установку'>
       </div>
EOF;

return $IPBHTML;
}

/**
 * Show the admin info page
 *
 * @access	public
 * @return	string		HTML
 */
public function page_admin() {

$IPBHTML = "";
//--starthtml--//

$username	= htmlspecialchars($_REQUEST['username']);
$email		= htmlspecialchars($_REQUEST['email']);

$IPBHTML .= <<<EOF
	<div class='message'>
		Внимательно заполните форму.<br />Данные введенные здесь используются для доступа к
        администраторским функциям системы.
	</div>
	<br />
	<fieldset>
	    <legend>Учетная запись администратора</legend>
            <table style='width: 100%; border: 0px; padding:0px' cellspacing='0'>
                <tr>
                    <td width='30%' class='title'>Имя пользователя:</td>

                    <td width='70%' class='content'><input type='text' class='sql_form' name='username' value='{$username}'></td>
                </tr>
                <tr>
                    <td class='title'>Пароль:</td>
                    <td class='content'><input type='password' class='sql_form' name='password'></td>
                </tr>
                <tr>
                    <td class='title'>Подтвердите пароль:</td>

                    <td class='content'><input type='password' class='sql_form' name='confirm_password'></td>
                </tr>
                <tr>
                    <td class='title'>E-mail адрес:</td>
                    <td class='content'><input type='text' class='sql_form' name='email' value='{$email}'></td>
                </tr>
            </table>
        </fieldset>
EOF;

return $IPBHTML;
}

/**
 * Show the DB override page
 *
 * @access	public
 * @return	string		HTML
 */
public function page_dbOverride() {

$IPBHTML = "";
//--starthtml--//

$url = IPSSetUp::getSavedData('install_url');

$IPBHTML .= <<<EOF
	<div class='message'>
         В базе данных (<em>{$this->request['db_name']}</em>) уже есть таблицы с таким же префиксом (<em>{$this->request['db_pre']}</em>).
		<br />Вы можете перезаписать существующие таблицы или вы можете выбрать другую базу данных или префикс.
		<br /><span style='font-weight:bold'>Может быть</span> вы хотели запустить <a class='color:gray' href='{$url}/admin/upgrade/index.php'>обновление</a> ?
	</div>
	<br />
	<fieldset>
		<legend>Перезапись таблиц</legend>
		<table style='width: 100%; border: 0px; padding:0px' cellspacing='0'>
			<tr>
               <td width='70%' class='title'>Перезаписать существующие в базе данных таблицы</td>
               <td width='30%' class='content'><input type='checkbox' class='sql_form' value='1' name='overwrite' ></td>
           </tr>
		</table>
	</fieldset>
	<br />
	<fieldset>
		<legend>Изменить данные базы данных</legend>
		<table style='width: 100%; border: 0px; padding:0px' cellspacing='0'>
			<tr>
	               <td width='30%' class='title'>Хост SQL:</td>
	               <td width='70%' class='content'>
	               	<input type='text' class='sql_form' value='{$this->request['db_host']}' name='db_host'>
	               </td>
	           </tr>
			<tr>
	           <td class='title'>Название базы данных:</td>
               <td class='content'>
               	<input type='text' class='sql_form' name='db_name' value='{$this->request['db_name']}'>
               </td>
           </tr>
           <tr>
               <td class='title'>Имя пользователя:</td>
               <td class='content'>
               	<input type='text' class='sql_form' name='db_user' value='{$this->request['db_user']}'>
               </td>
           </tr>
           <tr>
               <td class='title'>Пароль:</td>
               <td class='content'>
               	<input type='password' class='sql_form' name='db_pass' value='{$_REQUEST['db_pass']}'>
               </td>
           </tr>
           <tr>
               <td class='title'>Префикс таблиц:</td>
               <td class='content'>
               	<input type='text' class='sql_form' name='db_pre' value='{$this->request['db_pre']}'>
               </td>
           </tr>
        <!--{EXTRA.SQL}-->
		</table>
	</fieldset>
EOF;

return $IPBHTML;
}


/**
 * Collect DB info
 *
 * @access	public
 * @return	string		HTML
 */
public function page_db() {

$IPBHTML = "";
//--starthtml--//

/* 'lil hack here */
if ( is_file( DOC_IPS_ROOT_PATH . "conf_global.php" ) )
{
	$INFO = array();
	require( DOC_IPS_ROOT_PATH . 'conf_global.php' );/*noLibHook*/

	if ( is_array( $INFO ) && count($INFO) )
	{
		$this->request['db_host'] = ( $this->request['db_host'] ) ? ( $this->request['db_host'] == 'localhost' ? ( $INFO['sql_host'] ? $INFO['sql_host'] : 'localhost' ) : $this->request['db_host'] ) : 'localhost';
		$this->request['db_name'] = ( $this->request['db_name'] ) ? $this->request['db_name'] : $INFO['sql_database'];  
	}
}

$IPBHTML .= <<<EOF
	<div class='message'>
		     Необходимо создать базу данных перед продолжением. Обратитесь к вашему хостинг провайдеру, если не уверены в значениях этих настроек.
		  </div>
		<br />
		   <fieldset>
		       <legend>Информация о базе данных</legend>
		       <table style='width: 100%; border: 0px; padding:0px' cellspacing='0'>
		           <tr>
		               <td width='30%' class='title'>Хост SQL:</td>
		               <td width='70%' class='content'>
		               	<input type='text' class='sql_form' value='{$this->request['db_host']}' name='db_host'>
		               </td>
		           </tr>
		           <tr>
		               <td class='title'>Название базы данных:</td>
		               <td class='content'>
		               	<input type='text' class='sql_form' name='db_name' value='{$this->request['db_name']}'>
		               </td>
		           </tr>
		           <tr>
		               <td class='title'>Имя пользователя:</td>
		               <td class='content'>
		               	<input type='text' class='sql_form' name='db_user' value='{$this->request['db_user']}'>
		               </td>
		           </tr>
		           <tr>
		               <td class='title'>Пароль:</td>
		               <td class='content'>
		               	<input type='password' class='sql_form' name='db_pass' value='{$this->request['db_pass']}'>
		               </td>
		           </tr>
		           <tr>
		               <td class='title'>Префикс таблиц:</td>
		               <td class='content'>
		               	<input type='text' class='sql_form' name='db_pre' value='{$this->request['db_pre']}'>
		               </td>
		           </tr>
		<!--{EXTRA.SQL}-->
		       </table>
		   </fieldset>
EOF;

return $IPBHTML;
}


/**
 * Check the database to use
 *
 * @access	public
 * @param	array 		Available DB drivers
 * @return	string		HTML
 */
public function page_check_db( $drivers ) {

	$_drivers = '';

	foreach ($drivers as $k => $v)
	{
		$selected  = ($v == "Mysql") ? " selected='selected'" : "";
		$_drivers .= "<option value='".$v."'".$selected.">".strtoupper($v)."</option>\n";
	}


$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
	<div class='message'>
            Выберите какой драйвер базы данных вы хотите использовать.
        </div>
        <br />
        <fieldset>
            <legend>Драйвер базы данных</legend>
            <table style='width: 100%; border: 0px; padding:0px' cellspacing='0'>
			<tr>
                    <td width='30%' class='title'>SQL драйвер:</td>
                    <td width='70%' class='content'>
                    	<select name='sql_driver' class='sql_form'>{$_drivers}</select>
                    </td>
                </tr>
            </table>
        </fieldset>
EOF;

return $IPBHTML;
}

/**
 * Show the EULA
 *
 * @access	public
 * @return	string		HTML
 */
public function page_eula() {

$_eula = nl2br( $this->registry->fetchGlobalConfigValue('license') );

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
	<script language='javascript'>
	check_eula = function()
	{
		if( document.getElementById( 'eula' ).checked == true )
		{
			return true;
		}
		else
		{
			alert( 'Для продолжения установки необходми согласиться с условиями лицензии' );
			return false;
		}
	}
	document.getElementById( 'install-form' ).onsubmit = check_eula;
	</script>

	Пожалуйста, прочитайте все пункты Пользовательского Соглашения.<br /><br />


	<div class='eula'>
	    {$_eula}
    </div>
    <br />
    
    <input type='checkbox' name='eula' id='eula'> <strong><label for='eula'>Я согласен с Пользовательским Соглашением</label></strong>

EOF;

return $IPBHTML;
}

/**
 * Ask for license key
 *
 * @access	public
 * @return	string		HTML
 */
public function page_license( $error ) {

$IPBHTML = "";
//--starthtml--//

if ( $error )
{
$IPBHTML .= <<<EOF
	<input type='hidden' name='ignoreError' value='1' />
	 <div class='message error'>{$error}</div>
EOF;
}

$IPBHTML .= <<<EOF
	
	<br />
	<fieldset>
     <legend>Ключ лицензии</legend>
		<table style='width: 100%; border: 0px; padding:0px' cellspacing='0'>
	      <tr>
	          <td class='title'><b>Ключ</b></td>
	          <td width='70%' class='content'><input type='text' class='sql_form' name='lkey' value='{$this->request['lkey']}'></td>
	      </tr>
	      <tr>
	          <td colspan='2'><span style='color: gray'>Ввод ключа лицензии <span style='font-weight:bold'>не обязателен</span> для продолжения установки. Вы можете ввести его позже.</span></td>
	      </tr>
	  	</table>
	 </fieldset>
	 <br />
		
	<div class='message unspecific note'>
		<a href='http://external.ipslink.com/ipboard30/landing/?p=lkey' target='_blank'>Как найти ключ лицензии</a>
	</div>

EOF;

return $IPBHTML;
}

/**
 * Show the address info page
 *
 * @access	public
 * @param	string		Directory
 * @param	string		URL
 * @return	string		HTML
 */
public function page_address( $dir, $url ) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
	<fieldset>
      <legend>Адрес установки</legend>

      <table style='width: 100%; border: 0px; padding:0px' cellspacing='0'>
          <tr>
              <td width='30%' class='title'>Директория установки:</td>
              <td width='70%' class='content'><input type='text' class='sql_form' name='install_dir' value='{$dir}'></td>
          </tr>

      	<tr>
              <td width='30%' class='title'>URL установки:</td>
              <td width='70%' class='content'><input type='text' class='sql_form' name='install_url' value='{$url}'></td>
          </tr>
      </table>
  </fieldset>

EOF;

return $IPBHTML;
}

/**
 * Show the applications page
 *
 * @access	public
 * @param	array 		Applications
 * @return	string		HTML
 */
public function page_apps( $apps ) {

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
<div class='message' style='margin-top: 4px;'>
    Выберите приложения для установки.<br />Были обнаружены следующие приложения:
</div>
EOF;
	foreach( array( 'core', 'ips', 'other' ) as $type )
	{
		switch( $type )
		{
			case 'core':
				$title = "Приложения по-умолчанию";
			break;
			case 'ips':
				$title = "Приложения IPS";
			break;
			case 'other':
				$title = "Приложения сторонних разработчиков";
			break;
		}
		
		if ( count( $apps[ $type ] ) )
		{
			$IPBHTML .= <<<EOF
			<fieldset>
                <legend>{$title}</legend>
EOF;
		
		
			foreach( $apps[ $type ] as $key => $data )
			{
				if ( isset( $this->request['apps'] ) )
				{
					$_checked = isset( $this->request['apps'][ $key ] ) ? ' checked="checked" ' : '';
				}
				else
				{
					$_checked = ( $type == 'core' OR $type == 'ips' ) ? ' checked="checked" ' : '';
				}
				$_style   = ( $type == 'core' ) ? 'display:none' : '';

//-----------------------------------------
// Yes, I know this wouldn't work for "core"
// apps, but we can just use the global folder
// for them so it's irrelevant
//-----------------------------------------

$img = is_file( IPSLib::getAppDir( $key ) . '/skin_cp/appIcon.png' ) ? '../applications_addon/' . $type . '/' . $key . '/skin_cp/appIcon.png' : "../skin_cp/images/applications/{$key}.png";

$IPBHTML .=  <<<EOF
					<table style='width: 100%; border: 0px; padding:0px' cellspacing='0'>
					<tr>
       		 	        <td width='5%' class='title'>
							<input type='checkbox' name='apps[{$key}]' value='1' {$_checked} style="{$_style}" />
						</td>
						<td width='1%' valign='top' style='padding:4px'>
							<img src='{$img}' />
						</td>
       		 	        <td width='70%' class='content'>
                    		<strong>{$data['name']}</strong> <span style='color:gray'><em>От: {$data['author']}</em></span><div style='color:#777'>{$data['description']}</div>
                    	</td>
                	</tr>
					</table>
EOF;
			}
		
		
		$IPBHTML .=  <<<EOF
		    </fieldset>
EOF;
		}
	}

	return $IPBHTML;
}
	
/**
 * Show the requirements page
 *
 * @access	public
 * @param	bool		Files ok
 * @param	bool		Extensions ok
 * @param	array 		Extensions
 * @return	string		HTML
 */
public function page_requirements( $filesOK, $extensionsOK, $extensions=array(), $text='установки' ) {

$minPHP = IPSSetUp::minPhpVersion;
$minSQL = IPSSetUp::minDb_mysql;

$prefPHP = IPSSetUp::prefPhpVersion;
$prefSQL = IPSSetUp::prefDb_mysql;

/* Memory warning */
$_memLimit	= null;
$_recLimit	= 128;

if( @ini_get('memory_limit') )
{
	$_memLimit	= @ini_get('memory_limit');
}
		
$_filesOK      = ( $filesOK === NULL )       ? "<span style='color:gray'>Не проверено</span>" : ( ( $filesOK === FALSE ) ? "<span style='color:red'>Нет</span>" : "<span style='color:green'>Есть</span>" );
$_extensionsOK = ( $extensionsOK === FALSE ) ? "<span style='color:red'>Нет</span>" : ( $extensionsOK === TRUE ? "<span style='color:green'>Есть</span>" : "<span style='color:orange;'>Не полностью</span>" );

$IPBHTML = "";
//--starthtml--//

$IPBHTML .= <<<EOF
<div>
    <div>
        Добро пожаловать в систему установки. Мастер установки проведет вас через весь процесс {$text}.
    </div>
EOF;

if( $text == 'upgrade' )
{
	$IPBHTML .= <<<EOF
	<div class='message unspecific note'>
		Если вы не уверены, что сможете успешно произвести обновление приложения, пожалуйста обратитесь <a href='http://clientarea.ibresource.ru/'>в службу поддержки</a>.
		<br /><br />
		Прежде чем продолжить обновление, убедитесь, что у вас имеется актуальная, рабочая резервная копия базы форума.  Нажимая продолжить, вы подтверждаете, что такая копия у вас имеется.
	</div>
	<br />
EOF;
}
	
$IPBHTML .= <<<EOF
    <div class='message unspecific note'>
    	Если вам нужна помощь по работе с мастером установки, то обратитесь к <a href='http://external.ipslink.com/ipboard30/landing/?p=installation-guide' target='_blank'><b>документации</b></a>.
    </div>
</div>
<br />
<div class='message unspecified'>
	<strong>Системные требования</strong>
	<br />
	<strong>PHP:</strong> v{$minPHP} или выше<br />
	<strong>SQL:</strong> MySQL v{$minSQL} ({$prefSQL} или выше предпочтительнее)
	<br />
	<br />
EOF;
$_mbstringVar	= @ini_get('mbstring.func_overload');
if( $_mbstringVar == '0' )
{
$IPBHTML .= <<<EOF
	<strong>Конфигурация mbstrings:</strong>
	<br />
	<span style='color:green;'>Значение mbstring.func_overload на вашей системе:</strong> {$_mbstringVar} <br /></span>
	<br />
	<br />
EOF;
}
else
{
$IPBHTML .= <<<EOF
	<strong>Конфигурация mbstrings:</strong>
	<br />
	<span style='color:red; font-weight: bold;'>Значение mbstring.func_overload на вашей системе: {$_mbstringVar} <br />
	Продолжение установки приведет к ошибкам в работе форума! <br />
	Пожалуйста свяжитесь с вашим хостинг-провайдером для утановки этого параметра = 0<br />
	</span>
	<br />
	<br />
EOF;
}


if( $_memLimit )
{
	$_intLimit	= $_memLimit;
	$_intRec	= $_recLimit * 1024 * 1024;
	
	preg_match( '#^(\d+)(\w+)$#', strtolower($_intLimit), $match );
	
	if( $match[2] == 'g' )
	{
		$_intLimit = intval( $_intLimit ) * 1024 * 1024 * 1024;
	}
	else if ( $match[2] == 'm' )
	{
		$_intLimit = intval( $_intLimit ) * 1024 * 1024;
	}
	else if ( $match[2] == 'k' )
	{
		$_intLimit = intval( $_intLimit ) * 1024;
	}
	else
	{
		$_intLimit = intval( $_intLimit );
	}
	
	if( $_intLimit >= $_intRec )
	{
		$IPBHTML .= <<<EOF
		<strong>Memory Limit (конфигурация PHP):</strong> рекомендуется {$_recLimit}M или более<br />
		<span style='color:green;'>Значение на вашей системе: {$_memLimit}</span>
EOF;
	}
	else
	{
		$IPBHTML .= <<<EOF
		<strong>Memory Limit (конфигурация PHP):</strong> рекомендуется {$_recLimit}M или более<br />
		<span style='color:orange; font-weight: bold;'>Значение на вашей системе: {$_memLimit}.<br />Пожалуйста свяжитесь с вашим хостинг-провайдером для увеличения параметра до {$_recLimit}M.</span>
EOF;
	}
}
else
{
	$IPBHTML .= <<<EOF
	<strong>Memory Limit (конфигурация PHP):</strong> рекомендуется {$_recLimit}M или более<br />
	<span style='color:orange;'>Внимание: не удалось определить значени параметра на вашей системе.</span>
EOF;
}


//-----------------------------------------
// Suhosin
//-----------------------------------------

if( extension_loaded( 'suhosin' ) )
{
	$_postMaxVars	= @ini_get('suhosin.post.max_vars');
	$_reqMaxVars	= @ini_get('suhosin.request.max_vars');
	$_getMaxLen		= @ini_get('suhosin.get.max_value_length');
	$_postMaxLen	= @ini_get('suhosin.post.max_value_length');
	$_reqMaxLen		= @ini_get('suhosin.request.max_value_length');
	$_reqMaxVar		= @ini_get('suhosin.request.max_varname_length');
	
	$_indPMV		= $_postMaxVars < 4096 ? "orange; font-weight: bold" : "green";
	$_indRMV		= $_reqMaxVars < 4096 ? "orange; font-weight: bold" : "green";
	$_indGML		= $_getMaxLen < 2000 ? "orange; font-weight: bold" : "green";
	$_indPML		= $_postMaxLen < 1000000 ? "orange; font-weight: bold" : "green";
	$_indRML		= $_reqMaxLen < 1000000 ? "orange; font-weight: bold" : "green";
	$_indRMVL		= $_reqMaxVar < 350 ? "orange; font-weight: bold" : "green";
	
	$IPBHTML .= <<<EOF
	<br />
	<br />
	<strong>Suhosin:</strong><br />
	<span style='color:orange;'>Некоторые значения не удовлетворяют рекомендуемым.</span><br />
	
	<strong>suhosin.post.max_vars:</strong> 4096 или более<br />
	<span style='color:{$_indPMV};'>Значение на вашей системе: {$_postMaxVars}.<br />Может привести к проблемам при сохранении форм (особенно в админ-центре).</span><br />
	
	<strong>suhosin.request.max_vars:</strong> 4096 или более<br />
	<span style='color:{$_indRMV};'>Значение на вашей системе: {$_reqMaxVars}.<br />Может привести к проблемам при сохранении форм (особенно в админ-центре).</span><br />
	
	<strong>suhosin.get.max_value_length:</strong> 2000 или более<br />
	<span style='color:{$_indGML};'>Значение на вашей системе: {$_getMaxLen}.<br />Может вызывать проблемы при работе с длинными URL.</span><br />
	
	<strong>suhosin.post.max_value_length:</strong> 1000000 or better recommended<br />
	<span style='color:{$_indPML};'>Значение на вашей системе: {$_postMaxLen}.<br />Может привести к проблемам при сохранении больших сообщений или подобной информации.</span><br />
	
	<strong>suhosin.request.max_value_length:</strong> 1000000 or better recommended<br />
	<span style='color:{$_indRML};'>Значение на вашей системе: {$_reqMaxLen}.<br />Может привести к проблемам при сохранении больших сообщений или подобной информации.</span><br />
	
	<strong>suhosin.request.max_varname_length:</strong> 350 или более<br />
	<span style='color:{$_indRMVL};'>Значение на вашей системе: {$_reqMaxVar}.<br />Может привести к проблемам при работе с ЧПУ.</span><br />
EOF;
}

$IPBHTML .= <<<EOF
	<br />
	<br />
	<strong>Проверка: Файлы</strong>
	<br />
	<em>Требуемые файлы:</em> {$_filesOK}
	<br />
	<br />
	<strong>Проверка: Расширения PHP</strong>
	<br />
	<em>Общие расширения PHP:</em> {$_extensionsOK}
EOF;
	
foreach( $extensions as $xt )
{
	if ( $xt['_ok'] !== TRUE )
	{
		if ( $xt['_ok'] !== 1 )
		{
			$IPBHTML .= "<br />{$xt['prettyname']} ({$xt['extensionname']}): <span style='color:red; font-weight: bold;'>Нет</span> (<a href='{$xt['helpurl']}' target='_blank'>Подробнее</a>)";
		}
		else
		{
			$IPBHTML .= "<br />{$xt['prettyname']} ({$xt['extensionname']}) <span style='font-style: italic;'>Рекомендуется</span>: <span style='color:orange'>Нет</span> (<a href='{$xt['helpurl']}' target='_blank'>Подробнее</a>)";
		}
	}
	else
	{
		$IPBHTML .= "<br />{$xt['prettyname']} ({$xt['extensionname']}): <span style='color:green'>Есть</span>";
	}
}

$IPBHTML .= <<<EOF
</div>
EOF;

return $IPBHTML;
}

/**
 * Global template/wrapper
 *
 * @access	public
 * @param	string		Title
 * @param	string		Page content
 * @param	array 		Data
 * @param	array 		Errors
 * @param	array 		Warnings
 * @param	array 		Install step info
 * @return	string		HTML
 */
public function globalTemplate( $title, $content, $data=array(), $errors=array(), $warnings=array(), $messages=array(), $installStep=array(), $version, $appData ) {

$IPBHTML = "";
//--starthtml--//

$_cssPath        = '../setup/public';
$_productVersion = $this->registry->fetchGlobalConfigValue('version');
$_productName    = $this->registry->fetchGlobalConfigValue('name');
$app			 = ( IPS_IS_UPGRADER ) ? 'upgrade' : 'install';
$extraUrl		 = ( IPS_IS_UPGRADER ) ? '&s=' . $this->request['s'] : '';
$extraUrl		.= ( IPS_IS_UPGRADER AND $this->request['workact'] ) ? '&workact=' . $this->request['workact'] : '';
$extraUrl		.= ( IPS_IS_UPGRADER AND isset( $this->request['st'] ) ) ? '&st=' . $this->request['st'] : '';
$extraInfo       = ( IPS_IS_UPGRADER AND $version ) ? 'Модуль: ' . $version . '<br />(' . $appData['name'] . ')' : '';

$IPBHTML .= <<<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>Установщик IPS: {$title}</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<style type='text/css' media='all'>
			@import url('{$_cssPath}/install.css');
		</style>
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />	
	</head>
	<body>
		<form id='install-form' action='index.php?app={$app}{$extraUrl}&section={$this->registry->output->nextAction}' method='post'>
		<input type='hidden' name='_sd' value='{$data['savedData']}'>
		
		<div id='ipbwrapper'>
			<div id='branding'>
				<div class='main_width'>
					<div class='logo'><img src='{$this->registry->output->imageUrl}/logo.png' /></div>
				</div>	
			</div>
			<div id='primary_nav' class='clearfix'>
				<div class='main_width'>
					<ul class='ipsList_inline' id='community_app_menu'>
						<li class='active'><a href='#'>{$this->registry->output->sequenceData[$this->registry->output->currentPage]}</a></li>
					
EOF;
if ( ! IPS_IS_UPGRADER )
{
	$IPBHTML .= <<<EOF
						<li><a href='http://external.ipslink.com/ipboard30/landing/?p=installation-guide' target='_blank'><b>Руководство по установке</b></a></li>
EOF;
}

$IPBHTML .= <<<EOF
					</ul>
				</div>
			</div>
			<div id='content'>
		 	    <div class='ipsLayout ipsLayout_withleft ipsLayout_largeleft clearfix'>
		 	       <div class='ipsLayout_left clearfix'>
		 	       		<div class='ipsBox'>
		 	       			<div class='ipsBox_container'>
								<ul id='progress'>

EOF;

foreach( $data['progress'] as $p )
{
	$extra = '';
	
	if ( $installStep[0] > 0 )
	{
		 $extra = ( $p[0] == 'step_doing' ) ? "<p>Шаг {$installStep[0]}/{$installStep[1]}</p>" : '';
	}
	
	if ( $extraInfo )
	{
		 $extra .= ( $p[0] == 'step_doing' ) ? "<p>{$extraInfo}</p>" : '';
	}
	
	$IPBHTML .= <<<EOF
	<li class='{$p[0]}'>{$p[1]}{$extra}</li>
EOF;
}

$IPBHTML .= <<<EOF
    		 	    			</ul>
    		 	    		</div>
    		 	    	</div>
    		 	 	</div>
    		 	 	<div class='ipsLayout_content clearfix'>
EOF;

	if ( count( $messages ) )
	{
		$IPBHTML .= <<<EOF
		<br />
		    <div class='message' style='overflow:auto;max-height:180px'>
EOF;

		foreach( $messages as $msg )
		{
			$IPBHTML .= "<p>{$msg}</p>\n";	
		}
		
 		$IPBHTML.= <<<EOF
		    </div><br />
EOF;
	}

	if ( count( $errors ) OR count( $warnings ) )
	{
		$IPBHTML .= <<<EOF
		<br />
		    <div class='message error' style='overflow:auto;max-height:180px'>
EOF;

		foreach( $errors as $msg )
		{
			$IPBHTML .= "<p>Ошибка: {$msg}</p>\n";
		}
		
		foreach( $warnings as $msg )
		{
			$IPBHTML .= "<p>Предупреждение: {$msg}</p>\n";
		}
		
		
 		$IPBHTML.= <<<EOF
		    </div><br />
EOF;
	}
								$IPBHTML .= <<<EOF
    		 	        <div>
    		 	        	<h3 class='maintitle'>{$_productName} {$_productVersion}</h3>
    		 	            <div class='ipsBox'>
    		 	        		<div id='contentContainer' class='ipsBox_container ipsPad'>
        		 	            {$content}
    		 	            </div>
		 	            </div>
		 	            <div style='padding-top: 17px; padding-right: 15px; padding-left: 15px'>
		 	                <div style='float: right'>
EOF;

if ( $data['hideButton'] !== TRUE AND $this->_showNoButtons !== TRUE )
{
	if ( $this->registry->output->nextAction == 'disabled' OR count( $errors ) )
	{
		$IPBHTML .= <<<EOF
		 	                    <input type='submit' class='nav_button' value='Установка не может быть продолжена' disabled='disabled' />
EOF;
	}
	else 
	{
		if( ! $this->registry->output->nextAction )
		{
			$back = my_getenv('HTTP_REFERER');
	
			$IPBHTML .= <<<EOF
	<input type='button' class='nav_button' value='< Назад' onclick="window.location='{$back}';return false;" />
EOF;
		}
		$IPBHTML .= <<<EOF
		 	                    <input type='submit' class='nav_button' value='Далее >' />
EOF;
	}
}

$date = date("Y");

$IPBHTML .= <<<EOF
						</div>
					</div> <!-- buttons -->
				<br />
				<br />
				<div class='copyright'>
		 	    	&copy; 
EOF;
$IPBHTML .= date("Y");
$IPBHTML .= <<<EOF
 Invision Power Services, Inc.<br/>
 IBResource, LTD<br/>
 <a href="http://ipbmafia.ru/">IPBmafia.Ru</a>
				</div>
			</div><!-- ipsLayout_content -->
		</div><!-- ipsLayout-->

	</div><!-- content -->
</div><!-- wrapper -->
EOF;
/* Bit of a kludge */

if ( is_array( $errors ) AND count( $errors ) )
{
	$IPBHTML .= <<<EOF
		<script type='text/javascript'>
		//<![CDATA[

		function form_redirect()
		{
			return false;
		}
		//]]>
		</script>
EOF;
}

$IPBHTML .= <<<EOF
		</form>
	
	</body>
</html>
EOF;

return $IPBHTML;
}

/**
 * AJAX page refresh template
 *
 * @access	public
 * @param	string		Output
 * @return	string		HTML
 */
public function page_refresh( $output ) {

$this->_showNoButtons = TRUE;

$output = ( is_array( $output ) AND count( $output ) ) ? $output : array( 0 => 'Продолжение' );
$errors = array_merge( $this->registry->output->fetchWarnings(), $this->registry->output->fetchErrors() );

$HTML = <<<EOF
<script type='text/javascript'>
//<![CDATA[
setTimeout("form_redirect()",2000);

function form_redirect()
{
	document.getElementById( 'install-form' ).submit();
}
//]]>
</script>

EOF;

if ( empty( $errors ) )
{
	$HTML .= <<<EOF
	<br />
	<div class='message'>Пожалуйста подождите...</div>
	<br />
	<br />
	<br />
	<div style='text-align: center'>
	<img src='{$this->registry->output->imageUrl}/wait.gif' />
	<br /><br /><br />
	<ul id='auto_progress'>
EOF;
	foreach( $output as $l )
	{
		$HTML .= <<<EOF
		<li>{$l}</li>
EOF;
	}
	$HTML .= <<<EOF
	</ul>
</div>
EOF;
}
else
{
	$HTML .= <<<EOF
	<div style='float: right'>
		<input type='submit' class='nav_button' value='Все равно продолжить &rarr;' />
	</div>
EOF;
}

return $HTML;
}

}