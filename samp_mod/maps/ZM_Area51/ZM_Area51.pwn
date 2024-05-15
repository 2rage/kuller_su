//
//  ADMIN SPECTATE FILTER SCRIPT
//  kye 2007
//

#include <a_samp>
#define OBJECTS 8
new Object[MAX_OBJECTS];

public OnFilterScriptInit()
{
	Object[0] = CreateObject(8172,97.3000031,1838.0999756,32.0999985,0.0108948,270.2816467,0.2362976); //object(vgssairportland07)(1)
	Object[1] = CreateObject(8172,175.8999939,1940.9000244,32.0999985,0.0054932,270.2804260,269.9941101); //object(vgssairportland07)(2)
	Object[2] = CreateObject(8172,220.6999970,1950.3000488,32.0999985,0.0000000,269.1722107,238.7155762); //object(vgssairportland07)(3)
	Object[3] = CreateObject(8172,285.8999939,1865.8000488,32.0999985,0.0000000,269.2305298,180.2698822); //object(vgssairportland07)(4)
	Object[4] = CreateObject(8172,296.6000061,1813.5999756,32.0999985,0.0000000,268.1172485,125.4500122); //object(vgssairportland07)(5)
	Object[5] = CreateObject(8172,96.5000000,2002.6999512,32.0999985,0.0054932,270.2801514,0.2362061); //object(vgssairportland07)(6)
	Object[6] = CreateObject(8172,194.8999939,1798.8000488,32.0999985,0.0000000,269.4359436,90.1026611); //object(vgssairportland07)(7)
	Object[7] = CreateObject(8172,161.3000030,1762.1999512,32.0999985,0.0000000,269.4342041,53.6948547); //object(vgssairportland07)(8)
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

