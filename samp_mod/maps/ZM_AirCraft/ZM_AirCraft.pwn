//
//  ADMIN SPECTATE FILTER SCRIPT
//  kye 2007
//

#include <a_samp>
#define OBJECTS 5
new Object[MAX_OBJECTS];

public OnFilterScriptInit()
{
	Object[0] = CreateObject(8147,-1393.8000488,514.9000244,10.6000004,0.0000000,0.0000000,270.0000000); //object(vgsselecfence01)(1)
	Object[1] = CreateObject(8147,-1414.9000244,512.5999756,16.7000008,0.0595398,88.0009155,270.0009766); //object(vgsselecfence01)(2)
	Object[2] = CreateObject(8147,-1392.6999512,487.8999939,13.3000002,0.0000000,0.0000000,270.0000000); //object(vgsselecfence01)(4)
	Object[3] = CreateObject(8147,-1433.9000244,503.1000061,3.0999999,0.0000000,0.0000000,2.0000000); //object(vgsselecfence01)(5)
	Object[4] = CreateObject(8147,-1375.4000244,421.5000000,4.6999998,0.0000000,0.0000000,1.9995117); //object(vgsselecfence01)(6)
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

