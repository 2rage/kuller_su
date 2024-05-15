//
//  ADMIN SPECTATE FILTER SCRIPT
//  kye 2007
//

#include <a_samp>
#define OBJECTS 113
new Object[MAX_OBJECTS];

public OnFilterScriptInit()
{
	Object[0] = CreateObject(19376,524.1090088,-2375.2670898,3.0000000,0.0000000,90.0000000,0.0000000); //object(wall024) (3)
	Object[1] = CreateObject(19376,534.5969849,-2375.2548828,3.0000000,0.0000000,90.0000000,0.0000000); //object(wall024) (4)
	Object[2] = CreateObject(19376,534.5889893,-2384.8459473,3.0000000,0.0000000,90.0000000,0.0000000); //object(wall024) (5)
	Object[3] = CreateObject(19376,524.1090088,-2384.8459473,3.0000000,0.0000000,90.0000000,0.0000000); //object(wall024) (7)
	Object[4] = CreateObject(19380,536.5889893,-2375.6640625,6.0000000,90.0000000,180.0000000,180.0000000); //object(wall028) (1)
	Object[5] = CreateObject(19380,536.5859985,-2386.1269531,6.0000000,90.0000000,180.0054932,179.9835205); //object(wall028) (2)
	Object[6] = CreateObject(19380,531.5339966,-2389.4909668,6.0000000,90.0000000,180.0054932,89.9890747); //object(wall028) (3)
	Object[7] = CreateObject(19380,532.4240112,-2371.8649902,6.0000000,90.0000000,180.0054932,89.9890137); //object(wall028) (4)
	Object[8] = CreateObject(19380,521.9730225,-2371.7980957,6.0000000,90.0000000,180.0054932,89.9890137); //object(wall028) (5)
	Object[9] = CreateObject(19380,524.7280273,-2374.0449219,6.0000000,90.0000000,179.9945068,179.9945068); //object(wall028) (6)
	Object[10] = CreateObject(2200,530.2490234,-2377.0471191,3.0860000,0.0000000,0.0000000,90.0000000); //object(med_office5_unit_1) (1)
	Object[11] = CreateObject(19380,524.7280273,-2384.4350586,3.0000000,90.0000000,179.9945068,179.9945068); //object(wall028) (7)
	Object[12] = CreateObject(2200,529.9730225,-2375.7910156,3.0860000,0.0000000,0.0000000,270.0000000); //object(med_office5_unit_1) (2)
	Object[13] = CreateObject(2200,530.2490234,-2379.3110352,3.0860000,0.0000000,0.0000000,90.0000000); //object(med_office5_unit_1) (3)
	Object[14] = CreateObject(2200,529.9730225,-2378.0549316,3.0860000,0.0000000,0.0000000,269.9945068); //object(med_office5_unit_1) (4)
	Object[15] = CreateObject(2200,529.9719849,-2382.5620117,3.0860000,0.0000000,0.0000000,270.0000000); //object(med_office5_unit_1) (5)
	Object[16] = CreateObject(2200,530.2490234,-2383.8139648,3.0860000,0.0000000,0.0000000,90.0000000); //object(med_office5_unit_1) (6)
	Object[17] = CreateObject(19376,534.5889893,-2384.8459473,7.5000000,0.0000000,90.0000000,0.0000000); //object(wall024) (9)
	Object[18] = CreateObject(19376,524.1090088,-2384.8459473,7.5000000,0.0000000,90.0000000,0.0000000); //object(wall024) (10)
	Object[19] = CreateObject(19376,524.1090088,-2375.2670898,7.5000000,0.0000000,90.0000000,0.0000000); //object(wall024) (11)
	Object[20] = CreateObject(19376,534.5889893,-2375.2548828,7.5000000,0.0000000,90.0000000,0.0000000); //object(wall024) (12)
	Object[21] = CreateObject(19380,525.7849731,-2389.4250488,10.3500004,90.0000000,179.9945068,90.0000000); //object(wall028) (8)
	Object[22] = CreateObject(1523,524.7670288,-2389.6818848,3.0860000,0.0000000,0.0000000,0.0000000); //object(gen_doorext10) (1)
	Object[23] = CreateObject(2200,533.6209717,-2379.3181152,3.0860000,0.0000000,0.0000000,90.0000000); //object(med_office5_unit_1) (7)
	Object[24] = CreateObject(2200,533.6209717,-2377.0471191,3.0860000,0.0000000,0.0000000,90.0000000); //object(med_office5_unit_1) (8)
	Object[25] = CreateObject(2200,533.3120117,-2378.0620117,3.0860000,0.0000000,0.0000000,269.9945068); //object(med_office5_unit_1) (9)
	Object[26] = CreateObject(2200,533.3200073,-2375.7910156,3.0860000,0.0000000,0.0000000,269.9945068); //object(med_office5_unit_1) (10)
	Object[27] = CreateObject(2200,533.6209717,-2383.8139648,3.0860000,0.0000000,0.0000000,90.0000000); //object(med_office5_unit_1) (11)
	Object[28] = CreateObject(2200,533.3120117,-2382.5620117,3.0860000,0.0000000,0.0000000,269.9945068); //object(med_office5_unit_1) (12)
	Object[29] = CreateObject(1532,533.8679810,-2371.9819336,3.0860000,0.0000000,0.0000000,0.0000000); //object(gen_doorext11) (1)
	Object[30] = CreateObject(19377,528.6290283,-2394.4799805,5.6999998,0.0000000,90.0000000,0.0000000); //object(wall025) (1)
	Object[31] = CreateObject(19377,528.6289062,-2394.4794922,3.0000000,0.0000000,90.0000000,0.0000000); //object(wall025) (3)
	Object[32] = CreateObject(19377,526.4299927,-2394.2539062,3.0000000,0.0000000,0.0000000,0.0000000); //object(wall025) (4)
	Object[33] = CreateObject(19377,524.7280273,-2394.2539062,3.0000000,0.0000000,0.0000000,0.0000000); //object(wall025) (5)
	Object[34] = CreateObject(19377,528.6289062,-2404.0900879,3.0000000,0.0000000,90.0000000,0.0000000); //object(wall025) (6)
	Object[35] = CreateObject(1523,524.8079834,-2399.0129395,3.0860000,0.0000000,0.0000000,0.0000000); //object(gen_doorext10) (2)
	Object[36] = CreateObject(19377,524.7239990,-2403.8769531,3.0000000,0.0000000,0.0000000,0.0000000); //object(wall025) (7)
	Object[37] = CreateObject(19377,529.7700195,-2404.9628906,3.0000000,90.0000000,180.0000000,270.0001221); //object(wall025) (8)
	Object[38] = CreateObject(19377,531.5390015,-2399.2609863,3.0000000,90.0000000,179.9945068,269.9945679); //object(wall025) (9)
	Object[39] = CreateObject(19377,539.0599976,-2403.3540039,3.0000000,0.0000000,90.0000000,0.0000000); //object(wall025) (10)
	Object[40] = CreateObject(19377,538.9099731,-2404.9628906,3.0000000,90.0000000,179.9945068,269.9945068); //object(wall025) (11)
	Object[41] = CreateObject(19377,544.2299805,-2405.6589355,3.0000000,0.0000000,0.0000000,0.0000000); //object(wall025) (12)
	Object[42] = CreateObject(19377,539.1040039,-2399.2609863,3.0000000,90.0000000,180.0054932,269.9780273); //object(wall025) (13)
	Object[43] = CreateObject(19377,524.9660034,-2399.2519531,10.3999996,90.0000000,180.0054932,269.9780273); //object(wall025) (14)
	Object[44] = CreateObject(2002,527.3330078,-2388.8769531,3.0860000,0.0000000,0.0000000,180.0000000); //object(water_coolnu) (1)
	Object[45] = CreateObject(2818,532.2999878,-2376.9230957,3.0860000,0.0000000,0.0000000,90.0000000); //object(gb_bedrug02) (1)
	Object[46] = CreateObject(2818,532.2999878,-2379.2141113,3.0860000,0.0000000,0.0000000,90.0000000); //object(gb_bedrug02) (2)
	Object[47] = CreateObject(2818,532.2999878,-2383.7199707,3.0860000,0.0000000,0.0000000,90.0000000); //object(gb_bedrug02) (3)
	Object[48] = CreateObject(2819,528.1560059,-2378.3911133,3.0860000,0.0000000,0.0000000,310.0000000); //object(gb_bedclothes01) (1)
	Object[49] = CreateObject(19377,528.6289062,-2404.0900879,7.2750001,0.0000000,90.0000000,0.0000000); //object(wall025) (15)
	Object[50] = CreateObject(19377,539.0599976,-2403.3540039,7.2750001,0.0000000,90.0000000,0.0000000); //object(wall025) (16)
	Object[51] = CreateObject(1523,544.2579956,-2400.8989258,3.0860000,0.0000000,0.0000000,90.0000000); //object(gen_doorext10) (3)
	Object[52] = CreateObject(8427,548.1770020,-2403.6088867,-1.5010000,0.0000000,0.0000000,0.0000000); //object(villa_inn03_lvs) (1)
	Object[53] = CreateObject(8427,572.8460083,-2411.5190430,-1.5000000,0.0000000,0.0000000,90.0000000); //object(villa_inn03_lvs) (2)
	Object[54] = CreateObject(8427,572.7189941,-2392.4160156,-1.5000000,0.0000000,0.0000000,270.0000000); //object(villa_inn03_lvs) (3)
	Object[55] = CreateObject(8427,589.6190186,-2405.3420410,-1.5010000,0.0000000,0.0000000,180.0000000); //object(villa_inn03_lvs) (4)
	Object[56] = CreateObject(19377,544.2340088,-2400.4140625,-2.2500000,0.0000000,0.0000000,0.0000000); //object(wall025) (17)
	Object[57] = CreateObject(8427,572.5709839,-2402.8559570,-5.5000000,10.0000000,0.0000000,90.0000000); //object(villa_inn03_lvs) (5)
	Object[58] = CreateObject(3361,547.0689697,-2400.0791016,1.0000000,0.0000000,0.0000000,0.0000000); //object(cxref_woodstair) (1)
	Object[59] = CreateObject(19377,544.2333984,-2400.4140625,10.8000002,0.0000000,0.0000000,0.0000000); //object(wall025) (19)
	Object[60] = CreateObject(4141,560.6840210,-2437.5458984,-1.0000000,0.0000000,0.0000000,180.0000000); //object(hotelexterior1_lan) (1)
	Object[61] = CreateObject(4141,581.8350220,-2437.5739746,-1.0000000,0.0000000,0.0000000,179.9945068); //object(hotelexterior1_lan) (2)
	Object[62] = CreateObject(19377,544.2299805,-2394.6359863,3.0000000,0.0000000,0.0000000,0.0000000); //object(wall025) (20)
	Object[63] = CreateObject(4141,608.1389771,-2431.0139160,-1.0000000,0.0000000,0.0000000,179.9945068); //object(hotelexterior1_lan) (3)
	Object[64] = CreateObject(4141,611.1439819,-2376.0559082,-1.0000000,0.0000000,0.0000000,270.0000000); //object(hotelexterior1_lan) (4)
	Object[65] = CreateObject(4141,611.6019897,-2415.6220703,-1.0000000,0.0000000,0.0000000,179.9945068); //object(hotelexterior1_lan) (5)
	Object[66] = CreateObject(4141,548.1270142,-2366.3820801,-1.0000000,0.0000000,0.0000000,0.0000000); //object(hotelexterior1_lan) (6)
	Object[67] = CreateObject(4141,569.2500000,-2366.4150391,-1.0000000,0.0000000,0.0000000,0.0000000); //object(hotelexterior1_lan) (7)
	Object[68] = CreateObject(4141,517.1409912,-2407.5600586,18.5000000,0.0000000,0.0000000,90.0000000); //object(hotelexterior1_lan) (8)
	Object[69] = CreateObject(4141,547.7260132,-2404.3679199,40.0000000,90.0000000,180.0000000,180.0000000); //object(hotelexterior1_lan) (9)
	Object[70] = CreateObject(4141,568.8060303,-2404.3679199,40.0000000,90.0000000,179.9945068,179.9945068); //object(hotelexterior1_lan) (10)
	Object[71] = CreateObject(2520,526.7449951,-2403.2009277,3.0200000,0.0000000,0.0000000,180.0000000); //object(cj_shower2) (2)
	Object[72] = CreateObject(2520,529.0679932,-2403.2009277,3.0200000,0.0000000,0.0000000,179.9945068); //object(cj_shower2) (3)
	Object[73] = CreateObject(2520,531.5709839,-2403.2009277,3.0200000,0.0000000,0.0000000,179.9945068); //object(cj_shower2) (4)
	Object[74] = CreateObject(2520,533.9199829,-2403.2009277,3.0200000,0.0000000,0.0000000,179.9945068); //object(cj_shower2) (5)
	Object[75] = CreateObject(2520,536.3690186,-2403.2009277,3.0200000,0.0000000,0.0000000,179.9945068); //object(cj_shower2) (6)
	Object[76] = CreateObject(2520,538.7139893,-2403.2009277,3.0200000,0.0000000,0.0000000,179.9945068); //object(cj_shower2) (7)
	Object[77] = CreateObject(2520,541.1640015,-2403.2009277,3.0200000,0.0000000,0.0000000,179.9945068); //object(cj_shower2) (8)
	Object[78] = CreateObject(2520,543.4019775,-2403.2009277,3.0200000,0.0000000,0.0000000,179.9945068); //object(cj_shower2) (9)
	Object[79] = CreateObject(2524,543.3729858,-2402.1240234,3.0860000,0.0000000,0.0000000,270.0000000); //object(cj_b_sink4) (1)
	Object[80] = CreateObject(2742,542.2020264,-2404.5749512,4.6999998,0.0000000,0.0000000,180.0000000); //object(cj_handdrier) (1)
	Object[81] = CreateObject(2742,539.8029785,-2404.5749512,4.6999998,0.0000000,0.0000000,179.9945068); //object(cj_handdrier) (2)
	Object[82] = CreateObject(2742,537.4970093,-2404.5749512,4.6999998,0.0000000,0.0000000,179.9945068); //object(cj_handdrier) (3)
	Object[83] = CreateObject(2742,535.0250244,-2404.5749512,4.6999998,0.0000000,0.0000000,179.9945068); //object(cj_handdrier) (4)
	Object[84] = CreateObject(2742,532.6439819,-2404.5749512,4.6999998,0.0000000,0.0000000,179.9945068); //object(cj_handdrier) (5)
	Object[85] = CreateObject(2742,530.2420044,-2404.5749512,4.6999998,0.0000000,0.0000000,179.9945068); //object(cj_handdrier) (6)
	Object[86] = CreateObject(2742,527.8170166,-2404.5749512,4.6999998,0.0000000,0.0000000,179.9945068); //object(cj_handdrier) (7)
	Object[87] = CreateObject(1271,525.5239868,-2404.2199707,3.4360001,0.0000000,0.0000000,0.0000000); //object(gunbox) (1)
	Object[88] = CreateObject(1271,525.5209961,-2404.2229004,4.1360002,0.0000000,0.0000000,0.0000000); //object(gunbox) (2)
	Object[89] = CreateObject(1271,526.1370239,-2402.9509277,3.4360001,0.0000000,0.0000000,0.0000000); //object(gunbox) (3)
	Object[90] = CreateObject(1271,525.3319702,-2402.9790039,3.4360001,0.0000000,0.0000000,0.0000000); //object(gunbox) (4)
	Object[91] = CreateObject(1271,525.3200073,-2402.1120605,3.4360001,0.0000000,0.0000000,0.0000000); //object(gunbox) (5)
	Object[92] = CreateObject(1271,525.6140137,-2402.7209473,4.1269999,0.0000000,0.0000000,328.0000000); //object(gunbox) (6)
	Object[93] = CreateObject(1271,526.9039917,-2402.9899902,3.4360001,0.0000000,0.0000000,357.9968262); //object(gunbox) (7)
	Object[94] = CreateObject(1271,526.3259888,-2402.1159668,3.4360001,0.0000000,0.0000000,327.9949951); //object(gunbox) (8)
	Object[95] = CreateObject(1271,526.6270142,-2402.7299805,4.1269999,0.0000000,0.0000000,327.9913330); //object(gunbox) (9)
	Object[96] = CreateObject(1271,526.2609863,-2402.7548828,4.8179998,0.0000000,0.0000000,327.9913330); //object(gunbox) (10)
	Object[97] = CreateObject(1271,525.7890015,-2401.2319336,3.4360001,0.0000000,0.0000000,337.9913330); //object(gunbox) (11)
	Object[98] = CreateObject(1271,525.9689941,-2401.6430664,4.1269999,0.0000000,0.0000000,289.9888916); //object(gunbox) (12)
	Object[99] = CreateObject(1271,525.8920288,-2401.9189453,4.8179998,0.0000000,0.0000000,272.2341309); //object(gunbox) (13)
	Object[100] = CreateObject(1271,526.0520020,-2402.4150391,5.5089998,0.0000000,0.0000000,327.9913330); //object(gunbox) (14)
	Object[101] = CreateObject(983,579.8660278,-2401.8259277,1.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit3) (1)
	Object[102] = CreateObject(1251,579.8850098,-2405.0590820,-1.3000000,90.0000000,180.0000000,90.0000000); //object(smashbar) (1)
	Object[103] = CreateObject(1251,579.8850098,-2398.6459961,-1.3000000,90.0000000,179.9945068,270.0000000); //object(smashbar) (2)
	Object[104] = CreateObject(1461,544.3449707,-2401.8330078,4.4569998,0.0000000,0.0000000,90.0000000); //object(dyn_life_p) (1)
	Object[105] = CreateObject(1461,544.3449707,-2398.4680176,4.4540000,0.0000000,0.0000000,90.0000000); //object(dyn_life_p) (2)
	Object[106] = CreateObject(18762,545.5319824,-2407.4318848,1.5000000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (2)
	Object[107] = CreateObject(18764,549.2849731,-2407.8159180,4.0000000,0.0000000,0.0000000,0.0000000); //object(concrete5mx5mx5m) (1)
	Object[108] = CreateObject(18762,545.1699829,-2397.1999512,7.0000000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (7)
	Object[109] = CreateObject(18762,546.5609741,-2397.1850586,3.0000000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (8)
	Object[110] = CreateObject(18762,547.9520264,-2397.1479492,1.5000000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (9)
	Object[111] = CreateObject(18762,547.9429932,-2395.9221191,4.2500000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (10)
	Object[112] = CreateObject(18762,547.9479980,-2394.7180176,8.0000000,0.0000000,0.0000000,0.0000000); //object(concrete1mx1mx5m) (11)
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

