<div class="top-bar">
			<div class="top-center">
				<!-- Авториазция -->
				<div class="top-welcome left">
					{login}
				</div>
				<!-- Авторизация -->
				<!-- Поиск -->
				<div class="top-search right">
					<form action="#">
						<form id="searchbar" method="post" action=''>
          <input type="hidden" name="do" value="search" />
          <input type="hidden" name="subaction" value="search" />
          
          <input class="stext" id="story" name="story" value="Поиск..." onblur="if(this.value=='') this.value='Поиск...';" onfocus="if(this.value=='Поиск...') this.value='';" type="text" />
          <b class="light sbtop">&nbsp;</b>
          <b class="light sbfoot">&nbsp;</b>
						<input type="submit" value="" class="top-search-button">
					</form>
				</div>
				<!-- Поиск -->
			</div>
		</div>