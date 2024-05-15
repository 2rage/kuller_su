/*
	 =========================================================
     || Servername: KulleR.su | Zombie Server               ||
     || Gamemodename: KulleR.su | Zombie v. 021             ||
     || Created by: 2rage                                   ||
     =========================================================
     
     |---------------------------------------------------------|
     | 2rage. Начало разработки первой версии: 27 мая 2010 года|
     | Конец разработки, релиз первой версии: 22 Июня 2012 года|
	 |---------------------------------------------------------|
	 
	 *^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*
	 * 2rage. Начало разработки версии 0.2: 25 июня 2012 года*
	 * Конец разработки, релиз 0.2 версии: 22 мая 2013 года  *
	 *^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*

	 
	 /////////////////////////////////////////////////////////

	 Версия 0.21

	 - Беспинговая система - завершено
	 - Фикс багов  - завершено
	 - Откат заражения
	 - Невидимка админа
	 - Игнор админа античитом
	 
	 /////////////////////////////////////////////////////////

	 02.06.2013

	 Фикс выдачи оружия при повышении ранг человека
	 Фикс полоски опыта
	 Добавлен дефис в допустимый емайл

*/

#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS 100//максимум игроков на сервере, можно изменить на любое
#include <srow/colors2>//цвета в hex
//#include <srow/streamer>//стример объектов
#include <srow/mxINI>//файловая система
#include <srow/mxdate>//функция преобразования секунд юникса в дату
#include <srow/regex>//плагин регулярных выражений
//#include <srow/srow_objects>//мапы
#include <srow/srow_logs>//логи
//команды
#define ADMIN 2
#define HUMAN 1
#define ZOMBIE 0

//Имя мода
#define GM_NAME "KulleR.su | Zombie v.021f"

//ПРОФЕССИИ ЗОМБИ
#define ZOMBIE_PROF_TANK 0
#define ZOMBIE_PROF_JOKEY 1
#define ZOMBIE_PROF_VEDMA 2
#define ZOMBIE_PROF_BUMER 3

//ПРОФЕССИИ ЛЮДЕЙ
#define HUMAN_PROF_SHTURMOVIK 0
#define HUMAN_PROF_MEDIK 1
#define HUMAN_PROF_SNIPER 2
#define HUMAN_PROF_DEFENDER 3
#define HUMAN_PROF_CREATER 4


#include <srow/srow_textdraws>//текстдравы
#include <srow/srow_names>//имена рангов

// Обработка событий
#define CALLING_ACCOUNT_NOT_FOUND 0
#define CALLING_ACCOUNT_ONLINE 1
#define CALLING_ACCOUNT_OFFLINE 2

//проверка на правильный текст (защита от краша диалогов)
#define IsValidText(%1) \
    regex_match(%1, "[ а-яА-Яa-zA-Z0-9_ё=,!\\.\\?\\-\\+\\(\\)]+")

//проверка на правильный емайл
#define IsValidEmail(%1) \
    regex_match(%1, "[a-zA-Z0-9_\\.\\-]+@([a-zA-Z0-9\\-]+\\.)+[a-zA-Z]{2,4}")


#include <srow/mailer_bladock> // почтовик
//#define MAILER_URL "brics.16mb.com/mailer.php"//адресс пхп файла отвечающего за отправку почты

//#include <srow/mailer>//почтовик
#define MAIL_GENERAL "kuller-su@mail.ru"//почта на которую будут отправляться сообщения kuller-su@mail.ru
#define MAIL_PASSWORD "b100b7273"
#define MAIL_LOGIN "s.row.mail@yandex.ru"
#define MAIL_HOST "smtp.yandex.ru"
#define MAIL_SENDERNAME "S-ROW"


//имена пушек
stock WeaponNames[][20] = {{"Unarmed"},{"Brass Knuckles"},{"Golf Club"},{"Night Stick"},{"Knife"},{"Bat"},{"Shovel"},{"Pool Cue"},{"Katana"},{"Chainsaw"},{"Dildo"},{"Vibrator1"},{"Vibrator2"},{"Vibrator3"},{"Flowers"},{"Cane"},{"Grenade"},{"Tear Gas"},{"Molotov"},{" "},{"N/A"},{" "},{"Pistol"},
{"Silencer"},{"Deagle"},{"Shotgun"},{"Sawnoff"},{"Spas12"},{"Mac-10"},{"Mp5"},{"AK-47"},{"M4"},{"Tec-9"},{"Rifle"},{"Sniper"},{"RPG"},{"HeatSeeker"},{"Flamethrower"},{"Minigun"},{"Satchel"},{"Detonator"},{"Spraycan"},{"Extinguisher"},{"Camera"},{"Nightvision"},{"Infrared"},{"Parachute"},{" "},{" "},{"Vehicle Collision"},{"HeliKill"},{"Explosion"},{" "},{" "},{"Long Fall"}};


//Координаты бассейнов, озер и прочего и их высота
new Float:PoolsAndLakes[][5] ={//бассейны и озера (АНТИФЛАЙ) Последняя корда - высота
{-2359.918, -2518.289, -206.766, -301.4451, 39.0},//озеро у шаров повыше
{-2641.895, -2765.5, -388.2343, -522.3632, 7.0},  //озеро у шаров пониже
{-338.6584, -852.4849, -1821.749, -2148.729, 7.0},//озеро стрит
{2037.474, 1911.98, -1164.708, -1239.715,20.0},//глен парк
{1311.132, 1204.652, -2352.978, -2427.985,12.0},//озеро у аэролс
{1345.357, 1254.089, -754.1426, -856.7839,88.0},//мээд ддог бассейн
{1144.432, 1039.331, -595.5717, -712.3504,114.0},//буржуй дом лс
{352.8172, 177.8868, -1137.074, -1298.931,79.0},//буржуй дома 2шт лс
{2630.327, 2520.991, 2420.93, 2308.756,18.0},//бассейн лв 18 метров
{2575.659, 2438.989, 1616.373, 1504.199,11.0},  //бассейн лв2 11 метров
{2200.793, 2044.6, 1217.962, 1059.371,11.0},//замок у пирамиды
{2032.885, 1798.594, 1724.678, 1469.386,11.0},//пираты
{2134.411, 1997.741, 2010.915, 1817.512,11.0},//водопады
{-385.3699, -1436.379, 2849.402, 1880.138,44.0}//озеро дамба
};

#define NEED_EXP_UMNOZHITEL 200 // следранг = NEED_EXP_UMNOZHITEL * текущий ранг

#define INFECTION_RESET_TIME 30 // раз в сколько секунд зомби могут использовать заражение
new Player_ZombieInfectTime[MAX_PLAYERS];

//спектатор админа
new gSpectateID[MAX_PLAYERS] = -1;

forward DisableGSpectate(playerid);
public DisableGSpectate(playerid)
{
    gSpectateID[playerid] = -1;
	return 1;
}

#define MAP_CHANGE_DATA false // флаг можно ли изменять данные карт из игры ( спавн, маркер ). true - разрешено, иначе - запрет
new S[MAX_PLAYERS];
//Антифлуд
#define FloodTime 2 //Секунды флуда в чат
#define FloodTimeCmd 1 //Секунды флуда командами
#define FloodTimeMail 60//секунды флуда на мыло

//время заморозки при спавне в сек (защита от проваливания)
#define SPAWN_PROTECT 1

//лимиты
//#define MAX_CLASS 5//максимум классов

#define MAX_H_CLASS 5//Максимум классов у людей
#define MAX_Z_CLASS 4//Максимум классов у зомби

#define MAX_MAPS 36//максимум поддерживаемых арен
#define MAX_PATH_STR_ACCPATH 50//длинна пути к аккаунту
#define SHOP_GUNS_DIALOG_LINE_SIZE 90//размер линии в диалоге с покупкой оружиея
#define MAX_EMAIL_SIZE 64//максимальна длинна почты при регистрации

//макроссы
//#define GPW GivePlayerWeapon

//цвета
#define HUMAN_COLOR 0x0000FFFF
#define HUMAN_COLOR_I 0x0000FF00//цвет человека снайпера в невидимости
//#define ADMIN_COLOR COLOR_YELLOW
#define ADMIN_COLOR 0xFFFF0000
#define ZOMBIE_COLOR 0x008000FF

//файлы и пути к папкам
#define FORBIDDEN_WEAPONS_FILE "zombie/BadGun.cfg"
#define ACCOUNTS_FOLDER "zombie/accounts"
#define MAPS_FOLDER "zombie/maps"
#define TITULS_FILE "zombie/tituls.ini"

//автосообщения
#define AUTOMESSAGE_TIME 90//время в сек. между автосообщениями
new messageid = 0;
new time_to_send_automessage = AUTOMESSAGE_TIME;

//----[Цвета в str формате]----//
#define COL_EASY           "{FFF1AF}"
#define COL_WHITE          "{FFFFFF}"
#define COL_BLACK          "{0E0101}"
#define COL_GREY           "{C3C3C3}"
#define COL_GREEN          "{6EF83C}"
#define COL_RED            "{F81414}"
#define COL_YELLOW         "{F3FF02}"
#define COL_ORANGE         "{FFAF00}"
#define COL_LIME           "{B7FF00}"
#define COL_CYAN           "{00FFEE}"
#define COL_LIGHTBLUE      "{00C0FF}"
#define COL_BLUE           "{0049FF}"
#define COL_MAGENTA        "{F300FF}"
#define COL_VIOLET         "{B700FF}"
#define COL_PINK           "{FF00EA}"
#define COL_MARONE         "{A90202}"
#define COL_CMD            "{B8FF02}"
#define COL_PARAM          "{3FCD02}"
#define COL_SERVER         "{AFE7FF}"
#define COL_VALUE          "{A3E4FF}"
#define COL_RULE           "{F9E8B7}"
#define COL_RULE2          "{FBDF89}"
#define COL_RWHITE         "{FFFFFF}"
#define COL_LGREEN         "{C9FFAB}"
#define COL_LRED           "{FFA1A1}"
#define COL_LRED2          "{C77D87}"


//дефайны как параметры
#define NONE 0
#define RUB  0
#define ZM   1

//регa/автоrization
#define MAX_PASS_LEGHT 16
#define MIN_PASS_LEGHT 4

//диалоги
#define LOGIN_DIALOG 0                      //Диалог логина
#define REGISTER_DIALOG 1                   //Диалог реги
#define AGE_DIALOG 2                        //Диалог ввода возраста
#define DIALOG_HUMANPROFS_LIST 3            //Диалог с профессиями людей
#define ABOUT_HUMAN_DIALOG 4                //Диалог с описанием выбранной профессии людей
#define DIALOG_ZOMBIEPROFS_LIST 5           //Диалог с профессиями зомби
#define ABOUT_ZOMBIE_DIALOG 6               //Диалог с описанием выбранной профессии зомби
#define ACCEPT_REGISTER_DIALOG 7            //Диалог с подтверждением регистрации
#define MENU_DIALOG 8                       //Диалог с меню
#define MENU_RULES_D 9                      //Диалог с правилами
#define MENU_RULES_D2 10                    //Диалог с правилами страница 2
#define MENU_STAT_D 11                      //Диалог со статистикой
#define MENU_ADMINS_D 12                    //Диалог с функцииями с администрацией
#define MENU_ADMINS_D_LIST 13               //Диалог со списком админов онлайн
#define MENU_ADMINS_D_REPORT_INPUT_ID 14    //Диалог с жалобой на игрока и вводом ид
#define MENU_ADMINS_D_REPORT_INPUT_REASON 15//Диалог с жалобой на игрока и вводом причины
#define MENU_ADMINS_D_REPORT_TO_MAIL 16     //Диалог жалобы на почту
#define MENU_HELP_D 17                      //Диалог с помощью
#define MENU_MSGBUFFER_D 18                 //Диалог с помощью: описание смысла игры
#define MENU_TITULS_D 19                    //Диалог с титулами сервера
#define MENU_KICK_VOTE_DIALOG_VOTE 20       //Диалог с голосованием
#define MENU_KICK_VOTE_CHOSE_ID 21          //Диалог с голосованием: ввод ид
#define SHOP_DIALOG 23                      //Диалог с магазином
#define SHOP_PROTECT_D 24                   //Диалог с беретами
#define SHOP_CHOSEN_SROK_D 25               //Диалог ввода срока берета
#define SHOP_ACCEPT_BUY_CAP 26              //Диалог подтверждения замены берета (елси уже есть берет)
#define SHOP_ACCEPT_BUY_CAP_TRUE 27         //Диалог подтверждения покупки берета
#define SHOP_CAP_BUYED 28                   //Диалог с информацией о купленном берета
#define MENU_ADMINS_D_REPORT_AB_BUG 29      //Диалог с сообщением администрации о баге
#define SHOP_GUNS_D 30                      //выбор слота покупаемого оружия (автоматы дробовики и т.д)
#define SHOP_VIP_D 31                       //выбор срока в покупке випа
#define SHOP_VIP_ACCEPT_D 32                //Диалог с подтверждением покупки вип
#define SHOP_VIP_BUYED_D 33                 //информация о купленном випе
#define SHOP_UPG_RANK 34                    //покупка следующего ранга за рубли
#define CHOSEN_GUN_REPLACE_D 35             //подтверждение покупки оружия
#define CHOSEN_GUN_ACCEPT_D 36              //подтверждение покупки пушки
#define SHOP_GUN_DIALOG_PISTOLS 37          //список пистолетов
#define SHOP_BUY_GUN_VALUTE_CHOSE_D 38      //выбор валюты в покупке оружия
#define CHOSEN_GUN_ACCEPT_D_22 39           //подтверждение покупки оружия
#define SHOP_GUN_AVTOMATS_D 40      		//список автоматов
#define SHOP_GUN_SHOTGUNS_D 41  		 	//список дробов
#define SHOP_GUN_KARABINS_D 42  			//список штурмовых винтовок
#define MENU_ADMINS_D_SUGGEST_ADMIN 43    	//Диалог с вопросом к администрации
#define DIALOG_YOU_NEEDED_NEW_PROF_YES 44  	//информация о купленной профессии (купленной через список моих профессий)
#define DIALOG_YOU_NEEDED_NEW_PROF 45  	 	//подтверждение покупки профессии
#define MENU_MYPROFS_CHOSE_CLASS 46   		//покупка профессии: выбор самой профессии
#define MENU_MYPROFS_CHOSE_TEAM 47   		//покупка профессии: выбор команды
#define SHOP_BUY_PROFESSION_BUYED_D 48  	//информация о купленной профессии (купленной через магазин)
#define SHOP_BUY_PROFESSION_CHOSE_PROF 49   //покупка профессии: выбор самой профессии (магаз)
#define SHOP_BUY_PROFESSION_CHOSE_TEAM 50  	//покупка профессии: выбор команды (магаз)
#define DIALOG_ENTERMAIL 51             	//Диалог с вводом мыла
#define DIALOG_ENTER_FRIEND_NAME 52    	 	//Диалог с вводом имени друга
#define SHOP_BUY_HEALTH 53                  //Диалог с покупкой хп: выбор команды
#define SHOP_BUY_HEALTH_ENTER_KOLVO 54      //Диалог с покупкой хп: ввод количества
#define SHOP_BUY_HEALTH_CHOSE_VALUTE 55     //Диалог с покупкой хп: выбор валюты
#define SHOP_BUY_HEALTH_ACCEPT 56           //Диалог с покупкой хп: подтверждение
#define SHOP_BUY_HEALTH_INFO 57             //Диалог с покупкой хп: информация о покупке


//Дополнительное хп
#define SHOP_HEALTH_PRICE_ZM 1000
#define SHOP_HEALTH_PRICE_RUB 1

#define PLAYER_MAX_BUYED_HEALTH_FOR_ZOMBIE 300
#define PLAYER_MAX_BUYED_HEALTH_FOR_HUMAN 300

//Причины завершения арены
#define END_REASON_ZOMBIE_WIN 0// зомби победили
#define END_REASON_LILTE_PLAYER 1//мало игроков
#define END_REASON_ADMIN_STOP 2//админ остановил
#define END_REASON_TIME_LEFT 3//время вышло

//Параметры
#define JOKEY_BIG_JUMP_RESET 1//перезарядка прыжка жокея
#define JOKEY_BIG_JUMP_HIGHT 3.0//прыжок жокея и ведьмы в высоту
//#define ZM_FOR_KILL_HUMAN 10//деньги за убийство человека
//#define ZM_FOR_KILL_ZOMBIE 20//деньги за убийство зомби

#define KRIK_RADIUS 7.0//радиус крика ведьмы в метрах
#define DEFENDER_BANG_RADIUS 6.0//радиус прямого поражения от взрыва защитника
#define CURE_HEAL_RADIUS 4.0//радиус лечения медика
#define INFECT_RADIUS 2.5//радиус обычного заражения у зомби
#define INFECTED_PROCENT 20//процент игроков, которые станут зомби при заражении
#define ROUND_TIME 3015//время раунда (250)
#define INFECTION_TIME 15//время до инфекции
#define MAX_AFK_TIME_IN_HUMANT 20//макс. время в афк до автокилла
#define ZM_FOR_SUVRIVOR 100//награда выжившим
#define COUNT_FOR_NEXTARENA 20//время до начала следу
#define RUSH_DIST 8.0//радиус поражения цели в результате РАША жокея
#define RAMPAGE_TANG_BANG_DIST 3.0//радиус создания взрыва при агрессии танка
#define BOMB_BAND_DIST 3.0 // РАДИУС создания 4 взрывов бомбы
#define TIME_TO_ACTIVE_RAMP 400//время, выделенное на выполнение анимации танка (время между нажатием N и взрывом в мс)
#define RAMPAGE_TANG_BANG_TYPE 0//тип взрыва при агрессии танка
#define BUMER_BW_RAD 8.0//радиус поражения цели в результате притягивания бумером
#define HUMAN_SKILL_UPD 15// данное число * ранг професии = потолок очков до след ранга
#define ADMIN_SKIN 299//скин админа при его работе
#define CHECK_BUYED_TIME 30//время в сек до вызова проверки купленных вещей у всех игроков
#define INFO_WIN_SHOW_TIME 4*1000 //МС показа текстдрава о победе кого-либо
#define UNIX_TIME_CORRECT 3600*13 //перевод юникс времени на московское 13
#define HUMAN_PROFESSIONS_PRICE 25//цена людской профессии
#define ZOMBIE_PROFESSIONS_PRICE 25//цена зомби профессии
#define COPY_SKIN_RAD 5.0//Радиус копирования скина зомби у снайпера
#define FIX_ALL_TITUL_TIME 20//Каждые 20 сек проверка титулов

//Инфекция
#define INFECT_TEXT_RAD 20.0//видимость текста
#define INFECT_TEXT_HIGHT 0.8//высота текста на игрока
#define INFECT_TEXT_STR "Инфицирован\nУровень: %s"//сам текст

//Стандартные сообщений
#define MESSAGE_WAIT_SPAWN ""COL_EASY"Для совершения данного действия вы должны быть заспавнены"
#define MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC ""COL_EASY"Вы заглушены и не можете пользоваться данной функцией"
#define SERVER_LOGO GM_NAME//"*** Saints Row v. 0.2: ***"
//сообщения дисконнекта
#define MESSAGE_REASON_TIMEOUT "Потеря связи"
#define MESSAGE_REASON_DISCONNECT "Выход"

#define MESSAGE_EXIT_INFO ""COL_LIME"%s "COL_CYAN"покинул сервер (%s)"
#define MESSAGE_EXIT_INFO_ADLOG "%s покинул сервер (%s)"

//сообщения при подключении
#define MESSAGE_PLAYER_CONNECTED ""COL_LIME"%s "COL_ORANGE"подключился к серверу"
#define MESSAGE_PLAYER_CONNECTED_LOG "%s подключился к серверу [%s]"

//приветствие на сервере
#define MESSAGE_WELCOME_SELECTING "======================================================"

//Уровень заражения
#define RED_MONITOR 1//просто экран
#define ONE_HP 2//экран + снятие одного хп
#define TWO_HP 3//экран + снятие 2 хп
#define THREE_HP 4//экран + снятие 3 хп

//Шапки
#define RED_CAP 1//красный берет
#define LIGHTBLUE_CAP 2//голубой берет
#define BLUE_CAP 3//синяя ьбандана

//Уровни Урона зомби
#define DAMAGE_LEVEL_1 20
#define DAMAGE_LEVEL_2 50
#define DAMAGE_LEVEL_3 80
#define PRIDATOK_RANDOM 20//к врожденному урону зомби мы прибавим число от 0 до этого параметра

new test_enabled[MAX_PLAYERS];

new MaxID = 0; // Максимальный ид на сервере

//Лобби
new Home_Interior = 3;//интерьер домика
new Float: Home_Pos[4];//позиция домика
new Home_VW = 1;//виртульный мир домика

stock SetDefaulthHome()//задать лобби по стандарту (СИ-ДЖЕЙ ДОМ)
{
    Home_Interior = 18;
    Home_Pos[0] = 1722.0225;
    Home_Pos[1] = -1647.4247;
    Home_Pos[2] = 20.2276;
    Home_Pos[3] = 178.2884;
    Home_VW = 1;
}
new Player_CurrentTeam[MAX_PLAYERS];
#define TIME_TO_HIDE_DROP_ZM_INFORMER 2 // через сколько секунд скрывать DropZmInformer
new TimeToHideDropZmInformer[MAX_PLAYERS];

//Титулы
#define MAX_TITULS 7//сколько всего титулов возможно
#define TIT_NONE 0
#define TIT_LORD 1
#define TIT_PRESIDENT 2
#define TIT_RAMBO 3
#define TIT_KILLER 4
#define TIT_PROSVET 5
#define TIT_FRIENDLY 6
new Tit_Value[MAX_TITULS];//значение титула
new Tit_Name[MAX_TITULS][128];//имя владельца (спасибо strtok за требовательный объем выделенного места)

///
new bool: Call_Connected[MAX_PLAYERS] = false; // флаг вызова коннекта
new bool: PlayerNoAFK[MAX_PLAYERS] = true; // флаг того, что игрок находится а АФК и к игре не допускается

#define SET_POS_PROTECT_TIME 2 // защитное время с перемещения на координаты
new Player_SetPosProtectTime[MAX_PLAYERS];

//грузить все титулы из файла
stock LoadTituls()
{
	  new IF,buffer[MAX_PLAYER_NAME+60];
	  if(fexist(TITULS_FILE))IF = ini_openFile(TITULS_FILE);
	  else return 1;
	  for(new i = 1,idx; i < MAX_TITULS; i++)
	  {
			  idx = 0;
			  if(ini_getString(IF,GetTitKeyName(i),buffer) == INI_KEY_NOT_FOUND)
			  {
                  Tit_Name[i] = "Свободный титул";
                  Tit_Value[i] = 0;
			  }
			  Tit_Name[i] = strtokForCmd(buffer, idx,',');
			  if(strlen(Tit_Name[i]) < 1)Tit_Name[i] = "Свободный титул";
			  Tit_Value[i] = strval(strtokForCmd(buffer, idx,','));
	  }
	  ini_closeFile(IF);
	  print("   Титулы загружены");
	  return 1;
}

//узнать ключ в бд у титула
stock GetTitKeyName(titulid)
{
	 new str[32];
	 switch(titulid)
     {
	        case TIT_LORD:str = "Lord";
			case TIT_PRESIDENT:str = "President";
			case TIT_RAMBO:str = "Rambo";
			case TIT_KILLER:str = "Killer";
			case TIT_PROSVET:str = "Prosvet";
			case TIT_FRIENDLY:str = "Friendly";
	 }
	 return str;
}
//узнать имя титула
stock GetTitulName(titulid)
{
	 new str[32];
	 switch(titulid)
     {
	        case TIT_LORD:str = "Лорд";
			case TIT_PRESIDENT:str = "Президент";
			case TIT_RAMBO:str = "Рэмбо";
			case TIT_KILLER:str = "Киллер";
			case TIT_PROSVET:str = "Просветленный";
			case TIT_FRIENDLY:str = "Дружелюбный";
	 }
	 return str;
}
//переписать титул
stock ReWriteTitul(titulid)
{
	   new IF,str[MAX_PLAYER_NAME+60];
	   format(str,sizeof(str),"%s,%d",Tit_Name[titulid],Tit_Value[titulid]);
	   if(fexist(TITULS_FILE))IF = ini_openFile(TITULS_FILE);
	   else IF = ini_createFile(TITULS_FILE);
	   ini_setString(IF,GetTitKeyName(titulid),str);
	   ini_closeFile(IF);
}
//Игровой процесс
new bool:Game_Started = false;//проверка на старт арены
new Infection_Time;//время до начала инфекции в сек
new bool: MarkerActiv = false;//проверка на открытие убежищза
new Humans;//количество людей на сервер
new Zombies;//количество зомби на сервере
new CountForNextArena = 0;//время от конца старой до старта новой арены
new CountForEndArena;//время до конца арены
new survaivors;//цисло выживших
new NextArenaId; //отвечает за следубщую арену
new TimeToCheckBuyed;//время до проверки покупок игроков
new TimeToFixTituls;
new Player_Special_Voteban[MAX_PLAYERS];
//Длительное хранение: Диалоги при реге - выбор профессий
new HumanProf_D[48*MAX_H_CLASS];
new ZombieProf_D[48*MAX_Z_CLASS];
new bool: isKicked[MAX_PLAYERS];
//Голосование
#define PROCENT_FOR_KICK 60//Процент будущих проголосовавших за то, чтобы был кик
#define VOTETIME 30 //Секунд до окончания голосования
#define MINHOURS_FORVOTE 10//минимальные часы для голосования

new VotePlayerID = -1;//Игрок, чья судьба решается
new VoteTime;//время голосования
new VoteZa;//сколько проголосовало
new VoteNeed;//сколько нужно голосов для кика
new bool:Player_Voted[MAX_PLAYERS];//проголосовал ли

//защита от множества голосований: сброс голоса при дисконнекте проголосовавшего
stock NullDisconnectIDVote(playerid)
{
	  if(VotePlayerID == -1)return 1;//голосование и не начиналось
	  if(!Player_Voted[playerid])return 1;//игрок не голосовал
	  VoteZa --;
	  SetVoteCounter(VoteZa,VoteNeed);
	  return 1;
}

//сброс настроек голосования
stock ResetVoteParams()
{
     VotePlayerID = -1;//Игрок, чья судьба решается
     VoteTime = 0;
     VoteNeed = 0;
     VoteZa = 0;
     HideVoteTexts();
     for(new i, s_b = MaxID; i <= s_b; i++)
     {
           Player_Voted[i] = false;
     }
     return 1;
}
//игрок голосует
stock PlayerVoted(playerid)
{
     VoteZa++;
     Player_Voted[playerid] = true;
     new str[100];
     format(str,sizeof(str),""COL_RULE"Игрок %s проголосовал за кик игрока %s",GetName(playerid),GetName(VotePlayerID));
	 SendClientMessageToAll(-1,str);
	 SetVoteCounter(VoteZa,VoteNeed);
     FixVote();
     return 1;
}
//игрок открывает голосование
stock OpenVote(playerid,kickid)
{
      ResetVoteParams();
      VotePlayerID = kickid;
      VoteTime = VOTETIME+1;
      VoteZa = 1;
      Player_Voted[playerid] = true;
      new peoples = Humans+Zombies;
      VoteNeed = floatround((peoples/100.0)*PROCENT_FOR_KICK);
      new str[150];
      format(str,sizeof(str),""COL_RULE"Игрок %s открыл голосование за кик игрока %s. Голосов для удаления игрока: %d. Проголосовать можно через меню",GetName(playerid),GetName(kickid),VoteNeed);
      SendClientMessageToAll(-1,str);
      SetVoteCounter(VoteZa,VoteNeed);
      TextDrawSetString(_VoteName_,GetName(VotePlayerID));
      ShowVoteTexts();
      return 1;
}
//проверка голосования
stock FixVote()
{
	   new str[100];
	   if(VotePlayerID == -1)return 1;
	   if(VoteZa >= VoteNeed)
	   {
              format(str,sizeof(str),""COL_RULE"Игрок %s был кикнут в результате голосования. Проголосовало %d игроков из нужных %d",GetName(VotePlayerID),VoteZa,VoteNeed);
              SendClientMessageToAll(-1,str);
			  new val = VotePlayerID;
			  ResetVoteParams();
			  Player_Special_Voteban[val] = (gettime() + 180);
			  t_Kick(val);

	   }
	   return 1;

}

//окончание голосования
stock CancelVote()
{
	   if(VotePlayerID == -1)return 1;
	   new str[100];
	   format(str,sizeof(str),""COL_RULE"Голосование за кик %s закончено. Результат: %d из нужных %d голосов",GetName(VotePlayerID),VoteZa,VoteNeed);
	   SendClientMessageToAll(-1,str);
	   ResetVoteParams();
	   return 1;
}

// 3DTEXT Информер о професии и ранге
#define PrAnRaInf_TEXT_RAD 20.0 // радиус показа информера професии и ранга
#define PrAnRaInf_TEXT_HIGHT 1.4 // высота этого информера
#define PrAnRaInf_TEXT_STR "%s\nРанг: %d"

new Text3D: Player_ProfAndRankInf[MAX_PLAYERS];



// АНТИЧИТ
//Античит
// Скрывание диалога
#define HideDialog(%1)    ShowPlayerDialog(%1, -2, 0, "", "", "", "")

#define AC_MAX_REASONS 13 // Максимум причин

#define AC_JETPACK_HACK_ 0 // анти-читоджетпак
#define AC_FAKESKIN_HACK_ 1 // Читерский скин        + [Откладка]
#define AC_ARMOUR_HACK_ 2 // Чит на бронь
#define AC_DIALOG_HACK_ 3 // Чит на диалог
#define AC_GUN_HACK_ 4 // чит на оружие
#define AC_AMMO_GUN_HACK_ 5 // Чит на патроны + [Откладка]
#define AC_GUN_WP_ID_HACK_ 6 // Чит на замену оружия в слоте + [Откладка]
#define AC_FLYHACK_ 7 // анти-флайхак
#define AC_TP_HACK_ 8 // античит на телепорт
#define AC_INTERIOR_HACK 9 // Анти-телепорт в интерьеры
#define AC_CJ_RUN 10 // CJ Бег
#define AC_FALL_STANDING 11 //Зависание в воздухе
#define AC_FAST_RUN 12 // Быстрый бег

#define MAX_FAST_RUN_SPEED 15 // Скорость игрока для того, чтобы считать игрока читером
#define MAX_FALL_STANDING_TIME 2 // Сколько секунд можно висеть в воздухе

#define MAX_FORBIDDEN_WEAPONS 	(48)
#define MAX_WEAPONS 			(47)

#define DOBAVKA_ANI_FLYHACK 0.5 // на сколько метров нужно взлететь повыше чтобы быть читером
#define OTBAVKA_ANI_FLYSTAND 8// на сколько метров нужно не упасть за MAX_FALL_STANDING_TIME(2) секунды чтобы быть читером

#define FLY_METERS 2.5 //на сколько метров над водой кик

// Реакция античита
#define AC_ACTION_BAN 0
#define AC_ACTION_KICK 1
#define AC_ACTION_KILL 2
#define AC_ACTION_REPORT 3

new Float: FirstFallPos[MAX_PLAYERS][3]; // начальная позиция падения
new bool: FallFlag[MAX_PLAYERS]; // флаг падения
new Float: FallZ[MAX_PLAYERS]; // место хранения высоты падения

#define TP_RADIUS 5//радиус телепорта - 5 метров
#define SPAWN_PROTECT_TIME 2//защитное время в сек после спавна
new Float: AC_MyOldPos[MAX_PLAYERS][3];
new AC_SpawnProtect[MAX_PLAYERS] = 0;
new AC_TrueInterior[MAX_PLAYERS] = 0;


// Пушки
#define AC_MAX_SLOTS 13
new MyWeaponID[MAX_PLAYERS][AC_MAX_SLOTS];
new MyAmmo[MAX_PLAYERS][AC_MAX_SLOTS];

// Классы
#define AC_MAXIMUM_CLASS 1 // Максимум классов он у нас 1
new AC_ClassSkin[AC_MAXIMUM_CLASS];
new AC_CreatedClass = 0;
//

static ForbiddenWeaponsCount;
new ForbiddenWeapons [MAX_FORBIDDEN_WEAPONS char];
new bool: isDebug[MAX_PLAYERS][AC_MAX_REASONS];

new FallTime[MAX_PLAYERS];

enum AC_DATA{
    DialogID,
    RealSkinID,
}
new ACInfo[MAX_PLAYERS][AC_DATA];

// Отправить игрока в настоящий интерьер
stock AC_SetPlayerInterior(playerid, interiorid)
{
    AC_TrueInterior[playerid] = interiorid;
    SetPlayerInterior(playerid, interiorid);
    isDebug[playerid][AC_INTERIOR_HACK] = false;
	return 1;
}
#define SetPlayerInterior AC_SetPlayerInterior

stock isFall(playerid,oneanim=-1)
{
    new idx = GetPlayerAnimationIndex(playerid);
	if(oneanim == -1)
	{
	    if( idx == 1130 || idx == 1132 || idx == 1133) // FALL_FALL
	    {
			return true;
	    }
    }
    else
    {
        if( idx == oneanim)
		{
		    return true;
		}
    }
	return false;
}

// Античит на телепорт и на флайхак
stock AC_SetPlayerPos(playerid,Float:Px,Float:Py, Float:Pz)
{
    AC_TrueInterior[playerid] = 0;
    Player_SetPosProtectTime[playerid] = SET_POS_PROTECT_TIME;
    FallZ[playerid] = Pz;
    isDebug[playerid][AC_TP_HACK_] = false;
	AC_MyOldPos[playerid][0] = Px;
	AC_MyOldPos[playerid][1] = Py;
	AC_MyOldPos[playerid][2] = Pz;
	
	FirstFallPos[playerid][0] = Px;
	FirstFallPos[playerid][1] = Py;
	FirstFallPos[playerid][2] = Pz;
	
	FallTime[playerid] = 0;
	
	SetPlayerPos(playerid, Px,Py,Pz);
	return 1;
}
//#define SetPlayerPos AC_SetPlayerPos // макрос

stock NullACBuffer(playerid){
    AC_SpawnProtect[playerid] = 0;
    FallFlag[playerid] = false;
    FallZ[playerid] = 0;
    Player_SetPosProtectTime[playerid] = 0;
    ACInfo[playerid][DialogID] = -1;
    ACInfo[playerid][RealSkinID] = -1;
    for( new i; i < AC_MAX_SLOTS; i ++)
    {
             MyWeaponID[playerid][i] = 0;
             MyAmmo[playerid][i] = 0;
    }
    for( new i; i < AC_MAX_REASONS; i ++){
             isDebug[playerid][i] = false;
	}
    return 1;
}



//Дать игроку настоящую пушку
stock AC_GivePlayerWeapon(playerid,weaponid,ammo){

	 isDebug[playerid][AC_GUN_WP_ID_HACK_] = false; // вывести систему из откладки
     GivePlayerWeapon(playerid,weaponid,ammo);
	 new slotid = GetWeaponSlot(weaponid);
     MyWeaponID[playerid][slotid] = weaponid;
     MyAmmo[playerid][slotid] += ammo;
	 return 1;
}

//Дать игроку настоящие патроны
stock AC_SetPlayerAmmo(playerid,weaponslot,ammo){
     MyAmmo[playerid][weaponslot] = ammo;
     if((weaponslot != 0) && (ammo == 0)){
           MyWeaponID[playerid][weaponslot] = 0;
     }
	 SetPlayerAmmo(playerid,weaponslot,ammo);
	 return 1;
}

//Обнулить текущее оружие и выдать то, которое по-настоящему должно быть
stock RegivePlayerGun(playerid){
	 ResetPlayerWeapons(playerid);
	 for(new i = 0; i < AC_MAX_SLOTS; i ++){
             GivePlayerWeapon(playerid,MyWeaponID[playerid][i],MyAmmo[playerid][i]);
	 }
	 return 1;
}

//По-настроящему забрать у игркоа все пушки
stock AC_ResetPlayerWeapons(playerid){
	 ResetPlayerWeapons(playerid);
	 for(new i; i < AC_MAX_SLOTS; i ++){
             MyWeaponID[playerid][i] = 0;
             MyAmmo[playerid][i] = 0;
	 }
     MyAmmo[playerid][0] = 1;//кулачек жи есть
	 return 1;
}
/*
stock AC_GivePlayerWeapon(playerid,weaponid,ammo)
{
     GivePlayerWeapon(playerid,weaponid,ammo);
	 new slotid = GetWeaponSlot(weaponid);
     MyWeaponID[playerid][slotid] = weaponid;
     MyAmmo[playerid][slotid] += ammo;
	 return 1;
}

stock AC_SetPlayerAmmo(playerid,weaponslot,ammo)
{
     MyAmmo[playerid][weaponslot] = ammo;
     if(weaponslot != 0)
     {
           MyWeaponID[playerid][weaponslot] = 0;
     }
	 SetPlayerAmmo(playerid,weaponslot,ammo);
	 return 1;
}

stock RegivePlayerGun(playerid)
{
	 ResetPlayerWeapons(playerid);
	 for(new i; i < AC_MAX_SLOTS; i ++)
	 {
             GivePlayerWeapon(playerid,MyWeaponID[playerid][i],MyAmmo[playerid][i]);
	 }
	 return 1;
}

stock AC_ResetPlayerWeapons(playerid)
{
	 ResetPlayerWeapons(playerid);
	 for(new i; i < AC_MAX_SLOTS; i ++)
	 {
             MyWeaponID[playerid][i] = 0;
             MyAmmo[playerid][i] = 0;
	 }
     MyAmmo[playerid][0] = 1;//кулачек жи есть
	 return 1;
}
*/

// Открыть настоящий диалог
stock AC_ShowPlayerDialog(playerid, dialogid, style, capiton[], info[],but1[],but2[]){
    ACInfo[playerid][DialogID] = dialogid;
    ShowPlayerDialog(playerid, dialogid, style, capiton, info,but1,but2);
	return 1;
}

// По-настоящему сменить игроку скин
stock AC_SetPlayerSkin(playerid, skinid){
	 SetPlayerSkin(playerid, skinid);
	 ACInfo[playerid][RealSkinID] = skinid;
	 ClearAnimations(playerid);
	 return 1;
}


//Установить настоящее SpawnInfo
stock AC_SetSpawnInfo(playerid,team,skin,Float:x,Float:y,Float:z,Float:rot,w1,a1,w2,a2,w3,a3)
{
     ACInfo[playerid][RealSkinID] = skin;
     SetSpawnInfo(playerid,team,skin,Float:x,Float:y,Float:z,Float:rot,w1,a1,w2,a2,w3,a3);
	 return 1;
}
#define SetSpawnInfo AC_SetSpawnInfo //Макросим

//Добавить настоящий класс игрока
stock AC_AddPlayerClass(modelid,Float: Spawn_x,Float: Spawn_y,Float: Spawn_z,Float: Z_Angle,weap1,ammo1,weap2,ammo2,weap3,ammo3){
     AC_ClassSkin[AC_CreatedClass] = modelid;
     AddPlayerClass(modelid,Float: Spawn_x,Float: Spawn_y,Float: Spawn_z,Float: Z_Angle,weap1,ammo1,weap2,ammo2,weap3,ammo3);
     AC_CreatedClass ++;
	 return 1;
}

forward OnAntiCheatUpdatePlayer(playerid, cheatID, argument);
forward OnPlayerUseJetPackHack(playerid);
forward OnPlayerUseFakeSkin(playerid, realdskin, fakeskin);
forward OnPlayerUseFlyHack( playerid, arg, dop[] );
forward OnPlayerUseArmourHack( playerid, Float: currentarmour );
forward OnPlayerUseDialogHack( playerid, dialogid);
forward OnPlayerUseWeaponHack( playerid, weaponid, ammo, realcheat);
forward OnPlayerUseWeaponAmmoHack( playerid, weaponid, ammo, realcheat);

#define GivePlayerWeapon AC_GivePlayerWeapon
#define GPW AC_GivePlayerWeapon

#define ResetPlayerWeapons AC_ResetPlayerWeapons
#define SetPlayerAmmo AC_SetPlayerAmmo

public OnAntiCheatUpdatePlayer(playerid, cheatID, argument)
{
	if( Player_CurrentTeam[playerid] == ADMIN ) return false;
	switch( cheatID )
	{
            case AC_JETPACK_HACK_://чито джетпак
            {
                     if(   GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK   )
                     {
						   CallLocalFunction("OnPlayerUseJetPackHack","i",playerid);
						   return true;
                     }
            }
            case AC_ARMOUR_HACK_:
            {
					 new Float: arma;
					 GetPlayerArmour(playerid, arma);
					 if( arma > 0)
					 {
                           CallLocalFunction("OnPlayerUseArmourHack","if",playerid, arma);
						   return true;
					 }
            }
            case AC_DIALOG_HACK_: // чит на диалог [Вызывается из OnDialogResponse]
			{
					// argument = dialogid
					if( argument != ACInfo[playerid][DialogID] )
					{
                            HideDialog(playerid);
							return true;
					}
			}
            case AC_FAKESKIN_HACK_:   // Читерский скин
			{
					 if( GetPlayerSkin(playerid) != ACInfo[playerid][RealSkinID] )
					 {
                            if( !isDebug[playerid][AC_FAKESKIN_HACK_] )   // Если не в режиме откладки
							{
									  // Переход в режим откладки [ Защита от ложных срабатываний ]
                                      isDebug[playerid][AC_FAKESKIN_HACK_] = true;
									  return false;
							}
                            CallLocalFunction("OnPlayerUseFakeSkin","iii",playerid, ACInfo[playerid][RealSkinID], GetPlayerSkin(playerid));
                            isDebug[playerid][AC_FAKESKIN_HACK_] = false; // Откладка отключена
                            return true;
					 }
			}
			case AC_TP_HACK_:
			{
					 if(isKicked[playerid])return 1;
					 if(gSpectateID[playerid] != -1)return 1;
					 // if(  GetPVarInt(playerid, "PlayerInAFK") > 1) return 1; потом
					 if(!IsPlayerInRangeOfPoint(playerid, TP_RADIUS, AC_MyOldPos[playerid][0],AC_MyOldPos[playerid][1],AC_MyOldPos[playerid][2]) && AC_SpawnProtect[playerid] == 0 && Player_SetPosProtectTime[playerid] == 0)
				     {

                              //if(!isDebug[playerid][AC_TP_HACK_]){
							 ///     isDebug[playerid][AC_TP_HACK_] = true;
							  //    return false;
						     // }
							  if( !isFall(playerid) )
							  {
							      if(  GetPVarInt(playerid, "PlayerInAFK") < 2)
							      {
							      	     CallLocalFunction("OnPlayerUseTpHack","ii",playerid, AC_ACTION_REPORT);
							      }
						      }
				     }
				     GetPlayerPos(playerid,AC_MyOldPos[playerid][0],AC_MyOldPos[playerid][1],AC_MyOldPos[playerid][2]);//запомнить текущую позицию игрока в античит
				     isDebug[playerid][AC_TP_HACK_] = false;
					 return true;
			}
			case AC_CJ_RUN:
			{
			    if( gSpectateID[playerid] != -1 ) return false;
			    if( GetPVarInt(playerid, "PlayerInAFK") != -2) return false;
			    new animlib[30], animname[30] ;
 				GetAnimationName(GetPlayerAnimationIndex(playerid), animlib, sizeof(animlib), animname, sizeof(animname));
				if(strcmp(animlib, "PED", true) == 0 && strcmp(animname, "RUN_PLAYER", true) == 0 && GetPlayerSkin(playerid) != 0)
 				{
 				        if(!isDebug[playerid][AC_CJ_RUN]){
							      isDebug[playerid][AC_CJ_RUN] = true;
							      return false;
			      		}
 				        CallLocalFunction("OnPlayerUseCjRun","ii",playerid, AC_ACTION_BAN);
						return true;
 				}
 				isDebug[playerid][AC_CJ_RUN] = false;
			    return false;
			}
			case AC_INTERIOR_HACK:
			{
				if( AC_SpawnProtect[playerid] == 0 ) return false;
			    if( AC_TrueInterior[playerid] != GetPlayerInterior(playerid) )
			    {
    					if(!isDebug[playerid][AC_INTERIOR_HACK]){
							      isDebug[playerid][AC_INTERIOR_HACK] = true;
							      return false;
			      		}
			      		CallLocalFunction("OnPlayerUseInteriorHack","ii",playerid, AC_ACTION_KICK);
						return true;
			    }
			    isDebug[playerid][AC_INTERIOR_HACK] = false;
				return false;
			}
			case AC_FALL_STANDING: //античит на стояние в небе
			{
			    if(GetPVarInt(playerid,"ProtectTime") != 0)return false; // легальная заморозка
			    if( isFall(playerid, 1130) )
			    {
					if(FallTime[playerid] == 0)
					{
						GetPlayerPos(playerid,FirstFallPos[playerid][0],FirstFallPos[playerid][1],FirstFallPos[playerid][2]);
					}
			        FallTime[playerid] ++;
			        if( FallTime[playerid] > MAX_FALL_STANDING_TIME) // если игрок довольно долго висит в возухе
			        {
			            if( GetPVarInt(playerid, "PlayerInAFK") > 0) // если игрок в рассихре висит
			            {
			                GetPlayerPos(playerid,FirstFallPos[playerid][0],FirstFallPos[playerid][1],FirstFallPos[playerid][2]);
			                FallTime[playerid] = 0;
			                isDebug[playerid][AC_FALL_STANDING] = false;
			                return false;
			            }
			            new Float: FloatBuff[3];
			            GetPlayerPos(playerid,FloatBuff[0],FloatBuff[1],FloatBuff[2]);
			            if( FloatBuff[2] > FirstFallPos[playerid][2]+DOBAVKA_ANI_FLYHACK)
			            {
			                // Если текущая позиция больше начальной, то чит
			                //print("Если текущая позиция больше начальной, то чит");
			                CallLocalFunction("OnPlayerUseFlyHack","iis",playerid, AC_ACTION_REPORT, "Падает вверх");
							FallTime[playerid]= 0;
							return true;
			            }
			            if( FloatBuff[2] >= FirstFallPos[playerid][2]-OTBAVKA_ANI_FLYSTAND)
			            {
				            if(!isDebug[playerid][AC_FALL_STANDING]){ // если не в откладке, то дадим игроку еще шанс
								      isDebug[playerid][AC_FALL_STANDING] = true;
								      ClearAnimations(playerid);
								      FallTime[playerid] = FallTime[playerid]-1; // дадим игроку еще шанс
									  //SetTimerEx("OnAntiCheatUpdatePlayer", 200, 0, "iii", playerid, AC_FALL_STANDING, -1); // проверим, исправился ли игрок
            						  CallLocalFunction("OnPlayerUseFlyHack","iis",playerid, AC_ACTION_REPORT, "Подозрение на повисание в небе");
									  return false;
				      		}

							// игрок недостаточно низко упал, видимо висит
							//print("игрок недостаточно низко упал, видимо висит");
							CallLocalFunction("OnPlayerUseFlyHack","iis",playerid, AC_ACTION_REPORT, "Повис в небе");
							FallTime[playerid]= 0;
							return true;
			            }

			            FallTime[playerid] = 0;
			            return false;
			        }
			    }
			    else
			    {
			        FallTime[playerid] = 0;
			        isDebug[playerid][AC_FALL_STANDING] = false;
			    }
				return false;
			}
			case AC_FAST_RUN:
			{
			    if( GetPlayerSpeed( playerid ) > MAX_FAST_RUN_SPEED )
			    {
				        if( GetPlayerSurfingObjectID(playerid) >= 0 )
				        {
				           return false; // игрок летит на объекте
				        }
				        CallLocalFunction("OnPlayerUseFasRun","iis",playerid, AC_ACTION_REPORT, "Бегает быстрее MAX_FAST_RUN_SPEED");
				        return true;

			    }
			}
			case AC_FLYHACK_:
			{
			        switch(argument)
			        {
			            case 0: // вызов флайхака с воды ( из других мест не вызывать )
			            {
							if( S[playerid] != 2 || GetPVarInt(playerid, "PlayerInAFK") > 0 )return false;
			                new Float:P[3];
			                GetPlayerPos(playerid,P[0],P[1],P[2]);
			                if( P[2] > FLY_METERS)//над водой явно
						    {
									for(new i; i < sizeof(PoolsAndLakes); i ++)//перебрать все озера и бассейны
									{
                                           if(PlayerToKvadrat(playerid,PoolsAndLakes[i][0],PoolsAndLakes[i][1],PoolsAndLakes[i][2],PoolsAndLakes[i][3]))//если игрок находится в каком-либо оезере/бассейне
                                           {
												  if(P[2] < PoolsAndLakes[i][4])//если его высота меньше высоты бассейна
												  {
														  return false;//ОН НЕ ЧИТ
												  }
                                           }

									}
									/*
									if(!isDebug[playerid][AC_FLYHACK_])
									{
									    isDebug[playerid][AC_FLYHACK_] = true;
									    return false;
									}
									*/
									CallLocalFunction("OnPlayerUseFlyHack","iis",playerid, AC_ACTION_REPORT,"Над водой плавает");
									//isDebug[playerid][AC_FLYHACK_] = false;
									return true;
						    }
			            }
			            case 1: // вызов флайхака с таймера-рендера при резких переменах высот
			            {
			                if( Player_SetPosProtectTime[playerid] != 0) return false; // игроки с защитным временем не нужны
			                if( isFall(playerid) ) // если игрок падает
							{
							    new Float:Nenuzhniy_FloatBuffer, Float:FloatBuffer2;
							    if( FallFlag[playerid] ) // если игрок уже падает
							    {
							        GetPlayerPos(playerid,Nenuzhniy_FloatBuffer,Nenuzhniy_FloatBuffer,FloatBuffer2);
							        if( FloatBuffer2 > FallZ[playerid]+DOBAVKA_ANI_FLYHACK) // если его высота больше предыдущей
							        {
							            FallFlag[playerid] = false;
							            CallLocalFunction("OnPlayerUseFlyHack","iis",playerid, AC_ACTION_REPORT,"Падение - взлет");

							            //new str[70];
							            //format(str,sizeof(str), "%s заюзал флайхак", GetName(playerid));
							            //SendClientMessageToAll( -1, str);
							            //SetPlayerHealthEx(playerid,0);
							            return true;
							        }
							        else
							        {
							            GetPlayerPos(playerid,Nenuzhniy_FloatBuffer,Nenuzhniy_FloatBuffer,FallZ[playerid]);
							        }
							    }
							    else
							    {
							    	GetPlayerPos(playerid,Nenuzhniy_FloatBuffer,Nenuzhniy_FloatBuffer,FallZ[playerid]);
							    	FallFlag[playerid] = true;
							    }

							}
							else
							{
							    FallFlag[playerid] = false;
							}
							return false;
			            }
			        }
			}
			case AC_GUN_HACK_:
		    {

					 for(new slot, weaponid, ammo; slot < AC_MAX_SLOTS; slot++)
					 {
							weaponid = 0;
							ammo = 0;
							GetPlayerWeaponData(playerid,slot,weaponid,ammo);
                     		if(IsForbiddenWeapon(weaponid)) // пулемет или ему подобное
                     		{
                                CallLocalFunction("OnPlayerUseWeaponHack","iiii",playerid, weaponid, ammo, AC_ACTION_BAN);
								return true;
                     		}
                     		if((weaponid != MyWeaponID[playerid][slot]) && weaponid != 0)//чит
                     		{
                             	if(!isDebug[playerid][AC_GUN_WP_ID_HACK_])
						     	{
							      	isDebug[playerid][AC_GUN_WP_ID_HACK_] = true;
							      	return 1;
						     	}
						     	RegivePlayerGun(playerid);
						     	//print("((weaponid != MyWeaponID[playerid][slot]) && weaponid != 0)");
						     	if( weaponid < 22) CallLocalFunction("OnPlayerUseWeaponHack","iiii",playerid, weaponid, ammo, AC_ACTION_REPORT); // если холодное оружие
						     	else CallLocalFunction("OnPlayerUseWeaponHack","iiii",playerid, weaponid, ammo, AC_ACTION_REPORT); // Огнестрел
						     	isDebug[playerid][AC_GUN_WP_ID_HACK_] = false;
						    	return 1;
                     		}
					 		if((ammo > MyWeaponID[playerid][slot]) && weaponid != 0)//чит
     						{
							 	if(!isDebug[playerid][AC_AMMO_GUN_HACK_])
						     	{
							      	isDebug[playerid][AC_AMMO_GUN_HACK_] = true;
							      	return 1;
						     	}
						     	RegivePlayerGun(playerid);
						     	print("(ammo > MyWeaponID[playerid][slot]) && weaponid != 0)");
						     	CallLocalFunction("OnPlayerUseWeaponAmmoHack","iiii",playerid, weaponid, ammo, AC_ACTION_REPORT);
						     	isDebug[playerid][AC_AMMO_GUN_HACK_] = false;
						     	return 1;
                     		}
                     		if((ammo < MyWeaponID[playerid][slot]) && weaponid != 0)
					 		{
					         	MyAmmo[playerid][slot] = ammo;
					         	isDebug[playerid][AC_AMMO_GUN_HACK_] = false;
                     		}
                     		/*
                     		if((weaponid != MyWeaponID[playerid][slot]) && weaponid != 0)//чит
                     		{
                             	if(!isDebug[playerid][AC_GUN_HACK_])
						     	{
							      	isDebug[playerid][AC_GUN_HACK_] = true;
							      	return false;
						     	}
						    	RegivePlayerGun(playerid);
						     	CallLocalFunction("OnPlayerUseWeaponHack","iiii",playerid, weaponid, ammo, 0);
						     	isDebug[playerid][AC_GUN_HACK_] = false;
						     	return true;
                     		}
					 		if((ammo > MyAmmo[playerid][slot]) && weaponid != 0)//чит
                     		{
							 	if(!isDebug[playerid][AC_GUN_HACK_])
								{
							      	isDebug[playerid][AC_GUN_HACK_] = true;
							      	return false;
						     	}
						     	RegivePlayerGun(playerid);
						     	CallLocalFunction("OnPlayerUseWeaponHack","iiii",playerid, weaponid, ammo, 0);
						     	isDebug[playerid][AC_GUN_HACK_] = false;
						     	return true;
                     		}
                     		if((ammo < MyAmmo[playerid][slot]) && weaponid != 0)
					 		{
					         	MyAmmo[playerid][slot] = ammo;
					         	isDebug[playerid][AC_GUN_HACK_] = false;
                     		}
                     		*/
					 }
					 //isDebug[playerid][AC_GUN_HACK_] = false;
            }
    }
    return false;
}

#define SetPlayerSkin AC_SetPlayerSkin                    // Макрос
#define AddPlayerClas AC_AddPlayerClass                   // Макрос
#define ShowPlayerDialog AC_ShowPlayerDialog              // Макрос

stock GetWeaponSlot(weaponid)
{
	new slotid;
	switch(weaponid)
	{
		  case 0,1: slotid = 0;
		  case 2..9: slotid = 1;
		  case 10..15: slotid = 10;
		  case 16..18:slotid = 8;
		  case 22..24:slotid = 2;
		  case 25..27:slotid = 3;
		  case 28,29,32:slotid = 4;
		  case 30,31:slotid = 5;
		  case 33,34:slotid = 6;
		  case 35..38:slotid = 7;
		  case 39:slotid = 8;
		  case 40:slotid = 12;
		  case 41..43:slotid = 9;
		  case 44..46:slotid = 11;
	}
	return slotid;
}


// ================================= АНТИ-АТАКА =================================//

#define MAX_CONNECTS_IS_ROW 85 // Максимум игроков с одного ип
#define SESSION_TIME 2 // Допустимо одно подключение раз в 2 секунды

#define FREE_SESSION -1 // Дефайн как параметр, нельзя менять!
#define MAX_SESSIONS MAX_PLAYERS*2 // Максимальное количество сессий

#define ATTACK_NPC 0 // Загон npc на сервер
#define DOUBLE_CONNECT 1 // Многоразовое подключение с одного ип
#define FAKE_DEATH 2  // Многоразовая смерть
#define FAKE_SKIP_REQUESTCLASS 3 // Сброс выбора класса читом
#define DDOS_CONNECTER 4 // Дидос подключениями

// Выделение памяти
#define PROTECT_MAX_IP_SIZE 16 // под ип выделяется 16 байт

new SessionTime[MAX_SESSIONS] = FREE_SESSION;  // Тут хранится время сессии
new SessionIP[MAX_SESSIONS][PROTECT_MAX_IP_SIZE];      // Тут хранится ип сессии

forward GetServerAttackByPlayer(playerid, attackid);  // Проверка на атаку сервера игроком

// добавить сессию
stock AddSession(playerid)
{
	// ищем свободную сессию
	new cell = -1;
	for(new i; i < MAX_SESSIONS; i ++)
	{
		    if( SessionTime[i] != FREE_SESSION ) continue;
			cell = i; // свободная сессия нашлась
			GetPlayerIp(playerid,SessionIP[cell],PROTECT_MAX_IP_SIZE); // записать ип в переменную
			SessionTime[cell] = SESSION_TIME; // задать время
			return true;
	}
	return false;
}

// Фикс сессий
stock CheckSessions()
{
    for(new i; i < MAX_SESSIONS; i ++){
		  if( SessionTime[i] <= FREE_SESSION) continue; // пустая сессия
		  SessionTime[i] --;
	}
	return 1;
}

// проверка на ддос
stock IsDDOS(playerid)
{
	 new ip[PROTECT_MAX_IP_SIZE];
	 GetPlayerIp(playerid,ip,PROTECT_MAX_IP_SIZE);
	 for( new i; i < MAX_SESSIONS; i++)
	 {
			 if((!strcmp(ip, SessionIP[i], true)) && SessionTime[i] != FREE_SESSION) // ддос обнаружен
			 {
		           return true;
             }
	 }
	 return false;
}

// очистить сессию
stock ClearSession(sessionid)
{
	if( sessionid >= MAX_SESSIONS || sessionid < 0 ) return 1; // ошибка в sessionid
    SessionTime[sessionid] = FREE_SESSION;
	return 1;
}

// Проверка на атаку сервера игроком
public GetServerAttackByPlayer(playerid, attackid){
	switch( attackid ){
			case ATTACK_NPC:{        // npc
					 if( IsPlayerNPC(playerid)){
							return true;
					 }
			}
			case DOUBLE_CONNECT:{    // двойное подключение с одного ип
                     new ip[2][PROTECT_MAX_IP_SIZE];
                     GetPlayerIp(playerid,ip[0],PROTECT_MAX_IP_SIZE);
                     new x;
                     for(new i, m = GetMaxPlayers(); i != m; i++){
                         if(!IsPlayerConnected(i) || i == playerid) continue;
                         GetPlayerIp(i,ip[1],16);
                         if(!strcmp(ip[0],ip[1],true)) x++;
                         if(x >= MAX_CONNECTS_IS_ROW){ // многоразовое подкючение обнаружено
							   Kick( i );
                         }
                     }
                     if( x >= MAX_CONNECTS_IS_ROW) return true;
			}
			case FAKE_DEATH: {       // многоразовая смерть. Вызывать только из onplayerdeath
                     if(GetPVarInt(playerid,"K_Times") > 1){
						  return true;
					 }
			}
			case FAKE_SKIP_REQUESTCLASS:{  // читерский сброс выбора класса. Вызывать только из OnPlayerSpawn
                     if(GetPVarInt(playerid,"Logged")==0){
		                  return true;
                     }
            }
			case DDOS_CONNECTER:{           // Вызывается только из onplayerconnect
                     if( IsDDOS(playerid) ){ // Ддос обнаружен
			                 return true;
	                 }
			}
	}
	return false;
}
// ***********************************************************************************

//Таймер
new GM;//переменная для хранения таймера
#define CP_UPDATE_INTERVAL 950//интервал обновления процессора в милисекундах (ОДНА СЕКУНДА ПРИМЕРНО !> && !<)

//Режим строительства строителем
#define MAX_PLAYER_OBJECTS 12//максимум объектов для игрока
#define MAX_OBJECTS_CREATE MAX_PLAYER_OBJECTS*MAX_PLAYERS//максимум поддерживаемых объектов
new Object[MAX_PLAYER_OBJECTS];//переменная для хранения ид объекта
new Object_idx[MAX_PLAYERS];//количество уже созданных объектов у игрока
new Server_Objects = 0;//объектов всего создано

//Арены
//new OldMap = -1; //ид предыдущей арены
new CurrentMap = -1;//ид ТЕКУЩЕЙ арены
new Float: MapSpawnPos[MAX_MAPS][4];//спавн на карте
new MapName[MAX_MAPS][32];//тут хранится имя карты
new bool:MapHaveMarker[MAX_MAPS] = false;//наличие у карты маркера убежища (движок сделан так, что позволяет его отсутствие)
new MapInterior[MAX_MAPS];//интерьер карты
new Float: MapMarkerPos[MAX_MAPS][3];//позиция маркера
new bool: MapGiveZombieGun[MAX_MAPS] = false;//давание зомби оружия
new Loaded_Maps = 0;//счетчик всех загруженных карт
new MapFS[MAX_MAPS][32]; // скрипт объектов для карты

//ТАБЛИЦЫ С ОРУЖИЕМ В МАГАЗИНЕ
enum guns_picture{
    gun_iden,
    gun_ammo,
    gun_rubprice,
    gun_zmprice,
    gun_srok
}

//ОРУЖИЕИД, ПАТРОНЫ, ЦЕНА В РУБЛЯХ, ЦЕНА В ЗОМБИ МОНЕЙ, СРОК В ДНЯХ (-1 = БЕСКОНЕЧНО)
static stock shop_pistols_table[][guns_picture] ={
    { 23,300,2,1000,1},
    { 23,300,10,5000,7},
    { 23,300,35,15000,30},
    { 23,300,50,50000,-1},

    { 22,300,5,3000,1},
    { 22,300,20,15000,7},
    { 22,300,50,45000,30},
    { 22,300,100,100000,-1},

    { 24,100,5,5000,1},
    { 24,100,20,25000,7},
    { 24,100,50,75000,30},
    { 24,100,100,200000,-1}
};
static stock shop_avtomats_table[][guns_picture] ={
    { 32,500,6,-1,1},
    { 32,500,30,-1,7},
    { 32,500,100,-1,30},
    { 32,500,250,-1,-1},

    { 28,500,6,-1,1},
    { 28,500,30,-1,7},
    { 28,500,100,-1,30},
    { 28,500,250,-1,-1},

    { 29,300,3,3000,1},
    { 29,300,12,15000,7},
    { 29,300,36,45000,30},
    { 29,300,72,100000,-1}
};
static stock shop_shotguns_table[][guns_picture] ={
    { 25,100,3,3000,1},
    { 25,100,12,15000,7},
    { 25,100,36,45000,30},
    { 25,100,72,100000,-1},

    { 27,140,5,5000,1},
    { 27,140,20,25000,7},
    { 27,140,50,75000,30},
    { 27,140,150,200000,-1},

    { 26,120,6,-1,1},
    { 26,120,30,-1,7},
    { 26,120,100,-1,30},
    { 26,120,250,-1,-1}
};
static stock shop_karabins_table[][guns_picture] ={
    { 30,300,7,3000,1},
    { 30,300,35,15000,7},
    { 30,300,80,45000,30},
    { 30,300,200,100000,-1},

    { 31,300,10,5000,1},
    { 31,300,50,25000,7},
    { 31,300,150,7500,30},
    { 31,300,300,200000,-1}
};
new Karabins_Dialog[SHOP_GUNS_DIALOG_LINE_SIZE*sizeof(shop_karabins_table)];
new Shotguns_Dialog[SHOP_GUNS_DIALOG_LINE_SIZE*sizeof(shop_shotguns_table)];
new Pistols_Dialog[SHOP_GUNS_DIALOG_LINE_SIZE*sizeof(shop_pistols_table)];
new Avtomats_Dialog[SHOP_GUNS_DIALOG_LINE_SIZE*sizeof(shop_avtomats_table)];


//Информер профессии
new PlayerText: iNF_Polosa[MAX_PLAYERS];
new PlayerText: iNF_Information[MAX_PLAYERS];
new PlayerText: iNF_Score[MAX_PLAYERS];

stock CreateInformer(playerid)
{
	//полоска
	iNF_Polosa[playerid] = CreatePlayerTextDraw(playerid,203.000000,406.000000,"_");
	PlayerTextDrawUseBox(playerid,iNF_Polosa[playerid],1);
	PlayerTextDrawBoxColor(playerid,iNF_Polosa[playerid],0x00000066);
	PlayerTextDrawTextSize(playerid,iNF_Polosa[playerid],445.000000,0.000000);
	PlayerTextDrawAlignment(playerid,iNF_Polosa[playerid],0);
	PlayerTextDrawBackgroundColor(playerid,iNF_Polosa[playerid],0x000000ff);
	PlayerTextDrawFont(playerid,iNF_Polosa[playerid],1);
	PlayerTextDrawLetterSize(playerid,iNF_Polosa[playerid],1.000000,1.000000);
	PlayerTextDrawColor(playerid,iNF_Polosa[playerid],0xffffffff);
	PlayerTextDrawSetOutline(playerid,iNF_Polosa[playerid],1);
	PlayerTextDrawSetProportional(playerid,iNF_Polosa[playerid],1);
	PlayerTextDrawSetShadow(playerid,iNF_Polosa[playerid],1);


	//счет и информер
	iNF_Score[playerid] = CreatePlayerTextDraw(playerid,204.000000,404.000000,"IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
	iNF_Information[playerid] = CreatePlayerTextDraw(playerid,272.000000,356.000000,"Profession: ~n~~y~Shturmovik~n~~w~Rank: ~y~4~w~/~g~5~n~~w~Exp: ~y~75~w~/~g~75");
	PlayerTextDrawAlignment(playerid,iNF_Score[playerid],0);
	PlayerTextDrawAlignment(playerid,iNF_Information[playerid],0);
	PlayerTextDrawBackgroundColor(playerid,iNF_Score[playerid],0x000000ff);
	PlayerTextDrawBackgroundColor(playerid,iNF_Information[playerid],0x000000ff);
	PlayerTextDrawFont(playerid,iNF_Score[playerid],1);
	PlayerTextDrawLetterSize(playerid,iNF_Score[playerid],0.200001,1.300000);
	PlayerTextDrawFont(playerid,iNF_Information[playerid],1);
	PlayerTextDrawLetterSize(playerid,iNF_Information[playerid],0.499999,1.300000);
	PlayerTextDrawColor(playerid,iNF_Score[playerid],0x00ffffff);
	PlayerTextDrawColor(playerid,iNF_Information[playerid],0xffffffff);
	PlayerTextDrawSetOutline(playerid,iNF_Score[playerid],1);
	PlayerTextDrawSetOutline(playerid,iNF_Information[playerid],1);
	PlayerTextDrawSetProportional(playerid,iNF_Score[playerid],1);
	PlayerTextDrawSetProportional(playerid,iNF_Information[playerid],1);
	PlayerTextDrawSetShadow(playerid,iNF_Score[playerid],1);
	PlayerTextDrawSetShadow(playerid,iNF_Information[playerid],1);



	HideInformer(playerid);
	return 1;
}

stock DestroyInformer(playerid)
{
	PlayerTextDrawDestroy(playerid,iNF_Polosa[playerid]);
	PlayerTextDrawDestroy(playerid,iNF_Score[playerid]);
	PlayerTextDrawDestroy(playerid,iNF_Information[playerid]);
	return 1;
}

stock ShowInformer(playerid)
{
	PlayerTextDrawShow(playerid,iNF_Polosa[playerid]);
	PlayerTextDrawShow(playerid,iNF_Score[playerid]);
	PlayerTextDrawShow(playerid,iNF_Information[playerid]);
	return 1;
}

stock HideInformer(playerid)
{
	PlayerTextDrawHide(playerid,iNF_Polosa[playerid]);
	PlayerTextDrawHide(playerid,iNF_Score[playerid]);
	PlayerTextDrawHide(playerid,iNF_Information[playerid]);
	return 1;
}

//ИГРОК
new Player_OLDHP[MAX_PLAYERS];
new Player_Invites[MAX_PLAYERS];
new Player_Email[MAX_PLAYERS][MAX_EMAIL_SIZE];
new Player_Deaths[MAX_PLAYERS];
new Player_MuteTime[MAX_PLAYERS];
new Player_AdminLevel[MAX_PLAYERS];
new Player_KillHuman[MAX_PLAYERS];
new Player_KillZombie[MAX_PLAYERS];
new Player_Age[MAX_PLAYERS];
//new Player_Respects[MAX_PLAYERS];
//new Player_Level[MAX_PLAYERS];
new Player_Rub[MAX_PLAYERS];
new Player_Zm[MAX_PLAYERS];
new bool:Player_InMarker[MAX_PLAYERS];
new bool: Player_IsKill[MAX_PLAYERS];
new Player_IsVip[MAX_PLAYERS];
new Player_IL[MAX_PLAYERS];
new Player_Cap[MAX_PLAYERS];
new Player_RHealth[MAX_PLAYERS];
new Medik_ResetHealthTime[MAX_PLAYERS];
new Player_Invisible[MAX_PLAYERS];
new Player_Password[MAX_PLAYERS][MAX_PASS_LEGHT];
new Player_ChosenInt[MAX_PLAYERS];
new Player_TimeToExp[MAX_PLAYERS];
new Player_SecInGame[MAX_PLAYERS];
new Player_HourInGame[MAX_PLAYERS];
new Player_DefenderOldHealth[MAX_PLAYERS];
new Player_DefenderGmTime[MAX_PLAYERS];
new TimeForKill[MAX_PLAYERS];//время до перемещения игрока в тему зомби (если тот в афк на арене)
new Player_H_DopHealth[MAX_PLAYERS][MAX_H_CLASS];
new Player_Z_DopHealth[MAX_PLAYERS][MAX_Z_CLASS];
//Покупное оружие игрока (НЕ ИЗМЕНЯТЬ ДЕФАЙНЫ)
#define MAX_SLOTS 4
#define GUN_PISTOLS 0
#define GUN_AVTOMATS 1
#define GUN_SHOTGUNS 2
#define GUN_MASHINEGUNS 3

new Player_Gun[MAX_PLAYERS][MAX_SLOTS];
new Player_Ammo[MAX_PLAYERS][MAX_SLOTS];
new Player_GunSrok[MAX_PLAYERS][MAX_SLOTS];

//срок купленного берета
new Player_CapSrok[MAX_PLAYERS];

//***************************************
		 /*Профессии (классы)*/
new Player_HumanProfession[MAX_PLAYERS];
new Player_ZombieProfession[MAX_PLAYERS];
		 /*Ранг на профессии*/
new Player_HumanProfessionRang[MAX_PLAYERS][MAX_H_CLASS];
new Player_ZombieProfessionRang[MAX_PLAYERS][MAX_Z_CLASS];
		 /*Время Перезарядки способности*/
new Player_HumanResetSkillTime[MAX_PLAYERS][MAX_H_CLASS];
new Player_ZombieResetSkillTime[MAX_PLAYERS][MAX_Z_CLASS];
		 /*Уроверь скилла  рангах*/
new Player_HumanRangSkill[MAX_PLAYERS][MAX_H_CLASS];
new Player_ZombieRangSkill[MAX_PLAYERS][MAX_Z_CLASS];
		 /*Имение определенной профессии как доп.*/
new bool:Player_H_HaveProfession[MAX_PLAYERS][MAX_H_CLASS] ;
new bool:Player_Z_HaveProfession[MAX_PLAYERS][MAX_Z_CLASS] ;

//****************************************

//Бомба у штурмовика
#define MAX_BOMBS MAX_PLAYERS*3
#define BOMB_DETONATOR 3000
new Bomb_Object[MAX_BOMBS];
new Bomb_Time[MAX_BOMBS];
new Bombs_Counter = 0;

new Float:Bomb_X[MAX_BOMBS];
new Float:Bomb_Y[MAX_BOMBS];
new Float:Bomb_Z[MAX_BOMBS];

new Player_MyBombId[MAX_PLAYERS] = -1;

//Заметка 04.06.2012: Доделать Возвращение на Back Key - доделано

// Обновление ниженго информера
stock UpdateInformer(playerid)
{
	  new str[150],needexp,finaltext[102],exp;
	  switch(Player_CurrentTeam[playerid])
	  {
			 case ZOMBIE:
			 {
					exp = Player_ZombieRangSkill[playerid][Player_ZombieProfession[playerid]];
					needexp = (Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]+1)*NEED_EXP_UMNOZHITEL;
					if(exp > needexp)exp = needexp;
					if(Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] < 4)
					{
	                    format(str,sizeof(str),"Profession: ~n~~r~%s~n~~w~Rank: ~y~%d~w~/~r~5~n~~w~Exp: ~y~%d~w~/~r~%d",
						GetProfNameT(ZOMBIE,Player_ZombieProfession[playerid]),
						Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]+1,
						exp,
						needexp
	                    );
	                    
	                    new itog_procent = floatround( ( exp * 100 ) / needexp );
	                    
						// (51 * 100) / 1500 = сколько процентов составляет 51 от 1500
						
						/*
		                for(new procent = 0; procent < 101; procent++)
						{
								if( exp != floatround((needexp/100.0) * procent) )continue;
								for(new score; score < procent+1; score++)
								{
										strcat(finaltext,"I");
								}
								break;
						}
						*/
						for(new procent = 0; procent < itog_procent; procent ++)
						{
						    strcat(finaltext,"I");
						}
						
                    }
                    else
                    {
                        format(str,sizeof(str),"Profession: ~n~~r~%s~n~~w~Rank: ~y~5~w~/~r~5~n~~w~Exp: ~y~...~w~/~r~...",GetProfNameT(ZOMBIE,Player_ZombieProfession[playerid]));
                    }
                    
			 }
			 case HUMAN:
			 {
					exp = Player_HumanRangSkill[playerid][Player_HumanProfession[playerid]];
					needexp = (Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]+1)*NEED_EXP_UMNOZHITEL;
					if(exp > needexp)exp = needexp;
					if(Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] < 4)
					{
	                    format(str,sizeof(str),"Profession: ~n~~g~%s~n~~w~Rank: ~y~%d~w~/~g~5~n~~w~Exp: ~y~%d~w~/~g~%d",
						GetProfNameT(HUMAN,Player_HumanProfession[playerid]),
						Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]+1,
						exp,
						needexp
	                    );
	                    
	                    new itog_procent = floatround( ( exp * 100 ) / needexp );
	                    
	                    /*
	                    for(new procent = 0; procent < 101; procent++)
						{
								if( exp != floatround((needexp/100.0) * procent) )continue;
								for(new score; score < procent+1; score++)
								{
										strcat(finaltext,"I");
								}
								break;
						}
						*/
						
						for(new procent = 0; procent < itog_procent; procent ++)
						{
						    strcat(finaltext,"I");
						}
						
      				}
      				else
      				{
      				    format(str,sizeof(str),"Profession: ~n~~g~%s~n~~w~Rank: ~y~5~w~/~g~5~n~~w~Exp: ~y~...~w~/~g~...",
						GetProfNameT(HUMAN,Player_HumanProfession[playerid]));
      				}
					
			 }
			 case ADMIN:
			 {
                    HideInformer(playerid);
			 }
	  }
	  //if(!strlen(finaltext))finaltext = "IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII";
	  PlayerTextDrawSetString(playerid,iNF_Score[playerid],finaltext);
      PlayerTextDrawSetString(playerid,iNF_Information[playerid],str);
	  PlayerTextDrawShow(playerid,iNF_Polosa[playerid]);
	  return 1;
}
//обнулить все переменные
stock SetNull(playerid)
{
   Player_ZombieInfectTime[playerid] = 0;
   FallTime[playerid] = 0;
   test_enabled[playerid] = false;
   PlayerNoAFK[playerid] = true;
   S[playerid] = 0;
   isKicked[playerid] = false;
   TimeToHideDropZmInformer[playerid] = 0;
   Call_Connected[playerid] = false;
   Player_Voted[playerid] = false;
   Player_CapSrok[playerid] = 0;
   Player_OLDHP[playerid] = 50;
   Player_Invites[playerid] = 0;
   gSpectateID[playerid] = -1;
   TextDrawHideForPlayer(playerid,RedScreenBox);
   //********************************************************
   Player_HumanProfessionRang[playerid][HUMAN_PROF_SHTURMOVIK] = 0;
   Player_HumanProfessionRang[playerid][HUMAN_PROF_MEDIK] = 0;
   Player_HumanProfessionRang[playerid][HUMAN_PROF_SNIPER] = 0;
   Player_HumanProfessionRang[playerid][HUMAN_PROF_DEFENDER] = 0;
   Player_HumanProfessionRang[playerid][HUMAN_PROF_CREATER] = 0;
   //********************************************************
   Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_TANK] = 0;
   Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_JOKEY] = 0;
   Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_VEDMA] = 0;
   Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_BUMER] = 0;
   //********************************************************
   Player_CurrentTeam[playerid] = ZOMBIE;
   Player_InMarker[playerid] = false;
   Player_IL[playerid] = NONE;
   Player_Invisible[playerid] = 0;
   Object_idx[playerid] = 0;
   TimeForKill[playerid] = 0;
   Player_ChosenInt[playerid] = 0;//буффер для интегеров
   Player_TimeToExp[playerid] = 6000;
   Player_MyBombId[playerid] = -1;
   Player_RHealth[playerid] = 0;
   Player_IsKill[playerid] = false;
   Player_DefenderOldHealth[playerid] = 0;
   Player_DefenderGmTime[playerid] = 0;
   //*******************************************************
   Player_HourInGame[playerid] = 0;
   Player_SecInGame[playerid] = 0;
   Player_Deaths[playerid] = 0;
   Player_MuteTime[playerid] = 0;
   Player_AdminLevel[playerid] = 0;
   Player_KillHuman[playerid] = 0;
   Player_KillZombie[playerid] = 0;
   Player_Age[playerid] = 0;
   //Player_Respects[playerid] = 0;
   //Player_Level[playerid] = 0;
   Player_Rub[playerid] = 0;
   Player_Zm[playerid] = 0;
   Player_IsVip[playerid] = 0;
   Player_Cap[playerid] = NONE;
   Player_Special_Voteban[playerid] = 0;
   NullACBuffer(playerid); // обнулить данные античита
		   /*Скиллы*/
   for(new i; i < MAX_H_CLASS; i++)//Обнулим людей
   {
       Player_HumanRangSkill[playerid][i]=0;
       Player_HumanResetSkillTime[playerid][i]=0;//у медика - перезярядка инъекции
       Player_H_HaveProfession[playerid][i] = false;
       Player_H_DopHealth[playerid][i] = 0;
   }
   for(new i; i < MAX_Z_CLASS; i++)//обнулим зомби
   {
       Player_ZombieRangSkill[playerid][i]=0;
       Player_ZombieResetSkillTime[playerid][i]=0;
       Player_Z_HaveProfession[playerid][i] = false;
       Player_Z_DopHealth[playerid][i] = 0;
   }
   Medik_ResetHealthTime[playerid] = 0;
   
}

//провека титутла
stock FixTitul(playerid,titulid){
	   switch(titulid){
			case TIT_LORD:{
				 if(Player_Rub[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[TIT_LORD],GetName(playerid),0,MAX_PLAYER_NAME+1);
					  Tit_Value[TIT_LORD] = Player_Rub[playerid];
					  ReWriteTitul(titulid);
				 }
			}
			case TIT_PRESIDENT:{
		         if(Player_Zm[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[titulid],GetName(playerid),0,MAX_PLAYER_NAME+1);
					  Tit_Value[titulid] = Player_Zm[playerid];
					  ReWriteTitul(titulid);
				 }
		    }
			case TIT_RAMBO:{
		         if(Player_KillZombie[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[titulid],GetName(playerid),0,MAX_PLAYER_NAME+1);
					  Tit_Value[titulid] = Player_KillZombie[playerid];
					  ReWriteTitul(titulid);
				 }
		    }
			case TIT_KILLER:{
                 if(Player_KillHuman[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[titulid],GetName(playerid),0,MAX_PLAYER_NAME+1);
					  Tit_Value[titulid] = Player_KillHuman[playerid];
					  ReWriteTitul(titulid);
				 }
		    }
			case TIT_PROSVET:{
                 if(Player_HourInGame[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[titulid],GetName(playerid),0,MAX_PLAYER_NAME+1);
					  Tit_Value[titulid] = Player_HourInGame[playerid];
					  ReWriteTitul(titulid);
				 }
			}
			case TIT_FRIENDLY:{
		 	     if(Player_Invites[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[titulid],GetName(playerid),0,MAX_PLAYER_NAME+1);
					  Tit_Value[titulid] = Player_Invites[playerid];
					  ReWriteTitul(titulid);
				 }
			}
	   }
}

//создать диалог с выбором профессий при коннекте
stock createChosenProf(){
	new str[48];
	for(new i; i < MAX_H_CLASS; i++){
		   format(str,sizeof(str),""COL_LIME"[%d] "COL_WHITE"- "COL_EASY"%s\n",i+1,GetProfName(HUMAN,i));
		   strcat(HumanProf_D,str);
	}
	for(new i; i < MAX_Z_CLASS; i++){
		   format(str,sizeof(str),""COL_LIME"[%d] "COL_WHITE"- "COL_RED"%s\n",i+1,GetProfName(ZOMBIE,i));
		   strcat(ZombieProf_D,str);
	}
}

//проверка соотношения exp к needed-exp - проверка уровня
/*
stock FixLevel(playerid)
{
	  new exp = Player_Respects[playerid];
	  new neededexp = Player_Level[playerid]*2;
	  if(exp > neededexp)
	  {
			 SendClientMessage(playerid,-1,""COL_YELLOW"Вы перешли на новый уровень!");
			 Player_Respects[playerid] = 0;
			 Player_Level[playerid]++;
	  }
	  SetPlayerScore(playerid,Player_Level[playerid]);
}
*/
//открыть диалог с логином
stock OpenLogin(playerid,title[]="Авторизация")
{
	  new str[512];
	  format(str,sizeof(str),"{FFFFFF}__________________________________________________\n\nПриветствуем вас на Saints Row\n\n          Вход в аккаунт: "COL_EASY"%s{FFFFFF}\n          Введите пароль:\n__________________________________________________",GetName(playerid));
	  ShowPlayerDialog(playerid,LOGIN_DIALOG,DIALOG_STYLE_INPUT,title,str,"Ввод","Выход");
	  return 1;
}
//открыть диалог с авторизацией
stock OpenRegister(playerid,title[]="Регистрация")
{
	  new str[512];
	  format(str,sizeof(str),"{FFFFFF}__________________________________________________\n\nПриветствуем вас на Saints Row\n\n          Регистрация аккаунта: "COL_EASY"%s{FFFFFF}\n          Придумайте пароль:\n          В пароле разрешено использовать символы:\n          A-z, 0-9\n          Длинна пароля от %d до %d символов\n__________________________________________________",GetName(playerid),MIN_PASS_LEGHT,MAX_PASS_LEGHT);
	  //format(str,sizeof(str),""COL_WHITE"Добро пожаловать на сервер "COL_RED"Saints Row\n"COL_WHITE"Придумайте пароль к аккаунту\nВ пароле разрешено использовать символы A-z, 0-9\nДлинна пароля от %d до %d символов",MIN_PASS_LEGHT,MAX_PASS_LEGHT);
	  ShowPlayerDialog(playerid,REGISTER_DIALOG,DIALOG_STYLE_INPUT,title,str,"Ввод","Выход");
	  return 1;
}
//сохранть аккаунт
stock SaveAccount(playerid)
{
	  if(GetPVarInt(playerid,"Logged") != 1)return 1;
	  //только игрокам, прошедшим загрузку аккаунта, во избежания перезаписи неправильных параметров
	  new IF,str[64];
	  format(str,sizeof(str),"%s/%s.ini",ACCOUNTS_FOLDER,GetName(playerid));
	  if(!fexist(str))IF = ini_createFile(str);
	  else IF = ini_openFile(str);
	  ini_setInteger(IF,"zombieprofession",Player_ZombieProfession[playerid]);
	  ini_setInteger(IF,"humanprofession",Player_HumanProfession[playerid]);
	  //ini_setInteger(IF,"level",Player_Level[playerid]);
	  ini_setInteger(IF,"age",Player_Age[playerid]);
	  ini_setInteger(IF,"zombiekill",Player_KillZombie[playerid]);
	  ini_setInteger(IF,"humankill",Player_KillHuman[playerid]);
	  ini_setInteger(IF,"adminlevel",Player_AdminLevel[playerid]);
	  ini_setInteger(IF,"MuteTime",Player_MuteTime[playerid]);
	  ini_setInteger(IF,"deaths",Player_Deaths[playerid]);
	  ini_setInteger(IF,"cap",Player_Cap[playerid]);
	  //ini_setInteger(IF,"respects",Player_Respects[playerid]);
	  ini_setInteger(IF,"rub",Player_Rub[playerid]);
	  ini_setInteger(IF,"zm",Player_Zm[playerid]);
	  ini_setInteger(IF,"invites",Player_Invites[playerid]);
	  ini_setInteger(IF,"houringame",Player_HourInGame[playerid]);
	  ini_setInteger(IF,"secingame",Player_SecInGame[playerid]);
	  ini_setInteger(IF,"vip",Player_IsVip[playerid]);
	  ini_setString(IF,"mail",Player_Email[playerid]);
	  new bstr[40];
	  for(new i,value; i < MAX_H_CLASS; i ++)
	  {
			 format(bstr,sizeof(bstr),"humanrangskill_%d",i);
			 ini_setInteger(IF,bstr,Player_HumanRangSkill[playerid][i]);
			 format(bstr,sizeof(bstr),"humanresetskill_%d",i);
			 ini_setInteger(IF,bstr,Player_HumanResetSkillTime[playerid][i]);
             if(Player_H_HaveProfession[playerid][i])value = 1;
             else value = 0;
             format(bstr,sizeof(bstr),"h_haveprofession_%d",i);
			 ini_setInteger(IF,bstr,value);
			 format(bstr,sizeof(bstr),"dophealth_h_%d",i);
			 ini_setInteger(IF,bstr,Player_H_DopHealth[playerid][i]);
	  }
	  for(new i,value; i < MAX_Z_CLASS; i ++)
	  {
             format(bstr,sizeof(bstr),"zombierangskill_%d",i);
			 ini_setInteger(IF,bstr,Player_ZombieRangSkill[playerid][i]);
			 format(bstr,sizeof(bstr),"zombieresetskill_%d",i);
			 ini_setInteger(IF,bstr,Player_ZombieResetSkillTime[playerid][i]);
			 if(Player_Z_HaveProfession[playerid][i])value = 1;
			 else value = 0;
             format(bstr,sizeof(bstr),"z_haveprofession_%d",i);
			 ini_setInteger(IF,bstr,value);
			 format(bstr,sizeof(bstr),"dophealth_z_%d",i);
			 ini_setInteger(IF,bstr,Player_Z_DopHealth[playerid][i]);
	  }
	  ini_setInteger(IF,"medikresethealth",Medik_ResetHealthTime[playerid]);
	  ini_setInteger(IF,"h_rang_sturm",Player_HumanProfessionRang[playerid][HUMAN_PROF_SHTURMOVIK]);
	  ini_setInteger(IF,"h_rang_medik",Player_HumanProfessionRang[playerid][HUMAN_PROF_MEDIK]);
	  ini_setInteger(IF,"h_rang_sniper",Player_HumanProfessionRang[playerid][HUMAN_PROF_SNIPER]);
	  ini_setInteger(IF,"h_rang_def",Player_HumanProfessionRang[playerid][HUMAN_PROF_DEFENDER]);
	  ini_setInteger(IF,"h_rang_creat",Player_HumanProfessionRang[playerid][HUMAN_PROF_CREATER]);
	  ini_setInteger(IF,"z_rang_grom",Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_TANK]);
	  ini_setInteger(IF,"z_rang_jok",Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_JOKEY]);
	  ini_setInteger(IF,"z_rang_vedm",Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_VEDMA]);
	  ini_setInteger(IF,"z_rang_bumer",Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_BUMER]);
	  ini_setInteger(IF,"special_voteban",Player_Special_Voteban[playerid]);
	  ini_setString(IF,"password",Player_Password[playerid]);
	  ini_setInteger(IF,"capsrok",Player_CapSrok[playerid]);
	  for(new i; i < MAX_SLOTS; i++)
	  {
		  format(bstr,sizeof(bstr),"shopgun_%d",i);
	      ini_setInteger(IF,bstr,Player_Gun[playerid][i]);
	      format(bstr,sizeof(bstr),"shopammo_%d",i);
	      ini_setInteger(IF,bstr,Player_Ammo[playerid][i]);
	      format(bstr,sizeof(bstr),"shopgunsrok_%d",i);
	      ini_setInteger(IF,bstr,Player_GunSrok[playerid][i]);
      }
	  ini_closeFile(IF);
	  return 1;
}


//проверка проведенных часов в игре
stock FixHours(playerid)
{
	  if(Player_SecInGame[playerid] < 6000)return 1;
      Player_HourInGame[playerid] ++;
      FixTitul(playerid,TIT_PROSVET);
      Player_SecInGame[playerid] = 0;
      SaveAccount(playerid);
      return 1;
}

//грузить аккаунт
stock LoadAccount(playerid)
{
	  if(S[playerid] == 0 && GetPVarInt(playerid,"Logged") != 1)return 1;
	  new IF,str[64];
	  format(str,sizeof(str),"%s/%s.ini",ACCOUNTS_FOLDER,GetName(playerid));
	  if(!fexist(str))return 1;
	  IF = ini_openFile(str);
	  ini_getInteger(IF,"zombieprofession",Player_ZombieProfession[playerid]);
	  ini_getInteger(IF,"humanprofession",Player_HumanProfession[playerid]);
	  //ini_getInteger(IF,"level",Player_Level[playerid]);
	  ini_getInteger(IF,"age",Player_Age[playerid]);
	  ini_getInteger(IF,"zombiekill",Player_KillZombie[playerid]);
	  ini_getInteger(IF,"humankill",Player_KillHuman[playerid]);
	  ini_getInteger(IF,"adminlevel",Player_AdminLevel[playerid]);
	  ini_getInteger(IF,"MuteTime",Player_MuteTime[playerid]);
	  ini_getInteger(IF,"deaths",Player_Deaths[playerid]);
	  ini_getInteger(IF,"cap",Player_Cap[playerid]);
	  //ini_getInteger(IF,"respects",Player_Respects[playerid]);
	  ini_getInteger(IF,"rub",Player_Rub[playerid]);
	  ini_getInteger(IF,"zm",Player_Zm[playerid]);
	  ini_getInteger(IF,"invites",Player_Invites[playerid]);
	  ini_getInteger(IF,"houringame",Player_HourInGame[playerid]);
	  ini_getInteger(IF,"secingame",Player_SecInGame[playerid]);
	  ini_getInteger(IF,"vip",Player_IsVip[playerid]);
	  ini_getString(IF,"mail",Player_Email[playerid]);
	  ini_getInteger(IF,"medikresethealth",Medik_ResetHealthTime[playerid]);
	  ini_getInteger(IF,"h_rang_sturm",Player_HumanProfessionRang[playerid][HUMAN_PROF_SHTURMOVIK]);
	  ini_getInteger(IF,"h_rang_medik",Player_HumanProfessionRang[playerid][HUMAN_PROF_MEDIK]);
	  ini_getInteger(IF,"h_rang_sniper",Player_HumanProfessionRang[playerid][HUMAN_PROF_SNIPER]);
	  ini_getInteger(IF,"h_rang_def",Player_HumanProfessionRang[playerid][HUMAN_PROF_DEFENDER]);
	  ini_getInteger(IF,"h_rang_creat",Player_HumanProfessionRang[playerid][HUMAN_PROF_CREATER]);
	  ini_getInteger(IF,"z_rang_grom",Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_TANK]);
	  ini_getInteger(IF,"z_rang_jok",Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_JOKEY]);
	  ini_getInteger(IF,"z_rang_vedm",Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_VEDMA]);
	  ini_getInteger(IF,"z_rang_bumer",Player_ZombieProfessionRang[playerid][ZOMBIE_PROF_BUMER]);
	  ini_getInteger(IF,"special_voteban",Player_Special_Voteban[playerid]);
	  ini_getInteger(IF,"capsrok",Player_CapSrok[playerid]);
	  new bstr[40];
	  for(new i,value; i < MAX_H_CLASS; i ++)
	  {
			 format(bstr,sizeof(bstr),"humanrangskill_%d",i);
			 ini_getInteger(IF,bstr,Player_HumanRangSkill[playerid][i]);
			 format(bstr,sizeof(bstr),"humanresetskill_%d",i);
			 ini_getInteger(IF,bstr,Player_HumanResetSkillTime[playerid][i]);
			 
			 format(bstr,sizeof(bstr),"h_haveprofession_%d",i);
			 ini_getInteger(IF,bstr,value);
			 if(value == 1)Player_H_HaveProfession[playerid][i] = true;
			 else Player_H_HaveProfession[playerid][i] = false;
			 
			 format(bstr,sizeof(bstr),"dophealth_h_%d",i);
			 ini_getInteger(IF,bstr,Player_H_DopHealth[playerid][i]);
	  }
	  for(new i,value; i < MAX_Z_CLASS; i ++)
	  {
             format(bstr,sizeof(bstr),"zombierangskill_%d",i);
			 ini_getInteger(IF,bstr,Player_ZombieRangSkill[playerid][i]);
			 format(bstr,sizeof(bstr),"zombieresetskill_%d",i);
			 ini_getInteger(IF,bstr,Player_ZombieResetSkillTime[playerid][i]);
			 
             format(bstr,sizeof(bstr),"z_haveprofession_%d",i);
			 ini_getInteger(IF,bstr,value);
			 if(value == 1)Player_Z_HaveProfession[playerid][i] = true;
			 else Player_Z_HaveProfession[playerid][i] = false;
			 
			 format(bstr,sizeof(bstr),"dophealth_z_%d",i);
			 ini_getInteger(IF,bstr,Player_Z_DopHealth[playerid][i]);
	  }
	  for(new i; i < MAX_SLOTS; i++)
	  {
		  format(bstr,sizeof(bstr),"shopgun_%d",i);
	      ini_getInteger(IF,bstr,Player_Gun[playerid][i]);
	      format(bstr,sizeof(bstr),"shopammo_%d",i);
	      ini_getInteger(IF,bstr,Player_Ammo[playerid][i]);
	      format(bstr,sizeof(bstr),"shopgunsrok_%d",i);
	      ini_getInteger(IF,bstr,Player_GunSrok[playerid][i]);
      }
      Player_H_HaveProfession[playerid][Player_HumanProfession[playerid]] = true;
      Player_Z_HaveProfession[playerid][Player_ZombieProfession[playerid]] = true;
	  ini_closeFile(IF);
	  for(new i = 1; i < MAX_TITULS; i++)
	  {
           FixTitul(playerid,i);
	  }
	  return 1;
}



main(){}


//Таблицы с настройками рангов
   /*ЛЮДИ*/
enum rang_picture{
    /*rang_name[64],*/
    rang_price,//цена
	rang_health,//жизни
	rang_zmforkill, // сколько давать за убийство
	rang_skin,//скин
    rang_gun,//пушка 1
    rang_ammo,//патроны 1
    rang_gun2,//пу 2
    rang_ammo2,//па 2
    rang_gun3,//пу 3
    rang_ammo3,//па 3
    rang_gun4,//пу 4 -в основном - для огнеметчика
    rang_ammo4,//па 4 -в основном - для огнеметчика
    rang_special,//перезарядка скилла или другой интегер
	rang_special2,//еще доп. интегер
	rang_special3//и еще интегер для медика
}
static stock human_class_shturmovik[][rang_picture] ={//special = таймер до баха, special2 = время отката
    { /*"Сержант",*/0,100,10/*rang_zmforkill*/,284,23,100,29,120,3,1,0,0,30,60},
    { /*"Лейтенант",*/1000,125,15/*rang_zmforkill*/,282,23,150,29,150,3,1,0,0,20,60},
    { /*"Майор",*/1500,150,20/*rang_zmforkill*/,288,23,200,29,180,3,1,0,0,10,60},
    { /*"Генерал армии",*/2000,175,25/*rang_zmforkill*/,286,23,250,29,210,3,1,0,0,5,60},
    { /*"Министр обороны",*/3000,200,30/*rang_zmforkill*/,287,23,300,29,300,8,1,0,0,BOMB_DETONATOR,60}
};
static stock human_class_medik[][rang_picture] ={//special = восстановленное хп, special2 = время его перезарядки,special3 = перезярядка инъекции заражения
    { /*"Интерн",*/0,100,10/*rang_zmforkill*/,274,29,120,23,100,4,1,0,0,20,10,10},
    { /*"Научный сотрудник",*/1000,125,15/*rang_zmforkill*/,70,29,150,23,150,4,1,0,0,40,10,10},
    { /*"Кандинат медицинских наук",*/1500,150,20/*rang_zmforkill*/,70,29,180,23,180,4,1,0,0,60,10,10},
    { /*"Доктор медицинских наук",*/2000,175,25/*rang_zmforkill*/,70,29,210,23,210,4,1,0,0,80,10,10},
    { /*"Академик",*/3000,200,30/*rang_zmforkill*/,275,29,300,23,300,4,1,0,0,100,10,10}
};

static stock human_class_sniper[][rang_picture] ={//special2 = время перезарядки, special1 = время действия
    { /*"Капрал",*/0,100,10/*rang_zmforkill*/,165,33,50,23,100,4,1,0,0,20,90},//доделать и ниже
    { /*"Мичман",*/1000,125,15/*rang_zmforkill*/,128,33,75,23,150,4,1,0,0,30,80},
    { /*"Коммандер",*/1500,150,20/*rang_zmforkill*/,128,33,100,23,200,4,1,0,0,40,70},
    { /*"Бригадир",*/2000,175,25/*rang_zmforkill*/,128,34,50,23,250,4,1,0,0,50,60},
    { /*"Генерал-майор",*/3000,200,30/*rang_zmforkill*/,123,34,100,23,300,4,1,0,0,60,0}//время действия/время перезарядки
};
static stock human_class_defender[][rang_picture] ={//special - время действия, special2 - время мперезарядки
    { /*"Бомбардир",*/0,200,10/*rang_zmforkill*/,30,25,50,23,100,9,1,0,0,5/*Годмодтайм*/,60},
    { /*"Старшина",*/1000,225,15/*rang_zmforkill*/,29,25,75,23,150,9,1,0,0,6/*Годмодтайм*/,60},
    { /*"Поручик",*/1500,250,20/*rang_zmforkill*/,47,25,100,23,200,9,1,0,0,7/*Годмодтайм*/,60},
    { /*"Фельдмаршал",*/2000,275,25/*rang_zmforkill*/,48,25,150,23,250,9,1,0,0,8/*Годмодтайм*/,60},
    { /*"Генералиссимус",*/3000,300,30/*rang_zmforkill*/,46,25,200,23,300,9,1,0,0,10/*Годмодтайм*/,60}
};
static stock human_class_creater[][rang_picture] ={//special - кол-во объектов
    { /*"Подсобник",*/0,100,10/*rang_zmforkill*/,16,29,120,23,100,6,1,0,0,1},
    { /*"Ученик",*/1000,125,15/*rang_zmforkill*/,16,29,150,23,150,6,1,0,0,2},
    { /*"Мастер",*/1500,150,20/*rang_zmforkill*/,16,29,180,23,200,6,1,0,0,2},
    { /*"Бригадир",*/2000,175,25/*rang_zmforkill*/,16,29,210,23,250,6,1,0,0,3},
    { /*"Архитектор",*/3000,200,30/*rang_zmforkill*/,33,29,300,23,300,6,1,37,2000,3}
};
   /*Зомби*/
enum zombie_rang_picture{
	zm_rang_damage,
	zm_rang_health,
	zm_rang_zmforkill,
	zm_rang_skin,
	zm_rang_gun,
	zm_rang_ammo,
	zm_rang_special,
	zm_rang_special2,
}
static stock zombie_class_gromila[][zombie_rang_picture] ={
    { DAMAGE_LEVEL_3,200,20/*zmforkill*/,5,0,1,RED_MONITOR,60*4},
    { DAMAGE_LEVEL_3,250,25/*zmforkill*/,5,0,1,RED_MONITOR,(60*3)+30},
    { DAMAGE_LEVEL_3,300,30/*zmforkill*/,5,0,1,RED_MONITOR,60*3},
    { DAMAGE_LEVEL_3,350,35/*zmforkill*/,5,0,1,RED_MONITOR,(60*2)+30},
    { DAMAGE_LEVEL_3,400,40/*zmforkill*/,5,0,1,RED_MONITOR,60*2}
};
static stock zombie_class_jokey[][zombie_rang_picture] ={
    { DAMAGE_LEVEL_1,200,20/*zmforkill*/,78,4,1,RED_MONITOR,30},
    { DAMAGE_LEVEL_1,225,25/*zmforkill*/,78,4,1,RED_MONITOR,25},
    { DAMAGE_LEVEL_1,250,30/*zmforkill*/,78,4,1,RED_MONITOR,20},
    { DAMAGE_LEVEL_1,275,35/*zmforkill*/,78,4,1,RED_MONITOR,15},
    { DAMAGE_LEVEL_1,300,40/*zmforkill*/,78,4,1,RED_MONITOR,10}
};
static stock zombie_class_vedma[][zombie_rang_picture] ={//special - уровень заражения, special2 - время отката
    { DAMAGE_LEVEL_1,200,20/*zmforkill*/,75,9,1,ONE_HP,60*3},
    { DAMAGE_LEVEL_1,225,25/*zmforkill*/,75,9,1,ONE_HP,(60*2)+30},
    { DAMAGE_LEVEL_1,250,30/*zmforkill*/,75,9,1,TWO_HP,60*2},
    { DAMAGE_LEVEL_1,275,35/*zmforkill*/,75,9,1,TWO_HP,60+30},
    { DAMAGE_LEVEL_1,300,40/*zmforkill*/,75,9,1,THREE_HP,60}
};
static stock zombie_class_bumer[][zombie_rang_picture] ={//special - уровень заражения, special2 - время отката
    { DAMAGE_LEVEL_1,200,20/*zmforkill*/,79,5,1,ONE_HP,60},
    { DAMAGE_LEVEL_1,250,25/*zmforkill*/,79,5,1,ONE_HP,50},
    { DAMAGE_LEVEL_1,300,30/*zmforkill*/,79,5,1,TWO_HP,40},
    { DAMAGE_LEVEL_1,350,35/*zmforkill*/,79,5,1,TWO_HP,30},
    { DAMAGE_LEVEL_1,400,40/*zmforkill*/,79,5,1,THREE_HP,20}
};

//Удалить все бомбы с карты и сервера
stock Destroy_AllBombs()
{
	for(new bomb; bomb < Bombs_Counter; bomb++)
	{
		   if(Bomb_Time[bomb] == 0)continue;
		   Bomb_Time[bomb] = 0;
		   DestroyObject(Bomb_Object[bomb]);
	}
	Bombs_Counter = 0;
	for(new i, s_b = MaxID; i <= s_b; i ++)
	{
             Player_MyBombId[i] = -1;
	}
}

//взорвать бомбу
stock BangBomb(Bombid)
{
	//CreateExplosion(Bomb_X[Bombid],Bomb_Y[Bombid],Bomb_Z[Bombid],6,50.0);
	
	new Float: P[2];
	new Float:Ugol = 0.0;
	for(new i; i < 4; i++)
	{
               GetXYInFrontOfPoint(Bomb_X[Bombid], Bomb_Y[Bombid], P[0], P[1], Ugol, RAMPAGE_TANG_BANG_DIST);
               CreateExplosion(P[0], P[1],Bomb_Z[Bombid],RAMPAGE_TANG_BANG_TYPE,3.0);
               Ugol += 90.0;
	}
	
	DestroyObject(Bomb_Object[Bombid]);
	Bomb_Time[Bombid] = 0;
	for(new i, s_b = MaxID; i <= s_b; i ++)
	{
			 if(!IsPlayerConnected(i))continue;
             if(Player_MyBombId[i] == Bombid)
             {
                     Player_MyBombId[i] = -1;
             }
	}
}
stock GetXYInFrontOfPoint(Float:x, Float:y, &Float:x2, &Float:y2, Float:A, Float:distance)
{
    x2 = x + (distance * floatsin(-A, degrees));
    y2 = y + (distance * floatcos(-A, degrees));
}

//установить бомбу
stock SetBomb(playerid)
{
    ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.1,0,1,1,1000,1);
	new Float:P[4];
	GetPlayerPos(playerid,P[0],P[1],P[2]);
	GetPlayerFacingAngle(playerid,P[3]);
	GetXYInFrontOfPoint(P[0], P[1], Bomb_X[Bombs_Counter], Bomb_Y[Bombs_Counter], P[3], 1.3);
	Bomb_Z[Bombs_Counter] = P[2]-0.9;//фикс высоты бомбы
	Bomb_Object[Bombs_Counter] = CreateObject(1654,Bomb_X[Bombs_Counter],Bomb_Y[Bombs_Counter],Bomb_Z[Bombs_Counter],270.0,90.0,0);
	new rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
	Bomb_Time[Bombs_Counter] = human_class_shturmovik[rangid][rang_special];
	Player_MyBombId[playerid] = Bombs_Counter;
	Bombs_Counter++;
	Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] = human_class_shturmovik[rangid][rang_special2];
	SaveAccount(playerid);
	
	GameTextForPlayer(playerid,"~r~BOMB INSTALLED",3000,5);
	//на последнем ранге штурмовика тот может взрывать бомбу клавишой N
	if(rangid == 4)SendClientMessage(playerid,-1,""COL_RED"Нажмите кнопку N чтобы взорвать бомбу");
	else
	{
		  new str[80];
		  format(str,sizeof(str),""COL_RED"Бомба автоматически активируется через %d секунд(ы)",human_class_shturmovik[rangid][rang_special]);
		  SendClientMessage(playerid,-1,str);
	}
}

//Выдача комплекта к рангу: Скины
public GiveClassTeamSkin(playerid,teamid){
	new rangid;
    switch(teamid){
	      case ZOMBIE:{
		       rangid = Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]];
		       switch(Player_ZombieProfession[playerid])
		       {
                      case ZOMBIE_PROF_TANK:SetPlayerSkin(playerid,zombie_class_gromila[rangid][zm_rang_skin]);
				      case ZOMBIE_PROF_JOKEY:SetPlayerSkin(playerid,zombie_class_jokey[rangid][zm_rang_skin]);
				      case ZOMBIE_PROF_VEDMA:SetPlayerSkin(playerid,zombie_class_vedma[rangid][zm_rang_skin]);
				      case ZOMBIE_PROF_BUMER:SetPlayerSkin(playerid,zombie_class_bumer[rangid][zm_rang_skin]);
               }
          }
		  case HUMAN:{
			   rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
			   switch(Player_HumanProfession[playerid])
			   {
					case HUMAN_PROF_SHTURMOVIK:SetPlayerSkin(playerid,human_class_shturmovik[rangid][rang_skin]);
					case HUMAN_PROF_MEDIK:SetPlayerSkin(playerid,human_class_medik[rangid][rang_skin]);
					case HUMAN_PROF_SNIPER:SetPlayerSkin(playerid,human_class_sniper[rangid][rang_skin]);
					case HUMAN_PROF_DEFENDER:SetPlayerSkin(playerid,human_class_defender[rangid][rang_skin]);
					case HUMAN_PROF_CREATER:SetPlayerSkin(playerid,human_class_creater[rangid][rang_skin]);
	           }
          }
          case ADMIN:
          {
                SetPlayerSkin(playerid,ADMIN_SKIN);
          }
	}
	TogglePlayerControllable(playerid,1);
	return 1;
}
//Выдача комплекта к рангу: Оружие
public GiveClassTeamGun(playerid,teamid){
     ResetPlayerWeapons(playerid);
     new rangid;
	 switch(teamid){
		  case ZOMBIE:{
                rangid = Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]];
		        switch(Player_ZombieProfession[playerid]){
				      case ZOMBIE_PROF_TANK:GivePlayerWeapon(playerid,zombie_class_gromila[rangid][zm_rang_gun],zombie_class_gromila[rangid][zm_rang_ammo]);
				      case ZOMBIE_PROF_JOKEY:GivePlayerWeapon(playerid,zombie_class_jokey[rangid][zm_rang_gun],zombie_class_jokey[rangid][zm_rang_ammo]);
				      case ZOMBIE_PROF_VEDMA:GivePlayerWeapon(playerid,zombie_class_vedma[rangid][zm_rang_gun],zombie_class_vedma[rangid][zm_rang_ammo]);
				      case ZOMBIE_PROF_BUMER:GivePlayerWeapon(playerid,zombie_class_bumer[rangid][zm_rang_gun],zombie_class_bumer[rangid][zm_rang_ammo]);
		        }
		        if(Game_Started && MapGiveZombieGun[CurrentMap])GivePlayerWeapon(playerid,24,50000);
		  }
		  case HUMAN:{

			   rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
			   switch(Player_HumanProfession[playerid]){
					case HUMAN_PROF_SHTURMOVIK:{
                              GPW(playerid, human_class_shturmovik[rangid][rang_gun], human_class_shturmovik[rangid][rang_ammo]);
							  GPW(playerid, human_class_shturmovik[rangid][rang_gun2], human_class_shturmovik[rangid][rang_ammo2]);
							  GPW(playerid, human_class_shturmovik[rangid][rang_gun3], human_class_shturmovik[rangid][rang_ammo3]);
							  GPW(playerid, human_class_shturmovik[rangid][rang_gun4], human_class_shturmovik[rangid][rang_ammo4]);
					          /*
							  GPW(playerid,human_class_shturmovik[Player_HumanProfessionRang[playerid][rangid]][rang_gun],human_class_shturmovik[Player_HumanProfessionRang[playerid][rangid]][rang_ammo]);
							  GPW(playerid,human_class_shturmovik[Player_HumanProfessionRang[playerid][rangid]][rang_gun2],human_class_shturmovik[Player_HumanProfessionRang[playerid][rangid]][rang_ammo2]);
							  GPW(playerid,human_class_shturmovik[Player_HumanProfessionRang[playerid][rangid]][rang_gun3],human_class_shturmovik[Player_HumanProfessionRang[playerid][rangid]][rang_ammo3]);
							  GPW(playerid,human_class_shturmovik[Player_HumanProfessionRang[playerid][rangid]][rang_gun4],human_class_shturmovik[Player_HumanProfessionRang[playerid][rangid]][rang_ammo4]);
							  */
					}
					case HUMAN_PROF_MEDIK:{
                              GPW(playerid, human_class_medik[rangid][rang_gun], human_class_medik[rangid][rang_ammo]);
							  GPW(playerid, human_class_medik[rangid][rang_gun2], human_class_medik[rangid][rang_ammo2]);
							  GPW(playerid, human_class_medik[rangid][rang_gun3], human_class_medik[rangid][rang_ammo3]);
							  GPW(playerid, human_class_medik[rangid][rang_gun4], human_class_medik[rangid][rang_ammo4]);
							  /*
						      GPW(playerid,human_class_medik[Player_HumanProfessionRang[playerid][rangid]][rang_gun],human_class_medik[Player_HumanProfessionRang[playerid][rangid]][rang_ammo]);
							  GPW(playerid,human_class_medik[Player_HumanProfessionRang[playerid][rangid]][rang_gun2],human_class_medik[Player_HumanProfessionRang[playerid][rangid]][rang_ammo2]);
							  GPW(playerid,human_class_medik[Player_HumanProfessionRang[playerid][rangid]][rang_gun3],human_class_medik[Player_HumanProfessionRang[playerid][rangid]][rang_ammo3]);
							  GPW(playerid,human_class_medik[Player_HumanProfessionRang[playerid][rangid]][rang_gun4],human_class_medik[Player_HumanProfessionRang[playerid][rangid]][rang_ammo4]);
							  */
					}
					case HUMAN_PROF_SNIPER:{
							  GPW(playerid, human_class_sniper[rangid][rang_gun], human_class_sniper[rangid][rang_ammo]);
							  GPW(playerid, human_class_sniper[rangid][rang_gun2], human_class_sniper[rangid][rang_ammo2]);
							  GPW(playerid, human_class_sniper[rangid][rang_gun3], human_class_sniper[rangid][rang_ammo3]);
							  GPW(playerid, human_class_sniper[rangid][rang_gun4], human_class_sniper[rangid][rang_ammo4]);
							  /*
                              GPW(playerid,human_class_sniper[Player_HumanProfessionRang[playerid][rangid]][rang_gun],human_class_sniper[Player_HumanProfessionRang[playerid][rangid]][rang_ammo]);
							  GPW(playerid,human_class_sniper[Player_HumanProfessionRang[playerid][rangid]][rang_gun2],human_class_sniper[Player_HumanProfessionRang[playerid][rangid]][rang_ammo2]);
							  GPW(playerid,human_class_sniper[Player_HumanProfessionRang[playerid][rangid]][rang_gun3],human_class_sniper[Player_HumanProfessionRang[playerid][rangid]][rang_ammo3]);
							  GPW(playerid,human_class_sniper[Player_HumanProfessionRang[playerid][rangid]][rang_gun4],human_class_sniper[Player_HumanProfessionRang[playerid][rangid]][rang_ammo4]);
							  */
					}
					case HUMAN_PROF_DEFENDER:{
                              GPW(playerid, human_class_defender[rangid][rang_gun], human_class_defender[rangid][rang_ammo]);
							  GPW(playerid, human_class_defender[rangid][rang_gun2], human_class_defender[rangid][rang_ammo2]);
							  GPW(playerid, human_class_defender[rangid][rang_gun3], human_class_defender[rangid][rang_ammo3]);
							  GPW(playerid, human_class_defender[rangid][rang_gun4], human_class_defender[rangid][rang_ammo4]);
					          /*
						      GPW(playerid,human_class_defender[Player_HumanProfessionRang[playerid][rangid]][rang_gun],human_class_defender[Player_HumanProfessionRang[playerid][rangid]][rang_ammo]);
							  GPW(playerid,human_class_defender[Player_HumanProfessionRang[playerid][rangid]][rang_gun2],human_class_defender[Player_HumanProfessionRang[playerid][rangid]][rang_ammo2]);
							  GPW(playerid,human_class_defender[Player_HumanProfessionRang[playerid][rangid]][rang_gun3],human_class_defender[Player_HumanProfessionRang[playerid][rangid]][rang_ammo3]);
							  GPW(playerid,human_class_defender[Player_HumanProfessionRang[playerid][rangid]][rang_gun4],human_class_defender[Player_HumanProfessionRang[playerid][rangid]][rang_ammo4]);
							  */
					}
					case HUMAN_PROF_CREATER:{
                              GPW(playerid, human_class_creater[rangid][rang_gun], human_class_creater[rangid][rang_ammo]);
							  GPW(playerid, human_class_creater[rangid][rang_gun2], human_class_creater[rangid][rang_ammo2]);
							  GPW(playerid, human_class_creater[rangid][rang_gun3], human_class_creater[rangid][rang_ammo3]);
							  GPW(playerid, human_class_creater[rangid][rang_gun4], human_class_creater[rangid][rang_ammo4]);
                              /*
                              GPW(playerid,human_class_creater[Player_HumanProfessionRang[playerid][rangid]][rang_gun],human_class_creater[Player_HumanProfessionRang[playerid][rangid]][rang_ammo]);
							  GPW(playerid,human_class_creater[Player_HumanProfessionRang[playerid][rangid]][rang_gun2],human_class_creater[Player_HumanProfessionRang[playerid][rangid]][rang_ammo2]);
							  GPW(playerid,human_class_creater[Player_HumanProfessionRang[playerid][rangid]][rang_gun3],human_class_creater[Player_HumanProfessionRang[playerid][rangid]][rang_ammo3]);
							  GPW(playerid,human_class_creater[Player_HumanProfessionRang[playerid][rangid]][rang_gun4],human_class_creater[Player_HumanProfessionRang[playerid][rangid]][rang_ammo4]);
							  */
					}
			   }
			   //ЕЩЕ ВЫДАТЬ ВИП ПУШКИ
			   GiveShopGuns(playerid);
		  }
	 }
	 return 1;
}
//узнать цену ранга
stock GetRangMoneyPrice(teamid,profess,rang){
	new val;
	switch(teamid){
	      case ZOMBIE:val = 0;
		  case HUMAN:{
			   switch(profess){
					case HUMAN_PROF_SHTURMOVIK:val = human_class_shturmovik[rang][rang_price];
					case HUMAN_PROF_MEDIK:val = human_class_medik[rang][rang_price];
					case HUMAN_PROF_SNIPER:val = human_class_sniper[rang][rang_price];
					case HUMAN_PROF_DEFENDER:val = human_class_defender[rang][rang_price];
					case HUMAN_PROF_CREATER:val = human_class_creater[rang][rang_price];
	           }
          }
	}
	return val;
}
//узнать макс.хп ранга
stock GetMaxRangHealth(teamid,profess,rang){
	new val;
	switch(teamid){
	      case ZOMBIE:{
		       switch(profess) {
                      case ZOMBIE_PROF_TANK:val =  zombie_class_gromila[rang][zm_rang_health];
				      case ZOMBIE_PROF_JOKEY:val = zombie_class_jokey[rang][zm_rang_health];
				      case ZOMBIE_PROF_VEDMA:val = zombie_class_vedma[rang][zm_rang_health];
				      case ZOMBIE_PROF_BUMER:val = zombie_class_bumer[rang][zm_rang_health];
               }
          }
		  case HUMAN:{
			   switch(profess) {
					case HUMAN_PROF_SHTURMOVIK:val = human_class_shturmovik[rang][rang_health];
					case HUMAN_PROF_MEDIK:val = human_class_medik[rang][rang_health];
					case HUMAN_PROF_SNIPER:val = human_class_sniper[rang][rang_health];
					case HUMAN_PROF_DEFENDER:val = human_class_defender[rang][rang_health];
					case HUMAN_PROF_CREATER:val = human_class_creater[rang][rang_health];
	           }
          }
	}
	return val;
}
//Улучшение ранга зомби
stock UpgradeZombieRang(playerid,newrang){
     //if(Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] >= 4)return 1;
     Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] = newrang;
     GameTextForPlayer(playerid,"~g~New rank!",3000,5);
     new str[128];
     format(str,sizeof(str),""COL_EASY"Новый ранг! Уровень зомби в профессии \"%s\" успешно повышен до %d",GetProfName(ZOMBIE,Player_ZombieProfession[playerid]),newrang);
     SendClientMessage(playerid,-1,str);
     Player_ZombieRangSkill[playerid][Player_ZombieProfession[playerid]] = 0;
	 Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] = 0;
     SaveAccount(playerid);
     if(Game_Started){
     if(S[playerid] != 2)return 1;
     if(Player_CurrentTeam[playerid] != ZOMBIE)return 1;
     SetPlayerHealthEx(playerid,GetMaxRangHealth(ZOMBIE,Player_ZombieProfession[playerid],Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]])+Player_Z_DopHealth[playerid][Player_ZombieProfession[playerid]] );
     GiveClassTeamSkin(playerid,ZOMBIE);
     GiveClassTeamGun(playerid,ZOMBIE);
     }
	 return 1;
}
//улучшение людского ранга
stock UpgradeHumanRang(playerid,newrang){
      //if(Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] >= 4)return 1;
      Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] = newrang;
      GameTextForPlayer(playerid,"~g~New rank!",3000,5);
      new str[128];
      format(str,sizeof(str),""COL_EASY"Новый ранг! Вы были повышены до звания %s в вашей профессии",GetRangName(HUMAN,Player_HumanProfession[playerid],newrang),newrang);
      SendClientMessage(playerid,-1,str);
      Player_HumanRangSkill[playerid][Player_HumanProfession[playerid]] = 0;
      Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] = 0;
      Medik_ResetHealthTime[playerid] = 0;
      SaveAccount(playerid);
      if(S[playerid] != 2)return 1;
      if(Player_CurrentTeam[playerid] != HUMAN)return 1;
      SetPlayerHealthEx(playerid,GetMaxRangHealth(HUMAN,Player_HumanProfession[playerid],Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]])+Player_H_DopHealth[playerid][Player_HumanProfession[playerid]] );
      GiveClassTeamSkin(playerid,HUMAN);
      if(Game_Started)GiveClassTeamGun(playerid,HUMAN);
	  return 1;
}
//смена профессии
stock SwitchProfession(playerid,teamid,profid){
	  switch(teamid){
		   case HUMAN:{
                Player_HumanProfession[playerid] = profid;
                ReturnDefenderOldHP(playerid);
                if(Player_CurrentTeam[playerid] == HUMAN)SetPlayerHealthEx(playerid,GetMaxRangHealth(HUMAN,Player_HumanProfession[playerid],Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]])+Player_H_DopHealth[playerid][Player_HumanProfession[playerid]]);
                FixHumanRang(playerid);
                Player_H_HaveProfession[playerid][profid] = true;
                SaveAccount(playerid);
                if(S[playerid] != 2)return 1;
                if(Player_CurrentTeam[playerid] == HUMAN){
                      GiveClassTeamSkin(playerid,HUMAN);
                      if(!Game_Started)return 1;
                      GiveClassTeamGun(playerid,HUMAN);
			          
                }
		   }
		   case ZOMBIE:{

                Player_ZombieProfession[playerid] = profid;
                if(Player_CurrentTeam[playerid] == ZOMBIE)SetPlayerHealthEx(playerid,GetMaxRangHealth(ZOMBIE,Player_ZombieProfession[playerid],Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]])+Player_Z_DopHealth[playerid][Player_ZombieProfession[playerid]]);
                Player_Z_HaveProfession[playerid][profid] = true;
                SaveAccount(playerid);
                if(!Game_Started)return 1;
                if(S[playerid] != 2)return 1;
                if(Player_CurrentTeam[playerid] == ZOMBIE){
                     GiveClassTeamSkin(playerid,ZOMBIE);
                     GiveClassTeamGun(playerid,ZOMBIE);
			         
			    }
		   }
		   default: return 1;
      }
	  return 1;
}

//проверка людского ранга
stock FixHumanRang(playerid){
     new neededexp = NEED_EXP_UMNOZHITEL*(Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]+1);
	 new exp = Player_HumanRangSkill[playerid][Player_HumanProfession[playerid]];
	 if(exp >= neededexp && Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] < 4)UpgradeHumanRang(playerid,Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] + 1);
	 return 1;
}
//проверка зомборанга
stock FixZombieRang(playerid){
	 new neededexp = NEED_EXP_UMNOZHITEL*(Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]+1);
	 new exp = Player_ZombieRangSkill[playerid][Player_ZombieProfession[playerid]];
	 if(exp >= neededexp && Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] < 4)UpgradeZombieRang(playerid,Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] + 1);
	 return 1;
}

//Удалить все ящики всех строителей из всех мест в т.ч из памяти сервера
stock DestroyObjects(){
	   if(Server_Objects == 0)return 1;
	   for(new i; i <  Server_Objects; i++){
	         DestroyObject(Object[i]);
	         if(IsPlayerConnected(i))Object_idx[i] = 0;
	   }
	   Server_Objects = 0;
       return 1;
}
//строитель создает объект
stock PlayerCreateObject(playerid){
	   if(Object_idx[playerid] >= MAX_PLAYER_OBJECTS)return 1;
	   new Float: P[3];
	   GetPlayerPos(playerid,P[0],P[1],P[2]);
	   ClearAnimations(playerid);
	   SetPlayerVelocity(playerid,0.0,0.0,1.3);
       Object[Server_Objects] = CreateObject(1558,P[0],P[1],P[2],0.0,0.0,0.0);
       
       //AC_SetPlayerPos(playerid,P[0],P[1],P[2]+1.5);
       
       GameTextForPlayer(playerid,"~g~Object Created",2000,5);
       PlayerPlaySound(playerid,1137,0.0,0.0,0.0);
       Object_idx[playerid] ++;
       Server_Objects ++;
       return 1;
}


forward GiveClassTeamGun(playerid,teamid);
forward GiveClassTeamSkin(playerid,teamid);
forward Central_Processor();

//убить инфекцию
stock KillInfection(playerid){
	if(Player_IL[playerid] == NONE)return 1;
	Player_IL[playerid] = NONE;
	TextDrawHideForPlayer(playerid,RedScreenBox);
	SetPlayerDrunkLevel(playerid,0);
	__InfectText__RemoveLabelText(playerid);
	return 1;
}

//отправка в лобби
forward GoToHome(playerid);
public GoToHome(playerid)
{
    Player_InMarker[playerid] = true;
    if(Game_Started)survaivors++;
    DisablePlayerCheckpoint(playerid); // Удалить чекпоинт убежища
    ResetPlayerWeapons(playerid);
    SetPlayerSpawnInArea(playerid,-1);// установка спавна на лобби
    
    GiveClassTeamSkin(playerid,HUMAN);
    SetPlayerInterior(playerid,Home_Interior);
    AC_SetPlayerPos(playerid,Home_Pos[0],Home_Pos[1],Home_Pos[2]);
    SetPlayerFacingAngle(playerid,Home_Pos[3]);
    SetPlayerVirtualWorld(playerid,Home_VW);
    SetCameraBehindPlayer(playerid);
    KillInfection(playerid);
    ShowPlayer(playerid);
    FixInviseblePlayers(playerid);
    SetPlayerHealthEx(playerid,GetMaxRangHealth(HUMAN,Player_HumanProfession[playerid],Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]])+Player_H_DopHealth[playerid][Player_HumanProfession[playerid]]);
	return 1;
}
//отправка на карту
forward GoToArena(playerid,arenaid);
public GoToArena(playerid,arenaid)
{
    //выкинуть админа из спека если тот в нем
    //if(gSpectateID[playerid] != -1)OnPlayerCommandText(playerid, "/specoff");
    ShowPlayer(playerid);
    if(Player_CurrentTeam[playerid] != ADMIN)
    {
       //если игрок не началась и игрок не на работе администратора, то сделать человеком
       if(!Game_Started )Player_CurrentTeam[playerid] = HUMAN;
       //если игра началась, но заражения еще нет и игрок не на работе администратора, то сделать человеком
       if((Game_Started && Infection_Time > 0)) Player_CurrentTeam[playerid] = HUMAN;
       //если игра началась, заражение тоже, игрок не в убежище и не на работе администратора, то сделать зомби
       if(((Game_Started && Infection_Time == 0) && !Player_InMarker[playerid]))Player_CurrentTeam[playerid] = ZOMBIE;
	}
	SetPlayerSpawnInArea(playerid,arenaid); // установка спавна
	switch (Player_CurrentTeam[playerid]){
		 case ZOMBIE:{
		 SetZombie(playerid);
		 }
		 case HUMAN:{
		         SetHuman(playerid);
                 if(Player_InMarker[playerid] || !Game_Started){//если игрок в укрытии или игра не начата
						//телепорт в укрытиe
						GoToHome(playerid);
						return 1;
                 }
		 }
		 case ADMIN:
		 {
		         HideAdmin(playerid);
		         SetAdmin(playerid);
		         if(Player_InMarker[playerid] || !Game_Started){//если игрок в укрытии или игра не начата
						  //телепорт в укрытиe
						  GoToHome(playerid);
						  return 1;
                 }
         }
	}
	//отправка на карту
	SetPlayerInterior(playerid,MapInterior[arenaid]);
	AC_SetPlayerPos(playerid,MapSpawnPos[arenaid][0],MapSpawnPos[arenaid][1],MapSpawnPos[arenaid][2]);
	SetPlayerFacingAngle(playerid,MapSpawnPos[arenaid][3]);
	SetPlayerVirtualWorld(playerid,0);
	SetCameraBehindPlayer(playerid);
	//АНТИ-ПРОВАЛ ПОД ТЕКСТУРЫ
    SetPVarInt(playerid,"ProtectTime",SPAWN_PROTECT);
    TogglePlayerControllable(playerid,0);
	return 1;
}

// Установить спавн игрока на арене
// -1 = установка спавна на убежище
stock SetPlayerSpawnInArea(playerid,arenaid)
{//ACInfo[playerid][RealSkinID]
	if( arenaid == -1)
	{
	    SetSpawnInfo(playerid,0,1,Home_Pos[0],Home_Pos[1],Home_Pos[2],Home_Pos[3],0,0,0,0,0,0);
	    return 1;
	}
    SetSpawnInfo(playerid,0,1,MapSpawnPos[arenaid][0],MapSpawnPos[arenaid][1],MapSpawnPos[arenaid][2],MapSpawnPos[arenaid][3],0,0,0,0,0,0);// Установка спавна
	return 1;
}

stock SetAdmin(playerid)
{
     ResetPlayerWeapons(playerid);
     KillInfection(playerid);
     SetPlayerHealthEx(playerid,50000);
     SetPlayerTeam(playerid,ADMIN);
     SetPlayerSkin(playerid,ADMIN_SKIN);
     SetPlayerColor(playerid,ADMIN_COLOR);
     GivePlayerWeapon(playerid,24,50000);
     Player_CurrentTeam[playerid] = ADMIN;
	 return 1;
}

stock SetHuman(playerid){
	 //if(Player_CurrentTeam[playerid] != ZOMBIE)return 1;
	 ReturnDefenderOldHP(playerid);//если игрок был в режиме бессмертия защитника
	 SetPlayerHealthEx(playerid,GetMaxRangHealth(HUMAN,Player_HumanProfession[playerid],Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]])+Player_H_DopHealth[playerid][Player_HumanProfession[playerid]]);
	 Player_CurrentTeam[playerid] = HUMAN;
     GiveClassTeamSkin(playerid,HUMAN);
     GiveClassTeamGun(playerid,HUMAN);
     SetPlayerTeam(playerid,HUMAN);
	 SetPlayerColor(playerid,HUMAN_COLOR);
	 FixInviseblePlayers(playerid);
	 KillInfection(playerid);
	 return 1;
}

stock SetZombie(playerid){
     //if(Player_CurrentTeam[playerid] != HUMAN)return 1;
     ReturnDefenderOldHP(playerid);//если игрок был в режиме бессмертия защитника
     SetPlayerHealthEx(playerid,GetMaxRangHealth(ZOMBIE,Player_ZombieProfession[playerid],Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]])+Player_Z_DopHealth[playerid][Player_ZombieProfession[playerid]]);
	 Player_CurrentTeam[playerid] = ZOMBIE;
     GiveClassTeamSkin(playerid,ZOMBIE);
     GiveClassTeamGun(playerid,ZOMBIE);
     KillInfection(playerid);
     SetPlayerTeam(playerid,ZOMBIE);
     SetPlayerColor(playerid,ZOMBIE_COLOR);
     ShowPlayer(playerid);
     FixInviseblePlayers(playerid);
	 return 1;
}

stock IsPlayerInWater(playerid){
    new animlib[32],tmp[32];
    GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,tmp,32);
    if( !strcmp(animlib, "SWIM") && !IsPlayerInAnyVehicle(playerid) ) return true;
    return false;
}




forward RandomInfected();
public RandomInfected()
{
    //ПРОЦЕСС ВЫБОРА ЗОМБИ
    new NormalPlayer[MAX_PLAYERS] = -1;//Тут будут идентификаторы "нормальных" игроков
    new NormalPlayersCounter = 0;//Сколько всего нормальных игроков
	new ZombiInFutute = -1;//переменная для ид будущего зомби
    for(new i, s_b = MaxID; i <= s_b; i++)
    {
			if(!IsPlayerConnected(i) || S[i] == 0)continue;//пустые нам не нужны
			if(Player_CurrentTeam[i] != HUMAN || !PlayerNoAFK[i] )continue;//нелюди с сонями тоже
            NormalPlayer[NormalPlayersCounter] = i;//запишем ид нормального игрока в псевдо-массив
			NormalPlayersCounter ++;//запишем его наличие
    }
    ZombiInFutute = random(NormalPlayersCounter);//методом рандома выберем будущего зомби
    SetZombie(NormalPlayer[ZombiInFutute]);//Сделаем бедолагу зомби
    GameTextForPlayer(NormalPlayer[ZombiInFutute],"~r~Infected",3000,4);//напомним ему об его участи
    //Конец ПРОЦЕССА
    ReCountPlayers();
    return 1;
}

forward ReCountPlayers();

public ReCountPlayers()
{
     Humans = 0;
     Zombies = 0;
     new result;
	 for(new i, s_b = MaxID; i <= s_b; i++)
	 {
	       if(!IsPlayerConnected(i) || S[i] == 0)continue;//пустой игрок не нужен
	       if( !PlayerNoAFK[i] ) continue; // сони не нужны
	       if((Player_CurrentTeam[i] == ADMIN))continue;//Админы не нужны

		   if(Player_CurrentTeam[i] == HUMAN) Humans++;
	       else Zombies ++;
	 }
	 result = Humans + Zombies;
	 if(Game_Started && CountForNextArena == 0)//если игра начата + нет отсчета до след арены, то
	 {
			if(result < 2)return EndArena(END_REASON_LILTE_PLAYER);//мало игроков
			else if(Humans == 0)return EndArena(END_REASON_ZOMBIE_WIN);//Зомби победили
			if(Zombies == 0 && (Game_Started == true && Infection_Time == 0)){//зомби повыходили наверное
				 //Начать заражение немедленно!
				 if(!MarkerActiv){
				     SendClientMessageToAll(COLOR_RED,"Заражение начинается!");
				     RandomInfected();
				 }
			}
			/*
			if(!MarkerActiv || Infection_Time == 0)return 1;
			if(Zombies == 0){//зомби повыходили наверное
				     //Начать заражение немедленно!
				     SendClientMessageToAll(COLOR_RED,"Заражение начинается!");
				     RandomInfected();
				     return 1;
			}
			*/
	        //если зомби меньше указанного процента от всех людей то начать заражение
	        if( Zombies < floatround((Humans / 100.0)*INFECTED_PROCENT)  && Infection_Time == 0)RandomInfected();
	 }
	 if(!Game_Started && CountForNextArena == 0){//игра в режиме ожидания игроков
			if(result > 1)StartArena(NextArenaId);//заменить на стартарена •
	 }
	 return 1;
}

forward StartArena(arenaid);
public StartArena(arenaid)
{
	 if(Loaded_Maps <= arenaid)return 1;//nextarena
	 new str[128];
	/*
	 if( OldMap != -1)
     {
	 	format(str,sizeof(str), "unloadfs %s", MapFS[OldMap]);
 	    SendRconCommand(str);
	 }
	 */
	
	 // Грузить карту
	 if( CurrentMap == -1)
	 {
		 format(str,sizeof(str), "loadfs %s", MapFS[arenaid]);
		 SendRconCommand(str);
	 }
	 //
	 
	 CurrentMap = arenaid;
	 Infection_Time = INFECTION_TIME;
	 Game_Started = true;
	 CountForEndArena = ROUND_TIME;
	 

	 SetWorldTime(24);
	 SetWeather(0);

	 format(str,sizeof(str),"Арена \"%s\" начинается!\nЗаражение начнется через %d секунд",MapName[arenaid],INFECTION_TIME);
	 //WriteLog(LOG_FILE,str);//CHAT_LOG,REG_LOG,LOG_FILE,KILL_LOG_FILE
	 SendClientMessageToAll(COLOR_GREEN,str);
	 for(new i, s_b = MaxID; i <= s_b; i++)
	 {
	 	       if(!IsPlayerConnected(i))continue;
	           if(S[i] == 0)continue;
	           Player_InMarker[i] = false;
	           //TimeForKill[i] = 0;
			   ShowPlayer(i);
	           SpawnPlayer(i);
	           //PlayerPlaySound(i, 1068, 0, 0, 0);
	 }
	 ClearDeathMessages();
	 format(str,sizeof(str),"mapname %s",MapName[arenaid]);
	 SendRconCommand(str);
	 GameTextForAll(MapName[arenaid],3000,1);
	 NextArenaGen();
	 return 1;
}

//Скрыть сообщение о победе кого-лиюол
forward HideInfoWin();
public HideInfoWin()
{
     TextDrawHideForAll(HumansWin);
	 TextDrawHideForAll(ZombiesWin);
}

//Награда выжевшему
stock SurvivorEffect(playerid)
{
	new str[100];
    Player_Zm[playerid] += ZM_FOR_SUVRIVOR;
    
    format(str,sizeof(str),"%s получил %d ZM за выживание",GetName(playerid),ZM_FOR_SUVRIVOR);
    WriteLog(MONEYLOG,str);
    
    format(str,sizeof(str),"Вы сумели спастись. Вам была дана награда в размере "COL_VALUE"%d ZM",ZM_FOR_SUVRIVOR);
    SendClientMessage(playerid,COLOR_GREEN,str);
    GameTextForPlayer(playerid,"~y~SURVIVOR",3000,1);
    SaveAccount(playerid);
    PlayerPlaySound(playerid,RandomValue(36202,36205),0,0,0);
    return 1;
}

//Доделать стартарену - готво
//if(!Game_Started && CountForNextArena > 0) это период отсчета
forward EndArena(reason);
public EndArena(reason){
	 new str[128];
	 switch(reason){
		 case END_REASON_LILTE_PLAYER:{
			   SendClientMessageToAll(COLOR_GRAY,""COL_ORANGE"Матч был остановлен. "COL_VALUE"Причина: Не хватает игроков для продолжения");
			   SendClientMessageToAll(COLOR_YELLOW,"Игра не начнется пока не наберется минимум "COL_VALUE"2 игрока");
			   GameTextForAll("~b~The match was stopped",3000,1);
			   //WriteLog(LOG_FILE,"Матч был остановлен. Причина: Не хватает игроков для продолжения");
		 }
		 case END_REASON_ADMIN_STOP:{
			   SendClientMessageToAll(COLOR_GRAY,""COL_ORANGE"Матч был остановлен администратором");
			   format(str,sizeof(str),"Следующая карта начнется через "COL_VALUE"%d секунд",COUNT_FOR_NEXTARENA);
			   SendClientMessageToAll(COLOR_GREEN,str);
			   CountForNextArena = COUNT_FOR_NEXTARENA;
			   GameTextForAll("~w~The match was stopped an admin",3000,1);
			   //WriteLog(LOG_FILE,"Матч был остановлен администратором");
		 }
		 case END_REASON_ZOMBIE_WIN:{
			   SendClientMessageToAll(COLOR_YELLOW,""COL_ORANGE"Зомби победили!");
			   format(str,sizeof(str),"Следующая карта начнется через "COL_VALUE"%d секунд",COUNT_FOR_NEXTARENA);
			   SendClientMessageToAll(COLOR_GREEN,str);
			   CountForNextArena = COUNT_FOR_NEXTARENA;
			   //GameTextForAll("~p~ZOMBIE WIN",3000,1);
			   TextDrawShowForAll(ZombiesWin);
			   SetTimer("HideInfoWin",INFO_WIN_SHOW_TIME,0);
			   //WriteLog(LOG_FILE,"Зомби победили!");
		 }
		 case END_REASON_TIME_LEFT:{
			   if(MapHaveMarker[CurrentMap]){//если карта имеет маркер
			       for(new i, s_b = MaxID; i <= s_b; i++){
                        if(!IsPlayerConnected(i) || S[i] == 0)continue;
                        if(!Player_InMarker[i])continue;
					    SurvivorEffect(i);
			       }
			       if(survaivors == 0){
                        SendClientMessageToAll(COLOR_YELLOW,"Никто из людей не смог спастись! "COL_ORANGE"Зомби победили");
                        format(str,sizeof(str),"Следующая карта начнется через "COL_VALUE"%d секунд",COUNT_FOR_NEXTARENA);
			            SendClientMessageToAll(COLOR_GREEN,str);
			            //GameTextForAll("~p~ZOMBIE WIN",3000,1);
			            TextDrawShowForAll(ZombiesWin);
			            SetTimer("HideInfoWin",INFO_WIN_SHOW_TIME,0);
                        //WriteLog(LOG_FILE,"Никто из людей не смог спастись! Зомби победили");
			       }
				   else{
                        SendClientMessageToAll(COLOR_GREEN,"Среди людей есть спасенные. "COL_ORANGE"Победа людей!");
				        format(str,sizeof(str),"Следующая карта начнется через "COL_VALUE"%d секунд",COUNT_FOR_NEXTARENA);
			            SendClientMessageToAll(COLOR_GREEN,str);
			            //GameTextForAll("~y~HUMANS WIN",3000,1);
			            TextDrawShowForAll(HumansWin);
			            SetTimer("HideInfoWin",INFO_WIN_SHOW_TIME,0);
				        //WriteLog(LOG_FILE,"Среди людей есть спасенные. Победа людей!");
				   }
			   }
			   else{
			       for(new i, s_b = MaxID; i <= s_b; i++){
                        if(!IsPlayerConnected(i) || S[i] == 0)continue;
                        if(Player_CurrentTeam[i] != HUMAN)continue;
					    SurvivorEffect(i);
			       }
				   SendClientMessageToAll(COLOR_GREEN,"Среди людей есть выжившие. "COL_ORANGE"Победа людей!");
				   format(str,sizeof(str),"Следующая карта начнется через "COL_VALUE"%d секунд",COUNT_FOR_NEXTARENA);
			       SendClientMessageToAll(COLOR_GREEN,str);
			       //GameTextForAll("~y~HUMANS WIN",3000,1);
			       TextDrawShowForAll(HumansWin);
                   SetTimer("HideInfoWin",INFO_WIN_SHOW_TIME,0);
				   //WriteLog(LOG_FILE,"Среди людей есть выжившие. Победа людей!");
			   }
			   CountForNextArena = COUNT_FOR_NEXTARENA;
		 }
	 }
	 Infection_Time = 0;
	 MarkerActiv = false;
	 Game_Started = false;
	 CountForEndArena = 0;
	 survaivors = 0;
     for(new i, s_b = MaxID; i <= s_b; i++){
		   if(!IsPlayerConnected(i))continue;
		   if(S[i] == 0)continue;
		   KillInfection(i);
		   //SetHuman(i);
		   //TimeForKill[i] = 0;
		   Object_idx[i] = 0;
		   ReturnDefenderOldHP(i);
		   if(S[i] != 2)
		   {
		        if(S[i] == -1)
		        {
		        	//SetPlayerSpawnInArea(i,-1);
		        	SpawnPlayer(i);
		        }
		   		continue;
   		   }
		   if(Player_CurrentTeam[i] != ADMIN)SetHuman(i);
		   GoToHome(i);
     }
	 SendRconCommand("mapname Lobby");
     TextDrawsStd();
     DestroyObjects();
     Destroy_AllBombs();

     // Выгрузить карту
     if( CurrentMap != -1)
     {
	 	format(str,sizeof(str), "unloadfs %s", MapFS[CurrentMap]);
 	    SendRconCommand(str);
	 }

	// OldMap = CurrentMap;
	 //
     CurrentMap = -1;
     //NextArenaGen();
	 return 1;
}
stock RandomValue(value1, value2)
{
    new randval = random(value2-value1) + value1;
    return randval;
}

stock HexToInt(sctring[])
{
  if (sctring[0]==0) return 0;
  new i;
  new cur=1;
  new res=0;
  for (i=strlen(sctring);i>0;i--) {
    if (sctring[i-1]<58) res=res+cur*(str[i-1]-48); else res=res+cur*(sctring[i-1]-65+10);
    cur=cur*16;
  }
  return res;
}

// Нанесение урона одного игрока другому
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
				  //new str[128];
				 //format(str, sizeof(str), "OnPlayerTakeDamage = playerid(%d), issuerid(%d), Float:amount(%.f), weaponid(%d)",playerid, issuerid, amount, weaponid);
				  //SendClientMessageToAll(-1,str);
				  if(S[playerid] != 2) return 1;
				  if(Player_CurrentTeam[playerid] == ADMIN)return 1; // Админ бессмертен
				  if(issuerid == 65535)
				  {
				        if( weaponid == 54 && amount > 137 ) Player_RHealth[playerid] = 0;
				        else Player_RHealth[playerid] -= floatround(amount,floatround_ceil);
				    	if( Player_RHealth[playerid] < 1) {
							SetPlayerHealthEx(playerid, 0);
							OnPlayerKilledPlayer(playerid, issuerid, weaponid);
						}
                  		UpdateHealthOnHead(playerid);
				  }
                  
	              return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid)
{
    //new str[128];
    //format(str, sizeof(str), "OnPlayerGiveDamage = playerid(%d), damagedid(%d), Float:amount(%.f), weaponid(%d)",playerid, damagedid, amount, weaponid);
	//SendClientMessageToAll(-1,str);
	
    new rangid;
    if(S[damagedid] != 2) return 1;
    if(Player_CurrentTeam[damagedid] == ADMIN)return 1; // Админ бессмертен
    if(damagedid != INVALID_PLAYER_ID)
    {
	    if(GetPlayerTeam(playerid) != GetPlayerTeam(damagedid))
	    {
					      Player_RHealth[damagedid] -= floatround(amount,floatround_ceil);
	                      if(Player_CurrentTeam[playerid] == ZOMBIE/* && (weaponid == 0 || weaponid == 5||  weaponid == 4)*/)
	                      {
	                                 rangid = Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]];
		                             switch(Player_ZombieProfession[playerid])
									 {
	                      					case ZOMBIE_PROF_TANK: Player_RHealth[damagedid]-=(zombie_class_gromila[rangid][zm_rang_damage] + random(PRIDATOK_RANDOM));
					      					case ZOMBIE_PROF_JOKEY:Player_RHealth[damagedid]-=(zombie_class_jokey[rangid][zm_rang_damage] + random(PRIDATOK_RANDOM));
					      					case ZOMBIE_PROF_VEDMA:Player_RHealth[damagedid]-=(zombie_class_vedma[rangid][zm_rang_damage] + random(PRIDATOK_RANDOM));
					      					case ZOMBIE_PROF_BUMER:Player_RHealth[damagedid]-=(zombie_class_bumer[rangid][zm_rang_damage] + random(PRIDATOK_RANDOM));
	               					 }
	                      }
	    }
	    if( Player_RHealth[damagedid] < 1) {
			SetPlayerHealthEx(damagedid, 0);
			OnPlayerKilledPlayer(damagedid, playerid, weaponid);
		}
	    UpdateHealthOnHead(damagedid);
    }
	return 1;
}
//isUnlockedDeath[playerid] = false;
// Обновление ХП над головой и хп в полоске у игрока
stock UpdateHealthOnHead(playerid)
{
     if(S[playerid] == 0)return 1; // если игрок вне игры, то выполнять ничего не нужно
	 new str[80],maxhp,rangid;
	 
	 // ~~~~~~~~~~~~~ ХП НАД ГОЛОВОЙ ~~~~~~~~~~~~~
	 switch(Player_CurrentTeam[playerid])
	 {
		  case ZOMBIE:{
			   rangid = Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]];
			   maxhp = GetMaxRangHealth(Player_CurrentTeam[playerid],Player_ZombieProfession[playerid],rangid)+Player_Z_DopHealth[playerid][Player_ZombieProfession[playerid]];
	      }
		  case HUMAN:{
		       rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
   	           maxhp = GetMaxRangHealth(Player_CurrentTeam[playerid],Player_HumanProfession[playerid],rangid)+Player_H_DopHealth[playerid][Player_HumanProfession[playerid]];
		  }
		  default: return SetPlayerChatBubble(playerid,"",-1,30.0,999999999);
     }
     if(Player_Invisible[playerid] != 0)SetPlayerChatBubble(playerid,"",-1,30.0,999999999);  // Если игрок в режиме невидимости
	 else // Ну а если нет
	 {
		 // Покрасить в зависимости от процента
	     if(Player_RHealth[playerid] > maxhp)
		 {
		 	format(str,sizeof(str),"{00CC00}Бессмертен");  // Выше максимального HP
	     }
	     else // ну а если не выше
	     {
		     if(Player_RHealth[playerid] <= maxhp)format(str,sizeof(str),"{00CC00}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp);// выше 80 %
		     if(Player_RHealth[playerid] < floatround((maxhp/100.0)*80))format(str,sizeof(str),"{99FF00}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp);//79 .. 60 %
		     if(Player_RHealth[playerid] < floatround((maxhp/100.0)*60))format(str,sizeof(str),"{FFFF00}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp);//59 .. 40 %
		     if(Player_RHealth[playerid] < floatround((maxhp/100.0)*40))format(str,sizeof(str),"{FFCC00}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp);// 39 .. 20 %
		     if(Player_RHealth[playerid] < floatround((maxhp/100.0)*20))format(str,sizeof(str),"{FF6600}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp);// 19 .. 5 %
		     if(Player_RHealth[playerid] < floatround((maxhp/100.0)*5))format(str,sizeof(str),"{FF0000}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp); // 4 .. 1 %
		     if(Player_RHealth[playerid] < 1)format(str,sizeof(str),"{FF0000}0/{00CC00}%d",maxhp); // Мертвец
		 }
		 SetPlayerChatBubble(playerid,str,-1,30.0,999999999); // Выводить над головой
	 }
	 // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	 
	 if( Player_RHealth[playerid] < 1) Player_RHealth[playerid] = 0;
	 // ~~~~~~~~~~~~~ Обновление хп в полоске ~~~~~~~~~~~~~
	 if(Player_RHealth[playerid] >= 10000)return PlayerTextDrawSetString(playerid,HpText[playerid],"~y~xxxx"); // если игрок имеет хп больше 9999
	 else  // А ЕСЛИ НЕТ
	 {
	    switch(Player_CurrentTeam[playerid]){
	        case HUMAN:{  // ЕСЛИ ИГРОК ЧЕЛОВЕК
	            format(str,sizeof(str),"~g~%04d",Player_RHealth[playerid]); // КРАСИМ В ЗЕЛЕНЫЙ
	        }
	        case ZOMBIE:{ // ЕСЛИ ИГРОК ЗОМБИ
                format(str,sizeof(str),"~p~%04d",Player_RHealth[playerid]);  // КРАСИМ В ПУРПУРНЫЙ
	        }
	    }
	    
	 }
	 PlayerTextDrawSetString(playerid,HpText[playerid],str); // ОБНОВИТЬ
	 // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	 return 1;
}

// Вернуть текстдрав времени в исходное состояние
stock TextDrawsStd()
{
	TextDrawSetString(Textdraw1,"EVC: 00:00");
	return 1;
}

// Открыть статистику
stock OpenStat(playerid,dialogid=3409,showid = -1)
{
	 new str[530],str2[40],titul_str[150],tits;
	 for(new i = 1; i < MAX_TITULS; i++)
	 {
	       if (strcmp(Tit_Name[i], GetName(playerid), true, 10) == 0)
	       {
				 format(str,32+6,"%s | ",GetTitulName(i));
				 strcat(titul_str,str);
				 tits++;
	       }
     }
	 if(tits == 0)titul_str = "Отсутствует";
	 
	 if(Player_IsVip[playerid] != 0)str2 = "Имеется";
	 else str2 = "Отсутствует";
	 format(str,sizeof(str),"Nickname - %s\nВозраст - %d\nZombieMoney - %d\nУровень администратора - %d\nЧасов в игре - %d\nRUB - %d\nПрофессия (Люди) - %s(%d ранг)\nПрофессия (Зомби) - %s(%d ранг)",
	 GetName(playerid),Player_Age[playerid],Player_Zm[playerid],Player_AdminLevel[playerid],Player_HourInGame[playerid],Player_Rub[playerid],GetProfName(HUMAN,Player_HumanProfession[playerid]),Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]+1,GetProfName(ZOMBIE,Player_ZombieProfession[playerid]),Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]+1);

	 format(str,sizeof(str),"%s\nСмертей - %d\nДрузей приглашено: %d\nТитул(ы) сервера - %s\nПремиум аккаунт - %s",
	 str,Player_Deaths[playerid],Player_Invites[playerid],titul_str,str2);
	 if(Player_IsVip[playerid] != 0)
	 {
		  if(Player_IsVip[playerid] != -1)
		  {
                format(titul_str,sizeof(titul_str),"\nПремиум окончится - %s",date("%dd.%mm.%yyyy в %hh:%ii:%ss",Player_IsVip[playerid]-(UNIX_TIME_CORRECT)));
	            strcat(str,titul_str);
	      }
	      else strcat(str,"\nПремиум взят навсегда");
     }
	 if(showid != -1)ShowPlayerDialog(showid,dialogid,DIALOG_STYLE_MSGBOX,"Статистика персонажа",str,"Выход","");
	 else ShowPlayerDialog(playerid,dialogid,DIALOG_STYLE_MSGBOX,"Статистика персонажа",str,"Выход","");
	 return 1;
}

stock PlayerMoneyFix(playerid)
{
	 if(GetPlayerMoney(playerid) != Player_Zm[playerid])
	 {
		   ResetPlayerMoney(playerid);
		   GivePlayerMoney(playerid,Player_Zm[playerid]);
	 }
	 return 1;
}


new AC_GUN_SCAN_TIME;
#define TIME_AC_GUN_SCAN 2 // раз в сколько секунд проверять оружие у читеров
public Central_Processor()
{
	new str2[128];
	if( AC_GUN_SCAN_TIME > 0 )
	{
	    AC_GUN_SCAN_TIME --;
	}
	
	CheckSessions(); // антидидос
	//двигатель проверки покупок
	if(TimeToCheckBuyed > 0)
	{
         TimeToCheckBuyed --;
	}
	//счетчики людей и зомби
	if(Game_Started){
         format(str2,sizeof(str2),"Humans: %d",Humans);
         TextDrawSetString(Textdraw2,str2);
         format(str2,sizeof(str2),"Zombies: %d",Zombies);
         TextDrawSetString(Textdraw0,str2);
    }
    else{
         TextDrawSetString(Textdraw2,"Humans: X");
         TextDrawSetString(Textdraw0,"Zombies: X");
    }
    // ~~~~~~~~~~~~~~~~
    // Фикс времени обновления титулов
	if(TimeToFixTituls > 0)
	{
          TimeToFixTituls --;
	}
    //время между предыдущей и следующей ареной
    if(!Game_Started && CountForNextArena > 0){
            CountForNextArena--;
            if(CountForNextArena == 0){
				 StartArena(NextArenaId);
            }
    }
    //вермя до конца арены
    if(Game_Started && CountForEndArena > 0){
           format(str2,sizeof(str2),"EVC: %s",TimeConverter(CountForEndArena));
           TextDrawSetString(Textdraw1,str2);
           CountForEndArena--;
           if(CountForEndArena == 0){
				EndArena(END_REASON_TIME_LEFT);
           }
    }
    //вермя отправки автосообщений
	if(time_to_send_automessage > 0)
	{
             time_to_send_automessage--;
             if(time_to_send_automessage == 0)SendAutoMessage();
	}
	//время голосования
    if(VoteTime > 0)
	{
         VoteTime --;
         TextDrawSetString(_VoteTime_,TimeConverter(VoteTime));
         if(VoteTime == 0)
         {
             CancelVote();
         }
	}
	//открытие убежища
	if(((Game_Started && CountForEndArena < 60) && !MarkerActiv) && MapHaveMarker[CurrentMap]){
		   CallRemoteFunction("OnVaultOpen", "");
           MarkerActiv = true;
           SendClientMessageToAll(COLOR_LIGHTBLUE,"Внимание! Вход в убежище открыт на одну минуту!");
           for(new i, s_b = MaxID; i <= s_b; i++){
				  if(!IsPlayerConnected(i))continue;
				  SetPlayerCheckpoint(i,MapMarkerPos[CurrentMap][0],MapMarkerPos[CurrentMap][1],MapMarkerPos[CurrentMap][2],2.0);
           }

    }
    //счетчик времени всех бомб
    for(new bomb; bomb < Bombs_Counter; bomb ++)
    {
			      if(Bomb_Time[bomb] == 0 || Bomb_Time[bomb]  == BOMB_DETONATOR)continue;
                  Bomb_Time[bomb] --;
                  if(Bomb_Time[bomb] == 0)
                  {
                        BangBomb(bomb);
                  }
			 
    }
    
    // Двигатель начала заражения
    if(Game_Started && Infection_Time > 0)
	{
           Infection_Time--;
           if(Infection_Time == 0)
		   {
			           //Начинаем заражение сейчас же
		               ReCountPlayers();//система обнаружит что инфецируемых нет и начнет заражение
		   }
    }
    
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	for(new playerid,str[64], z = MaxID; playerid <= z; playerid++){
		  if(!IsPlayerConnected(playerid))continue;
		  //Защитное время на спавне, защита от проваливания
		  
		  //
		  format(str,sizeof(str), "Rub: %d", Player_Rub[playerid]);
		  PlayerTextDrawSetString(playerid,MoneyText[playerid],str);
		  //
		  
		  //
		  UpdateProfAndRank3DInformer(playerid);
		  //
		  
		  // Перезарядка заражения
		  if( Player_ZombieInfectTime[playerid] > 0)
		  {
	 	  		Player_ZombieInfectTime[playerid] --;
		  }
		  
		  // защитное время с перемещения на координаты: двигатель
		  if( Player_SetPosProtectTime[playerid] > 0 )
		  {
          		Player_SetPosProtectTime[playerid] --;
		  }
		  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		  
	      if(AC_SpawnProtect[playerid] > 0)
		  {
                    AC_SpawnProtect[playerid]--;
		  }
		  
		  if( TimeToHideDropZmInformer[playerid] > 0 )
		  {
		            TimeToHideDropZmInformer[playerid] --;
		            if( TimeToHideDropZmInformer[playerid] == 0 )
		            {
		                HideDropZmInformer(playerid);
		            }
		  }
		  /*
		  if(GetPVarInt(playerid, "PlayerInAFK") > 0)
		  {
		        if(isFall(playerid))
				{
				    SetPlayerHealthEx(playerid,0);
				    SendClientMessage(playerid, -1, "Вы были убиты за рассинхронизацию при падении");
				}
		  }
		  */
		  if( test_enabled[playerid] )
		  {
            new animname[3][128];
		    new idx = GetPlayerAnimationIndex(playerid);
			GetAnimationName(idx,animname[0],32,animname[1],32);
			format(animname[2], 128, "Idx = %d | Lib - %s | Name - %s | Speed = %d",idx,animname[0],animname[1], GetPlayerSpeed(playerid) );
			SendClientMessage(playerid,-1,animname[2]);
		  }
		  
		  // Обновление защитного времени ( заморозка на карте )
		  if(GetPVarInt(playerid,"ProtectTime") > 0)
		  {
	            SetPVarInt(playerid,"ProtectTime",GetPVarInt(playerid,"ProtectTime")-1);
	            if(GetPVarInt(playerid,"ProtectTime") == 0)
	            {
	                 TogglePlayerControllable(playerid,1);
                }
		  }
		  //проверить покупки игрока
		  if(TimeToCheckBuyed == 0)FixPlayerBuyed(playerid);
		  //после рестарта оставался экран, другого решения я просто не нашел
		  if(GetPVarInt(playerid,"Logged") != 0)TextDrawHideForPlayer(playerid,LoadScreen);
		  //фикс zm, визуальный античит
		  PlayerMoneyFix(playerid);
		  
		  
		  //фикс проведенных в игре часов (не зависит от выхода игрока, секунды игры сохран в файл)
		  if(S[playerid] > 0)
		  {
                   Player_SecInGame[playerid]++;
                   FixHours(playerid);
                   UpdateInformer(playerid);
                   UpdateHealthOnHead(playerid);//левое
                   
				   // Античит скан
				   if(GetPVarInt(playerid, "PlayerInAFK") < 2)
				   {
				        if(S[playerid] > 1)
		  				{
	                   		OnAntiCheatUpdatePlayer(playerid, AC_JETPACK_HACK_, -1);
	                   		OnAntiCheatUpdatePlayer(playerid, AC_ARMOUR_HACK_, -1);

	                   		OnAntiCheatUpdatePlayer(playerid, AC_INTERIOR_HACK, -1);
	                   		OnAntiCheatUpdatePlayer(playerid, AC_CJ_RUN, -1);
                            
                            //OnAntiCheatUpdatePlayer(playerid, AC_FAST_RUN, -1);
                            
                            OnAntiCheatUpdatePlayer(playerid, AC_FALL_STANDING, -1);
	                   		//OnAntiCheatUpdatePlayer(playerid, AC_TP_HACK_, -1); из онплаерапдейт
	                   		//OnAntiCheatUpdatePlayer(playerid, AC_FLY_HACK_, -1); Это вызывается через онплаерапдейт
	                   		OnAntiCheatUpdatePlayer(playerid, AC_FAKESKIN_HACK_, -1);
	                   		if( AC_GUN_SCAN_TIME == 0)
	                   		{
	                   			OnAntiCheatUpdatePlayer(playerid, AC_GUN_HACK_, -1);
	    					}
    					}
                   }
                   
                   if( gSpectateID[playerid] != -1)
				   {
				  		TextDrawHideForPlayer(playerid, ZmText);
			  	   }
			  	   else
			  	   {
			  	    	TextDrawShowForPlayer(playerid, ZmText);
			  	   }
		  }
		  //время гм у дефендера
		  if(Player_DefenderGmTime[playerid] > 0)
		  {
                Player_DefenderGmTime[playerid]--;
                if(Player_DefenderGmTime[playerid] == 0){Player_DefenderGmTime[playerid] = -1;ReturnDefenderOldHP(playerid);}
		  }
		  //получение респекта за час непрерывной игры
		  /*
		  if(S[playerid] > 0 && Player_TimeToExp[playerid] > 0)
		  {
                  Player_TimeToExp[playerid] --;
                  if(Player_TimeToExp[playerid] == 0)
                  {
                         Player_TimeToExp[playerid] = 6000;
                         if(Player_IsVip[playerid] == 0)Player_Respects[playerid]++;
                         else Player_Respects[playerid] += 2;
                         FixLevel(playerid);
                         SaveAccount(playerid);
                  }
		  }
		  */
		  //перезарядка прыжка жокея и ведьмы
		  if(GetPVarInt(playerid,"JumpReset") > 0)
		  {
                 SetPVarInt(playerid,"JumpReset",GetPVarInt(playerid,"JumpReset")-1);
		  }
		  //анти-нахождение в воде
		  if((IsPlayerInWater(playerid) && S[playerid] == 2) && gSpectateID[playerid] == -1 && AC_SpawnProtect[playerid] == 0)
		  {
		        if(!OnAntiCheatUpdatePlayer(playerid, AC_FLYHACK_, 0))// проверка игрока на флайхак
		        {
   					SetPlayerHealthEx(playerid,0);
				}
				else
				{
				    SetPlayerHealthEx(playerid,0);
				}
	      }
		  //афк коунтер
		  if(GetPVarInt(playerid, "PlayerInAFK") == 0) SetPVarInt(playerid, "PlayerInAFK", -1);
          else if(GetPVarInt(playerid, "PlayerInAFK") == -1)
          {
                SetPVarInt(playerid, "PlayerInAFK", 1);
                new string[56];
                format(string, sizeof(string), "АФК: {FFFFFF}%s", ConvertSeconds(GetPVarInt(playerid, "PlayerInAFK")));
                SetPlayerChatBubble(playerid, string, 0xFFFF00AA, 20.0, 1200);
          }
          else if(GetPVarInt(playerid, "PlayerInAFK") > 0)
          {
                new string[56];
                SetPVarInt(playerid, "PlayerInAFK", GetPVarInt(playerid, "PlayerInAFK")+1);
                format(string, sizeof(string), "АФК: {FFFFFF}%s", ConvertSeconds(GetPVarInt(playerid, "PlayerInAFK")));
                SetPlayerChatBubble(playerid, string, 0xFFFF00AA, 20.0, 1200);
                
                TimeForKill[playerid] ++;
				//if((Game_Started) && !Player_InMarker[playerid])
				//{
				    //TimeForKill[playerid] ++;
        		if((TimeForKill[playerid] >= MAX_AFK_TIME_IN_HUMANT) && PlayerNoAFK[playerid])
          		{
							//SetPlayerVirtualWorld(playerid, 10);
                            PlayerNoAFK[playerid] = false;
                            format(str,sizeof(str),"Игрок %s ушел в АФК",GetName(playerid));
                            SendClientMessageToAll(COLOR_LIGHTBLUE,str);
                            if((Player_CurrentTeam[playerid] == HUMAN && S[playerid] == 2) &&  ((Game_Started) && !Player_InMarker[playerid]))
                            {
                                //TimeForKill[playerid] = 0;
                                SendClientMessage(playerid,COLOR_RED,"Вы были перенесены к зомби за афк на арене");
                                Player_CurrentTeam[playerid] = ZOMBIE;
                                //OnPlayerKilledPlayer(playerid, 65535, -1);
                                SetPlayerHealthEx(playerid,0);
                            }
                            ReCountPlayers();
                            
            	}
				//}
          }
          //перезарядка второго скилла медика: врачебной аптечки
 	      if(Medik_ResetHealthTime[playerid] > 0 && S[playerid] > 0){
                  Medik_ResetHealthTime[playerid]--;
                  if(Medik_ResetHealthTime[playerid] == 0){
                          SendClientMessage(playerid,-1,""COL_EASY"Ваша врачебная аптечка успешно перезаряжена");
                          SaveAccount(playerid);
                  }
		  }
		  //Перезарядка всех зомби-скиллов на всех профессиях
		  for(new i; i < MAX_Z_CLASS; i++)
		  {
				 if(!Player_Z_HaveProfession[playerid][i])continue;
				 if(Player_ZombieResetSkillTime[playerid][i] > 0 && S[playerid] > 0)
				 {
                       Player_ZombieResetSkillTime[playerid][i]--;
                       if(Player_ZombieResetSkillTime[playerid][i] == 0){
							 format(str2,sizeof(str2),""COL_EASY"Ваша спец.способность на профессии %s(зомби) перезаряжена",GetProfName(ZOMBIE,i));
						     SendClientMessage(playerid,-1,str2);
						     //SaveAccount(playerid);
                      }
	             }
				 
          }
          //Перезарядка всех человеко-скиллов на всех профессиях
          for(new i; i < MAX_H_CLASS; i++)
		  {
				 if(!Player_H_HaveProfession[playerid][i])continue;
				 if(Player_HumanResetSkillTime[playerid][i] > 0 && S[playerid] > 0)
				 {
                       Player_HumanResetSkillTime[playerid][i]--;
                       if(Player_HumanResetSkillTime[playerid][i] == 0){
							 format(str2,sizeof(str2),""COL_EASY"Ваша спец.способность на профессии %s(люди) перезаряжена",GetProfName(HUMAN,i));
						     SendClientMessage(playerid,-1,str2);
						     //SaveAccount(playerid);
                      }
	             }

          }
          
		  /*
		  //перезарядка зомби скилла
		  if(Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] > 0 && S[playerid] > 0){
                  Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]]--;
                  if(Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] == 0){
						  SendClientMessage(playerid,-1,""COL_EASY"Ваша зомби-спец.способность перезаряжена");
						  SaveAccount(playerid);
                  }
		  }
		  //перезарядка людского скилла
		  if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] > 0 && S[playerid] > 0){
                  Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]--;
                  if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] == 0){
						  SendClientMessage(playerid,-1,""COL_EASY"Ваша человеческая спец. способность перезаряжена");
						  SaveAccount(playerid);
                  }
		  }
		  */
		  //окончание невидимости снайпера
		  if(Player_Invisible[playerid] > 0 && S[playerid] > 0){
                  Player_Invisible[playerid]--;
                  if(Player_Invisible[playerid] == 0){
                          Player_Invisible[playerid] = -1;
						  SendClientMessage(playerid,-1,""COL_RULE"Вас снова видно");
						  ShowPlayer(playerid);
                  }
		  }
		  //счетчик мута
		  if(Player_MuteTime[playerid] > 0 && S[playerid] > 0) {
                  Player_MuteTime[playerid] --;
                  if(Player_MuteTime[playerid] == 0){
						  format(str2,sizeof(str2),"Игрок %s снова может писать в чат",GetName(playerid));
						  SaveAccount(playerid);
						  SendClientMessageToAll(COLOR_LIGHTBLUE,str2);
                  }
          }
          if(TimeToFixTituls == 0)
          {
				for(new i; i < MAX_TITULS; i++)
				{
					 FixTitul(playerid,i);
				}
          }
          //инфекция игрока
          if(Player_IL[playerid] > 0){
			   TextDrawShowForPlayer(playerid,RedScreenBox);
			   if(Player_RHealth[playerid] != 50000)
			   {
			       switch(Player_IL[playerid])
			       {
		  	   	      case ONE_HP:
			          {
			            	 SetPlayerDrunkLevel(playerid,4999);
                             if(Player_RHealth[playerid] == 1)SetPlayerHealthEx(playerid,1);
					         else SetPlayerHealthEx(playerid,Player_RHealth[playerid]-1);
                      }
		 	   	      case TWO_HP:
				      {
				             SetPlayerDrunkLevel(playerid,4999);
                             if(Player_RHealth[playerid] <= 2)SetPlayerHealthEx(playerid,1);
					         else SetPlayerHealthEx(playerid,Player_RHealth[playerid]-2);
	                  }
		  	   	      case THREE_HP:
			          {
			                 SetPlayerDrunkLevel(playerid,4999);
							 if(Player_RHealth[playerid] <= 3)SetPlayerHealthEx(playerid,1);
                             else SetPlayerHealthEx(playerid,Player_RHealth[playerid]-3);
			          }
			       }
			   }
          }
	}
	if( AC_GUN_SCAN_TIME == 0)
	{
		  AC_GUN_SCAN_TIME = TIME_AC_GUN_SCAN;
	}
    					
	//перезарядить время проверки покупок
	if(TimeToCheckBuyed == 0)
    {
           TimeToCheckBuyed = CHECK_BUYED_TIME;
    }
    if(TimeToFixTituls == 0)
    {
           TimeToFixTituls = FIX_ALL_TITUL_TIME;
    }
	return 1;
}


public OnGameModeInit(){
	SendRconCommand("hostname • РУССКИЙ ЗОМБИ СЕРВЕР | ОТКРЫТИЕ В 18:00 •");
    mail_init(MAIL_HOST, MAIL_LOGIN, MAIL_PASSWORD, "s.row.mail@yandex.ru", MAIL_SENDERNAME); // Инит почтовика
	if( GetMaxPlayers() > MAX_PLAYERS)
	{
		  printf("Ошибка! Максимально поддерживается %d игроков",MAX_PLAYERS);
		  SendRconCommand("exit");
		  return 1;
	}
    LoadForbiddenWeapons (); // грузить читерские пушки
	SetGameModeText(GM_NAME);
	//Добавить класс
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	//Пустить процессор
	GM = SetTimer("Central_Processor",CP_UPDATE_INTERVAL,1);
	//Грузить стандартное лобби
	SetDefaulthHome();
	//Настройки на ноль
	Game_Started = false;
	Infection_Time = 0;
	SetWorldTime(24);
    SetWeather(0);
	//Грузить титулы
	LoadTituls();
	//UsePlayerPedAnims();
	//Фикс чека покупок
	TimeToCheckBuyed = CHECK_BUYED_TIME;
	
	//Создать диалоги с оружием
	CreateAvtomatsDialog();
	CreatePistolsDialog();
	CreateShotgunsDialog();
	CreateKarabinsDialog();
	//Создать текстдравы
	DestroyTextDraws();
	
	CreateTextDraws();
	//Текстдравы в исходное положение!
	TextDrawsStd();
	//Грузить арены
	LoadArenas();
	//Отключть бонусы за трюки
	EnableStuntBonusForAll(0);
	//вырубить желтые стерлки в инты
	DisableInteriorEnterExits();
	//очистить килллист
	ClearDeathMessages();
	
	//Создать список профессий при регистрации
	createChosenProf();
	//Создать объекты
	//CreateObjects();
	//Создать диалог с випом
	CreateVipDialog();
	//Создать диалог с кепками
	CreateCapsDialog();
	TimeToFixTituls = FIX_ALL_TITUL_TIME;
	
	new str[70];
	format(str,sizeof(str), "%s develop by BRICS", GM_NAME);
	TextDrawSetString(CreatedBy, str);
	//printf("сейчас - %s",date("%dd.%mm.%yyyy в %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT-(3600*3))));
	//format(titul_str,sizeof(titul_str),"\nПремиум окончится - %s",date("%dd.%mm.%yyyy в %hh:%ii:%ss",Player_IsVip[playerid]-(UNIX_TIME_CORRECT)));
	return 1;
}

//Скрыть время,зомби,людей голосование
stock HideTextDraws(playerid){
	TextDrawHideForPlayer(playerid,Textdraw0);
	TextDrawHideForPlayer(playerid,Textdraw1);
	TextDrawHideForPlayer(playerid,Textdraw2);
    HideVoteTextsForPlayer(playerid);
	return 1;
}


//Показать время, зомби, деньги, хп, людей для игрока
stock ShowTextDraws(playerid){
	TextDrawShowForPlayer(playerid,Textdraw0);
	TextDrawShowForPlayer(playerid,Textdraw1);
	TextDrawShowForPlayer(playerid,Textdraw2);
	PlayerTextDrawShow(playerid,MoneyText[playerid]);
	PlayerTextDrawShow(playerid,HpText[playerid]);
	return 1;
}

public OnGameModeExit()
{
	KillTimer(GM);
	DestroyTextDraws();
	for(new i; i < MAX_SESSIONS; i++)
	{
         ClearSession(i);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    ACInfo[playerid][RealSkinID] = AC_ClassSkin[classid];
    if(S[playerid] != 0) //это переменная, описанная выше. У Вас она может быть другой. В данный момент равна 1, т.к. игрок уже зашел в игру/аккаунт, и мы хотим его выкинуть из выбора class'а
    {
       //SetSpawnInfo(playerid,0,0,0.0,0.0,0.0,0.0,0,0,0,0,0,0); // вместо skin указывайте скин игрока, который должен быть у него. Для RP серверов присутствуют такие переменные.
       SetPlayerSpawnInArea(playerid,CurrentMap); // установка спавна
	   SpawnPlayer(playerid);
       return 1;
    }
    
	AC_SetPlayerPos(playerid, 1380.6447,-1753.0427,13.5469);
    SetPlayerFacingAngle(playerid, 269.6420);
    SetPlayerCameraPos(playerid, 1387.2906,-1752.8887,13.3828);
    SetPlayerCameraLookAt(playerid, 1380.6447,-1753.0427,13.5469);
    if((Game_Started && Infection_Time == 0) && !Player_InMarker[playerid]){
		   GiveClassTeamSkin(playerid,ZOMBIE);
           GameTextForPlayer(playerid,"~r~ZOMBIE",3000,5);
    }
	else if(((Game_Started && Infection_Time != 0) || !Game_Started) || !Player_InMarker[playerid]){
	       GiveClassTeamSkin(playerid,HUMAN);
           GameTextForPlayer(playerid,"~g~HUMAN",3000,5);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    new desti[32];
	GetPlayerVersion(playerid, desti, sizeof(desti));
	if(strcmp(desti, "unknown", true) == 0)
	{
	    BanEx(playerid, "Неизвестный клиент sa-mp");
	    return 1;
	}

    TextDrawShowForPlayer(playerid, LoadScreen);
	if( Call_Connected[playerid] == false)
	{
		Call_Connected[playerid] = true;
		SetTimerEx("OnPlayerConnecting", 1000, 0, "d", playerid);
		return 1;
	}
	SendClientMessage(playerid, -1, "Подождите...");
	return 1;
}

// Скрыть информер о получении ZM ( скрипт ++ )
stock HideDropZmInformer(playerid)
{
    TimeToHideDropZmInformer[playerid] = 0;
    PlayerTextDrawHide(playerid,DropZmInformer[playerid]);
	return 1;
}

// Показать информер о получении ZM ( скрипт ++ )
stock ShowDropZmInformer(playerid)
{
    TimeToHideDropZmInformer[playerid] = TIME_TO_HIDE_DROP_ZM_INFORMER;
    PlayerTextDrawShow(playerid,DropZmInformer[playerid]);
	return 1;
}

forward OnPlayerConnecting(playerid);
public OnPlayerConnecting(playerid)
{
	Call_Connected[playerid] = false;
	// Анти-песочница
    if(GetServerAttackByPlayer(playerid, DOUBLE_CONNECT))   // Проверка+действие на многоразовое подключение
    {
		   SendClientMessage(playerid, -1, "Второстепенные подключения были оборваны");
    }
	
    if(GetServerAttackByPlayer(playerid, DDOS_CONNECTER)) // ДИДОС
    {
            SendClientMessage( playerid, -1, "{ff0000}Вы были забанены: попытка нарушения работы сервера");
			BanEx(playerid, "Ддос-коннектер");
			return 1;
    }
    if( !AddSession(playerid)/*Добавляет сессию*/ ) 
	{
	        // ОЧЕНЬ РЕДКАЯ СИТУАЦИЯ КОГДА ВСЕ ЯЧЕЙКИ ПЕРЕПОЛНЕНЫ, НО НА ВСЯКИЙ СЛУЧАЙ ПОСТАВИМ.
			SendClientMessage( playerid, -1, "{FFFFFF}Сервер перегружен запросами. Пожалуйста, попробуйте подлючиться позже. Для выхода используйте /q");
			Kick(playerid);
			return 1;
	}
    // Анти загон бота
    if(GetServerAttackByPlayer(playerid, ATTACK_NPC)) // Проверка на заход NPC
    {
		   BanEx(playerid, "NPC Бот");
		   return 1;
    }
    
    if( playerid > MaxID) MaxID = playerid;

    //Выпилить автоматы с едой, водой и прочей хавкой//
    RemoveBuildingForPlayer(playerid, 956, 0,0,0, 9999);
    RemoveBuildingForPlayer(playerid, 955, 0,0,0, 9999);
    RemoveBuildingForPlayer(playerid, 1209, 0,0,0, 9999);
    RemoveBuildingForPlayer(playerid, 1302, 0,0,0, 9999);
    RemoveBuildingForPlayer(playerid, 1776, 0,0,0, 9999);
    RemoveBuildingForPlayer(playerid, 1775, 0,0,0, 9999);
    //***********************************************//
    
    PlayAudioStreamForPlayer(playerid,"http://dl.dropbox.com/u/54368978/Postal%202%20-%20Uncle%20Dave%20Heavy%20Metal.mp3");
    
    TextDrawHideForPlayer(playerid,HumansWin);
	TextDrawHideForPlayer(playerid,ZombiesWin);
	Player_RHealth[playerid] = 100;

	DestroyInformer(playerid);
    CreateInformer(playerid);

    PlayerTextDrawDestroy(playerid,MoneyText[playerid]);
	PlayerTextDrawDestroy(playerid,HpText[playerid]);
	PlayerTextDrawDestroy(playerid,DropZmInformer[playerid]);
    CreateTextDrawsHpAndMoney(playerid);
    
	PlayerTextDrawHide(playerid,MoneyText[playerid]);
	PlayerTextDrawHide(playerid,HpText[playerid]);
	PlayerTextDrawHide(playerid,DropZmInformer[playerid]);
	
	TextDrawHideForPlayer(playerid, ZmText);
	TextDrawShowForPlayer(playerid, Logo_Server1);
	TextDrawShowForPlayer(playerid, Logo_Server2);
	
	HideVoteTextsForPlayer(playerid);
    SetPlayerColor(playerid,COLOR_GRAY);
    SetPVarInt(playerid, "PlayerInAFK", -2);
    SetNull(playerid);
    //
    //DeleteProfAndRank3DInformer(playerid);

    
    SetTimerEx("OnPlayerConnectedEx",100,0,"i",playerid); // переключим на другой паблик
	return 1;
}

// Реальное подключение
forward OnPlayerConnectedEx(playerid);
public OnPlayerConnectedEx(playerid)
{
	for(new i; i < 40; i ++)
	{
		 SendClientMessage(playerid,-1,"");
	}
    new str[128],IF,ip[16];
    GetPlayerIp(playerid,ip,sizeof(ip));
    format(str,sizeof(str),"%s/%s.ini",ACCOUNTS_FOLDER,GetName(playerid));
    if(fexist(str))
	{
		 IF = ini_openFile(str);
		 ini_getString(IF,"password",Player_Password[playerid]);
		 ini_getInteger(IF,"special_voteban",Player_Special_Voteban[playerid]);
		 ini_closeFile(IF);
		 if(gettime() < Player_Special_Voteban[playerid])//если дата временного разбана еще не прошла
		 {
				SendClientMessage(playerid,COLOR_RED,"Вам заблокирован доступ на сервер в течении первых пяти минут после кика при голосовании");
				t_Kick(playerid);
				return 1;
		 }
		 ini_closeFile(IF);
	     OpenLogin(playerid);
	     SendClientMessage(playerid,COLOR_WHITE,       MESSAGE_WELCOME_SELECTING);
  	     SendClientMessage(playerid,COLOR_LIGHTBLUE,   "                  ***** С Возвращением На Наш Сервер  *****                  ");
  	     SendClientMessage(playerid,COLOR_GREEN,       "* !!! ЭТО ИМЯ ЗАРЕГИСТРИРОВАНО !!! ВЫ МОЖЕТЕ ВХОДИТЬ !!! *");
  	     SendClientMessage(playerid,COLOR_YELLOW,      "* Чтобы Войти, пожалуйста введите пароль в область для ввода *");
  	     SendClientMessage(playerid,COLOR_TURQUOISE,   "                          "SERVER_LOGO"                          ");
  	     SendClientMessage(playerid,COLOR_WHITE,       MESSAGE_WELCOME_SELECTING);
    }
    else
	{
	     OpenRegister(playerid);
	     SendClientMessage(playerid,COLOR_WHITE,       MESSAGE_WELCOME_SELECTING);
  	     SendClientMessage(playerid,COLOR_LIGHTBLUE,   "                  ***** Приветствуем на Нашем Сервере *****                  ");
  	     SendClientMessage(playerid,COLOR_YELLOWGREEN, "                       !!! ВЫ ПРИНЯТЫ НА СЕРВЕР !!!                       ");
  	     SendClientMessage(playerid,COLOR_RED,         "     !!! ДЛЯ ИГРЫ ВАМ НЕОБХОДИМО ЗАРЕГИСТРИРОВАТЬСЯ !!!     ");
  	     SendClientMessage(playerid,COLOR_YELLOW,      "       * Для Регистрации, пожалуйста заполните свою анкету *       ");
  	     SendClientMessage(playerid,COLOR_TURQUOISE,   "                          "SERVER_LOGO"                          ");
  	     SendClientMessage(playerid,COLOR_WHITE,       MESSAGE_WELCOME_SELECTING);
    }
    format(str,sizeof(str),MESSAGE_PLAYER_CONNECTED_LOG,GetName(playerid),ip);
	WriteLog(CRDLOG,str);
	format(str,sizeof(str),MESSAGE_PLAYER_CONNECTED,GetName(playerid));
	SendClientMessageToAll(-1,str);
	
	TextDrawShowForPlayer(playerid, CreatedBy);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	new str[100];
	NullDisconnectIDVote(playerid);//защита от подмены голосов
	if(VotePlayerID == playerid)
	{
		  ResetVoteParams();
		  format(str,sizeof(str),"Кандидат на кик %s покинул игру. Голосование остановлено",GetName(playerid));
		  SendClientMessageToAll(COLOR_GRAYTEXT,str);
	}
    SaveAccount(playerid);
    HideTextDraws(playerid);
    KillInfection(playerid);
    __InfectText__DeleteLabel(playerid);
    
    SetNull(playerid);
    ReCountPlayers();
    
    DisablePlayerCheckpoint(playerid);
    DestroyInformer(playerid);
    PlayerTextDrawDestroy(playerid,HpText[playerid]);
	PlayerTextDrawDestroy(playerid,MoneyText[playerid]);
	TextDrawHideForPlayer(playerid,LoadScreen);
	TextDrawHideForPlayer(playerid,HumansWin);
	TextDrawHideForPlayer(playerid,ZombiesWin);
	DeleteProfAndRank3DInformer(playerid);
	if(reason != 2)
    {
		switch(reason)
		{
				case 0:str = MESSAGE_REASON_TIMEOUT;
				case 1:str = MESSAGE_REASON_DISCONNECT;
		}
		format(str,sizeof(str),MESSAGE_EXIT_INFO_ADLOG,GetName(playerid),str);
		WriteLog(CRDLOG,str);
		switch(reason)
		{
				case 0:str = MESSAGE_REASON_TIMEOUT;
				case 1:str = MESSAGE_REASON_DISCONNECT;
		}
		format(str,sizeof(str),MESSAGE_EXIT_INFO,GetName(playerid),str);
		SendClientMessageToAll(-1,str);
	}
	else
	{
		format(str,sizeof(str),"%s покинул сервер (Кик/Бан системой)[%s]",GetName(playerid),str);
		WriteLog(CRDLOG,str);
	}
	
	if( playerid == MaxID )
	{
	       new m = MaxID;
	       MaxID = 0;
		   for( new i; i < m; i ++)
		   {
				  if(! IsPlayerConnected(i) || i == playerid) continue;
				  if( i > MaxID ) MaxID = i;
		   }
	}
	return 1;
}



public OnPlayerSpawn(playerid)
{
    //isUnlockedDeath[playerid] = true;
	Player_RHealth[playerid] = 100;
	AC_SpawnProtect[playerid] = SPAWN_PROTECT_TIME;
	S[playerid] = 2;
	ReturnDefenderOldHP(playerid);
	Player_IsKill[playerid] = false;
	FixPlayerBuyed(playerid);
    if( GetServerAttackByPlayer(playerid, FAKE_SKIP_REQUESTCLASS)) // Проверка на незаконный спавн
    {
		   SendClientMessage(playerid,COLOR_RED,"Вы были кикнуты с сервера. Причина: обход логина/регистрации");
		   t_Kick(playerid);
		   return 1;
    }
    
    for(new i, s_b = MaxID; i <= s_b; i ++)
    {
        if( gSpectateID[i] != playerid) continue;
        PlayerSpectatePlayer(i, playerid);
    }
    
    SetPVarInt(playerid,"K_Times",0); // Антифлуд смертями
    StopAudioStreamForPlayer(playerid);
    SetPVarInt(playerid, "PlayerInAFK", 0);
	ShowTextDraws(playerid);
	GoToArena(playerid,CurrentMap);
	ReCountPlayers();
	FixInviseblePlayers(playerid);
	SetPlayerScore(playerid,Player_HourInGame[playerid]);
	TextDrawShowForPlayer(playerid, ZmText);
	ShowInformer(playerid);
	return 1;
}

stock SetPlayerHealthEx(playerid,amount)
{
	   if(amount == 50000) SetPlayerHealth(playerid,50000);
	   else if( amount < 1) SetPlayerHealth(playerid,0);
       Player_RHealth[playerid] = amount;
       UpdateHealthOnHead(playerid);
	   return 1;
}

forward OnPlayerKilledPlayer(playerid, killerid, reason);
public OnPlayerKilledPlayer(playerid, killerid, reason)
{
    ClearAnimations(playerid);
    S[playerid] = 1;
    new str[100];
    Player_RHealth[playerid] = 0;
    UpdateHealthOnHead(playerid);

    ReturnDefenderOldHP(playerid);

    SetPVarInt(playerid, "PlayerInAFK", -2);
    KillInfection(playerid);
    Player_Deaths[playerid]++;
    if(!Player_IsKill[playerid])//Если игрок не убился по своей воле
    {
        if(reason != -1)SendDeathMessage(killerid,playerid,reason);
        if(Player_CurrentTeam[playerid] != Player_CurrentTeam[killerid])
        {
             new PrizeZm = 0;
			 switch(Player_CurrentTeam[killerid])
			 {
				  case ZOMBIE:{
				       if(Player_IsVip[killerid] == 0)
					   {
					          if(Player_Cap[killerid] != RED_CAP)Player_ZombieRangSkill[killerid][Player_ZombieProfession[killerid]] ++;
					          else Player_ZombieRangSkill[killerid][Player_ZombieProfession[killerid]] += 2;
                       }
				       else Player_ZombieRangSkill[killerid][Player_ZombieProfession[killerid]] += 3;

                       FixZombieRang(killerid);
                       Player_KillHuman[killerid] ++;
                       FixTitul(killerid,TIT_KILLER);
                       GameTextForPlayer(killerid,"~g~Player infected sucefully",3000,5);
                       GameTextForPlayer(playerid,"~r~Infected",3000,5);

                       if(Player_IsVip[killerid]==0)
			           {
			               if(Player_Cap[killerid] != BLUE_CAP)PrizeZm += GetZmForKill(HUMAN, Player_HumanProfession[playerid], Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]);
			               else PrizeZm += GetZmForKill(HUMAN, Player_HumanProfession[playerid], Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]])*2;
                       }
			           else PrizeZm+= GetZmForKill(HUMAN, Player_HumanProfession[playerid], Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]])*3;
				  }
				  case HUMAN:{

                       if(Player_IsVip[killerid] == 0)
					   {
							 if(Player_Cap[killerid] != RED_CAP)Player_HumanRangSkill[killerid][Player_HumanProfession[killerid]] ++;
					         else Player_HumanRangSkill[killerid][Player_HumanProfession[killerid]] += 2;
                       }
                       else Player_HumanRangSkill[killerid][Player_HumanProfession[killerid]] += 3;
                       //RED_CAP
                       FixHumanRang(killerid);
                       Player_KillZombie[killerid] ++;
                       FixTitul(killerid,TIT_RAMBO);

                       if(Player_IsVip[killerid]==0)
			           {
			               if(Player_Cap[killerid] != BLUE_CAP)PrizeZm+= GetZmForKill(ZOMBIE, Player_ZombieProfession[playerid], Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]);
			               else PrizeZm+= GetZmForKill(ZOMBIE, Player_ZombieProfession[playerid], Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]])*2;
                       }
			           else PrizeZm+= GetZmForKill(ZOMBIE, Player_ZombieProfession[playerid], Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]])*3;
				  }
			 }

			 Player_Zm[killerid]+= PrizeZm;

			 format(str, sizeof(str), "+%d ZM", PrizeZm);
			 PlayerTextDrawSetString(killerid, DropZmInformer[killerid], str);
			 ShowDropZmInformer(killerid);

			 FixTitul(killerid,TIT_PRESIDENT);
			 SaveAccount(killerid);
			 format(str,sizeof(str),"Игрок %s(%s) убил игрока %s(%s) из %s",GetName(killerid),GetTeamName(Player_CurrentTeam[killerid]),GetName(playerid),GetTeamName(Player_CurrentTeam[playerid]),WeaponNames[reason]);
			 WriteLog(KILLLOG,str);
        }
    }
    if(Game_Started && Infection_Time == 0)/*SetZombie(playerid);*/Player_CurrentTeam[playerid] = ZOMBIE;
    SaveAccount(playerid);
    PlayerTextDrawHide(playerid,MoneyText[playerid]);
	//PlayerTextDrawHide(playerid,HpText[playerid]);
	TogglePlayerControllable(playerid,1);
	ReCountPlayers();
	HideInformer(playerid);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    // Антифлуд смертями
    SetPVarInt(playerid,"K_Times",GetPVarInt(playerid,"K_Times") + 1);
    if(GetServerAttackByPlayer(playerid, FAKE_DEATH)) // Проверка: Многоразовая смерть
    {
		  Kick(playerid);
		  return 1;
    }
    // ********************** //
	//OnPlayerKilledPlayer(playerid, killerid, reason);
	return 1;
}

stock GetTeamName(teamid)
{
	 new teamname[20];
	 switch(teamid)
	 {
            case ZOMBIE: teamname = "Зомби";
            case HUMAN: teamname = "Человек";
	        case ADMIN: teamname = "Админ";
	 }
	 return teamname;
}

//Чаты
#define ADMIN_TO_ADMIN_SYM '*'//чат админам
#define ADMIN_TO_ALL_SYM '!'//чат всем

public OnPlayerText(playerid, text[])
{
    new str[128];
    if(GetPVarInt(playerid,"CountFlood") > gettime()){
        SendClientMessage(playerid,-1,"Не флудите в чате");
        return false;
	}
    if(GetPVarInt(playerid,"Logged") == 0){
	     SendClientMessage(playerid, COLOR_GRAYTEXT, "Ошибка: Вы вне игры и не можете писать в чат");
		 return 0;
	}
	if(Player_MuteTime[playerid] > 0){
		format(text,129,"Ошибка: У вас молчанка. Вы сможете снова говорить через %d секунд",Player_MuteTime[playerid]);
        SendClientMessage(playerid, COLOR_GRAYTEXT, text);
        return 0;
    }
    if(text[0] == ADMIN_TO_ADMIN_SYM && (IsPlayerAdmin(playerid) || Player_AdminLevel[playerid] > 0))
    {
		if(strlen(text) < 2)
		{
			  SendClientMessage(playerid,COLOR_GRAYTEXT,"Использование: *[сообщение админам]");
			  return 0;
		}
		format(str,128,""COL_ORANGE"[A]"COL_YELLOW"%s[%d]: %s",GetName(playerid),playerid, text[1]);
        WriteLog(CHATLOG,str);
		for(new i, s_b = MaxID; i <= s_b; i++)
		{
			   if(!IsPlayerAdmin(i) && Player_AdminLevel[i] < 1)continue;
               SendClientMessage(i,-1,str);
        }
		return 0;
    }
    if(text[0] == ADMIN_TO_ALL_SYM && (IsPlayerAdmin(playerid) || Player_AdminLevel[playerid] > 0))
    {
		if(strlen(text) < 2)
		{
			  SendClientMessage(playerid,COLOR_GRAYTEXT,"Использование: ![сообщение всем]");
			  return 0;
		}
		format(str,128,"Администратор: %s",text[1]);
        WriteLog(CHATLOG,str);
        SendClientMessageToAll(COLOR_LIGHTBLUE,str);
		return 0;
    }
    
    format(str,128,"%s[%d]: %s",GetName(playerid),playerid, text);
    WriteLog(CHATLOG,str);
    format(str,128,"%s[%d]: {ffffff}%s",GetName(playerid),playerid, text);
	SendClientMessageToAll(GetPlayerColor(playerid),str);
	//WritePlayerLog(playerid,str);
    //WriteLog(CHAT_LOG,str);//CHAT_LOG,REG_LOG,LOG_FILE
    SetPVarInt(playerid,"CountFlood",gettime() + FloodTime);
	return 0;
}

FixInviseblePlayers(playerid)
{
	 for(new i, s_b = MaxID; i <= s_b; i++)
	 {
			if(!IsPlayerConnected(i) || S[i] == 0)continue;
			if(Player_Invisible[i] == 0)continue;
			switch(Player_CurrentTeam[playerid])
			{
			       case ZOMBIE:{//наш игрок зомбак
			            ShowPlayerNameTagForPlayer(playerid,i,0);//и даже ник позволит скрыть
                        SetPlayerMarkerForPlayer(playerid,i,HUMAN_COLOR_I);//весь такой правильный
			       }
			       case HUMAN:{//наш игрок чувак
			            ShowPlayerNameTagForPlayer(playerid,i,1);
                        SetPlayerMarkerForPlayer(playerid,i,HUMAN_COLOR);
			       }
			}
	 }
	 return 1;
}

/*
stock UpdateHealthCounter(playerid)
{
	   new str[64];
	   //GetPlayerHealth(playerid,floatbuff);
	   if(S[playerid] == 0)return 1;

	   if(Player_RHealth[playerid] > 1000){
                     TextDrawSetString(HpText[playerid],"5000");
       }

       if(Player_RHealth[playerid] == 1000){
                     if(Player_CurrentTeam[playerid] == HUMAN)format(str,sizeof(str),"~g~%d",1000);
                     else format(str,sizeof(str),"~p~%d",1000);
       }

	   if(Player_RHealth[playerid] < 1000)
	   {
                         if(Player_CurrentTeam[playerid] == HUMAN)format(str,sizeof(str),"0~g~%d",Player_RHealth[playerid]);
                         else format(str,sizeof(str),"0~p~%d",Player_RHealth[playerid]);
	   }
	   if(Player_RHealth[playerid] < 100){
                        if(Player_CurrentTeam[playerid] == HUMAN)format(str,sizeof(str),"00~g~%d",Player_RHealth[playerid]);
                        else format(str,sizeof(str),"00~p~%d",Player_RHealth[playerid]);
	   }
	   if(Player_RHealth[playerid] < 10){
                        if(Player_CurrentTeam[playerid] == HUMAN)format(str,sizeof(str),"000~g~%d",Player_RHealth[playerid]);
                        else format(str,sizeof(str),"000~p~%d",Player_RHealth[playerid]);
	   }
	   TextDrawSetString(HpText[playerid],str);
	   return 1;
}
*/

HideAdmin(playerid)
{
    for(new i, s_b = MaxID; i <= s_b; i++)//если вдруг игрок снайпер
    {
		ShowPlayerNameTagForPlayer(i,playerid,0);
		SetPlayerMarkerForPlayer(i,playerid,HUMAN_COLOR_I);
	}
	return 1;
}

ShowAdmin(playerid)
{
    Player_Invisible[playerid] = 1;
    ShowPlayer(playerid);
    return 1;
}


HidePlayer(playerid)
{
	new bool:block = false;
	new Float: P[3];
	GetPlayerPos(playerid,P[0],P[1],P[2]);
    for(new i, s_b = MaxID; i <= s_b; i++)//если вдруг игрок снайпер
    {
		  if(!IsPlayerConnected(i))continue;
		  if(Player_CurrentTeam[i] != ZOMBIE)continue;
		  if(IsPlayerInRangeOfPoint(i,COPY_SKIN_RAD,P[0],P[1],P[2]) && !block){SetPlayerSkin(playerid,GetPlayerSkin(i));block = true;}
          ShowPlayerNameTagForPlayer(i,playerid,0);
          SetPlayerMarkerForPlayer(i,playerid,HUMAN_COLOR_I);
    }
    return 1;
}

ShowPlayer(playerid)
{
	if(Player_Invisible[playerid] == 0)return 1;
	SetPlayerColor(playerid,HUMAN_COLOR);
    for(new i, s_b = MaxID; i <= s_b; i++)//если вдруг игрок снайпер
    {
		 if(!IsPlayerConnected(i))continue;
         ShowPlayerNameTagForPlayer(i,playerid,1);
         SetPlayerMarkerForPlayer(i,playerid,HUMAN_COLOR);

          //FixInviseblePlayers(i);
	}
	if(Player_CurrentTeam[playerid] == HUMAN)GiveClassTeamSkin(playerid,HUMAN);
	Player_Invisible[playerid] = 0;
    return 1;
}
stock TurnPlayerFaceToPlayer(playerid, facingtoid)//плаерид оборачивается к факингтойду (lol :D)
{
new Float:angle;
new Float:misc = 5.0;
new Float:x, Float:y, Float:z;
new Float:ix, Float:iy, Float:iz;
GetPlayerPos(facingtoid, x, y, z);
GetPlayerPos(playerid, ix, iy, iz);
angle = 180.0-atan2(ix-x,iy-y);
angle += misc;
misc *= -1;
SetPlayerFacingAngle(playerid, angle+misc);
}




forward EffectTank(playerid);
public EffectTank(playerid)
{
	   if(!Game_Started)return 1;
       new Float:Ugol = 0.0;
	   new Float: P[3];
	   new Float: BangPOS[2];
	   Player_OLDHP[playerid] = Player_RHealth[playerid];
	   SetPlayerHealthEx(playerid,50000);
	   GetPlayerPos(playerid,P[0],P[1],P[2]);
	   GameTextForPlayer(playerid,"~g~TANK RAMPAGE!",3000,5);
	   // beta zombie gm ~~~~~~~~~~~~~~~~
	   new GmPlayer[MAX_PLAYERS];
	   new GmVsego = 0;
	   for(new i, s_b = MaxID; i <= s_b; i ++)
	   {
	            if(Player_CurrentTeam[i] == HUMAN) continue;
	            if( i == playerid ) continue;
	            if(!IsPlayerInRangeOfPoint(i,10.0,P[0],P[1],P[2]))continue;
	            Player_OLDHP[i] = Player_RHealth[i];
	            SetPlayerHealthEx(i,50000);
	            GmPlayer[GmVsego] = i;
	            GmVsego ++;
	   }
	   // ~~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~
	   for(new i; i < 2; i++)
	   {
               GetXYInFrontOfPoint(P[0], P[1], BangPOS[0], BangPOS[1], Ugol, RAMPAGE_TANG_BANG_DIST);
               CreateExplosion(BangPOS[0], BangPOS[1],P[2],RAMPAGE_TANG_BANG_TYPE,3.0);
               Ugol += 180.0;
	   }
	   
	   // beta zombie return hp
	   if( GmVsego != 0)
	   {
		   for(new i; i < GmVsego; i ++)
		   {
		            SetPlayerHealthEx(GmPlayer[i],Player_OLDHP[GmPlayer[i]]);
		   }
	   }
	   // ~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~
	   
	   SetTimerEx("BackHp",1000,0,"i",playerid);
	   return 1;
}

forward BackHp(playerid);
public BackHp(playerid)
{
      SetPlayerHealthEx(playerid,Player_OLDHP[playerid]);
	  return 1;
}

stock OpenGMenu(playerid)
{
	  ShowPlayerDialog(playerid,MENU_DIALOG,DIALOG_STYLE_LIST,"Меню","Правила\nПомощь\nСтатистика\nАдминистрация\nТитулы сервера\nГолосование\nИгровой магазин\nМои профессии","Выбрать","Выход");
	  return 1;
}


public OnPlayerCommandText(playerid, cmdtext[])
{
    if(GetPVarInt(playerid,"CmdFlood") > gettime())return SendClientMessage(playerid,-1,"Не флудите командами");
	SetPVarInt(playerid,"CmdFlood",gettime() + FloodTimeCmd);
	new val,val2,Float: P[4];
	new params[128],str[128],cmd[128],idx;
    cmd = strtokForCmd(cmdtext, idx);
    /*
    if(strcmp(cmd, "/setlevel", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 2 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 2 лвл");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /setlevel [playerid][level]");
         val = strval(params);
         
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /setlevel [playerid][level]");
         val2 = strval(params);
         if(!IsPlayerConnected(val))return SendClientMessage(playerid, COLOR_RED, "Игрок не активен");
         if(val2 < 0)return SendClientMessage(playerid, COLOR_RED, "Уровень не должен быть меньше нуля");
         Player_Level[val] = val2;
         Player_Respects[val] = 0;
         format(str,sizeof(str),"Администратор %s установил игроку %s уровень %d",GetName(playerid),GetName(val),val2);
	     SendClientMessageToAll(COLOR_LIGHTBLUE,str);
         WriteLog(ADMINLOG,str);
         return 1;
	}
	*/
    if(strcmp(cmd, "/nextarena", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /nextarena [arenaid]");
         val = strval(params);

	     if(val < 0 || val > (Loaded_Maps-1)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Арена не найдена");
         NextArenaId = val;
	     format(str,sizeof(str),"Администратор %s установил следующую арену на %s",GetName(playerid),MapName[val]);
	     SendClientMessageToAll(COLOR_LIGHTBLUE,str);
         WriteLog(ADMINLOG,str);
	     return 1;
	}
	
	if(strcmp(cmd, "/sethours", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 3 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 3 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /sethours [id][hours]");
         val = strval(params);
         
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /sethours [id][hours]");
         val2 = strval(params);

		 if(!IsPlayerConnected(val))return SendClientMessage(playerid, COLOR_RED, "Игрок не активен");
         if(val2 < 0)return SendClientMessage(playerid, COLOR_RED, "Часы не должны быть меньше нуля");
         
         Player_HourInGame[val] = val2;
         Player_SecInGame[val] = 0;
         SetPlayerScore(val, val2);
         SaveAccount(val);

	     format(str,sizeof(str),"Администратор %s установил игроку %s часы в игре %d",GetName(playerid),GetName(val),val2);
	     SendClientMessageToAll(COLOR_LIGHTBLUE,str);
         WriteLog(ADMINLOG,str);
	     return 1;
	}
    
    
    if(strcmp(cmdtext, "/specoff", true) == 0)
    {
        if(Player_AdminLevel[playerid] < 1 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");
		if(Player_CurrentTeam[playerid] != ADMIN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не на дежурстве");
		if(gSpectateID[playerid] == -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не наблюдаете ни за кем");
		TogglePlayerSpectating(playerid, 0);
		SetTimerEx("DisableGSpectate", 1000, 0, "i", playerid);
		SendClientMessage(playerid,COLOR_YELLOW,"Слежка завершена");
		return 1;
	}
	if(strcmp(cmd, "/specplayer", true) == 0)
    {
        if(Player_AdminLevel[playerid] < 1 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");
		if(Player_CurrentTeam[playerid] != ADMIN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не на дежурстве");
		cmd = strtokForCmd(cmdtext, idx);
		if(!isNumeric(cmd))return SendClientMessage(playerid, COLOR_YELLOW, "Используй: /spec_player [playerid]");
		val = strval(cmd);
		if(!IsPlayerConnected(val))return SendClientMessage(playerid, COLOR_RED, "Игрок не активен");
		if(val == playerid)return SendClientMessage(playerid, COLOR_RED, "Нельзя следить за собой");
		SetPlayerHealthEx(playerid,100);
		TogglePlayerSpectating(playerid, 1);
		PlayerSpectatePlayer(playerid, val);
		SetPlayerInterior(playerid,GetPlayerInterior(val));
		SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(val));
		gSpectateID[playerid] = val;
		return 1;
	}
    if(strcmp(cmdtext, "/aduty", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 1 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");
		 if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
         if(Player_CurrentTeam[playerid] == ADMIN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы уже на дежурстве администратора");
         Player_CurrentTeam[playerid] = ADMIN;
         HideAdmin(playerid);
		 format(str,sizeof(str),"Администратор %s заступил на дежурство",GetName(playerid));
		 SendClientMessageToAll(COLOR_YELLOW,str);
         WriteLog(ADMINLOG,str);
		 SpawnPlayer(playerid);
		 ReCountPlayers();
		 return 1;
	}
	if(strcmp(cmdtext, "/adutyoff", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 1 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");
		 if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
         if(Player_CurrentTeam[playerid] != ADMIN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не начинали дежурство администратора");
         if(gSpectateID[playerid] != -1)OnPlayerCommandText(playerid, "/specoff");
		 Player_CurrentTeam[playerid] = HUMAN;
		 ShowAdmin(playerid);
		 format(str,sizeof(str),"Администратор %s покинул дежурство",GetName(playerid));
		 SendClientMessageToAll(COLOR_YELLOW,str);
		 WriteLog(ADMINLOG,str);
		 SpawnPlayer(playerid);
		 ReCountPlayers();
		 return 1;
	}
	/*
    if(strcmp(cmdtext, "/test", true) == 0)
	{

         if( test_enabled[playerid] )
         {
            test_enabled[playerid] = false;
         }
         else
         {
            test_enabled[playerid] = true;
         }
		 return 1;
	}
	*/
	/*
	if(strcmp(cmdtext, "/test2", true) == 0)
	{
		 GetPlayerPos(playerid,P[0],P[1],P[2]);
		 SetPlayerPos(playerid,P[0],P[1],P[2]+5);
		 return 1;
	}
	if(strcmp(cmdtext, "/test3", true) == 0)
	{
		 GetPlayerPos(playerid,P[0],P[1],P[2]);
		 SetPlayerPos(playerid,P[0],P[1],P[2]+10);
		 return 1;
	}
	if(strcmp(cmdtext, "/test4", true) == 0)
	{
	    //ApplyAnimation(
		 ApplyAnimation(playerid,"PED","FALL_FALL",1000.0,0,0,0,0,600,1);
		 return 1;
	}
	if(strcmp(cmdtext, "/test5", true) == 0)
	{
		 ApplyAnimation(playerid,"KNIFE","Knife_G",4.1,0,1,1,600,1);//как будь-то кулаком ударил
		 return 1;
	}
	if(strcmp(cmdtext, "/test6", true) == 0)
	{
	     ClearAnimations(playerid);
		 return 1;
	}
    if(strcmp(cmdtext, "/test4", true) == 0)
	{
	    //ApplyAnimation(
		 ApplyAnimation(playerid,"PED","FALL_FALL",1000.0,0,0,0,0,600,1);
		 return 1;
	}
		  
*/
    
    if(strcmp(cmd, "/tp", true) == 0 || strcmp(cmd, "/тп", true) == 0)//+2
	{
         if(Player_AdminLevel[playerid] < 1 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");
         if(S[playerid] != 2)return SendClientMessage(playerid,COLOR_RED,MESSAGE_WAIT_SPAWN);
		 params = strtokForCmd(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, -1, "Используйте: /tp [x.mx][y.my][z.mz]");

         strdel(cmd,0,129);
         str = strtokForCmd(params,val,'.');
         //if(!isNumeric(str))return SendClientMessage(playerid, COLOR_GRAD1, "Используйте: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,str);
         str = strtokForCmd(params,val,'.');
         if(!isNumeric(str))return SendClientMessage(playerid,  -1, "Используйте: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,".");
         strcat(cmd,str);
         P[0] = floatstr(cmd);

	     params = strtokForCmd(cmdtext, idx);
	     if(!strlen(params))return SendClientMessage(playerid,  -1, "Используйте: /tp [x.mx][y.my][z.mz]");
	     val = 0;
	     strdel(cmd,0,129);
         str = strtokForCmd(params,val,'.');
         if(!isNumeric(str))return SendClientMessage(playerid,  -1, "Используйте: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,str);
         str = strtokForCmd(params,val,'.');
         if(!isNumeric(str))return SendClientMessage(playerid,  -1, "Используйте: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,".");
         strcat(cmd,str);
         P[1] = floatstr(cmd);

	     params = strtokForCmd(cmdtext, idx);
	     if(!strlen(params))return SendClientMessage(playerid,  -1, "Используйте: /tp [x.mx][y.my][z.mz]");
	     val = 0;
	     strdel(cmd,0,129);
         str = strtokForCmd(params,val,'.');
         if(!isNumeric(str))return SendClientMessage(playerid,  -1, "Используйте: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,str);
         str = strtokForCmd(params,val,'.');
         if(!isNumeric(str))return SendClientMessage(playerid,  -1, "Используйте: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,".");
         strcat(cmd,str);
         P[2] = floatstr(cmd);

         AC_SetPlayerPos(playerid,P[0],P[1],P[2]);
         return 1;
	}
    if(strcmp(cmdtext, "/shop", true) == 0)
	{
		 if(S[playerid] == 0)return 1;
         OpenShop(playerid);
		 return 1;
	}
	
    if(strcmp(cmd, "/setadm", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 3 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 3 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /setadm [id][level]");
         val = strval(params);
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /setadm [id][level]");
         val2 = strval(params);

	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
	     if(val == playerid && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Не применимо к себе");
	     if((Player_AdminLevel[val] >= Player_AdminLevel[playerid]) && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не можете применять данную команду к администраторам уровня выше вашего или одинаковому с вами");
		 Player_AdminLevel[val] = val2;

	     format(str,sizeof(str),"Администратор %s назначил игрока %s администратором %d уровня",GetName(playerid),GetName(val),val2);
	     SendClientMessageToAll(COLOR_LIGHTBLUE,str);
	     WriteLog(ADMINLOG,str);
	     SaveAccount(val);
	     return 1;
	}

    if(strcmp(cmd, "/unmute", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /unmute [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
		 if(Player_MuteTime[val] == 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не заглушен");
		 Player_MuteTime[val] = 0;

	     format(str,sizeof(str),"Администратор %s разглушил игрока %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_LIGHTBLUE,str);
	     WriteLog(ADMINLOG,str);
	     SaveAccount(val);
	     return 1;
	}

    if(strcmp(cmd, "/mute", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /mute [id][time]");
         val = strval(params);
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /mute [id][time]");
         val2 = strval(params);

	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
	     Player_MuteTime[val] = val2;

	     format(str,sizeof(str),"Администратор %s заглушил игрока %s на %d секунд(ы)",GetName(playerid),GetName(val),val2);
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     SaveAccount(val);
	     return 1;
	}

    if(strcmp(cmd, "/kick", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /kick [id][причина]");
         val = strval(params);
         params = strtokForCmd(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /kick [id][причина]");
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
         if(Player_AdminLevel[val] > 0 && val != playerid)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не можете применять данную команду к администраторам");
	     format(str,sizeof(str),"Администратор %s кикнул игрока %s. Причина: %s",GetName(playerid),GetName(val),params);
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     t_Kick(val);

	     return 1;
	}

    if(strcmp(cmd, "/ban", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 2 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /ban [id][причина]");
         val = strval(params);
         params = strtokForCmd(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /ban [id][причина]");
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
         if(Player_AdminLevel[val] > 0 && val != playerid)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не можете применять данную команду к администраторам");
	     format(str,sizeof(str),"Администратор %s забанил игрока %s. Причина: %s",GetName(playerid),GetName(val),params);
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     BanEx(val,params);
	     return 1;
	}
	
	if(strcmp(cmd, "/giverub", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 3 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 3 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /giverub [id][amount]");
         val = strval(params);
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /giverub [id][amount]");
         val2 = strval(params);

	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
		 Player_Rub[val] += val2;

	     format(str,sizeof(str),"Вы дали игроку %s %d RUB",GetName(val),val2);
	     SendClientMessage(playerid,COLOR_YELLOWGREEN,str);

	     format(str,sizeof(str),"Администратор %s дал вам %d RUB",GetName(playerid),val2);
	     SendClientMessage(val,COLOR_YELLOWGREEN,str);
	     
	     format(str,sizeof(str),"Администратор %s дал игроку %s %d рублей",GetName(playerid),GetName(val),val2);
	     MessageToAdmins(str);
	     WriteLog(MONEYLOG,str);
	     SaveAccount(val);
	     return 1;
	}
	if(strcmp(cmd, "/givezm", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 3 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 3 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /givezm [id][amount]");
         val = strval(params);
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /givezm [id][amount]");
         val2 = strval(params);

	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
		 Player_Zm[val] += val2;

	     format(str,sizeof(str),"Вы дали игроку %s %d Zombie Money",GetName(val),val2);
	     SendClientMessage(playerid,COLOR_YELLOWGREEN,str);

	     format(str,sizeof(str),"Администратор %s дал вам %d Zombie Money",GetName(playerid),val2);
	     SendClientMessage(val,COLOR_YELLOWGREEN,str);
	     
	     format(str,sizeof(str),"Администратор %s дал игроку %s %d Zombie Money",GetName(playerid),GetName(val),val2);
	     WriteLog(MONEYLOG,str);
	     MessageToAdmins(str);//+автозапись в админлог
	     SaveAccount(val);
	     return 1;
	}
	if(strcmp(cmd, "/giverank", true) == 0)
	{
	     if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 2 лвл");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /giverank [id][rankid][ZOMBIE/HUMAN]");
         val = strval(params);
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /giverank [id][rankid][ZOMBIE/HUMAN]");
         val2 = strval(params);
		 if(val2 > 5 || val2 < 1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /giverank [id][rankid (1-5)][ZOMBIE/HUMAN]");
         params = strtokForCmd(cmdtext, idx);
         if(strcmp(params, "HUMAN", true) == 0)UpgradeHumanRang(val,val2-1); // минус 1 ОБЯЗАТЕЛЬНО
         else if(strcmp(params, "ZOMBIE", true) == 0)UpgradeZombieRang(val,val2-1); // минус 1 ОБЯЗАТЕЛЬНО
         else return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /giverank [id][rankid][ZOMBIE/HUMAN]");
         format(str,sizeof(str),"Администратор %s сменил вам ранг",GetName(playerid));
         SendClientMessage(val,COLOR_YELLOWGREEN,str);
         format(str,sizeof(str),"Вы сменили ранг игроку %s",GetName(val));
         SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
         
         format(str,sizeof(str),"Администратор %s дал игроку %s %d ранг ",GetName(playerid),GetName(val),val2);
         MessageToAdmins(str);//+автозапись в админлог
		 return 1;
	}
	if(strcmp(cmd, "/setprof", true) == 0)
	{
	     if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 2 лвл");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /setprof [id][profid][ZOMBIE/HUMAN]");
         val = strval(params);
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /setprof [id][profid][ZOMBIE/HUMAN]");
         val2 = strval(params);
		 
         params = strtokForCmd(cmdtext, idx);
         if(strcmp(params, "HUMAN", true) == 0)
		 {
               if(val2 > 4 || val2 < 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Людской-Профессии с таким ид не существует");
               SwitchProfession(val,HUMAN,val2);
               format(str,sizeof(str),"Администратор %s сменил вам людскую профессию на %s",GetName(playerid),GetProfName(HUMAN,val2));
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"Вы сменили профессию игроку %s на %s(люди)",GetName(val),GetProfName(HUMAN,val2));
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"Администратор %s сменил игроку %s профессию на %s(люди)",GetName(playerid),GetName(val),GetProfName(HUMAN,val2));
               MessageToAdmins(str);//+автозапись в админлог
		 }
         else if(strcmp(params, "ZOMBIE", true) == 0)
         {
               if(val2 > 3 || val2 < 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Зомби-Профессии с таким ид не существует");
               SwitchProfession(val,ZOMBIE,val2);
               format(str,sizeof(str),"Администратор %s сменил вам зомби-профессию на %s",GetName(playerid),GetProfName(ZOMBIE,val2));
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"Вы сменили профессию игроку %s на %s(зомби)",GetName(val),GetProfName(ZOMBIE,val2));
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"Администратор %s сменил игроку %s профессию на %s(зомби)",GetName(playerid),GetName(val),GetProfName(ZOMBIE,val2));
               MessageToAdmins(str);//+автозапись в админлог
         }
         else return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /setprof [id][profid][ZOMBIE/HUMAN]");
		 return 1;
	}
	
	if(strcmp(cmd, "/setskill", true) == 0)
	{
	     if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 2 лвл");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /setskill [id][skill][ZOMBIE/HUMAN]");
         val = strval(params);
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /setskill [id][skill][ZOMBIE/HUMAN]");
         val2 = strval(params);

         params = strtokForCmd(cmdtext, idx);
         if(strcmp(params, "HUMAN", true) == 0)
		 {
               Player_HumanRangSkill[val][Player_HumanProfession[val]] = val2;
               format(str,sizeof(str),"Администратор %s установил вам скилл людской профессии на %d",GetName(playerid),val2);
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"Вы сменили скилл людской профессии игроку %s на %d",GetName(val),val2);
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
               FixHumanRang(val);
			   SaveAccount(val);
			   format(str,sizeof(str),"Администратор %s установил игроку %s скилл профессии(люд) на %d",GetName(playerid),GetName(val),val2);
               MessageToAdmins(str);//+автозапись в админлог
		 }
         else if(strcmp(params, "ZOMBIE", true) == 0)
         {
               Player_ZombieRangSkill[val][Player_ZombieProfession[val]] = val2;
               format(str,sizeof(str),"Администратор %s установил вам скилл зомби-профессии на %d",GetName(playerid),val2);
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"Вы сменили скилл зомби-профессии игроку %s на %d",GetName(val),val2);
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
               FixZombieRang(val);
			   SaveAccount(val);
			   format(str,sizeof(str),"Администратор %s установил игроку %s скилл профессии(зомб) на %d",GetName(playerid),GetName(val),val2);
               MessageToAdmins(str);//+автозапись в админлог
         }
         else return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /setskill [id][skill][ZOMBIE/HUMAN]");
		 return 1;
	}
	
	if(strcmp(cmd, "/resetskilltime", true) == 0)
	{
	     if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 2 лвл");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /resetskilltime [id][ZOMBIE/HUMAN]");
         val = strval(params);
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");

         params = strtokForCmd(cmdtext, idx);
         if(strcmp(params, "HUMAN", true) == 0)
		 {
               if(Player_HumanResetSkillTime[val][Player_HumanProfession[val]] == 0)return SendClientMessage(playerid,COLOR_GRAYTEXT,"Выбранный игрок не нуждается в обнулении перезарядки человеко-скилла");
               Player_HumanResetSkillTime[val][Player_HumanProfession[val]] = 0;
               format(str,sizeof(str),"Администратор %s обнулили вам время перезарядки спец.способности людской профессии",GetName(playerid));
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"Вы обнулили игроку %s время перезарядки человеческого скилла",GetName(val));
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
			   SaveAccount(val);
			   format(str,sizeof(str),"Администратор %s обнулил игроку %s время перезарядк ч-скилла",GetName(playerid),GetName(val));
               MessageToAdmins(str);//+автозапись в админлог
		 }
         else if(strcmp(params, "ZOMBIE", true) == 0)
         {
			   if(Player_ZombieResetSkillTime[val][Player_ZombieProfession[val]] == 0)return SendClientMessage(playerid,COLOR_GRAYTEXT,"Выбранный игрок не нуждается в обнулении перезарядки зомби-скилла");
               Player_ZombieResetSkillTime[val][Player_ZombieProfession[val]] = 0;
               format(str,sizeof(str),"Администратор %s обнулили вам время перезарядки спец.способности зомби профессии",GetName(playerid));
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"Вы обнулили игроку %s время перезарядки зомби скилла",GetName(val));
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
			   SaveAccount(val);
			   format(str,sizeof(str),"Администратор %s обнулил игроку %s время перезарядк з-скилла",GetName(playerid),GetName(val));
               MessageToAdmins(str);//+автозапись в админлог
         }
         else return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /resetskilltime [id][ZOMBIE/HUMAN]");
		 return 1;
	}
	
	if(strcmp(cmd, "/killinfect", true) == 0)
	{
	     if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /killinfect [id]");
         val = strval(params);
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
         if(Player_IL[val] == NONE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не инфицирован");
         KillInfection(val);
         format(str,sizeof(str),""COL_RULE"Администратор %s снял инфекцию игроку %s",GetName(playerid),GetName(val));
		 SendClientMessageToAll(-1,str);
         MessageToAdmins(str);//+автозапись в админлог
		 return 1;
	}
	if(strcmp(cmdtext, "/map_set_spawn", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 4 лвл");
         #if MAP_CHANGE_DATA == true
         
         if(CurrentMap == -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Для лобби нельзя задать позицию спавна");
		 if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "В данный момент это невозможно");
		 GetPlayerPos(playerid,P[0],P[1],P[2]);
		 GetPlayerFacingAngle(playerid,P[3]);
		 new IF;
		 format(str,sizeof(str),"%s/%d.ini",MAPS_FOLDER,CurrentMap);
		 IF = ini_openFile(str);
		 format(cmd,sizeof(cmd),"%.f,%.f,%.f,%.f",P[0],P[1],P[2],P[3]);
		 ini_setString(IF,"spawn",cmd);
		 ini_closeFile(IF);
		 MapSpawnPos[CurrentMap][0] = P[0];
		 MapSpawnPos[CurrentMap][1] = P[1];
		 MapSpawnPos[CurrentMap][2] = P[2];
		 MapSpawnPos[CurrentMap][3] = P[3];
		 format(str,sizeof(str),"Администратор %s изменил позицию спавна для текущей карты",GetName(playerid));
		 MessageToAdmins(str);//+автозапись в админлог
		 #else
		 SendClientMessage(playerid, COLOR_GRAYTEXT, "Флаг MAP_CHANGE_DATA отключен");
		 #endif
		 return 1;
	}
	if(strcmp(cmdtext, "/map_set_vault", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 4 лвл");
         #if MAP_CHANGE_DATA == true
         if(CurrentMap == -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Для лобби нельзя задать позицию убежища");
		 if(S[playerid] != 2 || MarkerActiv)return SendClientMessage(playerid, COLOR_GRAYTEXT, "В данный момент это невозможно");
		 GetPlayerPos(playerid,P[0],P[1],P[2]);
		 new IF;
		 format(str,sizeof(str),"%s/%d.ini",MAPS_FOLDER,CurrentMap);
		 IF = ini_openFile(str);
		 format(cmd,sizeof(cmd),"%.f,%.f,%.f",P[0],P[1],P[2]);
		 ini_setString(IF,"markerpos",cmd);
		 ini_setInteger(IF,"marker",1);
		 ini_closeFile(IF);
		 MapHaveMarker[CurrentMap] = true;
		 MapMarkerPos[CurrentMap][0] = P[0];
		 MapMarkerPos[CurrentMap][1] = P[1];
		 MapMarkerPos[CurrentMap][2] = P[2];
		 format(str,sizeof(str),"Администратор %s изменил позицию убежища для текущей карты",GetName(playerid));
		 MessageToAdmins(str);//+автозапись в админлог
		 #else
		 SendClientMessage(playerid, COLOR_GRAYTEXT, "Флаг MAP_CHANGE_DATA отключен");
		 #endif
		 return 1;
	}
	//KillInfection
	if(strcmp(cmd, "/acmd", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");
		 SendClientMessage(playerid,COLOR_GREEN,"Команды администратора:");
         if(Player_AdminLevel[playerid] >= 1 )SendClientMessage(playerid,-1,"/ahuman,/azombie,/killinfect,/goto,/gethere,/kick,/mute,/unmute,/aduty,/adutyoff,/specplayer,/specoff,/nextarena");
         if(Player_AdminLevel[playerid] >= 2 )SendClientMessage(playerid,-1,"/end,/ban,/exploder,/slap,/giverank,/setprof,/setskill,/resetskilltime");
         if(Player_AdminLevel[playerid] >= 3 )SendClientMessage(playerid,-1,"/setadm,/gmx,/giverub,/givezm,/sethours");
         if(Player_AdminLevel[playerid] >= 4 )SendClientMessage(playerid,-1,"/map_set_spawn, /map_set_vault");
	     return 1;
	}

    if(strcmp(cmd, "/end", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 2 лвл");
         if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Арена не запущена");
		 EndArena(END_REASON_ADMIN_STOP);
		 format(str,sizeof(str),"Администратор %s остановил арену",GetName(playerid));
         MessageToAdmins(str);//+автозапись в админлог
	     return 1;
	}
	if(strcmp(cmd, "/gmx", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 3 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 3 лвл");
		 format(str,sizeof(str),"Администратор %s перезапускает сервер",GetName(playerid));
		 SendClientMessageToAll(COLOR_YELLOW,str);
		 EndArena(-1);
		 format(str,sizeof(str),"Администратор %s перезапустил сервер",GetName(playerid));
         WriteLog(ADMINLOG,str);
         SendRconCommand("gmx");
	     return 1;
	}
    if(strcmp(cmd, "/ahuman", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /ahuman [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
	     if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не заспавнен");
	     if(Player_CurrentTeam[val] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок уже человек");
		 SetHuman(val);
	     format(str,sizeof(str),"Администратор %s сделал человеком игрока %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     
	     if( Infection_Time > 0)
	     {
	        SendClientMessageToAll(COLOR_RED,"Заражение начинается!");
	     	Infection_Time = 0; // начать заражение, так сказать
     	 }
	     ReCountPlayers();
	     return 1;
	}
	if(strcmp(cmd, "/azombie", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /azombie [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
	     if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не заспавнен");
	     if(Player_CurrentTeam[val] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок уже зомби");
	     if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "В данный момент это невозможно");
		 SetZombie(val);
	     format(str,sizeof(str),"Администратор %s сделал зомби игрока %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     
	     if( Infection_Time > 0)
	     {
	        SendClientMessageToAll(COLOR_RED,"Заражение начинается!");
	     	Infection_Time = 0; // начать заражение, так сказать
     	 }
	     ReCountPlayers();
	     return 1;
	}

    if(strcmp(cmd, "/exploder", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 2 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /exploder [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
	     if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не заспавнен");
		 GetPlayerPos(val,P[0],P[1],P[2]);
		 CreateExplosion(P[0],P[1],P[2],0,4.0);

	     format(str,sizeof(str),"Администратор %s взорвал игрока %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     return 1;
	}

    if(strcmp(cmd, "/goto", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /goto [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
	     if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не заспавнен");
		 GetPlayerPos(val,P[0],P[1],P[2]);
		 AC_SetPlayerPos(playerid,P[0]+1,P[1],P[2]);

	     format(str,sizeof(str),"Администратор %s телепортировался к игроку %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     return 1;
	}
    if(strcmp(cmd, "/gethere", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 1 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /gethere [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
	     if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не заспавнен");
		 GetPlayerPos(playerid,P[0],P[1],P[2]);
		 AC_SetPlayerPos(val,P[0]+1,P[1],P[2]);

	     format(str,sizeof(str),"Администратор %s телепортировал к себе игрока %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     return 1;
	}

    if(strcmp(cmd, "/slap", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступно для админа 2 лвл");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /slap [id][причина]");
         val = strval(params);
         params = strtokForCmd(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /slap [id][причина]");
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
         if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не заспавнен");
         GetPlayerPos(val,P[0],P[1],P[2]);
		 AC_SetPlayerPos(val,P[0],P[1],P[2]+10);
	     format(str,sizeof(str),"Администратор %s дал пинка игроку %s. Причина: %s",GetName(playerid),GetName(val),params);
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     return 1;
	}
    if (strcmp("/menu", cmdtext, true, 10) == 0)
    {
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  OpenGMenu(playerid);
		  return 1;
    }
    
    if (strcmp("/stat", cmdtext, true, 10) == 0)
    {
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  OpenStat(playerid);
		  return 1;
    }
    
    if (strcmp("/kill", cmdtext, true, 10) == 0)
    {
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  Player_IsKill[playerid] = true;
		  
		  SendDeathMessage(playerid,playerid,8);
		  OnPlayerKilledPlayer(playerid, playerid, 8);
		  
		  ClearAnimations(playerid);
		  SetPlayerHealthEx(playerid,0);
		  
		  SendClientMessage(playerid,COLOR_RED,"Вы успешно покончили с собой");
		  
		  format(cmd,100,"%s покончил с собой используя \"%s\"",GetName(playerid),cmdtext);
		  WriteLog(KILLLOG,cmd);
		  return 1;
    }
    
    if (strcmp("/bw", cmdtext, true, 10) == 0)
    {
  		  if(Player_ZombieProfession[playerid] != ZOMBIE_PROF_BUMER || Player_CurrentTeam[playerid] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не бумер");
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		  if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT,MESSAGE_WAIT_SPAWN);
		  if(Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] != 0)
		  {
				format(str,sizeof(str),"Способность перезаряжается. Вы снова сможете использовать ее через %d сек.",Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		  }
          GetPlayerPos(playerid,P[0],P[1],P[2]);
          GameTextForPlayer(playerid,"~g~Bumer attraction!",3000,5);
          for(new i, s_b = MaxID; i <= s_b; i++)
          {
				if(!IsPlayerConnected(i) || S[i] != 2 || Player_CurrentTeam[i] != HUMAN)continue;
				if(!IsPlayerInRangeOfPoint(i,BUMER_BW_RAD,P[0],P[1],P[2]))continue;
				GameTextForPlayer(i,"~r~Bumer attraction!",3000,5);
				AC_SetPlayerPos(i,P[0]+1/*+random(3)*/,P[1]/*+random(3)*/,P[2]);
				TurnPlayerFaceToPlayer(i, playerid);
				ApplyAnimation(i,"PED","getup_front",4.0,0,0,1,0,0);
          }
          new rangid = Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]];
          Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] = zombie_class_bumer[rangid][zm_rang_special2];
          SaveAccount(playerid);
          return 1;
    }
    if (strcmp("/rage", cmdtext, true, 10) == 0)
    {
          if(Player_ZombieProfession[playerid] != ZOMBIE_PROF_TANK || Player_CurrentTeam[playerid] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не танк");
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		  if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  if(Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] != 0)
		  {
				format(str,sizeof(str),"Способность перезаряжается. Вы снова сможете использовать ее через %d сек.",Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		  }
		  if(isFall(playerid)) // падальщики не нужны
		  {
		        SendClientMessage(playerid, COLOR_GRAYTEXT, "Ошибка: Вы падаете");
		        return 1;
		  }
		  ClearAnimations(playerid);
		  ApplyAnimation(playerid,"KNIFE","Knife_G",4.1,0,1,1,600,1);//как будь-то кулаком ударил
		  new rangid = Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]];
	      Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] = zombie_class_gromila[rangid][zm_rang_special2];
	      SaveAccount(playerid);
	      SetTimerEx("EffectTank",TIME_TO_ACTIVE_RAMP,0,"i",playerid);
	      return 1;
    }
    
    if (strcmp("/rush", cmdtext, true, 10) == 0)
    {
          if(Player_ZombieProfession[playerid] != ZOMBIE_PROF_JOKEY || Player_CurrentTeam[playerid] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не жокей");
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		  if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  if(Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] != 0)
		  {
				format(str,sizeof(str),"Способность перезаряжается. Вы снова сможете использовать ее через %d сек.",Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		  }
		  GetPlayerPos(playerid,P[0],P[1],P[2]);
		  GetPlayerFacingAngle(playerid,P[3]);
		  new Float: RUSHPOS[2];
		  GetXYInFrontOfPoint(P[0], P[1], RUSHPOS[0], RUSHPOS[1], P[3], RUSH_DIST);
		  new rangid = Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]];
		  for(new i, s_b = MaxID; i <= s_b; i++)
		  {
				if(!IsPlayerConnected(i) || S[i] != 2)continue;
				if(Player_CurrentTeam[i] != HUMAN)continue;
				if(!IsPlayerInRangeOfPoint(i,RUSH_DIST,RUSHPOS[0], RUSHPOS[1], P[2]))continue;
				GetPlayerPos(i,P[0],P[1],P[2]);
				AC_SetPlayerPos(playerid,P[0]+1,P[1],P[2]);
				TurnPlayerFaceToPlayer(playerid, i);
				ApplyAnimation(i,"PED","getup_front",4.0,0,0,1,0,0);
				GameTextForPlayer(playerid,"~g~RUSH!",3000,5);
		        PlayerPlaySound(playerid, 1130, 0, 0, 0);
		        GameTextForPlayer(i,"~r~RUSH!",3000,5);
		        PlayerPlaySound(i, 1130, 0, 0, 0);
		        Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] = zombie_class_jokey[rangid][zm_rang_special2];
		        SaveAccount(playerid);
		        return 1;
				
		  }
		  SendClientMessage(playerid, COLOR_GRAYTEXT, "Цель не найдена");
		  return 1;
    }
    if (strcmp("/explodebomb", cmdtext, true, 10) == 0)
    {
		  if(Player_HumanProfession[playerid] != HUMAN_PROF_SHTURMOVIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не штурмовик");
          if(Bomb_Time[Player_MyBombId[playerid]] != BOMB_DETONATOR)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не имеете бомбы с детонатором");
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		  if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  GameTextForPlayer(playerid,"~g~Bomb activated!",3000,5);
		  BangBomb(Player_MyBombId[playerid]);
		  return 1;
    }
    if (strcmp("/plant", cmdtext, true, 10) == 0)
    {
		  if(Player_HumanProfession[playerid] != HUMAN_PROF_SHTURMOVIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не штурмовик");
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		  if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  if(Player_InMarker[playerid])return SendClientMessage(playerid, COLOR_GRAYTEXT, "В данном месте установка бомбы невозможна");
		  if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] != 0)
		  {
				format(str,sizeof(str),"Способность перезаряжается. Вы снова сможете использовать ее через %d сек.",Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		  }
		  if(Player_MyBombId[playerid] != -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы уже установили бомбу. Дождитесь ее взрыва прежде чем ставить новую");
          if(isFall(playerid)) // падальщики не нужны
		  {
		        SendClientMessage(playerid, COLOR_GRAYTEXT, "Ошибка: Вы падаете");
		        return 1;
		  }
		  SetBomb(playerid);
		  return 1;
    }
    if (strcmp("/bar", cmdtext, true, 10) == 0 || strcmp("/barier", cmdtext, true, 10) == 0)//
	{
		if(Player_HumanProfession[playerid] != HUMAN_PROF_CREATER || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не строитель");
        if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
        if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(Player_InMarker[playerid])return SendClientMessage(playerid, COLOR_GRAYTEXT, "В данном месте активация способности невозможна");
        new rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
		if(Object_idx[playerid] >= human_class_creater[rangid][rang_special])
		{
				format(str,sizeof(str),"Вы исчерпали свой запас объектов (%d). Запас восстановится при старте следующей арены",human_class_creater[rangid][rang_special]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		PlayerCreateObject(playerid);
		return 1;
	}
    if (strcmp("/krik", cmdtext, true, 10) == 0)//
	{
		if(Player_ZombieProfession[playerid] != ZOMBIE_PROF_VEDMA || Player_CurrentTeam[playerid] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не ведьма");
		if(Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] != 0)
		{
				format(str,sizeof(str),"Способность перезаряжается. Вы снова сможете использовать ее через %d сек.",Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		new rangid = Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]];
		GetPlayerPos(playerid,P[0],P[1],P[2]);
		GameTextForPlayer(playerid,"~g~SCREAM!",3000,5);
		ApplyAnimation(playerid,"ON_LOOKERS","shout_01",1000.0,0,0,0,0,600,1);
		for(new i, s_b = MaxID; i <= s_b; i++)
		{
		      if(!IsPlayerConnected(i) || S[i] != 2)continue;
			  if(Player_CurrentTeam[i] != HUMAN)continue;
			  if(Player_Cap[i] == BLUE_CAP)continue;
			  if(Player_IL[i] >= zombie_class_vedma[rangid][zm_rang_special])continue;
		      if(!IsPlayerInRangeOfPoint(i,KRIK_RADIUS,P[0],P[1],P[2]))continue;
		      Player_IL[i] = zombie_class_vedma[rangid][zm_rang_special];
		      __InfectText__CreateLabelText(i,Get_IL_Name(Player_IL[i]));
	 	      format(str,sizeof(str),""COL_RED"Вы были заражены игроком %s. "COL_VALUE"Уровень инфекции: %s. "COL_RULE"Медик может вылечить вас",GetName(playerid),Get_IL_Name(Player_IL[i]));
	 	      SendClientMessage(i,-1,str);
	 	      format(str,sizeof(str),""COL_EASY"Игрок %s успешно заражен в резуальтате вашего крика",GetName(i));
	 	      SendClientMessage(playerid,-1,str);
	 	      GameTextForPlayer(i,"~r~SCREAM!",3000,5);
	 	      
		}
		Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] = zombie_class_vedma[rangid][zm_rang_special2];
		SaveAccount(playerid);
		return 1;
	}

    if (strcmp("/defence", cmdtext, true, 10) == 0)//
	{
 		if(Player_HumanProfession[playerid] != HUMAN_PROF_DEFENDER || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не обороняющийся");
		if(Player_DefenderGmTime[playerid] != 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Способность уже активирована");
		if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] != 0)
		{
				format(str,sizeof(str),"Способность перезаряжается. Вы снова сможете использовать ее через %d сек.",Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(Player_InMarker[playerid])return SendClientMessage(playerid, COLOR_GRAYTEXT, "В данном месте активация способности невозможна");
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(isFall(playerid)) // падальщики не нужны
	    {
		        SendClientMessage(playerid, COLOR_GRAYTEXT, "Ошибка: Вы падаете");
		        return 1;
		}
		new rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
		Player_DefenderOldHealth[playerid] = Player_RHealth[playerid];
        Player_DefenderGmTime[playerid] = human_class_defender[rangid][rang_special];
        SetPlayerHealthEx(playerid,50000);
        SetPlayerAttachedObject( playerid, 3, 18693, 6, 0.033288, 0.000000, -1.647527, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); //Правая рука
        SetPlayerAttachedObject( playerid, 4, 18693, 5, 0.036614, 1.886157, 0.782101, 145.929061, 0.000000, 0.000000, 0.469734, 200.000000, 1.000000 ); //Левая рука
        GameTextForPlayer(playerid,"~g~GODMODE!",3000,5);
		/*
		GetPlayerPos(playerid,P[0],P[1],P[2]);
		GameTextForPlayer(playerid,"~g~BANG!",3000,5);
		CreateExplosion(P[0],P[1],P[2],6,5.7);
		for(new i; i <= MaxID; i++)
		{
		      if(!IsPlayerConnected(i) || S[i] != 2)continue;
			  if(Player_CurrentTeam[i] != ZOMBIE)continue;
		      if(!IsPlayerInRangeOfPoint(i,DEFENDER_BANG_RADIUS,P[0],P[1],P[2]))continue;
              SetPlayerHealthEx(i,0);
		}
		format(cmd,100,"%s покончил с собой используя \"/likvid\"",GetName(playerid));
        WriteLog(KILLLOG,cmd);
		
		Player_IsKill[playerid] = true;
		SendDeathMessage(playerid,INVALID_PLAYER_ID,40);
		SetPlayerHealthEx(playerid,0);
		*/
		Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] = human_class_defender[rangid][rang_special2];
		SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/hide", cmdtext, true, 10) == 0)//
	{
		if(Player_HumanProfession[playerid] != HUMAN_PROF_SNIPER || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не снайпер");
		if(Player_Invisible[playerid] > 0)return SendClientMessage(playerid, -1,""COL_EASY"Режим невидимости уже активирован");
		if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] != 0)
		{
				format(str,sizeof(str),"Способность становиться невидимым перезагружется. Вы снова сможете использовать ее через %d сек.",Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(Player_InMarker[playerid])return SendClientMessage(playerid, COLOR_GRAYTEXT, "В данном месте активация способности невозможна");
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		new rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
		SendClientMessage(playerid, COLOR_GRAYTEXT, ""COL_LIGHTBLUE"Режим невидимости активирован");
		HidePlayer(playerid);
		Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] = human_class_sniper[rangid][rang_special2];
		Player_Invisible[playerid] = human_class_sniper[rangid][rang_special];
		SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/cure", cmd, true, 10) == 0)//*Завершено
	{
		
        if(Player_HumanProfession[playerid] != HUMAN_PROF_MEDIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не медик");
        if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] != 0)
		{
				format(str,sizeof(str),"Способность лечить от инфекции перезаряжается. Вы снова сможете использовать ее через %d сек.",Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		params = strtokForCmd(cmdtext, idx);
        if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /cure [id]");
        val = strval(params);
        if(val == playerid)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Не применимо к себе");
        if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
        if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не заспавнен");
		if(Player_IL[val] == 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не имеет инфекции");
		GetPlayerPos(playerid,P[0],P[1],P[2]);
		if(!IsPlayerInRangeOfPoint(val,CURE_HEAL_RADIUS,P[0],P[1],P[2]))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Выбранный вами игрок слишком далеко");
		KillInfection(val);
		format(str,sizeof(str),""COL_RULE2"Медик %s сделал вам инъекцию. Вы больше не инфицированы.",GetName(playerid));
        SendClientMessage(val,-1,str);
        GameTextForPlayer(val,"~g~Cured!",2000,5);
        format(str,sizeof(str),"~g~Player %s successfully cured",GetName(val));
	    GameTextForPlayer(playerid,str,2000,5);
		Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special3];
		SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/cureme", cmdtext, true, 10) == 0)//*Завершено
	{
		// Саморазинфицирование
        if(Player_HumanProfession[playerid] != HUMAN_PROF_MEDIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не медик");
        if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] != 0)
		{
				format(str,sizeof(str),"Способность лечить от инфекции перезаряжается. Вы снова сможете использовать ее через %d сек.",Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		if(Player_IL[playerid] == 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не инфицированы");
		KillInfection(playerid);
        SendClientMessage(playerid,-1,""COL_RULE2"Инфекция уничтожена. Вы больше не инфицированы.");
        GameTextForPlayer(playerid,"~g~Cured!",2000,5);
		Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special3];
		SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/healme", cmdtext, true, 10) == 0)//*Завершено
	{
		// Самолечение
        if(Player_HumanProfession[playerid] != HUMAN_PROF_MEDIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не медик");
        if(Medik_ResetHealthTime[playerid] != 0)
		{
				format(str,sizeof(str),"Врачебная аптечка перезаряжается. Вы снова сможете использовать ее через %d сек.",Medik_ResetHealthTime[playerid]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		
		new max_health;
		max_health = GetMaxRangHealth(HUMAN,Player_HumanProfession[playerid],Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]) + Player_H_DopHealth[playerid][Player_HumanProfession[playerid]];

		if(Player_RHealth[playerid] >= max_health )
		{
                SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не нуждаетесь в лечении");
                return 1;
        }
		
		new amount_hp; // сколько хп медик восстановит
		amount_hp = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special];
		new future_health; // сколько хп будет после восстановления
		future_health = Player_RHealth[playerid] + amount_hp;
		new result; // сколько хп восстановится в результате
		new infohealth; // сколько хп в информер о восстановлении вывести
	 	if(	max_health < future_health) // если восстановленного хп будет больше чем допустимо
	 	{
				  // то вычислить сколько хп нужно до максимума
				  new ostatok;
				  ostatok = max_health - Player_RHealth[playerid];
				  result = ostatok + Player_RHealth[playerid];
				  infohealth = ostatok;
	 	}
	 	else // ну а если нет, то лечить нормально
	 	{
	 	    result = Player_RHealth[playerid] + amount_hp;
	 	    infohealth = amount_hp;
	 	}
	 	
	 	SetPlayerHealthEx(playerid,result);

	 	format(str,sizeof(str),"Вы успешно восстановили себе %d Health Points",infohealth);
	 	SendClientMessage(playerid,-1,str);
	 	format(str,sizeof(str),"~g~Healed %d ~y~Health Points",infohealth);
	 	GameTextForPlayer(playerid,str,2000,5);
	 	Medik_ResetHealthTime[playerid] = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special2];
	 	SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/heal", cmd, true, 10) == 0)//*Завершено
	{

        if(Player_HumanProfession[playerid] != HUMAN_PROF_MEDIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не медик");
        if(Medik_ResetHealthTime[playerid] != 0)
		{
				format(str,sizeof(str),"Врачебная аптечка перезаряжается. Вы снова сможете использовать ее через %d сек.",Medik_ResetHealthTime[playerid]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игра еще не началась");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		params = strtokForCmd(cmdtext, idx);
        if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Используйте: /heal [id]");
        val = strval(params);
        if(val == playerid)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Ошибка: /heal [id] предназначена для лечения других игроков. Для самолечения используйте /healme");
        if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не найден");
        if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не заспавнен");
        if(Player_CurrentTeam[playerid] != Player_CurrentTeam[val])return SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не из вашей комманды");

        new max_health;
		max_health = GetMaxRangHealth(HUMAN,Player_HumanProfession[val],Player_HumanProfessionRang[val][Player_HumanProfession[val]]) + Player_H_DopHealth[val][Player_HumanProfession[val]];

		if( Player_RHealth[val] >= max_health )
		{
                SendClientMessage(playerid, COLOR_GRAYTEXT, "Игрок не нуждается в лечении");
                return 1;
        }
        
        GetPlayerPos(playerid,P[0],P[1],P[2]);
		if(!IsPlayerInRangeOfPoint(val,CURE_HEAL_RADIUS,P[0],P[1],P[2]))return SendClientMessage(playerid, COLOR_GRAYTEXT, "Выбранный вами игрок слишком далеко");

        new amount_hp; // сколько хп медик восстановит
		amount_hp = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special];

        new future_health; // сколько хп будет после восстановления
		future_health = Player_RHealth[val] + amount_hp;

		new result; // сколько хп восстановится в результате
		new infohealth; // сколько хп в информер о восстановлении вывести
	 	if( max_health < future_health ) // если восстановленного хп будет больше чем допустимо
	 	{
	 	          // то вычислить сколько хп нужно до максимума
				  new ostatok;
				  ostatok = max_health - Player_RHealth[val];
				  result = ostatok + Player_RHealth[val];
				  infohealth = ostatok;
	 	}
	 	else  // ну а если нет, то лечить нормально
	 	{
        	result = Player_RHealth[val] + amount_hp;
        	infohealth = amount_hp;
	 	}
	 	SetPlayerHealthEx(val,result);
	 	
	 	format(str,sizeof(str),"Медик %s успешно восстановил вам %d Health Points",GetName(playerid),infohealth);
	 	SendClientMessage(val,-1,str);
	 	format(str,sizeof(str),"~g~Healed %d ~y~Health Points",infohealth);
	 	GameTextForPlayer(val,str,2000,5);
	 	format(str,sizeof(str),"%d Health Points успешно восстановлены игроку %s",infohealth,GetName(val));
 		SendClientMessage(playerid,-1,str);
	 	Medik_ResetHealthTime[playerid] = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special2];
	 	GameTextForPlayer(playerid,"~g~Player Healed",2000,5);
	 	SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/infect", cmdtext, true, 10) == 0)//*Завершено
	{
        if(Player_CurrentTeam[playerid] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Вы не зомби и не можете заражать");
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Заражение еще не началось");
		
		if( Player_ZombieInfectTime[playerid] != 0)
		{
		    format(cmd, sizeof(cmd), "Возможность заражать игроков перезаряжается. Подождите еще %d секунд(у, ы)", Player_ZombieInfectTime[playerid]);
		    SendClientMessage(playerid, COLOR_GRAYTEXT, cmd);
		    return 1;
		}
        GetPlayerPos(playerid,P[0],P[1],P[2]);
        new rangid = Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]];
        new hum = 0;
        for(new i, s_b = MaxID; i <= s_b; i++)
        {
			  if(!IsPlayerConnected(i) || S[i] != 2)continue;
			  if(Player_CurrentTeam[i] != HUMAN)continue;
		      if(!IsPlayerInRangeOfPoint(i,INFECT_RADIUS,P[0],P[1],P[2]))continue;
		      
		      if(Player_Cap[i] == BLUE_CAP)
			  {
			        format(str,sizeof(str), "Игрок %s обладает защитой от заражения", GetName(i));
			        SendClientMessage(playerid,COLOR_GRAYTEXT,str);
			  		continue;
		      }
		      
		      if(Player_ZombieProfession[playerid] == ZOMBIE_PROF_BUMER)
		      {
					  if(Player_IL[i] >= zombie_class_bumer[rangid][zm_rang_special])continue;
					  Player_IL[i] = zombie_class_bumer[rangid][zm_rang_special];
		      }
		      else
		      {
					  if(Player_IL[i] >= RED_MONITOR)continue;
                      Player_IL[i] = RED_MONITOR;
			  }
		      __InfectText__CreateLabelText(i,Get_IL_Name(Player_IL[i]));
	 	      format(str,sizeof(str),""COL_RED"Вы были заражены игроком %s. "COL_VALUE"Уровень инфекции: %s. "COL_RULE"Медик может вылечить вас",GetName(playerid),Get_IL_Name(Player_IL[i]));
	 	      SendClientMessage(i,-1,str);
	 	      GameTextForPlayer(i,"~r~Infection activated!",2000,5);
	 	      format(str,sizeof(str),"~g~Player %s infected successfully",GetName(i));
	          GameTextForPlayer(playerid,str,2000,5);
	          Player_ZombieInfectTime[playerid] = INFECTION_RESET_TIME;
	          hum++;
        }
		if(hum == 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "Доступых для заражения игроков поблизости нет");
		return 1;
	}
	SendClientMessage(playerid,-1,"Неизвестная команда. Попробуйте /menu");
	return 1;
}

stock ReturnDefenderOldHP(playerid)
{
	 if(Player_DefenderGmTime[playerid] == 0)return 1;
     SetPlayerHealthEx(playerid,Player_DefenderOldHealth[playerid]);
     RemovePlayerAttachedObject(playerid, 3);//Тушим правую руку
     RemovePlayerAttachedObject(playerid, 4);//Тушим левую
     Player_DefenderGmTime[playerid]= 0;
     SendClientMessage(playerid,-1,"Режим бессмертия закончился");
     return 1;
}

//Арены
forward NextArenaGen();
public NextArenaGen(){//Генерация следующей арены
     if(NextArenaId < Loaded_Maps){
          NextArenaId ++;
          if(NextArenaId >= Loaded_Maps)NextArenaId = 0;
     }
     else NextArenaId = 0;
	 return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(!MarkerActiv)return SendClientMessage(playerid,COLOR_GRAY,"Вход в убежище закрыт");
	if(Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid,COLOR_GRAY,"Вы заражены и не можете спастись в убежище");
	SendClientMessage(playerid,COLOR_YELLOW,"Вы успешно спаслись! Оставайтесь в убежище до конца арены чтобы получить награду");
	GoToHome(playerid);
	//Циклы проферки: если все люди ушли в убежище то остановить раунд с истечением времени (люди автоматически победят)
	for(new i, s_b = MaxID; i <= s_b; i++)
	{
		   if(!IsPlayerConnected(i) || Player_CurrentTeam[i] != HUMAN || S[i] != 2)continue;
		   if(Player_InMarker[i])continue;
		   return 1;
	}
	EndArena(END_REASON_TIME_LEFT);
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    if(GetPVarInt(playerid, "Logged") != 1) return 0;
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	//перемещение наблюдающего в новый инт
	for(new i, s_b = MaxID; i <= s_b; i++)
	{
		   if(!IsPlayerConnected(i))continue;
		   if(gSpectateID[i] != playerid)continue;
		   SetPlayerInterior(i,newinteriorid);
	}
}

//Таблицы с вип
enum VipDate{
	vip_srok,
	vip_price
}

//#define VIP_DIALOG_PRICE_TEXT "1 день - 13 RUB\n2 дня - 21 RUB\n7 дней - 58 RUB\n30 дней - 163 RUB
//\n90 дней - 272 RUB\n180 дней - 524 RUB\n360 дней - 777 RUB\nПожизненно - 999 RUB"

//CРОК - ЦЕНА
static stock vip_date[][VipDate] ={
    { 1,13},
    { 2,21},
    { 7,58},
    { 30,163},
    { 90,272},
    { 180,524},
    { 360,777},
    { -1,999}
};
#define VIP_LINE 60
new VipDialog[VIP_LINE*sizeof(vip_date)];

stock CreateVipDialog(){
     new str[VIP_LINE];
	 for(new i; i < sizeof(vip_date); i++){
           if(vip_date[i][vip_srok] != -1)format(str,sizeof(str),""COL_LIME"[%d]"COL_RULE2"Срок: %d дней - Цена %d рублей\n",i+1,vip_date[i][vip_srok],vip_date[i][vip_price]);
		   else format(str,sizeof(str),""COL_LIME"[%d]"COL_RULE2"Срок: Пожизненно - Цена %d рублей\n",i+1,vip_date[i][vip_price]);
		   strcat(VipDialog,str);
	 }
	 return 1;
}

forward BigJump(playerid);
public BigJump(playerid)
{
    new Float:P[4];
    GetPlayerVelocity(playerid, P[0],P[1],P[3]);
    SetPlayerVelocity(playerid, P[0],P[1],P[3]+JOKEY_BIG_JUMP_HIGHT);
    return 1;
}
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new str[64],val;
	if(newkeys & KEY_CTRL_BACK)OnPlayerCommandText(playerid, "/shop");
	if(newkeys & KEY_YES)OnPlayerCommandText(playerid, "/menu");
	if(PRESSED(KEY_JUMP+KEY_SPRINT))
	{
		   if(!isFall(playerid)) // падальщики не нужны
		   {
			   if((Player_CurrentTeam[playerid] == ZOMBIE && Player_ZombieProfession[playerid] == ZOMBIE_PROF_JOKEY) || (Player_CurrentTeam[playerid] == ZOMBIE &&Player_ZombieProfession[playerid] == ZOMBIE_PROF_VEDMA))
			   {
					        if(GetPVarInt(playerid,"JumpReset") == 0 && S[playerid] == 2)
					        {
	                              SetPVarInt(playerid,"JumpReset",JOKEY_BIG_JUMP_RESET);
	                              BigJump(playerid);
					        }
			   }
		   }
	}
	if(newkeys & KEY_NO)
	{
		   if(Player_CurrentTeam[playerid] == HUMAN)
		   {
		        switch(Player_HumanProfession[playerid])
		        {
		             case HUMAN_PROF_SHTURMOVIK:
					 {
						  if(Player_MyBombId[playerid] > -1)
						  {
								if(Bomb_Time[Player_MyBombId[playerid]] == BOMB_DETONATOR)
								{
                                       OnPlayerCommandText(playerid, "/explodebomb");
                                       return 1;
								}
						  }
                          OnPlayerCommandText(playerid, "/plant");
                     }
				     case HUMAN_PROF_SNIPER:OnPlayerCommandText(playerid, "/hide");
				     case HUMAN_PROF_DEFENDER:OnPlayerCommandText(playerid, "/defence");
				     case HUMAN_PROF_CREATER:OnPlayerCommandText(playerid, "/barier");
				     /*
				     case HUMAN_PROF_MEDIK:
				     {
							SendClientMessage(playerid,COLOR_GRAYTEXT,""COL_EASY"Наведите прицел на игрока, которого хотите вылечить и нажмите Num4");
							SendClientMessage(playerid,COLOR_GRAYTEXT,""COL_EASY"Наведите прицел на игрока, с которого вы хотите снять инфекцию и нажмите Num6");
				     }
				     */
				     
                }
		   }
		   else if(Player_CurrentTeam[playerid] == ZOMBIE)
		   {
		        switch(Player_ZombieProfession[playerid])
		        {
				     case ZOMBIE_PROF_VEDMA:OnPlayerCommandText(playerid, "/krik");
				     case ZOMBIE_PROF_JOKEY:OnPlayerCommandText(playerid, "/rush");
				     case ZOMBIE_PROF_TANK:OnPlayerCommandText(playerid, "/rage");
				     case ZOMBIE_PROF_BUMER:OnPlayerCommandText(playerid, "/bw");
                }
		   }
	}
	if(newkeys & 8192) // num4
	{
	    if(Player_HumanProfession[playerid] == HUMAN_PROF_MEDIK && Player_CurrentTeam[playerid] == HUMAN)
        {
            OnPlayerCommandText(playerid, "/healme");
        }
	}
	if(newkeys & 16384) // num6
	{
	    if(Player_HumanProfession[playerid] == HUMAN_PROF_MEDIK && Player_CurrentTeam[playerid] == HUMAN)
        {
            OnPlayerCommandText(playerid, "/cureme");
        }
	}
	if(newkeys & /*8192*/KEY_WALK)//alt
	{
		   if(Player_HumanProfession[playerid] == HUMAN_PROF_MEDIK && Player_CurrentTeam[playerid] == HUMAN)
		   {
				 val = GetPlayerTargetPlayer(playerid);
				 if(val == INVALID_PLAYER_ID)return SendClientMessage(playerid,-1,""COL_EASY"Наведите прицел на игрока, которого хотите вылечить.");
				 format(str,sizeof(str),"/heal %d",val);
                 OnPlayerCommandText(playerid, str);
		   }
	}
	if(newkeys & /*16384*/KEY_NO)//n
	{
		   if(Player_HumanProfession[playerid] == HUMAN_PROF_MEDIK && Player_CurrentTeam[playerid] == HUMAN)
		   {
				 val = GetPlayerTargetPlayer(playerid);
				 if(val == INVALID_PLAYER_ID)return SendClientMessage(playerid,-1,""COL_EASY"Наведите прицел на игрока, которого хотите вылечить от инфекции.");
				 format(str,sizeof(str),"/cure %d",val);
                 OnPlayerCommandText(playerid, str);
		   }
	}
	if(newkeys & KEY_WALK)
	{
		   if(Player_CurrentTeam[playerid] != ZOMBIE)return 1;
           OnPlayerCommandText(playerid, "/infect");
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid){
    if(S[playerid] == 2)
	{
	    if( Player_RHealth[playerid] < 50000)
	    {
	        if(Player_RHealth[playerid] < 1)
	        {
	            SetPlayerHealth(playerid,0);
	        }
	        else
	        {
				SetPlayerHealth(playerid,1900);//fixhealth !_!_!_!
			}
		}
		else
		{
		    SetPlayerHealth(playerid,50000);
		}
		OnAntiCheatUpdatePlayer(playerid, AC_TP_HACK_, -1); // вызов антитпхака с рендера
		OnAntiCheatUpdatePlayer(playerid, AC_FLYHACK_, 1); // вызов антифлайхака с рендера
		// античит на флайхак
	}
    if(GetPVarInt(playerid, "PlayerInAFK") > -2)
	{
        if(GetPVarInt(playerid, "PlayerInAFK") > 2) SetPlayerChatBubble(playerid, "{FFFF00}АФК: {FFFFFF}завершено", COLOR_WHITE, 20.0, 500);
        SetPVarInt(playerid, "PlayerInAFK", 0);
        if(TimeForKill[playerid] > MAX_AFK_TIME_IN_HUMANT)
        {
				 new str[66];
				 //SetPlayerVirtualWorld(playerid, 0);
                 format(str,sizeof(str),"Игрок %s вернулся из АФК",GetName(playerid));
                 SendClientMessageToAll(COLOR_LIGHTBLUE,str);
        }
        TimeForKill[playerid] = 0;
        PlayerNoAFK[playerid] = true;
        ReCountPlayers();
    }
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

//===========[Описание людей]===========//
new AboutSturm[10][] = {
/*0*/    {"О Штурмовике:\n"},
/*1*/    {"Штурмовик — элитный солдат Выживших людей.\n"},
/*2*/    {"Штурмовики созданы как подразделения для нанесения первого удара и поддержки соединений Армии и Флота в критических боевых ситуациях.\n"},
/*3*/    {"Прекрасно вымуштрованные и безоговорочно преданные Императору, Штурмовики исполняют приказы без колебаний и не раздумывая о собственной жизни.\n"},
/*4*/    {"Эти мрачные безликие бойцы безжалостно обращают всю мощь своей подготовки и оружия на любого, кто пойдёт против выживших\n"},
/*5*/    {"Оснащенные точнейшим и мощнейшим оружием и снаряжением,\n"},
/*6*/    {"они являются наиболее надежными и эффективными войсковыми частями Спасенных людей и самыми грозными врагами Зомби.\n"},
/*7*/    {"Организованные в несколько корпусов штурмовиков, штурмовики существовали независимо от армии.\n"},
/*8*/    {"Звания штурмовиков: «Сержант», «Лейтенант», «Майор», «Генерал армии» и «Министр обороны»\n"},
/*9*/    {"Большую часть штурмовиков составляли солдаты клоны, а позднее люди, обученные в наилучших академиях.Имеют способность поставить бомбу.\n"}
};

new AboutMedik[6][] = {
/*0*/    {"О медике:\n"},
/*1*/    {"После появления зомби число повреждений на войне резко увеличилось.\n"},
/*2*/    {"Военные люди увидели, что ранения часто влекут за собою смерть; ничтожная на вид рана приводит к обширному инфицированию.\n"},
/*3*/    {"Для всех необходимость во врачах стала очевидной, и, начиная с 2040 года в каждом большом отряде, имеются цирюльники,\n"},
/*4*/    {"фельдшера с помощниками и особые хирурги и врачи. Имеются особые способности это: сделать инъекцию и вакцину человеку.\n"},
/*5*/    {"Звания медиков: «Интерн», «Научный сотрудник», «Кандидат медицинский наук», «Доктор Медицинский наук», «Академик»\n"}
};

new AboutSniper[9][] = {
/*0*/    {"О снайпере:\n"},
/*1*/    {"Специально обученный солдат (самостоятельная боевая единица), в совершенстве владеющий искусством меткой стрельбы,\n"},
/*2*/    {"маскировки и наблюдения; поражает цель, как правило, с первого выстрела.\n"},
/*3*/    {"Задача снайпера — поражение командного и связного составов, секрета противника, уничтожение важных появляющихся,\n"},
/*4*/    {"движущихся, открытых и замаскированных одиночных целей (вражеских жокеев, бумеров и др.).\n"},
/*5*/    {"Снайпер вооружается снайперской винтовкой с оптическим прицелом и иными специальными устройствами,облегчающими прицеливание.\n"},
/*6*/    {"Слово «Снайпер» впервые появилось в 2040 году во время первого нападения зомби, происходит от англ. snipe — «бекас»\n"},
/*7*/    {"(мелкая и быстрая птица,охота на которую сложна тем,что траектория полета птички непредсказуема,и выстрел должен проводиться «навскидку»).\n"},
/*8*/    {"Имеет способность стелса. Звания снайперов: «Капрал», «Мичман», «Бригадир», «Коммандер», «Генерал-Майор»"}
};


new AboutDef[5][] = {
/*0*/    {"О защитнике:\n"},
/*1*/    {"Люди, – которым нечего было терять, потерявшие семью, родных, близких – готовые уничтожить любого на своем пути записались в отряды защитников.\n"},
/*2*/    {"Это профессиональные киллеры, которые в связи с возникновением вируса и мутации людей, начали бороться за выживание,\n"},
/*3*/    {"они самые тяжеловооруженные и опасные. Имеют способность принести себя в жертву предварительно взорвавшись и нанося урон зомби.\n"},
/*4*/    {"Звания защитников: «Бомбардир», «Старшина», «Поручик», «Фельдмаршал», «Генералиссимус».\n"}
};

new AboutCreat[5][] = {
/*0*/    {"О строителе:\n"},
/*1*/    {"Военно-строительные войска — формирования в вооруженных силах некоторых государств, воинские части и подразделения,\n"},
/*2*/    {"предназначенные для возведения многочисленных построек,дабы противостоять монстрам. В зависимости от предназначения\n"},
/*3*/    {"могут быть самостоятельными подразделениями вооруженных сил государства или подчиняться родам войск.\n"},
/*4*/    {"Звания строителей: «Подсобник», «Ученик», «Мастер», «Прораб», «Архитектор».\n"}
};

//===========[Описание зомби]===========//
new AboutTank[6][] = {
/*0*/    {"О танках:\n"},
/*1*/    {"Танки — огромные мускулистые зараженные, обладающие сокрушительной мощью. Способен убивать с 1 удара, швырять объекты окружения,\n"},
/*3*/    {"Здоровье Танка зависит от уровня скилла: 5 уровень — 1000 единиц Health Points.\n"},
/*4*/    {"Если Танка подожгли, то он при этом не теряет здоровье. По слухам он произошел в результате скрещивания человека с носорогом.\n"},
/*5*/    {"Имеет способность стать неуязвимым на 4 секунды, в это время он ударяет своим мощным кулаком о землю и вокруг него появляется 4 взрыва.\n"},
/*6*/    {"Остается добавить, что людям надо быть максимально осторожными с этим видом особи и находиться как можно дальше от него.\n"}
};

new AboutJokey[5][] = {
/*0*/    {"О жокее:\n"},
/*1*/    {"Жокей — ловкий и быстрый Зараженный, способный далеко прыгать. Атакует, налетая на Выжившего и сбивая его с ног,\n"},
/*2*/    {"после чего начинает наносить ему серьезные травмы своими когтями. Присутствие Жокея трудно обнаружить, так как он очень ловкий и не попадается на вид.\n"},
/*3*/    {"Бегает он совершенно бесшумно. Единственная возможность спастись для Выживших — это помощь и сплоченность действий товарищей.\n"},
/*4*/    {"Здоровье Жокея зависит от уровня скилла:5 уровень — 500 единиц Health Points.Он был самым первым мутантом и получен в результате скрещивания человека с кроликом.\n"}
};

new AboutVedma[5][] = {
/*0*/    {"О ведьме:\n"},
/*1*/    {"Ведьма — одна из самых опасных Зараженных. Ведьма убивает Выжившего с пары ударов.\n"},
/*2*/    {"Здоровье Ведьмы зависит от уровня скилла: 5 уровень — 300 единиц Health Points.\n"},
/*3*/    {"Ведьма может издавать душераздирающий крик, который способен деморализовать людей, заражая и нанося им урон каждую секунду.\n"},
/*4*/    {"Из недостоверных источников, она произошла в результате скрещивания женщины с жокеем.\n"}
};

new AboutBumer[6][] = {
/*0*/    {"О бумерах:\n"},
/*1*/    {"Огромные, толстые, покрытые нарывами зараженные,наполненный неизвестной субстанцией (предположительно, кишечными экскрементами).\n"},
/*2*/    {"Толстяк может извергать блевоту на небольшое расстояние.\n"},
/*3*/    {"Когда его блевота попадает на Выжившего, она заставляет его притянуться к себе.\n"},
/*4*/    {"Толстяк самый медлительный из всех заражённых. Здоровье Бумера зависит от уровня скилла: 5 уровень — 600 единиц Health Points.\n"},
/*5*/    {"Самый последний вид мутантов, появившийся невероятным образом.\n"}
};

//правила
new Rules[36][] = {
/*0*/    {"Правила сервера:\n"},
/*1*/    {"1. Данный сервер является бесплатным. Соответственно администрация занимается им исключительно на собственные средства и исключительно по собственному желанию.\n"},
/*2*/    {"Здесь играют люди различных мировоззрений, так что, уважительно относитесь к каждому человеку.\n"},
/*3*/    {"2. Поддержание работоспособности сервера не является приоритетной задачей для администрации.\n"},
/*4*/    {"3. Исходя, из вышеизложенного администрация не гарантирует работоспособность сервера, а так же сохранность информации на нем и вообще продолжение работы над ним.\n"},
/*5*/    {"4. Администрация по мере возможностей помогает разрешать возникающие проблемы, но никаких гарантий не дает.\n"},
/*6*/    {"4.1 Обязательно указывайте действующий e-mail при регистрации. Аккаунты с несуществующим адресом могут быть удалены без объяснения причин.\n"},
/*7*/    {"4.2 Имена персонажей должны быть осмысленными, читаемыми и произносимыми.\n"},
/*8*/    {"4.3 Использование псевдокириллицы и прочих извращений не рекомендуется.\n"},
/*9*/    {"4.4. Пишите имена согласно грамматике английского языка. Первая буква имени заглавная, остальные прописные.\n"},
/*10*/    {"4.5 Запрещены нецензурные, вызывающие, оскорбительные или мешающие игровому процессу имена или титулы. Такие персонажи могут быть удалены без предупреждения.\n"},
/*11*/    {"4.6 Хозяин аккаунта несет полную ответственность за все, что было сделано из-под его аккаунта.\n"},
/*12*/    {"4.7 Запрещено совместное использование аккаунта, равно как и передача аккаунта другому лицу.\n"},
/*13*/    {"5.1 Запрещено совершать какие либо действия, которые могут нарушить игровой процесс или приводить к нестабильной работе сервера.\n"},
/*14*/    {"Также запрещено утаивание информации о таких действиях.\n"},
/*15*/    {"5.2 Запрещены ругательства, нецензурные выражения, оскорбления, угрозы, вымогательство, шантаж, сексуальные домогательства,\n"},
/*16*/    {"разжигание межнациональной, межклассовой или межрасовой розни итд итп.\n"},
/*17*/    {"5.3 Запрещено выдавать себя за администрацию сервера.\n"},
/*18*/    {"5.4 Запрещено требовать у других игроков информацию, которую они считают секретной.\n"},
/*19*/    {"5.5 Запрещено неуважительное обращение к администрации сервера. Оспаривание действий администрации разрешается только через форум.\n"},
/*20*/    {"5.6 Запрещено распускание слухов, дезинформация об администрации сервера, равно как и о других игроках.\n"},
/*21*/    {"5.7 Запрещено блокировать проходы.\n"},
/*22*/    {"5.8 Запрещено попрошайничать, донимать просьбами других игроков или администрацию сервера.\n"},
/*23*/    {"5.9 Запрещен флуд и спам, написание по одному слову в строчку, написание всех слов в верхнем регистре, повторение одной строки, реклама и антиреклама.\n"},
/*24*/    {"5.10 Общение в клановом/групповом чате регламентируется лидером клана/группы. Соблюдение пункта 5.2 правил в этих каналах администрацией не контролируется.\n"},
/*25*/    {"5.11 Запрещены любые виды мошенничества.\n"},
/*26*/    {"5.12 Запрещено использование программ, эмулирующих присутствие игрока в игре или нарушающих нормальное функционирование серверного ПО.\n"},
/*27*/    {"Под такими подразумеваются программы, изменяющие клиент либо заменяющие его, и изменяющие или облегчающие игровой процесс неигровыми методами.\n"},
/*28*/    {"5.13 Запрещено писать об уходе с сервера, или призывать других игроков прекратить игру.\n"},
/*29*/    {"5.14 Об игровых недоработках разрешено писать только на форуме, в разделе тех.поддержка, с соблюдением правил раздела.\n"},
/*30*/    {"6.1 Удаление аккаунта - Удаление с сервера учетной записи со всеми находящимися на ней персонажами. Может быть применено ко всем аккаунтам игрока сразу.\n"},
/*31*/    {"6.2 Удаление персонажа - Удаление с сервера определенного персонажа в учетной записи.\n"},
/*32*/    {"6.3 Бан аккаунта - временное или постоянное блокирование использование аккаунта. Может быть применено ко всем аккаунтам игрока сразу.\n"},
/*33*/    {"6.4 Конфискация имущества - Полная или частичная конфискация имущества с персонажа или со всех персонажей принадлежащих игроку.\n"},
/*34*/    {"6.5 Блокирование доступа с определенного компьютера. Может быть применено ко всем аккаунтам игрока сразу.\n"},
/*35*/    {"6.6 Другие действия.\n"}
};

//смысл игры
new AboutYourGame[10][] = {
/*0*/    {"Смысл игры:\n"},
/*1*/    {"Наверняка, Вы задумывались, зачем играть, тратить своё время на данном сервере?\n"},
/*2*/    {"Ответ простой – после долгого рабочего дня, учебы, всем свойственно отдыхать, расслабляться и, поэтому мы рекомендуем Вам именно наш сервер.\n"},
/*3*/    {"Полная неограниченность в возможностях, огромный спектр действий, не дадут Вам скучать.\n"},
/*4*/    {"Также на серверах будут проводиться ежемесячные турниры, за которые Вы будите получать призы.\n"},
/*5*/    {"Естественно, в будущем, мы планируем, целую сеть серверов популярных онлайн игр.\n"},
/*6*/    {"Также в игре хорошо передается через огромные просторы постапокалиптический мир. Игрок сам может выбрать свой класс:\n"},
/*7*/    {"быть отважным генералом армии или кровожадным жокеем. Дабы не ограничивать две команды, реализована система «игра по раундам»,\n"},
/*8*/    {"но это не мешает почувствовать все особенности, возможно будущего мира. Каждый класс имеет свои особенности и умения.\n"},
/*9*/    {"Например: ведьма может издавать душераздирающий крик, способный деморализовать людей.Или строитель имеет умение возводить блоки для защиты своих соратников.\n"}
};

//основные команды
new GeneralCommands[4][] = {
/*0*/    {"Основные команды:\n"},
/*1*/    {"/menu - Открыть основное меню\n"},
/*2*/    {"/shop - Открыть магазин\n"},
/*3*/    //{"/buyrank - Перейти на следующий ранг в людской профессии (при условиях его доступности)\n"},
/*4*/    {"/kill - Покончить с собой\n"}
};



stock About(playerid,teamid,profid)
{
	new bigbuffer[1110];
	switch(teamid){
		 case ZOMBIE:{
		     switch(profid){
		            case ZOMBIE_PROF_TANK:{
							/*format(bigbuffer,sizeof(bigbuffer), "%s%s%s%s%s%s",
					        AboutTank[0],AboutTank[1],AboutTank[2],AboutTank[3],AboutTank[4],AboutTank[5]);*/
                            for(new i; i < sizeof(AboutTank); i++) strcat(bigbuffer,AboutTank[i]);
							ShowPlayerDialog(playerid,ABOUT_ZOMBIE_DIALOG,DIALOG_STYLE_MSGBOX,"О танке",bigbuffer,"Выбрать","Назад");
					}
					case ZOMBIE_PROF_JOKEY:{
							/*format(bigbuffer,sizeof(bigbuffer), "%s%s%s%s%s",
					        AboutJokey[0],AboutJokey[1],AboutJokey[2],AboutJokey[3],AboutJokey[4]);*/
                            for(new i; i < sizeof(AboutJokey); i++) strcat(bigbuffer,AboutJokey[i]);
							ShowPlayerDialog(playerid,ABOUT_ZOMBIE_DIALOG,DIALOG_STYLE_MSGBOX,"О Жокее",bigbuffer,"Выбрать","Назад");
					}
					case ZOMBIE_PROF_VEDMA:{
							/*format(bigbuffer,sizeof(bigbuffer), "%s%s%s%s%s",
					        AboutVedma[0],AboutVedma[1],AboutVedma[2],AboutVedma[3],AboutVedma[4]);*/
                            for(new i; i < sizeof(AboutVedma); i++) strcat(bigbuffer,AboutVedma[i]);
							ShowPlayerDialog(playerid,ABOUT_ZOMBIE_DIALOG,DIALOG_STYLE_MSGBOX,"О Ведьме",bigbuffer,"Выбрать","Назад");
					}
					case ZOMBIE_PROF_BUMER:{
							/*format(bigbuffer,sizeof(bigbuffer), "%s%s%s%s%s%s",
					        AboutBumer[0],AboutBumer[1],AboutBumer[2],AboutBumer[3],AboutBumer[4],AboutBumer[5]);*/
                            for(new i; i < sizeof(AboutBumer); i++) strcat(bigbuffer,AboutBumer[i]);
							ShowPlayerDialog(playerid,ABOUT_ZOMBIE_DIALOG,DIALOG_STYLE_MSGBOX,"О Бумере",bigbuffer,"Выбрать","Назад");
					}
			 }
		 }
		 case HUMAN:{
			 switch(profid){
					case HUMAN_PROF_SHTURMOVIK:{
							/*format(bigbuffer,sizeof(bigbuffer), "%s%s%s%s%s%s%s%s%s%s",
					        AboutSturm[0],AboutSturm[1],AboutSturm[2],AboutSturm[3],AboutSturm[4],AboutSturm[5],AboutSturm[6],AboutSturm[7],AboutSturm[8],AboutSturm[9]);
                            */
                            for(new i; i < sizeof(AboutSturm); i++) strcat(bigbuffer,AboutSturm[i]);
							ShowPlayerDialog(playerid,ABOUT_HUMAN_DIALOG,DIALOG_STYLE_MSGBOX,"О Штурмовике",bigbuffer,"Выбрать","Назад");
					}
					case HUMAN_PROF_MEDIK:{
							/*format(bigbuffer,sizeof(bigbuffer), "%s%s%s%s%s%s",
					        AboutMedik[0],AboutMedik[1],AboutMedik[2],AboutMedik[3],AboutMedik[4],AboutMedik[5]);
                            */
                            for(new i; i < sizeof(AboutMedik); i++) strcat(bigbuffer,AboutMedik[i]);
							ShowPlayerDialog(playerid,ABOUT_HUMAN_DIALOG,DIALOG_STYLE_MSGBOX,"О Медике",bigbuffer,"Выбрать","Назад");
					}
					case HUMAN_PROF_SNIPER:{
							/*format(bigbuffer,sizeof(bigbuffer), "%s%s%s%s%s%s%s%s%s",
					        AboutSniper[0],AboutSniper[1],AboutSniper[2],AboutSniper[3],AboutSniper[4],AboutSniper[5],AboutSniper[6],AboutSniper[7],AboutSniper[8]);
							*/
							for(new i; i < sizeof(AboutSniper); i++) strcat(bigbuffer,AboutSniper[i]);
							ShowPlayerDialog(playerid,ABOUT_HUMAN_DIALOG,DIALOG_STYLE_MSGBOX,"О Снайпере",bigbuffer,"Выбрать","Назад");
					}
					case HUMAN_PROF_DEFENDER:{
							/*format(bigbuffer,sizeof(bigbuffer), "%s%s%s%s%s",
					        AboutDef[0],AboutDef[1],AboutDef[2],AboutDef[3],AboutDef[4]);*/
                            for(new i; i < sizeof(AboutDef); i++) strcat(bigbuffer,AboutDef[i]);
							ShowPlayerDialog(playerid,ABOUT_HUMAN_DIALOG,DIALOG_STYLE_MSGBOX,"О Защитнике",bigbuffer,"Выбрать","Назад");
					}
					case HUMAN_PROF_CREATER:{
							/*format(bigbuffer,sizeof(bigbuffer), "%s%s%s%s%s",
					        AboutCreat[0],AboutCreat[1],AboutCreat[2],AboutCreat[3],AboutCreat[4]);
					        */
					        for(new i; i < sizeof(AboutCreat); i++) strcat(bigbuffer,AboutCreat[i]);
							ShowPlayerDialog(playerid,ABOUT_HUMAN_DIALOG,DIALOG_STYLE_MSGBOX,"О Строителе",bigbuffer,"Выбрать","Назад");
					}
			 }
		 }
	}
}

stock OpenAgeDialog(playerid,title[]="Введите ваш возраст")
{
	ShowPlayerDialog(playerid,AGE_DIALOG,DIALOG_STYLE_INPUT,title,"Введите ваш реальный возраст","Ввод","");
	return 1;
}


stock OpenAcceptRegister(playerid)
{
	 new str[128];
	 new buffer[300];
	 format(str,sizeof(str),""COL_RULE"Ваш реальный возраст - "COL_EASY"%d ",Player_Age[playerid]);
	 strcat(buffer,str);
	 format(str,sizeof(str),""COL_RULE"\nПрофессия человека - "COL_EASY"%s ",GetProfName(HUMAN,Player_HumanProfession[playerid]));
	 strcat(buffer,str);
	 format(str,sizeof(str),""COL_RULE"\nПрофессия зомби - "COL_EASY"%s ",GetProfName(ZOMBIE,Player_ZombieProfession[playerid]));
	 strcat(buffer,str);
	 format(str,sizeof(str),""COL_RULE"\nДействующий e-mail - "COL_EASY"%s ",Player_Email[playerid]);
	 strcat(buffer,str);
	 ShowPlayerDialog(playerid,ACCEPT_REGISTER_DIALOG,DIALOG_STYLE_MSGBOX,"Подтверждение выбора",buffer,"Принять","Изменить");
	 return 1;
}

stock OpenVotePanel(playerid)
{
	 new str[200];
	 if(VotePlayerID == -1)ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"Голосование за кик игрока","Введите ид игрока для рассмотрения его удаления","Выбор","Назад");
	 else
	 {
			format(str,sizeof(str),"Голосование за удаление игрока %s\nДо окончания голосования осталось %d секунд\nЗа кик проголосовало %d из нужных %d игроков\nГолосуете за удаление этого игрока?",GetName(VotePlayerID),VoteTime,VoteZa,VoteNeed);
			ShowPlayerDialog(playerid,MENU_KICK_VOTE_DIALOG_VOTE,DIALOG_STYLE_MSGBOX,"Голосование открыто",str,"Да","Нет");
	 }
	 return 1;
}


stock OpenRules(playerid,list)
{
     new bbuffer[2048];
	 if(list == 0)
	 {
			 /*
             format(bbuffer,sizeof(bbuffer), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
			 Rules[0],Rules[1],Rules[2],Rules[3],Rules[4],Rules[5],Rules[6],Rules[7],Rules[8],Rules[9],Rules[10],Rules[11],Rules[12],Rules[13],Rules[14],Rules[15],Rules[16],Rules[17],Rules[18],Rules[19]);
			 */
			 //выводим первую половинку правил
			 for(new i; i < (sizeof(Rules)/2); i++) strcat(bbuffer,Rules[i]);
			 ShowPlayerDialog(playerid,MENU_RULES_D,DIALOG_STYLE_MSGBOX,"Правила сервера: страница 1",bbuffer,"Страница 2","В меню");
	 }
	 else
	 {
			 /*
	         format(bbuffer,sizeof(bbuffer), "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
			 Rules[20],Rules[21],Rules[22],Rules[23],Rules[24],Rules[25],Rules[26],Rules[27],Rules[28],Rules[29],Rules[30],Rules[31],Rules[32],Rules[33],Rules[34],Rules[35]);
			 */
			 //выводим вторую половинку правил
			 for(new i = (sizeof(Rules)/2); i < sizeof(Rules); i++)strcat(bbuffer,Rules[i]);
			 ShowPlayerDialog(playerid,MENU_RULES_D2,DIALOG_STYLE_MSGBOX,"Правила сервера: страница 2",bbuffer,"Страница 1","В меню");
	 }
	 return 1;
}

stock OpenShop(playerid,title[]="Магазин")
{
	 ShowPlayerDialog(playerid,SHOP_DIALOG,DIALOG_STYLE_LIST,title,"Защита\nОружие\nПремиум аккаунт\nПовысить ранг текущей профессии\nПриобрести профессию\nЗдоровье для текущей профессии","Выбор","Выход");
	 return 1;
}
//таблица с ценами ВСЕХ кепок в магазине
enum caps_picture{
    cap_srok,
    cap_price
}

//(-1 - БЕСКОНЕЧНО)
static stock shop_caps_table[][caps_picture] ={
{1,5},
{7,25},
{30,80},
{-1,250}
};

#define CAP_LINE_STR 70
new CapsDialog[CAP_LINE_STR*sizeof(shop_caps_table)];
stock CreateCapsDialog()
{
	  new str[CAP_LINE_STR];
	  for(new i; i < sizeof(shop_caps_table); i++){
	      if(shop_caps_table[i][cap_srok] != -1)format(str,sizeof(str),""COL_RULE"[%d]"COL_SERVER"Срок - %d дней(-ень,-ня) - Цена %d рублей\n",i+1,shop_caps_table[i][cap_srok],shop_caps_table[i][cap_price]);
	      else format(str,sizeof(str),""COL_RULE"[%d]"COL_SERVER"Срок - Бессрочно - Цена %d рублей\n",i+1,shop_caps_table[i][cap_price]);
		  strcat(CapsDialog,str);
	  }
	  return 1;
}

stock SetSrokShop(playerid,title[]="Купить берет")
{
     ShowPlayerDialog(playerid,SHOP_CHOSEN_SROK_D,DIALOG_STYLE_LIST,title,CapsDialog,"Выбор","Выход");
	 return 1;
}
stock OpenReplaceCapDialog(playerid)//доделать - dodelal
{
	 new str[128],str2[20];
	 switch(GetPVarInt(playerid,"ChosenCap"))
	 {
		   case RED_CAP: str = "красный";
		   case BLUE_CAP: str = "синий";
		   case LIGHTBLUE_CAP: str = "голубой";
	 }
	 switch(Player_Cap[playerid])
	 {
		   case RED_CAP: str2 = "красный";
		   case BLUE_CAP: str2= "синий";
		   case LIGHTBLUE_CAP: str2 = "голубой";
	 }
	 format(str,sizeof(str),"У вас уже есть %s берет.\nПокупка нового берета заменит ваш старый.\nВы действительно хотите купить %s берет?",str2,str);
     ShowPlayerDialog(playerid,SHOP_ACCEPT_BUY_CAP,DIALOG_STYLE_MSGBOX,"Подтверждение",str,"Подтвердить","Назад");
	 return 1;
}
stock AcceptBuyCapD(playerid)
{
	 new str[200],str2[20];
	 if(GetPVarInt(playerid,"ChosenCapSrok") == -1)str = "Навсегда";
	 else format(str,sizeof(str),"На %d дней(-ень,-ня)",GetPVarInt(playerid,"ChosenCapSrok"));
	 switch(GetPVarInt(playerid,"ChosenCap"))
	 {
		   case RED_CAP: str2 = "красный";
		   case BLUE_CAP: str2 = "синий";
		   case LIGHTBLUE_CAP: str2 = "голубой";
	 }
	 format(str,sizeof(str),"Вы уверены что хотите купить %s берет %s за %d рублей?",str2,str,GetPVarInt(playerid,"TruePrice"));
	 ShowPlayerDialog(playerid,SHOP_ACCEPT_BUY_CAP_TRUE,DIALOG_STYLE_MSGBOX,"Подтвердите покупку",str,"Подтвердить","Назад");
	 return 1;
}
stock BuyCap(playerid)
{
	 new str[200],str2[20],str3[25];
	 
	 if(GetPVarInt(playerid,"ChosenCapSrok") == -1)str3 = "Навсегда";
	 else format(str3,sizeof(str3),"На %d дней(-ень,-ня)",GetPVarInt(playerid,"ChosenCapSrok"));

	 switch(GetPVarInt(playerid,"ChosenCap"))
	 {
		   case RED_CAP: str2 = "красный";
		   case BLUE_CAP: str2 = "синий";
		   case LIGHTBLUE_CAP: str2 = "голубой";
	 }
	 new srok = gettime();
	 Player_Rub[playerid] -= GetPVarInt(playerid,"TruePrice");
	 if(GetPVarInt(playerid,"ChosenCapSrok") == -1)Player_CapSrok[playerid] = -1;
	 else Player_CapSrok[playerid] = gettime()+(86400*GetPVarInt(playerid,"ChosenCapSrok"));
	 Player_Cap[playerid] = GetPVarInt(playerid,"ChosenCap");
	 SaveAccount(playerid);
	 format(str,sizeof(str),"Вы успешно купили %s берет\nДата покупки: %s\nБерет куплен %s\nЦена покупки - %d RUB\nСпасибо за покупку!",str2,date("%dd.%mm.%yyyy в %hh:%ii:%ss",srok-(UNIX_TIME_CORRECT)),str3,GetPVarInt(playerid,"TruePrice"));
	 ShowPlayerDialog(playerid,SHOP_CAP_BUYED,DIALOG_STYLE_MSGBOX,"Информация",str,"Выход","");
	 
	 format(str,sizeof(str),"%s купил %s берет сроком %s за %d рублей",GetName(playerid),str2,str3,GetPVarInt(playerid,"TruePrice"));
	 WriteLog(BUYLOG,str);
	 return 1;
}

stock RemoveCap(playerid)
{
	 Player_Cap[playerid] = NONE;
	 Player_CapSrok[playerid] = 0;
	 SaveAccount(playerid);
	 return 1;
}

stock RemoveVip(playerid)
{
	 Player_IsVip[playerid] = 0;
	 SaveAccount(playerid);
}

stock OpenRepliceGun(playerid,slotid,title[]="Замена оружия")
{
	 new str[200];
	 format(str,sizeof(str),"Подтверждение замены:\nВы уже имеете %s в одном слоте с выбранным оружием\nПокупка %s заменит ваше прежднее оружие\nВы подтверждаете замену?",WeaponNames[Player_Gun[playerid][slotid]],WeaponNames[GetPVarInt(playerid,"ChosenGun")]);
	 ShowPlayerDialog(playerid,CHOSEN_GUN_REPLACE_D,DIALOG_STYLE_MSGBOX,title,str,"Подтвердить","Отменить");
	 return 1;
}



stock OpenAcceptGun(playerid,title[]="Подтверждение покупки")
{
	 new str[200],price,srok[25];
	 if(GetPVarInt(playerid,"ChosenValute") == RUB){str = "RUB";price = GetPVarInt(playerid,"ChosenGunPriceRub");}
	 else {str = "ZM";price = GetPVarInt(playerid,"ChosenGunPriceZm");}
	 
	 if(GetPVarInt(playerid,"ChosenSrok") == -1)srok = "Навсегда";
	 else format(srok,sizeof(srok),"На %d дней(-ень,-ня)",GetPVarInt(playerid,"ChosenSrok"));
	 //"ChosenAmmo"
	 format(str,sizeof(str),"Подтверждение покупки:\nОружие: %s\nКоличество патронов: %d\nЦена: %d %s\nПриобрести %s\nВы подтверждаете покупку?",
	 WeaponNames[GetPVarInt(playerid,"ChosenGun")],
     GetPVarInt(playerid,"ChosenAmmo"),
     price,
     str,
     srok);
	 ShowPlayerDialog(playerid,CHOSEN_GUN_ACCEPT_D,DIALOG_STYLE_MSGBOX,title,str,"Подтвердить","Назад");
	 return 1;
}

stock OpenBuyedGunGun(playerid)
{
	 new str[200],price,srok[25],log[100];
	 if(GetPVarInt(playerid,"ChosenValute") == RUB){str = "RUB";price = GetPVarInt(playerid,"ChosenGunPriceRub");}
	 else {str = "ZM";price = GetPVarInt(playerid,"ChosenGunPriceZm");}

	 if(GetPVarInt(playerid,"ChosenSrok") == -1)srok = "Навсегда";
	 else format(srok,sizeof(srok),"На %d дней(-ень,-ня)",GetPVarInt(playerid,"ChosenSrok"));
	 format(log,sizeof(log),"%s купил %s(П %d) сроком %s за %d %s",
	 GetName(playerid),
	 WeaponNames[GetPVarInt(playerid,"ChosenGun")],
	 GetPVarInt(playerid,"ChosenAmmo"),
	 srok,
	 price,
	 str);
	 WriteLog(BUYLOG,log);
	 
	 //"ChosenAmmo"
	 format(str,sizeof(str),"Информация о покупке:\nОружие: %s\nКоличество патронов: %d\nЦена: %d %s\nПриобретено %s\nДата покупки: %s\nСпасибо за покупку!",
	 WeaponNames[GetPVarInt(playerid,"ChosenGun")],
     GetPVarInt(playerid,"ChosenAmmo"),
     price,
     str,
     srok,
	 date("%dd.%mm.%yyyy в %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT)));
	 ShowPlayerDialog(playerid,CHOSEN_GUN_ACCEPT_D_22,DIALOG_STYLE_MSGBOX,"Покупка выполнена",str,"Выход","");
	 
	 if(GetPVarInt(playerid,"ChosenValute") == RUB)Player_Rub[playerid] -= price;
	 else Player_Zm[playerid] -= price;
	 
	 Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] = GetPVarInt(playerid,"ChosenGun");
	 Player_Ammo[playerid][GetPVarInt(playerid,"ChosenGunClass")] = GetPVarInt(playerid,"ChosenAmmo");
	 if(GetPVarInt(playerid,"ChosenSrok") != -1)Player_GunSrok[playerid][GetPVarInt(playerid,"ChosenGunClass")] = gettime()+(86400*GetPVarInt(playerid,"ChosenSrok"));
	 else Player_GunSrok[playerid][GetPVarInt(playerid,"ChosenGunClass")] = -1;
	 
	 SaveAccount(playerid);
	 
	 if((Game_Started && S[playerid] == 2) && Player_CurrentTeam[playerid] == HUMAN)GivePlayerWeapon(playerid,GetPVarInt(playerid,"ChosenGun"),GetPVarInt(playerid,"ChosenAmmo"));
	 return 1;
}


//Карабины
stock CreateKarabinsDialog(){
     new str[SHOP_GUNS_DIALOG_LINE_SIZE];
	 for(new i; i < sizeof(shop_karabins_table); i++){
		   format(str,sizeof(str),""COL_LIME"[%d]"COL_YELLOW"%s - Количество: %d - %dRub",i+1,WeaponNames[shop_karabins_table[i][gun_iden]],shop_karabins_table[i][gun_ammo],shop_karabins_table[i][gun_rubprice]);
           strcat(Karabins_Dialog,str);
		   if(shop_karabins_table[i][gun_zmprice] != -1){
			   format(str,sizeof(str),"/%d ZM",shop_karabins_table[i][gun_zmprice]);
			   strcat(Karabins_Dialog,str);
		   }
		   if(shop_karabins_table[i][gun_srok] == -1){
               strcat(Karabins_Dialog," - Навсегда\n");
               continue;
		   }
		   format(str,sizeof(str)," - На %d Дней\n",shop_karabins_table[i][gun_srok]);
		   strcat(Karabins_Dialog,str);
	 }
	 return 1;
}

//Дробовики

stock CreateShotgunsDialog(){
     new str[SHOP_GUNS_DIALOG_LINE_SIZE];
	 for(new i; i < sizeof(shop_shotguns_table); i++){
		   format(str,sizeof(str),""COL_LIME"[%d]"COL_YELLOW"%s - Количество: %d - %dRub",i+1,WeaponNames[shop_shotguns_table[i][gun_iden]],shop_shotguns_table[i][gun_ammo],shop_shotguns_table[i][gun_rubprice]);
           strcat(Shotguns_Dialog,str);
		   if(shop_shotguns_table[i][gun_zmprice] != -1){
			   format(str,sizeof(str),"/%d ZM",shop_shotguns_table[i][gun_zmprice]);
			   strcat(Shotguns_Dialog,str);
		   }
		   if(shop_shotguns_table[i][gun_srok] == -1){
               strcat(Shotguns_Dialog," - Навсегда\n");
               continue;
		   }
		   format(str,sizeof(str)," - На %d Дней\n",shop_shotguns_table[i][gun_srok]);
		   strcat(Shotguns_Dialog,str);
	 }
	 return 1;
}


//Пистолеты

stock CreatePistolsDialog(){
     new str[SHOP_GUNS_DIALOG_LINE_SIZE];
	 for(new i; i < sizeof(shop_pistols_table); i++){
		   format(str,sizeof(str),""COL_LIME"[%d]"COL_YELLOW"%s - Количество: %d - %dRub",i+1,WeaponNames[shop_pistols_table[i][gun_iden]],shop_pistols_table[i][gun_ammo],shop_pistols_table[i][gun_rubprice]);
           strcat(Pistols_Dialog,str);
		   if(shop_pistols_table[i][gun_zmprice] != -1){
			   format(str,sizeof(str),"/%d ZM",shop_pistols_table[i][gun_zmprice]);
			   strcat(Pistols_Dialog,str);
		   }
		   if(shop_pistols_table[i][gun_srok] == -1){
               strcat(Pistols_Dialog," - Навсегда\n");
               continue;
		   }
		   format(str,sizeof(str)," - На %d Дней\n",shop_pistols_table[i][gun_srok]);
		   strcat(Pistols_Dialog,str);
	 }
	 return 1;
}

//Автоматы

stock CreateAvtomatsDialog(){
     new str[SHOP_GUNS_DIALOG_LINE_SIZE];
	 for(new i; i < sizeof(shop_avtomats_table); i++){
		   format(str,sizeof(str),""COL_LIME"[%d]"COL_YELLOW"%s - Количество: %d - %dRub",i+1,WeaponNames[shop_avtomats_table[i][gun_iden]],shop_avtomats_table[i][gun_ammo],shop_avtomats_table[i][gun_rubprice]);
           strcat(Avtomats_Dialog,str);
		   if(shop_avtomats_table[i][gun_zmprice] != -1){
			   format(str,sizeof(str),"/%d ZM",shop_avtomats_table[i][gun_zmprice]);
			   strcat(Avtomats_Dialog,str);
		   }
		   if(shop_avtomats_table[i][gun_srok] == -1){
               strcat(Avtomats_Dialog," - Навсегда\n");
               continue;
		   }
		   format(str,sizeof(str)," - На %d Дней\n",shop_avtomats_table[i][gun_srok]);
		   strcat(Avtomats_Dialog,str);
	 }
	 return 1;
}
/*
#define GUN_PISTOLS 0
#define GUN_AVTOMATS 1
#define GUN_SHOTGUNS 2
#define GUN_MASHINEGUNS 3
*/


stock OpenChoseGun(playerid,listitem)
{
     SetPVarInt(playerid,"ChosenGunClass",listitem);
	 switch(listitem){
		   case GUN_PISTOLS:ShowPlayerDialog(playerid,SHOP_GUN_DIALOG_PISTOLS,DIALOG_STYLE_LIST,"Пистолеты",Pistols_Dialog,"Выбрать","Назад");
		   case GUN_AVTOMATS:ShowPlayerDialog(playerid,SHOP_GUN_AVTOMATS_D,DIALOG_STYLE_LIST,"Автоматы",Avtomats_Dialog,"Выбрать","Назад");
		   case GUN_SHOTGUNS:ShowPlayerDialog(playerid,SHOP_GUN_SHOTGUNS_D,DIALOG_STYLE_LIST,"Дробовики",Shotguns_Dialog,"Выбрать","Назад");
		   case GUN_MASHINEGUNS:ShowPlayerDialog(playerid,SHOP_GUN_KARABINS_D,DIALOG_STYLE_LIST,"Штурмовые винтовки",Karabins_Dialog,"Выбрать","Назад");
	 }
	 return 1;
}

stock FixPlayerBuyed(playerid)
{
     new str[100];
	 if(Player_Cap[playerid] != NONE)
	 {
          if(Player_CapSrok[playerid] > 0)
          {
				 if(gettime() >= Player_CapSrok[playerid])
				 {
                      RemoveCap(playerid);
                      SendClientMessage(playerid,-1,"Ваш купленный берет был удален по истечению срока покупки");
				 }
          }

	 }
     if(Player_IsVip[playerid] > 0)
     {
		  if(gettime() >= Player_IsVip[playerid])
		  {
                   RemoveVip(playerid);
                   SendClientMessage(playerid,-1,"Срок использования премиум аккаунта истек");
		  }
     }
     for(new i; i < MAX_SLOTS; i++)
	 {
		  if(Player_GunSrok[playerid][i] < 1)continue;
		  if(gettime() >= Player_GunSrok[playerid][i])
		  {
				format(str,100,"Купленный вами %s был удален по истечению срока действия",WeaponNames[Player_Gun[playerid][i]]);
				SendClientMessage(playerid,-1,str);
                Player_Gun[playerid][i] = 0;
                Player_Ammo[playerid][i] = 0;
                Player_GunSrok[playerid][i] = 0;
				SaveAccount(playerid);
		  }
     }
	 return 1;
}




stock OpenGunShop(playerid)
{

    ShowPlayerDialog(playerid,SHOP_GUNS_D,DIALOG_STYLE_LIST,"Купить оружие","Пистолеты\nАвтоматы\nДробовики\nШтурмовые винтовки","Выбрать","Назад");
	return 1;
}

stock OpenVipAccept(playerid,title[]= "Подтверждение покупки")
{
	 new str[100];
	 if(GetPVarInt(playerid,"VipSrok") != -1)format(str,sizeof(str),"Цена: %d RUB\nСрок: %d дней\nКупить премиум аккаунт?",GetPVarInt(playerid,"VipPrice"),GetPVarInt(playerid,"VipSrok"));
	 else format(str,sizeof(str),"Цена: %d RUB\nСрок: Пожизненно\nКупить премиум аккаунт?",GetPVarInt(playerid,"VipPrice"));
	 ShowPlayerDialog(playerid,SHOP_VIP_ACCEPT_D,DIALOG_STYLE_MSGBOX,title,str,"Купить","Назад");
	 return 1;
}

//выдать вип на Х срок
stock GiveVip(playerid,srok)
{
    if(srok != -1)Player_IsVip[playerid] = gettime()+(86400*srok);
    else Player_IsVip[playerid] = -1;
	SaveAccount(playerid);
	return 1;
}

//выдача всего купленного оружия игроку
stock GiveShopGuns(playerid)
{
	for(new i; i < MAX_SLOTS; i++)
	{
	      if(Player_Gun[playerid][i] == 0)continue;
		  GivePlayerWeapon(playerid,Player_Gun[playerid][i],Player_Ammo[playerid][i]);
    }
	return 1;
}

//скрыть защиту и дать игроку сделать спавн, показать статистику
stock HideEffectsAndStartGame(playerid)
{
       SetPVarInt(playerid,"Logged",1);
       TextDrawHideForPlayer(playerid, LoadScreen);
       TextDrawHideForPlayer(playerid, CreatedBy);
       
       CreateProfAndRank3DInformer(playerid);
   	   __InfectText__CreateLabel(playerid);
       
       //Спавним игрока
       SetPlayerSpawnInArea(playerid,CurrentMap); // установка спавна
       //SetSpawnInfo(playerid,0,0,0.0,0.0,0.0,0.0,0,0,0,0,0,0); // вместо skin указывайте скин игрока, который должен быть у него. Для RP серверов присутствуют такие переменные.
       SpawnPlayer(playerid);
       return 1;
}

//урок http://pawno.ru/showthread.php?31281-%C1%E0%ED-%ED%E0-%E2%F0%E5%EC%FF-%F1-%E8%F1%EF%EE%EB%FC%E7%EE%E2%E0%ED%E8%E5%EC-unix-%E2%F0%E5%EC%E5%ED%E8
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if( OnAntiCheatUpdatePlayer(playerid, AC_DIALOG_HACK_, dialogid) )
	{
   			OnPlayerUseDialogHack( playerid, dialogid);
		  	return 1;
	}
	new buff[512],bigbuffer[1024];
	switch(dialogid)
	{
		  case DIALOG_YOU_NEEDED_NEW_PROF_YES:return OpenProfessionChoseProfession(playerid,GetPVarInt(playerid,"ChosenTeam"));
		  case DIALOG_YOU_NEEDED_NEW_PROF:
		  {
		          if(!response)return OpenProfessionChoseProfession(playerid,GetPVarInt(playerid,"ChosenTeam"));
		          new price;
		          if(GetPVarInt(playerid,"ChosenTeam") == ZOMBIE)price = ZOMBIE_PROFESSIONS_PRICE;
	              else if(GetPVarInt(playerid,"ChosenTeam") == HUMAN)price = HUMAN_PROFESSIONS_PRICE;
		          if(Player_Rub[playerid] < price)return OpenProfessionChoseProfession(playerid,GetPVarInt(playerid,"ChosenTeam"),"У вас недостаточно рублей");
				  Player_Rub[playerid] -= price;
				  SwitchProfession(playerid,GetPVarInt(playerid,"ChosenTeam"),GetPVarInt(playerid,"ChosenTeamClass"));
				  SaveAccount(playerid);
				  OpenProfessionBuy(playerid,DIALOG_YOU_NEEDED_NEW_PROF_YES);
		  }
		  case MENU_MYPROFS_CHOSE_CLASS:
		  {
				  if(!response)return OpenMyProfs(playerid);
				  SetPVarInt(playerid,"ChosenTeamClass",listitem);
				  switch(GetPVarInt(playerid,"ChosenTeam")){
					   case ZOMBIE:{
							  if(Player_Z_HaveProfession[playerid][listitem]){
									if(Game_Started && Infection_Time == 0)return OpenProfessionChoseProfession(playerid,ZOMBIE,"Заражение уже началось");
                                    SwitchProfession(playerid,ZOMBIE,listitem);
                                    OpenProfessionChoseProfession(playerid,ZOMBIE,"Профессия зомби изменена");
									return 1;
							  }
							  else
							  {
							        format(buff, sizeof(buff), "Вы не владеете данной профессией\nВы можете купить ее прямо сейчас всего за %d рублей\nВы хотите совершить покупку?",ZOMBIE_PROFESSIONS_PRICE);
							  }
					   }
					   case HUMAN:{
                              if(Player_H_HaveProfession[playerid][listitem]){
                                    if(Game_Started && Infection_Time == 0)return OpenProfessionChoseProfession(playerid,HUMAN,"Заражение уже началось");
                                    SwitchProfession(playerid,HUMAN,listitem);
                                    OpenProfessionChoseProfession(playerid,HUMAN,"Профессия человека изменена");
                                    return 1;
							  }
							  else
							  {
							    	format(buff, sizeof(buff), "Вы не владеете данной профессией\nВы можете купить ее прямо сейчас всего за %d рублей\nВы хотите совершить покупку?",HUMAN_PROFESSIONS_PRICE);
							  }
					   }
				  }
				  ShowPlayerDialog(playerid,DIALOG_YOU_NEEDED_NEW_PROF,DIALOG_STYLE_MSGBOX,"Предложение",buff,"Купить","Назад");
		  }
		  case MENU_MYPROFS_CHOSE_TEAM:
		  {
				  if(!response)return OpenGMenu(playerid);
				  OpenProfessionChoseProfession(playerid,listitem);
		  }
		  //Покупка оружия
		  case CHOSEN_GUN_ACCEPT_D:
		  {
				  if(!response)return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  if(GetPVarInt(playerid,"ChosenValute") == RUB && ( GetPVarInt(playerid,"ChosenGunPriceRub" ) > Player_Rub[playerid] ))return OpenAcceptGun(playerid,"Недостаточно RUB!");
				  if(GetPVarInt(playerid,"ChosenValute") == ZM  && ( GetPVarInt(playerid,"ChosenGunPriceZm" ) > Player_Zm[playerid] ))return OpenAcceptGun(playerid,"Недостаточно Zombie Money!");
                  OpenBuyedGunGun(playerid);
		  }
		  //Подтверждение замены
		  case CHOSEN_GUN_REPLACE_D:
		  {
				  if(!response)return OpenGunShop(playerid);
				  OpenAcceptGun(playerid);
		  }
		  //Выбор валюты
		  case SHOP_BUY_GUN_VALUTE_CHOSE_D:
		  {
				  if(!response)return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  SetPVarInt(playerid,"ChosenValute",listitem);
				  //Подтверждение замены
				  if(Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] != 0)return OpenRepliceGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  //подтверждение покупки
				  OpenAcceptGun(playerid);
		  }
		  case SHOP_BUY_PROFESSION_BUYED_D:return Open_ChoseProfessionClass(playerid,GetPVarInt(playerid,"ChosenTeam"));
		  case CHOSEN_GUN_ACCEPT_D_22: return OpenShop(playerid);
		  case SHOP_CAP_BUYED:return OpenShop(playerid);
		  //Карабины
		  case SHOP_GUN_KARABINS_D:
		  {
                  if(!response)return OpenGunShop(playerid);
				  SetPVarInt(playerid,"ChosenGun",shop_karabins_table[listitem][gun_iden]);
				  SetPVarInt(playerid,"ChosenSrok",shop_karabins_table[listitem][gun_srok]);
				  SetPVarInt(playerid,"ChosenAmmo",shop_karabins_table[listitem][gun_ammo]);
                  SetPVarInt(playerid,"ChosenGunPriceRub",shop_karabins_table[listitem][gun_rubprice]);
                  SetPVarInt(playerid,"ChosenGunPriceZm",shop_karabins_table[listitem][gun_zmprice]);
				  if(shop_karabins_table[listitem][gun_zmprice] > 0)
				  {
				         //выбор валюты
				         ShowPlayerDialog(playerid,SHOP_BUY_GUN_VALUTE_CHOSE_D,DIALOG_STYLE_LIST,"Выбор валюты","Рубли\nZombie Money","Выбрать","Назад");
				         return 1;
                  }
                  if(Player_Rub[playerid] < shop_karabins_table[listitem][gun_rubprice])return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass")),SendClientMessage(playerid,COLOR_RED,"У вас недостаточно RUB");
				  SetPVarInt(playerid,"ChosenValute",RUB);
				  //Подтверждение замены
				  if(Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] != 0)return OpenRepliceGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  //подтверждение покупки
				  OpenAcceptGun(playerid);
		  }
		  //Дробс
		  case SHOP_GUN_SHOTGUNS_D:
		  {
                  if(!response)return OpenGunShop(playerid);
				  SetPVarInt(playerid,"ChosenGun",shop_shotguns_table[listitem][gun_iden]);
				  SetPVarInt(playerid,"ChosenSrok",shop_shotguns_table[listitem][gun_srok]);
				  SetPVarInt(playerid,"ChosenAmmo",shop_shotguns_table[listitem][gun_ammo]);
                  SetPVarInt(playerid,"ChosenGunPriceRub",shop_shotguns_table[listitem][gun_rubprice]);
                  SetPVarInt(playerid,"ChosenGunPriceZm",shop_shotguns_table[listitem][gun_zmprice]);
				  if(shop_shotguns_table[listitem][gun_zmprice] > 0)
				  {
				         //выбор валюты
				         ShowPlayerDialog(playerid,SHOP_BUY_GUN_VALUTE_CHOSE_D,DIALOG_STYLE_LIST,"Выбор валюты","Рубли\nZombie Money","Выбрать","Назад");
				         return 1;
                  }
                  if(Player_Rub[playerid] < shop_shotguns_table[listitem][gun_rubprice])return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass")),SendClientMessage(playerid,COLOR_RED,"У вас недостаточно RUB");
				  SetPVarInt(playerid,"ChosenValute",RUB);
				  //Подтверждение замены
				  if(Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] != 0)return OpenRepliceGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  //подтверждение покупки
				  OpenAcceptGun(playerid);
		  }
		  //Машиниганы (автоматы)
		  case SHOP_GUN_AVTOMATS_D:
		  {
		          if(!response)return OpenGunShop(playerid);
				  SetPVarInt(playerid,"ChosenGun",shop_avtomats_table[listitem][gun_iden]);
				  SetPVarInt(playerid,"ChosenSrok",shop_avtomats_table[listitem][gun_srok]);
				  SetPVarInt(playerid,"ChosenAmmo",shop_avtomats_table[listitem][gun_ammo]);
                  SetPVarInt(playerid,"ChosenGunPriceRub",shop_avtomats_table[listitem][gun_rubprice]);
                  SetPVarInt(playerid,"ChosenGunPriceZm",shop_avtomats_table[listitem][gun_zmprice]);
				  if(shop_avtomats_table[listitem][gun_zmprice] > 0)
				  {
				         //выбор валюты
				         ShowPlayerDialog(playerid,SHOP_BUY_GUN_VALUTE_CHOSE_D,DIALOG_STYLE_LIST,"Выбор валюты","Рубли\nZombie Money","Выбрать","Назад");
				         return 1;
                  }
                  if(Player_Rub[playerid] < shop_avtomats_table[listitem][gun_rubprice])return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass")),SendClientMessage(playerid,COLOR_RED,"У вас недостаточно RUB");
				  SetPVarInt(playerid,"ChosenValute",RUB);
				  //Подтверждение замены
				  if(Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] != 0)return OpenRepliceGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  //подтверждение покупки
				  OpenAcceptGun(playerid);
		  }
		  //пиколи
		  case SHOP_GUN_DIALOG_PISTOLS:
		  {
				  if(!response)return OpenGunShop(playerid);
				  SetPVarInt(playerid,"ChosenGun",shop_pistols_table[listitem][gun_iden]);
				  SetPVarInt(playerid,"ChosenSrok",shop_pistols_table[listitem][gun_srok]);
				  SetPVarInt(playerid,"ChosenAmmo",shop_pistols_table[listitem][gun_ammo]);
                  SetPVarInt(playerid,"ChosenGunPriceRub",shop_pistols_table[listitem][gun_rubprice]);
                  SetPVarInt(playerid,"ChosenGunPriceZm",shop_pistols_table[listitem][gun_zmprice]);
				  if(shop_pistols_table[listitem][gun_zmprice] > 0)
				  {
				         //выбор валюты
				         ShowPlayerDialog(playerid,SHOP_BUY_GUN_VALUTE_CHOSE_D,DIALOG_STYLE_LIST,"Выбор валюты","Рубли\nZombie Money","Выбрать","Назад");
				         return 1;
                  }
                  if(Player_Rub[playerid] < shop_pistols_table[listitem][gun_rubprice])return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass")),SendClientMessage(playerid,COLOR_RED,"У вас недостаточно RUB");
				  SetPVarInt(playerid,"ChosenValute",RUB);
				  //Подтверждение замены
				  if(Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] != 0)return OpenRepliceGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  //подтверждение покупки
				  OpenAcceptGun(playerid);
		  }
		  case SHOP_GUNS_D:
		  {
				  if(!response)return OpenShop(playerid);
				  OpenChoseGun(playerid,listitem);
		  }
		  //выбор класса в покупке класса
		  case SHOP_BUY_PROFESSION_CHOSE_PROF:
		  {
				  if(!response)return OpenProfBuy(playerid);
				  new price;
				  if(GetPVarInt(playerid,"ChosenTeam") == ZOMBIE)price = ZOMBIE_PROFESSIONS_PRICE;
	              else if(GetPVarInt(playerid,"ChosenTeam") == HUMAN)price = HUMAN_PROFESSIONS_PRICE;
				  if(Player_Rub[playerid] < price)return SendClientMessage(playerid,COLOR_GRAYTEXT,"У вас недостаточно рублей!"),Open_ChoseProfessionClass(playerid,GetPVarInt(playerid,"ChosenTeam"));
				  switch(GetPVarInt(playerid,"ChosenTeam"))
				  {
						case ZOMBIE:
						{
							   if(Player_Z_HaveProfession[playerid][listitem])return SendClientMessage(playerid,COLOR_GRAYTEXT,"Вы уже владеете данной профессией"),Open_ChoseProfessionClass(playerid,GetPVarInt(playerid,"ChosenTeam"));
                               Player_Z_HaveProfession[playerid][listitem] = true;
						}
						case HUMAN:
						{
							   if(Player_H_HaveProfession[playerid][listitem])return SendClientMessage(playerid,COLOR_GRAYTEXT,"Вы уже владеете данной профессией"),Open_ChoseProfessionClass(playerid,GetPVarInt(playerid,"ChosenTeam"));
                               Player_H_HaveProfession[playerid][listitem] = true;
						}
				  }
				  SetPVarInt(playerid,"ChosenTeamClass",listitem);
				  Player_Rub[playerid] -= price;
				  SaveAccount(playerid);
				  OpenProfessionBuy(playerid);
				  ///Open_ChoseProfessionClass(playerid,GetPVarInt(playerid,"ChosenTeam"));
		  }
		  //выбор команды в покупке класса
		  case SHOP_BUY_PROFESSION_CHOSE_TEAM:
		  {
 				  if(!response)return OpenShop(playerid);
 				  SetPVarInt(playerid,"ChosenTeam",listitem);
 				  Open_ChoseProfessionClass(playerid,listitem);
		  }
		  case SHOP_DIALOG:
		  {
				  if(!response)return 1;
				  switch(listitem)
				  {
					   //защита
					   case 0:ShowPlayerDialog(playerid,SHOP_PROTECT_D,DIALOG_STYLE_LIST,"Защита","Красный берет - 2x опыта при убийстве\nГолубой берет - 2x ZM при убийстве\nСиняя бандана - с ней вас невозможно заразить","Приобрести","Назад");
					   //патроны
					   case 1:OpenGunShop(playerid);
					   //випа
					   case 2:
					   {
							 if(Player_IsVip[playerid] != 0)return OpenShop(playerid,"Вы уже имеете премиум");
							 ShowPlayerDialog(playerid,SHOP_VIP_D,DIALOG_STYLE_LIST,"Приобрести премиум",VipDialog,"Выбрать","Назад");
					   }
					   //ранг
					   case 3: ShowPlayerDialog(playerid,SHOP_UPG_RANK,DIALOG_STYLE_LIST,"Выберите основу класса","Люди - 50 RUB\nЗомби - 50 RUB","Выбрать","Выход");
					   //купить профу
					   case 4: OpenProfBuy(playerid);
					   //купить здоровье
					   case 5:  ShowPlayerDialog(playerid,SHOP_BUY_HEALTH,DIALOG_STYLE_LIST,"Выберите основу профессии","Зомби\nЛюди","Выбрать","Выход");
				  }
		  }
		  //Покупка ХП
		  case SHOP_BUY_HEALTH_INFO:return OpenShop(playerid);
		  case SHOP_BUY_HEALTH_ACCEPT:
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_BUY_HEALTH_CHOSE_VALUTE,DIALOG_STYLE_LIST,"Выбор валюты","Рубли\nZombie Money","Выбор","Назад");
				  new price;
				  switch(GetPVarInt(playerid,"ChosenValute"))
	              {
		               case RUB:{
                             price =  GetPVarInt(playerid,"ChosenKolvo")*SHOP_HEALTH_PRICE_RUB;
                             if(Player_Rub[playerid] < price)return OpenAcceptBuyHealth(playerid,"У вас недостаточно средств");
                             Player_Rub[playerid] -= price;
					   } 
		               case ZM:{
		                     price = GetPVarInt(playerid,"ChosenKolvo")*SHOP_HEALTH_PRICE_ZM;
		                     if(Player_Zm[playerid] < price)return OpenAcceptBuyHealth(playerid,"У вас недостаточно средств");
		                     Player_Zm[playerid] -= price;
					   } 
                  }
                  switch(GetPVarInt(playerid,"ChosenTeam"))
                  {
					   case HUMAN: Player_H_DopHealth[playerid][Player_HumanProfession[playerid]] += GetPVarInt(playerid,"ChosenKolvo");
					   case ZOMBIE: Player_Z_DopHealth[playerid][Player_ZombieProfession[playerid]] += GetPVarInt(playerid,"ChosenKolvo");
                  }
                  OpenBuyHealthInfo(playerid);
                  SaveAccount(playerid);
		  }
		  case SHOP_BUY_HEALTH_CHOSE_VALUTE:
		  {
				  if(!response)return OpenBuyHealth(playerid,GetPVarInt(playerid,"ChosenTeam"));
				  SetPVarInt(playerid,"ChosenValute",listitem);
				  OpenAcceptBuyHealth(playerid);
		  }
		  case SHOP_BUY_HEALTH_ENTER_KOLVO:
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_BUY_HEALTH,DIALOG_STYLE_LIST,"Выберите основу профессии","Зомби\nЛюди","Выбрать","Выход");
				  if(!isNumeric(inputtext) || strval(inputtext) < 1)return OpenBuyHealth(playerid,GetPVarInt(playerid,"ChosenTeam"));
				  new maxhp;
				  if(GetPVarInt(playerid,"ChosenTeam") == ZOMBIE)
				  {
				        maxhp = PLAYER_MAX_BUYED_HEALTH_FOR_ZOMBIE-Player_Z_DopHealth[playerid][Player_ZombieProfession[playerid]];
				        
						if( maxhp < strval(inputtext) )return OpenBuyHealth(playerid,GetPVarInt(playerid,"ChosenTeam")),SendClientMessage(playerid,-1,"Неверное количество");
				  }
				  else if(GetPVarInt(playerid,"ChosenTeam") == HUMAN)
				  {
				        maxhp = PLAYER_MAX_BUYED_HEALTH_FOR_HUMAN - Player_H_DopHealth[playerid][Player_HumanProfession[playerid]];
						if( maxhp < strval(inputtext) )return OpenBuyHealth(playerid,GetPVarInt(playerid,"ChosenTeam")),SendClientMessage(playerid,-1,"Неверное количество");
				  }
				  SetPVarInt(playerid,"ChosenKolvo",strval(inputtext));
				  ShowPlayerDialog(playerid,SHOP_BUY_HEALTH_CHOSE_VALUTE,DIALOG_STYLE_LIST,"Выбор валюты","Рубли\nZombie Money","Выбор","Назад");
		  }
		  case SHOP_BUY_HEALTH:
		  {
				  if(!response)return OpenShop(playerid);
				  SetPVarInt(playerid,"ChosenTeam",listitem);
				  OpenBuyHealth(playerid,listitem);
		  }
		  //Покупка ХП: конец
		  //====================================
		  case SHOP_UPG_RANK:
		  {
				  if(!response)return OpenShop(playerid);
				  if(Player_Rub[playerid] < 50)return ShowPlayerDialog(playerid,SHOP_UPG_RANK,DIALOG_STYLE_LIST,"У вас недостаточно RUB","Люди - 50 RUB\nЗомби - 50 RUB","Выбрать","Выход");
				  switch(listitem)
				  {
					   case 0:
					   {
							 if(Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] >= 4)return ShowPlayerDialog(playerid,SHOP_UPG_RANK,DIALOG_STYLE_LIST,"В данном классе вы имеете макс. ранг","Люди - 50 RUB\nЗомби - 50 RUB","Выбрать","Выход");
							 UpgradeHumanRang(playerid,Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]+1);
							 buff = "Людской";
					   }
					   case 1:
					   {
					         if(Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] >= 4)return ShowPlayerDialog(playerid,SHOP_UPG_RANK,DIALOG_STYLE_LIST,"В данном классе вы имеете макс. ранг","Люди - 50 RUB\nЗомби - 50 RUB","Выбрать","Выход");
							 UpgradeZombieRang(playerid,Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]+1);
							 buff = "Зомби";
					   }
				  }
				  Player_Rub[playerid] -= 50;
				  format(bigbuffer,100,"%s повысил свой %s ранг за 50 рублей",GetName(playerid),buff);
				  WriteLog(BUYLOG,bigbuffer);
				  ShowPlayerDialog(playerid,SHOP_UPG_RANK,DIALOG_STYLE_LIST,"Ранг успешно повышен","Люди - 50 RUB\nЗомби - 50 RUB","Выбрать","Выход");
		  }
		  case SHOP_VIP_ACCEPT_D:
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_VIP_D,DIALOG_STYLE_LIST,"Приобрести премиум",VipDialog,"Выбрать","Назад");
				  if(Player_IsVip[playerid] != 0)return OpenVipAccept(playerid,"Вы уже имеете премиум");
				  if(Player_Rub[playerid] < GetPVarInt(playerid,"VipPrice"))return OpenVipAccept(playerid,"У вас недостаточно RUB");
				  Player_Rub[playerid] -= GetPVarInt(playerid,"VipPrice");
				  GiveVip(playerid,GetPVarInt(playerid,"VipSrok"));
				  new str[128];
				  if(GetPVarInt(playerid,"VipSrok") != -1)
				  format(str,sizeof(str),"Информация о покупке\nПремиум аккаунт\nЦена: %d\nСрок: %d дней\nДата покупки: %s",GetPVarInt(playerid,"VipPrice"),GetPVarInt(playerid,"VipSrok"),date("%dd.%mm.%yyyy в %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT)));
				  else format(str,sizeof(str),"Информация о покупке\nПремиум аккаунт\nЦена: %d\nСрок: Пожизненно\nДата покупки: %s",GetPVarInt(playerid,"VipPrice"),date("%dd.%mm.%yyyy в %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT)));

				  ShowPlayerDialog(playerid,SHOP_VIP_BUYED_D,DIALOG_STYLE_MSGBOX,"Информация о покупке",str,"Выход","");
				  
				  if(GetPVarInt(playerid,"VipSrok") != -1){
				     format(str,sizeof(str),"%s купил премиум-аккаунт сроком на %d дней за %d рублей",
	                 GetName(playerid),
	                 GetPVarInt(playerid,"VipSrok"),
	                 GetPVarInt(playerid,"VipPrice"));
				  }
	              else{
				     format(str,sizeof(str),"%s купил премиум-аккаунт навсегда за %d рублей",
	                 GetName(playerid),
	                 GetPVarInt(playerid,"VipPrice"));
				  }
				  WriteLog(BUYLOG,str);
		  }
		  case SHOP_VIP_BUYED_D:return OpenShop(playerid);
		  case SHOP_VIP_D:
		  {
				  if(!response)return OpenShop(playerid);
				  new price,srok;
				  
				  srok = vip_date[listitem][vip_srok];
				  price = vip_date[listitem][vip_price];
				  if(Player_Rub[playerid] < price)return ShowPlayerDialog(playerid,SHOP_VIP_D,DIALOG_STYLE_LIST,"У вас недостаточно RUB",VipDialog,"Выбрать","Назад");
				  SetPVarInt(playerid,"VipPrice",price);
				  SetPVarInt(playerid,"VipSrok",srok);
				  OpenVipAccept(playerid);
		  }
		  case SHOP_PROTECT_D:
		  {
		          if(!response)return OpenShop(playerid);
				  SetPVarInt(playerid,"ChosenCap",listitem+1);
				  switch(listitem)
				  {
						case 0: SetSrokShop(playerid,"Приобрести красный берет");
						case 1: SetSrokShop(playerid,"Приобрести голубой берет");
						case 2: SetSrokShop(playerid,"Приобрести синий берет");
				  }
				  
		  }
		  case SHOP_ACCEPT_BUY_CAP_TRUE:
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_PROTECT_D,DIALOG_STYLE_LIST,"Защита","Красный берет - 2x опыта при убийстве\nГолубой берет - 2x ZM при убийстве\nСиняя бандана - с ней вас невозможно заразить","Приобрести","Назад");
				  if(GetPVarInt(playerid,"TruePrice") > Player_Rub[playerid])return SetSrokShop(playerid,"У вас недостаточно денег!");
				  BuyCap(playerid);
		  }
		  case SHOP_ACCEPT_BUY_CAP:
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_PROTECT_D,DIALOG_STYLE_LIST,"Защита","Красный берет - 2x опыта при убийстве\nГолубой берет - 2x ZM при убийстве\nСиняя бандана - с ней вас невозможно заразить","Приобрести","Назад");
				  AcceptBuyCapD(playerid);
		  }
		  case SHOP_CHOSEN_SROK_D://доделать - гтво
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_PROTECT_D,DIALOG_STYLE_LIST,"Защита","Красный берет - 2x опыта при убийстве\nГолубой берет - 2x ZM при убийстве\nСиняя бандана - с ней вас невозможно заразить","Приобрести","Назад");

                  if(Player_Rub[playerid] < shop_caps_table[listitem][cap_price])return SetSrokShop(playerid,"У вас недостаточно RUB");
                  SetPVarInt(playerid,"ChosenCapSrok",shop_caps_table[listitem][cap_srok]);
                  SetPVarInt(playerid,"TruePrice",shop_caps_table[listitem][cap_price]);
				  if(Player_Cap[playerid] != 0)return OpenReplaceCapDialog(playerid);
                  AcceptBuyCapD(playerid);
				  return 1;
		  }
		  case MENU_KICK_VOTE_CHOSE_ID:
		  {
				  if(!response)return OpenGMenu(playerid);
				  if(Player_HourInGame[playerid] < MINHOURS_FORVOTE)return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"Ошибка: Количество ваших часов в игре слишком мало","Выбрать игрока для рассмотрения его удаления","Выбор","Назад");
                  if(VotePlayerID != -1)return OpenVotePanel(playerid),SendClientMessage(playerid,COLOR_GRAY,"Ошибка: Голосование уже началось");
                  if(!isNumeric(inputtext))return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"Голосование за кик игрока","Выбрать игрока для рассмотрения его удаления","Выбор","Назад");
				  if(!IsPlayerConnected(strval(inputtext)))return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"Игрок не найден","Выбрать игрока для рассмотрения его удаления","Выбор","Назад");
                  if( playerid == strval(inputtext) )return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"Вы не можете голосовать за кик себя!","Выбрать игрока для рассмотрения его удаления","Выбор","Назад");
                  if( IsPlayerAdmin(strval(inputtext)) || Player_AdminLevel[strval(inputtext)] > 0 )return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"Вы не можете голосовать за кик админа!","Выбрать игрока для рассмотрения его удаления","Выбор","Назад");
				  if((Humans+Zombies) < 3)return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"В игре меньше 3 игроков.","Выбрать игрока для рассмотрения его удаления","Выбор","Назад");
				  OpenVote(playerid,strval(inputtext));
		  }
		  case MENU_KICK_VOTE_DIALOG_VOTE:
		  {
				  if(!response)return OpenGMenu(playerid);
				  if(VotePlayerID == -1)return OpenVotePanel(playerid),SendClientMessage(playerid,COLOR_GRAY,"Ошибка: Голосование скорее всего завершилось");
				  PlayerVoted(playerid);
				  OpenGMenu(playerid);
		  }
		  //Диалоги регистрации
		  case LOGIN_DIALOG:
		  {
				  if(!response)return Kick(playerid);
				  if(!strlen(inputtext) || !IsValidText(inputtext))return OpenLogin(playerid,"Пароль не введен");
				  if(strcmp(inputtext, Player_Password[playerid], true))return OpenLogin(playerid,"Пароль введен неверно");
				  OnPlayerLogin(playerid);  // передача на другой паблик

		  }
		  case REGISTER_DIALOG:
		  {
		          if(!response)return Kick(playerid);
		          if(strlen(inputtext) > MAX_PASS_LEGHT || strlen(inputtext) < MIN_PASS_LEGHT )return OpenRegister(playerid,"Неверная длинна пароля");
                  if(!GetNormalPassword(inputtext))return OpenRegister(playerid,"Пароль содержит запрещенные символы");
				  strmid(Player_Password[playerid],inputtext,0,MAX_PASS_LEGHT+1);
				  OpenAgeDialog(playerid);
		  }
		  case DIALOG_ENTERMAIL:
		  {
                   if(!response) return ShowPlayerDialog(playerid,DIALOG_ENTERMAIL,DIALOG_STYLE_INPUT,"Почтовый ящик","Введите ваш действующий e-mail","Ввод","");
				   if(strlen(inputtext) < 1 || strlen(inputtext) > MAX_EMAIL_SIZE || !IsValidEmail(inputtext))return ShowPlayerDialog(playerid,DIALOG_ENTERMAIL,DIALOG_STYLE_INPUT,"Почтовый ящик","Введите ваш действующий e-mail","Ввод","");
				   strmid(Player_Email[playerid],inputtext,0,MAX_EMAIL_SIZE+1);
				   ShowPlayerDialog(playerid,DIALOG_HUMANPROFS_LIST,DIALOG_STYLE_LIST,"Выберите профессию человека",HumanProf_D,"Подробнее","");
		  }
		  case AGE_DIALOG:
		  {
		          if(!response)return OpenAgeDialog(playerid);
				  if(!isNumeric(inputtext))return OpenAgeDialog(playerid,"Неправильное значение");
				  if(strval(inputtext) > 50 || strval(inputtext) < 10)return OpenAgeDialog(playerid,"Недопустимый возраст");
				  Player_Age[playerid] = strval(inputtext);
				  ShowPlayerDialog(playerid,DIALOG_ENTERMAIL,DIALOG_STYLE_INPUT,"Почтовый ящик","Введите ваш действующий e-mail","Ввод","");
				  //ShowPlayerDialog(playerid,DIALOG_HUMANPROFS_LIST,DIALOG_STYLE_LIST,"Выберите профессию человека",HumanProf_D,"Подробнее","");
		  }
		  case DIALOG_HUMANPROFS_LIST:
		  {
                  if(!response)return ShowPlayerDialog(playerid,DIALOG_HUMANPROFS_LIST,DIALOG_STYLE_LIST,"Выберите профессию человека",HumanProf_D,"Подробнее","");
				  Player_ChosenInt[playerid] = listitem;
				  About(playerid,HUMAN,listitem);
		  }
		  case ABOUT_HUMAN_DIALOG:
		  {
                  if(!response)return ShowPlayerDialog(playerid,DIALOG_HUMANPROFS_LIST,DIALOG_STYLE_LIST,"Выберите профессию человека",HumanProf_D,"Подробнее","");
                  Player_HumanProfession[playerid] = Player_ChosenInt[playerid];
                  ShowPlayerDialog(playerid,DIALOG_ZOMBIEPROFS_LIST,DIALOG_STYLE_LIST,"Выберите профессию зомби",ZombieProf_D,"Подробнее","");
		  }
		  case DIALOG_ZOMBIEPROFS_LIST:
		  {
		          if(!response)return ShowPlayerDialog(playerid,DIALOG_ZOMBIEPROFS_LIST,DIALOG_STYLE_LIST,"Выберите профессию зомби",ZombieProf_D,"Подробнее","");
		          Player_ChosenInt[playerid] = listitem;
				  About(playerid,ZOMBIE,listitem);
		  }
		  case ABOUT_ZOMBIE_DIALOG:
		  {
                  if(!response)return ShowPlayerDialog(playerid,DIALOG_ZOMBIEPROFS_LIST,DIALOG_STYLE_LIST,"Выберите профессию зомби",ZombieProf_D,"Подробнее","");
                  Player_ZombieProfession[playerid] = Player_ChosenInt[playerid];
                  OpenAcceptRegister(playerid);
		  }
		  case DIALOG_ENTER_FRIEND_NAME:  // ввод имени игрока, пригласившего playerid на сервер
		  {
				  if(!response)return OnPlayerRegisted(playerid); // завершить регистрацию playerid
				  if(!strlen(inputtext) || !GNT(inputtext))return ShowPlayerDialog(playerid,DIALOG_ENTER_FRIEND_NAME,DIALOG_STYLE_INPUT,"Никнейм друга","Введите никнейм друга, пригласившего вас на сервер","Ввод","Пропустить");
				  switch( OnPlayerInvitePlayer(playerid, inputtext) ) // выполняем действия на OnPlayerInvitePlayer и узнаем результат
				  {
						// Проверка на существование акаунта
						case CALLING_ACCOUNT_NOT_FOUND: return ShowPlayerDialog(playerid,DIALOG_ENTER_FRIEND_NAME,DIALOG_STYLE_INPUT,"Данного аккаунта не существует","Введите никнейм друга, пригласившего вас на сервер","Ввод","Пропустить");
						// Все норм, завершаем регу
						default: return OnPlayerRegisted(playerid); // завершить регистрацию playerid
				  }
		  }
		  case ACCEPT_REGISTER_DIALOG:  // Основная регистрация завершена, НО РЕГИСТРАЦИЯ НЕ ЗАКОНЧЕНА. Осталось ввести имя друга, ну или отказаться
		  {
				  if(!response)return OpenAgeDialog(playerid);
				  // Показать ввод имени друга, который пригласил на сервер
				  ShowPlayerDialog(playerid,DIALOG_ENTER_FRIEND_NAME,DIALOG_STYLE_INPUT,"Никнейм друга","Введите никнейм друга, пригласившего вас на сервер","Ввод","Пропустить");
		  }
		  //Диалоги регистрации: конец
		  //=============================================================================================
		  case MENU_DIALOG: // Диалог с меню (/menu)
		  {
				  if(!response)return 1;
				  switch(listitem)
				  {
						 case 0:OpenRules(playerid,0);// открыть правила
						 case 1:OpenHelp(playerid);// открыть помощь
						 case 2:OpenStat(playerid,MENU_STAT_D); // открыть stat
						 case 3:OpenAdminD(playerid);// показать admins
						 case 4:// открыть tituls
						 {
							  for(new i = 1; i < MAX_TITULS; i++)
							  {
								   format(buff,170,""COL_WHITE"%d. "COL_YELLOW"%s - "COL_LIME"Владелец: %s - "COL_EASY"Количество: %d\n",i,GetTitulName(i),Tit_Name[i],Tit_Value[i]);
								   strcat(bigbuffer,buff);
							  }
							  ShowPlayerDialog(playerid,MENU_TITULS_D,DIALOG_STYLE_MSGBOX,"Титулы сервера",bigbuffer,"Назад","");
						 }
						 case 5:OpenVotePanel(playerid);//golosovan
						 case 6:OpenShop(playerid);//magaz
						 case 7:OpenMyProfs(playerid);//professii
		          }
          }
          case MENU_TITULS_D: return OpenGMenu(playerid);
		  case MENU_ADMINS_D: // открыть действия с администрацией
		  {
				 if(!response)return OpenGMenu(playerid);
				 switch(listitem){
					 case 0:{
					       if(Player_IsVip[playerid] == 0)return OpenAdminD(playerid),SendClientMessage(playerid,COLOR_GRAY,"Только для премиум-пользователей");
                           // Вывести список админов онлайн
						   switch(GetAdminList(bigbuffer)){
						        // коды результата
								case 0: ShowPlayerDialog(playerid,MENU_ADMINS_D_LIST,DIALOG_STYLE_MSGBOX,"Администрация онлайн","Администрации онлайн нет","Назад",""); // админов нет
								default: ShowPlayerDialog(playerid,MENU_ADMINS_D_LIST,DIALOG_STYLE_MSGBOX,"Администрация онлайн",bigbuffer,"Назад","");
						   }
					 }
					 case 1:ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"Жалоба","Введите ид нарушителя в это окно","Ввод","Назад");
					 case 2:ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_TO_MAIL,DIALOG_STYLE_INPUT,"Жалоба на почту","Введите содержимое жалобы","Отправить","Назад");
					 case 3:ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_AB_BUG,DIALOG_STYLE_INPUT,"Отчет об ошибке","Опишите ошибку","Ввод","Назад");
					 case 4:ShowPlayerDialog(playerid,MENU_ADMINS_D_SUGGEST_ADMIN,DIALOG_STYLE_INPUT,"Вопрос администратору","Введите текст вопроса","Ввод","Назад");
				 }
		  }
		  case MENU_ADMINS_D_SUGGEST_ADMIN: // выбрано действие спросить админа
		  {
                 if(!response)return OpenAdminD(playerid);
                 if(Player_MuteTime[playerid] != 0)return OpenAdminD(playerid),SendClientMessage(playerid,-1,MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC);
                 if(!strlen(inputtext) || !IsValidText(inputtext))return ShowPlayerDialog(playerid,MENU_ADMINS_D_SUGGEST_ADMIN,DIALOG_STYLE_INPUT,"Вопрос администратору","Введите текст вопроса","Ввод","Назад");
                 InfoAdmins(playerid,inputtext);
                 OpenAdminD(playerid);
		  }
		  case MENU_ADMINS_D_REPORT_AB_BUG: // выбрано действие сообщить о баге. Шлется на почту
		  {
  				 if(!response)return OpenAdminD(playerid);
  				 if(Player_MuteTime[playerid] != 0)return OpenAdminD(playerid),SendClientMessage(playerid,-1,MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC);
  				 if(GetPVarInt(playerid,"CmdFloodMail") > gettime())return OpenAdminD(playerid),SendClientMessage(playerid,-1,"Попробуйте позже");
		         if(!strlen(inputtext) || !IsValidText(inputtext))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_AB_BUG,DIALOG_STYLE_INPUT,"Отчет об ошибке","Опишите ошибку","Ввод","Назад");
                 InfoAdmins(playerid,inputtext);
                 
                 format(buff, 100, "ABOUT BUG SaintsRow - %s", GetName(playerid));
				 mail_send(playerid, MAIL_GENERAL, buff, inputtext);
                 
				 //SendMail(MAIL_GENERAL, "SaintsRow@Server", GetName(playerid), "ABOUT BUG SaintsRow", inputtext);
                 SetPVarInt(playerid,"CmdFloodMail",gettime() + FloodTimeMail);
				 OpenAdminD(playerid);
		         
		  }
		  case MENU_ADMINS_D_REPORT_TO_MAIL: // пожаловаться на почту админу
		  {
 				 if(!response)return OpenAdminD(playerid);
 				 if(Player_MuteTime[playerid] != 0)return OpenAdminD(playerid),SendClientMessage(playerid,-1,MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC);
 				 if(GetPVarInt(playerid,"CmdFloodMail") > gettime())return OpenAdminD(playerid),SendClientMessage(playerid,-1,"Попробуйте позже");
 				 if(!strlen(inputtext) || !IsValidText(inputtext))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_TO_MAIL,DIALOG_STYLE_INPUT,"Жалоба на почту","Введите содержимое жалобы","Отправить","Назад");

				 format(buff, 100, "Report SaintsRow - %s", GetName(playerid));
				 mail_send(playerid, MAIL_GENERAL, buff, inputtext);
				  //SendMail(MAIL_GENERAL, "SaintsRow@Server", GetName(playerid), "Report SaintsRow", inputtext);
                 SetPVarInt(playerid,"CmdFloodMail",gettime() + FloodTimeMail);
 				 SendClientMessage(playerid,COLOR_YELLOW,"Жалоба на почту администрации успешно отправлена");
 				 OpenAdminD(playerid);
		  }
		  case MENU_ADMINS_D_REPORT_INPUT_ID: // пожаловаться админам на игрока с опред.ид
		  {
				 if(!response)return OpenAdminD(playerid);
				 if(!isNumeric(inputtext))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"Жалоба","Введите ид нарушителя в это окно","Ввод","Назад");
				 if(!IsPlayerConnected(strval(inputtext)))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"Жалоба","Игрок не найден!\nВведите ид нарушителя в это окно","Ввод","Назад");
				 if(strval(inputtext) == playerid)return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"Жалоба","Вы не можете пожаловаться на себя!\nВведите ид нарушителя в это окно","Ввод","Назад");
                 if(Player_MuteTime[playerid] != 0)return OpenAdminD(playerid),SendClientMessage(playerid,-1,MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC);
				 Player_ChosenInt[playerid] = strval(inputtext);
				 ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_REASON,DIALOG_STYLE_INPUT,"Жалоба","Введите причину в это окно","Ввод","Назад");
		  }
		  case MENU_ADMINS_D_REPORT_INPUT_REASON: // ввести причину жалобы на игрока с опред. ид
		  {
			     if(!response)return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"Жалоба","Введите ид нарушителя в это окно","Ввод","Назад");
			     if(!IsPlayerConnected(Player_ChosenInt[playerid]))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"Жалоба","Выбранный вами игрок успел покинуть игру\nВведите ид нарушителя в это окно","Ввод","Назад");
			     if(!strlen(inputtext) || !IsValidText(inputtext))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_REASON,DIALOG_STYLE_INPUT,"Жалоба","Введите причину в это окно","Ввод","Назад");
			     if(strlen(inputtext) > 64 )return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_REASON,DIALOG_STYLE_INPUT,"Жалоба","Слишком длинная причина\nПричина должна быть не длиннее 64 символов\nВведите причину в это окно","Ввод","Назад");
			     ReportAdmins(playerid,Player_ChosenInt[playerid],inputtext);
			     OpenAdminD(playerid);
			     
		  }
		  case MENU_ADMINS_D_LIST:return OpenAdminD(playerid);
          case MENU_STAT_D:return OpenGMenu(playerid);
          case MENU_RULES_D:
          {
				  if(!response)return OpenGMenu(playerid);
				  OpenRules(playerid,1);
          }
          case MENU_RULES_D2:
          {
				  if(!response)return OpenGMenu(playerid);
				  OpenRules(playerid,0);
          }
          case MENU_HELP_D:
          {
				 if(!response)return OpenGMenu(playerid);
				 switch(listitem)
				 {
					 case 0:{ // показать смысл игры
						 for(new i; i < sizeof(AboutYourGame); i ++)strcat(bigbuffer,AboutYourGame[i]);
                         ShowPlayerDialog(playerid,MENU_MSGBUFFER_D,DIALOG_STYLE_MSGBOX,"Смысл игры",bigbuffer,"К помощи","");
  	 	             }
  	 	             case 1:{ // показать основные команды
                         for(new i; i < sizeof(GeneralCommands); i ++)strcat(bigbuffer,GeneralCommands[i]);
                         ShowPlayerDialog(playerid,MENU_MSGBUFFER_D,DIALOG_STYLE_MSGBOX,"Основные команды",bigbuffer,"К помощи","");
					 }
 	             }
          }
          case MENU_MSGBUFFER_D:return OpenHelp(playerid);
	}//ShowPlayerDialog(playerid,MENU_DIALOG,DIALOG_STYLE_LIST,"Меню","Правила\nПомощь\nСтатистика\nАдминистрация\nТитулы сервера\nГолосование\nИгровой магазин","Выбрать","Выход");
	return 1;
}


stock OpenHelp(playerid)
{
	 ShowPlayerDialog(playerid,MENU_HELP_D,DIALOG_STYLE_LIST,"Помощь","Смысл игры\nОсновные команды","Выбрать","Назад");
	 return 1;
}
stock OpenProfBuy(playerid)
{
	 new str[128];
	 format(str,sizeof(str),"Зомби - %d RUB\nЛюди - %d RUB",ZOMBIE_PROFESSIONS_PRICE,HUMAN_PROFESSIONS_PRICE);
     ShowPlayerDialog(playerid,SHOP_BUY_PROFESSION_CHOSE_TEAM,DIALOG_STYLE_LIST,"Выберите основу профессии",str,"Выбрать","Выход");
     return 1;
}
stock MessageToAdmins(messaaagee[])
{
	new str[128];
	format(str,sizeof(str),"[A]%s",messaaagee);
	for(new i, s_b = MaxID; i <= s_b; i++)
	{
       	 if(!IsPlayerConnected(i))continue;
		 if(Player_AdminLevel[i] < 1 && !IsPlayerAdmin(i))continue;
		 SendClientMessage(i,COLOR_LIGHTBLUE,str);
	}
	WriteLog(ADMINLOG,messaaagee);
}

stock ReportAdmins(playerid,reportid,reason[])
{
	new str[128];
	format(str,sizeof(str),"Жалоба от %s на %s с причиной: %s",GetName(playerid),GetName(reportid),reason);
	for(new i, s_b = MaxID; i <= s_b; i++)
	{
       	 if(!IsPlayerConnected(i))continue;
		 if(Player_AdminLevel[i] < 1 && !IsPlayerAdmin(i))continue;
		 SendClientMessage(i,COLOR_DARKRED,str);
	}
	format(str,sizeof(str),"Жалоба на %s успешно отправлена администрации",GetName(reportid));
	SendClientMessage(playerid,COLOR_YELLOW,str);
	return 1;
}

stock InfoAdmins(playerid,infotext[])
{
	new str[128];
	format(str,sizeof(str),"Сообщение администрации от %s: %s",GetName(playerid),infotext);
	for(new i, s_b = MaxID; i <= s_b; i++)
	{
       	 if(!IsPlayerConnected(i))continue;
		 if(Player_AdminLevel[i] < 1 && !IsPlayerAdmin(i))continue;
		 SendClientMessage(i,COLOR_INFO,str);
	}
	SendClientMessage(playerid,COLOR_YELLOW,"Сообщение успешно отправлено администрации");
	return 1;
}

stock OpenAdminD(playerid)
{
     ShowPlayerDialog(playerid,MENU_ADMINS_D,DIALOG_STYLE_LIST,"Администрация","Администрация онлайн\nЖалоба\nЖалоба на почту\nОтчет об ошибке\nВопрос администратору","Выбрать","Назад");
     return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(Player_IsVip[playerid] && S[playerid] != 0)
	{
            OpenStat(clickedplayerid,3409,playerid);
	}
	return 1;
}

//Служебные
stock GetNormalPassword(inputtext[])
{
	 for(new i; i < strlen(inputtext);i++){
            switch(inputtext[i]){
                 case 48..57: continue;
                 case 65..90: continue;
                 case 97..122: continue;
                 case '%':return false;
                 default: return false;
            }
     }
     return true;
}


ClearDeathMessages(){
	new x = GetMaxPlayers();
    for (new i = 0; i < 5; i++)
        SendDeathMessage(x/*INVALID_PLAYER_ID*/, x/*INVALID_PLAYER_ID*/, 500/*WEAPONSTATE_UNKNOWN*/);
    return 1;
}

stock GetName(playerid){
	 new name[MAX_PLAYER_NAME];
	 GetPlayerName(playerid,name,MAX_PLAYER_NAME);
	 return name;
}
stock strtokForCmd(const string[], &index,seperator=' ')
{
	new length = strlen(string);
	new offset = index;
	new result[128];
	while ((index < length) && (string[index] != seperator) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	if ((index < length) && (string[index] == seperator))index++;
	return result;
}

stock strtokForBD(const string[], &index,seperator=' ')
{
	new length = strlen(string);
	new offset = index;
	new result[256];
	while ((index < length) && (string[index] != seperator) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	if ((index < length) && (string[index] == seperator))index++;
	return result;
}

stock isNumeric(const string[]) {
	new length=strlen(string);
	if (length==0) return false;
	for (new i = 0; i < length; i++) {
		if (
		(string[i] > '9' || string[i] < '0' && string[i]!='-' && string[i]!='+') // Not a number,'+' or '-'
		|| (string[i]=='-' && i!=0)                                             // A '-' but not at first.
		|| (string[i]=='+' && i!=0)                                             // A '+' but not at first.
		) return false;
	}
	if (length==1 && (string[0]=='-' || string[0]=='+')) return false;
	return true;
}

stock ConvertSeconds(time)
{
    new string[128];
    if(time < 60) format(string, sizeof(string), "%d секунд", time);
    else if(time == 60) string = "1 минуту";
    else if(time > 60 && time < 3600)
    {
        new Float: minutes;
        new seconds;
        minutes = time / 60;
        seconds = time % 60;
        format(string, sizeof(string), "%.0f минут и %d секунд", minutes, seconds);
    }
    else if(time == 3600) string = "1 час";
    else if(time > 3600)
    {
        new Float: hours;
        new minutes_int;
        new Float: minutes;
        new seconds;
        hours = time / 3600;
        minutes_int = time % 3600;
        minutes = minutes_int / 60;
        seconds = minutes_int % 60;
        format(string, sizeof(string), "%.0f:%.0f:%d", hours, minutes, seconds);
    }
    return string;
}
stock TimeConverter(seconds)//Конвертер секунды в минуты и секунды
{
        new string[6];//объявляем символьную переменную
        new minutes = floatround(seconds/60);//кол. целых минут
        seconds -= minutes*60;  //остаток
        format(string, sizeof(string), "%02d:%02d", minutes, seconds);//преобразовываем
        return string;//возвращаем строку символов
}



forward LoadArenas();
public LoadArenas()
{
	   new IF;
	   Loaded_Maps = 0;
	   for(new i,str[32+60],buffer[256],FloatBuff[256],val,idx; i < MAX_MAPS; i++)
	   {
			format(str,sizeof(str),"%s/%d.ini",MAPS_FOLDER,i);
			if(!fexist(str))break;
			idx = 0;
			val = 0;
	        IF = ini_openFile(str);

	        ini_getString(IF,"name",MapName[Loaded_Maps]);
			ini_getInteger(IF,"interior",MapInterior[Loaded_Maps]);
			ini_getInteger(IF,"marker",val);
			if(val == 1)MapHaveMarker[Loaded_Maps] = true;
			else MapHaveMarker[Loaded_Maps] = false;
            //MapGiveZombieGun[CurrentMap]
			ini_getString(IF,"object_fs",MapFS[Loaded_Maps]); // объекты в fs для карты
			ini_getString(IF,"spawn",buffer);

			FloatBuff = strtokForBD(buffer, idx,',');
			MapSpawnPos[Loaded_Maps][0] = floatstr(FloatBuff);
			FloatBuff = strtokForBD(buffer, idx,',');
			MapSpawnPos[Loaded_Maps][1] = floatstr(FloatBuff);
			FloatBuff = strtokForBD(buffer, idx,',');
			MapSpawnPos[Loaded_Maps][2] = floatstr(FloatBuff);
			FloatBuff = strtokForBD(buffer, idx,',');
			MapSpawnPos[Loaded_Maps][3] = floatstr(FloatBuff);
			if(val == 1)
			{
				   idx = 0;

				   ini_getString(IF,"markerpos",buffer);

                   FloatBuff = strtokForBD(buffer, idx,',');
			       MapMarkerPos[Loaded_Maps][0] = floatstr(FloatBuff);
			       FloatBuff = strtokForBD(buffer, idx,',');
			       MapMarkerPos[Loaded_Maps][1] = floatstr(FloatBuff);
			       FloatBuff = strtokForBD(buffer, idx,',');
			       MapMarkerPos[Loaded_Maps][2] = floatstr(FloatBuff);
			}
			val = 0;
            ini_getInteger(IF,"zombiegun",val);
			if(val == 1)MapGiveZombieGun[Loaded_Maps] = true;
			else MapGiveZombieGun[Loaded_Maps] = false;
			
	        ini_closeFile(IF);
	        printf("   Арена %d (%s) загружена",Loaded_Maps,MapName[Loaded_Maps]);
	        Loaded_Maps ++;
	   }
	   printf("   Было успешно загружено %d арен",Loaded_Maps);
       NextArenaId = 0;
}

new AutoMessages[7][] = {
/*0*/   {""COL_EASY"Меню вызывается по нажатию кнопки "COL_YELLOW"\"Y\""COL_EASY", там Вы можете найти все необходимые функции"},
/*1*/   {""COL_WHITE"Чтобы заразить человека за зомби надо подойти к нему и нажать кнопку "COL_GREEN"ALT"},
/*2*/   {""COL_LIME"Чтобы Применить особое умение у своего класса, достаточно нажать клавишу "COL_EASY"N"},
/*3*/   {""COL_CYAN"Детальную информацию можно узнать на форуме "COL_LIME"***www.kuller.su***"},
/*4*/   {""COL_RULE"Чтобы задать вопрос, можно использовать "COL_RULE2"/menu - Администрация - Задать вопрос администратору"},
/*5*/   {""COL_EASY"Связь с главным администратором только через форум "COL_YELLOW"www.kuller.su"},
/*6*/   {""COL_WHITE"Игровой магазин находится в меню по нажатию кнопки "COL_LIME"\"Y\""}
/*7*/   //{""COL_RULE"Информацию о ранге можно посмотреть в "COL_GREEN"\"/buyrank\""}
};

forward SendAutoMessage();
public SendAutoMessage()
{
     SendClientMessageToAll(COLOR_LIGHTBLUE,"***============================================================================================***");
     SendClientMessageToAll(-1,AutoMessages[messageid]);
	 SendClientMessageToAll(COLOR_LIGHTBLUE,"***============================================================================================***");
	 messageid ++;
	 if(messageid == sizeof(AutoMessages))messageid = 0;
	 time_to_send_automessage = AUTOMESSAGE_TIME;
	 return 1;
}

new Text3D: InfectText[MAX_PLAYERS];


stock __InfectText__CreateLabel(playerid)
{
     InfectText[playerid] = Create3DTextLabel("",-1,0.0,0.0,0.0,INFECT_TEXT_RAD,0,0);
     Attach3DTextLabelToPlayer(InfectText[playerid],playerid,0.0,0.0,INFECT_TEXT_HIGHT);
	 return 1;
}

stock __InfectText__DeleteLabel(playerid)
{
     Delete3DTextLabel(InfectText[playerid]);
	 return 1;
}

stock __InfectText__RemoveLabelText(playerid)
{
     Update3DTextLabelText(InfectText[playerid],-1,"");
	 return 1;
}

stock __InfectText__CreateLabelText(playerid,doptext[])
{
	 new bbbstr[40];
	 format(bbbstr,sizeof(bbbstr),INFECT_TEXT_STR,doptext);
     Update3DTextLabelText(InfectText[playerid],COLOR_RED,bbbstr);
	 return 1;
}

//узнать название уровня заражения
stock Get_IL_Name(IL)
{
	new str[15];
    switch(IL)
    {
		  	      case RED_MONITOR:str = "Слабый";
		  	      case ONE_HP:str = "Средний";
		  	      case TWO_HP:str = "Высокий";
		  	      case THREE_HP:str = "Очень высокий";
    }
    return str;
}

//Магазин: покупка профессии
stock OpenMyProfs(playerid)
{
	ShowPlayerDialog(playerid,MENU_MYPROFS_CHOSE_TEAM,DIALOG_STYLE_LIST,"Выберите команду","Зомби\nЛюди","Выбор","Назад");
	return 1;
}

stock Open_ChoseProfessionClass(playerid,teamid)
{
	switch(teamid)
	{
		   case HUMAN: ShowPlayerDialog(playerid,SHOP_BUY_PROFESSION_CHOSE_PROF,DIALOG_STYLE_LIST,"Выберите профессию","Штурмовик\nМедик\nСнайпер\nЗащитник\nСтроитель","Купить","Назад");
		   case ZOMBIE:  ShowPlayerDialog(playerid,SHOP_BUY_PROFESSION_CHOSE_PROF,DIALOG_STYLE_LIST,"Выберите профессию","Танк\nЖокей\nВедьма\nБумер","Купить","Назад");
	}
	return 1;
}

stock OpenProfessionBuy(playerid,dialogid=SHOP_BUY_PROFESSION_BUYED_D)
{
	new str[150],price;
	if(GetPVarInt(playerid,"ChosenTeam") == ZOMBIE)price = ZOMBIE_PROFESSIONS_PRICE;
	else if(GetPVarInt(playerid,"ChosenTeam") == HUMAN)price = HUMAN_PROFESSIONS_PRICE;
	format(str,sizeof(str),"Информация о покупке:\nПрофессия: %s\nЦена: %d рублей\nДата приобретения: %s\nСпасибо за покупку!",
    GetProfName(GetPVarInt(playerid,"ChosenTeam"),GetPVarInt(playerid,"ChosenTeamClass")),
	price,
    date("%dd.%mm.%yyyy в %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT))
	);
	ShowPlayerDialog(playerid,dialogid,DIALOG_STYLE_MSGBOX,"Информация о покупке",str,"Выход","");


	format(str,sizeof(str),"%s купил Профессию \"%s\" за %d рублей",
    GetName(playerid),
    GetProfName(GetPVarInt(playerid,"ChosenTeam"),GetPVarInt(playerid,"ChosenTeamClass")),
    price);
 	WriteLog(BUYLOG,str);
	return 1;
}

stock OpenProfessionChoseProfession(playerid,teamid,title[]="Мои профессии")
{
	new str[130];
	SetPVarInt(playerid,"ChosenTeam",teamid);
    switch(teamid)
    {
		 case ZOMBIE:
		 {
			   for(new i; i < MAX_Z_CLASS; i++)
			   {
					  if(!Player_Z_HaveProfession[playerid][i])strcat(str,""COL_GREY"");
					  else strcat(str,"{00ff00}");
					  strcat(str,GetProfName(teamid,i));
					  strcat(str,"\n");
			   }
		 }
	     case HUMAN:
	     {
	           for(new i; i < MAX_H_CLASS; i++)
			   {
                      if(!Player_H_HaveProfession[playerid][i])strcat(str,""COL_GREY"");
					  else strcat(str,"{00ff00}");
					  strcat(str,GetProfName(teamid,i));
					  strcat(str,"\n");
			   }
	     }
    }
    ShowPlayerDialog(playerid,MENU_MYPROFS_CHOSE_CLASS,DIALOG_STYLE_LIST,title,str,"Переключить","Назад");
	return 1;
}

//Магазин: покупка дополнительного хп для своей профессии
stock OpenBuyHealth(playerid,teamid)
{
	 new str[200];
	 switch(teamid)
	 {
		 case ZOMBIE:{
	     format(str,sizeof(str),"Покупка жизней для профессии зомби\nЦена одной жизни - %d ZM или %d рублей\nТекущая профессия: %s\nВы можете приобрести еще %d единиц здоровья\nВведите покупаемое количество в это окно",
	     SHOP_HEALTH_PRICE_ZM,
	     SHOP_HEALTH_PRICE_RUB,
	     GetProfName(ZOMBIE,Player_ZombieProfession[playerid]),
	     PLAYER_MAX_BUYED_HEALTH_FOR_ZOMBIE-Player_Z_DopHealth[playerid][Player_ZombieProfession[playerid]]);}
		 case HUMAN:{
		 format(str,sizeof(str),"Покупка жизней для профессии человека\nЦена одной жизни - %d ZM или %d рублей\nТекущая профессия: %s\nВы можете приобрести еще %d единиц здоровья\nВведите покупаемое количество в это окно",
	     SHOP_HEALTH_PRICE_ZM,
	     SHOP_HEALTH_PRICE_RUB,
	     GetProfName(HUMAN,Player_HumanProfession[playerid]),
	     PLAYER_MAX_BUYED_HEALTH_FOR_HUMAN-Player_H_DopHealth[playerid][Player_HumanProfession[playerid]]);}
	 }
	 ShowPlayerDialog(playerid,SHOP_BUY_HEALTH_ENTER_KOLVO,DIALOG_STYLE_INPUT,"Введите количество",str,"Ввод","Назад");
	 return 1;
}
stock OpenAcceptBuyHealth(playerid,title[]="Подтверждение покупки")
{
	 new str[200],price,itog_kolvo,team,prof[20];
	 team = GetPVarInt(playerid,"ChosenTeam");
	 itog_kolvo = GetPVarInt(playerid,"ChosenKolvo");
	 switch(GetPVarInt(playerid,"ChosenValute"))
	 {
		   case RUB:{ price =  itog_kolvo*SHOP_HEALTH_PRICE_RUB;str = "Рублей";}
		   case ZM:{ price = itog_kolvo*SHOP_HEALTH_PRICE_ZM;str = "Zombie Money";}
	 }
	 switch(team)
	 {
		   case HUMAN: prof =  "Людской Профессии";
		   case ZOMBIE: prof = "Зомби-профессии";
	 }
	 format(str,sizeof(str),"Подтверждение покупки\nДополнительное хп\nКомпонент для %s\nКоличество: %d ед.\nЦена: %d %s\nВы подтверждаете покупку?",
	 prof,
	 itog_kolvo,
	 price,
	 str);
	 ShowPlayerDialog(playerid,SHOP_BUY_HEALTH_ACCEPT,DIALOG_STYLE_MSGBOX,title,str,"Подтвердить","Отмена");
	 return 1;
}
stock OpenBuyHealthInfo(playerid)
{
	 new str[200],price,itog_kolvo,team,prof[20];
	 team = GetPVarInt(playerid,"ChosenTeam");
	 itog_kolvo = GetPVarInt(playerid,"ChosenKolvo");
	 switch(GetPVarInt(playerid,"ChosenValute"))
	 {
		   case RUB:{ price =  itog_kolvo*SHOP_HEALTH_PRICE_RUB;str = "Рублей";}
		   case ZM:{ price = itog_kolvo*SHOP_HEALTH_PRICE_ZM;str = "Zombie Money";}
	 }
	 switch(team)
	 {
		   case HUMAN: prof =  "Людской Профессии";
		   case ZOMBIE: prof = "Зомби-профессии";
	 }
	 format(str,sizeof(str),"Информация о покупке:\nДополнительное хп\nКомпонент для %s\nКоличество: %d ед.\nЦена: %d %s\nДата покупки: %s\nСпасибо за покупку!",
	 prof,
	 itog_kolvo,
	 price,
	 str,
	 date("%dd.%mm.%yyyy в %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT)));
	 ShowPlayerDialog(playerid,SHOP_BUY_HEALTH_INFO,DIALOG_STYLE_MSGBOX,"Хп куплено",str,"Выход","");
	 return 1;
}

//проверка на нормальный текст: антикраш диалогов
stock GNT(text[])
{
     for(new i; i < strlen(text);i++)//метод поиска by Lik
     {
             switch(text[i])
             {
					case '%':return false;
					case 92:return false; // "\"
             }
     }
	 return true;
}
//////////////////////////////////////////////////////////////////////////////////
/*
  Антидидос:
  - Многоразовый заход на сервер
  - Песочница
  - Флуд смертями
  - Нелегитимный спавн
  - Загон нпц
  Античит:
  - Джетпак
  - Флайхак
  - Броньхак
  - Диалогхак
  - Скинхак
  - Оружиехак
  - Телепорт
*/

public OnVehicleStreamIn(vehicleid, forplayerid)
{
    MessageToAdmins("Внимание! Обнаружен читерский транспорт. Он будет удален");
	DestroyVehicle(vehicleid);
	return 1;
}

//Функции античита************************
stock StripNewLine (string []){
	new len = strlen (string);
	if (string [0] == 0)return;
	if ((string [len - 1] == '\n') || (string [len - 1] == '\r')){
		string [len - 1] = 0;
		if (string [0] == 0)return;
		if ((string [len - 2] == '\n') || (string [len - 2] == '\r'))string [len - 2] = 0;
	}
}
stock LoadForbiddenWeapons (){
	if (fexist (FORBIDDEN_WEAPONS_FILE)){
		new File: f = fopen (FORBIDDEN_WEAPONS_FILE, io_read),string [32];
		ForbiddenWeaponsCount = 0;
		while (fread (f, string, sizeof (string)) && ForbiddenWeaponsCount < MAX_FORBIDDEN_WEAPONS){
			StripNewLine (string);
			if (string [0])ForbiddenWeapons {ForbiddenWeaponsCount++} = strval (string);
		}
		fclose (f);
		printf ("   %d запрещенных ганов загружено.", ForbiddenWeaponsCount);
		return 1;
	}
	else print ("   Не найден файл с плохими пушками!");
	return 0;
}
stock IsForbiddenWeapon (weaponid){
	if (weaponid){
		for (new i = 0; i < ForbiddenWeaponsCount; ++i)if (ForbiddenWeapons {i} == weaponid)return true;
	}
	return false;
}

public OnPlayerUseDialogHack( playerid, dialogid)
{
	// диалог хакнут
	//SendClientMessage(playerid, -1, "Диалог-хак заюзан");
	BanEx(playerid,"Диалог-хакинг");
	return 1;
}

forward OnPlayerUseCjRun(playerid, action);
public OnPlayerUseCjRun(playerid, action)
{
    new str[100];
	switch(action)
	{
		 case AC_ACTION_BAN:
		 {
			format(str, sizeof(str), "[Античит]: Игрок %s был забанен за использование читов", GetName(playerid));
			SendClientMessageToAll(COLOR_RED,str);
			BanEx(playerid, "Причина: CJRUN");
			MessageToAdmins("Причина: CJRUN");
	     }
	}
	return 1;
}

// Чит на патроны
public OnPlayerUseWeaponAmmoHack( playerid, weaponid, ammo, realcheat)
{
    new str[100];
	switch(realcheat)
	{
		 case 1:
		 {
			format(str, sizeof(str), "[Античит]: Игрок %s был забанен за использование читов", GetName(playerid));
			SendClientMessageToAll(COLOR_RED,str);
			BanEx(playerid, "Причина: оружиехак");
			MessageToAdmins("Причина: оружиехак");
	     }
		 default:
		 {
			format(str, sizeof(str), "Игрок %s подозревается в использовании чита на патроны (id = %d - ammo = %d)", GetName(playerid),weaponid, ammo);
			MessageToAdmins(str);
		 }
	}
	return 1;
}


// Чит на подмену ИД пушек в слотах
public OnPlayerUseWeaponHack( playerid, weaponid, ammo, realcheat)
{
	// Пушка начитерена
	new str[100];
	switch(realcheat)
	{
		 case AC_ACTION_BAN:
		 {
			format(str, sizeof(str), "[Античит]: Игрок %s был забанен за использование читов", GetName(playerid));
			SendClientMessageToAll(COLOR_RED,str);
			BanEx(playerid, "Причина: оружиехак");
			MessageToAdmins("Причина: оружиехак");
	     }
	     case AC_ACTION_KICK:
	     {
	        format(str, sizeof(str), "[Античит]: Игрок %s был кикнут по подозрению в читерстве: Оружие", GetName(playerid));
			MessageToAdmins(str);
			SendClientMessageToAll( COLOR_RED, str);
			t_Kick(playerid);
	     }
		 default:
		 {
			format(str, sizeof(str), "Игрок %s подозревается в использовании чита на подмену ид оружия (id = %d - ammo = %d)", GetName(playerid),weaponid, ammo);
			MessageToAdmins(str);
		 }
	}
	return 1;
}

public OnPlayerUseArmourHack( playerid, Float: currentarmour )
{
	// бронь начитерена
	new str[100];
	format(str, sizeof(str), "[Античит]: Игрок %s был забанен за использование читов", GetName(playerid));
	SendClientMessageToAll(COLOR_RED,str);
	MessageToAdmins("Причина: броньхак");
	BanEx(playerid, "Причина: броньхак");
	return 1;
}

forward OnPlayerUseFasRun( playerid,arg, dop[] );

public OnPlayerUseFasRun( playerid,arg, dop[] )
{
	// фастран заюзан
	new str[100];
	switch(arg)
	{
	    case AC_ACTION_BAN: // бан
	    {
	    	format(str, sizeof(str), "[Античит]: Игрок %s был забанен за использование читов", GetName(playerid));
			SendClientMessageToAll(COLOR_RED,str);
			format(str, sizeof(str), "Причина: FASTRUN (%s)", dop);
			MessageToAdmins(str);
			BanEx(playerid, str);
	    }
		case AC_ACTION_REPORT:
		{
		    format(str, sizeof(str), "[Античит]: Игрок %s подозревается в использовании FASTRUN (%s)", GetName(playerid), dop);
			MessageToAdmins(str);
		}
		case AC_ACTION_KICK: // кик по подозрению
		{
		    format(str, sizeof(str), "[Античит]: Игрок %s был кикнут по подозрению в читерстве: FASTRUN", GetName(playerid));
			SendClientMessageToAll( COLOR_RED, str);
			format(str, sizeof(str), "[Античит]: Игрок %s был кикнут по подозрению в читерстве: FASTRUN (%s)", GetName(playerid), dop);
			MessageToAdmins(str);
			t_Kick(playerid);
		}
	}
	return 1;
}

public OnPlayerUseFlyHack( playerid,arg, dop[] )
{
	// флайхак заюзан
	new str[100];
	switch(arg)
	{
	    case AC_ACTION_BAN: // бан
	    {
	    	format(str, sizeof(str), "[Античит]: Игрок %s был забанен за использование читов", GetName(playerid));
			SendClientMessageToAll(COLOR_RED,str);
			format(str, sizeof(str), "Причина: флайхак (%s)", dop);
			MessageToAdmins(str);
			BanEx(playerid, str);
	    }
		case AC_ACTION_REPORT:
		{
		    format(str, sizeof(str), "[Античит]: Игрок %s подозревается в использовании FlyHack (%s)", GetName(playerid), dop);
			MessageToAdmins(str);
		}
		case AC_ACTION_KICK: // кик по подозрению
		{
		    format(str, sizeof(str), "[Античит]: Игрок %s был кикнут по подозрению в читерстве: FlyHack", GetName(playerid));
			SendClientMessageToAll( COLOR_RED, str);
			format(str, sizeof(str), "[Античит]: Игрок %s был кикнут по подозрению в читерстве: FlyHack (%s)", GetName(playerid), dop);
			MessageToAdmins(str);
			t_Kick(playerid);
		}
	}
	
	return 1;
}

forward OnPlayerUseTpHack(playerid, action);

public OnPlayerUseTpHack(playerid, action)
{
    // тпхак заюзан
	new str[100];
	switch(action)
	{
	    case AC_ACTION_BAN: // бан
	    {
	    	format(str, sizeof(str), "[Античит]: Игрок %s был забанен за использование читов", GetName(playerid));
			SendClientMessageToAll(COLOR_RED,str);
			MessageToAdmins("Причина: Телепортер");
			BanEx(playerid, "Причина: Телепортер");
	    }
		case AC_ACTION_REPORT:
		{
		    format(str, sizeof(str), "[Античит]: Игрок %s подозревается в использовании Телепорт", GetName(playerid));
			MessageToAdmins(str);
		}
		case AC_ACTION_KICK: // кик по подозрению
		{
		    format(str, sizeof(str), "[Античит]: Игрок %s был кикнут по подозрению в читерстве: Телепорт", GetName(playerid));
			MessageToAdmins(str);
			SendClientMessageToAll( COLOR_RED, str);
			t_Kick(playerid);
		}
	}
	return 1;
}

forward OnPlayerUseInteriorHack(playerid, action);
public OnPlayerUseInteriorHack(playerid, action)
{
    // интхак заюзан
	new str[100];
	switch(action)
	{
	    case AC_ACTION_BAN: // бан
	    {
	    	format(str, sizeof(str), "[Античит]: Игрок %s был забанен за использование читов", GetName(playerid));
			SendClientMessageToAll(COLOR_RED,str);
			MessageToAdmins("Причина: Интерьер-Хак");
			BanEx(playerid, "Причина: Интерьер-Хак");
	    }
		case AC_ACTION_REPORT:
		{
		    format(str, sizeof(str), "[Античит]: Игрок %s подозревается в использовании Интерьер-Хак", GetName(playerid));
			MessageToAdmins(str);
		}
		case AC_ACTION_KICK: // кик по подозрению
		{
		    format(str, sizeof(str), "[Античит]: Игрок %s был кикнут по подозрению в читерстве: Интерьер-Хак", GetName(playerid));
			MessageToAdmins(str);
			SendClientMessageToAll( COLOR_RED, str);
			t_Kick(playerid);
		}
	}
	return 1;
}

public OnPlayerUseJetPackHack(playerid)
{
	// джетпак начитерен

	new str[100];
	format(str, sizeof(str), "[Античит]: Игрок %s был забанен за использование читов", GetName(playerid));
	SendClientMessageToAll(COLOR_RED,str);
	MessageToAdmins("Причина: джетпак");
	BanEx(playerid, "Причина: джетпак");
	return 1;
}

public OnPlayerUseFakeSkin(playerid, realdskin, fakeskin)
{
	// Скин начитерен
	new str[100];
	format(str, sizeof(str), "[Античит]: Игрок %s был забанен за использование читов", GetName(playerid));
	SendClientMessageToAll(COLOR_RED,str);
	MessageToAdmins("Причина: Смена скина читом");
	BanEx(playerid, "Причина: Смена скина читом");
	return 1;
}

stock CreateProfAndRank3DInformer(playerid)
{
		Player_ProfAndRankInf[playerid] = Create3DTextLabel(" ",-1,0.0,0.0,0.0,PrAnRaInf_TEXT_RAD,0,0);
		Attach3DTextLabelToPlayer(Player_ProfAndRankInf[playerid],playerid,0.0,0.0,INFECT_TEXT_HIGHT);
		return 1;
}

stock DeleteProfAndRank3DInformer(playerid)
{
		Delete3DTextLabel(Player_ProfAndRankInf[playerid]);
		return 1;
}

stock UpdateProfAndRank3DInformer(playerid)
{
		new bbbstr[40];
		switch(Player_CurrentTeam[playerid])
		{
			case HUMAN:
			{
			    if( Player_Invisible[playerid] > 0 )
			    {
			        Update3DTextLabelText(Player_ProfAndRankInf[playerid],COLOR_RED," "); // disable
			        return 1;
			    }
				format(bbbstr,sizeof(bbbstr),PrAnRaInf_TEXT_STR,GetProfName(HUMAN,Player_HumanProfession[playerid]),Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]+1);
				Update3DTextLabelText(Player_ProfAndRankInf[playerid],COLOR_GREEN,bbbstr);
				return 1;
			}
			case ZOMBIE:
			{
			    format(bbbstr,sizeof(bbbstr),PrAnRaInf_TEXT_STR,GetProfName(ZOMBIE,Player_ZombieProfession[playerid]),Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]+1);
				Update3DTextLabelText(Player_ProfAndRankInf[playerid],COLOR_RED,bbbstr);
				return 1;
			}
			case ADMIN:
			{
			    Update3DTextLabelText(Player_ProfAndRankInf[playerid],COLOR_RED," "); // disable
			    return 1;
			}
		}
		return 1;
}

// ФУНКЦИИ НОВОГО ОПЫТА

forward OnPlayerLogin(playerid);
forward OnPlayerRegisted(playerid);
forward OnPlayerInvitePlayer(playerid, invitename[]);


// вызывается при обновлении списка админов. Записывает список в buffer_for_list
// Возвращает:
// 1 если админы есть, 0 - если нет
stock GetAdminList(buffer_for_list[], size = sizeof(buffer_for_list))
{
    // Вывести список админов онлайн
    buffer_for_list[0] = 0x0;
    new minstr[64],admin;
	for(new i, s_b = MaxID; i <= s_b; i++)
	{
				if(!IsPlayerConnected(i))continue;
				if(Player_AdminLevel[i] < 1 && !IsPlayerAdmin(i))continue;
				if(!IsPlayerAdmin(i))format(minstr,sizeof(minstr),"%s[%d] - %d уровень\n",GetName(i),i,Player_AdminLevel[i]);
				else format(minstr,sizeof(minstr),"%s[%d] - RCON уровень\n",GetName(i),i);
				strcat(buffer_for_list,minstr,size);
				admin ++;
	}
	if(admin != 0) return 1;
	else return 0;
}

stock InformAbout_Y_or_N(playerid)
{
	SendClientMessage(playerid, -1, "Подсказка: "COL_EASY"Для использования спец. способности класса используйте клавиши N, Alt(зомби, медик), Num4(медик), Num6(медик)");
	SendClientMessage(playerid, -1, "Подсказка: "COL_YELLOW"Для открытия меню используйте клавишу Y");
	return 1;
}

// Вызывается при завершении логина игрока. При регистрации не вызывается
// Ничего не возвращает
public OnPlayerLogin(playerid)
{
	HideEffectsAndStartGame(playerid);
	LoadAccount(playerid);
    OpenStat(playerid);         // показ статистики
	FixPlayerBuyed(playerid);   // проверка покупок на истечение времени
	SendClientMessage(playerid,COLOR_YELLOWGREEN,"Авторизация завершена");
	InformAbout_Y_or_N(playerid);

	return 1;
}

// Вызывается при завершении регистрации
// Ничего не возвращает
public OnPlayerRegisted(playerid)
{

    new buff[MAX_PLAYER_NAME+50];
	// Оповестить лог о регистрации
    format(buff,sizeof(buff),"%s зарегистрировался на сервере",GetName(playerid));
	WriteLog(CRDLOG,buff);

    // Дать профессии
	Player_H_HaveProfession[playerid][Player_HumanProfession[playerid]] = true;  // Сделаем выбранную профессию оффициальной
	Player_Z_HaveProfession[playerid][Player_ZombieProfession[playerid]] = true; // Сделаем выбранную профессию оффициальной
	//Player_Level[playerid] = 1; // Дадим игроку первый уровень

	HideEffectsAndStartGame(playerid);
 	SaveAccount(playerid);
 	OpenStat(playerid);
 	SendClientMessage(playerid,-1,""COL_EASY"Регистрация аккаунта успешно завершена");
 	InformAbout_Y_or_N(playerid);
	return 1;
}

// Вызывается когда игрок указывает ник пригласившего его игрока. playerid = тот, кого пригласиил. invitename = имя того, кто пригласил
// Возвращает результат
public OnPlayerInvitePlayer(playerid, invitename[])
{
    new str[100];
	format(str,sizeof(str),"%s/%s.ini",ACCOUNTS_FOLDER,invitename);
	if(!fexist(str))return CALLING_ACCOUNT_NOT_FOUND;// завершено
	for(new i, s_b = MaxID; i <= s_b; i++)
 	{
			if(!IsPlayerConnected(i))continue;
			if(strcmp(invitename, GetName(i), true) == 0)  // перебор игроков онлайн
			{
				      // Выполняется если указанный игрок присутствует на сервере
					  format(str,sizeof(str),"Ваш друг %s пришел на сервер",GetName(playerid));
			          SendClientMessage(i,COLOR_YELLOWGREEN,str);
					  Player_Invites[i]++;
					  SaveAccount(i);
			          FixTitul(i,TIT_FRIENDLY);
					  //HideEffectsAndStartGame(playerid);
					  //OpenStat(playerid);
					  OnPlayerRegisted(playerid); // завершить регистрацию playerid
					  return CALLING_ACCOUNT_ONLINE; // завершено
			}
    }
   
   	// Выполняется если указанного игрока нет в данный момент на сервере
   	new IF,val;
   	IF = ini_openFile(str);
   	ini_getInteger(IF,"invites",val);
   	val++;
    ini_setInteger(IF,"invites",val);
    ini_closeFile(IF);
    if(val > Tit_Value[TIT_FRIENDLY])
    {
			Tit_Value[TIT_FRIENDLY] = val;
			strmid(Tit_Name[TIT_FRIENDLY],invitename,0,MAX_PLAYER_NAME+1);
			ReWriteTitul(TIT_FRIENDLY);
    }
    return CALLING_ACCOUNT_OFFLINE;// завершено
}

//Проверка на нахождение игрока в квадрате (опред 2d зоне)
stock PlayerToKvadrat(playerid,Float:max_x,Float:min_x,Float:max_y,Float:min_y)
{
	new Float:xxp,Float:yyp,Float:zzp;
	GetPlayerPos(playerid, xxp, yyp, zzp);
	if((xxp <= max_x && xxp >= min_x) && (yyp <= max_y && yyp >= min_y)) return true;
	return false;
}

stock t_Kick(playerid)
{
    if(isKicked[playerid])return 1; // если игрока уже кикают
	SetTimerEx("Kick_bbb", 400, 0, "i", playerid);
	isKicked[playerid] = true;
	return 1;
}

forward Kick_bbb(playerid);
public Kick_bbb(playerid)
{
	Kick(playerid);
	return 1;
}

// Узнать сколько дается при убийстве какого-либо ранга
stock GetZmForKill(team, classs, rank)
{
	switch(team)
	{
		case ZOMBIE:
		{
			switch(classs)
			{
			    case ZOMBIE_PROF_TANK:  return zombie_class_gromila[rank][zm_rang_zmforkill];
			    case ZOMBIE_PROF_JOKEY: return zombie_class_jokey[rank][zm_rang_zmforkill];
			    case ZOMBIE_PROF_VEDMA: return zombie_class_vedma[rank][zm_rang_zmforkill];
			    case ZOMBIE_PROF_BUMER: return zombie_class_bumer[rank][zm_rang_zmforkill];
			}
		}
		case HUMAN:
		{
			switch(classs)
			{
			    case HUMAN_PROF_SHTURMOVIK:  return human_class_shturmovik[rank][rang_zmforkill];
			    case HUMAN_PROF_MEDIK: return human_class_medik[rank][rang_zmforkill];
			    case HUMAN_PROF_SNIPER: return human_class_sniper[rank][rang_zmforkill];
			    case HUMAN_PROF_DEFENDER: return human_class_defender[rank][rang_zmforkill];
			    case HUMAN_PROF_CREATER: return human_class_creater[rank][rang_zmforkill];
			}
		}
	}
	return -1;
}

stock GetPlayerSpeed(playerid)
{
        new Float:X, Float:Y, Float:Z;
        GetPlayerVelocity(playerid, X, Y, Z);
        return floatround( floatsqroot( X * X + Y * Y + Z * Z ) * 170.0 );
}
