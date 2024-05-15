//
//  ADMIN SPECTATE FILTER SCRIPT
//  kye 2007
//

#include <a_samp>
#define OBJECTS 90
new Object[MAX_OBJECTS];

public OnFilterScriptInit()
{
	Object[0] = CreateObject(16114,-1390.5046387,2448.7648926,90.3705902,0.0000000,0.0000000,0.0000000); //object(des_rockgp2_)(1)
	Object[1] = CreateObject(16114,-1364.9711914,2526.7094727,85.7928848,0.0000000,0.0000000,0.0000000); //object(des_rockgp2_)(2)
	Object[2] = CreateObject(16114,-1378.7011719,2490.6962891,87.0578613,0.0000000,0.0000000,0.0000000); //object(des_rockgp2_)(3)
	Object[3] = CreateObject(16114,-1396.3529053,2404.0581055,90.7063370,0.0000000,0.0000000,26.0000000); //object(des_rockgp2_)(5)
	Object[4] = CreateObject(16114,-1387.1788330,2370.8288574,88.2619324,0.0000000,0.0000000,25.9991455); //object(des_rockgp2_)(6)
	Object[5] = CreateObject(16114,-1357.8681641,2349.7919922,94.7966690,0.0000000,0.0000000,109.9951477); //object(des_rockgp2_)(7)
	Object[6] = CreateObject(5837,-1347.7828369,2437.8337402,118.7507477,0.0000000,0.0000000,266.0000000); //object(ci_guardhouse1)(1)
	Object[7] = CreateObject(16115,-1280.3677978,2563.2995606,90.3553314,0.0000000,0.0000000,0.0000000); //object(des_rockgp1_03)(2)
	Object[8] = CreateObject(16114,-1330.6923828,2572.8046875,86.0084610,0.0000000,0.0000000,327.9913330); //object(des_rockgp2_)(8)
	Object[9] = CreateObject(16114,-1326.4421387,2580.5615234,90.0084610,0.0000000,0.0000000,327.9913330); //object(des_rockgp2_)(9)
	Object[10] = CreateObject(16114,-1347.4482422,2553.8730469,86.0084610,0.0000000,0.0000000,335.9948731); //object(des_rockgp2_)(10)
	Object[11] = CreateObject(16115,-1266.2949219,2523.4794922,89.5431061,0.0000000,0.0000000,305.9967041); //object(des_rockgp1_03)(3)
	Object[12] = CreateObject(16114,-1329.9664307,2344.9501953,94.7966690,0.0000000,0.0000000,109.9951477); //object(des_rockgp2_)(11)
	Object[13] = CreateObject(16114,-1322.5277100,2338.3378906,97.7966690,0.0000000,0.0000000,93.9951172); //object(des_rockgp2_)(12)
	Object[14] = CreateObject(16122,-1366.6601562,2438.4765625,85.0776749,0.0000000,0.0000000,293.9996338); //object(des_rockgp2_11)(1)
	Object[15] = CreateObject(16122,-1331.0704346,2443.7565918,85.8223572,0.0000000,0.0000000,108.0000000); //object(des_rockgp2_11)(2)
	Object[16] = CreateObject(3279,-1335.1574707,2462.0295410,91.5085373,0.0000000,0.0000000,90.0000000); //object(a51_spottower)(1)
	Object[17] = CreateObject(3279,-1309.6076660,2427.7766113,94.1108704,0.0000000,0.0000000,282.0000000); //object(a51_spottower)(4)
	Object[18] = CreateObject(16114,-1291.4814453,2350.7187500,106.6419525,0.0000000,0.0000000,109.9951477); //object(des_rockgp2_)(15)
	Object[19] = CreateObject(16115,-1280.3671875,2563.2988281,89.3553314,0.0000000,0.0000000,0.0000000); //object(des_rockgp1_03)(4)
	Object[20] = CreateObject(3399,-1346.2084961,2470.4780273,88.6409225,0.0000000,340.0000000,270.0000000); //object(cxrf_a51_stairs)(1)
	Object[21] = CreateObject(3399,-1348.3416748,2470.3681641,88.6409225,0.0000000,339.9993897,269.9945068); //object(cxrf_a51_stairs)(2)
	Object[22] = CreateObject(3399,-1348.4731445,2462.4455566,95.4972305,0.0000000,340.0000000,270.0000000); //object(cxrf_a51_stairs)(3)
	Object[23] = CreateObject(3399,-1346.1778565,2447.5563965,109.5858688,0.0000000,339.9993897,269.9945068); //object(cxrf_a51_stairs)(4)
	Object[24] = CreateObject(3399,-1346.1669922,2462.4960938,95.4972305,0.0000000,339.9993897,269.9945068); //object(cxrf_a51_stairs)(5)
	Object[25] = CreateObject(3399,-1348.5551758,2455.2265625,102.5211410,0.0000000,339.9993897,269.9945068); //object(cxrf_a51_stairs)(6)
	Object[26] = CreateObject(3399,-1347.2098389,2411.4184570,95.4395904,0.0000000,339.9993897,90.0000000); //object(cxrf_a51_stairs)(7)
	Object[27] = CreateObject(3399,-1347.1595459,2418.9597168,102.5011520,0.0000000,339.9993897,90.0000000); //object(cxrf_a51_stairs)(9)
	Object[28] = CreateObject(3399,-1349.2098389,2411.4453125,95.4395904,0.0000000,339.9993897,90.0000000); //object(cxrf_a51_stairs)(10)
	Object[29] = CreateObject(3399,-1347.0463867,2426.5329590,109.4529190,0.0000000,339.9993897,90.0000000); //object(cxrf_a51_stairs)(11)
	Object[30] = CreateObject(3399,-1349.1562500,2418.8581543,102.5011520,0.0000000,339.9993897,90.0000000); //object(cxrf_a51_stairs)(12)
	Object[31] = CreateObject(3399,-1349.0456543,2426.5595703,109.4529190,0.0000000,339.9993897,90.0000000); //object(cxrf_a51_stairs)(13)
	Object[32] = CreateObject(3399,-1346.0917969,2454.8017578,102.5211410,0.0000000,339.9993897,269.9945068); //object(cxrf_a51_stairs)(15)
	Object[33] = CreateObject(3399,-1348.6892090,2447.4943848,109.5858688,0.0000000,339.9993897,269.9945068); //object(cxrf_a51_stairs)(16)
	Object[34] = CreateObject(3865,-1349.5058594,2437.3039551,115.3745346,0.0000000,0.0000000,358.0000000); //object(concpipe_sfxrf)(1)
	Object[35] = CreateObject(3865,-1346.0999756,2437.3076172,115.3425980,0.0000000,0.0000000,359.9974365); //object(concpipe_sfxrf)(2)
	Object[36] = CreateObject(3865,-1349.5058594,2437.3037109,115.3745346,0.0000000,0.0000000,357.9949951); //object(concpipe_sfxrf)(3)
	Object[37] = CreateObject(16114,-1290.1151123,2341.0639648,106.6419525,0.0000000,0.0000000,109.9951172); //object(des_rockgp2_)(17)
	Object[38] = CreateObject(1318,-1349.7342529,2433.0627441,117.8031692,0.0000000,0.0000000,282.0000000); //object(arrow)(1)
	Object[39] = CreateObject(1318,-1346.1989746,2433.0004883,117.8031692,0.0000000,0.0000000,281.9970703); //object(arrow)(2)
	Object[40] = CreateObject(1318,-1346.0777588,2441.8391113,117.8031692,0.0000000,0.0000000,281.9970703); //object(arrow)(3)
	Object[41] = CreateObject(1318,-1349.3315430,2441.6767578,117.8031692,0.0000000,0.0000000,281.9970703); //object(arrow)(4)
	Object[42] = CreateObject(16115,-1243.3927002,2470.9362793,90.1658173,0.0000000,0.0000000,305.9967041); //object(des_rockgp1_03)(5)
	Object[43] = CreateObject(16115,-1278.8879394,2388.9970703,90.4670639,0.0000000,0.0000000,259.9967041); //object(des_rockgp1_03)(6)
	Object[44] = CreateObject(16115,-1248.1068115,2418.2180176,94.5066528,0.0000000,0.0000000,285.9960938); //object(des_rockgp1_03)(7)
	Object[45] = CreateObject(16116,-1283.9603272,2360.6955566,95.3910065,0.0000000,0.0000000,84.0000000); //object(des_rockgp2_04)(1)
	Object[46] = CreateObject(3173,-1321.0301514,2392.3151856,94.8243561,0.0000000,0.0000000,120.0000000); //object(trailer_large4_01)(1)
	Object[47] = CreateObject(3241,-1332.8148193,2382.4660644,95.2015305,0.0000000,0.0000000,316.0000000); //object(conhoos2)(1)
	Object[48] = CreateObject(3356,-1338.8063965,2509.6867676,90.3613968,0.0000000,0.0000000,0.0000000); //object(cxrf_savhus2_)(1)
	Object[49] = CreateObject(3362,-1358.9650879,2387.1005859,94.6256104,0.0000000,0.0000000,337.9998779); //object(des_ruin2_)(2)
	Object[50] = CreateObject(3415,-1365.2781982,2418.6691894,93.5041580,0.0000000,0.0000000,0.0000000); //object(ce_loghut1)(1)
	Object[51] = CreateObject(3418,-1275.1889648,2461.0642090,89.0750732,0.0000000,0.0000000,102.0000000); //object(ce_oldhut02)(1)
	Object[52] = CreateObject(3418,-1271.3349609,2442.4345703,89.0701141,0.0000000,0.0000000,101.9970703); //object(ce_oldhut02)(2)
	Object[53] = CreateObject(16113,-1241.4686279,2473.3596191,86.3288117,0.0000000,0.0000000,136.0000000); //object(des_rockgp2_03)(1)
	Object[54] = CreateObject(16411,-1314.8945312,2472.6279297,86.2314148,0.0000000,0.0000000,307.9962158); //object(desn2_platroks)(2)
	Object[55] = CreateObject(16112,-1316.0438232,2446.2744141,82.8060455,0.0000000,0.0000000,0.0000000); //object(des_rockfl1_)(3)
	Object[56] = CreateObject(3279,-1278.8046875,2481.3896484,86.1372909,0.0000000,0.0000000,193.9970703); //object(a51_spottower)(5)
	Object[57] = CreateObject(2780,-1354.0784912,2445.1706543,88.1509247,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(1)
	Object[58] = CreateObject(2780,-1338.7977295,2440.4943848,96.5453949,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(2)
	Object[59] = CreateObject(2780,-1352.1212158,2444.0732422,88.0960617,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(3)
	Object[60] = CreateObject(2780,-1345.8276367,2438.9777832,88.3761368,0.0000000,0.0000000,0.0000000); //object(cj_smoke_mach)(4)
	Object[61] = CreateObject(3169,-1368.5025635,2402.6621094,93.4906464,0.0000000,0.0000000,0.0000000); //object(trailer_large2_01)(1)
	Object[62] = CreateObject(3363,-1295.1738281,2428.4541016,88.6982269,0.0000000,0.0000000,0.0000000); //object(des_ruin1_)(2)
	Object[63] = CreateObject(3363,-1321.2197266,2491.2880859,86.0468750,0.0000000,0.0000000,0.0000000); //object(des_ruin1_)(3)
	Object[64] = CreateObject(3364,-1340.4807129,2495.0966797,86.1870880,0.0000000,0.0000000,270.0000000); //object(des_ruin3_)(1)
	Object[65] = CreateObject(3364,-1304.6562500,2479.6074219,86.2738953,0.0000000,0.0000000,0.0000000); //object(des_ruin3_)(2)
	Object[66] = CreateObject(3364,-1361.8193359,2377.2536621,94.5145569,0.0000000,0.0000000,269.9945068); //object(des_ruin3_)(3)
	Object[67] = CreateObject(11428,-1279.7950440,2498.3090820,91.9468689,0.0000000,0.0000000,34.0000000); //object(des_indruin02)(1)
	Object[68] = CreateObject(11441,-1284.8638916,2412.2456055,89.1135788,0.0000000,0.0000000,0.0000000); //object(des_pueblo5)(1)
	Object[69] = CreateObject(11441,-1320.7695312,2416.1044922,93.4662018,0.0000000,0.0000000,0.0000000); //object(des_pueblo5)(2)
	Object[70] = CreateObject(11443,-1294.5924072,2403.0600586,91.8516693,0.0000000,0.0000000,0.0000000); //object(des_pueblo4)(1)
	Object[71] = CreateObject(11444,-1292.1740723,2392.8896484,92.0587158,0.0000000,0.0000000,0.0000000); //object(des_pueblo2)(1)
	Object[72] = CreateObject(11445,-1308.3278809,2399.4335938,94.1976090,0.0000000,0.0000000,0.0000000); //object(des_pueblo06)(1)
	Object[73] = CreateObject(11446,-1301.4892578,2392.2180176,94.4496307,0.0000000,0.0000000,28.0000000); //object(des_pueblo07)(1)
	Object[74] = CreateObject(11458,-1326.1811523,2478.4860840,86.0468750,0.0000000,0.0000000,0.0000000); //object(des_pueblo10)(1)
	Object[75] = CreateObject(11442,-1300.9516602,2511.9890137,86.0299377,0.0000000,0.0000000,0.0000000); //object(des_pueblo3)(1)
	Object[76] = CreateObject(8355,-1395.0000000,2395.3999023,106.5999985,0.0000000,270.0000000,8.0000000); //object(vgssairportland18)(1)
	Object[77] = CreateObject(8355,-1331.3000488,2345.8000488,126.5999985,0.0000000,270.0000000,89.9980469); //object(vgssairportland18)(2)
	Object[78] = CreateObject(8355,-1253.1999512,2409.1999512,113.9000015,0.0000000,270.0000000,159.9945068); //object(vgssairportland18)(3)
	Object[79] = CreateObject(8355,-1253.1992188,2409.1992188,153.9000092,0.0000000,270.0000000,159.9938965); //object(vgssairportland18)(4)
	Object[80] = CreateObject(8355,-1260.0000000,2529.5996094,100.9000015,0.0000000,270.0000000,205.9936523); //object(vgssairportland18)(5)
	Object[81] = CreateObject(8355,-1341.1999512,2545.8999023,108.9000015,0.0000000,270.0000000,307.9936523); //object(vgssairportland18)(6)
	Object[82] = CreateObject(8355,-1377.4000244,2503.6999512,113.9000015,0.0000000,270.0000000,339.9907227); //object(vgssairportland18)(7)
	Object[83] = CreateObject(11443,-1297.1999512,2497.1999512,86.0000000,0.0000000,0.0000000,0.0000000); //object(des_pueblo4)(2)
	Object[84] = CreateObject(11443,-1280.3994141,2471.2998047,86.5000000,0.0000000,0.0000000,0.0000000); //object(des_pueblo4)(3)
	Object[85] = CreateObject(3865,-1274.1999512,2521.6000977,84.5999985,305.0000000,0.0000000,328.0000000); //object(concpipe_sfxrf)(4)
	Object[86] = CreateObject(2228,-1278.3000488,2522.1000977,87.3000031,0.0000000,0.0000000,0.0000000); //object(cj_shovel)(1)
	Object[87] = CreateObject(2228,-1274.5999756,2516.1000977,87.3000031,0.0000000,0.0000000,0.0000000); //object(cj_shovel)(2)
	Object[88] = CreateObject(2228,-1278.1999512,2518.1000977,87.0999985,0.0000000,0.0000000,0.0000000); //object(cj_shovel)(3)
	Object[89] = CreateObject(11443,-1345.3000488,2484.3999023,86.3000031,0.0000000,0.0000000,0.0000000); //object(des_pueblo4)(3)
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
