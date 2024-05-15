
//Счетчики людей и зомби
new Text: TD_Zombies_Counter;
new Text: TD_Humans_Counter;

// Счетчик времени до конца арены
new Text: TD_EVC_Counter;

// Красный экран заражения
new Text: TD_InfectScreenBox;

// Загрузочный экран при входе на сервер
new Text: TD_LoadScreen;

// Вывод хп и денег игрока 
new PlayerText: PTD_HpText[MAX_PLAYERS];
new PlayerText: PTD_MoneyText[MAX_PLAYERS];

// Информеры о победе людей или зомби
new Text: TD_ZombiesWin;
new Text: TD_HumansWin;

// Элементы голосования
new Text: _VoteName_;
new Text: _VoteTime_;
new Text: _VoteCounter_;
new Text: _VoteTitle_;
new Text: _VoteBorder_;

// Информер профессии
new PlayerText: PTD_iNF_Polosa[MAX_PLAYERS];
new PlayerText: PTD_iNF_Information[MAX_PLAYERS];
new PlayerText: PTD_iNF_Score[MAX_PLAYERS];

// Текстдрав полученных денег (+999ZM)
new PlayerText: TD_DropZmInformer[MAX_PLAYERS];

// Надпись ZM у денег
new Text: TD_ZmText;

// Лого сервера
new Text:TD_Logo_Server1;
new Text:TD_Logo_Server2;

// Информация о версии
new Text: CreatedBy;

stock CreateTextDraws()
{
	// Текстдрав: надпись ZM
	TD_ZmText = TextDrawCreate(486.793304, 73.499992, "ZM:");
	TextDrawLetterSize(TD_ZmText, 0.404083, 2.667500);
	TextDrawAlignment(TD_ZmText, 1);
	TextDrawColor(TD_ZmText, 8388863);
	TextDrawSetShadow(TD_ZmText, 0);
	TextDrawSetOutline(TD_ZmText, 1);
	TextDrawBackgroundColor(TD_ZmText, 51);
	TextDrawFont(TD_ZmText, 1);
	TextDrawSetProportional(TD_ZmText, 1);

    //Текстдрав: время
	TD_EVC_Counter = TextDrawCreate(6.000000,211.000000,"EVC: 00:00");
	TextDrawAlignment(TD_EVC_Counter,0);
	TextDrawBackgroundColor(TD_EVC_Counter,0xff000033);
	TextDrawFont(TD_EVC_Counter,1);
	TextDrawLetterSize(TD_EVC_Counter,0.599999,3.000000);
	TextDrawColor(TD_EVC_Counter,0x00ffffff);
	TextDrawSetShadow(TD_EVC_Counter,2);
	TextDrawSetProportional(TD_EVC_Counter,1);
	TextDrawSetOutline(TD_EVC_Counter,1);
	
	//Текстдрав: хуманс коунтер
	TD_Humans_Counter = TextDrawCreate(337.000000,416.000000,"Humans: X");
	TextDrawAlignment(TD_Humans_Counter,0);
	TextDrawBackgroundColor(TD_Humans_Counter,0x000000ff);
	TextDrawFont(TD_Humans_Counter,1);
	TextDrawLetterSize(TD_Humans_Counter,0.899999,3.199999);
	TextDrawColor(TD_Humans_Counter,0x0000ffff);
	TextDrawSetProportional(TD_Humans_Counter,1);
	TextDrawSetShadow(TD_Humans_Counter,2);
	
	//Текстдрав: зомбиес коунтер
	TD_Zombies_Counter = TextDrawCreate(161.000000,415.000000,"Zombies: X");
	TextDrawAlignment(TD_Zombies_Counter,0);
	TextDrawBackgroundColor(TD_Zombies_Counter,0x000000ff);
	TextDrawFont(TD_Zombies_Counter,1);
    TextDrawLetterSize(TD_Zombies_Counter,0.799999,3.299999);
	TextDrawColor(TD_Zombies_Counter,0xff0000ff);
	TextDrawSetProportional(TD_Zombies_Counter,1);
	TextDrawSetShadow(TD_Zombies_Counter,2);

	//Текстдрав: Зомбиес and Humans Вин
	TD_HumansWin = TextDrawCreate(199.000000,131.000000,"Humans Win");
	TD_ZombiesWin = TextDrawCreate(197.000000,132.000000,"Zombies Win");
	TextDrawAlignment(TD_HumansWin,0);
    TextDrawAlignment(TD_ZombiesWin,0);
	TextDrawBackgroundColor(TD_HumansWin,0x000000ff);
	TextDrawBackgroundColor(TD_ZombiesWin,0x000000ff);
	TextDrawFont(TD_HumansWin,2);
	TextDrawLetterSize(TD_HumansWin,1.000000,4.499999);
	TextDrawFont(TD_ZombiesWin,2);
	TextDrawLetterSize(TD_ZombiesWin,1.000000,4.299999);
	TextDrawColor(TD_HumansWin,0x00ffffff);
	TextDrawColor(TD_ZombiesWin,0xff000099);
	TextDrawSetProportional(TD_HumansWin,1);
	TextDrawSetProportional(TD_ZombiesWin,1);
	TextDrawSetShadow(TD_HumansWin,2);
	TextDrawSetShadow(TD_ZombiesWin,2);

	//Текстдрав: Текстдрав-лого
	TD_LoadScreen = TextDrawCreate(0.0, -1.0, "TD_LoadScreen");
    TextDrawBackgroundColor(TD_LoadScreen, 255);
    TextDrawFont(TD_LoadScreen, 4);
    TextDrawLetterSize(TD_LoadScreen, 0.5, 1.0);
    TextDrawTextSize(TD_LoadScreen, 640.0, 449.0);
    TextDrawSetString(TD_LoadScreen, "loadsc2:loadsc2");
    TextDrawHideForAll(TD_LoadScreen);

    //Текстдрав: Красный экран при заражении
    TD_InfectScreenBox = TextDrawCreate(0.0, 0.0,"~n~");
    TextDrawLetterSize(TD_InfectScreenBox,0.1,50.0);
    TextDrawUseBox(TD_InfectScreenBox, 1);
    TextDrawBoxColor(TD_InfectScreenBox, 0xff000030);//'60' - больше - ярче
    
    //Голосование
    _VoteName_ = TextDrawCreate(499.000000,141.000000,"");
    TextDrawAlignment(_VoteName_,0);
    TextDrawBackgroundColor(_VoteName_,0x000000ff);
    TextDrawFont(_VoteName_,1);
    TextDrawLetterSize(_VoteName_,0.299999,1.000000);
    TextDrawColor(_VoteName_,0xff0000ff);
    TextDrawSetOutline(_VoteName_,1);
    TextDrawSetProportional(_VoteName_,1);
    TextDrawSetShadow(_VoteName_,1);
    
    _VoteTime_ = TextDrawCreate(500.000000,162.000000,"00:00");
    TextDrawAlignment(_VoteTime_,0);
    TextDrawBackgroundColor(_VoteTime_,0x000000ff);
    TextDrawFont(_VoteTime_,2);
    TextDrawLetterSize(_VoteTime_,0.299999,1.300000);
    TextDrawColor(_VoteTime_,0x00ffffff);
    TextDrawSetOutline(_VoteTime_,1);
    TextDrawSetProportional(_VoteTime_,1);
    TextDrawSetShadow(_VoteTime_,1);
    
    _VoteCounter_ = TextDrawCreate(499.000000,153.000000,"Votes: 99/100");
    TextDrawAlignment(_VoteCounter_,0);
    TextDrawBackgroundColor(_VoteCounter_,0x000000ff);
    TextDrawFont(_VoteCounter_,1);
    TextDrawLetterSize(_VoteCounter_,0.299999,1.000000);
    TextDrawColor(_VoteCounter_,0xffff00ff);
    TextDrawSetOutline(_VoteCounter_,1);
    TextDrawSetProportional(_VoteCounter_,1);
    TextDrawSetShadow(_VoteCounter_,1);
    
    _VoteTitle_ = TextDrawCreate(515.000000,129.000000,"Vote Kick:");
    TextDrawAlignment(_VoteTitle_,0);
    TextDrawBackgroundColor(_VoteTitle_,0x000000ff);
    TextDrawFont(_VoteTitle_,2);
    TextDrawLetterSize(_VoteTitle_,0.299999,1.200000);
    TextDrawColor(_VoteTitle_,0xffffffff);
    TextDrawSetOutline(_VoteTitle_,1);
    TextDrawSetProportional(_VoteTitle_,1);
    TextDrawSetShadow(_VoteTitle_,1);
    
    _VoteBorder_ = TextDrawCreate(497.000000,178.000000,"_");
    TextDrawUseBox(_VoteBorder_,1);
    TextDrawBoxColor(_VoteBorder_,0x00000066);
    TextDrawTextSize(_VoteBorder_,614.000000,12.000000);
    TextDrawAlignment(_VoteBorder_,0);
    TextDrawBackgroundColor(_VoteBorder_,0x000000ff);
    TextDrawFont(_VoteBorder_,3);
    TextDrawLetterSize(_VoteBorder_,6.799999,-5.799997);
    TextDrawColor(_VoteBorder_,0xffffffff);
    TextDrawSetOutline(_VoteBorder_,1);
    TextDrawSetProportional(_VoteBorder_,1);
    TextDrawSetShadow(_VoteBorder_,1);
    HideVoteTexts();
    
    
    // Лого из двух частей

	TD_Logo_Server1 = TextDrawCreate(527.554931, 422.916717, "KulleR.su");
	TextDrawLetterSize(TD_Logo_Server1, 0.371288, 1.518332);
	TextDrawTextSize(TD_Logo_Server1, -416.983978, -141.750015);
	TextDrawAlignment(TD_Logo_Server1, 1);
	TextDrawColor(TD_Logo_Server1, -1378294017);
	TextDrawSetShadow(TD_Logo_Server1, 0);
	TextDrawSetOutline(TD_Logo_Server1, 0);
	TextDrawBackgroundColor(TD_Logo_Server1, 51);
	TextDrawFont(TD_Logo_Server1, 1);
	TextDrawSetProportional(TD_Logo_Server1, 1);

	TD_Logo_Server2 = TextDrawCreate(581.435058, 423.500030, "Zombie");
	TextDrawLetterSize(TD_Logo_Server2, 0.325372, 1.460000);
	TextDrawAlignment(TD_Logo_Server2, 1);
	TextDrawColor(TD_Logo_Server2, -16776961);
	TextDrawSetShadow(TD_Logo_Server2, 0);
	TextDrawSetOutline(TD_Logo_Server2, 1);
	TextDrawBackgroundColor(TD_Logo_Server2, 51);
	TextDrawFont(TD_Logo_Server2, 1);
	TextDrawSetProportional(TD_Logo_Server2, 1);
	
	// Develop by
	CreatedBy = TextDrawCreate(9.523804, 433.066467, "Zombie S-ROW v.002_RC develop by 2rage");
	TextDrawLetterSize(CreatedBy, 0.133046, 0.900267);
	TextDrawAlignment(CreatedBy, 1);
	TextDrawColor(CreatedBy, -1);
	TextDrawSetShadow(CreatedBy, 0);
	TextDrawSetOutline(CreatedBy, 0);
	TextDrawBackgroundColor(CreatedBy, 51);
	TextDrawFont(CreatedBy, 1);
	TextDrawSetProportional(CreatedBy, 1);
    return 1;
}



//Удаление всех текстдравов
stock DestroyTextDraws()
{
    TextDrawDestroy(TD_Zombies_Counter);
	TextDrawDestroy(TD_EVC_Counter);
	TextDrawDestroy(TD_Humans_Counter);
	TextDrawDestroy(TD_LoadScreen);
	TextDrawDestroy(TD_InfectScreenBox);
	TextDrawDestroy(TD_HumansWin);
	TextDrawDestroy(TD_ZombiesWin);
	DestroyVoteTexts();
	for(new i; i < MAX_PLAYERS; i ++)
	{
			PlayerTextDrawDestroy(i,PTD_HpText[i]);
			PlayerTextDrawDestroy(i,PTD_MoneyText[i]);
			//DestroyPlayerTextDraws(i);
	}
}

stock SetVoteCounter(value,maxvalue)
{
	new str[15];
	format(str,sizeof(str),"Votes: %d/%d",value,maxvalue);
	TextDrawSetString(_VoteCounter_,str);
	return 1;
}

stock ShowVoteTexts()
{
	TextDrawShowForAll(_VoteName_);
	TextDrawShowForAll(_VoteTime_);
	TextDrawShowForAll(_VoteCounter_);
	TextDrawShowForAll(_VoteTitle_);
	TextDrawShowForAll(_VoteBorder_);
	return 1;
}


stock HideVoteTexts()
{
    TextDrawHideForAll(_VoteName_);
	TextDrawHideForAll(_VoteTime_);
	TextDrawHideForAll(_VoteCounter_);
	TextDrawHideForAll(_VoteTitle_);
	TextDrawHideForAll(_VoteBorder_);
	return 1;
}


stock HideVoteTextsForPlayer(playerid)
{
    TextDrawHideForPlayer(playerid,_VoteName_);
	TextDrawHideForPlayer(playerid,_VoteTime_);
	TextDrawHideForPlayer(playerid,_VoteCounter_);
	TextDrawHideForPlayer(playerid,_VoteTitle_);
	TextDrawHideForPlayer(playerid,_VoteBorder_);
	return 1;
}

stock DestroyVoteTexts()
{
	TextDrawDestroy(_VoteName_);
	TextDrawDestroy(_VoteTime_);
	TextDrawDestroy(_VoteCounter_);
	TextDrawDestroy(_VoteTitle_);
	TextDrawDestroy(_VoteBorder_);
	return 1;
}

//Создать текстдарвы хп и денег для игрока и денег за убийство
stock CreateTextDrawsHpAndMoney(playerid)
{
    PTD_HpText[playerid] = CreatePlayerTextDraw(playerid,555.000000,66.000000,"0000");
	PlayerTextDrawAlignment(playerid,PTD_HpText[playerid],0);
	PlayerTextDrawBackgroundColor(playerid,PTD_HpText[playerid],0x000000ff);
	PlayerTextDrawFont(playerid,PTD_HpText[playerid],2);
	PlayerTextDrawLetterSize(playerid,PTD_HpText[playerid],0.399999,1.000000);
	PlayerTextDrawColor(playerid,PTD_HpText[playerid],0x00ffffff);
	PlayerTextDrawSetOutline(playerid,PTD_HpText[playerid],1);
	PlayerTextDrawSetProportional(playerid,PTD_HpText[playerid],1);
	PlayerTextDrawSetShadow(playerid,PTD_HpText[playerid],1);

	PTD_MoneyText[playerid] = CreatePlayerTextDraw(playerid,497.000000,94.000000,"RUB: 0");//499.000000,100.000000
	PlayerTextDrawAlignment(playerid,PTD_MoneyText[playerid],0);
	PlayerTextDrawBackgroundColor(playerid,PTD_MoneyText[playerid],0x000000ff);
	PlayerTextDrawFont(playerid,PTD_MoneyText[playerid],1);
    PlayerTextDrawLetterSize(playerid,PTD_MoneyText[playerid],0.699999,2.700000);
	PlayerTextDrawColor(playerid,PTD_MoneyText[playerid],0x00ff0066);
	PlayerTextDrawSetProportional(playerid,PTD_MoneyText[playerid],1);
	PlayerTextDrawSetShadow(playerid,PTD_MoneyText[playerid],1);
	
	TD_DropZmInformer[playerid] = CreatePlayerTextDraw(playerid, 338.741027, 161.583343, "+999 ZM");
	PlayerTextDrawLetterSize(playerid, TD_DropZmInformer[playerid], 0.407364, 2.375828);
	PlayerTextDrawTextSize(playerid, TD_DropZmInformer[playerid], 359.370483, 387.333282);
	PlayerTextDrawAlignment(playerid, TD_DropZmInformer[playerid], 1);
	PlayerTextDrawColor(playerid, TD_DropZmInformer[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, TD_DropZmInformer[playerid], 0);
	PlayerTextDrawSetOutline(playerid, TD_DropZmInformer[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, TD_DropZmInformer[playerid], 51);
	PlayerTextDrawFont(playerid, TD_DropZmInformer[playerid], 1);
	PlayerTextDrawSetProportional(playerid, TD_DropZmInformer[playerid], 1);
    return 1;
}

// ~~~~~~~~~~~~~~~~~~~~~ НИЖНИЙ ИНФОРМЕР ~~~~~~~~~~~~~~~~~~~~~~~ //
stock CreateBottomInformer(playerid)
{
	//полоска
	PTD_iNF_Polosa[playerid] = CreatePlayerTextDraw(playerid,203.000000,406.000000,"_");
	PlayerTextDrawUseBox(playerid,PTD_iNF_Polosa[playerid],1);
	PlayerTextDrawBoxColor(playerid,PTD_iNF_Polosa[playerid],0x00000066);
	PlayerTextDrawTextSize(playerid,PTD_iNF_Polosa[playerid],445.000000,0.000000);
	PlayerTextDrawAlignment(playerid,PTD_iNF_Polosa[playerid],0);
	PlayerTextDrawBackgroundColor(playerid,PTD_iNF_Polosa[playerid],0x000000ff);
	PlayerTextDrawFont(playerid,PTD_iNF_Polosa[playerid],1);
	PlayerTextDrawLetterSize(playerid,PTD_iNF_Polosa[playerid],1.000000,1.000000);
	PlayerTextDrawColor(playerid,PTD_iNF_Polosa[playerid],0xffffffff);
	PlayerTextDrawSetOutline(playerid,PTD_iNF_Polosa[playerid],1);
	PlayerTextDrawSetProportional(playerid,PTD_iNF_Polosa[playerid],1);
	PlayerTextDrawSetShadow(playerid,PTD_iNF_Polosa[playerid],1);


	//счет и информер
	PTD_iNF_Score[playerid] = CreatePlayerTextDraw(playerid,204.000000,404.000000,"IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
	PTD_iNF_Information[playerid] = CreatePlayerTextDraw(playerid,272.000000,356.000000,"Profession: ~n~~y~Shturmovik~n~~w~Rank: ~y~4~w~/~g~5~n~~w~Exp: ~y~75~w~/~g~75");
	PlayerTextDrawAlignment(playerid,PTD_iNF_Score[playerid],0);
	PlayerTextDrawAlignment(playerid,PTD_iNF_Information[playerid],0);
	PlayerTextDrawBackgroundColor(playerid,PTD_iNF_Score[playerid],0x000000ff);
	PlayerTextDrawBackgroundColor(playerid,PTD_iNF_Information[playerid],0x000000ff);
	PlayerTextDrawFont(playerid,PTD_iNF_Score[playerid],1);
	PlayerTextDrawLetterSize(playerid,PTD_iNF_Score[playerid],0.200001,1.300000);
	PlayerTextDrawFont(playerid,PTD_iNF_Information[playerid],1);
	PlayerTextDrawLetterSize(playerid,PTD_iNF_Information[playerid],0.499999,1.300000);
	PlayerTextDrawColor(playerid,PTD_iNF_Score[playerid],0x00ffffff);
	PlayerTextDrawColor(playerid,PTD_iNF_Information[playerid],0xffffffff);
	PlayerTextDrawSetOutline(playerid,PTD_iNF_Score[playerid],1);
	PlayerTextDrawSetOutline(playerid,PTD_iNF_Information[playerid],1);
	PlayerTextDrawSetProportional(playerid,PTD_iNF_Score[playerid],1);
	PlayerTextDrawSetProportional(playerid,PTD_iNF_Information[playerid],1);
	PlayerTextDrawSetShadow(playerid,PTD_iNF_Score[playerid],1);
	PlayerTextDrawSetShadow(playerid,PTD_iNF_Information[playerid],1);



	HideBottomInformer(playerid);
	return 1;
}

stock DestroyBottomInformer(playerid)
{
	PlayerTextDrawDestroy(playerid,PTD_iNF_Polosa[playerid]);
	PlayerTextDrawDestroy(playerid,PTD_iNF_Score[playerid]);
	PlayerTextDrawDestroy(playerid,PTD_iNF_Information[playerid]);
	return 1;
}

stock ShowBottomInformer(playerid)
{
	PlayerTextDrawShow(playerid,PTD_iNF_Polosa[playerid]);
	PlayerTextDrawShow(playerid,PTD_iNF_Score[playerid]);
	PlayerTextDrawShow(playerid,PTD_iNF_Information[playerid]);
	return 1;
}

stock HideBottomInformer(playerid)
{
	PlayerTextDrawHide(playerid,PTD_iNF_Polosa[playerid]);
	PlayerTextDrawHide(playerid,PTD_iNF_Score[playerid]);
	PlayerTextDrawHide(playerid,PTD_iNF_Information[playerid]);
	return 1;
}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~