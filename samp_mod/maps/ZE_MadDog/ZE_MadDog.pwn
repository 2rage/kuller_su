//
//  ADMIN SPECTATE FILTER SCRIPT
//  kye 2007
//

#include <a_samp>
#define OBJECTS 6
new Object[MAX_OBJECTS];

public OnFilterScriptInit()
{
	Object[0] = CreateObject(5020,1259.8399658,-769.7329712,1084.6920166,0.0000000,0.0000000,0.0000000); //object(mul_las) (1)
	Object[1] = CreateObject(5020,1280.3530273,-789.2319946,1084.6920166,0.0000000,0.0000000,0.0000000); //object(mul_las) (2)
	Object[2] = CreateObject(5020,1247.7130127,-812.2869873,1084.6920166,90.0000000,180.0000000,180.0000000); //object(mul_las) (3)
	Object[3] = CreateObject(5020,1239.4670410,-837.1550293,1084.6920166,90.0000000,179.9945068,179.9945068); //object(mul_las) (4)
	Object[4] = CreateObject(5020,1282.2879639,-824.0989990,1090.6219482,0.0000000,0.0000000,90.2500000); //object(mul_las) (5)
	Object[5] = CreateObject(5020,1282.2650146,-783.8150024,1090.6219482,0.0000000,0.0000000,90.2471924); //object(mul_las) (6)
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

