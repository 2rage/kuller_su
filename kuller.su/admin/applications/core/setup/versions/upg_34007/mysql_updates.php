<?php

$SQL[] = "DELETE FROM core_sys_conf_settings WHERE conf_key='keycaptcha_template';";
$SQL[] = "ALTER TABLE profile_portal ADD vc_photo TEXT;";

//