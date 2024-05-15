                        <div class="news-item-block">
							<!-- лапки под новостями -->
							<div class="news-bg-right-top"></div>
							<div class="news-bg-left-bottom"></div>
							<!-- лапки под новостями -->
							<div class="news-item-body">
								<h3 class="news-item-title">[full-link]{title}[/full-link]</a></h3>
								<!-- мини-информация о новости -->
								<div class="news-item-detalis">
									<span class="news-item-author">{author}</span>
									<span class="news-item-date">[day-news]{date}[/day-news]</span>
									<span class="news-item-comments">[com-link]{comments-num}[/com-link]</span>
								</div>
								<!-- мини-информация о новости -->
								<!-- текст новости -->
								<div class="">
								{short-story}
								</div>
								<!-- текст новости -->
							</div>
							<div class="news-item-info">
								<!-- теги -->
								<div class="news-item-tags">Теги: {link-category}</div>
								<!-- теги -->
								<!-- кнопки для «поделиться» -->
								<div class="news-more-share">
									<div class="news-more">[full-link]Подробнее[/full-link]</div>
									<div class="news-share">
										<ul>
											<li><a href="#"><img src="{THEME}/img/social/vk.png" alt="VK"></a></li>
											<li><a href="#"><img src="{THEME}/img/social/fb.png" alt="Facebook"></a></li>
											<li><a href="#"><img src="{THEME}/img/social/twitter.png" alt="Twitter"></a></li>
											<li><a href="#"><img src="{THEME}/img/social/gplus.png" alt="Google +"></a></li>
										</ul>
									</div>
								</div>
								<!-- кнопки для «поделиться» -->
							</div>
						</div>
						<script language="javascript" type="text/javascript">
<!--
$(function cImg () {
    nNews = $("div[id*=news-id-]")
    nNews.each(function (i) {
    $(this).replaceWith("<div id='n-id-"+i+"' class='modnews'><div class='image load'></div>" + $(this).text() + "</div>");
    $(this).find("img").filter("img:first").unwrap().removeAttr("align").fadeIn(2000).prependTo("div[id='n-id-"+i+"'] div[class*=image]");
    $("div[class*=image]:empty").hide(2000);

    });
    });
//-->
</script>