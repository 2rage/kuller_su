<?php
require "SampQueryAPI.php";// Инклуд
$query = new SampQueryAPI('77.220.175.4', '7797');// сервер + IP
$stat = $query->getInfo();//инфа 1
$stat2 = $query->getRules();//инфа 2
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


<center>
	<font style="font-size:16pt;">
			<td>IP сервера  KulleR | Zombie [RUS/ENG]:</td>
			<td> <a href="samp://77.220.175.4:7797" title="Подключиться" style="color:red"> 77.220.175.4:7797</a></td>
		</tr>
		<br>
		</br>
		<tr>
			<td>Игроков на сервере:</td>
			<font color="red"><td><?= $stat['players'] ?> / <?= $stat['maxplayers'] ?></font></td>
		</tr>
		<br>
		</br>
		<tr>
			<td>Карта:</td>
			<font color="red"><td><?= htmlentities($stat['mapname']) ?></font></td>
		</tr>
		<br>
		</br>
		<tr>		
			<td>Режим:</td>
			<font color="green"><td>Онлайн</font></td>
		</tr>
		
	</font>
</center>
		