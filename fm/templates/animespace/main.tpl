<!doctype html>
<html lang="ru">
	<head>
{headers}
<link media="screen" href="{THEME}/fonts/stylesheet.css" type="text/css" rel="stylesheet" />
<link media="screen" href="{THEME}/style/style.css" type="text/css" rel="stylesheet" />
<!-- <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script> -->
<script type="text/javascript" src="/engine/classes/js/dle_js.js"></script>
<script type="text/javascript" src="{THEME}/js/mobilyslider.js"></script>
<script type="text/javascript" src="{THEME}/js/jquery.formstyler.min.js"></script>
<script type="text/javascript" src="{THEME}/js/init.js"></script>
<script type="text/javascript" src="{THEME}/js/libs.js"></script>
<link media="screen" href="{THEME}/style/bbcodes.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="{THEME}/js/tooltip.js"></script>
<link media="screen" href="{THEME}/style/bbcodes.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="{THEME}/js/tooltip.js"></script>
<link rel="icon" href="templates/animespace/images/favicon.ico" type="image/x-icon" />

</head>
	<body>{AJAX}
		<!-- Верхний бар -->
		{include file="verbar.tpl"}
		<!-- Верхний бар -->
		<div class="wrapper">
			<div class="h-block">
				<!-- Боковые выступы -->
				<div class="h-block-top-left"></div>
				<div class="h-block-top-right"></div>
				<div class="h-block-bottom-left"></div>
				<div class="h-block-top-right"></div>
				<!-- Боковые выступы -->
				<!-- Горизонтальное меню -->
				{include file="gozmenu.tpl"}
				<!-- Горизонтальное меню -->
				<!-- Слайдер -->
				{include file="slider.tpl"}
				<!-- Слайдер -->
			</div>
			<div class="big-content-block">
				<div class="content-bottom"></div>
				<div class="container">
					<!-- правый блок, контент -->
					<div class="content">
						<!-- новость -->
                        {info}{content}
						<!-- новость -->



						            <!-- пагинация -->
							
                                    <!-- пагинация -->
					</div>	
					<!-- правый блок, контент -->
				</div>		

				<div class="sidebar-left">
					<!-- музыкальный блок -->
					<div class="sidebar-block music-block">
						<!-- боковые кнопки -->
						<div class="music-block-top"></div>
						<div class="music-block-bottom"></div>
						<!-- боковые кнопки -->
						<!-- плеер -->
						<div class="music-player">
						<center>
							<div id=wmp>Загрузка плеера ...<br><a href="http://www.macromedia.com/go/getflashplayer">Скачать</a></div>
							<script src="http://myradio24.com/swfobject.js"></script><script type="text/javascript">
							var so = new SWFObject("http://myradio24.com/energy.swf?v12", "simple", "180", "75", "9");
							so.addParam("wmode", "transparent");
							so.addParam("allowScriptAccess", "sameDomain");
							so.addVariable("type", "mp3");
							so.addVariable("stream", "http://listen3.myradio24.com:9000/8468");
							so.addVariable("song", "http://myradio24.com/users/8468/status.txt");
							so.addVariable("song_refresh", "15");
							so.addVariable("traffic", "yes");
							so.addVariable("listeners", "yes");
							so.addVariable("autostart", "yes");
							so.addVariable("start_volume", "70");
							so.addVariable("style", "1");
							so.write("wmp");
							</script>
						</center>
						</div>
						<!-- плеер -->
						<hr>
						<!-- сейчас играет -->
						<div class="music-now">
							<div class="music-section">Приятного Вам прослушивания!</div>
							<div class="music-name">
								<span></span> </div>
						</div>
						<!-- сейчас играет -->
						<!-- расписание -->
						<div class="music-ether">
							<div class="music-ether-section"><a href="http://vk.com/bgfkvbh">Заказать песню, передать привет!</div></a>
						</div>
						<!-- расписание -->
						<!-- слушать -->
						<div class="music-listen">
							<p>Слушать радио в:</p>
							<div class="music-listen-programms">
								<a href="http://fm.kuller.su/fm.kuller.su.m3u"><img src="{THEME}/img/winap.png" alt=""></a>
								<a href="http://fm.kuller.su/fm.kuller.su.pls"><img src="{THEME}/img/itunes.png" alt=""></a>
							</div>
							<hr>
							<p class="listen-now">Онлайн на сервере: <span>30</span></p>
						</div>
						<!-- слушать -->							
					</div>
					<!-- музыкальный блок -->
					<!-- голосование -->
					{vote}
					<!-- голосование -->
															<div class="sidebar-block music-block">
<script type="text/javascript" src="//vk.com/js/api/openapi.js?96"></script>

<!-- VK Widget -->
<div id="vk_groups"></div>
<script type="text/javascript">
VK.Widgets.Group("vk_groups", {mode: 0, width: "275", height: "200"}, 54733855);
</script>
</div>
					{IPBIntegration->LastPost}
				</div>			
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
			<div class="footer-container">
				<!-- друзья -->
				<div class="footer-friend left">
					<div class="footer-section-name-img">
					</div>
				</div>
				<!-- друзья -->
				<div class="footer-stats left">
					<div class="footer-section-name-img">
						<img src="{THEME}/img/title-stats.png" alt="">
					</div>
					
					<!-- список онлайн -->
					<div class="footer-stats-items-lists">
						{include file="engine/modules/dt_online.php"}
					</div>
					<!-- список онлайн -->
				</div>
				<div class="clear"></div>
				<div class="b-menu">
					<ul>
						<li><a href="http://fm.kuller.su/" title="Главная">Главная</a></li>
						<li><a href="http://kuller.su/" title="Форум">Форум</a></li>
					</ul>
				</div>
				<div class="clear"></div>
			</div>

			<div class="bottom-info">
				<div class="bottom-copyright left">
					<p>(c) Copyright KulleR.su </p>
					<p><a href="#" title="Пользовательское соглашение">Пользовательское соглашение</a></p>
				</div>
				<div class="bottom-age right">
					<p>Сайт может содержать материалы не рекомендованные для просмотра <br> лицам младше 18 лет.</p>
				</div>
			</div>
			<div class="clear"></div>
		</div>
	</body>
</html>