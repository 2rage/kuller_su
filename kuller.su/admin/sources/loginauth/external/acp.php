<?php

/**
 * <pre>
 * Invision Power Services
 * IP.Board v3.4.2
 * Login handler abstraction : External method
 * Last Updated: $Date: 2012-05-10 16:10:13 -0400 (Thu, 10 May 2012) $
 * </pre>
 *
 * @author 		$Author: bfarber $
 * @copyright	(c) 2001 - 2009 Invision Power Services, Inc.
 * @license		http://www.invisionpower.com/company/standards.php#license
 * @package		IP.Board
 * @link		http://www.invisionpower.com
 * @since		Tuesday 1st March 2005 (11:52)
 * @version		$Revision: 10721 $
 *
 */

$config		= array(
					array(
							'title'			=> 'Сервер удаленной базы данных',
							'description'	=> "Обычно 'localhost', используется если база данных находится на одном сервере",
							'key'			=> 'REMOTE_DB_SERVER',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Порт сервера удаленной базы',
							'description'	=> 'Оставьте пустым, если не уверены.',
							'key'			=> 'REMOTE_DB_PORT',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Имя удаленной базы',
							'description'	=> 'Имя базы данных, через которую будут авторизовываться пользователи',
							'key'			=> 'REMOTE_DB_DATABASE',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Имя пользователя для доступа к удаленной базе',
							'description'	=> '',
							'key'			=> 'REMOTE_DB_USER',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Пароль пользователя для доступа к удаленной базе',
							'description'	=> "",
							'key'			=> 'REMOTE_DB_PASS',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Имя таблицы пользователей в удаленной базе',
							'description'	=> "Таблица в которой хранятся данные пользователей, которые будет проверять IP.Board при авторизации",
							'key'			=> 'REMOTE_TABLE_NAME',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Префикс таблиц в удаленной базе данных',
							'description'	=> 'Можно не заполнять, если префикса нет',
							'key'			=> 'REMOTE_TABLE_PREFIX',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Поле имени в таблице',
							'description'	=> "Поле таблицы удаленной базы, по которому будет проверяться login или email при авторизации на форуме",
							'key'			=> 'REMOTE_FIELD_NAME',
							'type'			=> 'string',
						),
					array(
							'title'			=> 'Поле пароля в таблице',
							'description'	=> "Поле таблицы удаленной базы, по которому будет проверяться пароль при авторизации на форуме",
							'key'			=> 'REMOTE_FIELD_PASS',
							'type'			=> 'string',
						),
					array(
							'title'			=> 'Дополнительные данные для запроса',
							'description'	=> "Дополнения в условие запроса (например: AND status='active')" ,
							'key'			=> 'REMOTE_EXTRA_QUERY',
							'type'			=> 'string'
						),
					array(
							'title'			=> 'Способ хеширования пароля в удаленной базе',
							'description'	=> "Если вы не нашли метод нужный вам, необходимо будет изменить реализацию хеширования пароля на свою в auth.php" ,
							'key'			=> 'REMOTE_PASSWORD_SCHEME',
							'type'			=> 'select',
							'options'		=> array( array( 'md5', 'MD5' ), array( 'sha1', 'SHA1' ), array( 'none', 'Открытый текст' ) )
						),
					array(
							'title'			=> 'Remote Database Connection Type',
							'description'	=> "This field is only used for databases that use connection types, such as MS-SQL",
							'key'			=> 'REMOTE_SQL_TYPE',
							'type'			=> 'string',
						),
					);