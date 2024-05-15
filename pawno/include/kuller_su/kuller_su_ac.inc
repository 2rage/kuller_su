//античит
#define AC_MAX_SLOTS 13
#define UNKNOWN_SLOTID -1

new AC_Ammo[MAX_PLAYERS][AC_MAX_SLOTS];

//native AC_GetPlayerAmmoCheat(playerid);

//Проверка аммуниции
stock AC_GetPlayerAmmoCheat(playerid)
{
	   new ammo,weapon;
	   for(new slotid; slotid < AC_MAX_SLOTS; slotid ++)
	   {
	        GetPlayerWeaponData(playerid,slotid,weapon,ammo);
	        if(ammo > AC_Ammo[playerid][slotid])return true;
	        else if(ammo < AC_Ammo[playerid][slotid])AC_Ammo[playerid][slotid] = ammo;
	   }
	   return false;
}
//проверка на джетпак
stock AC_GetPlayerJetpack(playerid)
{
	   if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)return true;
	   return false;
}

stock AC_GivePlayerWeapon(playerid,weaponid,ammo)
{
		new slotid = GetSlotId(weaponid);
		if(slotid == UNKNOWN_SLOTID)return 1;
		AC_Ammo[playerid][slotid] = ammo;
		GivePlayerWeapon(playerid,weaponid,ammo);
		return 1;
}

stock AC_ResetPlayerWeapons(playerid)
{
        for(new slotid; slotid < AC_MAX_SLOTS; slotid ++)AC_Ammo[playerid][slotid] = 0;
        ResetPlayerWeapons(playerid);
		return 1;
}

stock GetSlotId(weaponid)
{
		new slotid;
        switch(weaponid)
		{
			  case 0..1:slotid = 0;
			  case 2..9:slotid = 1;
			  case 10..15:slotid = 10;
			  case 16..18:slotid = 8;
			  case 22..24:slotid = 2;
			  case 25..27:slotid = 3;
			  case 28..29:slotid = 4;
			  case 30..31:slotid = 5;
			  case 32:slotid = 4;
			  case 33..34:slotid = 6;
			  case 35..38:slotid = 7;
			  case 39: slotid = 8;
			  case 40:slotid = 12;
			  case 41..43:slotid = 9;
			  case 44..46:slotid = 11;
			  default:slotid = UNKNOWN_SLOTID;
		}
		return slotid;
}
//#undef GivePlayerWeapon
#define GivePlayerWeapon(%0,%1,%2) AC_GivePlayerWeapon(%0,%1,%2)
#define ResetPlayerWeapons(%0) AC_ResetPlayerWeapons(%0)
