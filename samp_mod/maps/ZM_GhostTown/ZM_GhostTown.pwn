//
//  ADMIN SPECTATE FILTER SCRIPT
//  kye 2007
//

#include <a_samp>
#define OBJECTS 12
new Object[MAX_OBJECTS];

public OnFilterScriptInit()
{
	Object[0] = CreateObject(8147,-400.3999939,2156.1000977,42.7999992,0.0000000,0.0000000,20.0000000); //object(vgsselecfence01)(1)
	Object[1] = CreateObject(8147,-344.7999878,2220.3000488,43.2000008,0.0000000,0.0000000,189.9951172); //object(vgsselecfence01)(2)
	Object[2] = CreateObject(8147,-356.2000122,2273.0000000,42.2999992,0.0000000,0.0000000,279.9920654); //object(vgsselecfence01)(3)
	Object[3] = CreateObject(8147,-430.7000122,2308.1999512,43.5000000,0.0000000,0.0000000,3.9865723); //object(vgsselecfence01)(4)
	Object[4] = CreateObject(8147,-331.3999939,2176.8000488,43.9000015,0.0000000,0.0000000,100.0000000); //object(vgsselecfence01)(5)
	Object[5] = CreateObject(8172,-397.0996094,2149.2998047,67.6999969,0.0000000,271.9994812,19.9951172); //object(vgssairportland07)(1)
	Object[6] = CreateObject(8172,-348.7000122,2273.1000977,66.0999985,0.0000000,271.9940186,279.9935303); //object(vgssairportland07)(3)
	Object[7] = CreateObject(8172,-345.1000061,2213.1999512,66.4000015,0.0000000,271.9884949,189.9920654); //object(vgssairportland07)(4)
	Object[8] = CreateObject(8172,-350.7000122,2174.3999023,68.3000031,0.0000000,271.9830322,99.9865723); //object(vgssairportland07)(5)
	Object[9] = CreateObject(16053,-359.1000061,2198.6999512,45.0000000,0.0000000,0.0000000,280.9963379); //object(des_westrn7_01)(1)
	Object[10] = CreateObject(16689,-392.3999939,2185.5000000,44.2000008,0.0000000,0.0000000,284.9963379); //object(des_westrn7_02)(1)
	Object[11] = CreateObject(8172,-429.1000061,2305.1000977,66.9000015,0.0000000,271.9995117,3.9951172); //object(vgssairportland07)(1)
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

