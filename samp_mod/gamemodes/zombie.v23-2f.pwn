/*
	 =========================================================
     || Servername: KulleR.su | Zombie Server               ||
     || Gamemodename: KulleR.su | Zombie v. 023-2f          ||
     || Created by: 2rage                                   ||
     =========================================================
     
     |---------------------------------------------------------|
     | 2rage. ������ ���������� ������ ������: 27 ��� 2010 ����|
     | ����� ����������, ����� ������ ������: 22 ���� 2012 ����|
	 |---------------------------------------------------------|
	 
	 *^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*
	 * 2rage. ������ ���������� ������ 0.2: 25 ���� 2012 ����*
	 * ����� ����������, ����� 0.2 ������: 22 ��� 2013 ����  *
	 *^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*

	 
	 /////////////////////////////////////////////////////////

	 ������ 0.21

	 - ����������� ������� - ���������
	 - ���� �����  - ���������
	 - ����� ���������
	 - ��������� ������
	 - ����� ������ ���������
	 
	 /////////////////////////////////////////////////////////

	 02.06.2013

	 ���� ������ ������ ��� ��������� ���� ��������
	 ���� ������� �����
	 �������� ����� � ���������� �����
	 
	 /////////////////////////////////////////////////////////

	 ������ 0.23
	 
	 04.06.2013
	 ��������� �����
	 ���� �������� ������
	 ������ ������ ��� ����
	 �����������: ������ isPlayerConnected, GetName �� ������� �� �������
	 ������ ����� �� ����� ����� � �����
	 �������� ��������� ��������� �������
	 ���� ������� ��� �������
	 ���� ��������� ������ ������� ��� �������� � ����������� (/ban id ������� � ��)

	 05. 06. 13
	 ������ ����
	 ���� ������������ �������� �������
	 ���� ������ �� ���� ��� ������ �� ��������, ����� � ������� ����� ����

	 06. 06. 13
	 �������� ��������
	 �������� ��������-���� ��� ����� �� ������
	 �������� ������� �� ������������� ������
	 �������� ������ ���� � /nextarena
	 

	 ///////////////////////////////////////////////////////////

	 ������ 0.23-02
	 
	 === 021 ==

	 07.06.13
	 ������ ���������
	 ������� �������� ��� ��� ���������� ������ ������������ �� ����� � ����� � ������� �� �����
	 ������� ����������� � ����� �������

	 08.06.13
	 �������� �� 2rage � giverub, givezm
	 ����� ����� � ������� � �����
	 ���� ��������
	 
	 === 022 ==

	 09.06.13
	 ��������� �����
	 ����-rcon-���
	 /ignorepm
	 �� ��� pm
	 ���� �����
	 ���� ���� ����� ������ (������ �� ���������)
*/

#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS 100 // �������� ������� �� �������, ����� �������� �� �����
#include <kuller_su/colors2> // ����� � hex
#include <kuller_su/mxINI> // �������� �������
#include <kuller_su/mxdate> // ������� �������������� ������ ������ � ����
#include <kuller_su/regex> // ������ ���������� ���������
#include <kuller_su/kuller_su_logs> // ����
#include <kuller_su/kuller_su_textdraws>// ����������
#include <kuller_su/mailer_bladock> // ��������

// ~~~~~~~~~~~~~ Regex ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#define IsValidText(%1) \
    regex_match(%1, "[ �-��-�a-zA-Z0-9_�=,!\\.\\?\\-\\+\\(\\)]+") //�������� �� ���������� ����� (������ �� ����� ��������)

#define IsValidEmail(%1) \
    regex_match(%1, "[a-zA-Z0-9_\\.\\-]+@([a-zA-Z0-9\\-]+\\.)+[a-zA-Z]{2,4}") // ������� �� ���������� �����
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// �������� �� KulleR � 2rage
#define KULLERNAME "KulleR"
#define NAME2RAGE "2rage"

// �������� �������
#define HOSTNAME "� ������� ����� ������ | www.KULLER.su �"

//��� ����
#define GM_NAME "KulleR.su | Zombie v.023-022f"

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
//	-	�������
#define ADMIN 2
#define HUMAN 1
#define ZOMBIE 0

//	-	��������� �����
#define MAX_Z_CLASS 4	//	�������� ������� � �����
#define ZOMBIE_PROF_TANK 0
#define ZOMBIE_PROF_JOKEY 1
#define ZOMBIE_PROF_VEDMA 2
#define ZOMBIE_PROF_BUMER 3

//	-	��������� �����
#define MAX_H_CLASS 5	//	�������� ������� � �����
#define HUMAN_PROF_SHTURMOVIK 0
#define HUMAN_PROF_MEDIK 1
#define HUMAN_PROF_SNIPER 2
#define HUMAN_PROF_DEFENDER 3
#define HUMAN_PROF_CREATER 4

#include <kuller_su/kuller_su_names> // ����� ������
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

// ��������� �������
#define CALLING_ACCOUNT_NOT_FOUND 0
#define CALLING_ACCOUNT_ONLINE 1
#define CALLING_ACCOUNT_OFFLINE 2

// ~~~~~~~~~ ����� ~~~~~~~~~~~
#define MAIL_GENERAL "kuller-su@mail.ru"//����� �� ������� ����� ������������ ��������� kuller-su@mail.ru
#define MAIL_PASSWORD "b100b7273"
#define MAIL_LOGIN "s.row.mail@yandex.ru"
#define MAIL_HOST "smtp.yandex.ru"
#define MAIL_SENDERNAME "S-ROW"
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~ ������� ������ ������� ����� ������� �� ����� ������������� ������ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define BOMB_BANG_RAD 40.0 														// ������ ������ � �����
#define TANK_BANG_RAD 20.0 														// ������ ������ � �����
#define EXPLODE_BLOCK_FREE_CELLS 10 											// ��������� ����� ��� ���������� �����
#define EXPLODE_BLOCK_CELLS_SIZE EXPLODE_BLOCK_FREE_CELLS + MAX_PLAYERS 		// ������� ����� ��������� �����
new bool: Player_MyExplodeBlocker[MAX_PLAYERS][EXPLODE_BLOCK_CELLS_SIZE]; 		// ���� ����, ��� ����� �������� ���������� �� �������
new Player_ExploderBlockers[MAX_PLAYERS]; 										// ������� ����� ���������� �� �������
new bool:Player_BlockExplode[MAX_PLAYERS]; 										// ���� ���������� ����� �� �������
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//����� �����
stock WeaponNames[][20] = {{"Unarmed"},{"Brass Knuckles"},{"Golf Club"},{"Night Stick"},{"Knife"},{"Bat"},{"Shovel"},{"Pool Cue"},{"Katana"},{"Chainsaw"},{"Dildo"},{"Vibrator1"},{"Vibrator2"},{"Vibrator3"},{"Flowers"},{"Cane"},{"Grenade"},{"Tear Gas"},{"Molotov"},{" "},{"N/A"},{" "},{"Pistol"},
{"Silencer"},{"Deagle"},{"Shotgun"},{"Sawnoff"},{"Spas12"},{"Mac-10"},{"Mp5"},{"AK-47"},{"M4"},{"Tec-9"},{"Rifle"},{"Sniper"},{"RPG"},{"HeatSeeker"},{"Flamethrower"},{"Minigun"},{"Satchel"},{"Detonator"},{"Spraycan"},{"Extinguisher"},{"Camera"},{"Nightvision"},{"Infrared"},{"Parachute"},{" "},{" "},{"Vehicle Collision"},{"HeliKill"},{"Explosion"},{" "},{" "},{"Long Fall"}};


//���������� ���������, ���� � ������� � �� ������
new Float:PoolsAndLakes[][5] ={//�������� � ����� (��������) ��������� ����� - ������
{-2359.918, -2518.289, -206.766, -301.4451, 39.0},//����� � ����� ������
{-2641.895, -2765.5, -388.2343, -522.3632, 7.0},  //����� � ����� ������
{-338.6584, -852.4849, -1821.749, -2148.729, 7.0},//����� �����
{2037.474, 1911.98, -1164.708, -1239.715,20.0},//���� ����
{1311.132, 1204.652, -2352.978, -2427.985,12.0},//����� � ������
{1345.357, 1254.089, -754.1426, -856.7839,88.0},//���� ���� �������
{1144.432, 1039.331, -595.5717, -712.3504,114.0},//������ ��� ��
{352.8172, 177.8868, -1137.074, -1298.931,79.0},//������ ���� 2�� ��
{2630.327, 2520.991, 2420.93, 2308.756,18.0},//������� �� 18 ������
{2575.659, 2438.989, 1616.373, 1504.199,11.0},  //������� ��2 11 ������
{2200.793, 2044.6, 1217.962, 1059.371,11.0},//����� � ��������
{2032.885, 1798.594, 1724.678, 1469.386,11.0},//������
{2134.411, 1997.741, 2010.915, 1817.512,11.0},//��������
{-385.3699, -1436.379, 2849.402, 1880.138,44.0}//����� �����
};


// ~~~~~~~~~~~~~~~ ������ ������ ������� �� ���������� ~~~~~~~~~~~~~~~
new bool: isConnected[MAX_PLAYERS];
new pName[MAX_PLAYERS][MAX_PLAYER_NAME];
#define GetName(%0) pName[%0]
#define IsPlayerConnected(%0) isConnected[%0]
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~~~~~ ���������� ~~~~~~~~~~~~~~~ //
new AUDIOSTREAM_URL[100] = "http://listen3.myradio24.com:9000/8468"; // ����������� "NONE" ���� ������ ��������� �����
#define RADIO_MAIL "kuller-su@mail.ru" // ����� ��� �������� � �����
#define SENDHELLO_ANTIFLOOD_TIME 40 // ��� � ������� ������ ����� ����� �������
#define CALLSONG_ANTIFLOOD_TIME 40 // ��� � ������� ������ ����� ����� ���������� �����
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

// ~~~~~~~~~~~~~~~ ��������� ������ ~~~~~~~~~~~~~~ //
new gSpectateID[MAX_PLAYERS] = -1;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

new S[MAX_PLAYERS]; // ����������, ���������� �� ��������� ������

// ~~~~~~~~~~~~~ �������� ~~~~~~~~~~~~~~~~~~~~~~
#define FloodTime 2 //������� ����� � ���
#define FloodTimeCmd 1 //������� ����� ���������
#define FloodTimeMail 60//������� ����� �� ����
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//����� ��������� ��� ������ � ��� (������ �� ������������)
#define SPAWN_PROTECT 2

// ~~~~~~~~~~~ �����: ������ ~~~~~~~~~~~~~~~ //
#define MAX_MAPS 36//�������� �������������� ����
#define MAX_MAP_SPAWN_POS 8 // �������� �������������� ������� �� ������
#define MAP_CHANGE_DATA true // ���� ����� �� �������� ������ ���� �� ���� ( �����, ������ ). true - ���������, ����� - ������
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

#define MAX_PATH_STR_ACCPATH 50//������ ���� � ��������
#define SHOP_GUNS_DIALOG_LINE_SIZE 90//������ ����� � ������� � �������� �������
#define MAX_EMAIL_SIZE 64//����������� ����� ����� ��� �����������

// ~~~~~~~~~~~ ���� � ������ ~~~~~~~~~~~~~~ //
#define FORBIDDEN_WEAPONS_FILE "zombie/BadGun.cfg"
#define ACCOUNTS_FOLDER "zombie/accounts"
#define MAPS_FOLDER "zombie/maps"
#define TITULS_FILE "zombie/tituls.ini"
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

//	~~~~~~~~~~~ ������������� ~~~~~~~~~~~
#define AUTOMESSAGE_TIME 90//����� � ���. ����� ���������������
new messageid = 0;
new time_to_send_automessage = AUTOMESSAGE_TIME;
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


// ~~~~~~~~ ����� �������� ������� ~~~~~~~~ //
#define HUMAN_COLOR 0x0000FFFF
#define HUMAN_COLOR_I 0x0000FF00 //	���� �������� �������� � �����������
#define ADMIN_COLOR 0xFFFF0000
#define ZOMBIE_COLOR 0x008000FF
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

// ~~~~~~~~~~ ������ ��������� ~~~~~~~~~~  //
#define PM_INCOMING_COLOR     0xFFFF22AA
#define PM_OUTGOING_COLOR     0xFFCC2299
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ //

//----[����� � str �������]----//
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


//������� ��� ���������
#define NONE 0
#define RUB  0
#define ZM   1

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ������� ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define LOGIN_DIALOG 0                      	//������ ������
#define REGISTER_DIALOG 1                   	//������ ����
#define AGE_DIALOG 2                        	//������ ����� ��������
#define DIALOG_HUMANPROFS_LIST 3            	//������ � ����������� �����
#define ABOUT_HUMAN_DIALOG 4                	//������ � ��������� ��������� ��������� �����
#define DIALOG_ZOMBIEPROFS_LIST 5           	//������ � ����������� �����
#define ABOUT_ZOMBIE_DIALOG 6               	//������ � ��������� ��������� ��������� �����
#define ACCEPT_REGISTER_DIALOG 7            	//������ � �������������� �����������
#define MENU_DIALOG 8                       	//������ � ����
#define MENU_RULES_D 9                      	//������ � ���������
#define MENU_RULES_D2 10                    	//������ � ��������� �������� 2
#define MENU_STAT_D 11                      	//������ �� �����������
#define MENU_ADMINS_D 12                    	//������ � ���������� � ��������������
#define MENU_ADMINS_D_LIST 13               	//������ �� ������� ������� ������
#define MENU_ADMINS_D_REPORT_INPUT_ID 14    	//������ � ������� �� ������ � ������ ��
#define MENU_ADMINS_D_REPORT_INPUT_REASON 15	//������ � ������� �� ������ � ������ �������
#define MENU_ADMINS_D_REPORT_TO_MAIL 16     	//������ ������ �� �����
#define MENU_HELP_D 17                      	//������ � �������
#define MENU_MSGBUFFER_D 18                 	//������ � �������: �������� ������ ����
#define MENU_TITULS_D 19                    	//������ � �������� �������
#define MENU_KICK_VOTE_DIALOG_VOTE 20       	//������ � ������������
#define MENU_KICK_VOTE_CHOSE_ID 21          	//������ � ������������: ���� ��
#define SHOP_DIALOG 23                      	//������ � ���������
#define SHOP_PROTECT_D 24                   	//������ � ��������
#define SHOP_CHOSEN_SROK_D 25              	 	//������ ����� ����� ������
#define SHOP_ACCEPT_BUY_CAP 26              	//������ ������������� ������ ������ (���� ��� ���� �����)
#define SHOP_ACCEPT_BUY_CAP_TRUE 27         	//������ ������������� ������� ������
#define SHOP_CAP_BUYED 28                   	//������ � ����������� � ��������� ������
#define MENU_ADMINS_D_REPORT_AB_BUG 29      	//������ � ���������� ������������� � ����
#define SHOP_GUNS_D 30                      	//����� ����� ����������� ������ (�������� ��������� � �.�)
#define SHOP_VIP_D 31                       	//����� ����� � ������� ����
#define SHOP_VIP_ACCEPT_D 32                	//������ � �������������� ������� ���
#define SHOP_VIP_BUYED_D 33                 	//���������� � ��������� ����
#define SHOP_UPG_RANK 34                    	//������� ���������� ����� �� �����
#define CHOSEN_GUN_REPLACE_D 35             	//������������� ������� ������
#define CHOSEN_GUN_ACCEPT_D 36              	//������������� ������� �����
#define SHOP_GUN_DIALOG_PISTOLS 37          	//������ ����������
#define SHOP_BUY_GUN_VALUTE_CHOSE_D 38      	//����� ������ � ������� ������
#define CHOSEN_GUN_ACCEPT_D_22 39           	//������������� ������� ������
#define SHOP_GUN_AVTOMATS_D 40      			//������ ���������
#define SHOP_GUN_SHOTGUNS_D 41  		 		//������ ������
#define SHOP_GUN_KARABINS_D 42  				//������ ��������� ��������
#define MENU_ADMINS_D_SUGGEST_ADMIN 43    		//������ � �������� � �������������
#define DIALOG_YOU_NEEDED_NEW_PROF_YES 44  		//���������� � ��������� ��������� (��������� ����� ������ ���� ���������)
#define DIALOG_YOU_NEEDED_NEW_PROF 45  	 		//������������� ������� ���������
#define MENU_MYPROFS_CHOSE_CLASS 46   			//������� ���������: ����� ����� ���������
#define MENU_MYPROFS_CHOSE_TEAM 47   			//������� ���������: ����� �������
#define SHOP_BUY_PROFESSION_BUYED_D 48  		//���������� � ��������� ��������� (��������� ����� �������)
#define SHOP_BUY_PROFESSION_CHOSE_PROF 49   	//������� ���������: ����� ����� ��������� (�����)
#define SHOP_BUY_PROFESSION_CHOSE_TEAM 50  		//������� ���������: ����� ������� (�����)
#define DIALOG_ENTERMAIL 51             		//������ � ������ ����
#define DIALOG_ENTER_FRIEND_NAME 52    	 		//������ � ������ ����� �����
#define SHOP_BUY_HEALTH 53                  	//������ � �������� ��: ����� �������
#define SHOP_BUY_HEALTH_ENTER_KOLVO 54      	//������ � �������� ��: ���� ����������
#define SHOP_BUY_HEALTH_CHOSE_VALUTE 55     	//������ � �������� ��: ����� ������
#define SHOP_BUY_HEALTH_ACCEPT 56           	//������ � �������� ��: �������������
#define SHOP_BUY_HEALTH_INFO 57             	//������ � �������� ��: ���������� � �������
#define DIALOG_TRAINING_CHOSE 58 				// ������ � ������������ �������� ��������� �������� ��� ���
#define DIALOG_TRAINING_BOX 59 					// ���� ������ �������� � ������
#define DIALOG_CHANGEMAP 60						// ������ ����� �����
#define DIALOG_AUDIOSTREAM 61                   // ����� � ����� �������
#define DIALOG_RADIO_SENDHELLO 62               // �������� ������
#define DIALOG_RADIO_CALLSONG 63                // �������� �����
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//	~~~~~~~~~~~~~~~~~~	�������������� ��   ~~~~~~~~~~~~~~~~~~~~~~~~~~~ //
#define SHOP_HEALTH_PRICE_ZM 1000                	// ���� ������ �� � ZM
#define SHOP_HEALTH_PRICE_RUB 1                 	// ���� ������ �� � ���
#define PLAYER_MAX_BUYED_HEALTH_FOR_ZOMBIE 300 		// ������� ����� ����� ���������� ������������� ��
#define PLAYER_MAX_BUYED_HEALTH_FOR_HUMAN 300 		// ������� ������� ����� ���������� ������������� ��
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	//

//	~~~~~~~~~~~~~~~~~~	������� ���������� �����    ~~~~~~~~~~~~~~~~~~  //
#define END_REASON_ZOMBIE_WIN 0		//	����� ��������
#define END_REASON_LILTE_PLAYER 1	//	���� �������
#define END_REASON_ADMIN_STOP 2		//	����� ���������
#define END_REASON_TIME_LEFT 3		//	����� �����
//  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~	//

//���������
#define KRIK_RADIUS 7.0					//������ ����� ������ � ������
#define DEFENDER_BANG_RADIUS 6.0		//������ ������� ��������� �� ������ ���������
#define CURE_HEAL_RADIUS 4.0			//������ ������� ������
#define INFECT_RADIUS 2.5				//������ �������� ��������� � �����
#define INFECTED_PROCENT 20				//������� �������, ������� ������ ����� ��� ���������
#define ROUND_TIME 315					//����� ������ (250)
#define INFECTION_TIME 15				//����� �� ��������
#define MAX_AFK_TIME_IN_HUMANT 20		//����. ����� � ��� �� ���������
#define ZM_FOR_SUVRIVOR 100				//������� ��������
#define COUNT_FOR_NEXTARENA 20			//����� �� ������ �����
#define RUSH_DIST 8.0					//������ ��������� ���� � ���������� ���� �����
#define RAMPAGE_TANG_BANG_DIST 3.0		//������ �������� ������ ��� �������� �����
#define BOMB_BAND_DIST 3.0 				// ������ �������� 4 ������� �����
#define TIME_TO_ACTIVE_RAMP 400			//�����, ���������� �� ���������� �������� ����� (����� ����� �������� N � ������� � ��)
#define RAMPAGE_TANG_BANG_TYPE 0		//��� ������ ��� �������� �����
#define BUMER_BW_RAD 8.0				//������ ��������� ���� � ���������� ������������ �������
#define ADMIN_SKIN 299					//���� ������ ��� ��� ������
#define CHECK_BUYED_TIME 30				//����� � ��� �� ������ �������� ��������� ����� � ���� �������
#define INFO_WIN_SHOW_TIME 4*1000 		//�� ������ ���������� � ������ ����-����
#define UNIX_TIME_CORRECT 3600*13 		//������� ����� ������� �� ���������� 13
#define HUMAN_PROFESSIONS_PRICE 10		//���� ������� ���������
#define ZOMBIE_PROFESSIONS_PRICE 10		//���� ����� ���������
#define COPY_SKIN_RAD 5.0      			//������ ����������� ����� ����� � ��������
#define FIX_ALL_TITUL_TIME 20  			//������ 20 ��� �������� �������
#define JOKEY_BIG_JUMP_RESET 3			//����������� ������ �����
#define JOKEY_BIG_JUMP_HIGHT 3.0		//������ ����� � ������ � ������
#define NEED_EXP_UMNOZHITEL 50 			// �������� = NEED_EXP_UMNOZHITEL * ������� ����
#define INFECTION_RESET_TIME 30 		// ��� � ������� ������ ����� ����� ������������ ���������
#define WARNS_TO_BAN 3 					// ������� ������ ����� �������� ��� ����
// ~~~~~~~ ������� ������ ������ ~~~~~~~
#define MAX_PASS_LEGHT 16
#define MIN_PASS_LEGHT 4
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//��������
#define INFECT_TEXT_RAD 20.0//��������� ������
#define INFECT_TEXT_HIGHT 0.8//������ ������ �� ������
#define INFECT_TEXT_STR "�����������\n�������: %s"//��� �����

//����������� ���������
#define MESSAGE_WAIT_SPAWN ""COL_EASY"��� ���������� ������� �������� �� ������ ���� ����������"
#define MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC ""COL_EASY"�� ��������� � �� ������ ������������ ������ ��������"
#define SERVER_LOGO GM_NAME//"*** Saints Row v. 0.2: ***"
//��������� �����������
#define MESSAGE_REASON_TIMEOUT "������ �����"
#define MESSAGE_REASON_DISCONNECT "�����"

#define MESSAGE_EXIT_INFO ""COL_LIME"%s "COL_CYAN"������� ������ (%s)"
#define MESSAGE_EXIT_INFO_ADLOG "%s ������� ������ (%s)"

//��������� ��� �����������
#define MESSAGE_PLAYER_CONNECTED ""COL_LIME"%s "COL_ORANGE"����������� � �������"
#define MESSAGE_PLAYER_CONNECTED_LOG "%s ����������� � ������� [%s]"

//����������� �� �������
#define MESSAGE_WELCOME_SELECTING "======================================================"

// ~~~~~~~~~~~ ������� ��������� ~~~~~~~~~~~
#define RED_MONITOR 	1	//	������ �����
#define ONE_HP 			2	//	����� + ������ ������ ��
#define TWO_HP 			3	//	����� + ������ 2 ��
#define THREE_HP 		4	//	����� + ������ 3 ��
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~ ����� ~~~~~~~~~~~
#define RED_CAP 		1	//	������� �����
#define LIGHTBLUE_CAP 	2	//	������� �����
#define BLUE_CAP 		3	//	����� ��������
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~ ������ ����� ����� ~~~~~~~~~~~
#define DAMAGE_LEVEL_1 		20
#define DAMAGE_LEVEL_2 		50
#define DAMAGE_LEVEL_3 		80
#define PRIDATOK_RANDOM 	20	//	� ����������� ����� ����� �� �������� ����� �� 0 �� ����� ���������
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~ ����� ~~~~~~~~~~~
new Home_Interior = 3;	//	�������� ������
new Float: Home_Pos[4];	//	������� ������
new Home_VW = 1;	//	���������� ��� ������
stock SetDefaulthHome()	//	������ ����� �� ��������� (��-���� ���)
{
    Home_Interior = 18;
    Home_Pos[0] = 1722.0225;
    Home_Pos[1] = -1647.4247;
    Home_Pos[2] = 20.2276;
    Home_Pos[3] = 178.2884;
    Home_VW = 1;
}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//	~~~~~~~~~~~ ������ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define MAX_TITULS 7	//	������� ����� ������� ��������
#define TIT_NONE 0
#define TIT_LORD 1
#define TIT_PRESIDENT 2
#define TIT_RAMBO 3
#define TIT_KILLER 4
#define TIT_PROSVET 5
#define TIT_FRIENDLY 6
new Tit_Value[MAX_TITULS];//�������� ������
new Tit_Name[MAX_TITULS][128];//��� ��������� (������� strtok �� �������������� ����� ����������� �����)
stock LoadTituls() //������� ��� ������ �� �����
{
	  new IF,buffer[MAX_PLAYER_NAME+60];
	  if(fexist(TITULS_FILE))IF = ini_openFile(TITULS_FILE);
	  else return 1;
	  for(new i = 1,idx; i < MAX_TITULS; i++)
	  {
			  idx = 0;
			  if(ini_getString(IF,GetTitKeyName(i),buffer) == INI_KEY_NOT_FOUND)
			  {
                  Tit_Name[i] = "�����������";
                  Tit_Value[i] = 0;
			  }
			  else
			  {
				  Tit_Name[i] = strtokForCmd(buffer, idx,',');
				  if(!strlen(Tit_Name[i]))Tit_Name[i] = "�����������";
				  Tit_Value[i] = strval(strtokForCmd(buffer, idx,','));
			  }
	  }
	  ini_closeFile(IF);
	  print("   ������ ���������");
	  return 1;
}
stock GetTitKeyName(titulid)//������ ���� � �� � ������
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
stock GetTitulName(titulid)//������ ��� ������
{
	 new str[32];
	 switch(titulid)
     {
	        case TIT_LORD:str = "����";
			case TIT_PRESIDENT:str = "���������";
			case TIT_RAMBO:str = "�����";
			case TIT_KILLER:str = "������";
			case TIT_PROSVET:str = "�������������";
			case TIT_FRIENDLY:str = "�����������";
	 }
	 return str;
}
stock ReWriteTitul(titulid)//���������� �����
{
	   new IF,str[MAX_PLAYER_NAME+60];
	   format(str,sizeof(str),"%s,%d",Tit_Name[titulid],Tit_Value[titulid]);
	   if(fexist(TITULS_FILE))IF = ini_openFile(TITULS_FILE);
	   else IF = ini_createFile(TITULS_FILE);
	   ini_setString(IF,GetTitKeyName(titulid),str);
	   ini_closeFile(IF);
}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~ ������ ������� ��� ���������� ������ �� ������������ ����� ~~~~~~~~~~~~
#define FRIENDINVITE_PRICE_RUB 100 // RUB
#define FRIENDINVITE_LVL_FOR_PRICE 24 // ������� ����� � ���� ����� ���������, ����� �������� FRIENDINVITE_PRICE_RUB

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

new bool: isCreatedAccount[MAX_PLAYERS];
new test_enabled[MAX_PLAYERS];
new MaxID = 0; // ������ ������������ �� �� �������
new Player_CurrentTeam[MAX_PLAYERS];
#define TIME_TO_HIDE_DROP_ZM_INFORMER 2 // ����� ������� ������ �������� TD_DropZmInformer
new TimeToHideTD_DropZmInformer[MAX_PLAYERS];
new bool: Call_Connected[MAX_PLAYERS] = false; // ���� ������ ��������
new bool: PlayerNoAFK[MAX_PLAYERS] = true; // ���� ����, ��� ����� ��������� � ��� � � ���� �� �����������
#define SET_POS_PROTECT_TIME 2 // �������� ����� � ����������� �� ����������
new Player_SetPosProtectTime[MAX_PLAYERS];

//������� �������
new bool:Game_Started = false;//�������� �� ����� �����
new Infection_Time;//����� �� ������ �������� � ���
new bool: MarkerActiv = false;//�������� �� �������� ��������
new Humans;//���������� ����� �� ������
new Zombies;//���������� ����� �� �������
new CountForNextArena = 0;//����� �� ����� ������ �� ������ ����� �����
new CountForEndArena;//����� �� ����� �����
new survaivors;//����� ��������
new NextArenaId; //�������� �� ��������� �����
new TimeToCheckBuyed;//����� �� �������� ������� �������
new TimeToFixTituls;
new Player_Special_Voteban[MAX_PLAYERS];
//���������� ��������: ������� ��� ���� - ����� ���������
new HumanProf_D[48*MAX_H_CLASS];
new ZombieProf_D[48*MAX_Z_CLASS];

#define ABOUT_YOUR_GAME_DIALOG_SIZE 2048
new AboutYourGame_Dialog[ABOUT_YOUR_GAME_DIALOG_SIZE]; // ����� ����

#define RULES_LIST_SIZE 2048
new Rules_Dialog[2][RULES_LIST_SIZE]; // �������
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~~~~~~ �������� ~~~~~~~~~~~~~~~~~~~~~
#define TRAINING_MODE_REGISTER 0   // ����� �������� �� �����������
#define TRAINING_MODE_MENUDIALOG 1 // ����� �������� �� �������� � ����
#define MAX_TRAINING_LISTS 7 // ������� ����� ������� ��������
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~~~~~~ ��������� �������� ~~~~~~~~~~~~~~~~
#define TRAINING_START_SIZE 2048
new TrainingStart_List[TRAINING_START_SIZE];

#define TRAINING_TERM_SIZE 2048
new TrainingTerm_List[TRAINING_TERM_SIZE];

#define TRAINING_CMDSDIALOGS_SIZE 2048
new TrainingCmdsDialogs_List[TRAINING_CMDSDIALOGS_SIZE];

#define TRAINING_END_SIZE 2048
new TrainingEnd_List[TRAINING_END_SIZE];
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ���������� �������� ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
new TrainingStart_ListData[12][] = { // ����������
/*0*/    {"������������. ��� ��������� ��������� ��������� ��� � ��������� � ������������ ����. \n"},
/*1*/    {"������ �����, �������� �� ������ ������������� ����������� � ������ ��������� ���� \n"},
/*2*/    {"������ ����� ������ Zombie, �.�. ��������� �� ���� ������� ������ �������. \n"},
/*3*/    {"��  ������������ ��� ����� ������ � ���������� ������� �������. \n"},
/*4*/    {"�� ����������� ��������� ����� ������ �� �������������������� ���. \n"},
/*5*/    {"���� �� ������������ ��� �������, ����������� ������� ����� �� �������, �� ��� �� ������ ������������� ��� �����������, �������� �������� ����. \n"},
/*6*/    {"������ ����� ����� ���� ����������� � ������. ��������: ������ ����� �������� ��������������� ����, ��������� �������������� ����� \n"},
/*7*/    {"��� ��������� ����� ������ ��������� ����� ��� ������ ����� ����������. \n"},
/*8*/    {"KulleR.su �������� ���������� �� ��������������� ��������. ����� ������ ���� ������ �����, ��������������� � �������������. \n"},
/*9*/    {"�������� ���, � ��� �� �������, ���� �� ������, ����� � ��� ���������� �����. ������������ � ��������������, ������ ���������. \n"},
/*10*/   {"�� ��� �� ���������� ���� ����, ������ �������� �����, ����������, ����� ����� ������. ������� ��� ��� �����, \n"},
/*11*/   {"���������� ��������� � ���������� ��������-������������ ������� ��������. ����������� F6 - ��� �������� ������� � ��� ����. \n"}
};
new TrainingTerm_ListData[10][] = { // �������
/*0*/    {"Zombie Money - ������, ������� �������� ������������, �� ��� ����� ������ ��������� ������, �����, ������, ������ � �.�. \n"},
/*1*/    {"��� ������������ � ������ ������� ����. �������� �� ����� ��� �������� ����� ��� �����.\n"},
/*2*/    {"RUB (����� ������) - �����������, ��� ����������� ����������������� ������� �� ����� ��� ������� ������.\n"},
/*3*/    {"�� ��� �� ������ ������ �� ��� ��������� ������. ������������ ������ ������ ���� ���� Zombie Money\n"},
/*4*/    {"����� �� ����������, ���������� �������� � ����� ( kuller.su ) �������� �������������� ������� � KulleR.\n"},
/*5*/    {"������ �������: �������, �������� ���������, ��������� ����������� ����, ������� ����������� ����, ���������\n"},
/*6*/    {"������� ( Score ) � � ������ ����� ���������� ���� ���� � ����. ����� ���������� 10 ����� �������, ��� ����� ��������� �����������.\n"},
/*7*/    {"���� � �� ���� �������� ����� ��� �������� �� ��������� 1 ����.������������ �����, ���� ���� Zombie � Human.\n"},
/*8*/    {"�� ���� �������� ��� ������� ��, ����������� ������, ����������� ����� ������, ������������� �� �������� � �.�.\n"},
/*9*/    {"��� �� ��������� ����� �� ������ � ���� �� �������� �� ������� 24 ���� - �� ��������� 100 RUB �� ���� ����.\n"}
};
new TrainingCmdsDialogs_ListData[6][] = { // ������� � �������
/*0*/    {"� ��������, 90% ������� ���������� �� ���������� �����, ������� ����� �����������. ��� ������� ��� �������� � ���������� ���� �� ����� �������.\n"},
/*1*/    {"���������� ������ (Y) - ������� ����, ��� �� ������ ����� ��� ������ ��� ����������.\n"},
/*2*/    {"���������� ������ (N) - ���������, � ������� ������ ���� ��� ������, ��� ������� ������ N, ��� �����������������. ������ ����� ���������� ����������� � ������������� (�����).\n"},
/*3*/    {"������ (����� ALT) - ��� ������ ����� ��������� ������ ������ �����, ��� �����, ���� ������� � ������� � �������� � ������ ����� ALT � ���������� ���� ���������� ���������,\n"},
/*4*/    {"��� ���� ��������, ��������� �� 3 ���� - ������, �������, �������. ����� ���������� �� ����, ���� ������� ������ �� ������.\n"},
/*5*/    {"���� ������ ������������ � ���� N (��� ���������) � ������� � ����� � ������� �������� ������.\n"}
};

new TrainingEnd_ListData[6][] = { // ��������� ��������
/*0*/    {"������� ����� �������� �����. �� ��������� � ���� � ������ ��������� � ������ ����� �����������. \n"},
/*1*/    {"������ �������, ��� �� ������� ��������� ������������� �����, �����, � ����� ������ �����, ������� ��� �������������� ������������ ����� �����������.\n"},
/*2*/    {"�� ��������� ��� ������������ ������� � ����������! �� ������ ������� ������������� ������� � �������: ������ �������� �� �� ������.\n"},
/*3*/    {"������������� ��������� ������� ������ � ������� ���������, �� ������ �� ��� ������� ��. �� ������ ����������������� ��������� ��������� �� �������,\n"},
/*4*/    {"� ������ ��� ����������� �� ��� ���� ��������, ���������, �� �������� �� ��� ������� � �� ���� �� ��� ��� ��������� ������������ ����� ���������� ��������?\n"},
/*5*/    {"������������, �����������������, ������������� ����������� �����! ������� ��� ����! ������ ��� �������� ���� �� ����� �������!\n"}
};
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

new bool: isKicked[MAX_PLAYERS];


// ~~~~~~~~~~~~~~~~~~~~~ ����������� ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define PROCENT_FOR_KICK 60//������� ������� ��������������� �� ��, ����� ��� ���
#define VOTETIME 30 //������ �� ��������� �����������
#define MINHOURS_FORVOTE 10//����������� ���� ��� �����������

new VotePlayerID = -1;//�����, ��� ������ ��������
new VoteTime;//����� �����������
new VoteZa;//������� �������������
new VoteNeed;//������� ����� ������� ��� ����
new bool:Player_Voted[MAX_PLAYERS];//������������ ��

//������ �� ��������� �����������: ����� ������ ��� ����������� ����������������
stock NullDisconnectIDVote(playerid)
{
	  if(VotePlayerID == -1)return 1;//����������� � �� ����������
	  if(!Player_Voted[playerid])return 1;//����� �� ���������
	  VoteZa --;
	  SetVoteCounter(VoteZa,VoteNeed);
	  return 1;
}
//����� �������� �����������
stock ResetVoteParams()
{
     VotePlayerID = -1;//�����, ��� ������ ��������
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
//����� ��������
stock PlayerVoted(playerid)
{
     VoteZa++;
     Player_Voted[playerid] = true;
     new str[100];
     format(str,sizeof(str),""COL_RULE"����� %s ������������ �� ��� ������ %s",GetName(playerid),GetName(VotePlayerID));
	 SendClientMessageToAll(-1,str);
	 SetVoteCounter(VoteZa,VoteNeed);
     FixVote();
     return 1;
}
//����� ��������� �����������
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
      format(str,sizeof(str),""COL_RULE"����� %s ������ ����������� �� ��� ������ %s. ������� ��� �������� ������: %d. ������������� ����� ����� ����",GetName(playerid),GetName(kickid),VoteNeed);
      SendClientMessageToAll(-1,str);
      SetVoteCounter(VoteZa,VoteNeed);
      TextDrawSetString(_VoteName_,GetName(VotePlayerID));
      ShowVoteTexts();
      return 1;
}
//�������� �����������
stock FixVote()
{
	   new str[100];
	   if(VotePlayerID == -1)return 1;
	   if(VoteZa >= VoteNeed)
	   {
              format(str,sizeof(str),""COL_RULE"����� %s ��� ������ � ���������� �����������. ������������� %d ������� �� ������ %d",GetName(VotePlayerID),VoteZa,VoteNeed);
              SendClientMessageToAll(-1,str);
			  new val = VotePlayerID;
			  ResetVoteParams();
			  Player_Special_Voteban[val] = (gettime() + 180);
			  t_Kick(val);

	   }
	   return 1;

}
//��������� �����������
stock CancelVote()
{
	   if(VotePlayerID == -1)return 1;
	   new str[100];
	   format(str,sizeof(str),""COL_RULE"����������� �� ��� %s ���������. ���������: %d �� ������ %d �������",GetName(VotePlayerID),VoteZa,VoteNeed);
	   SendClientMessageToAll(-1,str);
	   ResetVoteParams();
	   return 1;
}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 3DTEXT �������� � �������� � ����� ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define PrAnRaInf_TEXT_RAD 20.0 // ������ ������ ��������� �������� � �����
#define PrAnRaInf_TEXT_HIGHT 1.0 // ������ ����� ���������
#define PrAnRaInf_TEXT_STR "%s\n����: %d"
new Text3D: __T3D__ProfAndRankInf[MAX_PLAYERS];
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ������� ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define HideDialog(%1)    ShowPlayerDialog(%1, -2, 0, "", "", "", "")

#define AC_MAX_REASONS 13 // �������� ������

#define AC_JETPACK_HACK_ 0 // ����-�����������
#define AC_FAKESKIN_HACK_ 1 // ��������� ����        + [��������]
#define AC_ARMOUR_HACK_ 2 // ��� �� �����
#define AC_DIALOG_HACK_ 3 // ��� �� ������
#define AC_GUN_HACK_ 4 // ��� �� ������
#define AC_AMMO_GUN_HACK_ 5 // ��� �� ������� + [��������]
#define AC_GUN_WP_ID_HACK_ 6 // ��� �� ������ ������ � ����� + [��������]
#define AC_FLYHACK_ 7 // ����-�������
#define AC_TP_HACK_ 8 // ������� �� ��������
#define AC_INTERIOR_HACK 9 // ����-�������� � ���������
#define AC_CJ_RUN 10 // CJ ���
#define AC_FALL_STANDING 11 //��������� � �������
#define AC_FAST_RUN 12 // ������� ���

#define MAX_FAST_RUN_SPEED 15 // �������� ������ ��� ����, ����� ������� ������ �������
#define MAX_FALL_STANDING_TIME 2 // ������� ������ ����� ������ � �������

#define MAX_FORBIDDEN_WEAPONS 	(48)
#define MAX_WEAPONS 			(47)

#define DOBAVKA_ANI_FLYHACK 0.5 // �� ������� ������ ����� �������� ������ ����� ���� �������
#define OTBAVKA_ANI_FLYSTAND 8// �� ������� ������ ����� �� ������ �� MAX_FALL_STANDING_TIME(2) ������� ����� ���� �������

#define FLY_METERS 2.5 //�� ������� ������ ��� ����� ���

// ������� ��������
#define AC_ACTION_BAN 0
#define AC_ACTION_KICK 1
#define AC_ACTION_KILL 2
#define AC_ACTION_REPORT 3

new Float: FirstFallPos[MAX_PLAYERS][3]; // ��������� ������� �������
new bool: FallFlag[MAX_PLAYERS]; // ���� �������
new Float: FallZ[MAX_PLAYERS]; // ����� �������� ������ �������

#define TP_RADIUS 5//������ ��������� - 5 ������
#define SPAWN_PROTECT_TIME 2//�������� ����� � ��� ����� ������
new Float: AC_MyOldPos[MAX_PLAYERS][3];
new AC_SpawnProtect[MAX_PLAYERS] = 0;
new AC_TrueInterior[MAX_PLAYERS] = 0;

new TP_HACK_WARNINGS[MAX_PLAYERS] = 0;
#define MAX_TP_HACK_WARNINGS 3

// ~~~~~~~~~~~~~~~~~~~~~ �����~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define AC_MAX_SLOTS 13
new MyWeaponID[MAX_PLAYERS][AC_MAX_SLOTS];
new MyAmmo[MAX_PLAYERS][AC_MAX_SLOTS];
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~~~~~~~~~~~ ������ ~~~~~~~~~~~~~~~~~~~~~
#define AC_MAXIMUM_CLASS 1 // �������� ������� �� � ��� 1
new AC_ClassSkin[AC_MAXIMUM_CLASS];
new AC_CreatedClass = 0;
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

static ForbiddenWeaponsCount;
new ForbiddenWeapons [MAX_FORBIDDEN_WEAPONS char];
new bool: isDebug[MAX_PLAYERS][AC_MAX_REASONS];

new FallTime[MAX_PLAYERS];

enum AC_DATA{
    DialogID,
    RealSkinID,
}
new ACInfo[MAX_PLAYERS][AC_DATA];

// ��������� ������ � ��������� ��������
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
	if(oneanim == -1){
	    if( idx == 1130 || idx == 1132 || idx == 1133){ // FALL_FALL
			return true;
	    }
    }
    else{
        if( idx == oneanim){
		    return true;
		}
    }
	return false;
}

// ������� �� �������� � �� �������
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
//#define SetPlayerPos AC_SetPlayerPos // ������

stock NullACBuffer(playerid){
    TP_HACK_WARNINGS[playerid] = 0;
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



//���� ������ ��������� �����
stock AC_GivePlayerWeapon(playerid,weaponid,ammo){

	 isDebug[playerid][AC_GUN_WP_ID_HACK_] = false; // ������� ������� �� ��������
     GivePlayerWeapon(playerid,weaponid,ammo);
	 new slotid = GetWeaponSlot(weaponid);
     MyWeaponID[playerid][slotid] = weaponid;
     MyAmmo[playerid][slotid] += ammo;
	 return 1;
}

//���� ������ ��������� �������
stock AC_SetPlayerAmmo(playerid,weaponslot,ammo){
     MyAmmo[playerid][weaponslot] = ammo;
     if((weaponslot != 0) && (ammo == 0)){
           MyWeaponID[playerid][weaponslot] = 0;
     }
	 SetPlayerAmmo(playerid,weaponslot,ammo);
	 return 1;
}

//�������� ������� ������ � ������ ��, ������� ��-���������� ������ ����
stock RegivePlayerGun(playerid){
	 ResetPlayerWeapons(playerid);
	 for(new i = 0; i < AC_MAX_SLOTS; i ++){
             GivePlayerWeapon(playerid,MyWeaponID[playerid][i],MyAmmo[playerid][i]);
	 }
	 return 1;
}

//��-����������� ������� � ������ ��� �����
stock AC_ResetPlayerWeapons(playerid){
	 ResetPlayerWeapons(playerid);
	 for(new i; i < AC_MAX_SLOTS; i ++){
             MyWeaponID[playerid][i] = 0;
             MyAmmo[playerid][i] = 0;
	 }
     MyAmmo[playerid][0] = 1;//������� �� ����
	 return 1;
}

// ������� ��������� ������
stock AC_ShowPlayerDialog(playerid, dialogid, style, capiton[], info[],but1[],but2[]){
    ACInfo[playerid][DialogID] = dialogid;
    ShowPlayerDialog(playerid, dialogid, style, capiton, info,but1,but2);
	return 1;
}

// ��-���������� ������� ������ ����
stock AC_SetPlayerSkin(playerid, skinid){
	 SetPlayerSkin(playerid, skinid);
	 ACInfo[playerid][RealSkinID] = skinid;
	 ClearAnimations(playerid);
	 return 1;
}


//���������� ��������� SpawnInfo
stock AC_SetSpawnInfo(playerid,team,skin,Float:x,Float:y,Float:z,Float:rot,w1,a1,w2,a2,w3,a3)
{
     ACInfo[playerid][RealSkinID] = skin;
     SetSpawnInfo(playerid,team,skin,Float:x,Float:y,Float:z,Float:rot,w1,a1,w2,a2,w3,a3);
	 return 1;
}
#define SetSpawnInfo AC_SetSpawnInfo //��������

//�������� ��������� ����� ������
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
            case AC_JETPACK_HACK_://���� �������
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
            case AC_DIALOG_HACK_: // ��� �� ������ [���������� �� OnDialogResponse]
			{
					// argument = dialogid
					if( argument != ACInfo[playerid][DialogID] )
					{
                            HideDialog(playerid);
							return true;
					}
			}
            case AC_FAKESKIN_HACK_:   // ��������� ����
			{
					 if( GetPlayerSkin(playerid) != ACInfo[playerid][RealSkinID] )
					 {
                            if( !isDebug[playerid][AC_FAKESKIN_HACK_] )   // ���� �� � ������ ��������
							{
									  // ������� � ����� �������� [ ������ �� ������ ������������ ]
                                      isDebug[playerid][AC_FAKESKIN_HACK_] = true;
									  return false;
							}
                            CallLocalFunction("OnPlayerUseFakeSkin","iii",playerid, ACInfo[playerid][RealSkinID], GetPlayerSkin(playerid));
                            isDebug[playerid][AC_FAKESKIN_HACK_] = false; // �������� ���������
                            return true;
					 }
			}
			case AC_TP_HACK_:
			{
					 if(isKicked[playerid])return 1;
					 if(gSpectateID[playerid] != -1)return 1;
					 // if(  GetPVarInt(playerid, "PlayerInAFK") > 1) return 1; �����
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
							      	     if( TP_HACK_WARNINGS[playerid] > MAX_TP_HACK_WARNINGS )
							      	     {
							      	        CallLocalFunction("OnPlayerUseTpHack","ii",playerid, AC_ACTION_BAN);
							      	     }
							      	     else
							      	     {
							      	        CallLocalFunction("OnPlayerUseTpHack","ii",playerid, AC_ACTION_REPORT);
							      	        TP_HACK_WARNINGS[playerid] ++;
							      	     }
							      }
						      }
				     }
				     GetPlayerPos(playerid,AC_MyOldPos[playerid][0],AC_MyOldPos[playerid][1],AC_MyOldPos[playerid][2]);//��������� ������� ������� ������ � �������
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
			case AC_FALL_STANDING: //������� �� ������� � ����
			{
			    if(GetPVarInt(playerid,"ProtectTime") != 0)return false; // ��������� ���������
			    if( isFall(playerid, 1130) )
			    {
					if(FallTime[playerid] == 0)
					{
						GetPlayerPos(playerid,FirstFallPos[playerid][0],FirstFallPos[playerid][1],FirstFallPos[playerid][2]);
					}
			        FallTime[playerid] ++;
			        if( FallTime[playerid] > MAX_FALL_STANDING_TIME) // ���� ����� �������� ����� ����� � ������
			        {
			            if( GetPVarInt(playerid, "PlayerInAFK") > 0) // ���� ����� � �������� �����
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
			                // ���� ������� ������� ������ ���������, �� ���
			                //print("���� ������� ������� ������ ���������, �� ���");
			                CallLocalFunction("OnPlayerUseFlyHack","iis",playerid, AC_ACTION_REPORT, "������ �����");
							FallTime[playerid]= 0;
							return true;
			            }
			            if( FloatBuff[2] >= FirstFallPos[playerid][2]-OTBAVKA_ANI_FLYSTAND)
			            {
				            if(!isDebug[playerid][AC_FALL_STANDING]){ // ���� �� � ��������, �� ����� ������ ��� ����
								      isDebug[playerid][AC_FALL_STANDING] = true;
								      ClearAnimations(playerid);
								      FallTime[playerid] = FallTime[playerid]-1; // ����� ������ ��� ����
									  //SetTimerEx("OnAntiCheatUpdatePlayer", 200, 0, "iii", playerid, AC_FALL_STANDING, -1); // ��������, ���������� �� �����
            						  CallLocalFunction("OnPlayerUseFlyHack","iis",playerid, AC_ACTION_REPORT, "���������� �� ��������� � ����");
									  return false;
				      		}

							// ����� ������������ ����� ����, ������ �����
							//print("����� ������������ ����� ����, ������ �����");
							CallLocalFunction("OnPlayerUseFlyHack","iis",playerid, AC_ACTION_REPORT, "����� � ����");
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
				           return false; // ����� ����� �� �������
				        }
				        CallLocalFunction("OnPlayerUseFasRun","iis",playerid, AC_ACTION_REPORT, "������ ������� MAX_FAST_RUN_SPEED");
				        return true;

			    }
			}
			case AC_FLYHACK_:
			{
			        switch(argument)
			        {
			            case 0: // ����� �������� � ���� ( �� ������ ���� �� �������� )
			            {
							if( S[playerid] != 2 || GetPVarInt(playerid, "PlayerInAFK") > 0 )return false;
			                new Float:P[3];
			                GetPlayerPos(playerid,P[0],P[1],P[2]);
			                if( P[2] > FLY_METERS)//��� ����� ����
						    {
									for(new i; i < sizeof(PoolsAndLakes); i ++)//��������� ��� ����� � ��������
									{
                                           if(PlayerToKvadrat(playerid,PoolsAndLakes[i][0],PoolsAndLakes[i][1],PoolsAndLakes[i][2],PoolsAndLakes[i][3]))//���� ����� ��������� � �����-���� ������/��������
                                           {
												  if(P[2] < PoolsAndLakes[i][4])//���� ��� ������ ������ ������ ��������
												  {
														  return false;//�� �� ���
												  }
                                           }

									}
									CallLocalFunction("OnPlayerUseFlyHack","iis",playerid, AC_ACTION_REPORT,"��� ����� �������");
									return true;
						    }
			            }
			            case 1: // ����� �������� � �������-������� ��� ������ ��������� �����
			            {
			                if( Player_SetPosProtectTime[playerid] != 0) return false; // ������ � �������� �������� �� �����
			                if( isFall(playerid) ) // ���� ����� ������
							{
							    new Float:Nenuzhniy_FloatBuffer, Float:FloatBuffer2;
							    if( FallFlag[playerid] ) // ���� ����� ��� ������
							    {
							        GetPlayerPos(playerid,Nenuzhniy_FloatBuffer,Nenuzhniy_FloatBuffer,FloatBuffer2);
							        if( FloatBuffer2 > FallZ[playerid]+DOBAVKA_ANI_FLYHACK) // ���� ��� ������ ������ ����������
							        {
							            FallFlag[playerid] = false;
							            CallLocalFunction("OnPlayerUseFlyHack","iis",playerid, AC_ACTION_REPORT,"������� - �����");
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
                     		if(IsForbiddenWeapon(weaponid)) // ������� ��� ��� ��������
                     		{
                                CallLocalFunction("OnPlayerUseWeaponHack","iiii",playerid, weaponid, ammo, AC_ACTION_BAN);
								return true;
                     		}
                     		if((weaponid != MyWeaponID[playerid][slot]) && weaponid != 0)//���
                     		{
                             	if(!isDebug[playerid][AC_GUN_WP_ID_HACK_])
						     	{
							      	isDebug[playerid][AC_GUN_WP_ID_HACK_] = true;
							      	return 1;
						     	}
						     	RegivePlayerGun(playerid);
						     	//print("((weaponid != MyWeaponID[playerid][slot]) && weaponid != 0)");
						     	if( weaponid < 22) CallLocalFunction("OnPlayerUseWeaponHack","iiii",playerid, weaponid, ammo, AC_ACTION_REPORT); // ���� �������� ������
						     	else CallLocalFunction("OnPlayerUseWeaponHack","iiii",playerid, weaponid, ammo, AC_ACTION_REPORT); // ���������
						     	isDebug[playerid][AC_GUN_WP_ID_HACK_] = false;
						    	return 1;
                     		}
					 		if((ammo > MyWeaponID[playerid][slot]) && weaponid != 0)//���
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
					 }
            }
    }
    return false;
}

#define SetPlayerSkin AC_SetPlayerSkin                    // ������
#define AddPlayerClas AC_AddPlayerClass                   // ������
#define ShowPlayerDialog AC_ShowPlayerDialog              // ������

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
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ================================= ����-����� =================================//

#define MAX_CONNECTS_IS_ROW 1 // �������� ������� � ������ ��
#define SESSION_TIME 2 // ��������� ���� ����������� ��� � 2 �������
#define FREE_SESSION -1 // ������ ��� ��������, ������ ������!
#define MAX_SESSIONS MAX_PLAYERS*2 // ������������ ���������� ������
#define ATTACK_NPC 0 // ����� npc �� ������
#define DOUBLE_CONNECT 1 // ������������ ����������� � ������ ��
#define FAKE_DEATH 2  // ������������ ������
#define FAKE_SKIP_REQUESTCLASS 3 // ����� ������ ������ �����
#define DDOS_CONNECTER 4 // ����� �������������
// ��������� ������
#define PROTECT_MAX_IP_SIZE 16 // ��� �� ���������� 16 ����
new SessionTime[MAX_SESSIONS] = FREE_SESSION;  // ��� �������� ����� ������
new SessionIP[MAX_SESSIONS][PROTECT_MAX_IP_SIZE];      // ��� �������� �� ������
forward GetServerAttackByPlayer(playerid, attackid);  // �������� �� ����� ������� �������
// �������� ������
stock AddSession(playerid)
{
	// ���� ��������� ������
	new cell = -1;
	for(new i; i < MAX_SESSIONS; i ++)
	{
		    if( SessionTime[i] != FREE_SESSION ) continue;
			cell = i; // ��������� ������ �������
			GetPlayerIp(playerid,SessionIP[cell],PROTECT_MAX_IP_SIZE); // �������� �� � ����������
			SessionTime[cell] = SESSION_TIME; // ������ �����
			return true;
	}
	return false;
}
// ���� ������
stock CheckSessions()
{
    for(new i; i < MAX_SESSIONS; i ++){
		  if( SessionTime[i] <= FREE_SESSION) continue; // ������ ������
		  SessionTime[i] --;
	}
	return 1;
}
// �������� �� ����
stock IsDDOS(playerid)
{
	 new ip[PROTECT_MAX_IP_SIZE];
	 GetPlayerIp(playerid,ip,PROTECT_MAX_IP_SIZE);
	 for( new i; i < MAX_SESSIONS; i++)
	 {
			 if((!strcmp(ip, SessionIP[i], true)) && SessionTime[i] != FREE_SESSION) // ���� ���������
			 {
		           return true;
             }
	 }
	 return false;
}
// �������� ������
stock ClearSession(sessionid)
{
	if( sessionid >= MAX_SESSIONS || sessionid < 0 ) return 1; // ������ � sessionid
    SessionTime[sessionid] = FREE_SESSION;
	return 1;
}
// �������� �� ����� ������� �������
public GetServerAttackByPlayer(playerid, attackid){
	switch( attackid ){
			case ATTACK_NPC:{        // npc
					 if( IsPlayerNPC(playerid)){
							return true;
					 }
			}
			case DOUBLE_CONNECT:{    // ������� ����������� � ������ ��
                     new ip[2][PROTECT_MAX_IP_SIZE];
                     GetPlayerIp(playerid,ip[0],PROTECT_MAX_IP_SIZE);
                     new x;
                     for(new i, m = GetMaxPlayers(); i != m; i++){
                         if(!IsPlayerConnected(i) || i == playerid) continue;
                         GetPlayerIp(i,ip[1],16);
                         if(!strcmp(ip[0],ip[1],true)) x++;
                         if(x >= MAX_CONNECTS_IS_ROW){ // ������������ ���������� ����������
							   Kick( i );
                         }
                     }
                     if( x >= MAX_CONNECTS_IS_ROW) return true;
			}
			case FAKE_DEATH: {       // ������������ ������. �������� ������ �� onplayerdeath
                     if(GetPVarInt(playerid,"K_Times") > 1){
						  return true;
					 }
			}
			case FAKE_SKIP_REQUESTCLASS:{  // ��������� ����� ������ ������. �������� ������ �� OnPlayerSpawn
                     if(GetPVarInt(playerid,"Logged")==0){
		                  return true;
                     }
            }
			case DDOS_CONNECTER:{           // ���������� ������ �� onplayerconnect
                     if( IsDDOS(playerid) ){ // ���� ���������
			                 return true;
	                 }
			}
	}
	return false;
}
// ***********************************************************************************

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ������ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
new GM;//���������� ��� �������� �������
#define CP_UPDATE_INTERVAL 950//�������� ���������� ���������� � ������������ (���� ������� �������� !> && !<)
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~����� ������������� ���������� ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define MAX_PLAYER_OBJECTS 12//�������� �������� ��� ������
#define MAX_OBJECTS_CREATE MAX_PLAYER_OBJECTS*MAX_PLAYERS//�������� �������������� ��������
new Object[MAX_PLAYER_OBJECTS];//���������� ��� �������� �� �������
new Object_idx[MAX_PLAYERS];//���������� ��� ��������� �������� � ������
new Server_Objects = 0;//�������� ����� �������
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ����� ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#define MAP_MAX_NAME 32
//new OldMap = -1; //�� ���������� �����
new CurrentMap = -1;//�� ������� �����
new Float: MapSpawnPos[MAX_MAPS][MAX_MAP_SPAWN_POS][4];//����� �� �����
new MapSpawnsLoaded[MAX_MAPS]; // ���-�� ����������� �������
new MapName[MAX_MAPS][MAP_MAX_NAME];//��� �������� ��� �����
new bool:MapHaveMarker[MAX_MAPS] = false;//������� � ����� ������� ������� (������ ������ ���, ��� ��������� ��� ����������)
new MapInterior[MAX_MAPS];//�������� �����
new Float: MapMarkerPos[MAX_MAPS][3];//������� �������
new Loaded_Maps = 0;//������� ���� ����������� ����
new MapFS[MAX_MAPS][32]; // ������ �������� ��� �����

new MapDialog[(MAP_MAX_NAME+10)*MAX_MAPS];
stock CreateMapsDialog()
{
    MapDialog[0] = 0x0;
	for(new i, line[MAP_MAX_NAME+10];i < Loaded_Maps; i ++)
	{
	    format(line, sizeof( line ), "[%d] - %s\n", i, MapName[i]);
		strcat(MapDialog, line);
	}
	return 1;
}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ������� � ������� � �������� ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
enum guns_picture{
    gun_iden,
    gun_ammo,
    gun_rubprice,
    gun_zmprice,
    gun_srok
}

//��������, �������, ���� � ������, ���� � ����� �����, ���� � ���� (-1 = ����������)
static stock shop_pistols_table[][guns_picture] ={
    { 23,300,2,100,1},
    { 23,300,10,500,7},
    { 23,300,35,1500,30},
    { 23,300,50,50000,-1},

    { 22,300,5,300,1},
    { 22,300,20,1500,7},
    { 22,300,50,4500,30},
    { 22,300,100,100000,-1},

    { 24,100,5,500,1},
    { 24,100,20,2500,7},
    { 24,100,50,7500,30},
    { 24,100,100,100000,-1}
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

    { 29,300,3,300,1},
    { 29,300,12,1500,7},
    { 29,300,36,4500,30},
    { 29,300,72,100000,-1}
};
static stock shop_shotguns_table[][guns_picture] ={
    { 25,100,3,300,1},
    { 25,100,12,1500,7},
    { 25,100,36,4500,30},
    { 25,100,72,100000,-1},

    { 27,140,5,500,1},
    { 27,140,20,2500,7},
    { 27,140,50,7500,30},
    { 27,140,150,100000,-1},

    { 26,120,6,-1,1},
    { 26,120,30,-1,7},
    { 26,120,100,-1,30},
    { 26,120,250,-1,-1}
};
static stock shop_karabins_table[][guns_picture] ={
    { 30,300,7,300,1},
    { 30,300,35,1500,7},
    { 30,300,80,4500,30},
    { 30,300,200,300000,-1},

    { 31,300,10,500,1},
    { 31,300,50,2500,7},
    { 31,300,150,7500,30},
    { 31,300,300,100000,-1}
};
new Karabins_Dialog[SHOP_GUNS_DIALOG_LINE_SIZE*sizeof(shop_karabins_table)];
new Shotguns_Dialog[SHOP_GUNS_DIALOG_LINE_SIZE*sizeof(shop_shotguns_table)];
new Pistols_Dialog[SHOP_GUNS_DIALOG_LINE_SIZE*sizeof(shop_pistols_table)];
new Avtomats_Dialog[SHOP_GUNS_DIALOG_LINE_SIZE*sizeof(shop_avtomats_table)];
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//�����
new PlayerIngorePMPlayer[MAX_PLAYERS][MAX_PLAYERS];
new Player_ZombieInfectTime[MAX_PLAYERS]; // ����������� ����������� ��������
new Player_Warns[MAX_PLAYERS];
new Player_OLDHP[MAX_PLAYERS];
new Player_Invites[MAX_PLAYERS];
new Player_Email[MAX_PLAYERS][MAX_EMAIL_SIZE];
new Player_Deaths[MAX_PLAYERS];
new Player_MuteTime[MAX_PLAYERS];
new Player_AdminLevel[MAX_PLAYERS];
new Player_KillHuman[MAX_PLAYERS];
new Player_KillZombie[MAX_PLAYERS];
new Player_Age[MAX_PLAYERS];
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
new AfkStartTime[MAX_PLAYERS];//����� �� ����������� ������ � ���� ����� (���� ��� � ��� �� �����)
new Player_H_DopHealth[MAX_PLAYERS][MAX_H_CLASS];
new Player_Z_DopHealth[MAX_PLAYERS][MAX_Z_CLASS];
new Player_RegIP[MAX_PLAYERS][16]; // �� ��� �����������
new Player_FriendName[MAX_PLAYERS][MAX_PLAYER_NAME]; // ��� �����, ������������� �� ������


//�������� ������ ������ (�� �������� �������)
#define MAX_SLOTS 4
#define GUN_PISTOLS 0
#define GUN_AVTOMATS 1
#define GUN_SHOTGUNS 2
#define GUN_MASHINEGUNS 3

new Player_Gun[MAX_PLAYERS][MAX_SLOTS];
new Player_Ammo[MAX_PLAYERS][MAX_SLOTS];
new Player_GunSrok[MAX_PLAYERS][MAX_SLOTS];

//���� ���������� ������
new Player_CapSrok[MAX_PLAYERS];

//***************************************
		 /*��������� (������)*/
new Player_HumanProfession[MAX_PLAYERS];
new Player_ZombieProfession[MAX_PLAYERS];
		 /*���� �� ���������*/
new Player_HumanProfessionRang[MAX_PLAYERS][MAX_H_CLASS];
new Player_ZombieProfessionRang[MAX_PLAYERS][MAX_Z_CLASS];
		 /*����� ����������� �����������*/
new Player_HumanResetSkillTime[MAX_PLAYERS][MAX_H_CLASS];
new Player_ZombieResetSkillTime[MAX_PLAYERS][MAX_Z_CLASS];
		 /*������� ������  ������*/
new Player_HumanRangSkill[MAX_PLAYERS][MAX_H_CLASS];
new Player_ZombieRangSkill[MAX_PLAYERS][MAX_Z_CLASS];
		 /*������ ������������ ��������� ��� ���.*/
new bool:Player_H_HaveProfession[MAX_PLAYERS][MAX_H_CLASS] ;
new bool:Player_Z_HaveProfession[MAX_PLAYERS][MAX_Z_CLASS] ;

//****************************************

//����� � ����������
#define MAX_BOMBS MAX_PLAYERS*3
#define BOMB_DETONATOR 3000
new Bomb_Object[MAX_BOMBS];
new Bomb_Time[MAX_BOMBS];
new Bombs_Counter = 0;

new Float:Bomb_X[MAX_BOMBS];
new Float:Bomb_Y[MAX_BOMBS];
new Float:Bomb_Z[MAX_BOMBS];

new Player_MyBombId[MAX_PLAYERS] = -1;

//������� 04.06.2012: �������� ����������� �� Back Key - ��������

// ���������� ������� ���������
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
	                    // (51 * 100) / 1500 = ������� ��������� ���������� 51 �� 1500
	                    new itog_procent = floatround( ( exp * 100 ) / needexp );
						for(new procent = 0; procent < itog_procent; procent ++){
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
						for(new procent = 0; procent < itog_procent; procent ++){
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
                    HideBottomInformer(playerid);
			 }
	  }
	  PlayerTextDrawSetString(playerid,PTD_iNF_Score[playerid],finaltext);
      PlayerTextDrawSetString(playerid,PTD_iNF_Information[playerid],str);
	  PlayerTextDrawShow(playerid,PTD_iNF_Polosa[playerid]);
	  return 1;
}
//�������� ��� ����������
stock SetNull(playerid)
{
   for(new i = 0, s_b = MaxID; i <= s_b; i ++)
   {
    	PlayerIngorePMPlayer[playerid][i] = false;
   }
   Player_ZombieInfectTime[playerid] = 0;
   FallTime[playerid] = 0;
   test_enabled[playerid] = false;
   PlayerNoAFK[playerid] = true;
   S[playerid] = 0;
   Player_Warns[playerid] = 0;
   isKicked[playerid] = false;
   
   Player_BlockExplode[playerid] = false;
   Player_ExploderBlockers[playerid] = 0;
   for(new i; i < EXPLODE_BLOCK_CELLS_SIZE; i ++)
   {
         Player_MyExplodeBlocker[playerid][i] = false;
   }
   
   TimeToHideTD_DropZmInformer[playerid] = 0;
   Call_Connected[playerid] = false;
   Player_Voted[playerid] = false;
   Player_CapSrok[playerid] = 0;
   Player_OLDHP[playerid] = 50;
   Player_Invites[playerid] = 0;
   gSpectateID[playerid] = -1;
   TextDrawHideForPlayer(playerid,TD_InfectScreenBox);
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
   AfkStartTime[playerid] = 0;
   Player_ChosenInt[playerid] = 0;//������ ��� ���������
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
   Player_Rub[playerid] = 0;
   Player_Zm[playerid] = 0;
   Player_IsVip[playerid] = 0;
   Player_Cap[playerid] = NONE;
   Player_Special_Voteban[playerid] = 0;
   NullACBuffer(playerid); // �������� ������ ��������
		   /*������*/
   for(new i; i < MAX_H_CLASS; i++)//������� �����
   {
       Player_HumanRangSkill[playerid][i]=0;
       Player_HumanResetSkillTime[playerid][i]=0;//� ������ - ����������� ��������
       Player_H_HaveProfession[playerid][i] = false;
       Player_H_DopHealth[playerid][i] = 0;
   }
   for(new i; i < MAX_Z_CLASS; i++)//������� �����
   {
       Player_ZombieRangSkill[playerid][i]=0;
       Player_ZombieResetSkillTime[playerid][i]=0;
       Player_Z_HaveProfession[playerid][i] = false;
       Player_Z_DopHealth[playerid][i] = 0;
   }
   Medik_ResetHealthTime[playerid] = 0;
   
}

//������� �������
stock FixTitul(playerid,titulid){
	   switch(titulid){
			case TIT_LORD:{
				 if(Player_Rub[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[TIT_LORD],GetName(playerid),0,MAX_PLAYER_NAME);
					  Tit_Value[TIT_LORD] = Player_Rub[playerid];
					  ReWriteTitul(titulid);
				 }
			}
			case TIT_PRESIDENT:{
		         if(Player_Zm[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[titulid],GetName(playerid),0,MAX_PLAYER_NAME);
					  Tit_Value[titulid] = Player_Zm[playerid];
					  ReWriteTitul(titulid);
				 }
		    }
			case TIT_RAMBO:{
		         if(Player_KillZombie[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[titulid],GetName(playerid),0,MAX_PLAYER_NAME);
					  Tit_Value[titulid] = Player_KillZombie[playerid];
					  ReWriteTitul(titulid);
				 }
		    }
			case TIT_KILLER:{
                 if(Player_KillHuman[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[titulid],GetName(playerid),0,MAX_PLAYER_NAME);
					  Tit_Value[titulid] = Player_KillHuman[playerid];
					  ReWriteTitul(titulid);
				 }
		    }
			case TIT_PROSVET:{
                 if(Player_HourInGame[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[titulid],GetName(playerid),0,MAX_PLAYER_NAME);
					  Tit_Value[titulid] = Player_HourInGame[playerid];
					  ReWriteTitul(titulid);
				 }
			}
			case TIT_FRIENDLY:{
		 	     if(Player_Invites[playerid] > Tit_Value[titulid]){
					  strmid(Tit_Name[titulid],GetName(playerid),0,MAX_PLAYER_NAME);
					  Tit_Value[titulid] = Player_Invites[playerid];
					  ReWriteTitul(titulid);
				 }
			}
	   }
}

//������� ������ � ������� ��������� ��� ��������
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

//�������� ����������� exp � needed-exp - �������� ������
/*
stock FixLevel(playerid)
{
	  new exp = Player_Respects[playerid];
	  new neededexp = Player_Level[playerid]*2;
	  if(exp > neededexp)
	  {
			 SendClientMessage(playerid,-1,""COL_YELLOW"�� ������� �� ����� �������!");
			 Player_Respects[playerid] = 0;
			 Player_Level[playerid]++;
	  }
	  SetPlayerScore(playerid,Player_Level[playerid]);
}
*/
//������� ������ � �������
stock OpenLogin(playerid,title[]="�����������")
{
	  new str[512];
	  format(str,sizeof(str),"{FFFFFF}__________________________________________________\n\n������������ ��� �� KulleR.su | Zombie\n\n          ���� � �������: "COL_EASY"%s{FFFFFF}\n          ������� ������:\n__________________________________________________",GetName(playerid));
	  ShowPlayerDialog(playerid,LOGIN_DIALOG,DIALOG_STYLE_PASSWORD,title,str,"����","�����");
	  return 1;
}
//������� ������ � ������������
stock OpenRegister(playerid,title[]="�����������")
{
	  new str[512];
	  format(str,sizeof(str),"{FFFFFF}__________________________________________________\n\n������������ ��� �� Saints Row\n\n          ����������� ��������: "COL_EASY"%s{FFFFFF}\n          ���������� ������:\n          � ������ ��������� ������������ �������:\n          A-z, 0-9\n          ������ ������ �� %d �� %d ��������\n__________________________________________________",GetName(playerid),MIN_PASS_LEGHT,MAX_PASS_LEGHT);
	  //format(str,sizeof(str),""COL_WHITE"����� ���������� �� ������ "COL_RED"Saints Row\n"COL_WHITE"���������� ������ � ��������\n� ������ ��������� ������������ ������� A-z, 0-9\n������ ������ �� %d �� %d ��������",MIN_PASS_LEGHT,MAX_PASS_LEGHT);
	  ShowPlayerDialog(playerid,REGISTER_DIALOG,DIALOG_STYLE_PASSWORD,title,str,"����","�����");
	  return 1;
}
//�������� �������
stock SaveAccount(playerid)
{
	  if(!isCreatedAccount[playerid])return 1;
	  //������ �������, ��������� �������� ��������, �� ��������� ���������� ������������ ����������
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
	  ini_setString(IF, "friendname", Player_FriendName[playerid]);
	  //ini_setInteger(IF,"respects",Player_Respects[playerid]);
	  ini_setInteger(IF,"rub",Player_Rub[playerid]);
	  ini_setInteger(IF,"warns", Player_Warns[playerid]);
	  ini_setInteger(IF,"zm",Player_Zm[playerid]);
	  ini_setString(IF, "regip", Player_RegIP[playerid]);
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


//�������� ����������� ����� � ����
stock FixHours(playerid)
{
	  if(Player_SecInGame[playerid] < 6000)return 1;
      Player_HourInGame[playerid] ++;
      FixTitul(playerid,TIT_PROSVET);
      Player_SecInGame[playerid] = 0;
      
      if( Player_HourInGame[playerid] >= FRIENDINVITE_LVL_FOR_PRICE)
      {
            if( strlen(Player_FriendName[playerid]) > 0)
            {
                GivePrizeForFriend(Player_FriendName[playerid]);
                Player_FriendName[playerid][0] = 0x0;
            }
      }
      
      SaveAccount(playerid);
      return 1;
}

//������� �������
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
	  ini_getString(IF, "friendname", Player_FriendName[playerid]);
	  //ini_getInteger(IF,"respects",Player_Respects[playerid]);
	  ini_getInteger(IF,"rub",Player_Rub[playerid]);
	  ini_getInteger(IF,"zm",Player_Zm[playerid]);
	  ini_getInteger(IF,"warns", Player_Warns[playerid]);
	  ini_getInteger(IF,"invites",Player_Invites[playerid]);
	  ini_getInteger(IF,"houringame",Player_HourInGame[playerid]);
	  ini_getInteger(IF,"secingame",Player_SecInGame[playerid]);
	  ini_getInteger(IF,"vip",Player_IsVip[playerid]);
	  ini_getString(IF,"mail",Player_Email[playerid]);
	  ini_getString(IF, "regip", Player_RegIP[playerid]);
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


//������� � ����������� ������
   /*����*/
enum rang_picture{
    /*rang_name[64],*/
    rang_price,//����
	rang_health,//�����
	rang_zmforkill, // ������� ������ �� ��������
	rang_skin,//����
    rang_gun,//����� 1
    rang_ammo,//������� 1
    rang_gun2,//�� 2
    rang_ammo2,//�� 2
    rang_gun3,//�� 3
    rang_ammo3,//�� 3
    rang_gun4,//�� 4 -� �������� - ��� �����������
    rang_ammo4,//�� 4 -� �������� - ��� �����������
    rang_special,//����������� ������ ��� ������ �������
	rang_special2,//��� ���. �������
	rang_special3//� ��� ������� ��� ������
}
static stock human_class_shturmovik[][rang_picture] ={//special = ������ �� ����, special2 = ����� ������
    { /*"�������",*/0,150,10/*rang_zmforkill*/,284,23,100,29,180,3,1,0,0,30,60},
    { /*"���������",*/1000,175,15/*rang_zmforkill*/,282,23,150,29,210,3,1,0,0,20,60},
    { /*"�����",*/1500,200,20/*rang_zmforkill*/,288,23,200,29,240,3,1,0,0,10,60},
    { /*"������� �����",*/2000,225,25/*rang_zmforkill*/,286,23,270,29,210,3,1,0,0,5,60},
    { /*"������� �������",*/3000,250,30/*rang_zmforkill*/,287,23,300,29,300,8,1,0,0,BOMB_DETONATOR,60}
};
static stock human_class_medik[][rang_picture] ={//special = ��������������� ��, special2 = ����� ��� �����������,special3 = ����������� �������� ���������
    { /*"������",*/0,150,10/*rang_zmforkill*/,274,29,180,23,100,4,1,0,0,20,10,10},
    { /*"������� ���������",*/1000,175,15/*rang_zmforkill*/,70,29,210,23,150,4,1,0,0,40,10,10},
    { /*"�������� ����������� ����",*/1500,200,20/*rang_zmforkill*/,70,29,240,23,180,4,1,0,0,60,10,10},
    { /*"������ ����������� ����",*/2000,225,25/*rang_zmforkill*/,70,29,270,23,210,4,1,0,0,80,10,10},
    { /*"��������",*/3000,250,30/*rang_zmforkill*/,275,29,300,23,300,4,1,0,0,100,10,10}
};

static stock human_class_sniper[][rang_picture] ={//special2 = ����� �����������, special1 = ����� ��������
    { /*"������",*/0,150,10/*rang_zmforkill*/,165,33,50,23,100,4,1,0,0,20,90},//�������� � ����
    { /*"������",*/1000,175,15/*rang_zmforkill*/,128,33,75,23,150,4,1,0,0,30,80},
    { /*"���������",*/1500,200,20/*rang_zmforkill*/,128,33,100,23,200,4,1,0,0,40,70},
    { /*"��������",*/2000,225,25/*rang_zmforkill*/,128,34,50,23,250,4,1,0,0,50,60},
    { /*"�������-�����",*/3000,250,30/*rang_zmforkill*/,123,34,100,23,300,4,1,0,0,60,0}//����� ��������/����� �����������
};
static stock human_class_defender[][rang_picture] ={//special - ����� ��������, special2 - ����� ������������
    { /*"���������",*/0,200,10/*rang_zmforkill*/,30,25,50,23,100,9,1,0,0,5/*����������*/,60},
    { /*"��������",*/1000,225,15/*rang_zmforkill*/,29,25,75,23,150,9,1,0,0,6/*����������*/,60},
    { /*"�������",*/1500,250,20/*rang_zmforkill*/,47,25,100,23,200,9,1,0,0,7/*����������*/,60},
    { /*"�����������",*/2000,275,25/*rang_zmforkill*/,48,25,150,23,250,9,1,0,0,8/*����������*/,60},
    { /*"��������������",*/3000,300,30/*rang_zmforkill*/,46,25,200,23,300,9,1,0,0,10/*����������*/,60}
};
static stock human_class_creater[][rang_picture] ={//special - ���-�� ��������
    { /*"���������",*/0,150,10/*rang_zmforkill*/,16,29,180,23,100,6,1,0,0,1},
    { /*"������",*/1000,175,15/*rang_zmforkill*/,16,29,210,23,150,6,1,0,0,2},
    { /*"������",*/1500,200,20/*rang_zmforkill*/,16,29,240,23,200,6,1,0,0,2},
    { /*"��������",*/2000,225,25/*rang_zmforkill*/,16,29,270,23,250,6,1,0,0,3},
    { /*"����������",*/3000,250,30/*rang_zmforkill*/,33,29,300,23,300,6,1,37,100,3}
};
   /*�����*/
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
static stock zombie_class_vedma[][zombie_rang_picture] ={//special - ������� ���������, special2 - ����� ������
    { DAMAGE_LEVEL_1,200,20/*zmforkill*/,75,9,1,ONE_HP,60*3},
    { DAMAGE_LEVEL_1,225,25/*zmforkill*/,75,9,1,ONE_HP,(60*2)+30},
    { DAMAGE_LEVEL_1,250,30/*zmforkill*/,75,9,1,TWO_HP,60*2},
    { DAMAGE_LEVEL_1,275,35/*zmforkill*/,75,9,1,TWO_HP,60+30},
    { DAMAGE_LEVEL_1,300,40/*zmforkill*/,75,9,1,THREE_HP,60}
};
static stock zombie_class_bumer[][zombie_rang_picture] ={//special - ������� ���������, special2 - ����� ������
    { DAMAGE_LEVEL_1,200,20/*zmforkill*/,79,5,1,ONE_HP,60},
    { DAMAGE_LEVEL_1,250,25/*zmforkill*/,79,5,1,ONE_HP,50},
    { DAMAGE_LEVEL_1,300,30/*zmforkill*/,79,5,1,TWO_HP,40},
    { DAMAGE_LEVEL_1,350,35/*zmforkill*/,79,5,1,TWO_HP,30},
    { DAMAGE_LEVEL_1,400,40/*zmforkill*/,79,5,1,THREE_HP,20}
};

//������� ��� ����� � ����� � �������
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

new bool: ExplodeBlockersFull_Cells[EXPLODE_BLOCK_FREE_CELLS]; // ��������� ������

//�������� �����
stock BangBomb(Bombid)
{
	//CreateExplosion(Bomb_X[Bombid],Bomb_Y[Bombid],Bomb_Z[Bombid],6,50.0);
	new Float: P[2];
	new Float:Ugol = 0.0;
	
	// beta humans gm ~~~~~~~~~~~~~~~~
	/*
	new GmPlayer[MAX_PLAYERS];
	new OLDHP_SPECIAL[MAX_PLAYERS];
	new GmVsego = 0;
	*/
	new z = 0; // �� ������ ������
	new bool: z_finded = false;
	
	for( z = 0; z < EXPLODE_BLOCK_FREE_CELLS; z++ ) // ����� ������ ������
	{
	    if( ExplodeBlockersFull_Cells[z] == false )
	    {
	        z_finded = true;
	        ExplodeBlockersFull_Cells[z] = true;
	        break;
	    }
	}

	if( z_finded )
	{
		for(new i, s_b = MaxID; i <= s_b; i ++)
	    {
		    if(Player_CurrentTeam[i] != HUMAN) continue;
		    if(!IsPlayerInRangeOfPoint(i,BOMB_BANG_RAD,Bomb_X[Bombid],Bomb_Y[Bombid],Bomb_Z[Bombid]))continue;

			AddCellToExplodeBlockers(i,(EXPLODE_BLOCK_CELLS_SIZE - EXPLODE_BLOCK_FREE_CELLS) + z);
			/*
			OLDHP_SPECIAL[i] = Player_RHealth[i];//
		    SetPlayerHealthEx(i,50000);//
		    GmPlayer[GmVsego] = i;//
		    GmVsego ++;//
		    */
	    }
    }
	// ~~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~
	
	for(new i; i < 4; i++)
	{
               GetXYInFrontOfPoint(Bomb_X[Bombid], Bomb_Y[Bombid], P[0], P[1], Ugol, RAMPAGE_TANG_BANG_DIST);
               CreateExplosion(P[0], P[1],Bomb_Z[Bombid],RAMPAGE_TANG_BANG_TYPE,3.0);
               Ugol += 90.0;
	}
	
	// beta humans return hp
	if( z_finded )
	{
	    /*
	    if( GmVsego != 0)//
	    {
			   for(new i; i < GmVsego; i ++)//
			   {
			            SetPlayerHealthEx(GmPlayer[i],OLDHP_SPECIAL[GmPlayer[i]]);//
			   }//
	    }//
	    */
	    SetTimerEx("RemoveExplodeProtectWithBomb", 500, 0, "i", z);
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

// ������ ���� ���������� � �����
forward RemoveExplodeProtectWithBomb(b_cellid);
public RemoveExplodeProtectWithBomb(b_cellid)
{
    UnBlockExplodeDamageForOther(b_cellid + (EXPLODE_BLOCK_CELLS_SIZE - EXPLODE_BLOCK_FREE_CELLS));
    ExplodeBlockersFull_Cells[b_cellid] = false;
	return 1;
}

stock GetXYInFrontOfPoint(Float:x, Float:y, &Float:x2, &Float:y2, Float:A, Float:distance)
{
    x2 = x + (distance * floatsin(-A, degrees));
    y2 = y + (distance * floatcos(-A, degrees));
}

//���������� �����
stock SetBomb(playerid)
{
    ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.1,0,1,1,1000,1);
	new Float:P[4];
	GetPlayerPos(playerid,P[0],P[1],P[2]);
	GetPlayerFacingAngle(playerid,P[3]);
	GetXYInFrontOfPoint(P[0], P[1], Bomb_X[Bombs_Counter], Bomb_Y[Bombs_Counter], P[3], 1.3);
	Bomb_Z[Bombs_Counter] = P[2]-0.9;//���� ������ �����
	Bomb_Object[Bombs_Counter] = CreateObject(1654,Bomb_X[Bombs_Counter],Bomb_Y[Bombs_Counter],Bomb_Z[Bombs_Counter],270.0,90.0,0);
	new rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
	Bomb_Time[Bombs_Counter] = human_class_shturmovik[rangid][rang_special];
	Player_MyBombId[playerid] = Bombs_Counter;
	Bombs_Counter++;
	Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] = human_class_shturmovik[rangid][rang_special2];
	SaveAccount(playerid);
	
	GameTextForPlayer(playerid,"~r~BOMB INSTALLED",3000,5);
	//�� ��������� ����� ���������� ��� ����� �������� ����� �������� N
	if(rangid == 4)SendClientMessage(playerid,-1,""COL_RED"������� ������ N ����� �������� �����");
	else
	{
		  new str[80];
		  format(str,sizeof(str),""COL_RED"����� ������������� ������������ ����� %d ������(�)",human_class_shturmovik[rangid][rang_special]);
		  SendClientMessage(playerid,-1,str);
	}
}

//������ ��������� � �����: �����
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
//������ ��������� � �����: ������
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
			   //��� ������ ��� �����
			   GiveShopGuns(playerid);
		  }
	 }
	 return 1;
}
//������ ���� �����
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
//������ ����.�� �����
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
//��������� ����� �����
stock UpgradeZombieRang(playerid,newrang){
     //if(Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] >= 4)return 1;
     Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] = newrang;
     GameTextForPlayer(playerid,"~g~New rank!",3000,5);
     new str[128];
     format(str,sizeof(str),""COL_EASY"����� ����! ������� ����� � ��������� \"%s\" ������� ������� �� %d",GetProfName(ZOMBIE,Player_ZombieProfession[playerid]),newrang);
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
//��������� �������� �����
stock UpgradeHumanRang(playerid,newrang){
      //if(Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] >= 4)return 1;
      Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] = newrang;
      GameTextForPlayer(playerid,"~g~New rank!",3000,5);
      new str[128];
      format(str,sizeof(str),""COL_EASY"����� ����! �� ���� �������� �� ������ %s � ����� ���������",GetRangName(HUMAN,Player_HumanProfession[playerid],newrang),newrang);
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
//����� ���������
stock SwitchProfession(playerid,teamid,profid){
	  switch(teamid){
		   case HUMAN:{
                Player_HumanProfession[playerid] = profid;
                ReturnDefenderOldHP(playerid);
                FixHumanRang(playerid);
                Player_H_HaveProfession[playerid][profid] = true;
                SaveAccount(playerid);
                if(S[playerid] != 2)return 1;
                if(Player_CurrentTeam[playerid] == HUMAN){
                      SetPlayerHealthEx(playerid,GetMaxRangHealth(HUMAN,Player_HumanProfession[playerid],Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]])+Player_H_DopHealth[playerid][Player_HumanProfession[playerid]]);
                      GiveClassTeamSkin(playerid,HUMAN);
                      if(!Game_Started)return 1;
                      GiveClassTeamGun(playerid,HUMAN);
			          
                }
		   }
		   case ZOMBIE:{

                Player_ZombieProfession[playerid] = profid;
                Player_Z_HaveProfession[playerid][profid] = true;
                SaveAccount(playerid);
                if(!Game_Started)return 1;
                if(S[playerid] != 2)return 1;
                if(Player_CurrentTeam[playerid] == ZOMBIE){
                     SetPlayerHealthEx(playerid,GetMaxRangHealth(ZOMBIE,Player_ZombieProfession[playerid],Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]])+Player_Z_DopHealth[playerid][Player_ZombieProfession[playerid]]);
                     GiveClassTeamSkin(playerid,ZOMBIE);
                     GiveClassTeamGun(playerid,ZOMBIE);
			         
			    }
		   }
		   default: return 1;
      }
	  return 1;
}

//�������� �������� �����
stock FixHumanRang(playerid){
     new neededexp = NEED_EXP_UMNOZHITEL*(Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]+1);
	 new exp = Player_HumanRangSkill[playerid][Player_HumanProfession[playerid]];
	 if(exp >= neededexp && Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] < 4)UpgradeHumanRang(playerid,Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] + 1);
	 return 1;
}
//�������� ����������
stock FixZombieRang(playerid){
	 new neededexp = NEED_EXP_UMNOZHITEL*(Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]+1);
	 new exp = Player_ZombieRangSkill[playerid][Player_ZombieProfession[playerid]];
	 if(exp >= neededexp && Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] < 4)UpgradeZombieRang(playerid,Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] + 1);
	 return 1;
}

//������� ��� ����� ���� ���������� �� ���� ���� � �.� �� ������ �������
stock DestroyObjects(){
	   if(Server_Objects == 0)return 1;
	   for(new i; i <  Server_Objects; i++){
	         DestroyObject(Object[i]);
	         if(IsPlayerConnected(i))Object_idx[i] = 0;
	   }
	   Server_Objects = 0;
       return 1;
}
//��������� ������� ������
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

//����� ��������
stock KillInfection(playerid){
	if(Player_IL[playerid] == NONE)return 1;
	Player_IL[playerid] = NONE;
	TextDrawHideForPlayer(playerid,TD_InfectScreenBox);
	SetPlayerDrunkLevel(playerid,0);
	__InfectText__RemoveLabelText(playerid);
	return 1;
}

//�������� � �����
forward GoToHome(playerid);
public GoToHome(playerid)
{
    Player_InMarker[playerid] = true;
    if(Game_Started)survaivors++;
    DisablePlayerCheckpoint(playerid); // ������� �������� �������
    ResetPlayerWeapons(playerid);
    SetPlayerSpawnInArea(playerid,-1);// ��������� ������ �� �����

    if( Player_CurrentTeam[playerid] == ADMIN) GiveClassTeamSkin(playerid, ADMIN);
	else GiveClassTeamSkin(playerid,HUMAN);
    SetPlayerInterior(playerid,Home_Interior);
    AC_SetPlayerPos(playerid,Home_Pos[0],Home_Pos[1],Home_Pos[2]);
    SetPlayerFacingAngle(playerid,Home_Pos[3]);
    SetPlayerVirtualWorld(playerid,Home_VW);
    SetCameraBehindPlayer(playerid);
    KillInfection(playerid);
    ShowPlayer(playerid);
    FixInviseblePlayers(playerid);
    SetPlayerHealthEx(playerid,GetMaxRangHealth(HUMAN,Player_HumanProfession[playerid],Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]])+Player_H_DopHealth[playerid][Player_HumanProfession[playerid]]);
    
    FixPlayerSpetates(playerid); // ���� ���������
	return 1;
}
//�������� �� �����
forward GoToArena(playerid,arenaid);
public GoToArena(playerid,arenaid)
{
    ShowPlayer(playerid); // �������� ������
    if(Player_CurrentTeam[playerid] != ADMIN)
    {
       //���� ����� �� �������� � ����� �� �� ������ ��������������, �� ������� ���������
       if(!Game_Started )Player_CurrentTeam[playerid] = HUMAN;
       //���� ���� ��������, �� ��������� ��� ��� � ����� �� �� ������ ��������������, �� ������� ���������
       if((Game_Started && Infection_Time > 0)) Player_CurrentTeam[playerid] = HUMAN;
       //���� ���� ��������, ��������� ����, ����� �� � ������� � �� �� ������ ��������������, �� ������� �����
       if(((Game_Started && Infection_Time == 0) && !Player_InMarker[playerid]))Player_CurrentTeam[playerid] = ZOMBIE;
	}
	SetPlayerSpawnInArea(playerid,arenaid); // ��������� ������
	switch (Player_CurrentTeam[playerid]){
		 case ZOMBIE:{
		 	SetZombie(playerid);
		 }
		 case HUMAN:{
		         SetHuman(playerid);
                 if(Player_InMarker[playerid] || !Game_Started){	//	���� ����� � ������� ��� ���� �� ������
						//	�������� � ������e
						GoToHome(playerid);
						return 1;
                 }
		 }
		 case ADMIN:
		 {
		         HideAdmin(playerid); // ������ ������
		         SetAdmin(playerid);  // ���� ���������� ������
		         if(Player_InMarker[playerid] || !Game_Started){	//	���� ����� � ������� ��� ���� �� ������
						  //	�������� � ������e
						  GoToHome(playerid);
						  return 1;
                 }
         }
	}
	if( arenaid == -1) return GoToHome(playerid);
	// ~~~~~~~~~~~~ �������� � ������ �� ����� ~~~~~~~~~~~~
	SetPlayerInterior(playerid,MapInterior[arenaid]);
	new rand_spawn = random(MapSpawnsLoaded[arenaid]); // ��������������� �����
	GoToSpawnInArena(playerid, arenaid, rand_spawn); // ��������� �� ���� ��������� �����
	SetPlayerVirtualWorld(playerid,0);
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	// ~~~~~ ��������� ������ �� ����� �� ������ ~~~~~~
	SetCameraBehindPlayer(playerid);
	// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	// ~~~~~~ ����-������ ��� �������� ~~~~~~
    SetPVarInt(playerid,"ProtectTime",SPAWN_PROTECT);
    TogglePlayerControllable(playerid,0);
    // ~~~~~~~~~~~~~~~~~~~~~
    
    // ~~~~~~~~~ ���� ����������� �� ������� ~~~~~~~~~~~
    FixPlayerSpetates(playerid); // ���� ���������
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	return 1;
}

stock NextSpectate(playerid)
{
    for(new i = gSpectateID[playerid]+1, s_b = MaxID; i <= s_b; i ++)
    {
        //if( i == playerid) continue;
        if( S[i] == 0 ) continue;
        if( gSpectateID[i] != -1) continue;
        
        StartSpectate(playerid, i);
        return true;
    }
    for(new i = 0; i < gSpectateID[playerid]; i ++)
    {
    	//if( i == playerid) continue;
        if( S[i] == 0 ) continue;
        if( gSpectateID[i] != -1) continue;
        StartSpectate(playerid, i);
        return true;
    }
	return false;
}

// playerid ������ �� specplayerid
stock StartSpectate(playerid, specplayerid)
{
    TogglePlayerSpectating(playerid, 1);
    PlayerSpectatePlayer(playerid, specplayerid);
    SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
    SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(specplayerid));
    gSpectateID[playerid] = specplayerid;
	return 1;
}

stock CancelSpectate(playerid)
{
    TogglePlayerSpectating(playerid, 0);
    SetTimerEx("DisableGSpectate", 1000, 0, "i", playerid);
    SendClientMessage(playerid,COLOR_YELLOW,"������ ���������");
	return 1;
}

// ���� ��������� �� �������
stock FixPlayerSpetates(playerid)
{
    for(new i, s_b = MaxID; i <= s_b; i ++)
    {
        if( gSpectateID[i] != playerid) continue;
        StartSpectate(i, playerid);
        //SetPlayerInterior(i,GetPlayerInterior(playerid)),SetPlayerVirtualWorld(i,GetPlayerVirtualWorld(playerid));
        //PlayerSpectatePlayer(i, playerid);
    }
	return 1;
}

stock GoToSpawnInArena(playerid, arenaid, spawnid) // �������� � ������ �� �����
{
	if( spawnid >= MapSpawnsLoaded[arenaid] ) return 2;
	AC_SetPlayerPos(playerid,MapSpawnPos[arenaid][spawnid][0],MapSpawnPos[arenaid][spawnid][1],MapSpawnPos[arenaid][spawnid][2]);
	SetPlayerFacingAngle(playerid,MapSpawnPos[arenaid][spawnid][3]);
	return 1;
}

// ���������� ����� ������ �� �����
// -1 = ��������� ������ �� �������
stock SetPlayerSpawnInArea(playerid,arenaid)
{//ACInfo[playerid][RealSkinID]
	if( arenaid == -1)
	{
	    SetSpawnInfo(playerid,0,1,Home_Pos[0],Home_Pos[1],Home_Pos[2],Home_Pos[3],0,0,0,0,0,0);
	    return 1;
	}
    SetSpawnInfo(playerid,0,1,MapSpawnPos[arenaid][0][0],MapSpawnPos[arenaid][0][1],MapSpawnPos[arenaid][0][2],MapSpawnPos[arenaid][0][3],0,0,0,0,0,0);// ��������� ������
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
	 ReturnDefenderOldHP(playerid);//���� ����� ��� � ������ ���������� ���������
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
     ReturnDefenderOldHP(playerid);//���� ����� ��� � ������ ���������� ���������
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
    //������� ������ �����
    new NormalPlayer[MAX_PLAYERS] = -1;//��� ����� �������������� "����������" �������
    new NormalPlayersCounter = 0;//������� ����� ���������� �������
	new ZombiInFutute = -1;//���������� ��� �� �������� �����
    for(new i, s_b = MaxID; i <= s_b; i++)
    {
			if(!IsPlayerConnected(i) || S[i] == 0)continue;//������ ��� �� �����
			if(Player_CurrentTeam[i] != HUMAN || !PlayerNoAFK[i] )continue;//������ � ������ ����
            NormalPlayer[NormalPlayersCounter] = i;//������� �� ����������� ������ � ������-������
			NormalPlayersCounter ++;//������� ��� �������
    }
    ZombiInFutute = random(NormalPlayersCounter);//������� ������� ������� �������� �����
    SetZombie(NormalPlayer[ZombiInFutute]);//������� �������� �����
    GameTextForPlayer(NormalPlayer[ZombiInFutute],"~r~Infected",3000,4);//�������� ��� �� ��� ������
    //����� ��������
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
	       if(!IsPlayerConnected(i) || S[i] == 0)continue;//������ ����� �� �����
	       if( !PlayerNoAFK[i] ) continue; // ���� �� �����
	       if((Player_CurrentTeam[i] == ADMIN))continue;//������ �� �����

		   if(Player_CurrentTeam[i] == HUMAN) Humans++;
	       else Zombies ++;
	 }
	 result = Humans + Zombies;
	 if(Game_Started && CountForNextArena == 0)//���� ���� ������ + ��� ������� �� ���� �����, ��
	 {
			if(result < 2)return EndArena(END_REASON_LILTE_PLAYER);//���� �������
			else if(Humans == 0)return EndArena(END_REASON_ZOMBIE_WIN);//����� ��������
			if(Zombies == 0 && (Game_Started == true && Infection_Time == 0)){//����� ���������� ��������
				 //������ ��������� ����������!
				 if(!MarkerActiv){
				     SendClientMessageToAll(COLOR_RED,"��������� ����������!");
				     RandomInfected();
				 }
			}
			/*
			if(!MarkerActiv || Infection_Time == 0)return 1;
			if(Zombies == 0){//����� ���������� ��������
				     //������ ��������� ����������!
				     SendClientMessageToAll(COLOR_RED,"��������� ����������!");
				     RandomInfected();
				     return 1;
			}
			*/
	        //���� ����� ������ ���������� �������� �� ���� ����� �� ������ ���������
	        if( Zombies < floatround((Humans / 100.0)*INFECTED_PROCENT)  && Infection_Time == 0)RandomInfected();
	 }
	 if(!Game_Started && CountForNextArena == 0){//���� � ������ �������� �������
			if(result > 1)StartArena(NextArenaId);//�������� �� ���������� �
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
	
	 // ������� �����
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

	 format(str,sizeof(str),"����� \"%s\" ����������!\n��������� �������� ����� %d ������",MapName[arenaid],INFECTION_TIME);
	 //WriteLog(LOG_FILE,str);//CHAT_LOG,REG_LOG,LOG_FILE,KILL_LOG_FILE
	 SendClientMessageToAll(COLOR_GREEN,str);
	 for(new i, s_b = MaxID; i <= s_b; i++)
	 {
	 	       if(!IsPlayerConnected(i))continue;
	           if(S[i] == 0)continue;
	           Player_InMarker[i] = false;
	           //AfkStartTime[i] = 0;
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

//������ ��������� � ������ ����-�����
forward HideInfoWin();
public HideInfoWin()
{
     TextDrawHideForAll(TD_HumansWin);
	 TextDrawHideForAll(TD_ZombiesWin);
}

//������� ���������
stock SurvivorEffect(playerid)
{
	new str[100];
    Player_Zm[playerid] += ZM_FOR_SUVRIVOR;
    
    format(str,sizeof(str),"%s ������� %d ZM �� ���������",GetName(playerid),ZM_FOR_SUVRIVOR);
    WriteLog(MONEYLOG,str);
    
    format(str,sizeof(str),"�� ������ ��������. ��� ���� ���� ������� � ������� "COL_VALUE"%d ZM",ZM_FOR_SUVRIVOR);
    SendClientMessage(playerid,COLOR_GREEN,str);
    GameTextForPlayer(playerid,"~y~SURVIVOR",3000,1);
    SaveAccount(playerid);
    PlayerPlaySound(playerid,RandomValue(36202,36205),0,0,0);
    return 1;
}

//�������� ���������� - �����
//if(!Game_Started && CountForNextArena > 0) ��� ������ �������
forward EndArena(reason);
public EndArena(reason){
	 new str[128];
	 switch(reason){
		 case END_REASON_LILTE_PLAYER:{
			   SendClientMessageToAll(COLOR_GRAY,""COL_ORANGE"���� ��� ����������. "COL_VALUE"�������: �� ������� ������� ��� �����������");
			   SendClientMessageToAll(COLOR_YELLOW,"���� �� �������� ���� �� ��������� ������� "COL_VALUE"2 ������");
			   GameTextForAll("~b~The match was stopped",3000,1);
			   //WriteLog(LOG_FILE,"���� ��� ����������. �������: �� ������� ������� ��� �����������");
		 }
		 case END_REASON_ADMIN_STOP:{
			   SendClientMessageToAll(COLOR_GRAY,""COL_ORANGE"���� ��� ���������� ���������������");
			   format(str,sizeof(str),"��������� ����� �������� ����� "COL_VALUE"%d ������",COUNT_FOR_NEXTARENA);
			   SendClientMessageToAll(COLOR_GREEN,str);
			   CountForNextArena = COUNT_FOR_NEXTARENA;
			   GameTextForAll("~w~The match was stopped an admin",3000,1);
			   //WriteLog(LOG_FILE,"���� ��� ���������� ���������������");
		 }
		 case END_REASON_ZOMBIE_WIN:{
			   SendClientMessageToAll(COLOR_YELLOW,""COL_ORANGE"����� ��������!");
			   format(str,sizeof(str),"��������� ����� �������� ����� "COL_VALUE"%d ������",COUNT_FOR_NEXTARENA);
			   SendClientMessageToAll(COLOR_GREEN,str);
			   CountForNextArena = COUNT_FOR_NEXTARENA;
			   //GameTextForAll("~p~ZOMBIE WIN",3000,1);
			   TextDrawShowForAll(TD_ZombiesWin);
			   SetTimer("HideInfoWin",INFO_WIN_SHOW_TIME,0);
			   //WriteLog(LOG_FILE,"����� ��������!");
		 }
		 case END_REASON_TIME_LEFT:{
			   if(MapHaveMarker[CurrentMap]){//���� ����� ����� ������
			       for(new i, s_b = MaxID; i <= s_b; i++){
                        if(!IsPlayerConnected(i) || S[i] == 0)continue;
                        if(!Player_InMarker[i])continue;
					    SurvivorEffect(i);
			       }
			       if(survaivors == 0){
                        SendClientMessageToAll(COLOR_YELLOW,"����� �� ����� �� ���� ��������! "COL_ORANGE"����� ��������");
                        format(str,sizeof(str),"��������� ����� �������� ����� "COL_VALUE"%d ������",COUNT_FOR_NEXTARENA);
			            SendClientMessageToAll(COLOR_GREEN,str);
			            //GameTextForAll("~p~ZOMBIE WIN",3000,1);
			            TextDrawShowForAll(TD_ZombiesWin);
			            SetTimer("HideInfoWin",INFO_WIN_SHOW_TIME,0);
                        //WriteLog(LOG_FILE,"����� �� ����� �� ���� ��������! ����� ��������");
			       }
				   else{
                        SendClientMessageToAll(COLOR_GREEN,"����� ����� ���� ���������. "COL_ORANGE"������ �����!");
				        format(str,sizeof(str),"��������� ����� �������� ����� "COL_VALUE"%d ������",COUNT_FOR_NEXTARENA);
			            SendClientMessageToAll(COLOR_GREEN,str);
			            //GameTextForAll("~y~HUMANS WIN",3000,1);
			            TextDrawShowForAll(TD_HumansWin);
			            SetTimer("HideInfoWin",INFO_WIN_SHOW_TIME,0);
				        //WriteLog(LOG_FILE,"����� ����� ���� ���������. ������ �����!");
				   }
			   }
			   else{
			       for(new i, s_b = MaxID; i <= s_b; i++){
                        if(!IsPlayerConnected(i) || S[i] == 0)continue;
                        if(Player_CurrentTeam[i] != HUMAN)continue;
					    SurvivorEffect(i);
			       }
				   SendClientMessageToAll(COLOR_GREEN,"����� ����� ���� ��������. "COL_ORANGE"������ �����!");
				   format(str,sizeof(str),"��������� ����� �������� ����� "COL_VALUE"%d ������",COUNT_FOR_NEXTARENA);
			       SendClientMessageToAll(COLOR_GREEN,str);
			       //GameTextForAll("~y~HUMANS WIN",3000,1);
			       TextDrawShowForAll(TD_HumansWin);
                   SetTimer("HideInfoWin",INFO_WIN_SHOW_TIME,0);
				   //WriteLog(LOG_FILE,"����� ����� ���� ��������. ������ �����!");
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
		   //AfkStartTime[i] = 0;
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

     // ��������� �����
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

// ��������� ����� ������ ������ �������
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
				  //new str[128];
				  //format(str, sizeof(str), "OnPlayerTakeDamage = playerid(%d), issuerid(%d), Float:amount(%.f), weaponid(%d)",playerid, issuerid, amount, weaponid);
				  //SendClientMessageToAll(-1,str);
				  
				  if(S[playerid] != 2) return 1;
				  if(Player_CurrentTeam[playerid] == ADMIN)return 1; // ����� ����������
				  if(issuerid == 65535)
				  {
						if( weaponid == 51)
						{
						    if( Player_BlockExplode[playerid] ) // ���� ���� �� ������� ������������
						    {
						        return 1; // � �������
						    }
						}
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
    if(Player_CurrentTeam[damagedid] == ADMIN)return 1; // ����� ����������
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
// ���������� �� ��� ������� � �� � ������� � ������
stock UpdateHealthOnHead(playerid)
{
     if(S[playerid] == 0)return 1; // ���� ����� ��� ����, �� ��������� ������ �� �����
	 new str[80],maxhp,rangid;
	 
	 // ~~~~~~~~~~~~~ �� ��� ������� ~~~~~~~~~~~~~
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
     if(Player_Invisible[playerid] != 0)SetPlayerChatBubble(playerid,"",-1,30.0,999999999);  // ���� ����� � ������ �����������
	 else // �� � ���� ���
	 {
		 // ��������� � ����������� �� ��������
	     if(Player_RHealth[playerid] > maxhp)
		 {
		 	format(str,sizeof(str),"{00CC00}����������");  // ���� ������������� HP
	     }
	     else // �� � ���� �� ����
	     {
		     if(Player_RHealth[playerid] <= maxhp)format(str,sizeof(str),"{00CC00}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp);// ���� 80 %
		     if(Player_RHealth[playerid] < floatround((maxhp/100.0)*80))format(str,sizeof(str),"{99FF00}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp);//79 .. 60 %
		     if(Player_RHealth[playerid] < floatround((maxhp/100.0)*60))format(str,sizeof(str),"{FFFF00}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp);//59 .. 40 %
		     if(Player_RHealth[playerid] < floatround((maxhp/100.0)*40))format(str,sizeof(str),"{FFCC00}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp);// 39 .. 20 %
		     if(Player_RHealth[playerid] < floatround((maxhp/100.0)*20))format(str,sizeof(str),"{FF6600}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp);// 19 .. 5 %
		     if(Player_RHealth[playerid] < floatround((maxhp/100.0)*5))format(str,sizeof(str),"{FF0000}%d{FFFFFF}/{00CC00}%d",Player_RHealth[playerid],maxhp); // 4 .. 1 %
		     if(Player_RHealth[playerid] < 1)format(str,sizeof(str),"{FF0000}̸���"); // �������
		 }
		 SetPlayerChatBubble(playerid,str,-1,30.0,999999999); // �������� ��� �������
	 }
	 // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	 
	 if( Player_RHealth[playerid] < 1) Player_RHealth[playerid] = 0;
	 // ~~~~~~~~~~~~~ ���������� �� � ������� ~~~~~~~~~~~~~
	 if(Player_RHealth[playerid] >= 10000)return PlayerTextDrawSetString(playerid,PTD_HpText[playerid],"~y~xxxx"); // ���� ����� ����� �� ������ 9999
	 else  // � ���� ���
	 {
	    switch(Player_CurrentTeam[playerid]){
	        case HUMAN:{  // ���� ����� �������
	            format(str,sizeof(str),"~g~%04d",Player_RHealth[playerid]); // ������ � �������
	        }
	        case ZOMBIE:{ // ���� ����� �����
                format(str,sizeof(str),"~p~%04d",Player_RHealth[playerid]);  // ������ � ���������
	        }
	    }
	    
	 }
	 PlayerTextDrawSetString(playerid,PTD_HpText[playerid],str); // ��������
	 // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	 return 1;
}

// ������� ��������� ������� � �������� ���������
stock TextDrawsStd()
{
	TextDrawSetString(TD_EVC_Counter,"EVC: 00:00");
	return 1;
}

// ������� ����������
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
	 if(tits == 0)titul_str = "�����������";
	 
	 if(Player_IsVip[playerid] != 0)str2 = "�������";
	 else str2 = "�����������";
	 format(str,sizeof(str),"Nickname - %s\n������� - %d\nZombieMoney - %d\n������� �������������� - %d\n����� � ���� - %d\nRUB - %d\n��������� (����) - %s(%d ����)\n��������� (�����) - %s(%d ����)",
	 GetName(playerid),Player_Age[playerid],Player_Zm[playerid],Player_AdminLevel[playerid],Player_HourInGame[playerid],Player_Rub[playerid],GetProfName(HUMAN,Player_HumanProfession[playerid]),Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]+1,GetProfName(ZOMBIE,Player_ZombieProfession[playerid]),Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]+1);

	 format(str,sizeof(str),"%s\n������� - %d\n������ ����������: %d\n�����(�) ������� - %s\n������� ������� - %s",
	 str,Player_Deaths[playerid],Player_Invites[playerid],titul_str,str2);
	 if(Player_IsVip[playerid] != 0)
	 {
		  if(Player_IsVip[playerid] != -1)
		  {
                format(titul_str,sizeof(titul_str),"\n������� ��������� - %s",date("%dd.%mm.%yyyy � %hh:%ii:%ss",Player_IsVip[playerid]-(UNIX_TIME_CORRECT)));
	            strcat(str,titul_str);
	      }
	      else strcat(str,"\n������� ���� ��������");
     }
	 if(showid != -1)ShowPlayerDialog(showid,dialogid,DIALOG_STYLE_MSGBOX,"���������� ���������",str,"�����","");
	 else ShowPlayerDialog(playerid,dialogid,DIALOG_STYLE_MSGBOX,"���������� ���������",str,"�����","");
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
#define TIME_AC_GUN_SCAN 2 // ��� � ������� ������ ��������� ������ � �������
public Central_Processor()
{
	new str2[128];
	if( AC_GUN_SCAN_TIME > 0 )
	{
	    AC_GUN_SCAN_TIME --;
	}
	
	CheckSessions(); // ���������
	//��������� �������� �������
	if(TimeToCheckBuyed > 0)
	{
         TimeToCheckBuyed --;
	}
	//�������� ����� � �����
	if(Game_Started){
         format(str2,sizeof(str2),"Humans: %d",Humans);
         TextDrawSetString(TD_Humans_Counter,str2);
         format(str2,sizeof(str2),"Zombies: %d",Zombies);
         TextDrawSetString(TD_Zombies_Counter,str2);
    }
    else{
         TextDrawSetString(TD_Humans_Counter,"Humans: X");
         TextDrawSetString(TD_Zombies_Counter,"Zombies: X");
    }
    // ~~~~~~~~~~~~~~~~
    // ���� ������� ���������� �������
	if(TimeToFixTituls > 0)
	{
          TimeToFixTituls --;
	}
    //����� ����� ���������� � ��������� ������
    if(!Game_Started && CountForNextArena > 0){
            CountForNextArena--;
            if(CountForNextArena == 0){
				 StartArena(NextArenaId);
            }
    }
    //����� �� ����� �����
    if(Game_Started && CountForEndArena > 0){
           format(str2,sizeof(str2),"EVC: %s",TimeConverter(CountForEndArena));
           TextDrawSetString(TD_EVC_Counter,str2);
           CountForEndArena--;
           if(CountForEndArena == 0){
				EndArena(END_REASON_TIME_LEFT);
           }
    }
    //����� �������� �������������
	if(time_to_send_automessage > 0)
	{
             time_to_send_automessage--;
             if(time_to_send_automessage == 0)SendAutoMessage();
	}
	//����� �����������
    if(VoteTime > 0)
	{
         VoteTime --;
         TextDrawSetString(_VoteTime_,TimeConverter(VoteTime));
         if(VoteTime == 0)
         {
             CancelVote();
         }
	}
	//�������� �������
	if(((Game_Started && CountForEndArena < 60) && !MarkerActiv) && MapHaveMarker[CurrentMap]){
		   CallRemoteFunction("OnVaultOpen", "");
           MarkerActiv = true;
           SendClientMessageToAll(COLOR_LIGHTBLUE,"��������! ���� � ������� ������ �� ���� ������!");
           for(new i, s_b = MaxID; i <= s_b; i++){
				  if(!IsPlayerConnected(i))continue;
				  SetPlayerCheckpoint(i,MapMarkerPos[CurrentMap][0],MapMarkerPos[CurrentMap][1],MapMarkerPos[CurrentMap][2],2.0);
           }

    }
    //������� ������� ���� ����
    for(new bomb; bomb < Bombs_Counter; bomb ++)
    {
			      if(Bomb_Time[bomb] == 0 || Bomb_Time[bomb]  == BOMB_DETONATOR)continue;
                  Bomb_Time[bomb] --;
                  if(Bomb_Time[bomb] == 0)
                  {
                        BangBomb(bomb);
                  }
			 
    }
    
    // ��������� ������ ���������
    if(Game_Started && Infection_Time > 0)
	{
           Infection_Time--;
           if(Infection_Time == 0)
		   {
			           //�������� ��������� ������ ��
		               ReCountPlayers();//������� ��������� ��� ������������ ��� � ������ ���������
		   }
    }
    
	//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	for(new playerid,str[64], z = MaxID; playerid <= z; playerid++){
		  if(!IsPlayerConnected(playerid))continue;
		  if( TP_HACK_WARNINGS[playerid] > 0 )
		  {
		        TP_HACK_WARNINGS[playerid] --;
	      }
		  //�������� ����� �� ������, ������ �� ������������
		  
		  //
		  format(str,sizeof(str), "Rub: %d", Player_Rub[playerid]);
		  PlayerTextDrawSetString(playerid,PTD_MoneyText[playerid],str);
		  //
		  
		  //
		  __ProfAndRank3D__UpdateInformer(playerid);
		  //
		  
		  // ����������� ���������
		  if( Player_ZombieInfectTime[playerid] > 0)
		  {
	 	  		Player_ZombieInfectTime[playerid] --;
		  }
		  
		  // �������� ����� � ����������� �� ����������: ���������
		  if( Player_SetPosProtectTime[playerid] > 0 )
		  {
          		Player_SetPosProtectTime[playerid] --;
		  }
		  // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		  
	      if(AC_SpawnProtect[playerid] > 0)
		  {
                    AC_SpawnProtect[playerid]--;
		  }
		  
		  if( TimeToHideTD_DropZmInformer[playerid] > 0 )
		  {
		            TimeToHideTD_DropZmInformer[playerid] --;
		            if( TimeToHideTD_DropZmInformer[playerid] == 0 )
		            {
		                HideTD_DropZmInformer(playerid);
		            }
		  }
		  /*
		  if(GetPVarInt(playerid, "PlayerInAFK") > 0)
		  {
		        if(isFall(playerid))
				{
				    SetPlayerHealthEx(playerid,0);
				    SendClientMessage(playerid, -1, "�� ���� ����� �� ���������������� ��� �������");
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
		  
		  // ���������� ��������� ������� ( ��������� �� ����� )
		  if(GetPVarInt(playerid,"ProtectTime") > 0)
		  {
	            SetPVarInt(playerid,"ProtectTime",GetPVarInt(playerid,"ProtectTime")-1);
	            if(GetPVarInt(playerid,"ProtectTime") == 0)
	            {
	                 TogglePlayerControllable(playerid,1);
                }
		  }
		  //��������� ������� ������
		  if(TimeToCheckBuyed == 0)FixPlayerBuyed(playerid);
		  //����� �������� ��������� �����, ������� ������� � ������ �� �����
		  //if(GetPVarInt(playerid,"Logged") != 0)TextDrawHideForPlayer(playerid,TD_LoadScreen);
		  //���� zm, ���������� �������
		  PlayerMoneyFix(playerid);
		  
		  
		  //���� ����������� � ���� ����� (�� ������� �� ������ ������, ������� ���� ������ � ����)
		  if(S[playerid] > 0)
		  {
                   Player_SecInGame[playerid]++;
                   FixHours(playerid);
                   UpdateInformer(playerid);
                   UpdateHealthOnHead(playerid);//�����
                   
				   // ������� ����
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
	                   		//OnAntiCheatUpdatePlayer(playerid, AC_TP_HACK_, -1); �� �������������
	                   		//OnAntiCheatUpdatePlayer(playerid, AC_FLY_HACK_, -1); ��� ���������� ����� �������������
	                   		OnAntiCheatUpdatePlayer(playerid, AC_FAKESKIN_HACK_, -1);
	                   		if( AC_GUN_SCAN_TIME == 0)
	                   		{
	                   			OnAntiCheatUpdatePlayer(playerid, AC_GUN_HACK_, -1);
	    					}
    					}
                   }
                   
                   if( gSpectateID[playerid] != -1)
				   {
				  		TextDrawHideForPlayer(playerid, TD_ZmText);
			  	   }
			  	   else
			  	   {
			  	    	TextDrawShowForPlayer(playerid, TD_ZmText);
			  	   }
		  }
		  //����� �� � ���������
		  if(Player_DefenderGmTime[playerid] > 0)
		  {
                Player_DefenderGmTime[playerid]--;
                if(Player_DefenderGmTime[playerid] == 0){Player_DefenderGmTime[playerid] = -1;ReturnDefenderOldHP(playerid);}
		  }
		  //��������� �������� �� ��� ����������� ����
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
		  //����������� ������ ����� � ������
		  if(GetPVarInt(playerid,"JumpReset") > 0)
		  {
                 SetPVarInt(playerid,"JumpReset",GetPVarInt(playerid,"JumpReset")-1);
		  }
		  //����-���������� � ����
		  if((IsPlayerInWater(playerid) && S[playerid] == 2) && gSpectateID[playerid] == -1 && AC_SpawnProtect[playerid] == 0)
		  {
		        if(!OnAntiCheatUpdatePlayer(playerid, AC_FLYHACK_, 0))// �������� ������ �� �������
		        {
   					SetPlayerHealthEx(playerid,0);
				}
				else
				{
				    SetPlayerHealthEx(playerid,0);
				}
	      }
		  //��� �������
		  if(GetPVarInt(playerid, "PlayerInAFK") == 0) SetPVarInt(playerid, "PlayerInAFK", -1);
          else if(GetPVarInt(playerid, "PlayerInAFK") == -1)
          {
                SetPVarInt(playerid, "PlayerInAFK", 1);
                new string[56];
                format(string, sizeof(string), "���: {FFFFFF}%s", ConvertSeconds(GetPVarInt(playerid, "PlayerInAFK")));
                SetPlayerChatBubble(playerid, string, 0xFFFF00AA, 20.0, 1200);
          }
          else if(GetPVarInt(playerid, "PlayerInAFK") > 0)
          {
                new string[56];
                SetPVarInt(playerid, "PlayerInAFK", GetPVarInt(playerid, "PlayerInAFK")+1);
                format(string, sizeof(string), "���: {FFFFFF}%s", ConvertSeconds(GetPVarInt(playerid, "PlayerInAFK")));
                SetPlayerChatBubble(playerid, string, 0xFFFF00AA, 20.0, 1200);
                
                AfkStartTime[playerid] ++;
				//if((Game_Started) && !Player_InMarker[playerid])
				//{
				    //AfkStartTime[playerid] ++;
        		if((AfkStartTime[playerid] >= MAX_AFK_TIME_IN_HUMANT) && PlayerNoAFK[playerid])
          		{
						OnPlayerAfkStart(playerid);
            	}
				//}
          }
          //����������� ������� ������ ������: ��������� �������
 	      if(Medik_ResetHealthTime[playerid] > 0 && S[playerid] > 0){
                  Medik_ResetHealthTime[playerid]--;
                  if(Medik_ResetHealthTime[playerid] == 0){
                          SendClientMessage(playerid,-1,""COL_EASY"���� ��������� ������� ������� ������������");
                          SaveAccount(playerid);
                  }
		  }
		  //����������� ���� �����-������� �� ���� ����������
		  for(new i; i < MAX_Z_CLASS; i++)
		  {
				 if(!Player_Z_HaveProfession[playerid][i])continue;
				 if(Player_ZombieResetSkillTime[playerid][i] > 0 && S[playerid] > 0)
				 {
                       Player_ZombieResetSkillTime[playerid][i]--;
                       if(Player_ZombieResetSkillTime[playerid][i] == 0){
							 format(str2,sizeof(str2),""COL_EASY"���� ����.����������� �� ��������� %s(�����) ������������",GetProfName(ZOMBIE,i));
						     SendClientMessage(playerid,-1,str2);
						     //SaveAccount(playerid);
                      }
	             }
				 
          }
          //����������� ���� ��������-������� �� ���� ����������
          for(new i; i < MAX_H_CLASS; i++)
		  {
				 if(!Player_H_HaveProfession[playerid][i])continue;
				 if(Player_HumanResetSkillTime[playerid][i] > 0 && S[playerid] > 0)
				 {
                       Player_HumanResetSkillTime[playerid][i]--;
                       if(Player_HumanResetSkillTime[playerid][i] == 0){
							 format(str2,sizeof(str2),""COL_EASY"���� ����.����������� �� ��������� %s(����) ������������",GetProfName(HUMAN,i));
						     SendClientMessage(playerid,-1,str2);
						     //SaveAccount(playerid);
                      }
	             }

          }
		  //��������� ����������� ��������
		  if(Player_Invisible[playerid] > 0 && S[playerid] > 0){
                  Player_Invisible[playerid]--;
                  if(Player_Invisible[playerid] == 0){
                          Player_Invisible[playerid] = -1;
						  SendClientMessage(playerid,-1,""COL_RULE"��� ����� �����");
						  ShowPlayer(playerid);
                  }
		  }
		  //������� ����
		  if(Player_MuteTime[playerid] > 0 && S[playerid] > 0) {
                  Player_MuteTime[playerid] --;
                  if(Player_MuteTime[playerid] == 0){
						  format(str2,sizeof(str2),"����� %s ����� ����� ������ � ���",GetName(playerid));
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
          //�������� ������
          if(Player_IL[playerid] > 0 && S[playerid] == 2){
			   TextDrawShowForPlayer(playerid,TD_InfectScreenBox);
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
    					
	//������������ ����� �������� �������
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

//#define MAP_MAX_SIZE
public OnGameModeInit(){
	SendRconCommand("hostname "HOSTNAME"");
    mail_init(MAIL_HOST, MAIL_LOGIN, MAIL_PASSWORD, "s.row.mail@yandex.ru", MAIL_SENDERNAME); // ���� ���������
	if( GetMaxPlayers() > MAX_PLAYERS)
	{
		  printf("������! ����������� �������������� %d �������",MAX_PLAYERS);
		  SendRconCommand("exit");
		  return 1;
	}
    LoadForbiddenWeapons (); // ������� ��������� �����
	SetGameModeText(GM_NAME);
	//�������� �����
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	//������� ���������
	GM = SetTimer("Central_Processor",CP_UPDATE_INTERVAL,1);
	//������� ����������� �����
	SetDefaulthHome();
	//��������� �� ����
	Game_Started = false;
	Infection_Time = 0;
	SetWorldTime(24);
    SetWeather(0);
	//������� ������
	LoadTituls();
	//UsePlayerPedAnims();
	//���� ���� �������
	TimeToCheckBuyed = CHECK_BUYED_TIME;
	
	// ������� ������� ����
	CreateLogoObjects();
	
	//������� ������� � �������
	CreateAvtomatsDialog();
	CreatePistolsDialog();
	CreateShotgunsDialog();
	CreateKarabinsDialog();
	//������� ����������
	DestroyTextDraws();
	
	CreateTextDraws();
	//���������� � �������� ���������!
	TextDrawsStd();
	//������� �����
	LoadArenas();
	//�������� ������ �� �����
	EnableStuntBonusForAll(0);
	//�������� ������ ������� � ����
	DisableInteriorEnterExits();
	//�������� ��������
	ClearDeathMessages();
	
	// ������� �������� ��������
	Create_TrainingEnd_List();
	Create_TrainingCmdsDialogs_List();
	Create_TrainingTerm_List();
	Create_TrainingStart_List();
	
	// ������� ������ � ���������
	CreateRulesDialog(0); // 1
	CreateRulesDialog(1); // 2
	
	// ������� ������ � ������ ����
	CreateAboutYourGameDialog();
	//������� ������ ��������� ��� �����������
	createChosenProf();
	//������� �������
	//CreateObjects();
	//������� ������ � �����
	CreateVipDialog();
	//������� ������ � �������
	CreateCapsDialog();
	TimeToFixTituls = FIX_ALL_TITUL_TIME;
	
	new str[70];
	format(str,sizeof(str), "%s developed by 2rage", GM_NAME);
	TextDrawSetString(CreatedBy, str);
	//printf("������ - %s",date("%dd.%mm.%yyyy � %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT-(3600*3))));
	//format(titul_str,sizeof(titul_str),"\n������� ��������� - %s",date("%dd.%mm.%yyyy � %hh:%ii:%ss",Player_IsVip[playerid]-(UNIX_TIME_CORRECT)));
	SetTimer("SendAzimutMessage", 30*1000, 1);
	return 1;
}

forward SendAzimutMessage();
public SendAzimutMessage()
{
	static azmessageid;
	if( azmessageid > 9) azmessageid =0;
	switch( azmessageid )
	{
	    case 0: SendClientMessageToAll(-1, ""COL_CMD"��� ��������� ���� ���������� � ����� - kuller.su � ������� RUB");
	    case 1: SendClientMessageToAll(-1, ""COL_CMD"������������� ����������� ������ ������ � ���������� ������ N �� ����������!");
	    case 2: SendClientMessageToAll(-1, ""COL_CMD"���������� ������ �� ������ � �������� 100 RUB!");
	    case 3: SendClientMessageToAll(-1, ""COL_CMD"������� ������� - �3 ����� � �3 ZM � �������� + ����� ���������� ���������� � TAB.");
	    case 4: SendClientMessageToAll(-1, ""COL_CMD"���� ���������� �������� ������ Y! � �� �� ������ ����� ��� ����������� ����������!");
	    case 5: SendClientMessageToAll(-1, ""COL_CMD"��������� ����� �������� �� ALT!");
	    case 6: SendClientMessageToAll(-1, ""COL_CMD"�� ������ ��������� RUB, ��������� � ����� - kuller.su (������� ����������)");
	    case 7: SendClientMessageToAll(-1, ""COL_CMD"������� ����������� �� ������� ������ H! ����� ������ ������ ����� ZM ��� RUB.");
	    case 8: SendClientMessageToAll(-1, ""COL_CMD"����� ������ ���� �� ������ ����������� Num 4 Num 6");
	    case 9: SendClientMessageToAll(-1, ""COL_CMD"��� �������, ����� � ��� �������.");
	    case 10: SendClientMessageToAll(-1, ""COL_CMD"1 ����� = 3 RUB �� �������, ��� ��������� ���������� � ����� - kuller.su.");
	    case 11: SendClientMessageToAll(-1, ""COL_CMD"������� �� ����� ������� ������ ���� �� ����� 24 ���� �� ������� � ������ ��� ���!");
		case 12: SendClientMessageToAll(-1, ""COL_CMD"���������� ���� ���������� � 5:30 �� ����������� �������!");
		case 13: SendClientMessageToAll(-1, ""COL_CMD"�������������� �� ������ www.kuller.su � �������� RUB!");
		case 14: SendClientMessageToAll(-1, ""COL_CMD"������� ���� �����! ��� ��������� ���������� ������� � ���� Y ����� (�����).");
		case 15: SendClientMessageToAll(-1, ""COL_CMD"����������������� 1 ������ ����� - 100 RUB ����������� � ������ (kuller.su).");
	}
	
	azmessageid ++;
	return 1;
}

//������ �����,�����,����� �����������
stock HideTextDraws(playerid){
	TextDrawHideForPlayer(playerid,TD_Zombies_Counter);
	TextDrawHideForPlayer(playerid,TD_EVC_Counter);
	TextDrawHideForPlayer(playerid,TD_Humans_Counter);
    HideVoteTextsForPlayer(playerid);
	return 1;
}


//�������� �����, �����, ������, ��, ����� ��� ������
stock ShowTextDraws(playerid){
	TextDrawShowForPlayer(playerid,TD_Zombies_Counter);
	TextDrawShowForPlayer(playerid,TD_EVC_Counter);
	TextDrawShowForPlayer(playerid,TD_Humans_Counter);
	PlayerTextDrawShow(playerid,PTD_MoneyText[playerid]);
	PlayerTextDrawShow(playerid,PTD_HpText[playerid]);
	return 1;
}

public OnGameModeExit()
{
	KillTimer(GM);
	DestroyLogoObjects(); // ������� ������� ����
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
    if(S[playerid] != 0) //��� ����������, ��������� ����. � ��� ��� ����� ���� ������. � ������ ������ ����� 1, �.�. ����� ��� ����� � ����/�������, � �� ����� ��� �������� �� ������ class'�
    {
       //SetSpawnInfo(playerid,0,0,0.0,0.0,0.0,0.0,0,0,0,0,0,0); // ������ skin ���������� ���� ������, ������� ������ ���� � ����. ��� RP �������� ������������ ����� ����������.
       SetPlayerSpawnInArea(playerid,CurrentMap); // ��������� ������
	   SpawnPlayer(playerid);
       return 1;
    }
    
	//AC_SetPlayerPos(playerid, 1380.6447,-1753.0427,13.5469);
    //SetPlayerFacingAngle(playerid, 269.6420);
    //SetPlayerCameraPos(playerid, 1387.2906,-1752.8887,13.3828);
    //SetPlayerCameraLookAt(playerid, 1380.6447,-1753.0427,13.5469);
    
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

public OnVehicleMod(playerid,vehicleid,componentid)
{
    RemoveVehicleComponent(vehicleid,componentid);
    MessageToAdmins("��������! ��������� ��������� ���������. �� ����� ������");
	DestroyVehicle(vehicleid);
    return 1;
}

public OnPlayerConnect(playerid)
{
    isConnected[playerid] = true;
    new desti[32];
	GetPlayerVersion(playerid, desti, sizeof(desti));
	if(strcmp(desti, "unknown", true) == 0)
	{
	    BanEx(playerid, "����������� ������ sa-mp");
	    return 1;
	}
    //TextDrawShowForPlayer(playerid, TD_LoadScreen);
	if( Call_Connected[playerid] == false)
	{
	    __ProfAndRank3D__CreateInformer(playerid);
   	   	__InfectText__CreateLabel(playerid);
   	   	
	    isCreatedAccount[playerid] = false;
		Call_Connected[playerid] = true;
		GetPlayerName(playerid, pName[playerid], MAX_PLAYER_NAME);
		SetTimerEx("OnPlayerConnecting", 1000, 0, "d", playerid);
		return 1;
	}
	SendClientMessage(playerid, -1, "���������...");
	return 1;
}

// ������ �������� � ��������� ZM ( ������ ++ )
stock HideTD_DropZmInformer(playerid)
{
    TimeToHideTD_DropZmInformer[playerid] = 0;
    PlayerTextDrawHide(playerid,TD_DropZmInformer[playerid]);
	return 1;
}

// �������� �������� � ��������� ZM ( ������ ++ )
stock ShowTD_DropZmInformer(playerid)
{
    TimeToHideTD_DropZmInformer[playerid] = TIME_TO_HIDE_DROP_ZM_INFORMER;
    PlayerTextDrawShow(playerid,TD_DropZmInformer[playerid]);
	return 1;
}

forward OnPlayerConnecting(playerid);
public OnPlayerConnecting(playerid)
{
	Call_Connected[playerid] = false;
	// ����-���������
    if(GetServerAttackByPlayer(playerid, DOUBLE_CONNECT))   // ��������+�������� �� ������������ �����������
    {
		   SendClientMessage(playerid, -1, "�������������� ����������� ���� ��������");
    }
	
    if(GetServerAttackByPlayer(playerid, DDOS_CONNECTER)) // �����
    {
            SendClientMessage( playerid, -1, "{ff0000}�� ���� ��������: ������� ��������� ������ �������");
			BanEx(playerid, "����-���������");
			return 1;
    }
    if( !AddSession(playerid)/*��������� ������*/ ) 
	{
	        // ����� ������ �������� ����� ��� ������ �����������, �� �� ������ ������ ��������.
			SendClientMessage( playerid, -1, "{FFFFFF}������ ���������� ���������. ����������, ���������� ����������� �����. ��� ������ ����������� /q");
			Kick(playerid);
			return 1;
	}
    // ���� ����� ����
    if(GetServerAttackByPlayer(playerid, ATTACK_NPC)) // �������� �� ����� NPC
    {
		   BanEx(playerid, "NPC ���");
		   return 1;
    }
    new ipa[16];
	GetPlayerIp(playerid, ipa, 16);
	if(strcmp(ipa, "255.255.255", true) == 0)
	{
	    SendClientMessage(playerid, -1, "������: �� ������ ������������ ��");
	    t_Kick(playerid);
	    return 1;
	}
    if( playerid > MaxID) MaxID = playerid;
    SetPlayerColor(playerid,COLOR_GRAY);
    //�������� �������� � ����, ����� � ������ ������//
    RemoveBuildingForPlayer(playerid, 956, 0,0,0, 9999);
    RemoveBuildingForPlayer(playerid, 955, 0,0,0, 9999);
    RemoveBuildingForPlayer(playerid, 1209, 0,0,0, 9999);
    RemoveBuildingForPlayer(playerid, 1302, 0,0,0, 9999);
    RemoveBuildingForPlayer(playerid, 1776, 0,0,0, 9999);
    RemoveBuildingForPlayer(playerid, 1775, 0,0,0, 9999);
    //***********************************************//
    
    PlayAudioStreamForPlayer(playerid,"http://dl.dropbox.com/u/54368978/Postal%202%20-%20Uncle%20Dave%20Heavy%20Metal.mp3");
    
    TextDrawHideForPlayer(playerid,TD_HumansWin);
	TextDrawHideForPlayer(playerid,TD_ZombiesWin);
	Player_RHealth[playerid] = 100;

	DestroyBottomInformer(playerid);
    CreateBottomInformer(playerid);

    PlayerTextDrawDestroy(playerid,PTD_MoneyText[playerid]);
	PlayerTextDrawDestroy(playerid,PTD_HpText[playerid]);
	PlayerTextDrawDestroy(playerid,TD_DropZmInformer[playerid]);
    CreateTextDrawsHpAndMoney(playerid);
    
	PlayerTextDrawHide(playerid,PTD_MoneyText[playerid]);
	PlayerTextDrawHide(playerid,PTD_HpText[playerid]);
	PlayerTextDrawHide(playerid,TD_DropZmInformer[playerid]);
	
	TextDrawHideForPlayer(playerid, TD_ZmText);
	TextDrawShowForPlayer(playerid, TD_Logo_Server1);
	TextDrawShowForPlayer(playerid, TD_Logo_Server2);
	
	HideVoteTextsForPlayer(playerid);
    SetPVarInt(playerid, "PlayerInAFK", -2);
    SetNull(playerid);

    AC_SetPlayerPos(playerid, 2540.9023,606.6636,10.5607);
    SetPlayerFacingAngle(playerid, 270.2573);
    SetPlayerCameraPos(playerid, 2543.5901,612.0669,29.9688);
    SetPlayerCameraLookAt(playerid, 2541.7754,612.1378,10.7064);
    
    SetTimerEx("OnPlayerConnectedEx",100,0,"i",playerid); // ���������� �� ������ ������
	return 1;
}

stock ClearChat(playerid, emptymessages)
{
    for(new i; i < emptymessages; i ++)
	{
		 SendClientMessage(playerid,-1,"");
	}
	return 1;
}

// �������� �����������
forward OnPlayerConnectedEx(playerid);
public OnPlayerConnectedEx(playerid)
{
	ClearChat(playerid, 40);
    new str[128],IF,ip[16];
    GetPlayerIp(playerid,ip,sizeof(ip));
    format(str,sizeof(str),"%s/%s.ini",ACCOUNTS_FOLDER,GetName(playerid));
    if(fexist(str))
	{
		 IF = ini_openFile(str);
		 ini_getString(IF,"password",Player_Password[playerid]);
		 ini_getInteger(IF,"special_voteban",Player_Special_Voteban[playerid]);
		 new isblocked; // ����� 0, ���� �� ������������, ����� - ����������
		 ini_getInteger(IF,"isblocked",isblocked);
		 ini_closeFile(IF);
		 if( isblocked != 0 ) // ������� ������������
		 {
		        SendClientMessage(playerid, COLOR_RED, "��� ������� ������������!");
		        t_Kick(playerid);
		    	return 1;
		 }
		 if(gettime() < Player_Special_Voteban[playerid])//���� ���� ���������� ������� ��� �� ������
		 {
				SendClientMessage(playerid,COLOR_RED,"��� ������������ ������ �� ������ � ������� ������ ���� ����� ����� ���� ��� �����������");
				t_Kick(playerid);
				return 1;
		 }
	     OpenLogin(playerid);
	     SendClientMessage(playerid,COLOR_WHITE,       MESSAGE_WELCOME_SELECTING);
  	     SendClientMessage(playerid,COLOR_LIGHTBLUE,   "                  ***** � ������������ �� ��� ������  *****                  ");
  	     SendClientMessage(playerid,COLOR_GREEN,       "* !!! ��� ��� ���������������� !!! �� ������ ������� !!! *");
  	     SendClientMessage(playerid,COLOR_YELLOW,      "* ����� �����, ���������� ������� ������ � ������� ��� ����� *");
  	     SendClientMessage(playerid,COLOR_TURQUOISE,   "                          "SERVER_LOGO"                          ");
  	     SendClientMessage(playerid,COLOR_WHITE,       MESSAGE_WELCOME_SELECTING);
    }
    else
	{
	     OpenRegister(playerid);
	     SendClientMessage(playerid,COLOR_WHITE,       MESSAGE_WELCOME_SELECTING);
  	     SendClientMessage(playerid,COLOR_LIGHTBLUE,   "                  ***** ������������ �� ����� ������� *****                  ");
  	     SendClientMessage(playerid,COLOR_YELLOWGREEN, "                       !!! �� ������� �� ������ !!!                       ");
  	     SendClientMessage(playerid,COLOR_RED,         "     !!! ��� ���� ��� ���������� ������������������ !!!     ");
  	     SendClientMessage(playerid,COLOR_YELLOW,      "       * ��� �����������, ���������� ��������� ���� ������ *       ");
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
    for(new i, s_b = MaxID; i <= s_b; i ++)
	{
             if( gSpectateID[i] == playerid )
             {
                if( !NextSpectate(i))
                {
					CancelSpectate(i);
                }
             }
	}
 	
	new str[100];
	NullDisconnectIDVote(playerid);//������ �� ������� �������
	if(VotePlayerID == playerid)
	{
		  ResetVoteParams();
		  format(str,sizeof(str),"�������� �� ��� %s ������� ����. ����������� �����������",GetName(playerid));
		  SendClientMessageToAll(COLOR_GRAYTEXT,str);
	}
    SaveAccount(playerid);
    HideTextDraws(playerid);
    KillInfection(playerid);
    __InfectText__DeleteLabel(playerid);
    
    SetNull(playerid);
    ReCountPlayers();
    DisablePlayerCheckpoint(playerid);
    DestroyBottomInformer(playerid);
    PlayerTextDrawDestroy(playerid,PTD_HpText[playerid]);
	PlayerTextDrawDestroy(playerid,PTD_MoneyText[playerid]);
	TextDrawHideForPlayer(playerid,TD_LoadScreen);
	TextDrawHideForPlayer(playerid,TD_HumansWin);
	TextDrawHideForPlayer(playerid,TD_ZombiesWin);
	__ProfAndRank3D__DeleteInformer(playerid);
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
		format(str,sizeof(str),"%s ������� ������ (���/��� ��������)[%s]",GetName(playerid),str);
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
	HideDialog(playerid);
	isConnected[playerid] = false;
	isCreatedAccount[playerid] = false;
	return 1;
}



public OnPlayerSpawn(playerid)
{
    //isUnlockedDeath[playerid] = true;
    if( S[playerid] == 0) StopAudioStreamForPlayer(playerid);
	Player_RHealth[playerid] = 100;
	AC_SpawnProtect[playerid] = SPAWN_PROTECT_TIME;
	S[playerid] = 2;
	ReturnDefenderOldHP(playerid);
	Player_IsKill[playerid] = false;
	FixPlayerBuyed(playerid);
    if( GetServerAttackByPlayer(playerid, FAKE_SKIP_REQUESTCLASS)) // �������� �� ���������� �����
    {
		   SendClientMessage(playerid,COLOR_RED,"�� ���� ������� � �������. �������: ����� ������/�����������");
		   t_Kick(playerid);
		   return 1;
    }
    //SetPlayerSpawnInArea(playerid,CurrentMap); // ��������� ������������ �� ������� ����� ����� (���� ��������� � ����)
    SetPVarInt(playerid,"K_Times",0); // �������� ��������
    SetPVarInt(playerid, "PlayerInAFK", 0);
	ShowTextDraws(playerid);
	GoToArena(playerid,CurrentMap);
	ReCountPlayers();
	FixInviseblePlayers(playerid);
	SetPlayerScore(playerid,Player_HourInGame[playerid]);
	TextDrawShowForPlayer(playerid, TD_ZmText);
	ShowBottomInformer(playerid);
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
	new Float: hpshka;
	GetPlayerHealth(playerid, hpshka);
	if( hpshka > 0)
	{
	    SetPlayerHealth(playerid, 0);
	}
	Player_RHealth[playerid] = 0;
    UpdateHealthOnHead(playerid);
    ReturnDefenderOldHP(playerid);

    SetPVarInt(playerid, "PlayerInAFK", -2);
    KillInfection(playerid);
    Player_Deaths[playerid]++;
    if(!Player_IsKill[playerid])//���� ����� �� ������ �� ����� ����
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
			 PlayerTextDrawSetString(killerid, TD_DropZmInformer[killerid], str);
			 ShowTD_DropZmInformer(killerid);

			 FixTitul(killerid,TIT_PRESIDENT);
			 SaveAccount(killerid);
			 format(str,sizeof(str),"����� %s(%s) ���� ������ %s(%s) �� %s",GetName(killerid),GetTeamName(Player_CurrentTeam[killerid]),GetName(playerid),GetTeamName(Player_CurrentTeam[playerid]),WeaponNames[reason]);
			 WriteLog(KILLLOG,str);
        }
    }
    if(Game_Started && Infection_Time == 0)/*SetZombie(playerid);*/Player_CurrentTeam[playerid] = ZOMBIE;
    SaveAccount(playerid);
    PlayerTextDrawHide(playerid,PTD_MoneyText[playerid]);
	//PlayerTextDrawHide(playerid,PTD_HpText[playerid]);
	TogglePlayerControllable(playerid,1);
	ReCountPlayers();
	HideBottomInformer(playerid);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    // �������� ��������
    SetPVarInt(playerid,"K_Times",GetPVarInt(playerid,"K_Times") + 1);
    if(GetServerAttackByPlayer(playerid, FAKE_DEATH)) // ��������: ������������ ������
    {
		  new str[100];
		  format(str, sizeof(str), "[�]����� %s ��� ������: �������-�����", GetName(playerid));
		  MessageToAdmins(str);
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
            case ZOMBIE: teamname = "�����";
            case HUMAN: teamname = "�������";
	        case ADMIN: teamname = "�����";
	 }
	 return teamname;
}

//����
#define ADMIN_TO_ADMIN_SYM '*'//��� �������
#define ADMIN_TO_ALL_SYM '!'//��� ����

public OnPlayerText(playerid, text[])
{
    new str[128];
    if(GetPVarInt(playerid,"CountFlood") > gettime()){
        SendClientMessage(playerid,-1,"�� ������� � ����");
        return false;
	}
    if(GetPVarInt(playerid,"Logged") == 0){
	     SendClientMessage(playerid, COLOR_GRAYTEXT, "������: �� ��� ���� � �� ������ ������ � ���");
		 return 0;
	}
	if(Player_MuteTime[playerid] > 0){
		format(text,129,"������: � ��� ��������. �� ������� ����� ������ � ��� ����� %d ������",Player_MuteTime[playerid]);
        SendClientMessage(playerid, COLOR_GRAYTEXT, text);
        return 0;
    }
    if(text[0] == ADMIN_TO_ADMIN_SYM && (IsPlayerAdmin(playerid) || Player_AdminLevel[playerid] > 0))
    {
		if(strlen(text) < 2)
		{
			  SendClientMessage(playerid,COLOR_GRAYTEXT,"�������������: *[��������� �������]");
			  return 0;
		}
		format(str,128,""COL_ORANGE"[A-Chat]"COL_YELLOW"%s[%d]: %s",GetName(playerid),playerid, text[1]);
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
			  SendClientMessage(playerid,COLOR_GRAYTEXT,"�������������: ![��������� ����]");
			  return 0;
		}
		format(str,128,"�������������: %s",text[1]);
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
			       case ZOMBIE:{//��� ����� ������
			            ShowPlayerNameTagForPlayer(playerid,i,0);//� ���� ��� �������� ������
                        SetPlayerMarkerForPlayer(playerid,i,HUMAN_COLOR_I);//���� ����� ����������
			       }
			       case HUMAN:{//��� ����� �����
			            ShowPlayerNameTagForPlayer(playerid,i,1);
                        SetPlayerMarkerForPlayer(playerid,i,HUMAN_COLOR);
			       }
			}
	 }
	 return 1;
}


HideAdmin(playerid)
{
    for(new i, s_b = MaxID; i <= s_b; i++)//���� ����� ����� �������
    {
		if( !IsPlayerConnected (i)) continue;
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
    for(new i, s_b = MaxID; i <= s_b; i++)//���� ����� ����� �������
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
    for(new i, s_b = MaxID; i <= s_b; i++)//���� ����� ����� �������
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
stock TurnPlayerFaceToPlayer(playerid, facingtoid)//������� ������������� � ����������� (lol :D)
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

forward UnBlockExplodeDamageForOther(cellid);

// �������������� ���� �� ������� ��� ����������� � ������ �������
public UnBlockExplodeDamageForOther(cellid)
{
	for(new i, s_b = MaxID; i <= s_b; i ++)
	{
				if(!IsPlayerConnected(i)) continue;
	            if(Player_MyExplodeBlocker[i][cellid] == true)
	            {
	                RemoveFromCellExplodeBlockers(i, cellid);
	            }
	}
	return 1;
}

// �������� ������ � ������ ������������� �����
stock AddCellToExplodeBlockers(playerid,cellid)
{
    Player_MyExplodeBlocker[playerid][cellid] = true;
	if( Player_ExploderBlockers[playerid] == 0) Player_BlockExplode[playerid] = true;
	Player_ExploderBlockers[playerid] ++;
	return 1;
}

// �������� ������������ ��������� ����� �� ������
stock RemoveFromCellExplodeBlockers(playerid, cellid)
{
    Player_MyExplodeBlocker[playerid][cellid] = false;
    Player_ExploderBlockers[playerid] --;
    if(Player_ExploderBlockers[playerid] == 0)
    {
    	Player_BlockExplode[playerid] = false;
    }
	return 1;
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
	   /*
	   new OLDHP_SPECIAL[MAX_PLAYERS];
	   new GmPlayer[MAX_PLAYERS];
	   new GmVsego = 0;
	   */
	   for(new i, s_b = MaxID; i <= s_b; i ++)
	   {
	            if(Player_CurrentTeam[i] != ZOMBIE) continue;
	            if( i == playerid ) continue;
	            if( Player_MyExplodeBlocker[i][playerid] ) continue; // ���� ���� �� ������ ������ ��� ������������
	            if(!IsPlayerInRangeOfPoint(i,TANK_BANG_RAD,P[0],P[1],P[2]))continue;
				
				AddCellToExplodeBlockers(i,playerid);
				/*
				OLDHP_SPECIAL[i] = Player_RHealth[i];//
	            SetPlayerHealthEx(i,50000);//
	            GmPlayer[GmVsego] = i;//
	            GmVsego ++;//
	            */
	   }
	   // ~~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~
	   for(new i; i < 2; i++)
	   {
               GetXYInFrontOfPoint(P[0], P[1], BangPOS[0], BangPOS[1], Ugol, RAMPAGE_TANG_BANG_DIST);
               CreateExplosion(BangPOS[0], BangPOS[1],P[2],RAMPAGE_TANG_BANG_TYPE,3.0);
               Ugol += 180.0;
	   }
	   // beta zombie return hp
	   /*
	   if( GmVsego != 0)//
	   {
		   for(new i; i < GmVsego; i ++)//
		   {
		            SetPlayerHealthEx(GmPlayer[i],OLDHP_SPECIAL[GmPlayer[i]]);//
		   }//
	   }//
	   */
	   // ~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~
	   SetTimerEx("BackHp",1000,0,"i",playerid);
	   return 1;
}

forward BackHp(playerid);
public BackHp(playerid)
{
      SetPlayerHealthEx(playerid,Player_OLDHP[playerid]);
      UnBlockExplodeDamageForOther(playerid);
	  return 1;
}

stock OpenGMenu(playerid)
{
	  ShowPlayerDialog(playerid,MENU_DIALOG,DIALOG_STYLE_LIST,"����","�������\n������ � ��������\n����������\n�������������\n������ �������\n�����������\n������� �������\n��� ���������\n����� �������","�������","�����");
	  return 1;
}

stock SetPlayerHoursInGame(playerid, hours)
{
    Player_HourInGame[playerid] = hours;
    Player_SecInGame[playerid] = 0;
    SetPlayerScore(playerid, hours);
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(GetPVarInt(playerid,"CmdFlood") > gettime())return SendClientMessage(playerid,-1,"�� ������� ���������");
	SetPVarInt(playerid,"CmdFlood",gettime() + FloodTimeCmd);
	new val,val2,Float: P[4];
	new params[128],str[170],cmd[128],idx;
    cmd = strtokForCmd(cmdtext, idx);
    if(strcmp(cmd, "/pm", true) == 0)
	{
         if(S[playerid] == 0) return SendClientMessage(playerid, COLOR_GRAYTEXT, "��� ���������� ������� �������� ��������������� / ������������");
         if( Player_MuteTime[playerid] != 0) return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� ���������");
         
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /pm [playerid][message]");
         val = strval(params);

         params = strrest(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /pm [playerid][message]");
         
         if(strlen(params) > 80)return SendClientMessage(playerid, COLOR_GRAYTEXT, "������: ��������� �� ������ ��������� 85 ��������");
         
         if(val == playerid)return SendClientMessage(playerid, COLOR_RED, "�� �� ������ ���������� ��������� ����");
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �������");
         if(S[val] == 0)return SendClientMessage(playerid, COLOR_RED, "����� �� ��������� / ���������");
		 if( PlayerIngorePMPlayer[val][playerid]) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� ������������ ����� PM �� ���");
		 format(cmd, sizeof(cmd), ">> ��� PM �� %s (%d): %s", GetName(playerid), playerid, params);
		 SendClientMessage(val, PM_INCOMING_COLOR, cmd);
		 
		 format(cmd, sizeof(cmd), "<< PM ��� %s (%d): %s", GetName(val), val, params);
		 SendClientMessage(playerid, PM_OUTGOING_COLOR, cmd);
		 
		 format(str, sizeof(str), "PM �� %s ��� %s: %s", GetName(playerid), GetName(val), params);
		 WriteLog(PMLOG,str);
         return 1;
	}
	if(strcmp(cmd, "/ignorepm", true) == 0)
	{
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /ignorepm [playerid]");
         val = strval(params);

         if(val == playerid)return SendClientMessage(playerid, COLOR_RED, "�� �� ������ ������������� PM �� ����");
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �������");
         if(S[val] == 0)return SendClientMessage(playerid, COLOR_RED, "����� �� ��������� / ���������");

         PlayerIngorePMPlayer[playerid][val] = true;

		 format(cmd, sizeof(cmd), ""COL_SERVER"�� ������������� PM �� ������ %s", GetName(val));
		 SendClientMessage(val, -1, cmd);
		 
		 
         return 1;
	}
    /*
    if(strcmp(cmd, "/setlevel", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 2 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /setlevel [playerid][level]");
         val = strval(params);
         
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /setlevel [playerid][level]");
         val2 = strval(params);
         if(!IsPlayerConnected(val))return SendClientMessage(playerid, COLOR_RED, "����� �� �������");
         if(val2 < 0)return SendClientMessage(playerid, COLOR_RED, "������� �� ������ ���� ������ ����");
         Player_Level[val] = val2;
         Player_Respects[val] = 0;
         format(str,sizeof(str),"������������� %s ��������� ������ %s ������� %d",GetName(playerid),GetName(val),val2);
	     SendClientMessageToAll(COLOR_LIGHTBLUE,str);
         WriteLog(ADMINLOG,str);
         return 1;
	}
	*/
    if(strcmp(cmd, "/nextarena", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 2 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))
		 {
		    
		    ShowPlayerDialog(playerid, DIALOG_CHANGEMAP, DIALOG_STYLE_LIST, "��������� ��������� �����", MapDialog, "����������", "�����");
		 	return 1;
 		 }
         val = strval(params);

	     if(val < 0 || val > (Loaded_Maps-1)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� �������");
         NextArenaId = val;
	     format(str,sizeof(str),"������������� %s ��������� ��������� ����� �� %s",GetName(playerid),MapName[val]);
	     SendClientMessageToAll(COLOR_LIGHTBLUE,str);
         WriteLog(ADMINLOG,str);
	     return 1;
	}
	if(strcmp(cmd, "/sethours", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 3 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 3 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /sethours [id][hours]");
         val = strval(params);
         
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /sethours [id][hours]");
         val2 = strval(params);

		 if(!IsPlayerConnected(val))return SendClientMessage(playerid, COLOR_RED, "����� �� �������");
         if(val2 < 0)return SendClientMessage(playerid, COLOR_RED, "���� �� ������ ���� ������ ����");
         
         SetPlayerHoursInGame(val, val2);
         
         if( Player_HourInGame[val] >= FRIENDINVITE_LVL_FOR_PRICE)
	     {
	            if( strlen(Player_FriendName[val]) > 0)
	            {
	                GivePrizeForFriend(Player_FriendName[val]);
	                Player_FriendName[val][0] = 0x0;
	            }
	     }
         
         SaveAccount(val);

	     format(str,sizeof(str),"������������� %s ��������� ������ %s ���� � ���� %d",GetName(playerid),GetName(val),val2);
	     SendClientMessageToAll(COLOR_LIGHTBLUE,str);
         WriteLog(ADMINLOG,str);
	     return 1;
	}
    if(strcmp(cmdtext, "/specoff", true) == 0)
    {
        if(Player_AdminLevel[playerid] < 2 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");
		if(Player_CurrentTeam[playerid] != ADMIN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �� ���������");
		if(gSpectateID[playerid] == -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ���������� �� �� ���");
		CancelSpectate(playerid);
		return 1;
	}
	if(strcmp(cmd, "/specplayer", true) == 0)
    {
        if(Player_AdminLevel[playerid] < 2 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");
		if(Player_CurrentTeam[playerid] != ADMIN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �� ���������");
		cmd = strtokForCmd(cmdtext, idx);
		if(!isNumeric(cmd))return SendClientMessage(playerid, COLOR_YELLOW, "���������: /spec_player [playerid]");
		val = strval(cmd);
		if(!IsPlayerConnected(val))return SendClientMessage(playerid, COLOR_RED, "����� ���������");
		if(val == playerid)return SendClientMessage(playerid, COLOR_RED, "������ ������� �� �����");
  		//SetPlayerHealthEx(playerid,100);
  		StartSpectate(playerid, val);
		return 1;
	}
    if(strcmp(cmdtext, "/aduty", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 2 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");
		 if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
         if(Player_CurrentTeam[playerid] == ADMIN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� ��� �� ��������� ��������������");
         Player_CurrentTeam[playerid] = ADMIN;
         HideAdmin(playerid);
		 format(str,sizeof(str),"������������� %s �������� �� ���������",GetName(playerid));
		 SendClientMessageToAll(COLOR_YELLOW,str);
         WriteLog(ADMINLOG,str);
		 SpawnPlayer(playerid);
		 ReCountPlayers();
		 return 1;
	}
	if(strcmp(cmdtext, "/adutyoff", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 2 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");
		 if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
         if(Player_CurrentTeam[playerid] != ADMIN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �������� ��������� ��������������");
         if(gSpectateID[playerid] != -1)CancelSpectate(playerid);
		 Player_CurrentTeam[playerid] = HUMAN;
		 ShowAdmin(playerid);
		 format(str,sizeof(str),"������������� %s ������� ���������",GetName(playerid));
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
		 ApplyAnimation(playerid,"KNIFE","Knife_G",4.1,0,1,1,600,1);//��� ����-�� ������� ������
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
/*
    if(strcmp(cmd, "/test", true) == 0)
	{
		 
         params = strrest(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /test [url]");
         
         PlayAudioStreamForPlayer(playerid, params);

	     return 1;
	}
	*/
	
    if(strcmp(cmd, "/tp", true) == 0 || strcmp(cmd, "/��", true) == 0)//+2
	{
         if(Player_AdminLevel[playerid] < 2 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");
         if(S[playerid] != 2)return SendClientMessage(playerid,COLOR_RED,MESSAGE_WAIT_SPAWN);
		 params = strtokForCmd(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, -1, "�����������: /tp [x.mx][y.my][z.mz]");

         strdel(cmd,0,129);
         str = strtokForCmd(params,val,'.');
         //if(!isNumeric(str))return SendClientMessage(playerid, COLOR_GRAD1, "�����������: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,str);
         str = strtokForCmd(params,val,'.');
         if(!isNumeric(str))return SendClientMessage(playerid,  -1, "�����������: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,".");
         strcat(cmd,str);
         P[0] = floatstr(cmd);

	     params = strtokForCmd(cmdtext, idx);
	     if(!strlen(params))return SendClientMessage(playerid,  -1, "�����������: /tp [x.mx][y.my][z.mz]");
	     val = 0;
	     strdel(cmd,0,129);
         str = strtokForCmd(params,val,'.');
         if(!isNumeric(str))return SendClientMessage(playerid,  -1, "�����������: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,str);
         str = strtokForCmd(params,val,'.');
         if(!isNumeric(str))return SendClientMessage(playerid,  -1, "�����������: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,".");
         strcat(cmd,str);
         P[1] = floatstr(cmd);

	     params = strtokForCmd(cmdtext, idx);
	     if(!strlen(params))return SendClientMessage(playerid,  -1, "�����������: /tp [x.mx][y.my][z.mz]");
	     val = 0;
	     strdel(cmd,0,129);
         str = strtokForCmd(params,val,'.');
         if(!isNumeric(str))return SendClientMessage(playerid,  -1, "�����������: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,str);
         str = strtokForCmd(params,val,'.');
         if(!isNumeric(str))return SendClientMessage(playerid,  -1, "�����������: /tp [x.mx][y.my][z.mz]");
         strcat(cmd,".");
         strcat(cmd,str);
         P[2] = floatstr(cmd);

         AC_SetPlayerPos(playerid,P[0],P[1],P[2]);
         return 1;
	}
    if(strcmp(cmdtext, "/shop", true) == 0)
	{
		 if(S[playerid] == 0)return 1;
		 SetPVarInt(playerid, "ShopOpenMenu", 0);
         OpenShop(playerid);
		 return 1;
	}
	
    if(strcmp(cmd, "/setadm", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 4 && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ������ ��� KulleR'a");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /setadm [id][level]");
         val = strval(params);
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /setadm [id][level]");
         val2 = strval(params);

	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
	     if(val == playerid && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� ��������� � ����");
	     if((Player_AdminLevel[val] >= Player_AdminLevel[playerid]) && !IsPlayerAdmin(playerid))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ������ ��������� ������ ������� � ��������������� ������ ���� ������ ��� ����������� � ����");
		 Player_AdminLevel[val] = val2;

	     format(str,sizeof(str),"������������� %s �������� ������ %s ��������������� %d ������",GetName(playerid),GetName(val),val2);
	     SendClientMessageToAll(COLOR_LIGHTBLUE,str);
	     WriteLog(ADMINLOG,str);
	     SaveAccount(val);
	     return 1;
	}

    if(strcmp(cmd, "/unmute", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /unmute [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
		 if(Player_MuteTime[val] == 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ��������");
		 Player_MuteTime[val] = 0;

	     format(str,sizeof(str),"������������� %s ��������� ������ %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_LIGHTBLUE,str);
	     WriteLog(ADMINLOG,str);
	     SaveAccount(val);
	     return 1;
	}

    if(strcmp(cmd, "/mute", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 1 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /mute [id][time]");
         val = strval(params);
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /mute [id][time]");
         val2 = strval(params);

	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
	     Player_MuteTime[val] = val2;

	     format(str,sizeof(str),"������������� %s �������� ������ %s �� %d ������(�)",GetName(playerid),GetName(val),val2);
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     SaveAccount(val);
	     return 1;
	}

    if(strcmp(cmd, "/kick", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 1 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /kick [id][�������]");
         val = strval(params);
         params = strrest(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /kick [id][�������]");
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
         if(Player_AdminLevel[val] > 0 && val != playerid)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ������ ��������� ������ ������� � ���������������");
	     format(str,sizeof(str),"������������� %s ������ ������ %s. �������: %s",GetName(playerid),GetName(val),params);
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     t_Kick(val);

	     return 1;
	}
	if(strcmp(cmd, "/warn", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /warn [id][�������]");
         val = strval(params);
         
         params = strrest(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /warn [id][�������]");
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
         if(Player_AdminLevel[val] > 0 && val != playerid)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ������ ��������� ������ ������� � ���������������");
         Player_Warns[playerid] ++;
		 if( Player_Warns[playerid] >= WARNS_TO_BAN)
		 {
  	         format(str,sizeof(str),"������������� %s ����� ���� ������ %s. �������: %s",GetName(playerid),GetName(val),params);
		     SendClientMessageToAll(COLOR_BROWN,str);
		     WriteLog(ADMINLOG,str);
		     format(str,sizeof(str),"����� %s ��� ������������� �������: %d/%d ������",GetName(val),Player_Warns[playerid], WARNS_TO_BAN);
		     SendClientMessageToAll(COLOR_BROWN,str);
		     WriteLog(ADMINLOG,str);
		     Player_Warns[playerid] = 0;
		     BanEx(val, "����-�����");
		 }
		 else
		 {
			 format(str,sizeof(str),"������������� %s ����� ���� ������ %s. �������: %s",GetName(playerid),GetName(val),params);
		     SendClientMessageToAll(COLOR_BROWN,str);
		     WriteLog(ADMINLOG,str);
		     t_Kick(val);
	     }
	     return 1;
	}
	
    if(strcmp(cmd, "/ban", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 3 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 3 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /ban [id][�������]");
         val = strval(params);
         params = strrest(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /ban [id][�������]");
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
         if(Player_AdminLevel[val] > 0 && val != playerid)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ������ ��������� ������ ������� � ���������������");
	     format(str,sizeof(str),"������������� %s ������� ������ %s. �������: %s",GetName(playerid),GetName(val),params);
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     BanEx(val,params);
	     return 1;
	}
	
	if(strcmp(cmd, "/giverub", true) == 0)
	{
		 //if(Player_AdminLevel[playerid] < 3 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 3 ������");
		 if(strcmp(KULLERNAME, GetName(playerid), true) && strcmp(NAME2RAGE, GetName(playerid), true)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "������ ������� ��� ����������");
	     params = strtokForCmd(cmdtext, idx);
	     if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /giverub [id][amount]");
	     val = strval(params);
	     params = strtokForCmd(cmdtext, idx);
	     if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /giverub [id][amount]");
         val2 = strval(params);

		 if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
		 Player_Rub[val] += val2;

         format(str,sizeof(str),"�� ���� ������ %s %d RUB",GetName(val),val2);
		 SendClientMessage(playerid,COLOR_YELLOWGREEN,str);

		 format(str,sizeof(str),"������������� %s ��� ��� %d RUB",GetName(playerid),val2);
		 SendClientMessage(val,COLOR_YELLOWGREEN,str);

		 format(str,sizeof(str),"������������� %s ��� ������ %s %d ������",GetName(playerid),GetName(val),val2);
		 MessageToAdmins(str);
		 WriteLog(MONEYLOG,str);
		 SaveAccount(val);
	     return 1;
	}
	if(strcmp(cmd, "/givezm", true) == 0)
	{
		 //if(Player_AdminLevel[playerid] < 3 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 3 ������");
		 if(strcmp(KULLERNAME, GetName(playerid), true) && strcmp(NAME2RAGE, GetName(playerid), true)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "������ ������� ��� ����������");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /givezm [id][amount]");
         val = strval(params);
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /givezm [id][amount]");
         val2 = strval(params);

		 if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
		 Player_Zm[val] += val2;

		 format(str,sizeof(str),"�� ���� ������ %s %d Zombie Money",GetName(val),val2);
	     SendClientMessage(playerid,COLOR_YELLOWGREEN,str);

		 format(str,sizeof(str),"������������� %s ��� ��� %d Zombie Money",GetName(playerid),val2);
		 SendClientMessage(val,COLOR_YELLOWGREEN,str);

		 format(str,sizeof(str),"������������� %s ��� ������ %s %d Zombie Money",GetName(playerid),GetName(val),val2);
		 WriteLog(MONEYLOG,str);
		 MessageToAdmins(str);//+���������� � ��������
         SaveAccount(val);
	     return 1;
	}
	if(strcmp(cmd, "/giverank", true) == 0)
	{
	     //if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 4 ������");
	     if(strcmp(KULLERNAME, GetName(playerid), true) && strcmp(NAME2RAGE, GetName(playerid), true)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "������ ������� ��� ����������");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /giverank [id][rankid][ZOMBIE/HUMAN]");
         val = strval(params);
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /giverank [id][rankid][ZOMBIE/HUMAN]");
         val2 = strval(params);
		 if(val2 > 5 || val2 < 1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /giverank [id][rankid (1-5)][ZOMBIE/HUMAN]");
         params = strtokForCmd(cmdtext, idx);
         if(strcmp(params, "HUMAN", true) == 0)UpgradeHumanRang(val,val2-1); // ����� 1 �����������
         else if(strcmp(params, "ZOMBIE", true) == 0)UpgradeZombieRang(val,val2-1); // ����� 1 �����������
         else return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /giverank [id][rankid][ZOMBIE/HUMAN]");
         format(str,sizeof(str),"������������� %s ������ ��� ����",GetName(playerid));
         SendClientMessage(val,COLOR_YELLOWGREEN,str);
         format(str,sizeof(str),"�� ������� ���� ������ %s",GetName(val));
         SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
         
         format(str,sizeof(str),"������������� %s ��� ������ %s %d ���� ",GetName(playerid),GetName(val),val2);
         MessageToAdmins(str);//+���������� � ��������
		 return 1;
	}
	if(strcmp(cmd, "/setprof", true) == 0)
	{
	     //if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 4 ������");
	     if(strcmp(KULLERNAME, GetName(playerid), true) && strcmp(NAME2RAGE, GetName(playerid), true)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "������ ������� ��� ����������");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /setprof [id][profid][ZOMBIE/HUMAN]");
         val = strval(params);
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /setprof [id][profid][ZOMBIE/HUMAN]");
         val2 = strval(params);
		 
         params = strtokForCmd(cmdtext, idx);
         if(strcmp(params, "HUMAN", true) == 0)
		 {
               if(val2 > 4 || val2 < 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������-��������� � ����� �� �� ����������");
               SwitchProfession(val,HUMAN,val2);
               format(str,sizeof(str),"������������� %s ������ ��� ������� ��������� �� %s",GetName(playerid),GetProfName(HUMAN,val2));
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"�� ������� ��������� ������ %s �� %s(����)",GetName(val),GetProfName(HUMAN,val2));
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"������������� %s ������ ������ %s ��������� �� %s(����)",GetName(playerid),GetName(val),GetProfName(HUMAN,val2));
               MessageToAdmins(str);//+���������� � ��������
		 }
         else if(strcmp(params, "ZOMBIE", true) == 0)
         {
               if(val2 > 3 || val2 < 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����-��������� � ����� �� �� ����������");
               SwitchProfession(val,ZOMBIE,val2);
               format(str,sizeof(str),"������������� %s ������ ��� �����-��������� �� %s",GetName(playerid),GetProfName(ZOMBIE,val2));
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"�� ������� ��������� ������ %s �� %s(�����)",GetName(val),GetProfName(ZOMBIE,val2));
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"������������� %s ������ ������ %s ��������� �� %s(�����)",GetName(playerid),GetName(val),GetProfName(ZOMBIE,val2));
               MessageToAdmins(str);//+���������� � ��������
         }
         else return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /setprof [id][profid][ZOMBIE/HUMAN]");
		 return 1;
	}
	
	if(strcmp(cmd, "/setskill", true) == 0)
	{
	     //if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 4 ������");
	     if(strcmp(KULLERNAME, GetName(playerid), true) && strcmp(NAME2RAGE, GetName(playerid), true)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "������ ������� ��� ����������");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /setskill [id][skill][ZOMBIE/HUMAN]");
         val = strval(params);
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /setskill [id][skill][ZOMBIE/HUMAN]");
         val2 = strval(params);

         params = strtokForCmd(cmdtext, idx);
         if(strcmp(params, "HUMAN", true) == 0)
		 {
               Player_HumanRangSkill[val][Player_HumanProfession[val]] = val2;
               format(str,sizeof(str),"������������� %s ��������� ��� ����� ������� ��������� �� %d",GetName(playerid),val2);
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"�� ������� ����� ������� ��������� ������ %s �� %d",GetName(val),val2);
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
               FixHumanRang(val);
			   SaveAccount(val);
			   format(str,sizeof(str),"������������� %s ��������� ������ %s ����� ���������(���) �� %d",GetName(playerid),GetName(val),val2);
               MessageToAdmins(str);//+���������� � ��������
		 }
         else if(strcmp(params, "ZOMBIE", true) == 0)
         {
               Player_ZombieRangSkill[val][Player_ZombieProfession[val]] = val2;
               format(str,sizeof(str),"������������� %s ��������� ��� ����� �����-��������� �� %d",GetName(playerid),val2);
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"�� ������� ����� �����-��������� ������ %s �� %d",GetName(val),val2);
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
               FixZombieRang(val);
			   SaveAccount(val);
			   format(str,sizeof(str),"������������� %s ��������� ������ %s ����� ���������(����) �� %d",GetName(playerid),GetName(val),val2);
               MessageToAdmins(str);//+���������� � ��������
         }
         else return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /setskill [id][skill][ZOMBIE/HUMAN]");
		 return 1;
	}
	
	if(strcmp(cmd, "/resetskilltime", true) == 0)
	{
	     if(Player_AdminLevel[playerid] < 3 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 3 ������");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /resetskilltime [id][ZOMBIE/HUMAN]");
         val = strval(params);
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");

         params = strtokForCmd(cmdtext, idx);
         if(strcmp(params, "HUMAN", true) == 0)
		 {
               if(Player_HumanResetSkillTime[val][Player_HumanProfession[val]] == 0)return SendClientMessage(playerid,COLOR_GRAYTEXT,"��������� ����� �� ��������� � ��������� ����������� ��������-������");
               Player_HumanResetSkillTime[val][Player_HumanProfession[val]] = 0;
               format(str,sizeof(str),"������������� %s �������� ��� ����� ����������� ����.����������� ������� ���������",GetName(playerid));
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"�� �������� ������ %s ����� ����������� ������������� ������",GetName(val));
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
			   SaveAccount(val);
			   format(str,sizeof(str),"������������� %s ������� ������ %s ����� ���������� �-������",GetName(playerid),GetName(val));
               MessageToAdmins(str);//+���������� � ��������
		 }
         else if(strcmp(params, "ZOMBIE", true) == 0)
         {
			   if(Player_ZombieResetSkillTime[val][Player_ZombieProfession[val]] == 0)return SendClientMessage(playerid,COLOR_GRAYTEXT,"��������� ����� �� ��������� � ��������� ����������� �����-������");
               Player_ZombieResetSkillTime[val][Player_ZombieProfession[val]] = 0;
               format(str,sizeof(str),"������������� %s �������� ��� ����� ����������� ����.����������� ����� ���������",GetName(playerid));
               SendClientMessage(val,COLOR_YELLOWGREEN,str);
               format(str,sizeof(str),"�� �������� ������ %s ����� ����������� ����� ������",GetName(val));
               SendClientMessage(playerid,COLOR_YELLOWGREEN,str);
			   SaveAccount(val);
			   format(str,sizeof(str),"������������� %s ������� ������ %s ����� ���������� �-������",GetName(playerid),GetName(val));
               MessageToAdmins(str);//+���������� � ��������
         }
         else return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /resetskilltime [id][ZOMBIE/HUMAN]");
		 return 1;
	}
	
	if(strcmp(cmd, "/killinfect", true) == 0)
	{
	     if(Player_AdminLevel[playerid] < 3 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 3 ������");
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /killinfect [id]");
         val = strval(params);
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
         if(Player_IL[val] == NONE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� �����������");
         KillInfection(val);
         format(str,sizeof(str),""COL_RULE"������������� %s ���� �������� ������ %s",GetName(playerid),GetName(val));
		 SendClientMessageToAll(-1,str);
         MessageToAdmins(str);//+���������� � ��������
		 return 1;
	}
	if(strcmp(cmdtext, "/map_spawnlist", true) == 0) // ������� �����
	{
	    if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 4 ������");
	    if(CurrentMap == -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ����� ��� �������");
	    SendClientMessage(playerid,-1, "�����-����: ");
	    format(cmd, sizeof(cmd), "������� �� ������� �����: %d", MapSpawnsLoaded[CurrentMap]);
	    SendClientMessage(playerid,-1, cmd);
	    return 1;
	}
	if(strcmp(cmd, "/map_remove_spawn", true) == 0) // ������� �����
	{
         if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 4 ������");
         #if MAP_CHANGE_DATA == true

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "������� ������ . �����������: /map_remove_spawn [id_������]");
         val = strval(params);

         if(CurrentMap == -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��� ����� ������ ������� ������� ������");
		 if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ������ ������ ��� ����������");

         if( (val < 0) || (val >= MapSpawnsLoaded[CurrentMap])) return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ������. ������: ������ � ����� �� �� ����������");
		 if( MapSpawnsLoaded[CurrentMap] <= 1) return SendClientMessage(playerid, COLOR_GRAYTEXT, "������: ��������� ����� ������ �������");

		 new new_spawn_id = 0;
		 for(new s; s < MapSpawnsLoaded[CurrentMap]; s ++)
		 {
		    if( s == val ) continue;
		    
		    MapSpawnPos[CurrentMap][new_spawn_id][0] = MapSpawnPos[CurrentMap][s][0];
		    MapSpawnPos[CurrentMap][new_spawn_id][1] = MapSpawnPos[CurrentMap][s][1];
		    MapSpawnPos[CurrentMap][new_spawn_id][2] = MapSpawnPos[CurrentMap][s][2];
		    MapSpawnPos[CurrentMap][new_spawn_id][3] = MapSpawnPos[CurrentMap][s][3];
		    new_spawn_id ++;
		 }
		 MapSpawnPos[CurrentMap][MapSpawnsLoaded[CurrentMap]][0] = 0;
         MapSpawnPos[CurrentMap][MapSpawnsLoaded[CurrentMap]][1] = 0;
         MapSpawnPos[CurrentMap][MapSpawnsLoaded[CurrentMap]][2] = 0;
         MapSpawnPos[CurrentMap][MapSpawnsLoaded[CurrentMap]][3] = 0;
         MapSpawnsLoaded[CurrentMap] --;
         
         ReWriteArena(CurrentMap);
         
		 format(str,sizeof(str),"������������� %s ������ ������� ������ [%d] ��� ������� �����",GetName(playerid), val);
		 MessageToAdmins(str);//+���������� � ��������

		 #else
		 SendClientMessage(playerid, COLOR_GRAYTEXT, "���� MAP_CHANGE_DATA ��������");
		 #endif
		 return 1;
	}
	if(strcmp(cmdtext, "/map_add_spawn", true) == 0) // �������� �����
	{
	     if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 4 ������");
         #if MAP_CHANGE_DATA == true

         if(CurrentMap == -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ������ �� ������� ���������. ��� ����� ������ ������ ������� ������");
		 if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ������ �� ������� ���������. � ������ ������ ��� ����������");

         if( MapSpawnsLoaded[CurrentMap]+1 >= MAX_MAP_SPAWN_POS) return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ������ �� ������� ���������. ������: ����� �������");

		 GetPlayerPos(playerid,P[0],P[1],P[2]);
		 GetPlayerFacingAngle(playerid,P[3]);

		 MapSpawnPos[CurrentMap][MapSpawnsLoaded[CurrentMap]][0] = P[0];
		 MapSpawnPos[CurrentMap][MapSpawnsLoaded[CurrentMap]][1] = P[1];
		 MapSpawnPos[CurrentMap][MapSpawnsLoaded[CurrentMap]][2] = P[2];
		 MapSpawnPos[CurrentMap][MapSpawnsLoaded[CurrentMap]][3] = P[3];
		 
		 format(str,sizeof(str),"������������� %s ������� ����� [%d] ��� ������� �����",GetName(playerid), MapSpawnsLoaded[CurrentMap]);
		 MessageToAdmins(str);//+���������� � ��������

         MapSpawnsLoaded[CurrentMap] ++;
         ReWriteArena(CurrentMap);
		 #else
		 SendClientMessage(playerid, COLOR_GRAYTEXT, "���� MAP_CHANGE_DATA ��������");
		 #endif
	     return 1;
	}
	if(strcmp(cmd, "/map_goto_spawn", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 4 ������");
         
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� �� �����. �����������: /map_goto_spawn [id_������]");
         val = strval(params);

         if(CurrentMap == -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ����� ��� ������� ��� ��������� �� ���");
		 if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ������ ������ ��� ����������");

         if( (val < 0) || (val >= MapSpawnsLoaded[CurrentMap])) return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� �� ����� �����. ������: ������ � ����� �� �� ����������");
		 GoToSpawnInArena(playerid, CurrentMap, val);
		 format(str,sizeof(str),"������������� %s ���������������� �� ����� [%d] ������� �����",GetName(playerid), val);
		 MessageToAdmins(str);//+���������� � ��������
		 return 1;
	}
	if(strcmp(cmd, "/map_replace_spawn", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 4 ������");
         #if MAP_CHANGE_DATA == true
         
         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "������ ������ �� ������� ���������. �����������: /map_replace_spawn [id_������]");
         val = strval(params);
         
         if(CurrentMap == -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��� ����� ������ �������� ������� ������");
		 if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ������ ������ ��� ����������");
         
         if( (val < 0) || (val >= MapSpawnsLoaded[CurrentMap])) return SendClientMessage(playerid, COLOR_GRAYTEXT, "������ ������ �� ������� ���������. ������: ������ � ����� �� �� ����������");
         
		 GetPlayerPos(playerid,P[0],P[1],P[2]);
		 GetPlayerFacingAngle(playerid,P[3]);
		 new IF;
		 format(str,sizeof(str),"%s/%d.ini",MAPS_FOLDER,CurrentMap);
		 IF = ini_openFile(str);
		 format(cmd,sizeof(cmd),"%.f,%.f,%.f,%.f",P[0],P[1],P[2],P[3]);
		 new spawnkey[10];
		 format(spawnkey, sizeof(spawnkey), "spawn_%d", val);
		 ini_setString(IF,spawnkey,cmd);
		 ini_closeFile(IF);
		 
		 MapSpawnPos[CurrentMap][val][0] = P[0];
		 MapSpawnPos[CurrentMap][val][1] = P[1];
		 MapSpawnPos[CurrentMap][val][2] = P[2];
		 MapSpawnPos[CurrentMap][val][3] = P[3];
		 format(str,sizeof(str),"������������� %s ������� ������� ������ [%d] ��� ������� �����",GetName(playerid), val);
		 MessageToAdmins(str);//+���������� � ��������
		 
		 #else
		 SendClientMessage(playerid, COLOR_GRAYTEXT, "���� MAP_CHANGE_DATA ��������");
		 #endif
		 return 1;
	}
	if(strcmp(cmdtext, "/map_set_vault", true) == 0)
	{
         if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 4 ������");
         #if MAP_CHANGE_DATA == true
         if(CurrentMap == -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��� ����� ������ ������ ������� �������");
		 if(S[playerid] != 2 || MarkerActiv)return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ������ ������ ��� ����������");
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
		 format(str,sizeof(str),"������������� %s ������� ������� ������� ��� ������� �����",GetName(playerid));
		 MessageToAdmins(str);//+���������� � ��������
		 #else
		 SendClientMessage(playerid, COLOR_GRAYTEXT, "���� MAP_CHANGE_DATA ��������");
		 #endif
		 return 1;
	}
	//KillInfection
	if(strcmp(cmd, "/acmd", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 1 ������");
		 SendClientMessage(playerid,COLOR_GREEN,"������� ��������������:");
         if(Player_AdminLevel[playerid] >= 1 )SendClientMessage(playerid,-1,"[1]: /goto,/gethere,/mute, /kick");
         if(Player_AdminLevel[playerid] >= 2 )
		 {
		    SendClientMessage(playerid,-1,"[2]: /tp, /ban,/exploder,/slap,/ahuman,/azombie,");
		    SendClientMessage(playerid,-1,"[2]: /warn,/unmute,/aduty,/adutyoff,/specplayer,/specoff,/nextarena");
		 }
         if(Player_AdminLevel[playerid] >= 3 )SendClientMessage(playerid,-1,"[3]: /killinfect, /resetskilltime, /sethours");
         if(Player_AdminLevel[playerid] >= 4 )SendClientMessage(playerid,-1,"[4]: /end,/setadm,/gmx, /map_spawnlist, /map_remove_spawn, /map_add_spawn, /map_goto_spawn, /map_replace_spawn, /map_set_vault");
	     return 1;
	}

    if(strcmp(cmd, "/end", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");
         if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ��������");
		 EndArena(END_REASON_ADMIN_STOP);
		 format(str,sizeof(str),"������������� %s ��������� �����",GetName(playerid));
         MessageToAdmins(str);//+���������� � ��������
	     return 1;
	}
	if(strcmp(cmd, "/gmx", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 4 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 3 ������");
		 format(str,sizeof(str),"������������� %s ������������� ������",GetName(playerid));
		 SendClientMessageToAll(COLOR_YELLOW,str);
		 EndArena(-1);
		 format(str,sizeof(str),"������������� %s ������������ ������",GetName(playerid));
         WriteLog(ADMINLOG,str);
         SendRconCommand("gmx");
	     return 1;
	}
    if(strcmp(cmd, "/ahuman", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /ahuman [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
	     if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ���������");
	     if(Player_CurrentTeam[val] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� ��� �������");
		 SetHuman(val);
	     format(str,sizeof(str),"������������� %s ������ ��������� ������ %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     
	     if( Infection_Time > 0)
	     {
	        SendClientMessageToAll(COLOR_RED,"��������� ����������!");
	     	Infection_Time = 0; // ������ ���������, ��� �������
     	 }
	     ReCountPlayers();
	     return 1;
	}
	if(strcmp(cmd, "/azombie", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /azombie [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
	     if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ���������");
	     if(Player_CurrentTeam[val] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� ��� �����");
	     if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ������ ������ ��� ����������");
		 SetZombie(val);
	     format(str,sizeof(str),"������������� %s ������ ����� ������ %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     
	     if( Infection_Time > 0)
	     {
	        SendClientMessageToAll(COLOR_RED,"��������� ����������!");
	     	Infection_Time = 0; // ������ ���������, ��� �������
     	 }
	     ReCountPlayers();
	     return 1;
	}

    if(strcmp(cmd, "/exploder", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 3 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /exploder [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
	     if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ���������");
		 GetPlayerPos(val,P[0],P[1],P[2]);
		 CreateExplosion(P[0],P[1],P[2],0,4.0);

	     format(str,sizeof(str),"������������� %s ������� ������ %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     return 1;
	}

    if(strcmp(cmd, "/goto", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 1 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /goto [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
	     if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ���������");
		 GetPlayerPos(val,P[0],P[1],P[2]);
		 AC_SetPlayerPos(playerid,P[0]+1,P[1],P[2]);

	     format(str,sizeof(str),"������������� %s ���������������� � ������ %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     return 1;
	}
    if(strcmp(cmd, "/gethere", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 1 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 1 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /gethere [id]");
         val = strval(params);
	     if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
	     if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ���������");
		 GetPlayerPos(playerid,P[0],P[1],P[2]);
		 AC_SetPlayerPos(val,P[0]+1,P[1],P[2]);

	     format(str,sizeof(str),"������������� %s �������������� � ���� ������ %s",GetName(playerid),GetName(val));
	     SendClientMessageToAll(COLOR_BROWN,str);
	     WriteLog(ADMINLOG,str);
	     return 1;
	}

    if(strcmp(cmd, "/slap", true) == 0)
	{
		 if(Player_AdminLevel[playerid] < 2 )return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ������ 2 ������");

         params = strtokForCmd(cmdtext, idx);
         if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /slap [id][�������]");
         val = strval(params);
         params = strrest(cmdtext, idx);
         if(!strlen(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /slap [id][�������]");
         if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
         if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ���������");
         GetPlayerPos(val,P[0],P[1],P[2]);
		 AC_SetPlayerPos(val,P[0],P[1],P[2]+10);
	     format(str,sizeof(str),"������������� %s ��� ����� ������ %s. �������: %s",GetName(playerid),GetName(val),params);
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
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  Player_IsKill[playerid] = true;
		  
		  SendDeathMessage(playerid,playerid,8);
		  OnPlayerKilledPlayer(playerid, playerid, 8);
		  
		  ClearAnimations(playerid);
		  SetPlayerHealthEx(playerid,0);
		  
		  SendClientMessage(playerid,COLOR_RED,"�� ������� ��������� � �����");
		  
		  format(cmd,100,"%s �������� � ����� ��������� \"%s\"",GetName(playerid),cmdtext);
		  WriteLog(KILLLOG,cmd);
		  return 1;
    }
    
    if (strcmp("/bw", cmdtext, true, 10) == 0)
    {
  		  if(Player_ZombieProfession[playerid] != ZOMBIE_PROF_BUMER || Player_CurrentTeam[playerid] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �����");
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		  if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT,MESSAGE_WAIT_SPAWN);
		  if(Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] != 0)
		  {
				format(str,sizeof(str),"����������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]]);
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
          if(Player_ZombieProfession[playerid] != ZOMBIE_PROF_TANK || Player_CurrentTeam[playerid] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ����");
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		  if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  if(Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] != 0)
		  {
				format(str,sizeof(str),"����������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		  }
		  if(isFall(playerid)) // ���������� �� �����
		  {
		        SendClientMessage(playerid, COLOR_GRAYTEXT, "������: �� �������");
		        return 1;
		  }
		  ClearAnimations(playerid);
		  ApplyAnimation(playerid,"KNIFE","Knife_G",4.1,0,1,1,600,1);//��� ����-�� ������� ������
		  new rangid = Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]];
	      Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] = zombie_class_gromila[rangid][zm_rang_special2];
	      SaveAccount(playerid);
	      SetTimerEx("EffectTank",TIME_TO_ACTIVE_RAMP,0,"i",playerid);
	      return 1;
    }
    
    if (strcmp("/rush", cmdtext, true, 10) == 0)
    {
          if(Player_ZombieProfession[playerid] != ZOMBIE_PROF_JOKEY || Player_CurrentTeam[playerid] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �����");
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		  if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  if(Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] != 0)
		  {
				format(str,sizeof(str),"����������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]]);
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
				AC_SetPlayerPos(i,P[0]+1,P[1],P[2]);
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
		  SendClientMessage(playerid, COLOR_GRAYTEXT, "���� �� �������");
		  return 1;
    }
    if (strcmp("/explodebomb", cmdtext, true, 10) == 0)
    {
		  if(Player_HumanProfession[playerid] != HUMAN_PROF_SHTURMOVIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ���������");
          if(Bomb_Time[Player_MyBombId[playerid]] != BOMB_DETONATOR)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ������ ����� � �����������");
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		  if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  GameTextForPlayer(playerid,"~g~Bomb activated!",3000,5);
		  BangBomb(Player_MyBombId[playerid]);
		  return 1;
    }
    if (strcmp("/plant", cmdtext, true, 10) == 0)
    {
		  if(Player_HumanProfession[playerid] != HUMAN_PROF_SHTURMOVIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ���������");
		  if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		  if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		  if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		  if(Player_InMarker[playerid])return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ������ ����� ��������� ����� ����������");
		  if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] != 0)
		  {
				format(str,sizeof(str),"����������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		  }
		  if(Player_MyBombId[playerid] != -1)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� ��� ���������� �����. ��������� �� ������ ������ ��� ������� �����");
          if(isFall(playerid)) // ���������� �� �����
		  {
		        SendClientMessage(playerid, COLOR_GRAYTEXT, "������: �� �������");
		        return 1;
		  }
		  SetBomb(playerid);
		  return 1;
    }
    if (strcmp("/bar", cmdtext, true, 10) == 0 || strcmp("/barier", cmdtext, true, 10) == 0)//
	{
		if(Player_HumanProfession[playerid] != HUMAN_PROF_CREATER || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ���������");
        if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
        if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(Player_InMarker[playerid])return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ������ ����� ��������� ����������� ����������");
        new rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
		if(Object_idx[playerid] >= human_class_creater[rangid][rang_special])
		{
				format(str,sizeof(str),"�� ��������� ���� ����� �������� (%d). ����� ������������� ��� ������ ��������� �����",human_class_creater[rangid][rang_special]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		PlayerCreateObject(playerid);
		return 1;
	}
    if (strcmp("/krik", cmdtext, true, 10) == 0)//
	{
		if(Player_ZombieProfession[playerid] != ZOMBIE_PROF_VEDMA || Player_CurrentTeam[playerid] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ������");
		if(Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] != 0)
		{
				format(str,sizeof(str),"����������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
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
	 	      format(str,sizeof(str),""COL_RED"�� ���� �������� ������� %s. "COL_VALUE"������� ��������: %s. "COL_RULE"����� ����� �������� ���",GetName(playerid),Get_IL_Name(Player_IL[i]));
	 	      SendClientMessage(i,-1,str);
	 	      format(str,sizeof(str),""COL_EASY"����� %s ������� ������� � ����������� ������ �����",GetName(i));
	 	      SendClientMessage(playerid,-1,str);
	 	      GameTextForPlayer(i,"~r~SCREAM!",3000,5);
	 	      
		}
		Player_ZombieResetSkillTime[playerid][Player_ZombieProfession[playerid]] = zombie_class_vedma[rangid][zm_rang_special2];
		SaveAccount(playerid);
		return 1;
	}

    if (strcmp("/defence", cmdtext, true, 10) == 0)//
	{
 		if(Player_HumanProfession[playerid] != HUMAN_PROF_DEFENDER || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �������������");
		if(Player_DefenderGmTime[playerid] != 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����������� ��� ������������");
		if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] != 0)
		{
				format(str,sizeof(str),"����������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(Player_InMarker[playerid])return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ������ ����� ��������� ����������� ����������");
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(isFall(playerid)) // ���������� �� �����
	    {
		        SendClientMessage(playerid, COLOR_GRAYTEXT, "������: �� �������");
		        return 1;
		}
		new rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
		Player_DefenderOldHealth[playerid] = Player_RHealth[playerid];
        Player_DefenderGmTime[playerid] = human_class_defender[rangid][rang_special];
        SetPlayerHealthEx(playerid,50000);
        SetPlayerAttachedObject( playerid, 3, 18693, 6, 0.033288, 0.000000, -1.647527, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); //������ ����
        SetPlayerAttachedObject( playerid, 4, 18693, 5, 0.036614, 1.886157, 0.782101, 145.929061, 0.000000, 0.000000, 0.469734, 200.000000, 1.000000 ); //����� ����
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
		format(cmd,100,"%s �������� � ����� ��������� \"/likvid\"",GetName(playerid));
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
		if(Player_HumanProfession[playerid] != HUMAN_PROF_SNIPER || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �������");
		if(Player_Invisible[playerid] > 0)return SendClientMessage(playerid, -1,""COL_EASY"����� ����������� ��� �����������");
		if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] != 0)
		{
				format(str,sizeof(str),"����������� ����������� ��������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(Player_InMarker[playerid])return SendClientMessage(playerid, COLOR_GRAYTEXT, "� ������ ����� ��������� ����������� ����������");
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		new rangid = Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]];
		SendClientMessage(playerid, COLOR_GRAYTEXT, ""COL_LIGHTBLUE"����� ����������� �����������");
		HidePlayer(playerid);
		Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] = human_class_sniper[rangid][rang_special2];
		Player_Invisible[playerid] = human_class_sniper[rangid][rang_special];
		SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/cure", cmd, true, 10) == 0)//*���������
	{
		
        if(Player_HumanProfession[playerid] != HUMAN_PROF_MEDIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �����");
        if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] != 0)
		{
				format(str,sizeof(str),"����������� ������ �� �������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		params = strtokForCmd(cmdtext, idx);
        if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /cure [id]");
        val = strval(params);
        if(val == playerid)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� ��������� � ����");
        if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
        if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ���������");
		if(Player_IL[val] == 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ����� ��������");
		GetPlayerPos(playerid,P[0],P[1],P[2]);
		if(!IsPlayerInRangeOfPoint(val,CURE_HEAL_RADIUS,P[0],P[1],P[2]))return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ���� ����� ������� ������");
		KillInfection(val);
		format(str,sizeof(str),""COL_RULE2"����� %s ������ ��� ��������. �� ������ �� ������������.",GetName(playerid));
        SendClientMessage(val,-1,str);
        GameTextForPlayer(val,"~g~Cured!",2000,5);
        format(str,sizeof(str),"~g~Player %s successfully cured",GetName(val));
	    GameTextForPlayer(playerid,str,2000,5);
		Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special3];
		SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/cureme", cmdtext, true, 10) == 0)//*���������
	{
		// ��������������������
        if(Player_HumanProfession[playerid] != HUMAN_PROF_MEDIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �����");
        if(Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] != 0)
		{
				format(str,sizeof(str),"����������� ������ �� �������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		if(Player_IL[playerid] == 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ������������");
		KillInfection(playerid);
        SendClientMessage(playerid,-1,""COL_RULE2"�������� ����������. �� ������ �� ������������.");
        GameTextForPlayer(playerid,"~g~Cured!",2000,5);
		Player_HumanResetSkillTime[playerid][Player_HumanProfession[playerid]] = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special3];
		SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/healme", cmdtext, true, 10) == 0)//*���������
	{
		// �����������
        if(Player_HumanProfession[playerid] != HUMAN_PROF_MEDIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �����");
        if(Medik_ResetHealthTime[playerid] != 0)
		{
				format(str,sizeof(str),"��������� ������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Medik_ResetHealthTime[playerid]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		
		new max_health;
		max_health = GetMaxRangHealth(HUMAN,Player_HumanProfession[playerid],Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]) + Player_H_DopHealth[playerid][Player_HumanProfession[playerid]];

		if(Player_RHealth[playerid] >= max_health )
		{
                SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ���������� � �������");
                return 1;
        }
		
		new amount_hp; // ������� �� ����� �����������
		amount_hp = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special];
		new future_health; // ������� �� ����� ����� ��������������
		future_health = Player_RHealth[playerid] + amount_hp;
		new result; // ������� �� ������������� � ����������
		new infohealth; // ������� �� � �������� � �������������� �������
	 	if(	max_health < future_health) // ���� ���������������� �� ����� ������ ��� ���������
	 	{
				  // �� ��������� ������� �� ����� �� ���������
				  new ostatok;
				  ostatok = max_health - Player_RHealth[playerid];
				  result = ostatok + Player_RHealth[playerid];
				  infohealth = ostatok;
	 	}
	 	else // �� � ���� ���, �� ������ ���������
	 	{
	 	    result = Player_RHealth[playerid] + amount_hp;
	 	    infohealth = amount_hp;
	 	}
	 	
	 	SetPlayerHealthEx(playerid,result);

	 	format(str,sizeof(str),"�� ������� ������������ ���� %d Health Points",infohealth);
	 	SendClientMessage(playerid,-1,str);
	 	format(str,sizeof(str),"~g~Healed %d ~y~Health Points",infohealth);
	 	GameTextForPlayer(playerid,str,2000,5);
	 	Medik_ResetHealthTime[playerid] = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special2];
	 	SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/heal", cmd, true, 10) == 0)//*���������
	{

        if(Player_HumanProfession[playerid] != HUMAN_PROF_MEDIK || Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� �����");
        if(Medik_ResetHealthTime[playerid] != 0)
		{
				format(str,sizeof(str),"��������� ������� ��������������. �� ����� ������� ������������ �� ����� %d ���.",Medik_ResetHealthTime[playerid]);
                SendClientMessage(playerid, COLOR_GRAYTEXT, str);
				return 1;
		}
		
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(!Game_Started)return SendClientMessage(playerid, COLOR_GRAYTEXT, "���� ��� �� ��������");
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		params = strtokForCmd(cmdtext, idx);
        if(!isNumeric(params))return SendClientMessage(playerid, COLOR_GRAYTEXT, "�����������: /heal [id]");
        val = strval(params);
        if(val == playerid)return SendClientMessage(playerid, COLOR_GRAYTEXT, "������: /heal [id] ������������� ��� ������� ������ �������. ��� ����������� ����������� /healme");
        if(!IsPlayerConnected(val)) return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ������");
        if(S[val] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ���������");
        if(Player_CurrentTeam[playerid] != Player_CurrentTeam[val])return SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� �� ����� ��������");

        new max_health;
		max_health = GetMaxRangHealth(HUMAN,Player_HumanProfession[val],Player_HumanProfessionRang[val][Player_HumanProfession[val]]) + Player_H_DopHealth[val][Player_HumanProfession[val]];

		if( Player_RHealth[val] >= max_health )
		{
                SendClientMessage(playerid, COLOR_GRAYTEXT, "����� �� ��������� � �������");
                return 1;
        }
        
        GetPlayerPos(playerid,P[0],P[1],P[2]);
		if(!IsPlayerInRangeOfPoint(val,CURE_HEAL_RADIUS,P[0],P[1],P[2]))return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ���� ����� ������� ������");

        new amount_hp; // ������� �� ����� �����������
		amount_hp = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special];

        new future_health; // ������� �� ����� ����� ��������������
		future_health = Player_RHealth[val] + amount_hp;

		new result; // ������� �� ������������� � ����������
		new infohealth; // ������� �� � �������� � �������������� �������
	 	if( max_health < future_health ) // ���� ���������������� �� ����� ������ ��� ���������
	 	{
	 	          // �� ��������� ������� �� ����� �� ���������
				  new ostatok;
				  ostatok = max_health - Player_RHealth[val];
				  result = ostatok + Player_RHealth[val];
				  infohealth = ostatok;
	 	}
	 	else  // �� � ���� ���, �� ������ ���������
	 	{
        	result = Player_RHealth[val] + amount_hp;
        	infohealth = amount_hp;
	 	}
	 	SetPlayerHealthEx(val,result);
	 	
	 	format(str,sizeof(str),"����� %s ������� ����������� ��� %d Health Points",GetName(playerid),infohealth);
	 	SendClientMessage(val,-1,str);
	 	format(str,sizeof(str),"~g~Healed %d ~y~Health Points",infohealth);
	 	GameTextForPlayer(val,str,2000,5);
	 	format(str,sizeof(str),"%d Health Points ������� ������������� ������ %s",infohealth,GetName(val));
 		SendClientMessage(playerid,-1,str);
	 	Medik_ResetHealthTime[playerid] = human_class_medik[Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]][rang_special2];
	 	GameTextForPlayer(playerid,"~g~Player Healed",2000,5);
	 	SaveAccount(playerid);
		return 1;
	}
	if (strcmp("/infect", cmdtext, true, 10) == 0)//*���������
	{
        if(Player_CurrentTeam[playerid] != ZOMBIE)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�� �� ����� � �� ������ ��������");
		if(S[playerid] != 2)return SendClientMessage(playerid, COLOR_GRAYTEXT, MESSAGE_WAIT_SPAWN);
		if(Infection_Time > 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "��������� ��� �� ��������");
		
		if( Player_ZombieInfectTime[playerid] != 0)
		{
		    format(cmd, sizeof(cmd), "����������� �������� ������� ��������������. ��������� ��� %d ������(�, �)", Player_ZombieInfectTime[playerid]);
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
			        format(str,sizeof(str), "����� %s �������� ������� �� ���������", GetName(i));
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
	 	      format(str,sizeof(str),""COL_RED"�� ���� �������� ������� %s. "COL_VALUE"������� ��������: %s. "COL_RULE"����� ����� �������� ���",GetName(playerid),Get_IL_Name(Player_IL[i]));
	 	      SendClientMessage(i,-1,str);
	 	      GameTextForPlayer(i,"~r~Infection activated!",2000,5);
	 	      format(str,sizeof(str),"~g~Player %s infected successfully",GetName(i));
	          GameTextForPlayer(playerid,str,2000,5);
	          Player_ZombieInfectTime[playerid] = INFECTION_RESET_TIME;
	          hum++;
        }
		if(hum == 0)return SendClientMessage(playerid, COLOR_GRAYTEXT, "�������� ��� ��������� ������� ���������� ���");
		return 1;
	}
	SendClientMessage(playerid,-1,"����������� �������. ���������� /menu");
	return 1;
}

stock ReturnDefenderOldHP(playerid)
{
	 if(Player_DefenderGmTime[playerid] == 0)return 1;
     if(S[playerid] == 2)SetPlayerHealthEx(playerid,Player_DefenderOldHealth[playerid]);
     RemovePlayerAttachedObject(playerid, 3);//����� ������ ����
     RemovePlayerAttachedObject(playerid, 4);//����� �����
     Player_DefenderGmTime[playerid]= 0;
     SendClientMessage(playerid,-1,"����� ���������� ����������");
     return 1;
}

//�����
forward NextArenaGen();
public NextArenaGen(){//��������� ��������� �����
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
	if(!MarkerActiv)return SendClientMessage(playerid,COLOR_GRAY,"���� � ������� ������");
	if(Player_CurrentTeam[playerid] != HUMAN)return SendClientMessage(playerid,COLOR_GRAY,"�� �������� � �� ������ �������� � �������");
	SendClientMessage(playerid,COLOR_YELLOW,"�� ������� ��������! ����������� � ������� �� ����� ����� ����� �������� �������");
	GoToHome(playerid);
	//����� ��������: ���� ��� ���� ���� � ������� �� ���������� ����� � ���������� ������� (���� ������������� �������)
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
	//����������� ������������ � ����� ���
	FixPlayerSpetates(playerid); // ���� ���������
}

//������� � ���
enum VipDate{
	vip_srok,
	vip_price
}
//C��� - ����
static stock vip_date[][VipDate] ={
    { 1,26},
    { 2,42},
    { 7,116},
    { 30,272},
    { 90,524},
    { 180,777},
    { 360,1200},
    { -1,1500}
};
#define VIP_LINE 60
new VipDialog[VIP_LINE*sizeof(vip_date)];

stock CreateVipDialog(){
     new str[VIP_LINE];
	 for(new i; i < sizeof(vip_date); i++){
           if(vip_date[i][vip_srok] != -1)format(str,sizeof(str),""COL_LIME"[%d]"COL_RULE2"����: %d ���� - ���� %d ������\n",i+1,vip_date[i][vip_srok],vip_date[i][vip_price]);
		   else format(str,sizeof(str),""COL_LIME"[%d]"COL_RULE2"����: ���������� - ���� %d ������\n",i+1,vip_date[i][vip_price]);
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
		   if(!isFall(playerid)) // ���������� �� �����
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
				 if(val == INVALID_PLAYER_ID)return SendClientMessage(playerid,-1,""COL_EASY"�������� ������ �� ������, �������� ������ ������������ ��������.");
				 format(str,sizeof(str),"/heal %d",val);
                 OnPlayerCommandText(playerid, str);
		   }
	}
	if(newkeys & /*16384*/KEY_NO)//n
	{
		   if(Player_HumanProfession[playerid] == HUMAN_PROF_MEDIK && Player_CurrentTeam[playerid] == HUMAN)
		   {
				 val = GetPlayerTargetPlayer(playerid);
				 if(val == INVALID_PLAYER_ID)return SendClientMessage(playerid,-1,""COL_EASY"�������� ������ �� ������, �������� ������ �������� �� ��������.");
				 format(str,sizeof(str),"/cure %d",val);
                 OnPlayerCommandText(playerid, str);
		   }
	}
	if( newkeys == KEY_FIRE )
	{
		if(gSpectateID[playerid] != -1)
		{
			NextSpectate(playerid);
		}
	}
	if( newkeys == 128 ) // ���
	{
	    if(gSpectateID[playerid] != -1)
		{
			StartSpectate(playerid, gSpectateID[playerid]);
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
    if(!success) //������ ������������
    {
        printf("FAILED RCON LOGIN BY IP %s USING PASSWORD %s",ip, password);
        new pip[16], x;
        for(new i, s_b = MaxID; i <= s_b; i++) //Loop through all players
        {
            GetPlayerIp(i, pip, sizeof(pip));
            if(!strcmp(ip, pip, true)) //If a player's IP is the IP that failed the login
            {
                SendClientMessage(i, 0xFFFFFFFF, "������������ RCON ������. ������"); //Send a message
                BanEx(i, "RCON ������"); //They are now banned.
            }
            x = 1;
        }
        if( x != 1)
        {
            new str[40];
            format(str, sizeof(str), "banip %s", ip);
            SendRconCommand(str);
        }
    }
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
				SetPlayerHealth(playerid,1900);
			}
		}
		else
		{
		    SetPlayerHealth(playerid,50000);
		}
		OnAntiCheatUpdatePlayer(playerid, AC_TP_HACK_, -1); // ����� ���������� � �������
		OnAntiCheatUpdatePlayer(playerid, AC_FLYHACK_, 1); // ����� ������������ � �������
		// ������� �� �������
	}
    if(GetPVarInt(playerid, "PlayerInAFK") > -2)
	{
        if(GetPVarInt(playerid, "PlayerInAFK") > 2) SetPlayerChatBubble(playerid, "{FFFF00}���: {FFFFFF}���������", COLOR_WHITE, 20.0, 500);
        SetPVarInt(playerid, "PlayerInAFK", 0);
        if(PlayerNoAFK[playerid] == false)
        {
				 OnPlayerLeaveAfk(playerid);
        }
        AfkStartTime[playerid] = 0;
    }
	return 1;
}

forward  OnPlayerAfkStart(playerid);
public OnPlayerAfkStart(playerid)
{
	new str[100];
    //SetPlayerVirtualWorld(playerid, 10);
    PlayerNoAFK[playerid] = false;
    format(str,sizeof(str),"����� %s ���� � ���",GetName(playerid));
    SendClientMessageToAll(COLOR_LIGHTBLUE,str);
    if((Player_CurrentTeam[playerid] == HUMAN) && (S[playerid] == 2))
    {
				if( (Game_Started) && (!Player_InMarker[playerid])	)
				{
    				SendClientMessage(playerid,COLOR_RED,"�� ���� ���������� � ����� �� ��� �� �����");
				    SetZombie(playerid); //
				    //Player_CurrentTeam[playerid] = ZOMBIE;
				    //OnPlayerKilledPlayer(playerid, 65535, -1);
				    //Player_IsKill[playerid] = true;// - / _!_!
				    //SetPlayerHealthEx(playerid,0);
					//SpawnPlayer(playerid); // - / _!_!
				}
	}
	ReCountPlayers();
	return 1;
}

forward OnPlayerLeaveAfk(playerid);
public OnPlayerLeaveAfk(playerid)
{
    new str[66];
    //SetPlayerVirtualWorld(playerid, 0);
    format(str,sizeof(str),"����� %s �������� �� ���",GetName(playerid));
    SendClientMessageToAll(COLOR_LIGHTBLUE,str);
    PlayerNoAFK[playerid] = true;
    SpawnPlayer(playerid); //
    ReCountPlayers();
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

//===========[�������� �����]===========//
new AboutSturm[10][] = {
/*0*/    {"� ����������:\n"},
/*1*/    {"��������� � ������� ������ �������� �����.\n"},
/*2*/    {"���������� ������� ��� ������������� ��� ��������� ������� ����� � ��������� ���������� ����� � ����� � ����������� ������ ���������.\n"},
/*3*/    {"��������� �������������� � ������������� ��������� ����������, ���������� ��������� ������� ��� ��������� � �� ���������� � ����������� �����.\n"},
/*4*/    {"��� ������� �������� ����� ����������� �������� ��� ���� ����� ���������� � ������ �� ������, ��� ����� ������ ��������\n"},
/*5*/    {"���������� ��������� � ��������� ������� � �����������,\n"},
/*6*/    {"��� �������� �������� ��������� � ������������ ���������� ������� ��������� ����� � ������ �������� ������� �����.\n"},
/*7*/    {"�������������� � ��������� �������� �����������, ���������� ������������ ���������� �� �����.\n"},
/*8*/    {"������ �����������: ��������, ����������, ������, �������� ����� � �������� ��������\n"},
/*9*/    {"������� ����� ����������� ���������� ������� �����, � ������� ����, ��������� � ��������� ���������.����� ����������� ��������� �����.\n"}
};

new AboutMedik[6][] = {
/*0*/    {"� ������:\n"},
/*1*/    {"����� ��������� ����� ����� ����������� �� ����� ����� �����������.\n"},
/*2*/    {"������� ���� �������, ��� ������� ����� ������ �� ����� ������; ��������� �� ��� ���� �������� � ��������� �������������.\n"},
/*3*/    {"��� ���� ������������� �� ������ ����� ���������, �, ������� � 2040 ���� � ������ ������� ������, ������� ����������,\n"},
/*4*/    {"��������� � ����������� � ������ ������� � �����. ������� ������ ����������� ���: ������� �������� � ������� ��������.\n"},
/*5*/    {"������ �������: �������, �������� ���������, ��������� ����������� ����, ������� ����������� ����, ���������\n"}
};

new AboutSniper[9][] = {
/*0*/    {"� ��������:\n"},
/*1*/    {"���������� ��������� ������ (��������������� ������ �������), � ������������ ��������� ���������� ������ ��������,\n"},
/*2*/    {"���������� � ����������; �������� ����, ��� �������, � ������� ��������.\n"},
/*3*/    {"������ �������� � ��������� ���������� � �������� ��������, ������� ����������, ����������� ������ ������������,\n"},
/*4*/    {"����������, �������� � ��������������� ��������� ����� (��������� ������, ������� � ��.).\n"},
/*5*/    {"������� ����������� ����������� ��������� � ���������� �������� � ����� ������������ ������������,������������ ������������.\n"},
/*6*/    {"����� �������� ������� ��������� � 2040 ���� �� ����� ������� ��������� �����, ���������� �� ����. snipe � ������\n"},
/*7*/    {"(������ � ������� �����,����� �� ������� ������ ���,��� ���������� ������ ������ ��������������,� ������� ������ ����������� ����������).\n"},
/*8*/    {"����� ����������� ������. ������ ���������: �������, �������, ���������, ����������, ��������-�����"}
};


new AboutDef[5][] = {
/*0*/    {"� ���������:\n"},
/*1*/    {"����, � ������� ������ ���� ������, ���������� �����, ������, ������� � ������� ���������� ������ �� ����� ���� ���������� � ������ ����������.\n"},
/*2*/    {"��� ���������������� �������, ������� � ����� � �������������� ������ � ������� �����, ������ �������� �� ���������,\n"},
/*3*/    {"��� ����� ����������������� � �������. ����� ����������� �������� ���� � ������ �������������� ����������� � ������ ���� �����.\n"},
/*4*/    {"������ ����������: ����������, ���������, ��������, ������������, ���������������.\n"}
};

new AboutCreat[5][] = {
/*0*/    {"� ���������:\n"},
/*1*/    {"������-������������ ������ � ������������ � ����������� ����� ��������� ����������, �������� ����� � �������������,\n"},
/*2*/    {"��������������� ��� ���������� �������������� ��������,���� ������������� ��������. � ����������� �� ��������������\n"},
/*3*/    {"����� ���� ���������������� ��������������� ����������� ��� ����������� ��� ����������� ����� �����.\n"},
/*4*/    {"������ ����������: ����������, �������, �������, �������, �����������.\n"}
};

//===========[�������� �����]===========//
new AboutTank[6][] = {
/*0*/    {"� ������:\n"},
/*1*/    {"����� � �������� ����������� ����������, ���������� �������������� �����. �������� ������� � 1 �����, ������� ������� ���������,\n"},
/*3*/    {"�������� ����� ������� �� ������ ������: 5 ������� � 1000 ������ Health Points.\n"},
/*4*/    {"���� ����� ��������, �� �� ��� ���� �� ������ ��������. �� ������ �� ��������� � ���������� ����������� �������� � ���������.\n"},
/*5*/    {"����� ����������� ����� ���������� �� 4 �������, � ��� ����� �� ������� ����� ������ ������� � ����� � ������ ���� ���������� 4 ������.\n"},
/*6*/    {"�������� ��������, ��� ����� ���� ���� ����������� ����������� � ���� ����� ����� � ���������� ��� ����� ������ �� ����.\n"}
};

new AboutJokey[5][] = {
/*0*/    {"� �����:\n"},
/*1*/    {"����� � ������ � ������� ����������, ��������� ������ �������. �������, ������� �� ��������� � ������ ��� � ���,\n"},
/*2*/    {"����� ���� �������� �������� ��� ��������� ������ ������ �������. ����������� ����� ������ ����������, ��� ��� �� ����� ������ � �� ���������� �� ���.\n"},
/*3*/    {"������ �� ���������� ��������. ������������ ����������� �������� ��� �������� � ��� ������ � ������������ �������� ���������.\n"},
/*4*/    {"�������� ����� ������� �� ������ ������:5 ������� � 500 ������ Health Points.�� ��� ����� ������ �������� � ������� � ���������� ����������� �������� � ��������.\n"}
};

new AboutVedma[5][] = {
/*0*/    {"� ������:\n"},
/*1*/    {"������ � ���� �� ����� ������� ����������. ������ ������� ��������� � ���� ������.\n"},
/*2*/    {"�������� ������ ������� �� ������ ������: 5 ������� � 300 ������ Health Points.\n"},
/*3*/    {"������ ����� �������� ��������������� ����, ������� �������� �������������� �����, ������� � ������ �� ���� ������ �������.\n"},
/*4*/    {"�� ������������� ����������, ��� ��������� � ���������� ����������� ������� � ������.\n"}
};

new AboutBumer[6][] = {
/*0*/    {"� �������:\n"},
/*1*/    {"��������, �������, �������� �������� ����������,����������� ����������� ����������� (����������������, ��������� �������������).\n"},
/*2*/    {"������� ����� ��������� ������� �� ��������� ����������.\n"},
/*3*/    {"����� ��� ������� �������� �� ���������, ��� ���������� ��� ����������� � ����.\n"},
/*4*/    {"������� ����� ������������ �� ���� ���������. �������� ������ ������� �� ������ ������: 5 ������� � 600 ������ Health Points.\n"},
/*5*/    {"����� ��������� ��� ��������, ����������� ����������� �������.\n"}
};

//�������
new Rules[36][] = {
/*0*/    {"������� �������:\n"},
/*1*/    {"1. ������ ������ �������� ����������. �������������� ������������� ���������� �� ������������� �� ����������� �������� � ������������� �� ������������ �������.\n"},
/*2*/    {"����� ������ ���� ��������� �������������, ��� ���, ����������� ���������� � ������� ��������.\n"},
/*3*/    {"2. ����������� ����������������� ������� �� �������� ������������ ������� ��� �������������.\n"},
/*4*/    {"3. ������, �� ��������������� ������������� �� ����������� ����������������� �������, � ��� �� ����������� ���������� �� ��� � ������ ����������� ������ ��� ���.\n"},
/*5*/    {"4. ������������� �� ���� ������������ �������� ��������� ����������� ��������, �� ������� �������� �� ����.\n"},
/*6*/    {"4.1 ����������� ���������� ����������� e-mail ��� �����������. �������� � �������������� ������� ����� ���� ������� ��� ���������� ������.\n"},
/*7*/    {"4.2 ����� ���������� ������ ���� ������������, ��������� � �������������.\n"},
/*8*/    {"4.3 ������������� ��������������� � ������ ���������� �� �������������.\n"},
/*9*/    {"4.4. ������ ����� �������� ���������� ����������� �����. ������ ����� ����� ���������, ��������� ���������.\n"},
/*10*/    {"4.5 ��������� �����������, ����������, �������������� ��� �������� �������� �������� ����� ��� ������. ����� ��������� ����� ���� ������� ��� ��������������.\n"},
/*11*/    {"4.6 ������ �������� ����� ������ ��������������� �� ���, ��� ���� ������� ��-��� ��� ��������.\n"},
/*12*/    {"4.7 ��������� ���������� ������������� ��������, ����� ��� � �������� �������� ������� ����.\n"},
/*13*/    {"5.1 ��������� ��������� ����� ���� ��������, ������� ����� �������� ������� ������� ��� ��������� � ������������ ������ �������.\n"},
/*14*/    {"����� ��������� ��������� ���������� � ����� ���������.\n"},
/*15*/    {"5.2 ��������� ������������, ����������� ���������, �����������, ������, ��������������, ������, ����������� ��������������,\n"},
/*16*/    {"���������� ���������������, ������������ ��� ���������� ����� ��� ���.\n"},
/*17*/    {"5.3 ��������� �������� ���� �� ������������� �������.\n"},
/*18*/    {"5.4 ��������� ��������� � ������ ������� ����������, ������� ��� ������� ���������.\n"},
/*19*/    {"5.5 ��������� �������������� ��������� � ������������� �������. ����������� �������� ������������� ����������� ������ ����� �����.\n"},
/*20*/    {"5.6 ��������� ����������� ������, ������������� �� ������������� �������, ����� ��� � � ������ �������.\n"},
/*21*/    {"5.7 ��������� ����������� �������.\n"},
/*22*/    {"5.8 ��������� ��������������, �������� ��������� ������ ������� ��� ������������� �������.\n"},
/*23*/    {"5.9 �������� ���� � ����, ��������� �� ������ ����� � �������, ��������� ���� ���� � ������� ��������, ���������� ����� ������, ������� � �����������.\n"},
/*24*/    {"5.10 ������� � ��������/��������� ���� ���������������� ������� �����/������. ���������� ������ 5.2 ������ � ���� ������� �������������� �� ��������������.\n"},
/*25*/    {"5.11 ��������� ����� ���� �������������.\n"},
/*26*/    {"5.12 ��������� ������������� ��������, ����������� ����������� ������ � ���� ��� ���������� ���������� ���������������� ���������� ��.\n"},
/*27*/    {"��� ������ ��������������� ���������, ���������� ������ ���� ���������� ���, � ���������� ��� ����������� ������� ������� ���������� ��������.\n"},
/*28*/    {"5.13 ��������� ������ �� ����� � �������, ��� ��������� ������ ������� ���������� ����.\n"},
/*29*/    {"5.14 �� ������� ������������ ��������� ������ ������ �� ������, � ������� ���.���������, � ����������� ������ �������.\n"},
/*30*/    {"6.1 �������� �������� - �������� � ������� ������� ������ �� ����� ������������ �� ��� �����������. ����� ���� ��������� �� ���� ��������� ������ �����.\n"},
/*31*/    {"6.2 �������� ��������� - �������� � ������� ������������� ��������� � ������� ������.\n"},
/*32*/    {"6.3 ��� �������� - ��������� ��� ���������� ������������ ������������� ��������. ����� ���� ��������� �� ���� ��������� ������ �����.\n"},
/*33*/    {"6.4 ����������� ��������� - ������ ��� ��������� ����������� ��������� � ��������� ��� �� ���� ���������� ������������� ������.\n"},
/*34*/    {"6.5 ������������ ������� � ������������� ����������. ����� ���� ��������� �� ���� ��������� ������ �����.\n"},
/*35*/    {"6.6 ������ ��������.\n"}
};

//����� ����



new AboutYourGame[8][] = {
/*0*/    {"����� ����:\n"},
/*1*/    {"���������, �� ������������, ����� ������, ������� ��� ����� �� ������ �������? \n"},
/*2*/    {"����� ������� � ����� ������� �������� ���, �����, ���� ����������� ��������, ������������� �, ������� �� ����������� ��� ������ ��� ������.\n"},
/*3*/    {"������ ���������������� � ������������, �������� ������ ��������, �� ����� ��� �������.\n"},
/*4*/    {"����� �� �������� ����� ����������� ����������� �������, �� ������� �� ������ �������� �����.\n"},
/*5*/    {"�����������, � �������, �� ���������, ����� ���� �������� SA-MP.\n"},
/*6*/    {"����� � ����, ������ ���������� ����� �������� �������� - �������������������� ���. \n"},
/*7*/    {"����� �� ������� ������������ ������� \"������\", �������� ��� ������, ����� �� ����������� �������, ��������� � ����.\n"}
};

//�������� �������
new GeneralCommands[6][] = {
/*0*/    {"�������� �������:\n"},
/*1*/    {"/menu - ������� �������� ����\n"},
/*2*/    {"/shop - ������� �������\n"},
/*3*/    {"/pm - ��������� ������ ���������\n"},
/*4*/    {"/ignorepm - ������������� ����� ������ ��������� �� ������\n"},
/*5*/    {"/kill - ��������� � �����\n"}
};



stock About(playerid,teamid,profid)
{
	new bigbuffer[1110];
	switch(teamid){
		 case ZOMBIE:{
		     switch(profid){
		            case ZOMBIE_PROF_TANK:{
                            for(new i; i < sizeof(AboutTank); i++) strcat(bigbuffer,AboutTank[i]);
							ShowPlayerDialog(playerid,ABOUT_ZOMBIE_DIALOG,DIALOG_STYLE_MSGBOX,"� �����",bigbuffer,"�������","�����");
					}
					case ZOMBIE_PROF_JOKEY:{
                            for(new i; i < sizeof(AboutJokey); i++) strcat(bigbuffer,AboutJokey[i]);
							ShowPlayerDialog(playerid,ABOUT_ZOMBIE_DIALOG,DIALOG_STYLE_MSGBOX,"� �����",bigbuffer,"�������","�����");
					}
					case ZOMBIE_PROF_VEDMA:{
                            for(new i; i < sizeof(AboutVedma); i++) strcat(bigbuffer,AboutVedma[i]);
							ShowPlayerDialog(playerid,ABOUT_ZOMBIE_DIALOG,DIALOG_STYLE_MSGBOX,"� ������",bigbuffer,"�������","�����");
					}
					case ZOMBIE_PROF_BUMER:{
                            for(new i; i < sizeof(AboutBumer); i++) strcat(bigbuffer,AboutBumer[i]);
							ShowPlayerDialog(playerid,ABOUT_ZOMBIE_DIALOG,DIALOG_STYLE_MSGBOX,"� ������",bigbuffer,"�������","�����");
					}
			 }
		 }
		 case HUMAN:{
			 switch(profid){
					case HUMAN_PROF_SHTURMOVIK:{
                            for(new i; i < sizeof(AboutSturm); i++) strcat(bigbuffer,AboutSturm[i]);
							ShowPlayerDialog(playerid,ABOUT_HUMAN_DIALOG,DIALOG_STYLE_MSGBOX,"� ����������",bigbuffer,"�������","�����");
					}
					case HUMAN_PROF_MEDIK:{
                            for(new i; i < sizeof(AboutMedik); i++) strcat(bigbuffer,AboutMedik[i]);
							ShowPlayerDialog(playerid,ABOUT_HUMAN_DIALOG,DIALOG_STYLE_MSGBOX,"� ������",bigbuffer,"�������","�����");
					}
					case HUMAN_PROF_SNIPER:{
							for(new i; i < sizeof(AboutSniper); i++) strcat(bigbuffer,AboutSniper[i]);
							ShowPlayerDialog(playerid,ABOUT_HUMAN_DIALOG,DIALOG_STYLE_MSGBOX,"� ��������",bigbuffer,"�������","�����");
					}
					case HUMAN_PROF_DEFENDER:{
                            for(new i; i < sizeof(AboutDef); i++) strcat(bigbuffer,AboutDef[i]);
							ShowPlayerDialog(playerid,ABOUT_HUMAN_DIALOG,DIALOG_STYLE_MSGBOX,"� ���������",bigbuffer,"�������","�����");
					}
					case HUMAN_PROF_CREATER:{
					        for(new i; i < sizeof(AboutCreat); i++) strcat(bigbuffer,AboutCreat[i]);
							ShowPlayerDialog(playerid,ABOUT_HUMAN_DIALOG,DIALOG_STYLE_MSGBOX,"� ���������",bigbuffer,"�������","�����");
					}
			 }
		 }
	}
}

stock OpenAgeDialog(playerid,title[]="������� ��� �������")
{
	ShowPlayerDialog(playerid,AGE_DIALOG,DIALOG_STYLE_INPUT,title,"������� ��� �������� �������","����","");
	return 1;
}


stock OpenAcceptRegister(playerid)
{
	 new str[128];
	 new buffer[300];
	 format(str,sizeof(str),""COL_RULE"��� �������� ������� - "COL_EASY"%d ",Player_Age[playerid]);
	 strcat(buffer,str);
	 format(str,sizeof(str),""COL_RULE"\n��������� �������� - "COL_EASY"%s ",GetProfName(HUMAN,Player_HumanProfession[playerid]));
	 strcat(buffer,str);
	 format(str,sizeof(str),""COL_RULE"\n��������� ����� - "COL_EASY"%s ",GetProfName(ZOMBIE,Player_ZombieProfession[playerid]));
	 strcat(buffer,str);
	 format(str,sizeof(str),""COL_RULE"\n����������� e-mail - "COL_EASY"%s ",Player_Email[playerid]);
	 strcat(buffer,str);
	 ShowPlayerDialog(playerid,ACCEPT_REGISTER_DIALOG,DIALOG_STYLE_MSGBOX,"������������� ������",buffer,"�������","��������");
	 return 1;
}

stock OpenVotePanel(playerid)
{
	 new str[200];
	 if(VotePlayerID == -1)ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"����������� �� ��� ������","������� �� ������ ��� ������������ ��� ��������","�����","�����");
	 else
	 {
			format(str,sizeof(str),"����������� �� �������� ������ %s\n�� ��������� ����������� �������� %d ������\n�� ��� ������������� %d �� ������ %d �������\n��������� �� �������� ����� ������?",GetName(VotePlayerID),VoteTime,VoteZa,VoteNeed);
			ShowPlayerDialog(playerid,MENU_KICK_VOTE_DIALOG_VOTE,DIALOG_STYLE_MSGBOX,"����������� �������",str,"��","���");
	 }
	 return 1;
}


stock OpenRules(playerid,list)
{
	 if(list == 0){
			 //������� ������ ��������� ������
			 ShowPlayerDialog(playerid,MENU_RULES_D,DIALOG_STYLE_MSGBOX,"������� �������: �������� 1",Rules_Dialog[0],"�������� 2","� ����");
	 }
	 else{
			 //������� ������ ��������� ������
			 ShowPlayerDialog(playerid,MENU_RULES_D2,DIALOG_STYLE_MSGBOX,"������� �������: �������� 2",Rules_Dialog[1],"�������� 1","� ����");
	 }
	 return 1;
}


stock CreateRulesDialog(listid) // ������� ������ � ���������
{
	switch(listid) // ��������
	{
	    case 0:
	    {
	        for(new i; i < (sizeof(Rules)/2); i++) strcat(Rules_Dialog[0],Rules[i]);
	    }
	    case 1:
		{
		    for(new i = (sizeof(Rules)/2); i < sizeof(Rules); i++)strcat(Rules_Dialog[1],Rules[i]);
		}
	}
	return 1;
}

stock OpenShop(playerid,title[]="�������")
{
	 ShowPlayerDialog(playerid,SHOP_DIALOG,DIALOG_STYLE_LIST,title,"������\n������\n������� �������\n�������� ���� ������� ���������\n���������� ���������\n�������� ��� ������� ���������","�����","�����");
	 return 1;
}
//������� � ������ ���� ����� � ��������
enum caps_picture{
    cap_srok,
    cap_price
}

//(-1 - ����������)
static stock shop_caps_table[][caps_picture] ={
{1,10},
{7,50},
{30,200},
{-1,500}
};

#define CAP_LINE_STR 70
new CapsDialog[CAP_LINE_STR*sizeof(shop_caps_table)];
stock CreateCapsDialog()
{
	  new str[CAP_LINE_STR];
	  for(new i; i < sizeof(shop_caps_table); i++){
	      if(shop_caps_table[i][cap_srok] != -1)format(str,sizeof(str),""COL_RULE"[%d]"COL_SERVER"���� - %d ����(-���,-��) - ���� %d ������\n",i+1,shop_caps_table[i][cap_srok],shop_caps_table[i][cap_price]);
	      else format(str,sizeof(str),""COL_RULE"[%d]"COL_SERVER"���� - ��������� - ���� %d ������\n",i+1,shop_caps_table[i][cap_price]);
		  strcat(CapsDialog,str);
	  }
	  return 1;
}

stock SetSrokShop(playerid,title[]="������ �����")
{
     ShowPlayerDialog(playerid,SHOP_CHOSEN_SROK_D,DIALOG_STYLE_LIST,title,CapsDialog,"�����","�����");
	 return 1;
}
stock OpenReplaceCapDialog(playerid)
{
	 new str[128],str2[20];
	 switch(GetPVarInt(playerid,"ChosenCap"))
	 {
		   case RED_CAP: str = "�������";
		   case BLUE_CAP: str = "�����";
		   case LIGHTBLUE_CAP: str = "�������";
	 }
	 switch(Player_Cap[playerid])
	 {
		   case RED_CAP: str2 = "�������";
		   case BLUE_CAP: str2= "�����";
		   case LIGHTBLUE_CAP: str2 = "�������";
	 }
	 format(str,sizeof(str),"� ��� ��� ���� %s �����.\n������� ������ ������ ������� ��� ������.\n�� ������������� ������ ������ %s �����?",str2,str);
     ShowPlayerDialog(playerid,SHOP_ACCEPT_BUY_CAP,DIALOG_STYLE_MSGBOX,"�������������",str,"�����������","�����");
	 return 1;
}
stock AcceptBuyCapD(playerid)
{
	 new str[200],str2[20];
	 if(GetPVarInt(playerid,"ChosenCapSrok") == -1)str = "��������";
	 else format(str,sizeof(str),"�� %d ����(-���,-��)",GetPVarInt(playerid,"ChosenCapSrok"));
	 switch(GetPVarInt(playerid,"ChosenCap"))
	 {
		   case RED_CAP: str2 = "�������";
		   case BLUE_CAP: str2 = "�����";
		   case LIGHTBLUE_CAP: str2 = "�������";
	 }
	 format(str,sizeof(str),"�� ������� ��� ������ ������ %s ����� %s �� %d ������?",str2,str,GetPVarInt(playerid,"TruePrice"));
	 ShowPlayerDialog(playerid,SHOP_ACCEPT_BUY_CAP_TRUE,DIALOG_STYLE_MSGBOX,"����������� �������",str,"�����������","�����");
	 return 1;
}
stock BuyCap(playerid)
{
	 new str[200],str2[20],str3[25];
	 
	 if(GetPVarInt(playerid,"ChosenCapSrok") == -1)str3 = "��������";
	 else format(str3,sizeof(str3),"�� %d ����(-���,-��)",GetPVarInt(playerid,"ChosenCapSrok"));

	 switch(GetPVarInt(playerid,"ChosenCap"))
	 {
		   case RED_CAP: str2 = "�������";
		   case BLUE_CAP: str2 = "�����";
		   case LIGHTBLUE_CAP: str2 = "�������";
	 }
	 new srok = gettime();
	 Player_Rub[playerid] -= GetPVarInt(playerid,"TruePrice");
	 if(GetPVarInt(playerid,"ChosenCapSrok") == -1)Player_CapSrok[playerid] = -1;
	 else Player_CapSrok[playerid] = gettime()+(86400*GetPVarInt(playerid,"ChosenCapSrok"));
	 Player_Cap[playerid] = GetPVarInt(playerid,"ChosenCap");
	 SaveAccount(playerid);
	 format(str,sizeof(str),"�� ������� ������ %s �����\n���� �������: %s\n����� ������ %s\n���� ������� - %d RUB\n������� �� �������!",str2,date("%dd.%mm.%yyyy � %hh:%ii:%ss",srok-(UNIX_TIME_CORRECT)),str3,GetPVarInt(playerid,"TruePrice"));
	 ShowPlayerDialog(playerid,SHOP_CAP_BUYED,DIALOG_STYLE_MSGBOX,"����������",str,"�����","");
	 
	 format(str,sizeof(str),"%s ����� %s ����� ������ %s �� %d ������",GetName(playerid),str2,str3,GetPVarInt(playerid,"TruePrice"));
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

stock OpenRepliceGun(playerid,slotid,title[]="������ ������")
{
	 new str[200];
	 format(str,sizeof(str),"������������� ������:\n�� ��� ������ %s � ����� ����� � ��������� �������\n������� %s ������� ���� �������� ������\n�� ������������� ������?",WeaponNames[Player_Gun[playerid][slotid]],WeaponNames[GetPVarInt(playerid,"ChosenGun")]);
	 ShowPlayerDialog(playerid,CHOSEN_GUN_REPLACE_D,DIALOG_STYLE_MSGBOX,title,str,"�����������","��������");
	 return 1;
}



stock OpenAcceptGun(playerid,title[]="������������� �������")
{
	 new str[200],price,srok[25];
	 if(GetPVarInt(playerid,"ChosenValute") == RUB){str = "RUB";price = GetPVarInt(playerid,"ChosenGunPriceRub");}
	 else {str = "ZM";price = GetPVarInt(playerid,"ChosenGunPriceZm");}
	 
	 if(GetPVarInt(playerid,"ChosenSrok") == -1)srok = "��������";
	 else format(srok,sizeof(srok),"�� %d ����(-���,-��)",GetPVarInt(playerid,"ChosenSrok"));
	 //"ChosenAmmo"
	 format(str,sizeof(str),"������������� �������:\n������: %s\n���������� ��������: %d\n����: %d %s\n���������� %s\n�� ������������� �������?",
	 WeaponNames[GetPVarInt(playerid,"ChosenGun")],
     GetPVarInt(playerid,"ChosenAmmo"),
     price,
     str,
     srok);
	 ShowPlayerDialog(playerid,CHOSEN_GUN_ACCEPT_D,DIALOG_STYLE_MSGBOX,title,str,"�����������","�����");
	 return 1;
}

stock OpenBuyedGunGun(playerid)
{
	 new str[200],price,srok[25],log[100];
	 if(GetPVarInt(playerid,"ChosenValute") == RUB){str = "RUB";price = GetPVarInt(playerid,"ChosenGunPriceRub");}
	 else {str = "ZM";price = GetPVarInt(playerid,"ChosenGunPriceZm");}

	 if(GetPVarInt(playerid,"ChosenSrok") == -1)srok = "��������";
	 else format(srok,sizeof(srok),"�� %d ����(-���,-��)",GetPVarInt(playerid,"ChosenSrok"));
	 format(log,sizeof(log),"%s ����� %s(� %d) ������ %s �� %d %s",
	 GetName(playerid),
	 WeaponNames[GetPVarInt(playerid,"ChosenGun")],
	 GetPVarInt(playerid,"ChosenAmmo"),
	 srok,
	 price,
	 str);
	 WriteLog(BUYLOG,log);
	 
	 //"ChosenAmmo"
	 format(str,sizeof(str),"���������� � �������:\n������: %s\n���������� ��������: %d\n����: %d %s\n����������� %s\n���� �������: %s\n������� �� �������!",
	 WeaponNames[GetPVarInt(playerid,"ChosenGun")],
     GetPVarInt(playerid,"ChosenAmmo"),
     price,
     str,
     srok,
	 date("%dd.%mm.%yyyy � %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT)));
	 ShowPlayerDialog(playerid,CHOSEN_GUN_ACCEPT_D_22,DIALOG_STYLE_MSGBOX,"������� ���������",str,"�����","");
	 
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


//��������
stock CreateKarabinsDialog(){
     new str[SHOP_GUNS_DIALOG_LINE_SIZE];
	 for(new i; i < sizeof(shop_karabins_table); i++){
		   format(str,sizeof(str),""COL_LIME"[%d]"COL_YELLOW"%s - ����������: %d - %dRub",i+1,WeaponNames[shop_karabins_table[i][gun_iden]],shop_karabins_table[i][gun_ammo],shop_karabins_table[i][gun_rubprice]);
           strcat(Karabins_Dialog,str);
		   if(shop_karabins_table[i][gun_zmprice] != -1){
			   format(str,sizeof(str),"/%d ZM",shop_karabins_table[i][gun_zmprice]);
			   strcat(Karabins_Dialog,str);
		   }
		   if(shop_karabins_table[i][gun_srok] == -1){
               strcat(Karabins_Dialog," - ��������\n");
               continue;
		   }
		   format(str,sizeof(str)," - �� %d ����\n",shop_karabins_table[i][gun_srok]);
		   strcat(Karabins_Dialog,str);
	 }
	 return 1;
}

//���������

stock CreateShotgunsDialog(){
     new str[SHOP_GUNS_DIALOG_LINE_SIZE];
	 for(new i; i < sizeof(shop_shotguns_table); i++){
		   format(str,sizeof(str),""COL_LIME"[%d]"COL_YELLOW"%s - ����������: %d - %dRub",i+1,WeaponNames[shop_shotguns_table[i][gun_iden]],shop_shotguns_table[i][gun_ammo],shop_shotguns_table[i][gun_rubprice]);
           strcat(Shotguns_Dialog,str);
		   if(shop_shotguns_table[i][gun_zmprice] != -1){
			   format(str,sizeof(str),"/%d ZM",shop_shotguns_table[i][gun_zmprice]);
			   strcat(Shotguns_Dialog,str);
		   }
		   if(shop_shotguns_table[i][gun_srok] == -1){
               strcat(Shotguns_Dialog," - ��������\n");
               continue;
		   }
		   format(str,sizeof(str)," - �� %d ����\n",shop_shotguns_table[i][gun_srok]);
		   strcat(Shotguns_Dialog,str);
	 }
	 return 1;
}


//���������

stock CreatePistolsDialog(){
     new str[SHOP_GUNS_DIALOG_LINE_SIZE];
	 for(new i; i < sizeof(shop_pistols_table); i++){
		   format(str,sizeof(str),""COL_LIME"[%d]"COL_YELLOW"%s - ����������: %d - %dRub",i+1,WeaponNames[shop_pistols_table[i][gun_iden]],shop_pistols_table[i][gun_ammo],shop_pistols_table[i][gun_rubprice]);
           strcat(Pistols_Dialog,str);
		   if(shop_pistols_table[i][gun_zmprice] != -1){
			   format(str,sizeof(str),"/%d ZM",shop_pistols_table[i][gun_zmprice]);
			   strcat(Pistols_Dialog,str);
		   }
		   if(shop_pistols_table[i][gun_srok] == -1){
               strcat(Pistols_Dialog," - ��������\n");
               continue;
		   }
		   format(str,sizeof(str)," - �� %d ����\n",shop_pistols_table[i][gun_srok]);
		   strcat(Pistols_Dialog,str);
	 }
	 return 1;
}

//��������

stock CreateAvtomatsDialog(){
     new str[SHOP_GUNS_DIALOG_LINE_SIZE];
	 for(new i; i < sizeof(shop_avtomats_table); i++){
		   format(str,sizeof(str),""COL_LIME"[%d]"COL_YELLOW"%s - ����������: %d - %dRub",i+1,WeaponNames[shop_avtomats_table[i][gun_iden]],shop_avtomats_table[i][gun_ammo],shop_avtomats_table[i][gun_rubprice]);
           strcat(Avtomats_Dialog,str);
		   if(shop_avtomats_table[i][gun_zmprice] != -1){
			   format(str,sizeof(str),"/%d ZM",shop_avtomats_table[i][gun_zmprice]);
			   strcat(Avtomats_Dialog,str);
		   }
		   if(shop_avtomats_table[i][gun_srok] == -1){
               strcat(Avtomats_Dialog," - ��������\n");
               continue;
		   }
		   format(str,sizeof(str)," - �� %d ����\n",shop_avtomats_table[i][gun_srok]);
		   strcat(Avtomats_Dialog,str);
	 }
	 return 1;
}

stock OpenChoseGun(playerid,listitem)
{
     SetPVarInt(playerid,"ChosenGunClass",listitem);
	 switch(listitem){
		   case GUN_PISTOLS:ShowPlayerDialog(playerid,SHOP_GUN_DIALOG_PISTOLS,DIALOG_STYLE_LIST,"���������",Pistols_Dialog,"�������","�����");
		   case GUN_AVTOMATS:ShowPlayerDialog(playerid,SHOP_GUN_AVTOMATS_D,DIALOG_STYLE_LIST,"��������",Avtomats_Dialog,"�������","�����");
		   case GUN_SHOTGUNS:ShowPlayerDialog(playerid,SHOP_GUN_SHOTGUNS_D,DIALOG_STYLE_LIST,"���������",Shotguns_Dialog,"�������","�����");
		   case GUN_MASHINEGUNS:ShowPlayerDialog(playerid,SHOP_GUN_KARABINS_D,DIALOG_STYLE_LIST,"��������� ��������",Karabins_Dialog,"�������","�����");
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
                      SendClientMessage(playerid,-1,"��� ��������� ����� ��� ������ �� ��������� ����� �������");
				 }
          }

	 }
     if(Player_IsVip[playerid] > 0)
     {
		  if(gettime() >= Player_IsVip[playerid])
		  {
                   RemoveVip(playerid);
                   SendClientMessage(playerid,-1,"���� ������������� ������� �������� �����");
		  }
     }
     for(new i; i < MAX_SLOTS; i++)
	 {
		  if(Player_GunSrok[playerid][i] < 1)continue;
		  if(gettime() >= Player_GunSrok[playerid][i])
		  {
				format(str,100,"��������� ���� %s ��� ������ �� ��������� ����� ��������",WeaponNames[Player_Gun[playerid][i]]);
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

    ShowPlayerDialog(playerid,SHOP_GUNS_D,DIALOG_STYLE_LIST,"������ ������","���������\n��������\n���������\n��������� ��������","�������","�����");
	return 1;
}

stock OpenVipAccept(playerid,title[]= "������������� �������")
{
	 new str[100];
	 if(GetPVarInt(playerid,"VipSrok") != -1)format(str,sizeof(str),"����: %d RUB\n����: %d ����\n������ ������� �������?",GetPVarInt(playerid,"VipPrice"),GetPVarInt(playerid,"VipSrok"));
	 else format(str,sizeof(str),"����: %d RUB\n����: ����������\n������ ������� �������?",GetPVarInt(playerid,"VipPrice"));
	 ShowPlayerDialog(playerid,SHOP_VIP_ACCEPT_D,DIALOG_STYLE_MSGBOX,title,str,"������","�����");
	 return 1;
}

//������ ��� �� � ����
stock GiveVip(playerid,srok)
{
    if(srok != -1)Player_IsVip[playerid] = gettime()+(86400*srok);
    else Player_IsVip[playerid] = -1;
	SaveAccount(playerid);
	return 1;
}

//������ ����� ���������� ������ ������
stock GiveShopGuns(playerid)
{
	for(new i; i < MAX_SLOTS; i++)
	{
	      if(Player_Gun[playerid][i] == 0)continue;
		  GivePlayerWeapon(playerid,Player_Gun[playerid][i],Player_Ammo[playerid][i]);
    }
	return 1;
}

//������ ������ � ���� ������ ������� �����, �������� ����������
stock HideEffectsAndStartGame(playerid)
{
       SetPVarInt(playerid,"Logged",1);
       TextDrawHideForPlayer(playerid, TD_LoadScreen);
       TextDrawHideForPlayer(playerid, CreatedBy);
       
       //������� ������
       SetPlayerSpawnInArea(playerid,CurrentMap); // ��������� ������
       SpawnPlayer(playerid);
       return 1;
}

//���� http://pawno.ru/showthread.php?31281-%C1%E0%ED-%ED%E0-%E2%F0%E5%EC%FF-%F1-%E8%F1%EF%EE%EB%FC%E7%EE%E2%E0%ED%E8%E5%EC-unix-%E2%F0%E5%EC%E5%ED%E8
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
		  case DIALOG_AUDIOSTREAM:
		  {
				if(!response) return OpenGMenu(playerid);
				if(strcmp(AUDIOSTREAM_URL, "NONE", true) == 0)
				{
                    OpenRadioDialog(playerid, "����� �������� ����������");
					return 1;
				}
				switch(listitem)
				{
				    case 0: // ��� �����
				    {
				        PlayAudioStreamForPlayer(playerid,AUDIOSTREAM_URL);
				        OpenRadioDialog(playerid, "�� �������� ����� �������");
				    }
				    case 1: // ���� �����
				    {
				        StopAudioStreamForPlayer(playerid);
				        OpenRadioDialog(playerid, "�� ��������� ����� �������");
				    }
					case 2: // �������� ������
					{
					    ShowPlayerDialog(playerid, DIALOG_RADIO_SENDHELLO, DIALOG_STYLE_INPUT, "�������� ������", "������� ����� �������", "��������", "�����");
					}
					case 3: // �������� �����
					{
					    ShowPlayerDialog(playerid, DIALOG_RADIO_CALLSONG, DIALOG_STYLE_INPUT, "�������� �����", "������� �������� �����", "��������", "�����");
					}
				}
		  }
		  case DIALOG_RADIO_CALLSONG:
		  {
		        if(!response)return OpenRadioDialog(playerid);
		        if(Player_MuteTime[playerid] != 0)return OpenRadioDialog(playerid),SendClientMessage(playerid,-1,MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC);
				if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_RADIO_CALLSONG, DIALOG_STYLE_INPUT, "�������� �����", "������� �������� �����", "��������", "�����");
  				if(GetPVarInt(playerid,"RadioMailFloodCallSong") > gettime())return ShowPlayerDialog(playerid, DIALOG_RADIO_CALLSONG, DIALOG_STYLE_INPUT, "�������� �����", "������: �� ������� ����� ����������� �����.\n\t���������� �����.\n������� �������� �����", "��������", "�����");
		        if(!IsValidText(inputtext))return ShowPlayerDialog(playerid,DIALOG_RADIO_CALLSONG,DIALOG_STYLE_INPUT,"�������� �����","������: � ������ ������� ����������� �������.\n\t���������� �����.\n������� �������� �����","��������","�����");
		        format(buff, 100, "RADIO CallSONG KulleR.su - %s", GetName(playerid));
		        format(bigbuffer, 200, "����� ����� \"%s\" �� ������ %s", inputtext, GetName(playerid));
				mail_send(playerid, RADIO_MAIL, buff, bigbuffer);
                SetPVarInt(playerid,"RadioMailFloodCallSong",gettime() + CALLSONG_ANTIFLOOD_TIME);
                OpenRadioDialog(playerid, "����� ���� ��������");
		  }
		  case DIALOG_RADIO_SENDHELLO:
		  {
		        if(!response)return OpenRadioDialog(playerid);
		        if(Player_MuteTime[playerid] != 0)return OpenRadioDialog(playerid),SendClientMessage(playerid,-1,MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC);
				if(!strlen(inputtext)) return ShowPlayerDialog(playerid, DIALOG_RADIO_SENDHELLO, DIALOG_STYLE_INPUT, "�������� ������", "������� ����� �������", "��������", "�����");
  				if(GetPVarInt(playerid,"RadioMailFloodSendHello") > gettime())return ShowPlayerDialog(playerid, DIALOG_RADIO_SENDHELLO, DIALOG_STYLE_INPUT, "�������� ������", "������: �� ������� ����� ����������� �������.\n\t���������� �����.\n������� ����� �������", "��������", "�����");
		        if(!IsValidText(inputtext))return ShowPlayerDialog(playerid,DIALOG_RADIO_SENDHELLO,DIALOG_STYLE_INPUT,"�������� ������","������: � ������ ������� ����������� �������.\n\t���������� �����.\n������� ����� �������","��������","�����");
		        format(buff, 100, "RADIO SendHELLO KulleR.su - %s", GetName(playerid));
		        format(bigbuffer, 200, "������ �� ������ %s: %s", GetName(playerid), inputtext);
				mail_send(playerid, RADIO_MAIL, buff, bigbuffer);
                SetPVarInt(playerid,"RadioMailFloodSendHello",gettime() + SENDHELLO_ANTIFLOOD_TIME);
                OpenRadioDialog(playerid, "������ ��� ���������");
		  }
		  case DIALOG_CHANGEMAP:
		  {
			    if(!response) return 1;
			    format(buff, 20, "/nextarena %d", listitem);
			    OnPlayerCommandText(playerid, buff);
		  }
		  case DIALOG_TRAINING_BOX: // ��������: ����������
		  {
				new tlist = GetPVarInt(playerid, "TrainingList");
				new tmode = GetPVarInt(playerid, "TrainingMode");
				if(!response)
				{
				    switch(tmode)
				    {
				        case TRAINING_MODE_REGISTER: // ����� ������ ������ � ������ �������� ��� �����������
				        {
						    switch(tlist)
						    {
						        case 1: return OpenTrainingList(playerid, 1, tmode); // �� ���� �������� ������ �������� �� ������ ��������
						        default: return OpenTrainingList(playerid, tlist-1, tmode); // ������� �� ���������� ��������
						    }
					    }
   						case TRAINING_MODE_MENUDIALOG: // ����� ������ ������ ��� ����
   						{
   						    OpenHelp(playerid);
   						    return 1;
   						}

				    }
				    return 1;
				}
				else
				{
				    switch(tmode)
				    {
				        case TRAINING_MODE_REGISTER: // ����� ����� ������ � ������ �������� ��� �����������
				        {
						    switch(tlist)
						    {
						        case MAX_TRAINING_LISTS:  // ��������� ��������
								{
								    CancelTraining(playerid); // ��� ����� �������� ��������
									return 1;
								}
						        default: return OpenTrainingList(playerid, tlist+1, tmode); // ����������� �� ��������� ��������
						    }
					    }
					    case TRAINING_MODE_MENUDIALOG: // ����� ����� ������ ��� ����
   						{
   						    OpenHelp(playerid);
   						    return 1;
   						}
				    }
				}
		  }
		  case DIALOG_TRAINING_CHOSE:
		  {
				if(!response) return OnPlayerSelectedTrainingPath(playerid, false);
				else OnPlayerSelectedTrainingPath(playerid, true);
		  }
		  case DIALOG_YOU_NEEDED_NEW_PROF_YES:return OpenProfessionChoseProfession(playerid,GetPVarInt(playerid,"ChosenTeam"));
		  case DIALOG_YOU_NEEDED_NEW_PROF:
		  {
		          if(!response)return OpenProfessionChoseProfession(playerid,GetPVarInt(playerid,"ChosenTeam"));
		          new price;
		          if(GetPVarInt(playerid,"ChosenTeam") == ZOMBIE)price = ZOMBIE_PROFESSIONS_PRICE;
	              else if(GetPVarInt(playerid,"ChosenTeam") == HUMAN)price = HUMAN_PROFESSIONS_PRICE;
		          if(Player_Rub[playerid] < price)return OpenProfessionChoseProfession(playerid,GetPVarInt(playerid,"ChosenTeam"),"� ��� ������������ ������");
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
									if(Game_Started && Infection_Time == 0)return OpenProfessionChoseProfession(playerid,ZOMBIE,"��������� ��� ��������");
                                    SwitchProfession(playerid,ZOMBIE,listitem);
                                    OpenProfessionChoseProfession(playerid,ZOMBIE,"��������� ����� ��������");
									return 1;
							  }
							  else
							  {
							        format(buff, sizeof(buff), "�� �� �������� ������ ����������\n�� ������ ������ �� ����� ������ ����� �� %d ������\n�� ������ ��������� �������?",ZOMBIE_PROFESSIONS_PRICE);
							  }
					   }
					   case HUMAN:{
                              if(Player_H_HaveProfession[playerid][listitem]){
                                    if(Game_Started && Infection_Time == 0)return OpenProfessionChoseProfession(playerid,HUMAN,"��������� ��� ��������");
                                    SwitchProfession(playerid,HUMAN,listitem);
                                    OpenProfessionChoseProfession(playerid,HUMAN,"��������� �������� ��������");
                                    return 1;
							  }
							  else
							  {
							    	format(buff, sizeof(buff), "�� �� �������� ������ ����������\n�� ������ ������ �� ����� ������ ����� �� %d ������\n�� ������ ��������� �������?",HUMAN_PROFESSIONS_PRICE);
							  }
					   }
				  }
				  ShowPlayerDialog(playerid,DIALOG_YOU_NEEDED_NEW_PROF,DIALOG_STYLE_MSGBOX,"�����������",buff,"������","�����");
		  }
		  case MENU_MYPROFS_CHOSE_TEAM:
		  {
				  if(!response)return OpenGMenu(playerid);
				  OpenProfessionChoseProfession(playerid,listitem);
		  }
		  //������� ������
		  case CHOSEN_GUN_ACCEPT_D:
		  {
				  if(!response)return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  if(GetPVarInt(playerid,"ChosenValute") == RUB && ( GetPVarInt(playerid,"ChosenGunPriceRub" ) > Player_Rub[playerid] ))return OpenAcceptGun(playerid,"������������ RUB!");
				  if(GetPVarInt(playerid,"ChosenValute") == ZM  && ( GetPVarInt(playerid,"ChosenGunPriceZm" ) > Player_Zm[playerid] ))return OpenAcceptGun(playerid,"������������ Zombie Money!");
                  OpenBuyedGunGun(playerid);
		  }
		  //������������� ������
		  case CHOSEN_GUN_REPLACE_D:
		  {
				  if(!response)return OpenGunShop(playerid);
				  OpenAcceptGun(playerid);
		  }
		  //����� ������
		  case SHOP_BUY_GUN_VALUTE_CHOSE_D:
		  {
				  if(!response)return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  SetPVarInt(playerid,"ChosenValute",listitem);
				  //������������� ������
				  if(Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] != 0)return OpenRepliceGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  //������������� �������
				  OpenAcceptGun(playerid);
		  }
		  case SHOP_BUY_PROFESSION_BUYED_D:return Open_ChoseProfessionClass(playerid,GetPVarInt(playerid,"ChosenTeam"));
		  case CHOSEN_GUN_ACCEPT_D_22: return OpenShop(playerid);
		  case SHOP_CAP_BUYED:return OpenShop(playerid);
		  //��������
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
				         //����� ������
				         ShowPlayerDialog(playerid,SHOP_BUY_GUN_VALUTE_CHOSE_D,DIALOG_STYLE_LIST,"����� ������","�����\nZombie Money","�������","�����");
				         return 1;
                  }
                  if(Player_Rub[playerid] < shop_karabins_table[listitem][gun_rubprice])return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass")),SendClientMessage(playerid,COLOR_RED,"� ��� ������������ RUB");
				  SetPVarInt(playerid,"ChosenValute",RUB);
				  //������������� ������
				  if(Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] != 0)return OpenRepliceGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  //������������� �������
				  OpenAcceptGun(playerid);
		  }
		  //�����
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
				         //����� ������
				         ShowPlayerDialog(playerid,SHOP_BUY_GUN_VALUTE_CHOSE_D,DIALOG_STYLE_LIST,"����� ������","�����\nZombie Money","�������","�����");
				         return 1;
                  }
                  if(Player_Rub[playerid] < shop_shotguns_table[listitem][gun_rubprice])return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass")),SendClientMessage(playerid,COLOR_RED,"� ��� ������������ RUB");
				  SetPVarInt(playerid,"ChosenValute",RUB);
				  //������������� ������
				  if(Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] != 0)return OpenRepliceGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  //������������� �������
				  OpenAcceptGun(playerid);
		  }
		  //���������� (��������)
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
				         //����� ������
				         ShowPlayerDialog(playerid,SHOP_BUY_GUN_VALUTE_CHOSE_D,DIALOG_STYLE_LIST,"����� ������","�����\nZombie Money","�������","�����");
				         return 1;
                  }
                  if(Player_Rub[playerid] < shop_avtomats_table[listitem][gun_rubprice])return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass")),SendClientMessage(playerid,COLOR_RED,"� ��� ������������ RUB");
				  SetPVarInt(playerid,"ChosenValute",RUB);
				  //������������� ������
				  if(Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] != 0)return OpenRepliceGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  //������������� �������
				  OpenAcceptGun(playerid);
		  }
		  //������
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
				         //����� ������
				         ShowPlayerDialog(playerid,SHOP_BUY_GUN_VALUTE_CHOSE_D,DIALOG_STYLE_LIST,"����� ������","�����\nZombie Money","�������","�����");
				         return 1;
                  }
                  if(Player_Rub[playerid] < shop_pistols_table[listitem][gun_rubprice])return OpenChoseGun(playerid,GetPVarInt(playerid,"ChosenGunClass")),SendClientMessage(playerid,COLOR_RED,"� ��� ������������ RUB");
				  SetPVarInt(playerid,"ChosenValute",RUB);
				  //������������� ������
				  if(Player_Gun[playerid][GetPVarInt(playerid,"ChosenGunClass")] != 0)return OpenRepliceGun(playerid,GetPVarInt(playerid,"ChosenGunClass"));
				  //������������� �������
				  OpenAcceptGun(playerid);
		  }
		  case SHOP_GUNS_D:
		  {
				  if(!response)return OpenShop(playerid);
				  OpenChoseGun(playerid,listitem);
		  }
		  //����� ������ � ������� ������
		  case SHOP_BUY_PROFESSION_CHOSE_PROF:
		  {
				  if(!response)return OpenProfBuy(playerid);
				  new price;
				  if(GetPVarInt(playerid,"ChosenTeam") == ZOMBIE)price = ZOMBIE_PROFESSIONS_PRICE;
	              else if(GetPVarInt(playerid,"ChosenTeam") == HUMAN)price = HUMAN_PROFESSIONS_PRICE;
				  if(Player_Rub[playerid] < price)return SendClientMessage(playerid,COLOR_GRAYTEXT,"� ��� ������������ ������!"),Open_ChoseProfessionClass(playerid,GetPVarInt(playerid,"ChosenTeam"));
				  switch(GetPVarInt(playerid,"ChosenTeam"))
				  {
						case ZOMBIE:
						{
							   if(Player_Z_HaveProfession[playerid][listitem])return SendClientMessage(playerid,COLOR_GRAYTEXT,"�� ��� �������� ������ ����������"),Open_ChoseProfessionClass(playerid,GetPVarInt(playerid,"ChosenTeam"));
                               Player_Z_HaveProfession[playerid][listitem] = true;
						}
						case HUMAN:
						{
							   if(Player_H_HaveProfession[playerid][listitem])return SendClientMessage(playerid,COLOR_GRAYTEXT,"�� ��� �������� ������ ����������"),Open_ChoseProfessionClass(playerid,GetPVarInt(playerid,"ChosenTeam"));
                               Player_H_HaveProfession[playerid][listitem] = true;
						}
				  }
				  SetPVarInt(playerid,"ChosenTeamClass",listitem);
				  Player_Rub[playerid] -= price;
				  SaveAccount(playerid);
				  OpenProfessionBuy(playerid);
				  ///Open_ChoseProfessionClass(playerid,GetPVarInt(playerid,"ChosenTeam"));
		  }
		  //����� ������� � ������� ������
		  case SHOP_BUY_PROFESSION_CHOSE_TEAM:
		  {
 				  if(!response)return OpenShop(playerid);
 				  SetPVarInt(playerid,"ChosenTeam",listitem);
 				  Open_ChoseProfessionClass(playerid,listitem);
		  }
		  case SHOP_DIALOG:
		  {
				  if(!response)
				  {
				  	  if( GetPVarInt(playerid, "ShopOpenMenu") == 1) return OpenGMenu(playerid); // ���� ��������� ����� ����
				  	  return 1;
		  		  }
				  switch(listitem)
				  {
					   //������
					   case 0:ShowPlayerDialog(playerid,SHOP_PROTECT_D,DIALOG_STYLE_LIST,"������","������� ����� - 2x ����� ��� ��������\n������� ����� - 2x ZM ��� ��������\n����� ������� - � ��� ��� ���������� ��������","����������","�����");
					   //�������
					   case 1:OpenGunShop(playerid);
					   //����
					   case 2:
					   {
							 if(Player_IsVip[playerid] != 0)return OpenShop(playerid,"�� ��� ������ �������");
							 ShowPlayerDialog(playerid,SHOP_VIP_D,DIALOG_STYLE_LIST,"���������� �������",VipDialog,"�������","�����");
					   }
					   //����
					   case 3: ShowPlayerDialog(playerid,SHOP_UPG_RANK,DIALOG_STYLE_LIST,"�������� ������ ������","���� - 50 RUB\n����� - 50 RUB","�������","�����");
					   //������ �����
					   case 4: OpenProfBuy(playerid);
					   //������ ��������
					   case 5:  ShowPlayerDialog(playerid,SHOP_BUY_HEALTH,DIALOG_STYLE_LIST,"�������� ������ ���������","�����\n����","�������","�����");
				  }
		  }
		  //������� ��
		  case SHOP_BUY_HEALTH_INFO:return OpenShop(playerid);
		  case SHOP_BUY_HEALTH_ACCEPT:
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_BUY_HEALTH_CHOSE_VALUTE,DIALOG_STYLE_LIST,"����� ������","�����\nZombie Money","�����","�����");
				  new price;
				  switch(GetPVarInt(playerid,"ChosenValute"))
	              {
		               case RUB:{
                             price =  GetPVarInt(playerid,"ChosenKolvo")*SHOP_HEALTH_PRICE_RUB;
                             if(Player_Rub[playerid] < price)return OpenAcceptBuyHealth(playerid,"� ��� ������������ �������");
                             Player_Rub[playerid] -= price;
					   } 
		               case ZM:{
		                     price = GetPVarInt(playerid,"ChosenKolvo")*SHOP_HEALTH_PRICE_ZM;
		                     if(Player_Zm[playerid] < price)return OpenAcceptBuyHealth(playerid,"� ��� ������������ �������");
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
				  if(!response)return ShowPlayerDialog(playerid,SHOP_BUY_HEALTH,DIALOG_STYLE_LIST,"�������� ������ ���������","�����\n����","�������","�����");
				  if(!isNumeric(inputtext) || strval(inputtext) < 1)return OpenBuyHealth(playerid,GetPVarInt(playerid,"ChosenTeam"));
				  new maxhp;
				  if(GetPVarInt(playerid,"ChosenTeam") == ZOMBIE)
				  {
				        maxhp = PLAYER_MAX_BUYED_HEALTH_FOR_ZOMBIE-Player_Z_DopHealth[playerid][Player_ZombieProfession[playerid]];
				        
						if( maxhp < strval(inputtext) )return OpenBuyHealth(playerid,GetPVarInt(playerid,"ChosenTeam")),SendClientMessage(playerid,-1,"�������� ����������");
				  }
				  else if(GetPVarInt(playerid,"ChosenTeam") == HUMAN)
				  {
				        maxhp = PLAYER_MAX_BUYED_HEALTH_FOR_HUMAN - Player_H_DopHealth[playerid][Player_HumanProfession[playerid]];
						if( maxhp < strval(inputtext) )return OpenBuyHealth(playerid,GetPVarInt(playerid,"ChosenTeam")),SendClientMessage(playerid,-1,"�������� ����������");
				  }
				  SetPVarInt(playerid,"ChosenKolvo",strval(inputtext));
				  ShowPlayerDialog(playerid,SHOP_BUY_HEALTH_CHOSE_VALUTE,DIALOG_STYLE_LIST,"����� ������","�����\nZombie Money","�����","�����");
		  }
		  case SHOP_BUY_HEALTH:
		  {
				  if(!response)return OpenShop(playerid);
				  SetPVarInt(playerid,"ChosenTeam",listitem);
				  OpenBuyHealth(playerid,listitem);
		  }
		  //������� ��: �����
		  //====================================
		  case SHOP_UPG_RANK:
		  {
				  if(!response)return OpenShop(playerid);
				  if(Player_Rub[playerid] < 50)return ShowPlayerDialog(playerid,SHOP_UPG_RANK,DIALOG_STYLE_LIST,"� ��� ������������ RUB","���� - 50 RUB\n����� - 50 RUB","�������","�����");
				  switch(listitem)
				  {
					   case 0:
					   {
							 if(Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]] >= 4)return ShowPlayerDialog(playerid,SHOP_UPG_RANK,DIALOG_STYLE_LIST,"� ������ ������ �� ������ ����. ����","���� - 50 RUB\n����� - 50 RUB","�������","�����");
							 UpgradeHumanRang(playerid,Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]+1);
							 buff = "�������";
					   }
					   case 1:
					   {
					         if(Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]] >= 4)return ShowPlayerDialog(playerid,SHOP_UPG_RANK,DIALOG_STYLE_LIST,"� ������ ������ �� ������ ����. ����","���� - 50 RUB\n����� - 50 RUB","�������","�����");
							 UpgradeZombieRang(playerid,Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]+1);
							 buff = "�����";
					   }
				  }
				  Player_Rub[playerid] -= 50;
				  format(bigbuffer,100,"%s ������� ���� %s ���� �� 50 ������",GetName(playerid),buff);
				  WriteLog(BUYLOG,bigbuffer);
				  ShowPlayerDialog(playerid,SHOP_UPG_RANK,DIALOG_STYLE_LIST,"���� ������� �������","���� - 50 RUB\n����� - 50 RUB","�������","�����");
		  }
		  case SHOP_VIP_ACCEPT_D:
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_VIP_D,DIALOG_STYLE_LIST,"���������� �������",VipDialog,"�������","�����");
				  if(Player_IsVip[playerid] != 0)return OpenVipAccept(playerid,"�� ��� ������ �������");
				  if(Player_Rub[playerid] < GetPVarInt(playerid,"VipPrice"))return OpenVipAccept(playerid,"� ��� ������������ RUB");
				  Player_Rub[playerid] -= GetPVarInt(playerid,"VipPrice");
				  GiveVip(playerid,GetPVarInt(playerid,"VipSrok"));
				  new str[128];
				  if(GetPVarInt(playerid,"VipSrok") != -1)
				  format(str,sizeof(str),"���������� � �������\n������� �������\n����: %d\n����: %d ����\n���� �������: %s",GetPVarInt(playerid,"VipPrice"),GetPVarInt(playerid,"VipSrok"),date("%dd.%mm.%yyyy � %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT)));
				  else format(str,sizeof(str),"���������� � �������\n������� �������\n����: %d\n����: ����������\n���� �������: %s",GetPVarInt(playerid,"VipPrice"),date("%dd.%mm.%yyyy � %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT)));

				  ShowPlayerDialog(playerid,SHOP_VIP_BUYED_D,DIALOG_STYLE_MSGBOX,"���������� � �������",str,"�����","");
				  
				  if(GetPVarInt(playerid,"VipSrok") != -1){
				     format(str,sizeof(str),"%s ����� �������-������� ������ �� %d ���� �� %d ������",
	                 GetName(playerid),
	                 GetPVarInt(playerid,"VipSrok"),
	                 GetPVarInt(playerid,"VipPrice"));
				  }
	              else{
				     format(str,sizeof(str),"%s ����� �������-������� �������� �� %d ������",
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
				  if(Player_Rub[playerid] < price)return ShowPlayerDialog(playerid,SHOP_VIP_D,DIALOG_STYLE_LIST,"� ��� ������������ RUB",VipDialog,"�������","�����");
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
						case 0: SetSrokShop(playerid,"���������� ������� �����");
						case 1: SetSrokShop(playerid,"���������� ������� �����");
						case 2: SetSrokShop(playerid,"���������� ����� �����");
				  }
				  
		  }
		  case SHOP_ACCEPT_BUY_CAP_TRUE:
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_PROTECT_D,DIALOG_STYLE_LIST,"������","������� ����� - 2x ����� ��� ��������\n������� ����� - 2x ZM ��� ��������\n����� ������� - � ��� ��� ���������� ��������","����������","�����");
				  if(GetPVarInt(playerid,"TruePrice") > Player_Rub[playerid])return SetSrokShop(playerid,"� ��� ������������ �����!");
				  BuyCap(playerid);
		  }
		  case SHOP_ACCEPT_BUY_CAP:
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_PROTECT_D,DIALOG_STYLE_LIST,"������","������� ����� - 2x ����� ��� ��������\n������� ����� - 2x ZM ��� ��������\n����� ������� - � ��� ��� ���������� ��������","����������","�����");
				  AcceptBuyCapD(playerid);
		  }
		  case SHOP_CHOSEN_SROK_D://�������� - ����
		  {
				  if(!response)return ShowPlayerDialog(playerid,SHOP_PROTECT_D,DIALOG_STYLE_LIST,"������","������� ����� - 2x ����� ��� ��������\n������� ����� - 2x ZM ��� ��������\n����� ������� - � ��� ��� ���������� ��������","����������","�����");

                  if(Player_Rub[playerid] < shop_caps_table[listitem][cap_price])return SetSrokShop(playerid,"� ��� ������������ RUB");
                  SetPVarInt(playerid,"ChosenCapSrok",shop_caps_table[listitem][cap_srok]);
                  SetPVarInt(playerid,"TruePrice",shop_caps_table[listitem][cap_price]);
				  if(Player_Cap[playerid] != 0)return OpenReplaceCapDialog(playerid);
                  AcceptBuyCapD(playerid);
				  return 1;
		  }
		  case MENU_KICK_VOTE_CHOSE_ID:
		  {
				  if(!response)return OpenGMenu(playerid);
				  if(Player_HourInGame[playerid] < MINHOURS_FORVOTE)return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"������: ���������� ����� ����� � ���� ������� ����","������� ������ ��� ������������ ��� ��������","�����","�����");
                  if(VotePlayerID != -1)return OpenVotePanel(playerid),SendClientMessage(playerid,COLOR_GRAY,"������: ����������� ��� ��������");
                  if(!isNumeric(inputtext))return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"����������� �� ��� ������","������� ������ ��� ������������ ��� ��������","�����","�����");
				  if(!IsPlayerConnected(strval(inputtext)))return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"����� �� ������","������� ������ ��� ������������ ��� ��������","�����","�����");
                  if( playerid == strval(inputtext) )return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"�� �� ������ ���������� �� ��� ����!","������� ������ ��� ������������ ��� ��������","�����","�����");
                  if( IsPlayerAdmin(strval(inputtext)) || Player_AdminLevel[strval(inputtext)] > 0 )return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"�� �� ������ ���������� �� ��� ������!","������� ������ ��� ������������ ��� ��������","�����","�����");
				  if((Humans+Zombies) < 3)return ShowPlayerDialog(playerid,MENU_KICK_VOTE_CHOSE_ID,DIALOG_STYLE_INPUT,"� ���� ������ 3 �������.","������� ������ ��� ������������ ��� ��������","�����","�����");
				  OpenVote(playerid,strval(inputtext));
		  }
		  case MENU_KICK_VOTE_DIALOG_VOTE:
		  {
				  if(!response)return OpenGMenu(playerid);
				  if(VotePlayerID == -1)return OpenVotePanel(playerid),SendClientMessage(playerid,COLOR_GRAY,"������: ����������� ������ ����� �����������");
				  PlayerVoted(playerid);
				  OpenGMenu(playerid);
		  }
		  //������� �����������
		  case LOGIN_DIALOG:
		  {
				  if(!response)return Kick(playerid);
				  if(!strlen(inputtext) || !IsValidText(inputtext))return OpenLogin(playerid,"������ �� ������");
				  if(strcmp(inputtext, Player_Password[playerid], true))return OpenLogin(playerid,"������ ������ �������");
				  OnPlayerLogin(playerid);  // �������� �� ������ ������

		  }
		  case REGISTER_DIALOG:
		  {
		          if(!response)return Kick(playerid);
		          if(strlen(inputtext) > MAX_PASS_LEGHT || strlen(inputtext) < MIN_PASS_LEGHT )return OpenRegister(playerid,"�������� ������ ������");
                  if(!GetNormalPassword(inputtext))return OpenRegister(playerid,"������ �������� ����������� �������");
				  strmid(Player_Password[playerid],inputtext,0,MAX_PASS_LEGHT+1);
				  OpenAgeDialog(playerid);
		  }
		  case DIALOG_ENTERMAIL:
		  {
                   if(!response) return ShowPlayerDialog(playerid,DIALOG_ENTERMAIL,DIALOG_STYLE_INPUT,"�������� ����","������� ��� ����������� e-mail","����","");
				   if(strlen(inputtext) < 1 || strlen(inputtext) > MAX_EMAIL_SIZE || !IsValidEmail(inputtext))return ShowPlayerDialog(playerid,DIALOG_ENTERMAIL,DIALOG_STYLE_INPUT,"�������� ����","������� ��� ����������� e-mail","����","");
				   strmid(Player_Email[playerid],inputtext,0,MAX_EMAIL_SIZE+1);
				   ShowPlayerDialog(playerid,DIALOG_HUMANPROFS_LIST,DIALOG_STYLE_LIST,"�������� ��������� ��������",HumanProf_D,"���������","");
		  }
		  case AGE_DIALOG:
		  {
		          if(!response)return OpenAgeDialog(playerid);
				  if(!isNumeric(inputtext))return OpenAgeDialog(playerid,"������������ ��������");
				  if(strval(inputtext) > 50 || strval(inputtext) < 10)return OpenAgeDialog(playerid,"������������ �������");
				  Player_Age[playerid] = strval(inputtext);
				  ShowPlayerDialog(playerid,DIALOG_ENTERMAIL,DIALOG_STYLE_INPUT,"�������� ����","������� ��� ����������� e-mail","����","");
				  //ShowPlayerDialog(playerid,DIALOG_HUMANPROFS_LIST,DIALOG_STYLE_LIST,"�������� ��������� ��������",HumanProf_D,"���������","");
		  }
		  case DIALOG_HUMANPROFS_LIST:
		  {
                  if(!response)return ShowPlayerDialog(playerid,DIALOG_HUMANPROFS_LIST,DIALOG_STYLE_LIST,"�������� ��������� ��������",HumanProf_D,"���������","");
				  Player_ChosenInt[playerid] = listitem;
				  About(playerid,HUMAN,listitem);
		  }
		  case ABOUT_HUMAN_DIALOG:
		  {
                  if(!response)return ShowPlayerDialog(playerid,DIALOG_HUMANPROFS_LIST,DIALOG_STYLE_LIST,"�������� ��������� ��������",HumanProf_D,"���������","");
                  Player_HumanProfession[playerid] = Player_ChosenInt[playerid];
                  ShowPlayerDialog(playerid,DIALOG_ZOMBIEPROFS_LIST,DIALOG_STYLE_LIST,"�������� ��������� �����",ZombieProf_D,"���������","");
		  }
		  case DIALOG_ZOMBIEPROFS_LIST:
		  {
		          if(!response)return ShowPlayerDialog(playerid,DIALOG_ZOMBIEPROFS_LIST,DIALOG_STYLE_LIST,"�������� ��������� �����",ZombieProf_D,"���������","");
		          Player_ChosenInt[playerid] = listitem;
				  About(playerid,ZOMBIE,listitem);
		  }
		  case ABOUT_ZOMBIE_DIALOG:
		  {
                  if(!response)return ShowPlayerDialog(playerid,DIALOG_ZOMBIEPROFS_LIST,DIALOG_STYLE_LIST,"�������� ��������� �����",ZombieProf_D,"���������","");
                  Player_ZombieProfession[playerid] = Player_ChosenInt[playerid];
                  OpenAcceptRegister(playerid);
		  }
		  case DIALOG_ENTER_FRIEND_NAME:  // ���� ����� ������, ������������� playerid �� ������
		  {
				  if(!response)return OnPlayerRegisted(playerid); // ��������� ����������� playerid
				  if(!strlen(inputtext) || !GNT(inputtext))return ShowPlayerDialog(playerid,DIALOG_ENTER_FRIEND_NAME,DIALOG_STYLE_INPUT,"������� �����","������� ������� �����, ������������� ��� �� ������","����","����������");
				  switch( OnPlayerInvitePlayer(playerid, inputtext) ) // ��������� �������� �� OnPlayerInvitePlayer � ������ ���������
				  {
						// �������� �� ������������� �������
						case CALLING_ACCOUNT_NOT_FOUND: return ShowPlayerDialog(playerid,DIALOG_ENTER_FRIEND_NAME,DIALOG_STYLE_INPUT,"������� �������� �� ����������","������� ������� �����, ������������� ��� �� ������","����","����������");
						// ��� ����, ��������� ����
						default: return OnPlayerRegisted(playerid); // ��������� ����������� playerid
				  }
		  }
		  case ACCEPT_REGISTER_DIALOG:  // �������� ����������� ���������, �� ����������� �� ���������. �������� ������ ��� �����, �� ��� ����������
		  {
				  if(!response)return OpenAgeDialog(playerid);
				  // �������� ���� ����� �����, ������� ��������� �� ������
				  ShowPlayerDialog(playerid,DIALOG_ENTER_FRIEND_NAME,DIALOG_STYLE_INPUT,"������� �����","������� ������� �����, ������������� ��� �� ������","����","����������");
		  }
		  //������� �����������: �����
		  //=============================================================================================
		  case MENU_DIALOG: // ������ � ���� (/menu)
		  {
				  if(!response)return 1;
				  switch(listitem)
				  {
						 case 0:OpenRules(playerid,0);// ������� �������
						 case 1:OpenHelp(playerid);// ������� ������
						 case 2:OpenStat(playerid,MENU_STAT_D); // ������� stat
						 case 3:OpenAdminD(playerid);// �������� admins
						 case 4:// ������� tituls
						 {
							  for(new i = 1; i < MAX_TITULS; i++)
							  {
								   format(buff,170,""COL_WHITE"%d. "COL_YELLOW"%s - "COL_LIME"��������: %s - "COL_EASY"����������: %d\n",i,GetTitulName(i),Tit_Name[i],Tit_Value[i]);
								   strcat(bigbuffer,buff);
							  }
							  ShowPlayerDialog(playerid,MENU_TITULS_D,DIALOG_STYLE_MSGBOX,"������ �������",bigbuffer,"�����","");
						 }
						 case 5:OpenVotePanel(playerid);//golosovan
						 case 6:SetPVarInt(playerid, "ShopOpenMenu", 1), OpenShop(playerid);//magaz
						 case 7:OpenMyProfs(playerid);//professii
						 case 8:OpenRadioDialog(playerid); // �����
		          }
          }
          case MENU_TITULS_D: return OpenGMenu(playerid);
		  case MENU_ADMINS_D: // ������� �������� � ��������������
		  {
				 if(!response)return OpenGMenu(playerid);
				 switch(listitem){
					 case 0:{
					       if(Player_IsVip[playerid] == 0)return OpenAdminD(playerid),SendClientMessage(playerid,COLOR_GRAY,"������ ��� �������-�������������");
                           // ������� ������ ������� ������
						   switch(GetAdminList(bigbuffer)){
						        // ���� ����������
								case 0: ShowPlayerDialog(playerid,MENU_ADMINS_D_LIST,DIALOG_STYLE_MSGBOX,"������������� ������","������������� ������ ���","�����",""); // ������� ���
								default: ShowPlayerDialog(playerid,MENU_ADMINS_D_LIST,DIALOG_STYLE_MSGBOX,"������������� ������",bigbuffer,"�����","");
						   }
					 }
					 case 1:ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"������","������� �� ���������� � ��� ����","����","�����");
					 case 2:ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_TO_MAIL,DIALOG_STYLE_INPUT,"������ �� �����","������� ���������� ������","���������","�����");
					 case 3:ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_AB_BUG,DIALOG_STYLE_INPUT,"����� �� ������","������� ������","����","�����");
					 case 4:ShowPlayerDialog(playerid,MENU_ADMINS_D_SUGGEST_ADMIN,DIALOG_STYLE_INPUT,"������ ��������������","������� ����� �������","����","�����");
				 }
		  }
		  case MENU_ADMINS_D_SUGGEST_ADMIN: // ������� �������� �������� ������
		  {
                 if(!response)return OpenAdminD(playerid);
                 if(Player_MuteTime[playerid] != 0)return OpenAdminD(playerid),SendClientMessage(playerid,-1,MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC);
                 if(!strlen(inputtext) || !IsValidText(inputtext))return ShowPlayerDialog(playerid,MENU_ADMINS_D_SUGGEST_ADMIN,DIALOG_STYLE_INPUT,"������ ��������������","������� ����� �������","����","�����");
                 InfoAdmins(playerid,inputtext);
                 OpenAdminD(playerid);
		  }
		  case MENU_ADMINS_D_REPORT_AB_BUG: // ������� �������� �������� � ����. ������ �� �����
		  {
  				 if(!response)return OpenAdminD(playerid);
  				 if(Player_MuteTime[playerid] != 0)return OpenAdminD(playerid),SendClientMessage(playerid,-1,MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC);
  				 if(GetPVarInt(playerid,"CmdFloodMail") > gettime())return OpenAdminD(playerid),SendClientMessage(playerid,-1,"���������� �����");
		         if(!strlen(inputtext) || !IsValidText(inputtext))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_AB_BUG,DIALOG_STYLE_INPUT,"����� �� ������","������� ������","����","�����");
                 InfoAdmins(playerid,inputtext);
                 
                 format(buff, 100, "ABOUT BUG KulleR.su - %s", GetName(playerid));
				 mail_send(playerid, MAIL_GENERAL, buff, inputtext);
                 
				 //SendMail(MAIL_GENERAL, "SaintsRow@Server", GetName(playerid), "ABOUT BUG SaintsRow", inputtext);
                 SetPVarInt(playerid,"CmdFloodMail",gettime() + FloodTimeMail);
				 OpenAdminD(playerid);
		         
		  }
		  case MENU_ADMINS_D_REPORT_TO_MAIL: // ������������ �� ����� ������
		  {
 				 if(!response)return OpenAdminD(playerid);
 				 if(Player_MuteTime[playerid] != 0)return OpenAdminD(playerid),SendClientMessage(playerid,-1,MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC);
 				 if(GetPVarInt(playerid,"CmdFloodMail") > gettime())return OpenAdminD(playerid),SendClientMessage(playerid,-1,"���������� �����");
 				 if(!strlen(inputtext) || !IsValidText(inputtext))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_TO_MAIL,DIALOG_STYLE_INPUT,"������ �� �����","������� ���������� ������","���������","�����");

				 format(buff, 100, "Report KulleR.su - %s", GetName(playerid));
				 mail_send(playerid, MAIL_GENERAL, buff, inputtext);
				  //SendMail(MAIL_GENERAL, "SaintsRow@Server", GetName(playerid), "Report SaintsRow", inputtext);
                 SetPVarInt(playerid,"CmdFloodMail",gettime() + FloodTimeMail);
 				 SendClientMessage(playerid,COLOR_YELLOW,"������ �� ����� ������������� ������� ����������");
 				 OpenAdminD(playerid);
		  }
		  case MENU_ADMINS_D_REPORT_INPUT_ID: // ������������ ������� �� ������ � �����.��
		  {
				 if(!response)return OpenAdminD(playerid);
				 if(!isNumeric(inputtext))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"������","������� �� ���������� � ��� ����","����","�����");
				 if(!IsPlayerConnected(strval(inputtext)))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"������","����� �� ������!\n������� �� ���������� � ��� ����","����","�����");
				 if(strval(inputtext) == playerid)return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"������","�� �� ������ ������������ �� ����!\n������� �� ���������� � ��� ����","����","�����");
                 if(Player_MuteTime[playerid] != 0)return OpenAdminD(playerid),SendClientMessage(playerid,-1,MESSAGE_YOU_ARE_MUTED_CANT_USE_THIS_FUNC);
				 Player_ChosenInt[playerid] = strval(inputtext);
				 ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_REASON,DIALOG_STYLE_INPUT,"������","������� ������� � ��� ����","����","�����");
		  }
		  case MENU_ADMINS_D_REPORT_INPUT_REASON: // ������ ������� ������ �� ������ � �����. ��
		  {
			     if(!response)return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"������","������� �� ���������� � ��� ����","����","�����");
			     if(!IsPlayerConnected(Player_ChosenInt[playerid]))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_ID,DIALOG_STYLE_INPUT,"������","��������� ���� ����� ����� �������� ����\n������� �� ���������� � ��� ����","����","�����");
			     if(!strlen(inputtext) || !IsValidText(inputtext))return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_REASON,DIALOG_STYLE_INPUT,"������","������� ������� � ��� ����","����","�����");
			     if(strlen(inputtext) > 64 )return ShowPlayerDialog(playerid,MENU_ADMINS_D_REPORT_INPUT_REASON,DIALOG_STYLE_INPUT,"������","������� ������� �������\n������� ������ ���� �� ������� 64 ��������\n������� ������� � ��� ����","����","�����");
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
					 case 0: OpenTrainingList(playerid, 1, TRAINING_MODE_MENUDIALOG); // ������
					 case 1: OpenTrainingList(playerid, 2, TRAINING_MODE_MENUDIALOG); // �������
					 case 2: OpenTrainingList(playerid, 3, TRAINING_MODE_MENUDIALOG); // ������� � �������
					 case 3: OpenTrainingList(playerid, 4, TRAINING_MODE_MENUDIALOG); // ����� ����
					 case 4: OpenTrainingList(playerid, 7, TRAINING_MODE_MENUDIALOG); // ����������
  	 	             case 5:{ // �������� �������� �������
                         for(new i; i < sizeof(GeneralCommands); i ++)strcat(bigbuffer,GeneralCommands[i]);
                         ShowPlayerDialog(playerid,MENU_MSGBUFFER_D,DIALOG_STYLE_MSGBOX,"������ ������",bigbuffer,"� ������","");
					 }
 	             }
          }
          case MENU_MSGBUFFER_D:return OpenHelp(playerid);
	}//ShowPlayerDialog(playerid,MENU_DIALOG,DIALOG_STYLE_LIST,"����","�������\n������\n����������\n�������������\n������ �������\n�����������\n������� �������","�������","�����");
	return 1;
}

stock CreateAboutYourGameDialog() // ������� ������ � ������ ����
{
    for(new i; i < sizeof(AboutYourGame); i ++)strcat(AboutYourGame_Dialog,AboutYourGame[i]);
	return 1;
}

stock OpenHelp(playerid)
{
	 ShowPlayerDialog(playerid,MENU_HELP_D,DIALOG_STYLE_LIST,"������ � ��������","��������::������\n��������::�������� �������\n��������::������� � �������\n��������::����� ����\n��������::����������\n������ ������","�������","�����");
	 return 1;
}
stock OpenProfBuy(playerid)
{
	 new str[128];
	 format(str,sizeof(str),"����� - %d RUB\n���� - %d RUB",ZOMBIE_PROFESSIONS_PRICE,HUMAN_PROFESSIONS_PRICE);
     ShowPlayerDialog(playerid,SHOP_BUY_PROFESSION_CHOSE_TEAM,DIALOG_STYLE_LIST,"�������� ������ ���������",str,"�������","�����");
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
	format(str,sizeof(str),"������ �� %s �� %s (%d) � ��������: %s",GetName(playerid), GetName(reportid), reportid ,reason);
	for(new i, s_b = MaxID; i <= s_b; i++)
	{
       	 if(!IsPlayerConnected(i))continue;
		 if(Player_AdminLevel[i] < 1 && !IsPlayerAdmin(i))continue;
		 SendClientMessage(i,COLOR_DARKRED,str);
	}
	format(str,sizeof(str),"������ �� %s ������� ���������� �������������",GetName(reportid));
	SendClientMessage(playerid,COLOR_YELLOW,str);
	return 1;
}

stock InfoAdmins(playerid,infotext[])
{
	new str[180];
	format(str,sizeof(str),"��������� ������������� �� %s (%d): %s",GetName(playerid), playerid, infotext);
	for(new i, s_b = MaxID; i <= s_b; i++)
	{
       	 if(!IsPlayerConnected(i))continue;
		 if(Player_AdminLevel[i] < 1 && !IsPlayerAdmin(i))continue;
		 SendClientMessage(i,COLOR_INFO,str);
	}
	SendClientMessage(playerid,COLOR_YELLOW,"��������� ������� ���������� �������������");
	return 1;
}

stock OpenAdminD(playerid)
{
     ShowPlayerDialog(playerid,MENU_ADMINS_D,DIALOG_STYLE_LIST,"�������������","������������� ������\n������\n������ �� �����\n����� �� ������\n������ ��������������","�������","�����");
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

//���������
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

/*
stock GetName(playerid){
	 new name[MAX_PLAYER_NAME];
	 GetPlayerName(playerid,name,MAX_PLAYER_NAME);
	 return name;
}
*/

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
    if(time < 60) format(string, sizeof(string), "%d ������", time);
    else if(time == 60) string = "1 ������";
    else if(time > 60 && time < 3600)
    {
        new Float: minutes;
        new seconds;
        minutes = time / 60;
        seconds = time % 60;
        format(string, sizeof(string), "%.0f ����� � %d ������", minutes, seconds);
    }
    else if(time == 3600) string = "1 ���";
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
stock TimeConverter(seconds)//��������� ������� � ������ � �������
{
        new string[6];//��������� ���������� ����������
        new minutes = floatround(seconds/60);//���. ����� �����
        seconds -= minutes*60;  //�������
        format(string, sizeof(string), "%02d:%02d", minutes, seconds);//���������������
        return string;//���������� ������ ��������
}


forward ReWriteArena(arenaid);
public ReWriteArena(arenaid)
{
	if( arenaid < 0 || arenaid >= Loaded_Maps ) return 1;
	// ������������ �����
	new IF, val;
	new path[90],buffer[256];
	format(path,sizeof(path),"%s/%d.ini",MAPS_FOLDER,arenaid);
	if(!fexist(path)) return 2;
	fremove(path);
	IF = ini_createFile(path);
	ini_setString(IF, "name", MapName[arenaid]);
	ini_setInteger(IF, "interior", MapInterior[arenaid]);
	if( MapHaveMarker[arenaid] ) val = 1;
	else val = 0;
	ini_setInteger(IF, "marker", val);
	for(new z = 0, key[10]; z < MapSpawnsLoaded[arenaid]; z ++) // ������ ������������
	{
	    format(buffer, sizeof(buffer), "%.f,%.f,%.f,%.f", MapSpawnPos[arenaid][z][0], MapSpawnPos[arenaid][z][1], MapSpawnPos[arenaid][z][2], MapSpawnPos[arenaid][z][3]);
	    format(key, sizeof(key), "spawn_%d", z);
	    ini_setString(IF, key, buffer);
	}
	format(buffer, sizeof(buffer), "%.f,%.f,%.f", MapMarkerPos[arenaid][0], MapMarkerPos[arenaid][1], MapMarkerPos[arenaid][2]);
	ini_setString(IF, "markerpos", buffer);
	ini_setString(IF,"object_fs",MapFS[arenaid]); // ������� � fs ��� �����
	ini_closeFile(IF);
	return 1;
}

forward LoadArenas();
public LoadArenas()
{
	   new IF;
	   Loaded_Maps = 0;
	   new ReWriteMapFlag = false; // ������ ����� ����� ��������������
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
			ini_getString(IF,"object_fs",MapFS[Loaded_Maps]); // ������� � fs ��� �����

			//MAX_MAP_SPAWN_POS
			// ������� ������
                //MapSpawnsLoaded
			if(ini_getString(IF, "spawn", buffer) != INI_KEY_NOT_FOUND) // ���������� ������ ����
			{
			        FloatBuff = strtokForBD(buffer, idx,',');
					MapSpawnPos[Loaded_Maps][0][0] = floatstr(FloatBuff);
					FloatBuff = strtokForBD(buffer, idx,',');
					MapSpawnPos[Loaded_Maps][0][1] = floatstr(FloatBuff);
					FloatBuff = strtokForBD(buffer, idx,',');
					MapSpawnPos[Loaded_Maps][0][2] = floatstr(FloatBuff);
					FloatBuff = strtokForBD(buffer, idx,',');
					MapSpawnPos[Loaded_Maps][0][3] = floatstr(FloatBuff);
					MapSpawnsLoaded[Loaded_Maps] ++;
					ReWriteMapFlag = true;
			}
			else
			{
				// ������� ������
				for(new z = 0, key[10], mspawn_cell; z < MAX_MAP_SPAWN_POS; z ++)
				{
				    format(key, sizeof(key), "spawn_%d", z);
					if(ini_getString(IF, key, buffer) == INI_KEY_NOT_FOUND)  break; // �������� ��������
					mspawn_cell = MapSpawnsLoaded[Loaded_Maps];
                    idx = 0;
					FloatBuff = strtokForBD(buffer, idx,',');
					MapSpawnPos[Loaded_Maps][mspawn_cell][0] = floatstr(FloatBuff);
					FloatBuff = strtokForBD(buffer, idx,',');
					MapSpawnPos[Loaded_Maps][mspawn_cell][1] = floatstr(FloatBuff);
					FloatBuff = strtokForBD(buffer, idx,',');
					MapSpawnPos[Loaded_Maps][mspawn_cell][2] = floatstr(FloatBuff);
					FloatBuff = strtokForBD(buffer, idx,',');
					MapSpawnPos[Loaded_Maps][mspawn_cell][3] = floatstr(FloatBuff);
					MapSpawnsLoaded[Loaded_Maps] ++;
				}
			}
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
			
	        ini_closeFile(IF);
	        printf("   ����� %d (%s) ���������. �������: %d ��",Loaded_Maps,MapName[Loaded_Maps], MapSpawnsLoaded[Loaded_Maps]);
	        
			
	        
	        Loaded_Maps ++;
	        
	        if( ReWriteMapFlag )
			{
				ReWriteArena(Loaded_Maps-1);
			    printf("  !����� %d (%s): ���������� ������ ������� �������. ����� ���� ������������",Loaded_Maps-1,MapName[Loaded_Maps-1], MapSpawnsLoaded[Loaded_Maps-1]);
			    ReWriteMapFlag = false;
			}
	   }
	   CreateMapsDialog(); // ������� ������ � �������
	   printf("   ���� ������� ��������� %d ����",Loaded_Maps);
       NextArenaId = 0;
}

new AutoMessages[7][] = {
/*0*/   {""COL_EASY"���� ���������� �� ������� ������ "COL_YELLOW"\"Y\""COL_EASY", ��� �� ������ ����� ��� ����������� �������"},
/*1*/   {""COL_WHITE"����� �������� �������� �� ����� ���� ������� � ���� � ������ ������ "COL_GREEN"ALT"},
/*2*/   {""COL_LIME"����� ��������� ������ ������ � ������ ������, ���������� ������ ������� "COL_EASY"N"},
/*3*/   {""COL_CYAN"��������� ���������� ����� ������ �� ������ "COL_LIME"***www.kuller.su***"},
/*4*/   {""COL_RULE"����� ������ ������, ����� ������������ "COL_RULE2"/menu - ������������� - ������ ������ ��������������"},
/*5*/   {""COL_EASY"����� � ������� ��������������� ������ ����� ����� "COL_YELLOW"www.kuller.su"},
/*6*/   {""COL_WHITE"������� ������� ��������� � ���� �� ������� ������ "COL_LIME"\"Y\""}
/*7*/   //{""COL_RULE"���������� � ����� ����� ���������� � "COL_GREEN"\"/buyrank\""}
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

// ~~~~~~~~~~~~~~~~~~~ ��������: ��������� � ���� ��� ������� ~~~~~~~~~~~~~~~~~~~
stock __ProfAndRank3D__CreateInformer(playerid){
		__T3D__ProfAndRankInf[playerid] = Create3DTextLabel(" ",-1,0.0,0.0,0.0,PrAnRaInf_TEXT_RAD,0,0);
		Attach3DTextLabelToPlayer(__T3D__ProfAndRankInf[playerid],playerid,0.0,0.0,PrAnRaInf_TEXT_HIGHT);
		return 1;
}
stock __ProfAndRank3D__DeleteInformer(playerid){
		Delete3DTextLabel(__T3D__ProfAndRankInf[playerid]);
		return 1;
}
stock __ProfAndRank3D__UpdateInformer(playerid){
		new bbbstr[40];
		switch(Player_CurrentTeam[playerid]){
			case HUMAN:
			{
			    if( Player_Invisible[playerid] > 0 ){
			        Update3DTextLabelText(__T3D__ProfAndRankInf[playerid],COLOR_RED," "); // disable
			        return 1;
			    }
				format(bbbstr,sizeof(bbbstr),PrAnRaInf_TEXT_STR,GetProfName(HUMAN,Player_HumanProfession[playerid]),Player_HumanProfessionRang[playerid][Player_HumanProfession[playerid]]+1);
				Update3DTextLabelText(__T3D__ProfAndRankInf[playerid],COLOR_GREEN,bbbstr);
				return 1;
			}
			case ZOMBIE:{
			    format(bbbstr,sizeof(bbbstr),PrAnRaInf_TEXT_STR,GetProfName(ZOMBIE,Player_ZombieProfession[playerid]),Player_ZombieProfessionRang[playerid][Player_ZombieProfession[playerid]]+1);
				Update3DTextLabelText(__T3D__ProfAndRankInf[playerid],COLOR_RED,bbbstr);
				return 1;
			}
			case ADMIN:{
			    Update3DTextLabelText(__T3D__ProfAndRankInf[playerid],COLOR_RED," "); // disable
			    return 1;
			}
		}
		return 1;
}

// ~~~~~~~~~~~~~ �������� � ��������� ~~~~~~~~~~~~~
new Text3D: __T3D__InfectText[MAX_PLAYERS];
stock __InfectText__CreateLabel(playerid){
     __T3D__InfectText[playerid] = Create3DTextLabel(" ",-1,0.0,0.0,0.0,INFECT_TEXT_RAD,0,0);
     Attach3DTextLabelToPlayer(__T3D__InfectText[playerid],playerid,0.0,0.0,INFECT_TEXT_HIGHT);
	 return 1;
}
stock __InfectText__DeleteLabel(playerid){
     Delete3DTextLabel(__T3D__InfectText[playerid]);
	 return 1;
}
stock __InfectText__RemoveLabelText(playerid){
     Update3DTextLabelText(__T3D__InfectText[playerid],-1,"");
	 return 1;
}
stock __InfectText__CreateLabelText(playerid,doptext[]){
	 new bbbstr[40];
	 format(bbbstr,sizeof(bbbstr),INFECT_TEXT_STR,doptext);
     Update3DTextLabelText(__T3D__InfectText[playerid],COLOR_RED,bbbstr);
	 return 1;
}
stock Get_IL_Name(IL){//������ �������� ������ ���������
	new str[15];
    switch(IL)
    {
		  	      case RED_MONITOR:str = "������";
		  	      case ONE_HP:str = "�������";
		  	      case TWO_HP:str = "�������";
		  	      case THREE_HP:str = "����� �������";
    }
    return str;
}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

//�������: ������� ���������
stock OpenMyProfs(playerid)
{
	ShowPlayerDialog(playerid,MENU_MYPROFS_CHOSE_TEAM,DIALOG_STYLE_LIST,"�������� �������","�����\n����","�����","�����");
	return 1;
}

stock Open_ChoseProfessionClass(playerid,teamid)
{
	switch(teamid)
	{
		   case HUMAN: ShowPlayerDialog(playerid,SHOP_BUY_PROFESSION_CHOSE_PROF,DIALOG_STYLE_LIST,"�������� ���������","���������\n�����\n�������\n��������\n���������","������","�����");
		   case ZOMBIE:  ShowPlayerDialog(playerid,SHOP_BUY_PROFESSION_CHOSE_PROF,DIALOG_STYLE_LIST,"�������� ���������","����\n�����\n������\n�����","������","�����");
	}
	return 1;
}

stock OpenProfessionBuy(playerid,dialogid=SHOP_BUY_PROFESSION_BUYED_D)
{
	new str[150],price;
	if(GetPVarInt(playerid,"ChosenTeam") == ZOMBIE)price = ZOMBIE_PROFESSIONS_PRICE;
	else if(GetPVarInt(playerid,"ChosenTeam") == HUMAN)price = HUMAN_PROFESSIONS_PRICE;
	format(str,sizeof(str),"���������� � �������:\n���������: %s\n����: %d ������\n���� ������������: %s\n������� �� �������!",
    GetProfName(GetPVarInt(playerid,"ChosenTeam"),GetPVarInt(playerid,"ChosenTeamClass")),
	price,
    date("%dd.%mm.%yyyy � %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT))
	);
	ShowPlayerDialog(playerid,dialogid,DIALOG_STYLE_MSGBOX,"���������� � �������",str,"�����","");


	format(str,sizeof(str),"%s ����� ��������� \"%s\" �� %d ������",
    GetName(playerid),
    GetProfName(GetPVarInt(playerid,"ChosenTeam"),GetPVarInt(playerid,"ChosenTeamClass")),
    price);
 	WriteLog(BUYLOG,str);
	return 1;
}

stock OpenProfessionChoseProfession(playerid,teamid,title[]="��� ���������")
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
    ShowPlayerDialog(playerid,MENU_MYPROFS_CHOSE_CLASS,DIALOG_STYLE_LIST,title,str,"�����������","�����");
	return 1;
}

//�������: ������� ��������������� �� ��� ����� ���������
stock OpenBuyHealth(playerid,teamid)
{
	 new str[200];
	 switch(teamid)
	 {
		 case ZOMBIE:{
	     format(str,sizeof(str),"������� ������ ��� ��������� �����\n���� ����� ����� - %d ZM ��� %d ������\n������� ���������: %s\n�� ������ ���������� ��� %d ������ ��������\n������� ���������� ���������� � ��� ����",
	     SHOP_HEALTH_PRICE_ZM,
	     SHOP_HEALTH_PRICE_RUB,
	     GetProfName(ZOMBIE,Player_ZombieProfession[playerid]),
	     PLAYER_MAX_BUYED_HEALTH_FOR_ZOMBIE-Player_Z_DopHealth[playerid][Player_ZombieProfession[playerid]]);}
		 case HUMAN:{
		 format(str,sizeof(str),"������� ������ ��� ��������� ��������\n���� ����� ����� - %d ZM ��� %d ������\n������� ���������: %s\n�� ������ ���������� ��� %d ������ ��������\n������� ���������� ���������� � ��� ����",
	     SHOP_HEALTH_PRICE_ZM,
	     SHOP_HEALTH_PRICE_RUB,
	     GetProfName(HUMAN,Player_HumanProfession[playerid]),
	     PLAYER_MAX_BUYED_HEALTH_FOR_HUMAN-Player_H_DopHealth[playerid][Player_HumanProfession[playerid]]);}
	 }
	 ShowPlayerDialog(playerid,SHOP_BUY_HEALTH_ENTER_KOLVO,DIALOG_STYLE_INPUT,"������� ����������",str,"����","�����");
	 return 1;
}
stock OpenAcceptBuyHealth(playerid,title[]="������������� �������")
{
	 new str[200],price,itog_kolvo,team,prof[20];
	 team = GetPVarInt(playerid,"ChosenTeam");
	 itog_kolvo = GetPVarInt(playerid,"ChosenKolvo");
	 switch(GetPVarInt(playerid,"ChosenValute"))
	 {
		   case RUB:{ price =  itog_kolvo*SHOP_HEALTH_PRICE_RUB;str = "������";}
		   case ZM:{ price = itog_kolvo*SHOP_HEALTH_PRICE_ZM;str = "Zombie Money";}
	 }
	 switch(team)
	 {
		   case HUMAN: prof =  "������� ���������";
		   case ZOMBIE: prof = "�����-���������";
	 }
	 format(str,sizeof(str),"������������� �������\n�������������� ��\n��������� ��� %s\n����������: %d ��.\n����: %d %s\n�� ������������� �������?",
	 prof,
	 itog_kolvo,
	 price,
	 str);
	 ShowPlayerDialog(playerid,SHOP_BUY_HEALTH_ACCEPT,DIALOG_STYLE_MSGBOX,title,str,"�����������","������");
	 return 1;
}
stock OpenBuyHealthInfo(playerid)
{
	 new str[200],price,itog_kolvo,team,prof[20];
	 team = GetPVarInt(playerid,"ChosenTeam");
	 itog_kolvo = GetPVarInt(playerid,"ChosenKolvo");
	 switch(GetPVarInt(playerid,"ChosenValute"))
	 {
		   case RUB:{ price =  itog_kolvo*SHOP_HEALTH_PRICE_RUB;str = "������";}
		   case ZM:{ price = itog_kolvo*SHOP_HEALTH_PRICE_ZM;str = "Zombie Money";}
	 }
	 switch(team)
	 {
		   case HUMAN: prof =  "������� ���������";
		   case ZOMBIE: prof = "�����-���������";
	 }
	 format(str,sizeof(str),"���������� � �������:\n�������������� ��\n��������� ��� %s\n����������: %d ��.\n����: %d %s\n���� �������: %s\n������� �� �������!",
	 prof,
	 itog_kolvo,
	 price,
	 str,
	 date("%dd.%mm.%yyyy � %hh:%ii:%ss",gettime()-(UNIX_TIME_CORRECT)));
	 ShowPlayerDialog(playerid,SHOP_BUY_HEALTH_INFO,DIALOG_STYLE_MSGBOX,"�� �������",str,"�����","");
	 return 1;
}

//�������� �� ���������� �����: �������� ��������
stock GNT(text[])
{
     for(new i; i < strlen(text);i++)//����� ������ by Lik
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
  ���������:
  - ������������ ����� �� ������
  - ���������
  - ���� ��������
  - ������������ �����
  - ����� ���
  �������:
  - �������
  - �������
  - ��������
  - ���������
  - �������
  - ���������
  - ��������
*/

public OnVehicleStreamIn(vehicleid, forplayerid)
{
    MessageToAdmins("��������! ��������� ��������� ���������. �� ����� ������");
	DestroyVehicle(vehicleid);
	return 1;
}

//������� ��������************************
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
		printf ("   %d ����������� ����� ���������.", ForbiddenWeaponsCount);
		return 1;
	}
	else print ("   �� ������ ���� � ������� �������!");
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
	// ������ ������
	//SendClientMessage(playerid, -1, "������-��� ������");
	BanEx(playerid,"������-������");
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
			format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������� �� ������������� �����", GetName(playerid), playerid);
			SendClientMessageToAll(COLOR_RED,str);
			BanEx(playerid, "�������: CJRUN");
			MessageToAdmins("�������: CJRUN");
	     }
	}
	return 1;
}

// ��� �� �������
public OnPlayerUseWeaponAmmoHack( playerid, weaponid, ammo, realcheat)
{
    new str[100];
	switch(realcheat)
	{
		 case 1:
		 {
			format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������� �� ������������� �����", GetName(playerid), playerid);
			SendClientMessageToAll(COLOR_RED,str);
			BanEx(playerid, "�������: ���������");
			MessageToAdmins("�������: ���������");
	     }
		 default:
		 {
			format(str, sizeof(str), "����� %s (%d) ������������� � ������������� ���� �� ������� (id = %d - ammo = %d)", GetName(playerid), playerid,weaponid, ammo);
			MessageToAdmins(str);
		 }
	}
	return 1;
}


// ��� �� ������� �� ����� � ������
public OnPlayerUseWeaponHack( playerid, weaponid, ammo, realcheat)
{
	// ����� ����������
	new str[128];
	switch(realcheat)
	{
		 case AC_ACTION_BAN:
		 {
			format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������� �� ������������� �����", GetName(playerid), playerid);
			SendClientMessageToAll(COLOR_RED,str);
			BanEx(playerid, "�������: ���������");
			MessageToAdmins("�������: ���������");
	     }
	     case AC_ACTION_KICK:
	     {
	        format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������ �� ���������� � ���������: ������", GetName(playerid), playerid);
			MessageToAdmins(str);
			SendClientMessageToAll( COLOR_RED, str);
			t_Kick(playerid);
	     }
		 default:
		 {
			format(str, sizeof(str), "����� %s (%d) ������������� � ������������� ���� �� ������� �� ������ (id = %d - ammo = %d)", GetName(playerid), playerid,weaponid, ammo);
			MessageToAdmins(str);
		 }
	}
	return 1;
}

public OnPlayerUseArmourHack( playerid, Float: currentarmour )
{
	// ����� ����������
	new str[100];
	format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������� �� ������������� �����", GetName(playerid),  playerid);
	SendClientMessageToAll(COLOR_RED,str);
	MessageToAdmins("�������: ��������");
	BanEx(playerid, "�������: ��������");
	return 1;
}

forward OnPlayerUseFasRun( playerid,arg, dop[] );

public OnPlayerUseFasRun( playerid,arg, dop[] )
{
	// ������� ������
	new str[100];
	switch(arg)
	{
	    case AC_ACTION_BAN: // ���
	    {
	    	format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������� �� ������������� �����", GetName(playerid),  playerid);
			SendClientMessageToAll(COLOR_RED,str);
			format(str, sizeof(str), "�������: FASTRUN (%s)", dop);
			MessageToAdmins(str);
			BanEx(playerid, str);
	    }
		case AC_ACTION_REPORT:
		{
		    format(str, sizeof(str), "[�������]: ����� %s (%d) ������������� � ������������� FASTRUN (%s)", GetName(playerid),  playerid, dop);
			MessageToAdmins(str);
		}
		case AC_ACTION_KICK: // ��� �� ����������
		{
		    format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������ �� ���������� � ���������: FASTRUN", GetName(playerid),  playerid);
			SendClientMessageToAll( COLOR_RED, str);
			format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������ �� ���������� � ���������: FASTRUN (%s)", GetName(playerid), playerid, dop);
			MessageToAdmins(str);
			t_Kick(playerid);
		}
	}
	return 1;
}

public OnPlayerUseFlyHack( playerid,arg, dop[] )
{
	// ������� ������
	new str[100];
	switch(arg)
	{
	    case AC_ACTION_BAN: // ���
	    {
	    	format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������� �� ������������� �����", GetName(playerid),  playerid);
			SendClientMessageToAll(COLOR_RED,str);
			format(str, sizeof(str), "�������: ������� (%s)", dop);
			MessageToAdmins(str);
			BanEx(playerid, str);
	    }
		case AC_ACTION_REPORT:
		{
		    format(str, sizeof(str), "[�������]: ����� %s (%d) ������������� � ������������� FlyHack (%s)", GetName(playerid), playerid, dop);
			MessageToAdmins(str);
		}
		case AC_ACTION_KICK: // ��� �� ����������
		{
		    format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������ �� ���������� � ���������: FlyHack", GetName(playerid),  playerid);
			SendClientMessageToAll( COLOR_RED, str);
			format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������ �� ���������� � ���������: FlyHack (%s)", GetName(playerid), playerid, dop);
			MessageToAdmins(str);
			t_Kick(playerid);
		}
	}

	return 1;
}

forward OnPlayerUseTpHack(playerid, action);

public OnPlayerUseTpHack(playerid, action)
{
    // ����� ������
	new str[100];
	switch(action)
	{
	    case AC_ACTION_BAN: // ���
	    {
	    	format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������� �� ������������� �����", GetName(playerid), playerid);
			SendClientMessageToAll(COLOR_RED,str);
			MessageToAdmins("�������: ����������");
			BanEx(playerid, "�������: ����������");
	    }
		case AC_ACTION_REPORT:
		{
		    format(str, sizeof(str), "[�������]: ����� %s (%d)  ������������� � ������������� ��������", GetName(playerid),  playerid);
			MessageToAdmins(str);
		}
		case AC_ACTION_KICK: // ��� �� ����������
		{
		    format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������ �� ���������� � ���������: ��������", GetName(playerid),  playerid);
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
    // ������ ������
	new str[100];
	switch(action)
	{
	    case AC_ACTION_BAN: // ���
	    {
	    	format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������� �� ������������� �����", GetName(playerid),  playerid);
			SendClientMessageToAll(COLOR_RED,str);
			MessageToAdmins("�������: ��������-���");
			BanEx(playerid, "�������: ��������-���");
	    }
		case AC_ACTION_REPORT:
		{
		    format(str, sizeof(str), "[�������]: ����� %s (%d) ������������� � ������������� ��������-���", GetName(playerid),  playerid);
			MessageToAdmins(str);
		}
		case AC_ACTION_KICK: // ��� �� ����������
		{
		    format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������ �� ���������� � ���������: ��������-���", GetName(playerid),  playerid);
			MessageToAdmins(str);
			SendClientMessageToAll( COLOR_RED, str);
			t_Kick(playerid);
		}
	}
	return 1;
}

public OnPlayerUseJetPackHack(playerid)
{
	// ������� ���������

	new str[100];
	format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������� �� ������������� �����", GetName(playerid),  playerid);
	SendClientMessageToAll(COLOR_RED,str);
	MessageToAdmins("�������: �������");
	BanEx(playerid, "�������: �������");
	return 1;
}

public OnPlayerUseFakeSkin(playerid, realdskin, fakeskin)
{
	// ���� ���������
	new str[100];
	format(str, sizeof(str), "[�������]: ����� %s (%d) ��� ������� �� ������������� �����", GetName(playerid),  playerid);
	SendClientMessageToAll(COLOR_RED,str);
	MessageToAdmins("�������: ����� ����� �����");
	BanEx(playerid, "�������: ����� ����� �����");
	return 1;
}
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// ������� ������ �����

forward OnPlayerLogin(playerid);
forward OnPlayerRegisted(playerid);
forward OnPlayerInvitePlayer(playerid, invitename[]);


// ���������� ��� ���������� ������ �������. ���������� ������ � buffer_for_list
// ����������:
// 1 ���� ������ ����, 0 - ���� ���
stock GetAdminList(buffer_for_list[], size = sizeof(buffer_for_list))
{
    // ������� ������ ������� ������
    buffer_for_list[0] = 0x0;
    new minstr[64],admin;
	for(new i, s_b = MaxID; i <= s_b; i++)
	{
				if(!IsPlayerConnected(i))continue;
				if(Player_AdminLevel[i] < 1 && !IsPlayerAdmin(i))continue;
				if(!IsPlayerAdmin(i))format(minstr,sizeof(minstr),"%s[%d] - %d �������\n",GetName(i),i,Player_AdminLevel[i]);
				else format(minstr,sizeof(minstr),"%s[%d] - RCON �������\n",GetName(i),i);
				strcat(buffer_for_list,minstr,size);
				admin ++;
	}
	if(admin != 0) return 1;
	else return 0;
}

stock InformAbout_Y_or_N(playerid)
{
	SendClientMessage(playerid, -1, "���������: "COL_EASY"��� ������������� ����. ����������� ������ ����������� ������� N, Alt(�����, �����), Num4(�����), Num6(�����)");
	SendClientMessage(playerid, -1, "���������: "COL_RULE2"��� �������� ���� ����������� ������� Y");
	SendClientMessage(playerid, -1, ""COL_YELLOW"vk.com/game.samp - �������������, �������� 5 RUB.");
	return 1;
}

stock OpenRadioDialog(playerid, title[] = "����� �������")
{
	ShowPlayerDialog(playerid, DIALOG_AUDIOSTREAM, DIALOG_STYLE_LIST, title, "�������� �����\n��������� �����\n�������� ������ (� 20:00)\n�������� ����� (� 18:00)", "�������", "�����");
	return 1;
}

// ���������� ��� ���������� ������ ������. ��� ����������� �� ����������
// ������ �� ����������
public OnPlayerLogin(playerid)
{
    isCreatedAccount[playerid] = true;
	HideEffectsAndStartGame(playerid);
	LoadAccount(playerid);
    OpenStat(playerid);         // ����� ����������
	FixPlayerBuyed(playerid);   // �������� ������� �� ��������� �������
	SendClientMessage(playerid,COLOR_YELLOWGREEN,"����������� ���������");
	InformAbout_Y_or_N(playerid);

	return 1;
}

stock Create_TrainingStart_List()
{
	for(new i; i < sizeof(TrainingStart_ListData); i ++) strcat(TrainingStart_List, TrainingStart_ListData[i]);
	return 1;
}

stock Create_TrainingTerm_List()
{
    for(new i; i < sizeof(TrainingTerm_ListData); i ++)strcat(TrainingTerm_List, TrainingTerm_ListData[i]);
	return 1;
}

stock Create_TrainingCmdsDialogs_List()
{
    for(new i; i < sizeof(TrainingCmdsDialogs_ListData); i ++)strcat(TrainingCmdsDialogs_List, TrainingCmdsDialogs_ListData[i]);
	return 1;
}

stock Create_TrainingEnd_List()
{
    for(new i; i < sizeof(TrainingEnd_ListData); i ++)strcat(TrainingEnd_List, TrainingEnd_ListData[i]);
	return 1;
}

// ���������� ��� ���������� �����������
// ������ �� ����������
public OnPlayerRegisted(playerid)
{
    isCreatedAccount[playerid] = true;
    new buff[MAX_PLAYER_NAME+50];
	// ���������� ��� � �����������
    format(buff,sizeof(buff),"%s ����������������� �� �������",GetName(playerid));
	WriteLog(CRDLOG,buff);

    // ���� ���������
	Player_H_HaveProfession[playerid][Player_HumanProfession[playerid]] = true;  // ������� ��������� ��������� ������������
	Player_Z_HaveProfession[playerid][Player_ZombieProfession[playerid]] = true; // ������� ��������� ��������� ������������
	//Player_Level[playerid] = 1; // ����� ������ ������ �������

	GetPlayerIp(playerid, Player_RegIP[playerid], 16);

 	SaveAccount(playerid);
 	SendClientMessage(playerid,-1,""COL_EASY"����������� �������� ������� ���������");
 	
 	OpenSelectedTraining(playerid); // ������� ������ ��������?
	return 1;
}

stock OpenTrainingList(playerid, listid, tmode)
{
	new real_list = listid - 1;
	if( real_list > MAX_TRAINING_LISTS || MAX_TRAINING_LISTS < 1 ) return SendClientMessage(playerid, -1, "������: �������� �� ����������");
	switch(listid)
	{
	    case 1:
	    {
	        switch(tmode){
	            case TRAINING_MODE_REGISTER:{
                	ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "1/6. ��������� ���������: ������",TrainingStart_List,"������", "");
   				}
	            case TRAINING_MODE_MENUDIALOG:{
	                ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "��������� ���������: ������",TrainingStart_List,"�����", "");
	            }
	        }
	    }
	    case 2:
	    {
	        switch(tmode){
	            case TRAINING_MODE_REGISTER:{
                	ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "2/6. ��������� ���������: �������",TrainingTerm_List,"������", "�����");
   				}
	            case TRAINING_MODE_MENUDIALOG:{
	                ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "��������� ���������: �������",TrainingTerm_List,"�����", "");
	            }
	        }
	    }
	    case 3:
	    {
	        switch(tmode){
	            case TRAINING_MODE_REGISTER:{
                	ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "3/6. ��������� ���������: ������� � �������",TrainingCmdsDialogs_List,"������", "�����");
   				}
	            case TRAINING_MODE_MENUDIALOG:{
	                ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "��������� ���������: ������� � �������",TrainingCmdsDialogs_List,"�����", "");
	            }
	        }
	    }
	    case 4:
	    {
	        switch(tmode){
	            case TRAINING_MODE_REGISTER:{
                	ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "4/6. ��������� ���������: ����� ����",AboutYourGame_Dialog,"������", "�����");
   				}
	            case TRAINING_MODE_MENUDIALOG:{
	                ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "��������� ���������: ����� ����",AboutYourGame_Dialog,"�����", "");
	            }
	        }
	    }
	    case 5:
	    {
	        switch(tmode){
	            case TRAINING_MODE_REGISTER:{
                	ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "5/6. ��������� ���������: ������� ������� (��� 1)",Rules_Dialog[0],"������", "�����");
   				}
	            case TRAINING_MODE_MENUDIALOG:{
	                ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "��������� ���������: ������� ������� (��� 1)",Rules_Dialog[0],"�������� 2", "�����");
	            }
	        }
	    }
	    case 6:
	    {
	        switch(tmode){
	            case TRAINING_MODE_REGISTER:{
                	ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "5/6. ��������� ���������: ������� ������� (��� 2)",Rules_Dialog[1],"������", "�����");
   				}
	            case TRAINING_MODE_MENUDIALOG:{
	                ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "��������� ���������: ������� ������� (��� 2)",Rules_Dialog[1],"�������� 1", "�����");
	            }
	        }
	    }
	    case 7:
	    {
	        switch(tmode){
	            case TRAINING_MODE_REGISTER:{
                	ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "6/6. ��������� ���������: �����",TrainingEnd_List,"���������", "�����");
   				}
	            case TRAINING_MODE_MENUDIALOG:{
	                ShowPlayerDialog(playerid, DIALOG_TRAINING_BOX, DIALOG_STYLE_MSGBOX, "��������� ���������: �����",TrainingEnd_List,"�����", "");
	            }
	        }
	    }
	}
	SetPVarInt(playerid, "TrainingMode", tmode);
	SetPVarInt(playerid, "TrainingList", listid);
	return 1;
}

stock CancelTraining(playerid) // ��������� �������� ������
{
    ClearChat(playerid, 21);
    SendClientMessage(playerid, COLOR_YELLOWGREEN, "�������� ���������");
    InformAbout_Y_or_N(playerid);
    HideEffectsAndStartGame(playerid);
    OpenStat(playerid);
	return 1;
}

// ���������� ������ ��������
stock OpenSelectedTraining(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_TRAINING_CHOSE, DIALOG_STYLE_MSGBOX, "��������?","\t������� ������ ��������?", "��", "���");
	return 1;
}

// ���������� ����� ����� �������� ��������� �������� ��� ���. isyes  = ���������
forward OnPlayerSelectedTrainingPath(playerid, bool: isyes);
public OnPlayerSelectedTrainingPath(playerid, bool: isyes)
{
	if( !isyes ) // �� ���������
	{
	    InformAbout_Y_or_N(playerid);
	    HideEffectsAndStartGame(playerid);
	    OpenStat(playerid);
	}
	else // ���������
	{
	    OpenTrainingList(playerid, 1, TRAINING_MODE_REGISTER);
	}
	return 1;
}

// ���������� ����� ����� ��������� ��� ������������� ��� ������. playerid = ���, ���� ����������. invitename = ��� ����, ��� ���������
// ���������� ���������
public OnPlayerInvitePlayer(playerid, invitename[])
{
    new str[128];
	format(str,sizeof(str),"%s/%s.ini",ACCOUNTS_FOLDER,invitename);
	if(!fexist(str))return CALLING_ACCOUNT_NOT_FOUND;// ���������
	
	//ini_setString(IF, "friendname", Player_FriendName[playerid]);
	
	//format(str2, sizeof(str2), "%s/%s.ini", ACCOUNTS_FOLDER, GetName(playerid));
	//IF2 = ini_openFile(str2);
	//ini_setString(IF2, "friendname", invitename);
	//ini_closeFile(IF2);
	
	new ipp[16], playerip[16];
	GetPlayerIp(playerid, playerip, 16);
	for(new i, s_b = MaxID; i <= s_b; i++)
 	{
			if(!IsPlayerConnected(i))continue;
			if(strcmp(invitename, GetName(i), true) == 0)  // ������� ������� ������
			{
				      // ����������� ���� ��������� ����� ������������ �� �������
					  format(str,sizeof(str),"��� ���� %s ������ �� ������",GetName(playerid));
			          SendClientMessage(i,COLOR_YELLOWGREEN,str);
			          if(strcmp(playerip, Player_RegIP[i], true) == 0) // ������ ���� �� ������� ( �� ������ �� )
			   	      {
			   	           format(str,sizeof(str),"{FFFF00}����� %s ������ ����� %s. \"����\" ��� ������������ �� ������� ���������� IP",GetName(playerid),invitename);
               			   MessageToAdmins(str);//+���������� � ��������
					   	   BlockAccount(invitename, i);
					   	   SendClientMessage(playerid, COLOR_RED, "��������� ���� ������� ������ ������������ �� ������� ���������� ��-��������");
					  }
					  else
					  {
					    strmid(Player_FriendName[playerid], invitename, 0, MAX_PLAYER_NAME);
					  	Player_Invites[i]++;
					  	SaveAccount(i);
			          	FixTitul(i,TIT_FRIENDLY);
       	              }
					  //HideEffectsAndStartGame(playerid);
					  //OpenStat(playerid);
					  //OnPlayerRegisted(playerid); // ��������� ����������� playerid !_!_!
					  return CALLING_ACCOUNT_ONLINE; // ���������
			}
    }
   
   	// ����������� ���� ���������� ������ ��� � ������ ������ �� �������
   	new IF,val;
   	IF = ini_openFile(str);
   	
   	if( ini_getString(IF,"regip",ipp) != INI_KEY_NOT_FOUND )
   	{
	   	if(strcmp(ipp, playerip, true) == 0) // ������ ���� �� �������
	   	{
		   	    ini_closeFile(IF);
		   	    BlockAccount(invitename);
		   	    format(str,sizeof(str),"{FFFF00}����� %s ������ ����� %s. \"����\" ��� ������������ �� ������� ���������� IP",GetName(playerid),invitename);
		        MessageToAdmins(str);//+���������� � ��������
		   	    SendClientMessage(playerid, COLOR_RED, "��������� ���� ������� ������ ������������ �� ������� ���������� ��-��������");
		   	    return CALLING_ACCOUNT_OFFLINE;// ���������
	   	}
   	}
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
    strmid(Player_FriendName[playerid], invitename, 0, MAX_PLAYER_NAME);
    return CALLING_ACCOUNT_OFFLINE;// ���������
}

// ������ ������ ������� �� �����, �������� �� ��������
stock GivePrizeForFriend(friendname[])
{
	new str[100];
    format(str,sizeof(str),"%s/%s.ini",ACCOUNTS_FOLDER, friendname);
	if( !fexist(str)) return CALLING_ACCOUNT_NOT_FOUND;
    for(new i, s_b = MaxID; i <= s_b; i++)
 	{
			if(!IsPlayerConnected(i))continue;
			if(strcmp(friendname, GetName(i), true) == 0)  // ������� ������� ������
			{
                      Player_Rub[i] += FRIENDINVITE_PRICE_RUB;
                      SaveAccount(i);
                      format(str, sizeof(str), "�� �������� ������� �������� %d RUB �� ������������� ������", FRIENDINVITE_PRICE_RUB);
                      SendClientMessage(i, COLOR_YELLOWGREEN, str);
					  return CALLING_ACCOUNT_ONLINE; // ���������
			}
    }
    new IF, val;
	
	IF = ini_openFile(str);
	ini_getInteger(IF,"rub",val);
	val+= FRIENDINVITE_PRICE_RUB;
	ini_setInteger(IF,"rub",val);
	ini_closeFile(IF);
	return CALLING_ACCOUNT_OFFLINE;
}


stock BlockAccount(accname[], blockid = -1)
{
    new str[100], IF;
	format(str,sizeof(str),"%s/%s.ini",ACCOUNTS_FOLDER,accname);
	IF = ini_openFile(str);
	ini_setInteger(IF,"isblocked",1);
	ini_closeFile(IF);
	if( blockid != -1)
	{
	    SendClientMessage(blockid,COLOR_RED,"��� ������� ������������!");
        t_Kick(blockid);
	}
	return 1;
}

//�������� �� ���������� ������ � �������� (����� 2d ����)
stock PlayerToKvadrat(playerid,Float:max_x,Float:min_x,Float:max_y,Float:min_y)
{
	new Float:xxp,Float:yyp,Float:zzp;
	GetPlayerPos(playerid, xxp, yyp, zzp);
	if((xxp <= max_x && xxp >= min_x) && (yyp <= max_y && yyp >= min_y)) return true;
	return false;
}

stock t_Kick(playerid)
{
    if(isKicked[playerid])return 1; // ���� ������ ��� ������
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

forward DisableGSpectate(playerid);
public DisableGSpectate(playerid)
{
    gSpectateID[playerid] = -1;
	return 1;
}

// ������ ������� ������ ��� �������� ������-���� �����
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
stock strrest(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
	new offset = index;
	new result[128];
	while ((index < length) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

// ~~~~~~~~~ ������� ���� ~~~~~~~~~~~~~~
#define MAX_LOGO_OBJECTS 62
new Logo_Object[MAX_LOGO_OBJECTS];

stock DestroyLogoObjects()
{
    for(new i; i < MAX_LOGO_OBJECTS; i ++)
	{
	    DestroyObject(Logo_Object[i]);
	}
	return 1;
}
stock CreateLogoObjects()
{
    Logo_Object[0] = CreateObject(3437,2541.7971191,598.5250244,11.0000000,90.0000000,180.0000000,90.0000000); //object(ballypllr01_lvs) (1)
	Logo_Object[1] = CreateObject(19125,2539.5300293,601.0579834,9.9740000,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (1)
	Logo_Object[2] = CreateObject(19125,2540.4660645,601.0579834,9.9720001,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (5)
	Logo_Object[3] = CreateObject(19125,2541.4399414,601.0579834,9.9689999,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (6)
	Logo_Object[4] = CreateObject(19125,2542.4008789,601.0579834,9.9600000,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (7)
	Logo_Object[5] = CreateObject(19125,2543.6020508,601.0579834,9.9610004,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (8)
	Logo_Object[6] = CreateObject(19125,2544.5959473,601.0579834,9.9610004,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (9)
	Logo_Object[7] = CreateObject(19125,2543.6020508,602.4279785,10.0019999,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (17)
	Logo_Object[8] = CreateObject(19125,2544.5959473,603.2670288,10.0039997,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (18)
	Logo_Object[9] = CreateObject(19125,2541.8920898,601.7910156,9.9820004,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (19)
	Logo_Object[10] = CreateObject(19125,2540.4660645,602.4279785,10.0179996,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (20)
	Logo_Object[11] = CreateObject(19125,2539.5349121,603.2670288,10.0389996,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (21)
	Logo_Object[12] = CreateObject(19125,2542.7319336,602.1049805,9.9930000,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (10)
	Logo_Object[13] = CreateObject(19125,2541.1870117,602.1049805,9.9989996,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (22)
	Logo_Object[14] = CreateObject(19126,2539.4089355,605.3239746,10.0920000,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (4)
	Logo_Object[15] = CreateObject(19126,2540.9350586,605.3239746,10.0860004,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (9)
	Logo_Object[16] = CreateObject(19126,2542.6030273,605.3239746,10.0719995,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (10)
	Logo_Object[17] = CreateObject(19126,2543.8090820,605.5629883,10.0869999,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (11)
	Logo_Object[18] = CreateObject(19126,2544.4289551,606.7100220,10.1260004,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (12)
	Logo_Object[19] = CreateObject(19126,2543.8569336,607.8140259,10.1630001,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (13)
	Logo_Object[20] = CreateObject(19126,2542.6030273,608.0800171,10.1730003,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (14)
	Logo_Object[21] = CreateObject(19126,2540.9350586,608.0800171,10.1859999,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (15)
	Logo_Object[22] = CreateObject(19126,2539.4089355,608.0800171,10.1940002,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (16)
	Logo_Object[23] = CreateObject(19123,2539.3100586,610.0650024,10.2240000,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (1)
	Logo_Object[24] = CreateObject(19123,2541.0449219,610.0650024,10.2130003,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (2)
	Logo_Object[25] = CreateObject(19123,2542.7270508,610.0650024,10.2139997,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (3)
	Logo_Object[26] = CreateObject(19123,2544.3469238,610.0650024,10.1949997,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (4)
	Logo_Object[27] = CreateObject(19123,2544.3469238,612.4739990,10.2790003,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (6)
	Logo_Object[28] = CreateObject(19123,2544.3469238,611.2470093,10.2360001,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (8)
	Logo_Object[29] = CreateObject(19123,2539.3100586,613.9869995,10.3330002,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (9)
	Logo_Object[30] = CreateObject(19123,2541.0449219,613.9869995,10.3269997,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (10)
	Logo_Object[31] = CreateObject(19123,2542.7270508,613.9869995,10.3280001,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (11)
	Logo_Object[32] = CreateObject(19123,2544.3469238,613.9869995,10.3290005,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (12)
	Logo_Object[33] = CreateObject(19123,2544.3469238,616.4829712,10.3750000,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (13)
	Logo_Object[34] = CreateObject(19123,2544.3469238,615.2160034,10.3540001,0.0000000,0.0000000,0.0000000); //object(bollardlight3) (14)
	Logo_Object[35] = CreateObject(19126,2539.2509766,618.1060181,10.4460001,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (20)
	Logo_Object[36] = CreateObject(19126,2540.6030273,618.1060181,10.4350004,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (21)
	Logo_Object[37] = CreateObject(19126,2541.6599121,618.1060181,10.4329996,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (22)
	Logo_Object[38] = CreateObject(19126,2542.9389648,618.1060181,10.4300003,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (23)
	Logo_Object[39] = CreateObject(19126,2544.1379395,618.1060181,10.4340000,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (24)
	Logo_Object[40] = CreateObject(19126,2541.6599121,619.0590210,10.4630003,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (25)
	Logo_Object[41] = CreateObject(19126,2544.1379395,619.0590210,10.4580002,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (26)
	Logo_Object[42] = CreateObject(19126,2544.1379395,620.0120239,10.4890003,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (27)
	Logo_Object[43] = CreateObject(19126,2539.2509766,619.0590210,10.4790001,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (28)
	Logo_Object[44] = CreateObject(19126,2539.2509766,620.0120239,10.5080004,0.0000000,0.0000000,0.0000000); //object(bollardlight6) (29)
	Logo_Object[45] = CreateObject(19125,2539.2409668,622.0579834,10.5550003,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (23)
	Logo_Object[46] = CreateObject(19125,2540.1230469,622.0579834,10.5530005,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (24)
	Logo_Object[47] = CreateObject(19125,2541.2338867,622.0579834,10.5520000,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (25)
	Logo_Object[48] = CreateObject(19125,2542.2561035,622.0579834,10.5539999,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (26)
	Logo_Object[49] = CreateObject(19125,2543.3259277,622.0579834,10.5559998,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (27)
	Logo_Object[50] = CreateObject(19125,2544.0739746,622.0579834,10.5579996,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (28)
	Logo_Object[51] = CreateObject(19125,2539.4528809,623.0369873,10.5889997,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (29)
	Logo_Object[52] = CreateObject(19125,2540.3649902,623.8880005,10.5970001,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (30)
	Logo_Object[53] = CreateObject(19125,2541.3378906,622.9589844,10.5719995,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (31)
	Logo_Object[54] = CreateObject(19125,2542.3469238,623.0900269,10.5749998,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (32)
	Logo_Object[55] = CreateObject(19125,2543.3889160,623.5960083,10.5889997,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (33)
	Logo_Object[56] = CreateObject(19125,2544.1870117,623.9509888,10.5979996,0.0000000,0.0000000,0.0000000); //object(bollardlight5) (34)
	Logo_Object[57] = CreateObject(3437,2541.8291016,625.6129761,11.0000000,90.0000000,180.0054932,89.9835815); //object(ballypllr01_lvs) (4)
	Logo_Object[58] = CreateObject(3437,2546.3889160,605.3909912,11.0000000,90.0000000,180.0054932,359.9890137); //object(ballypllr01_lvs) (5)
	Logo_Object[59] = CreateObject(3437,2537.3469238,605.3909912,11.0000000,90.0000000,180.0054932,359.9835205); //object(ballypllr01_lvs) (6)
	Logo_Object[60] = CreateObject(3437,2546.3889160,618.4329834,11.0000000,90.0000000,179.9945068,180.0109863); //object(ballypllr01_lvs) (7)
	Logo_Object[61] = CreateObject(3437,2537.3469238,618.4329834,11.0000000,90.0000000,180.0054932,179.9945068); //object(ballypllr01_lvs) (8)
	return 1;
}

/*
stock FixSpec(playerid)
{
	if(PlayerInfo[playerid][SpecID] == -1)return 1;
	new SpecInfo[512],mictext[80],specid;
	specid = PlayerInfo[playerid][SpecID];

	//���
	format(mictext,sizeof(mictext),"Name: %s",PlayerName(specid));
	strcat(SpecInfo,mictext);

	//������� ������
	if(PlayerInfo[specid][Admin] > 0)
	{
        strcat(SpecInfo,"; ");//���������
        format(mictext,sizeof(mictext),"%d",PlayerInfo[specid][Admin]);
	    if(IsPlayerAdmin(specid))mictext = "RCON";
	    format(mictext,sizeof(mictext),"AdminLevel: %s",mictext);
	    strcat(SpecInfo,mictext);
    }

	strcat(SpecInfo,"~n~");//���������

	//��
	GetPlayerIp(specid,mictext,16);
	format(mictext,sizeof(mictext),"Ip: %s",mictext);
	strcat(SpecInfo,mictext);

	strcat(SpecInfo,"~n~");//���������

	//������
    format(mictext,sizeof(mictext),"Country: %s",CountryName[specid]);
    strcat(SpecInfo,mictext);

    strcat(SpecInfo,"~n~");//���������

    //���� �� ������
    new Float:P[4];
	GetPlayerHealth(specid,P[0]);
	GetPlayerArmour(specid,P[1]);
    format(mictext,sizeof(mictext),"Money: %d; Health: %d; Armour: %d; SkinID: %d",
	PlayerInfo[specid][Money],
	floatround(P[0]),
	floatround(P[1]),
	GetPlayerSkin(specid)
	);
	strcat(SpecInfo,mictext);

	strcat(SpecInfo,"~n~");//���������

	//����� (���� ����)
	if(GetPlayerState(specid) == PLAYER_STATE_DRIVER || GetPlayerState(specid) == PLAYER_STATE_PASSENGER)
	{
		switch(GetPlayerState(specid))
		{
			  case PLAYER_STATE_DRIVER: mictext = "Driver";
			  case PLAYER_STATE_PASSENGER: mictext = "Passenger";
		}

	    format(mictext,sizeof(mictext),"VehicleID: %d; VSpeed: %d; State: %s",
	    GetPlayerVehicleID(specid),
	    GetPlayerSpeed(specid),
	    mictext);
	    strcat(SpecInfo,mictext);
	    strcat(SpecInfo,"~n~");//���������
	}
	//�����
	for(new slot,weapon,ammo;slot < 13; slot++)
	{
	     GetPlayerWeaponData(specid,slot,weapon,ammo);
	     if(weapon != 0)
	     {
			  format(mictext,sizeof(mictext),"%s(%d); ~n~",WeaponNames[weapon],ammo);
			  strcat(SpecInfo,mictext);
	     }
    }


	PlayerTextDrawSetString(playerid,SpecText[playerid],SpecInfo);
	PlayerTextDrawShow(playerid,SpecText[playerid]);
	return 1;
}

stock CreateSpecText(playerid)
{
    SpecText[playerid] = CreatePlayerTextDraw(playerid,25.000000,214.000000,"Loading...");
    PlayerTextDrawAlignment(playerid,SpecText[playerid],0);
    PlayerTextDrawBackgroundColor(playerid,SpecText[playerid],0x000000ff);
    PlayerTextDrawFont(playerid,SpecText[playerid],1);
    PlayerTextDrawLetterSize(playerid,SpecText[playerid],0.299999,1.400000);
    PlayerTextDrawColor(playerid,SpecText[playerid],0x00ffff99);
    PlayerTextDrawSetOutline(playerid,SpecText[playerid],1);
    PlayerTextDrawSetProportional(playerid,SpecText[playerid],1);
    PlayerTextDrawSetShadow(playerid,SpecText[playerid],1);
    PlayerTextDrawHide(playerid,SpecText[playerid]);
    return 1;
}

*/
