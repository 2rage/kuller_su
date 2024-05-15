<?php
# FORUMS: Last field: forums_bitoptions

$INSERT[] = "INSERT INTO forums VALUES (1, 0, 0, 0, 0, '', 'Категория', 'Тестовая категория. Ее можно удалить или переименовать.', 1, 1, 0, '', '', '', 0, 'last_post', 'Z-A', 30, 'all', 0, 0, 1, 1, 1, 0, -1, '', 0, 0, '', '', '', 0, '', 1, 0, 0, 1, 0, '', 0,0,0,1,0,'category','','','', 0, 0, 0, 0, '', 0, 0, 0, 0);";
$INSERT[] = "INSERT INTO forums VALUES (2, 1, 0, UNIX_TIMESTAMP(), 1, '<%admin_name%>', 'Форум', 'Тестовый форум. Может быть удален или переименован.', 1, 1, 0, '', '', 'Добро пожаловать&#33;', 1, 'last_post', 'Z-A', 100, 'all', 0, 0, 1, 1, 1, 0, 1, '', 0, 0, '', '', '', 1, '', 0, 0, 0, 1, 0, 'Добро пожаловать&#33;', 1,0,0,1,0,'forum','dobro-pojalovat','<%admin_seoname%>','a:1:{i:1;i:<%time%>;}', 0, 0, 0, 0, '', 0, 0, 0, 0);";
$INSERT[] ="INSERT INTO permission_index VALUES(NULL, 'forums', 'forum', 1, '*', '*', '*', '*', ',4,3,', ',4,3,', '', 0, 0, NULL)";
$INSERT[] ="INSERT INTO permission_index VALUES(NULL, 'forums', 'forum', 2, '*', '*', '*', '*', ',4,3,', ',4,3,', '', 0, 0, NULL)";

$INSERT[] = "INSERT INTO forum_perms SET perm_name='Маска неактивированных', perm_id=1";
$INSERT[] = "INSERT INTO forum_perms SET perm_name='Маска пользователей', perm_id=3";
$INSERT[] = "INSERT INTO forum_perms SET perm_name='Маска гостей', perm_id=2";
$INSERT[] = "INSERT INTO forum_perms SET perm_name='Маска администраторов', perm_id=4";
$INSERT[] = "INSERT INTO forum_perms SET perm_name='Маска забаненных', perm_id=5";
$INSERT[] = "INSERT INTO forum_perms SET perm_name='Маска модераторов', perm_id=6";

$INSERT[] = "INSERT INTO posts (pid, append_edit, edit_time, author_id, author_name, use_sig, use_emo, ip_address, post_date, post, queued, topic_id, new_topic, edit_name, post_key, post_htmlstate) VALUES (1, 0, NULL, 1, '<%admin_name%>', 0, 1, '127.0.0.1', UNIX_TIMESTAMP(), 'Добро пожаловать на ваш новый форум под управлением Invision Power Board&#33;<br /><br />  <br /><br /> Поздравляем с покупкой и установкой нашего продукта.  Желаем долгой и успешной жизни вашему сообществу&#33;<br /><br /> А теперь время проверить работу форума - удалите эту тему, а так же измените тестовые форум и категорию в администраторском центре.<br /><br />  <br /><br /> [url=http://external.ipslink.com/ipboard30/landing/?p=docs-ipb]Ну и конечно же почитайте документацию...[/url]', 0, 1, 1, NULL, '0', 0);";

# TOPICS: seo_first_name
$INSERT[] = "INSERT INTO topics VALUES (1, 'Добро пожаловать&#33;', 'open', 0, 1, UNIX_TIMESTAMP(), 1, UNIX_TIMESTAMP(), '<%admin_name%>', '<%admin_name%>', '0', 0, 0, 2, 1, 1, 0, null, 0, 1, 0, 0, 0, 0, 0, 'dobro-pojalovat', '<%admin_seoname%>', '<%admin_seoname%>', 0, 0, 0, 0, UNIX_TIMESTAMP(), 0);";

