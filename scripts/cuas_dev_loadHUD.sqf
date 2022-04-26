
//cuas_dev_loadHUD.sqf

//loads back panel of drone BUster block 3


//special defines
#include "\vbs2\customer\weapons\bah_CUAS_devices\data\scripts\cuas_dev_projectdefines.hpp"

//to quickly change from packed addon or P: drive
#ifdef CUAS_DEV_USE_MISSION_SCRIPTS
	_projectDataFolder = "P:\vbs2\customer\weapons\bah_CUAS_devices\data\";
#else
	_projectDataFolder = "\vbs2\customer\weapons\bah_CUAS_devices\data\";
#endif


sleep .1;  //wait for editor to close

_weaponState = weaponState player;
_weapon = _weaponState select 0;
_mode = _weaponState select 2;

//terminate any loops
terminate CUAS_DEV_CTRL_LIGHTS;

//weapon is drone buster block 3
//if ("bah_cuas_droneBuster_3B" in _weapon) then
if ("bah_cuas_droneBuster" in _weapon) then
{
	//HUD not displayed
	if(isNil "BAH_CUAS_DEV_RSC") then
	{
		//change flag to stop signalLight loop
		CUAS_DEV_EDITOR_OPEN = FALSE;
		
		//load panel
		cutRsc ["CUAS_DEV_DB_B3_RSC", "PLAIN"];
		
		//position controls
		nul = [_weapon] execVM format ["%1scripts\cuas_dev_positionCtrls.sqf", _projectDataFolder];

		//check initial weapon safety condition, change mode and battery
		nul = [player] execVM format ["%1scripts\cuas_dev_checkMode.sqf", _projectDataFolder];
	};
	
	//check weapon mode, change band
	[_mode, _weapon] call fn_cuas_dev_changeBand;  //can be [Land, SendHome, Land_2, SendHome_2]
	
	//run loop to control lights
	CUAS_DEV_CTRL_LIGHTS = [player] execVM format ["%1scripts\cuas_dev_controlLights.sqf", _projectDataFolder];
};




