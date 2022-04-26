//cuas_dev_init.sqf
//executes when player switches to weapon and switches out of weapon, or changes firing mode

//vbs includes
#include "\vbs2\headers\dikCodes.hpp"
#include "\vbs2\headers\function_library.hpp"

//special defines
#include "\vbs2\customer\weapons\bah_CUAS_devices\data\scripts\cuas_dev_projectdefines.hpp"

//to quickly change from packed addon or P: drive
#ifdef CUAS_DEV_USE_MISSION_SCRIPTS
	_projectDataFolder = "P:\vbs2\customer\weapons\bah_CUAS_devices\data\";
#else
	_projectDataFolder = "\vbs2\customer\weapons\bah_CUAS_devices\data\";
#endif

//to be used with eventhandlers
CUAS_DEV_PATH = format ["%1", _projectDataFolder];

//add eventHandler to determine when player stops firing.
//execute from config eventhandler when player selects, changes firing mode, and switches to a different weapon

//[unit, weapon, muzzle, mode, selected] 
_unit = _this select 0;
_weapon = _this select 1;
_mode = _this select 3;
_selected = _this select 4;

_classNames = [];

//wait for mission to start
waitUntil {applicationState select 0 && (applicationState select 1) != "OME"};

//execute for the following conditions
if
(
	local _unit &&				//execute where local
	isPlayer _unit &&			//unit is a player
	_selected						//weapon is selected
)
then
{
	//add function library once and one time only
	_load_fn_library = missionNamespace getVariable "BAH_CUAS_DEV_LOAD_LIBRARY";

	if (isNil "_load_fn_library") then
	{
		_cuas_library = [_unit] execVM (_projectDataFolder + "scripts\cuas_dev_fn_library.sqf");	

		missionNamespace setVariable ["BAH_CUAS_DEV_LOAD_LIBRARY", TRUE];
		
		//get list of CUAS drones
		_condition = format ["(%1 in configName _x)", str "bah_cuas_"];
		_className_array = _condition configClasses (configFile >> "CfgVehicles");
		_countNames = count _className_array;
		
		for "_i" from 0 to (_countNames -1) do
		{
			_config = _className_array select _i;
			_configName = configName _config;
			
			_classNames = _classNames + [_configName];
		};	
		
		missionNamespace setVariable ["BAH_CUAS_DEV_CUAS_DRONES", _classNames];
	};

	//add eventhandler if none exist
	if (isNil "BAH_CUAS_MB_up") then
	{
		//just in case, remove any eventHandlers
		removeAllSystemEventHandlers "MouseButtonUp";		//detect when player releases LMB
		removeAllSystemEventHandlers "MouseButtonDown";		//detect when player releases LMB
		unbindKey KEYID_SafetySwitch;		//check weapon safety
		
		//control when player stops firing, must use global variable for path
		BAH_CUAS_MB_up = addSystemEventHandler ["MouseButtonUp", format ["nul = [_this, 1] execVM '%1scripts\cuas_dev_mouseButton_EH.sqf'", CUAS_DEV_PATH]];	
		
		//add droneBuster features
		if ("bah_cuas_droneBuster" in _weapon) then
		{
			//control when player opens or closes the editor, must use global variable for path
			BAH_CUAS_editorUnload = ["editorUnload", format ["nul = [] execVM '%1scripts\cuas_dev_loadHUD.sqf'", CUAS_DEV_PATH]] call fn_vbs_addSysEventHandler;
			BAH_CUAS_editorLoad = ["editorLoad", "BAH_CUAS_DEV_RSC = nil; CUAS_DEV_EDITOR_OPEN = TRUE"] call fn_vbs_addSysEventHandler;
		
			//control when player puts weapon on safe or fire
			KEYID_SafetySwitch = "SafetySwitch" bindKey format ["nul = [player] execVM '%1scripts\cuas_dev_checkMode.sqf'", _projectDataFolder];	
		
			//load new panel for drone buster build 3	
			nul = [] execVM format ["%1scripts\cuas_dev_loadHUD.sqf", _projectDataFolder];
		};
		
		//define max range
		if (_weapon == "bah_cuas_droneBuster") then
		{
			BAH_CUAS_DEVICE_RANGE = 200;	//distance in meters for OG dronebuster
		}
		else
		{
			BAH_CUAS_DEVICE_RANGE = 1000;	//distance in meters for all other devices
		};
	}
	else
	{
		//check weapon mode, change band		
		[_mode, _weapon] call fn_cuas_dev_changeBand;  //can be [Land, SendHome, Land_2, SendHome_2]
	};
}
else
{
	//unload rsc, reset onLoad variable, and remove bindKey and eventHandlers
	cutRsc ["default", "PLAIN", 0];

	removeAllSystemEventHandlers "MouseButtonUp";		//detect when player releases LMB
	unbindKey KEYID_SafetySwitch;		//check weapon safety
		
	if (!isNil "BAH_CUAS_editorUnload") then
	{
		["editorUnload", BAH_CUAS_editorUnload] call fn_vbs_removeSysEventHandler;		//editor closed	
	};
	
	if (!isNil "BAH_CUAS_editorLoad") then
	{
		["editorLoad", BAH_CUAS_editorLoad] call fn_vbs_removeSysEventHandler;			//editor open
	};
	
	BAH_CUAS_DEV_RSC = nil; 		//global variable for back panel
	BAH_CUAS_MB_up = nil;			//handle for MB up EH
	BAH_CUAS_editorUnload = nil; //handle when editor is unloaded
	BAH_CUAS_editorLoad = nil;	//handle when editor is opened
	KEYID_SafetySwitch = nil;		//handle for safety bindkey
	BAH_CUAS_JAM_LIGHT_ON = nil;	//jam light timer
	BAH_CUAS_SIG_LIGHT_ON = nil;	//signal light timer
};










