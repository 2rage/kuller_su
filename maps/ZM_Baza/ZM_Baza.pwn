//
//  ADMIN SPECTATE FILTER SCRIPT
//  kye 2007
//

#include <a_samp>
#define OBJECTS 41
new Object[MAX_OBJECTS];

public OnFilterScriptInit()
{
	Object[0] = CreateObject(3628,2491.3999000,-2052.3999000,11.7000000,0.0000000,90.0000000,0.0000000); //object(smallprosjmt_las) (1)
	Object[1] = CreateObject(1966,2495.3100600,-2049.0000000,8.8500000,0.0000000,0.0000000,90.0000000); //object(imcompmovedr1_las) (1)
	Object[2] = CreateObject(1685,2519.3999000,-2044.8000500,6.2000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (1)
	Object[3] = CreateObject(1685,2519.3999000,-2046.5999800,6.2000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (2)
	Object[4] = CreateObject(1685,2519.3999000,-2053.6001000,6.2000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (3)
	Object[5] = CreateObject(1685,2519.3999000,-2051.8000500,6.2000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (4)
	Object[6] = CreateObject(1685,2519.3999000,-2046.5999800,7.7000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (5)
	Object[7] = CreateObject(1685,2519.3999000,-2051.8000500,7.7000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (6)
	Object[8] = CreateObject(1685,2519.3999000,-2046.5999800,9.2000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (7)
	Object[9] = CreateObject(1685,2519.3999000,-2044.8000500,7.7000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (8)
	Object[10] = CreateObject(1685,2519.3999000,-2044.8000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (9)
	Object[11] = CreateObject(1685,2519.3999000,-2051.8000500,9.2000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (10)
	Object[12] = CreateObject(1685,2519.3999000,-2053.6001000,7.7000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (11)
	Object[13] = CreateObject(1685,2519.3999000,-2053.6001000,9.2000000,0.0000000,0.0000000,0.0000000); //object(blockpallet) (12)
	Object[14] = CreateObject(3013,2514.6269500,-2053.8925800,5.9176700,0.0000000,0.0000000,40.0000000); //object(cr_ammobox) (1)
	Object[15] = CreateObject(1654,2514.8999000,-2052.5000000,6.8500000,0.0000000,0.0000000,130.0000000); //object(dynamite) (1)
	Object[16] = CreateObject(2060,2520.3999000,-2050.1999500,5.5000000,0.0000000,0.0000000,60.0000000); //object(cj_sandbag) (1)
	Object[17] = CreateObject(2060,2520.3999000,-2050.1999500,5.8000000,0.0000000,0.0000000,60.0000000); //object(cj_sandbag) (2)
	Object[18] = CreateObject(2060,2520.3999000,-2050.1999500,6.1000000,0.0000000,0.0000000,60.0000000); //object(cj_sandbag) (3)
	Object[19] = CreateObject(2060,2520.3999000,-2048.1001000,5.5000000,0.0000000,0.0000000,300.0000000); //object(cj_sandbag) (4)
	Object[20] = CreateObject(2060,2520.3999000,-2048.1001000,5.8000000,0.0000000,0.0000000,299.9980000); //object(cj_sandbag) (6)
	Object[21] = CreateObject(2060,2520.3999000,-2048.1001000,6.1000000,0.0000000,0.0000000,299.9980000); //object(cj_sandbag) (8)
	Object[22] = CreateObject(2064,2519.6999500,-2049.1999500,6.0000000,0.0000000,0.0000000,90.0000000); //object(cj_feildgun) (1)
	Object[23] = CreateObject(1281,2507.8999000,-2055.6001000,10.5000000,270.0000000,0.0000000,0.0000000); //object(parktable1) (1)
	Object[24] = CreateObject(1281,2507.8999000,-2042.8000500,10.5000000,90.0000000,0.0000000,0.0000000); //object(parktable1) (2)
	Object[25] = CreateObject(3863,2515.6999500,-2052.8000500,7.0000000,0.0000000,0.0000000,180.0000000); //object(marketstall03_sfxrf) (1)
	Object[26] = CreateObject(3013,2514.3999000,-2053.5000000,5.9000000,0.0000000,0.0000000,359.9960000); //object(cr_ammobox) (2)
	Object[27] = CreateObject(3013,2515.1413600,-2054.0334500,5.9176700,0.0000000,0.0000000,79.9960000); //object(cr_ammobox) (3)
	Object[28] = CreateObject(3013,2514.5000000,-2053.6001000,6.2000000,0.0000000,0.0000000,29.9950000); //object(cr_ammobox) (4)
	Object[29] = CreateObject(3013,2514.8999000,-2054.0000000,6.2000000,0.0000000,0.0000000,79.9930000); //object(cr_ammobox) (5)
	Object[30] = CreateObject(3013,2514.6999500,-2053.8000500,6.5000000,0.0000000,0.0000000,55.9910000); //object(cr_ammobox) (6)
	Object[31] = CreateObject(1654,2514.6999500,-2052.3999000,6.8500000,0.0000000,0.0000000,180.0000000); //object(dynamite) (2)
	Object[32] = CreateObject(1654,2514.5000000,-2052.5000000,6.8500000,0.0000000,0.0000000,230.0000000); //object(dynamite) (3)
	Object[33] = CreateObject(3633,2513.1999500,-2053.6001000,6.3000000,0.0000000,0.0000000,0.0000000); //object(imoildrum4_las) (1)
	Object[34] = CreateObject(3633,2513.1999500,-2053.6001000,7.2000000,0.0000000,0.0000000,0.0000000); //object(imoildrum4_las) (2)
	Object[35] = CreateObject(3633,2513.1999500,-2052.1999500,6.4000000,0.0000000,0.0000000,0.0000000); //object(imoildrum4_las) (3)
	Object[36] = CreateObject(3633,2511.8000500,-2053.6001000,6.4000000,0.0000000,0.0000000,0.0000000); //object(imoildrum4_las) (4)
	Object[37] = CreateObject(2973,2516.6001000,-2045.4000200,5.6000000,0.0000000,0.0000000,0.0000000); //object(k_cargo2) (1)
	Object[38] = CreateObject(2973,2514.0000000,-2045.4000200,5.6000000,0.0000000,0.0000000,0.0000000); //object(k_cargo2) (2)
	Object[39] = CreateObject(3066,2507.0000000,-2045.1999500,7.4000000,4.0000000,0.0000000,90.0000000); //object(ammotrn_obj) (1)
	Object[40] = CreateObject(3066,2506.3000500,-2053.1001000,7.5000000,3.9990000,0.0000000,90.0000000); //object(ammotrn_obj) (2)
	return 1;
}

public OnFilterScriptExit()
{
	for(new i; i < OBJECTS; i ++)
	{
	    DestroyObject(Object[i]);
	}
	return 1;
}
