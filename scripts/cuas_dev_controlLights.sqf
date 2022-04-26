
//cuas_dev_controlLights.sqf
//start a loop to cycle through different colored lights.

_weapon = currentWeapon player;

_sigLight_duration = 1.3;	//signal light on/off in sec
_jamLight_duration = 0.5;  //jam light on/off in sec
_timeON = time;  //init variable
_timeOFF = time;
_i = 1;

//this loop stops when player changes weapons
while {"bah_cuas_droneBuster" in _weapon} do
{
_i=_i+1;
[-1,100] diagMessage format ["controlLights: %1", _i];
	_weapon = currentWeapon player;
	_safetyOn = weaponSafety player;  //true = safety on, false = weapon can fire

	if(_safetyOn) then
	{
		//weapon on safe, all lights off
		["LIGHT", 1, [1,1,1,1]] call fn_cuas_dev_change_lights;  //0 = random lights, 1= white
	}
	else
	{
		//does player have a battery?
		_magazines = magazines player;
		
		if ("bah_droneBuster_mag" in _magazines) then
		{
			//weapon on fire
			//battery lights on
			[] call fn_cuas_dev_battery;
			
			//check status of LMB, more reliable than EH.
			//if player changes LMB state when RTE is open, this does not work.
			_idx_LMB_dn = inputAction "DefaultAction";
			
			if (_idx_LMB_dn > 0) then
			{
				if (_weapon == "bah_cuas_droneBuster_3B") then
				{
					//LMB DN
					//show jam with red or green light
					
					_weaponState = weaponState player;
					_mode = _weaponState select 2;  //[Land, SendHome, Land_2, SendHome_2]
					
					_color = [1,0,0,1];  //default red for Land/c2+GPS
					
					if ("SendHome" in _mode) then
					{
						_color = [0, 1, 0, 1];  //green for sendHome/c2
					};
					
					//create timer to turn jam light on
					if
					(
						isNil "BAH_CUAS_JAM_LIGHT_ON" &&
						time > (_timeOFF + _jamLight_duration) 
					)
					then
					{
						["LIGHT_JAM", 1, _color] call fn_cuas_dev_change_lights;  //0 = random lights, 1= user defined
						
						BAH_CUAS_JAM_LIGHT_ON = TRUE;
						_timeON = time;  //record time in sec				
					};

					//timer to turn light off
					if 
					(
						!(isNil "BAH_CUAS_JAM_LIGHT_ON") &&
						time > (_timeON + _jamLight_duration) 
					)
					then
					{
						["LIGHT_JAM", 1, [1,1,1,1]] call fn_cuas_dev_change_lights;  //0 = random lights, 1= user defined
						
						BAH_CUAS_JAM_LIGHT_ON = nil;	
						_timeOFF = time;
					};
					
					//reset signal light to white
					["LIGHT_SIG", 1, [1,1,1,1]] call fn_cuas_dev_change_lights;  //0 = random lights, 1= user defined
				}
				elseIf (_weapon == "bah_cuas_droneBuster") then
				{
					//original drone buster, jam light, show all colors
					["LIGHT_JAM", 0, []] call fn_cuas_dev_change_lights;  //0 = random lights, 1= user defined
					
					//reset signal light to white
					["LIGHT_SIG", 1, [1,1,1,1]] call fn_cuas_dev_change_lights;  //0 = random lights, 1= user defined
				};
			}
			else
			{
				//LMB UP
				//show jam with white light
				["LIGHT_JAM", 1, [1,1,1,1]] call fn_cuas_dev_change_lights;  //0 = random lights, 1= user defined
				
				_max_sigStrength = 4; //default signal strength
				_timeON = time;  //save time for drone buster 3B

				//find possible drones					
				_weapon = currentWeapon player;
				_tgtArray = [player, _weapon, ""] call fn_cuas_dev_findTgts;

				_count = count _tgtArray;

				if (_count > 0) then
				{
					for "_i" from 0 to (_count -1) do
					{
						_tgt = _tgtArray select _i;
						_tgt_dis = player distance _tgt;  //slant range
						
						_tgt_typeof = typeOf _tgt;
						_tgt_freq = getNumber (configFile >> "CfgVehicles" >> _tgt_typeof >> "MinOperatingFrequencyFCC");

						_tgt_freq_format = [_tgt_freq, 2] call fn_vbs_cutDecimals;
						
						_light_color = [1,1,1,1];	//default color white
						
						if (_tgt_freq_format >= 5.8) then
						{
							_light_color = [0.65,0,0.65,1]; //purple
						}
						elseIf (_tgt_freq_format >= 3.3) then
						{
							_light_color = [0,1,1,1]; //cyan, video downlink	
						}						
						elseIf (_tgt_freq_format >= 2.4) then
						{
							_light_color = [1,0,0,1]; //red, most commercial drones	
						}
						elseIf (_tgt_freq_format >= 1.26) then
						{
							_light_color = [0,0,1,1]; //blue
						}
						elseIf (_tgt_freq_format >= .915) then
						{
							_light_color = [0,1,0,1]; //green
						};					
						
						_sigStrength = 4; //default signal strength
						
						//calculate signal strength based on tgt dis and device max range
						_signal_factor = _tgt_dis/BAH_CUAS_DEVICE_RANGE;  //1 = far .1 = close
	
						if (_signal_factor < .25) then
						{
							_sigStrength = 4;
						}
						elseIf (_signal_factor < .50) then
						{
							_sigStrength = 3;
						}
						elseIf (_signal_factor < .75) then
						{
							_sigStrength = 2;
						}
						elseIf (_signal_factor < 1.0) then
						{
							_sigStrength = 1;
						};
						
						//color each light based on signal strength
						for "_j" from 1 to 4 do
						{
							//search word
							_light_name = format ["LIGHT_SIG_%1", _j];
				
							if (_sigStrength >= _j) then
							{
								//color this light
								[_light_name, 1, _light_color] call fn_cuas_dev_change_lights;  //0 = random lights, 1= user defined
							}
							else
							{
								//outside tgt_dis, color light white
								[_light_name, 1, [1,1,1,1]] call fn_cuas_dev_change_lights;  //0 = random lights, 1= user defined	
							};
							
							_idx_LMB_dn = inputAction "DefaultAction";
/*	
//doesn't do anything						
							//player clicked mousebutton, reset signal lights
							if (_idx_LMB_dn > 0) exitWith
							{
								["LIGHT_SIG", 1, [1,1,1,1]] call fn_cuas_dev_change_lights;
								
								//reset time?
								_timeON = 0;
								_timeOFF = 0;
								
								[-1,5000] diagMessage "Whenn??? mouse button click";
							};
*/
						};
						
						//change light pattern for 3B
						if (_weapon == "bah_cuas_droneBuster_3B") then
						{
							//turn light on, wait, then switch colors
							waitUntil
							{
								sleep .1;

								//exit condition, player clicked mousebutton, reset signal lights
								_idx_LMB_dn = inputAction "DefaultAction";
								
								if (_idx_LMB_dn > 0) exitWith
								{
									//reset time?
									_timeON = 0;
									_timeOFF = 0;
								};
								
								time > (_timeON + _sigLight_duration	)	//keep light on
							};

							_timeON = time;
						}
						else
						{
							sleep .1;
						};
						
						//check if target array has changed, stops loop and updates lights
						_weapon = currentWeapon player;
						_new_tgtArray = [player, _weapon, ""] call fn_cuas_dev_findTgts;
						if
						(
							(count _tgtArray) > 0 &&				//at least 1 target
							str _tgtArray != str _new_tgtArray	//target arrays are different
						)
						exitWith {}
					};
				}
				else
				{
					//no targets change signal lights to white
					["LIGHT_SIG", 1, [1,1,1,1]] call fn_cuas_dev_change_lights;  //0 = random lights, 1= white	
				};
			};
		};
	};

	sleep .1;
};





