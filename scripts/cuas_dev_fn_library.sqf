

//cuas_dev_fn_library.sqf
//function library

//special defines
#include "\vbs2\customer\weapons\bah_CUAS_devices\data\scripts\cuas_dev_defines.hpp"


fn_cuas_dev_change_lights = 
{
	//change lights for a specific control(s)
	
	//passed array 		["LIGHT_JAM", 0]  //searchWord, type //0 = random, 1= white

	local _searchWord = _this select 0;
	local _type = _this select 1;
	local _color = _this select 2;
	
	local _display = BAH_CUAS_DEV_RSC;

	//find controls
	local _condition = format ["(%1 in configName _x)", str _searchWord];
	local _configControls = _condition configClasses (configFile >> "RscTitles" >> "CUAS_DEV_DB_B3_RSC" >> "Controls");
			
	switch (_type) do
	{
		case 0:
		{
			//random lights
			
			//find next color in array
			local _count_colors = count BAH_CUAS_COLOR_ARRAY;
			local _color_idx = missionNamespace getVariable ["CUAS_DEV_COLOR_IDX", 0];  //idx for color array
			
			//algorithm to revolve forwards (0+1)%3 to rotate between 0 and 2
			local _color_idx = (_color_idx + 1) % _count_colors;
			
			local _color = BAH_CUAS_COLOR_ARRAY select _color_idx;
			
			//save new color
			missionNamespace setVariable ["CUAS_DEV_COLOR_IDX", _color_idx];  //idx for color array

			//rotate through colors
			{
				local _idc = getNumber (configFile >> "RscTitles" >> "CUAS_DEV_DB_B3_RSC" >> "Controls">> configName _x >> "idc");
				local _ctrl = _display displayCtrl _idc;
			
				_ctrl ctrlSetTextColor _color; //color array
				
			}forEach _configControls;
		};
		
		case 1:
		{
			//user defined color
			{
				_idc = getNumber (configFile >> "RscTitles" >> "CUAS_DEV_DB_B3_RSC" >> "Controls">> configName _x >> "idc");
				_ctrl = _display displayCtrl _idc;
			
				_ctrl ctrlSetTextColor _color; //default white
				
			}forEach _configControls;			
		};
	};
};


fn_cuas_dev_battery = 
{
	//controls
	//instead of loading these each time, maybe assign as constant?
	local _display = BAH_CUAS_DEV_RSC;
	local _ctrl_light_bat_1 = _display displayCtrl IDC_DB_B3_LIGHT_BAT_1;
	local _ctrl_light_bat_2 = _display displayCtrl IDC_DB_B3_LIGHT_BAT_2;
	local _ctrl_light_bat_3 = _display displayCtrl IDC_DB_B3_LIGHT_BAT_3;
	local _ctrl_light_bat_4 = _display displayCtrl IDC_DB_B3_LIGHT_BAT_4;
	local _ctrl_light_bat_5 = _display displayCtrl IDC_DB_B3_LIGHT_BAT_5;
	
	//assign colors
	_ctrl_light_bat_1 ctrlSetTextColor [1, 0, 0, 1]; //red
	_ctrl_light_bat_2 ctrlSetTextColor [1, 1, 0, 1]; //yellow
	_ctrl_light_bat_3 ctrlSetTextColor [0, 1, 0, 1]; //green
	_ctrl_light_bat_4 ctrlSetTextColor [0, 1, 0, 1]; //green
	_ctrl_light_bat_5 ctrlSetTextColor [0, 1, 0, 1]; //green	
};


fn_cuas_dev_changeBand = 
{
	//passed array [_mode, _weapon];
	local _band = _this select 0;  //[Land, SendHome, Land_2, SendHome_2]
	local _weapon = _this select 1;  

	//display
	local _display = BAH_CUAS_DEV_RSC;
	local _ctrl_knob = _display displayCtrl -1;  //3B band
	
	local _ctrl_angle = 0;  //default angle

	if (_weapon == "bah_cuas_droneBuster_3B") then
	{
		//control
		_ctrl_knob = _display displayCtrl IDC_DB_B3_KNOB_BAND;  //define ctrl

		switch (_band) do
		{
			case "Land":
			{
				//"C2 + GPS High"
				_ctrl_angle = -85;			
			};
			case "SendHome":
			{
				//"C2 High"
				_ctrl_angle = -40;
			};
			case "Land_2":
			{
				//"C2 + GPS Low"
				_ctrl_angle = 20;
			};
			case "SendHome_2":
			{
				//"C2 Low"
				_ctrl_angle = 0;
			};		
		};		
	}
	elseIf (_weapon == "bah_cuas_droneBuster") then
	{
		//control, on the OG droneBuster, safety and band is the same dial
		_ctrl_knob = _display displayCtrl IDC_DB_B3_KNOB_MODE;  

		switch (_band) do
		{
			case "Land":
			{
				//"C2 + GPS"
				_ctrl_angle = 53;			
			};
			case "SendHome":
			{
				//"C2"
				_ctrl_angle = 23;
			};	
		};
	};

	_ctrl_knob ctrlSetAngle _ctrl_angle;
	_ctrl_knob ctrlCommit 0; 
};


fn_cuas_dev_findTgts = 
{
	//find targets
	//passed array [_unit, _weapon, _weapon_mode]
	local _unit = _this select 0;
	local _weapon = _this select 1;
	local _weapon_mode = _this select 2;
	
	local _tgtArray = [];
	
	//find effective cone for jamming, not consistant if the FOV changes
	//get cam fov in degrees for left side of screen
	local _camFrustrum = camFrustum;
	local _camFrustrum_FOV_L= _camFrustrum select 1;
	local _camFrustrum_FOV_L_deg = (atan (_camFrustrum_FOV_L));	

	//for left side of screen, calculate num deg in each 1% of screen
	local _screenWidth_L = safeZoneWAbs/2;  //safeZoneWAbs = 1.3 for 16:9

	//find cone radius
	local _cone = 15;		//default radius in deg (droneBuster and other devices)

	if ("droneDefender" in _weapon) then
	{
		_cone = 22.25;  //22 degree cone
	};
	
	if ("bah_cuas_droneBuster_3B" in _weapon) then
	{
		_cone = 5;  //5 degree cone
	};

	//dis from center of screen for effective cone in screen %
	local _effectiveDis = (_screenWidth_L*_cone)/_camFrustrum_FOV_L_deg; 

	//list of drone, defined in cuas_dev_init.sqf
	local _types = missionNamespace getVariable ["BAH_CUAS_DEV_CUAS_DRONES", [""]];

/*
	//search for these types of drones
	local _types =
	[
		"bah_cuas_dji_phantom_4",
		"bah_cuas_dji_phantom_4_drop",
		"bah_cuas_dji_phantom_4_chemical",
		"bah_cuas_dji_phantom_4_mk40",
		"bah_cuas_dji_mavic",
		"bah_cuas_dji_inspire2",
		"bah_cuas_dji_s1000",
		"bah_cuas_instanteye_mk2",
		"bah_cuas_matrice200",
		"bah_cuas_matrice600",		
		"bah_oetsc_octocopter",
		"bah_cuas_PD100_BlackHornet",
		"bah_cuas_Parrot_disco",
		"bah_cuas_skywalker",		
		"bah_cuas_ababil3",
		"bah_cuas_ch4_rainbow",
		"bah_cuas_Farpad",
		"bah_cuas_HomebuildDrone",
		"bah_cuas_Mohajer4",
		"bah_cuas_MQ5B_Hunter",
		"bah_cuas_MQ19_aerosonde",
		"bah_cuas_MyTwinDream",
		"bah_cuas_Oghab1",
		"bah_cuas_Orlan10",
		"bah_cuas_RQ2_Pioneer",
		"bah_cuas_RQ4_Global_Hawk",
		"bah_cuas_RQ7_Shadow",
		"bah_cuas_RQ12A_WaspAE",
		"bah_cuas_rq20_puma",
		"bah_cuas_RVJet",
		"bah_cuas_ScanEagle",
		"bah_cuas_Searcher2",
		"bah_cuas_Skyhunter",
		"bah_cuas_Talon",
		"bah_cuas_YakovlevPchela",
		"bah_cuas_Yasir",
		"bah_cuas_Zala42108",
		"bah_cuas_qasef1"
	];
*/
	//find drones
	local _targets = nearestObjects [getPos _unit, _types, BAH_CUAS_DEVICE_RANGE];

	local _count = count _targets;

	if (_count > 0) then
	{
		//check each drone if inside disruption cone
		for "_i" from 0 to _count-1 do
		{
			local _tgt = _targets select _i;

			local _sc_pos = worldToScreen (getPos _tgt);
			
			if ((count _sc_pos) > 0) then
			{	
				//check if drone is within effective cone, disrupt drone
				if
				(
					([0.5,0.5] distance _sc_pos) < _effectiveDis
				)
				then
				{
					//check if player is busting drone
					local _idx_LMB_dn = inputAction "DefaultAction";
					
					if (_idx_LMB_dn > 0) then
					{
						_time = time;
						_script_delay = 2;
						
						_speed = speed _tgt; //kph
						_pos = getPos _tgt;  // pos AGL

						//player is firing at the drone
						_tgt setVariable ["BAH_CUAS_DISRUPT_DATA", [TRUE, _time, _weapon_mode], TRUE]; 
					};
					
					_tgtArray = _tgtArray + [_tgt];
				}
				else
				{
					//within range but not within disrupt cone, normal operation
					//[disrupted?, time in sec, weapon mode];
					
					_tgt setVariable ["BAH_CUAS_DISRUPT_DATA", [FALSE, 0, ""], TRUE]; 
					//_tgt setVariable ["BAH_CUAS_DISRUPT_DATA", [FALSE, 0, "normal"], TRUE]; 

					_tgtArray = _tgtArray - [_tgt];
				};
			}
			else
			{
				//not in range, normal operation
				//[disrupted?, time in sec, weapon mode];
				
				_tgt setVariable ["BAH_CUAS_DISRUPT_DATA", [FALSE, 0, ""], TRUE];
				//_tgt setVariable ["BAH_CUAS_DISRUPT_DATA", [FALSE, 0, "normal"], TRUE]; 
				
				_tgtArray = _tgtArray - [_tgt];		
			};
		};
	}
	else
	{
		//no targets, normal operation
		//[disrupted?, time in sec, weapon mode];
		
		_tgt setVariable ["BAH_CUAS_DISRUPT_DATA", [FALSE, 0, ""], TRUE];	
		//_tgt setVariable ["BAH_CUAS_DISRUPT_DATA", [FALSE, 0, "normal"], TRUE]; 
		
		_tgtArray = _tgtArray - [_tgt];			
	};
	
	_tgtArray
};


