
//cuas_dev_mouseButton_EH.sqf
//resets disrupt variable when player stops firing (releases LMB)


//special defines
#include "\vbs2\customer\weapons\bah_CUAS_devices\data\scripts\cuas_dev_projectdefines.hpp"

//to quickly change from packed addon or P: drive
#ifdef CUAS_DEV_USE_MISSION_SCRIPTS
	_projectDataFolder = "P:\vbs2\customer\weapons\bah_CUAS_devices\data\";
#else
	_projectDataFolder = "\vbs2\customer\weapons\bah_CUAS_devices\data\";
#endif


//wait for mission to start
_weaponClass = currentWeapon player;

if
(
	!(applicationState select 0) ||
	(applicationState select 1) == "OME" ||
	dialog ||
	!("bah_cuas" in _weaponClass)
)
exitWith {};

_array = _this select 0;
_button = _array select 2; //1=RMB, 0=LMB
_state = _this select 1;		//-1 = btn dn, 1 = btn up

_unit = player;
_safetyOn = weaponSafety player;  //true = safety on, false = weapon can fire
	
//search for these types of drones
_types =
[
		"bah_cuas_dji_phantom_4",
		"bah_cuas_dji_phantom_4_drop",
		"bah_cuas_dji_phantom_4_chemical",
		"bah_cuas_dji_phantom_4_mk40",
		"bah_cuas_dji_mavic",
		"bah_cuas_Parrot_disco",
		"bah_cuas_skywalker",
		"oetsc_octocopter",
		"oetsc_quadcopter", 
		"oetsc_quadcopter_red",
		"bah_cuas_dji_inspire2",
		"bah_cuas_dji_s1000",
		"bah_cuas_matrice200",
		"bah_cuas_matrice600",
		"bah_cuas_HomebuildDrone", 
		"bah_cuas_MyTwinDream",
		"bah_cuas_RVJet"
];

if (_button == 0 && _state == 1) then   //LMB up
{
	//distance from player to check
	_radius = 200;

	//find drones
	_targets = nearestObjects [getPos _unit, _types, _radius];

	_count = count _targets;

	//return to normal
	for "_i" from 0 to _count-1 do
	{
		_tgt = _targets select _i;

		//[disrupted?, time in sec, weapon mode];
		_tgt setVariable ["BAH_CUAS_DISRUPT_DATA", [FALSE, 0, ""], TRUE]; 
	};
};











