<div class="sidebar-block poll-block">
						<div class="poll-block-top"></div>
						<div class="poll-block-bottom"></div>
						<h4 class="sidebar-section-poll-name">Голосование</h4>
						<p class="poll-description">{title}</p>
						<form action="#" class="radio-btn">
						    <label> [votelist]<form method="post" name="vote" action=''>[/votelist]</label>
							<label>{list}</label>
							<label>[voteresult]<br><p class="small">Всего проголосовало: {votes}</p> [/voteresult]</label>
							[votelist]
				<input type="hidden" name="vote_action" value="vote" />
				<input type="hidden" name="vote_id" id="vote_id" value="{vote_id}" />
            <center><button class="poll-submit" type="submit" onclick="doVote('vote'); return false;" ><span></span></button><a onclick="doVote('results'); return false;" >Результаты опроса</a></center>
			
			[/votelist]
						
						</form>	
					</div>