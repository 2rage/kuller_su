<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Login handler abstraction : LDAP method
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @since		2.1.0
 * @version		$Revision: 10721 $
 *
 */
 
$filter_description = <<<EOF
Укажите строку фильтра для LDAP чтобы ограничить поиск по ldap_uid_field. Фильтр может быть полезен для авторизации только по опеределенной группе в вашей организации, например. 'ou=your_department'
<br /><br />
Ниже перечислены все операторы, которые могут быть использованы:<br />
 =xyz   - ищет точное совпадение<br />
 =*xyz  - ищет все, что заканчивается на xyz<br />
 =xyz*  - ищет все, что начинается на xyz<br />
 =*xyz* - ищет все, что содержит в себе xyz<br />
 =*     - ищет все значения 
<br /><br />
Возможно использование логических операторов для построения сложных выражений<br />
 &(term1)(term2)  - term1 И term2<br />
 | (term1)(term2) - term1 ИЛИ term2<br />
 !(term1) - НЕ term1, например, '!(ou=Student)'<br />
<br /><br />
Оставьте это поле пустым, если вы не уверены как фильтровать записи в вашем реестре.
EOF;

$config		= array(
					array(
							'title'			=> 'LDAP сервер',
							'description'	=> 'Имя хоста или IP',
							'key'			=> 'ldap_server',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'LDAP порт сервера',
							'description'	=> 'Если нужен',
							'key'			=> 'ldap_port',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Имя пользователя для LDAP',
							'description'	=> 'Если LDAP сервер требует имени пользователя для подключения, введите его здесь',
							'key'			=> 'ldap_server_username',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Пароль пользователя для LDAP',
							'description'	=> 'Если LDAP сервер требует пароля пользователя для подключения, введите его здесь',
							'key'			=> 'ldap_server_password',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Поле UID',
							'description'	=> "",
							'key'			=> 'ldap_uid_field',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Базовый DN',
							'description'	=> "Например, o=My Company,c=US",
							'key'			=> 'ldap_base_dn',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Фильтр',
							'description'	=> $filter_description,
							'key'			=> 'ldap_filter',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Версия протокола LDAP',
							'description'	=> "Выберите версию вашего LDAP сервера (обычно Версия 3)",
							'key'			=> 'ldap_server_version',
							'type'			=> 'select',
							'options'		=> array( array( 2, 'Версия 2' ), array( 3, 'Версия 3' ) )
						),
					array(
							'title'			=> 'OPT Referrals',
							'description'	=> "При использовании Win2K3 Active Directory, должно быть включено",
							'key'			=> 'ldap_opt_referrals',
							'type'			=> 'yesno',
						),
					array(
							'title'			=> 'Суффикс логина пользователя',
							'description'	=> "Если необходимо добавлять суффикс к имени пользователя ( например, '@mycompany.com')" ,
							'key'			=> 'ldap_username_suffix',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Обязательный пароль',
							'description'	=> "Если пользователи в вашем реестре не имеют индивидуальных паролей выключите эту опцию" ,
							'key'			=> 'ldap_user_requires_pass',
							'type'			=> 'yesno',
						),
					array(
							'title'			=> 'Поле имени пользователя',
							'description'	=> "Если имя поля указано, IPB будет пытаться получить отображаемое имя пользователя из этого поля" ,
							'key'			=> 'ldap_display_name',
							'type'			=> 'string',
						),
					array(
							'title'			=> 'Поле Email адреса',
							'description'	=> "Если имя поля указано, IPB будет пытаться получить email из этого поля" ,
							'key'			=> 'ldap_email_field',
							'type'			=> 'string',
						),
					array(
							'title'			=> 'Дополнительные поля',
							'description'	=> "Список полей разделенных запятой из которых IPB может получить дополнительную информацию.  Вам необходимо будет также изменить auth.php чтобы правильно сохранять значения этих полей в IPB." ,
							'key'			=> 'additional_fields',
							'type'			=> 'string',
						),
					);