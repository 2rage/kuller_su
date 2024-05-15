<div class="news-item-body">
<div class="dcomment">
<table width="100%" cellspacing="0" cellpadding="0">
<tr>
   <td class="ss_topwhite">
       <table width="100%" cellspacing="0" cellpadding="0">
      <tr>
		<td align="left"><strong>Пользователь: {usertitle}</strong></td>
		<td align="right">&nbsp;</td>
      </tr>
      </table>
   </td>
</tr>
<tr>
   <td class="ss_top">
      <table width="100%" cellspacing="0" cellpadding="0">
      <tr>
		<td align="left">&nbsp;</td>
		<td width="95">&nbsp;</td>
      </tr>
      </table>	  
  </td>
</tr>
<tr>
<td class="ss_center2">			  
<div class="padd10px">              		  
<div class="tbprofile">
<div class="pad10">

<center><table width="675" nowrap="nowrap" class="tbprofile" align="left">
						<tr>
						     <td width="150" rowspan="5" align="center"><img src="{foto}" border="0">
<br>[not-logged] [ {edituser} ] [/not-logged]</td>
						     <td width="150" align="left">Полное имя:</td>
						     <td width="260" align="left">{fullname}</td>
						</tr>
						<tr>
						     <td width="150" align="left">Дата регистрации:</td>
						     <td width="260" align="left">{registration}</td>
						</tr>
						<tr>
						     <td width="150" align="left">Последнее посещение:</td>
						     <td width="260" align="left"> {lastdate} [online]<img src="{THEME}/images/online.png" style="vertical-align: middle;" title="Пользователь Онлайн" alt="Пользователь Онлайн" />[/online][offline]<img src="{THEME}/images/offline.png" style="vertical-align: middle;" title="Пользователь offline" alt="Пользователь offline" />[/offline]</td>
						</tr>
						<tr>
						     <td width="150" align="left">Группа:</td>
						     <td width="260" align="left"><font color="red">{status}</font>[time_limit] у групі до: {time_limit}[/time_limit]</td>
						</tr>
						<tr>
						     <td width="150" align="left">Место жительства:</td>
						     <td width="410" align="left" colspan="2">{land}</td>
						</tr>
						<tr>
						     <td width="150" align="left">E-Mail адрес:</td>
						     <td width="410" align="left" colspan="2">[ {email} ] &nbsp;&nbsp;&nbsp;[ {pm} ]</td>
						</tr>
						<tr>
						     <td width="150" align="left">Номер ICQ:</td>
						     <td width="410" align="left" colspan="2"><noindex>{icq}</noindex></td>
						
						</tr>
						<tr>
						
							</tr>
						     <td width="150" align="left">Количество публикаций:</td>
						     <td width="410" align="left" colspan="2">{news-num} &nbsp;&nbsp;&nbsp;[ {news} ]&nbsp;&nbsp;[rss]RSS[/rss]</td>
						</tr>
						<tr>
						     <td width="150" align="left">Количество комментариев:</td>
						     <td width="410" align="left" colspan="2">{comm-num} &nbsp;&nbsp;&nbsp;[ {comments} ]</td>
						</tr>
						<tr>
						     <td width="150" align="left">Немного о себе:</td>
						     <td width="410" align="left" colspan="2">{info}</td>
						</tr>
</table>
               </div> 
 </div> 

[not-logged]
<br>
<center><div id="options" style="display: none;">
<div class="tbprofile">
					<table width="560" nowrap="nowrap" class="tbprofile" align="center">
						<tr>
						     <td width="150" align="left">Ваш E-Mail:</td>
						     <td width="410" align="left"><input type="text" name="email" value="{editmail}" class="inprofile"><br>{hidemail}</td>
						</tr>
                          <tr>
						     <td width="150" align="left">Ваше Имя:</td>
						     <td width="410" align="left"><input type="text" name="fullname" value="{fullname}" class="inprofile"></td>
						</tr>
						<tr>
						     <td width="150" align="left">Место жительства:</td>
						     <td width="410" align="left"><input type="text" name="land" value="{land}" class="inprofile"></td>
						</tr>
						<tr>
						     <td width="150" align="left">Номер ICQ:</td>
						     <td width="410" align="left"><input type="text" name="icq" value="{icq}" class="inprofile"></td>
						</tr>
						<tr>
						     <td width="150" align="left">Список игнорируемых:</td>
						     <td width="410" align="left">{ignore-list}</td>
						</tr>
						<tr>
						     <td width="150" align="left">Старый пароль:</td>
						     <td width="410" align="left"><input type="password" name="altpass" class="inprofile"></td>
						</tr>
						<tr>
						     <td width="150" align="left">Новый пароль:</td>
						     <td width="410" align="left"><input type="password" name="password1" class="inprofile"></td>
						</tr>
						<tr>
						     <td width="150" align="left">Повторите пароль:</td>
						     <td width="410" align="left"><input type="password" name="password2" class="inprofile"></td>
						</tr>
						<tr>
						     <td width="150" align="left">О себе:</td>
						     <td width="410" align="left"><textarea name=info class="zaprofile">{editinfo}</textarea></td>
						</tr>
						<tr>
						     <td width="150" align="left">Подпись:</td>
						     <td width="410" align="left"><textarea name=signature class="zaprofile">{editsignature}</textarea></td>
						</tr>
						<tr>
						     <td width="150" align="left">Аватар:</td>
						     <td width="410" align="left"><input type="file" name="image" class="inprofile"><br><br>Сервис <a href="http://www.gravatar.com/" target="_blank">Gravatar</a>: <input type="text" name="gravatar" value="{gravatar}" class="f_input" /> (Укажите E-mail на данном сервисе)<br><br><input type="checkbox" name="del_foto" value="yes">  Видалити аватар</td></td>
						</tr>
						<tr>
						     <td width="150" align="left">Блокировка по IP:</td>
						     <td width="410" align="left"><input type="text" name="allowed_ip" value="{allowed-ip}" class="inprofile"><br>Ваш IP: 91.124.30.76<br><font style="color:red;font-size:10px;">*  Увага! Будьте пильні при зміні даного налаштування. Доступ до вашого аккаунту буде доступний лише з тої IP або підмережі, яку Ви вкажете. Приклад: 192.48.25.71 або 129.42.*.*</span></td>
						</tr>
					</table>  

<br><div class="fieldsubmit">
			<input class="fbutton" type="submit" name="submit" value="Отправить" />
			<input name="submit" type="hidden" id="submit" value="submit" />
		</div>

</div>
</div>
[/not-logged]
</div> 
 </div> 
</td>
</tr>
</table></div>