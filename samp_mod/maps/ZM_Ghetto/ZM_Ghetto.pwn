//
//  ADMIN SPECTATE FILTER SCRIPT
//  kye 2007
//

#include <a_samp>
#define OBJECTS 63
new Object[MAX_OBJECTS];

public OnFilterScriptInit()
{
	Object[0] = CreateObject(1337,3083.1809100,-1328.1541700,69.8883100,0.0000000,0.0000000,0.0000000); //object(binnt07_la) (1)
	Object[1] = CreateObject(14408,3054.8999000,-1909.4000200,19.1000000,0.0000000,0.0000000,0.0000000); //object(carter-floors04) (1)
	Object[2] = CreateObject(14412,3027.1999500,-2049.1999500,25.9000000,0.0000000,0.0000000,0.0000000); //object(carter_drugfloor) (1)
	Object[3] = CreateObject(9321,3048.6999500,-2062.3000500,11.8000000,0.0000000,0.0000000,180.2500000); //object(garage_sfn01) (1)
	Object[4] = CreateObject(18260,3053.6999500,-2061.0000000,11.8000000,0.0000000,0.0000000,0.0000000); //object(crates01) (1)
	Object[5] = CreateObject(3280,3052.0000000,-2046.0000000,16.5000000,0.0000000,0.0000000,0.0000000); //object(a51_panel) (1)
	Object[6] = CreateObject(3280,3052.0000000,-2044.4000200,16.5000000,0.0000000,0.0000000,0.0000000); //object(a51_panel) (2)
	Object[7] = CreateObject(3280,3053.5000000,-2043.1999500,16.2000000,0.0000000,0.0000000,0.0000000); //object(a51_panel) (3)
	Object[8] = CreateObject(14815,3133.1001000,-1734.3000500,40.6000000,0.0000000,0.0000000,0.0000000); //object(whhouse_main) (1)
	Object[9] = CreateObject(14738,3154.3999000,-1737.6999500,41.4000000,0.0000000,0.0000000,0.0000000); //object(brothelbar) (1)
	Object[10] = CreateObject(2571,3137.3999000,-1740.1999500,38.8000000,0.0000000,0.0000000,329.0000000); //object(hotel_single_1) (1)
	Object[11] = CreateObject(1337,3134.5527300,-1735.7568400,42.8187500,0.0000000,0.0000000,0.0000000); //object(binnt07_la) (2)
	Object[12] = CreateObject(3920,94.6000000,105.1000000,501.6000100,0.0000000,0.0000000,0.0000000); //object(lib_veg3) (1)
	Object[13] = CreateObject(8356,2328.1992200,-1761.8994100,28.8000000,0.0000000,90.7470000,269.4950000); //object(vgssairportland15) (4)
	Object[14] = CreateObject(8356,2357.3999000,-1721.5999800,12.6000000,0.0000000,92.0000000,90.0000000); //object(vgssairportland15) (5)
	Object[15] = CreateObject(8356,2237.3994100,-1734.2998000,28.7000000,0.0000000,90.7420000,179.2420000); //object(vgssairportland15) (6)
	Object[16] = CreateObject(8356,2419.8000500,-1762.5000000,30.6000000,0.0000000,90.7420000,359.2420000); //object(vgssairportland15) (8)
	Object[17] = CreateObject(2063,2356.5000000,-1746.0000000,13.4000000,0.0000000,0.0000000,0.0000000); //object(cj_greenshelves) (1)
	Object[18] = CreateObject(2063,2356.3000500,-1744.4000200,14.1000000,0.0000000,140.0000000,274.2500000); //object(cj_greenshelves) (2)
	Object[19] = CreateObject(2448,2280.6001000,-1725.6999500,12.5000000,0.0000000,0.0000000,0.0000000); //object(cj_ff_conter_5d) (1)
	Object[20] = CreateObject(944,2275.5000000,-1731.8000500,13.3000000,0.0000000,0.0000000,0.0000000); //object(packing_carates04) (1)
	Object[21] = CreateObject(3761,2280.3000500,-1742.4000200,13.3000000,0.0000000,270.0000000,8.0000000); //object(industshelves) (1)
	Object[22] = CreateObject(3722,2312.7998000,-1743.5000000,16.8000000,0.0000000,0.0000000,136.0000000); //object(laxrf_scrapbox) (2)
	Object[23] = CreateObject(5262,2343.1999500,-1750.1999500,16.4000000,0.0000000,90.0000000,16.0000000); //object(las2dkwar04) (1)
	Object[24] = CreateObject(1337,2357.2353500,-1749.0527300,12.8828100,0.0000000,0.0000000,0.0000000); //object(binnt07_la) (3)
	Object[25] = CreateObject(3374,135.7000000,121.4000000,479.8999900,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (1)
	Object[26] = CreateObject(3374,2355.3999000,-1734.1999500,13.9000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (2)
	Object[27] = CreateObject(3374,2362.6999500,-1730.4000200,13.9000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (3)
	Object[28] = CreateObject(3374,2366.0000000,-1734.9000200,13.9000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (4)
	Object[29] = CreateObject(3374,2371.1999500,-1730.0000000,13.9000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (5)
	Object[30] = CreateObject(3374,2374.3999000,-1734.5000000,13.9000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (6)
	Object[31] = CreateObject(3374,2381.3000500,-1734.5999800,13.9000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (7)
	Object[32] = CreateObject(3374,2387.8999000,-1734.3000500,13.9000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (8)
	Object[33] = CreateObject(3374,2374.3999000,-1734.3000500,16.8000000,0.0000000,0.0000000,0.0000000); //object(sw_haybreak02) (9)
	Object[34] = CreateObject(11417,2372.5000000,-1748.9000200,17.3000000,0.0000000,0.0000000,0.0000000); //object(xenonsign2_sfse) (1)
	Object[35] = CreateObject(1676,2372.3999000,-1751.1999500,14.0000000,0.0000000,0.0000000,0.0000000); //object(washgaspump) (1)
	Object[36] = CreateObject(1676,2369.8000500,-1749.1999500,14.0000000,0.0000000,0.0000000,304.0000000); //object(washgaspump) (2)
	Object[37] = CreateObject(4642,2359.1001000,-1739.3000500,14.2000000,0.0000000,0.0000000,142.0000000); //object(paypark_lan) (1)
	Object[38] = CreateObject(925,2306.6999500,-1730.0999800,13.4000000,0.0000000,0.0000000,0.0000000); //object(rack2) (1)
	Object[39] = CreateObject(925,2309.1001000,-1730.0999800,13.4000000,0.0000000,0.0000000,0.0000000); //object(rack2) (2)
	Object[40] = CreateObject(925,2309.1001000,-1730.0999800,15.5000000,0.0000000,0.0000000,0.0000000); //object(rack2) (3)
	Object[41] = CreateObject(925,2309.0000000,-1731.6999500,13.4000000,0.0000000,0.0000000,0.0000000); //object(rack2) (4)
	Object[42] = CreateObject(925,2306.6999500,-1731.6999500,13.4000000,0.0000000,0.0000000,0.0000000); //object(rack2) (5)
	Object[43] = CreateObject(1225,2303.6001000,-1731.5000000,12.8000000,0.0000000,0.0000000,0.0000000); //object(barrel4) (1)
	Object[44] = CreateObject(1225,2307.3999000,-1729.5999800,14.9000000,0.0000000,0.0000000,0.0000000); //object(barrel4) (2)
	Object[45] = CreateObject(1225,2306.6999500,-1733.8000500,12.8000000,0.0000000,0.0000000,0.0000000); //object(barrel4) (3)
	Object[46] = CreateObject(1225,2307.1001000,-1721.8000500,8.8000000,0.0000000,0.0000000,0.0000000); //object(barrel4) (4)
	Object[47] = CreateObject(1225,2304.1999500,-1729.5000000,12.8000000,0.0000000,0.0000000,0.0000000); //object(barrel4) (5)
	Object[48] = CreateObject(11225,2288.8000500,-1743.1999500,12.3000000,0.0000000,0.0000000,0.0000000); //object(hubhole3_sfse) (1)
	Object[49] = CreateObject(11225,2289.0000000,-1753.6999500,12.2000000,0.0000000,0.0000000,0.0000000); //object(hubhole3_sfse) (2)
	Object[50] = CreateObject(11225,2288.3999000,-1745.5000000,12.3000000,0.0000000,0.0000000,0.0000000); //object(hubhole3_sfse) (3)
	Object[51] = CreateObject(2669,2289.1001000,-1730.0999800,13.7000000,0.0000000,0.0000000,0.0000000); //object(cj_chris_crate) (2)
	Object[52] = CreateObject(2679,2290.8000500,-1733.5000000,13.6000000,328.4170000,352.9520000,358.7690000); //object(cj_chris_crate_rd) (1)
	Object[53] = CreateObject(17875,2260.3000500,-1758.4000200,16.2000000,0.0000000,0.0000000,0.0000000); //object(hubst2_alpha) (1)
	Object[54] = CreateObject(1337,2347.3056600,-1743.1455100,13.0468800,0.0000000,0.0000000,0.0000000); //object(binnt07_la) (4)
	Object[55] = CreateObject(17958,2361.6001000,-1732.3000500,13.4000000,0.0000000,0.0000000,0.0000000); //object(buringd_alpha) (1)
	Object[56] = CreateObject(5259,2254.3999000,-1733.0000000,12.4000000,0.0000000,0.0000000,0.0000000); //object(las2dkwar01) (1)
	Object[57] = CreateObject(5259,2254.3999000,-1733.0000000,17.6000000,0.0000000,0.0000000,0.0000000); //object(las2dkwar01) (2)
	Object[58] = CreateObject(3761,2256.1999500,-1740.0999800,13.8000000,0.0000000,0.0000000,0.0000000); //object(industshelves) (2)
	Object[59] = CreateObject(3798,2256.1999500,-1738.0999800,15.8000000,0.0000000,0.0000000,0.0000000); //object(acbox3_sfs) (1)
	Object[60] = CreateObject(9361,2269.6999500,-1741.9000200,15.1000000,0.0000000,0.0000000,0.0000000); //object(boatoffice_sfn) (1)
	Object[61] = CreateObject(8399,2410.6999500,-1755.0000000,17.1000000,0.0000000,0.0000000,54.0000000); //object(nightclub01_lvs) (1)
	Object[62] = CreateObject(1537,2396.3000500,-1743.1999500,12.5000000,0.0000000,0.0000000,54.0000000); //object(gen_doorext16) (1)
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
