


//cuas_dev_checkMode.sqf
//check weapon safety, rotate dial

//special defines
#include "\vbs2\customer\weapons\bah_CUAS_devices\data\scripts\cuas_dev_projectdefines.hpp"
#include "\vbs2\customer\weapons\bah_CUAS_devices\data\scripts\cuas_dev_defines.hpp"

//to quickly change from packed addon or P: drive
#ifdef CUAS_DEV_USE_MISSION_SCRIPTS
	_projectDataFolder = "P:\vbs2\customer\weapons\bah_CUAS_devices\data\";
#else
	_projectDataFolder = "\vbs2\customer\weapons\bah_CUAS_devices\data\";
#endif

//wait for weapon safety to change
sleep .1;

//controls
_display = BAH_CUAS_DEV_RSC;
_ctrl_knob_mode = _display displayCtrl IDC_DB_B3_KNOB_MODE;

_safetyOn = weaponSafety player;  //true = safety on, false = weapon can fire
//the DB 3B dial has a 45 degree offset.  if ctrl angle is 0 degrees, the dial is pointing at 45 degrees.
//the DB OG dial has a 180 degree offset.  if ctrl angle is 0 degrees, the dial is pointing at 180 degrees.

_weapon = currentWeapon player;

_ctrl_angle = 0;  //default value

if (_weapon == "bah_cuas_droneBuster_3B") then
{
	if (_safetyOn) then
	{
		//weapon on safe, rotate to off
		_ctrl_angle = 18; 
	}
	else
	{
		//weapon on fire, rotate to detect
		_ctrl_angle = -5;
	};
	
	_ctrl_knob_mode ctrlSetAngle _ctrl_angle;  //rotate dial for 3B
	_ctrl_knob_mode ctrlCommit 0; 
}
elseIf (_weapon == "bah_cuas_droneBuster") then
{
	//on the OG dronebuster, the safety and band (c2, c2+gps) are the same dial
	if (_safetyOn) then
	{
		//weapon on safe, rotate to off
		_ctrl_angle = 0;
		
		_ctrl_knob_mode ctrlSetAngle _ctrl_angle;  //turn off
		_ctrl_knob_mode ctrlCommit 0; 
	}
	else
	{
		//weapon on fire, find band 
		_weaponState = weaponState player;
		_weapon = _weaponState select 0;
		_mode = _weaponState select 2;
		
		[_mode, _weapon] call fn_cuas_dev_changeBand;  //can be [Land, SendHome]		
	};
};









	