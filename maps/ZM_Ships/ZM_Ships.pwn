//
//  ADMIN SPECTATE FILTER SCRIPT
//  kye 2007
//

#include <a_samp>
#define OBJECTS 15
new Object[MAX_OBJECTS];

public OnFilterScriptInit()
{
	Object[0] = CreateObject(8493,-681.9000244,428.7000122,156.6000061,0.0000000,0.0000000,0.0000000); //object(pirtshp01_lvs)(1)
	Object[1] = CreateObject(8832,-1017.7999878,175.1000061,112.0000000,0.0000000,0.0000000,210.0000000); //object(pirtebrdg01_lvs)(1)
	Object[2] = CreateObject(8832,-729.5999756,422.0000000,145.1000061,0.0000000,0.0000000,177.9981690); //object(pirtebrdg01_lvs)(2)
	Object[3] = CreateObject(8493,-773.0000000,432.5000000,157.0000000,0.0000000,0.0000000,358.0000000); //object(pirtshp01_lvs)(2)
	Object[4] = CreateObject(2674,-774.5999756,423.0000000,144.6999970,0.0000000,0.0000000,0.0000000); //object(proc_rubbish_2)(1)
	Object[5] = CreateObject(8832,-727.7999878,465.5000000,148.5000000,0.0000000,0.0000000,267.9949951); //object(pirtebrdg01_lvs)(3)
	Object[6] = CreateObject(8493,-712.0000000,511.7999878,160.6999970,0.0000000,0.0000000,268.0000000); //object(pirtshp01_lvs)(3)
	Object[7] = CreateObject(3524,-687.9000244,425.2999878,147.6000061,0.0000000,0.0000000,12.0000000); //object(skullpillar01_lvs)(1)
	Object[8] = CreateObject(3524,-688.4000244,411.2999878,147.1000061,0.0000000,0.0000000,131.9970703); //object(skullpillar01_lvs)(2)
	Object[9] = CreateObject(3524,-732.5999756,463.2000122,154.3999939,0.0000000,0.0000000,359.9908447); //object(skullpillar01_lvs)(5)
	Object[10] = CreateObject(3524,-718.7000122,463.3999939,154.3000030,0.0000000,0.0000000,359.9890137); //object(skullpillar01_lvs)(6)
	Object[11] = CreateObject(3524,-766.2999878,428.0000000,148.0000000,0.0000000,0.0000000,299.9890137); //object(skullpillar01_lvs)(7)
	Object[12] = CreateObject(3524,-766.4000244,413.6000061,148.3000030,0.0000000,0.0000000,229.9871826); //object(skullpillar01_lvs)(8)
	Object[13] = CreateObject(3528,-689.2998047,402.5996094,142.3999939,0.0000000,341.9989014,153.9953613); //object(vgsedragon)(1)
	Object[14] = CreateObject(16776,-727.2000122,397.8999939,148.8999939,0.0000000,0.0000000,178.0000000); //object(des_cockbody)(1)
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

