<?php
//@header('Location: '.$urlgo,true,302);
@$urlgo = $_GET['url'];
//echo '1:'.$urlgo ;
if (!$urlgo || $urlgo == '') {@$urlgo = $_SERVER['argv'][0];}
//echo '2:'.$urlgo ;
if (!$urlgo || $urlgo == '') {@$urlgo = $_SERVER['QUERY_STRING'];}
//echo '3:'.$urlgo ;
//$urlgo = str_replace("&amp;" , "&", $urlgo);

$urlgo = preg_replace("/^\?/" , "", $urlgo);
$html= <<<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Переход по внешней ссылке</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="robots" content="noindex">
	<link rel="shortcut icon" href="../favicon.ico" type="image/x-icon" />
</head>
<body id="body">
<noindex><br /><br /><center>Перенаправление на внешний ресурс: <br /><br />
<div id="waiting"></div>
<noscript>
Нажмите <a href="{$urlgo}" rel="nofollow">сюда</a> если ваш браузер не перешел по ссылке автоматически.
</noscript>
</center></noindex>


<script type='text/javascript'>

function countdown(secs){
	secs--;
    if(secs>0)  
	{
        document.getElementById("waiting").innerHTML = 'Осталось '+secs+'c.';
        window.setTimeout("countdown("+secs+")",1000);
    }  
	else { 
	    document.getElementById("waiting").innerHTML = 'Нажмите <a href="{$urlgo}" rel="nofollow">сюда</a> если ваш браузер не перешел по ссылке автоматически.';
		window.location.href = "{$urlgo}";
    }
}
countdown(3);
 
</script>
</body>
</html>
EOF;

echo $html
?>