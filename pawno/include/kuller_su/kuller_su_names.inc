
//Получение значений
stock GetProfNameT(teamid,profess){
	new str[64];
	switch(teamid){
	      case ZOMBIE:{
		       switch(profess){
                      case ZOMBIE_PROF_TANK:str = "Tank";
				      case ZOMBIE_PROF_JOKEY:str = "Jokey";
				      case ZOMBIE_PROF_VEDMA:str = "Vedma";
				      case ZOMBIE_PROF_BUMER:str = "Bumer";
               }
          }
		  case HUMAN:{
			   switch(profess){
					case HUMAN_PROF_SHTURMOVIK:str = "Shturmovik";
					case HUMAN_PROF_MEDIK:str = "Medik";
					case HUMAN_PROF_SNIPER:str = "Sniper";
					case HUMAN_PROF_DEFENDER:str = "Zash'itnik";
					case HUMAN_PROF_CREATER:str = "Stroitel";
	           }
          }
	}
	return str;
}


stock GetRangNameT(teamid,profess,rang){
	new str[64];
	switch(teamid){
	      case ZOMBIE:GetProfNameT(ZOMBIE,profess);
		  case HUMAN:{
			   switch(profess)/*{
					case HUMAN_PROF_SHTURMOVIK:str = human_class_shturmovik[rang][rang_nameT];
					case HUMAN_PROF_MEDIK:str = human_class_medik[rang][rang_nameT];
					case HUMAN_PROF_SNIPER:str = human_class_sniper[rang][rang_nameT];
					case HUMAN_PROF_DEFENDER:str = human_class_defender[rang][rang_nameT];
					case HUMAN_PROF_CREATER:str = human_class_creater[rang][rang_nameT];
	           }*/
	           {
					case HUMAN_PROF_SHTURMOVIK:
					{
						  switch(rang)
						  {
							   case 0:str = "Serjant";
							   case 1:str = "Leitenant";
							   case 2:str = "Mayor";
							   case 3:str = "General armii";
							   case 4:str = "Ministr oboroni";
						  }
					}
					case HUMAN_PROF_MEDIK:
					{
			              switch(rang)
						  {
							   case 0:str = "Intern";
							   case 1:str = "Nauchniy Sotrudnik";
							   case 2:str = "Kandidat medicinskih nauk";
							   case 3:str = "Doctor medicinskih nauk";
							   case 4:str = "Akademik";
						  }
			        }
					case HUMAN_PROF_SNIPER:
					{
                          switch(rang)
						  {
							   case 0:str = "Kapral";
							   case 1:str = "Michman";
							   case 2:str = "Kommander";
							   case 3:str = "Brigadir";
							   case 4:str = "General-Mayor";
						  }
					}
					case HUMAN_PROF_DEFENDER:
					{
                          switch(rang)
						  {
							   case 0:str = "Bombardir";
							   case 1:str = "Starshina";
							   case 2:str = "Poruchik";
							   case 3:str = "Pheldmarshal";
							   case 4:str = "Generalissimus";
						  }
					}
					case HUMAN_PROF_CREATER:
					{
                          switch(rang)
						  {
							   case 0:str = "Podsobnik";
							   case 1:str = "Uchenik";
							   case 2:str = "Master";
							   case 3:str = "Prorab";
							   case 4:str = "Arhitector";
						  }
					}
			  }
          }
	}
	return str;
}
stock GetProfName(teamid,profess){
	new str[20];
	switch(teamid)
	{
	      case ZOMBIE:
		  {
		       switch(profess)
			   {
                      case ZOMBIE_PROF_TANK: strmid(str,"Танк",0,sizeof(str));    //"str = "Танк";
				      case ZOMBIE_PROF_JOKEY:str = "Жокей";
				      case ZOMBIE_PROF_VEDMA:str = "Ведьма";
				      case ZOMBIE_PROF_BUMER:str = "Бумер";
               }
          }
		  case HUMAN:
		  {
			   switch(profess)
			   {

					case HUMAN_PROF_SHTURMOVIK:str = "Штурмовик";
					case HUMAN_PROF_MEDIK:str = "Медик";
					case HUMAN_PROF_SNIPER:str = "Снайпер";
					case HUMAN_PROF_DEFENDER:str = "Защитник";
					case HUMAN_PROF_CREATER:str = "Строитель";


	           }
          }
	}
	return str;
}
stock GetRangName(teamid,profess,rang){
    new str[64];
	switch(teamid){
	      case ZOMBIE:GetProfName(ZOMBIE,profess);
		  case HUMAN:{
			   switch(profess){
	  /*
					case HUMAN_PROF_SHTURMOVIK:return human_class_shturmovik[rang][rang_name];
					case HUMAN_PROF_MEDIK:return human_class_medik[rang][rang_name];
					case HUMAN_PROF_SNIPER:return  human_class_sniper[rang][rang_name];
					case HUMAN_PROF_DEFENDER:return human_class_defender[rang][rang_name];
					case HUMAN_PROF_CREATER:return human_class_creater[rang][rang_name];
					*/
					case HUMAN_PROF_SHTURMOVIK:
					{
						  switch(rang)
						  {
							   case 0:str = "Сержант";
							   case 1:str = "Лейтенант";
							   case 2:str = "Майор";
							   case 3:str = "Генерал армии";
							   case 4:str = "Министр обороны";
						  }
					}
					case HUMAN_PROF_MEDIK:
					{
			              switch(rang)
						  {
							   case 0:str = "Интернт";
							   case 1:str = "Научный сотрудник";
							   case 2:str = "Кандидат медицинских наук";
							   case 3:str = "Доктор медицинских наук";
							   case 4:str = "Академик";
						  }
			        }
					case HUMAN_PROF_SNIPER:
					{
                          switch(rang)
						  {
							   case 0:str = "Капрал";
							   case 1:str = "Мичман";
							   case 2:str = "Коммандер";
							   case 3:str = "Бригадир";
							   case 4:str = "Генерал-майор";
						  }
					}
					case HUMAN_PROF_DEFENDER:
					{
                          switch(rang)
						  {
							   case 0:str = "Бомбардир";
							   case 1:str = "Старшина";
							   case 2:str = "Поручик";
							   case 3:str = "Фельдмаршал";
							   case 4:str = "Генералиссимус";
						  }
					}
					case HUMAN_PROF_CREATER:
					{
                          switch(rang)
						  {
							   case 0:str = "Подсобник";
							   case 1:str = "Ученик";
							   case 2:str = "Мастер";
							   case 3:str = "Прораб";
							   case 4:str = "Архитектор";
						  }
					}
	           }
          }
	}
	return str;
}
