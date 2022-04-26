

//cuas_dev_positionCtrls.sqf

//position controls for Drone Buster 1B and 3B

//special defines
#include "\vbs2\customer\weapons\bah_CUAS_devices\data\scripts\cuas_dev_projectdefines.hpp"
#include "\vbs2\customer\weapons\bah_CUAS_devices\data\scripts\cuas_dev_defines.hpp"


//to quickly change from packed addon or P: drive
#ifdef CUAS_DEV_USE_MISSION_SCRIPTS
	_projectDataFolder = "P:\vbs2\customer\weapons\bah_CUAS_devices\data\";
#else
	_projectDataFolder = "\vbs2\customer\weapons\bah_CUAS_devices\data\";
#endif


//passed array [_weapon]

_weapon = _this select 0;

//init some variables
_configControls = [];
_xPos = -1;
_yPos = -1;
_numSq_X = 1;
_numSq_Y = 1;
_image = "";

//define displya
_display_rsc = BAH_CUAS_DEV_RSC;
	
//find ctrls
_configControls = "!('ANY' in configName _x)" configClasses (configFile >> "RscTitles" >> "CUAS_DEV_DB_B3_RSC" >> "Controls");

//position ctrls, using this method, we can recycle rsc used for OG and 3B drone buster
{
	_idc = getNumber (configFile >> "RscTitles" >> "CUAS_DEV_DB_B3_RSC" >> "Controls">> configName _x >> "idc");
	_ctrl = _display_rsc displayCtrl _idc;

	if (_weapon == "bah_cuas_droneBuster") then
	{
		switch (_idc) do
		{
			//drone buster body
			case IDC_DB_B3_PANEL:
			{
				_numSq_X = 4;
				_numSq_Y = 46;
				_image = "DroneBuster_1B_panel_ca";
				
				_ctrl ctrlSetText format ["%1%2.paa", _projectDataFolder, _image];
			};
			case IDC_DB_B3_KNOB_BRIGHT:
			{
				_numSq_X = 20.25;
				_numSq_Y = 56.75;
				_image = "dronebuster_1b_knob_ca";
				
				_ctrl ctrlSetText format ["%1%2.paa", _projectDataFolder, _image];
			};		
			case IDC_DB_B3_KNOB_MODE:
			{
				_numSq_X = 10;
				_numSq_Y = 55.25;
				_image = "dronebuster_1b_knob_ca";
				
				_ctrl ctrlSetText format ["%1%2.paa", _projectDataFolder, _image];
			};	
			case IDC_DB_B3_KNOB_BAND:
			{
				_numSq_X = 10;
				_numSq_Y = 72.25;
				_image = "dronebuster_1b_knob_ca";
				
				_ctrl ctrlSetText format ["%1%2.paa", _projectDataFolder, _image];
			};	

			//lights	
			case IDC_DB_B3_LIGHT_JAM:
			{
				_numSq_X = 16.25;
				_numSq_Y = 52.5;							
			};
			case IDC_DB_B3_LIGHT_SIG_4:
			{
				_numSq_X = 16.25;
				_numSq_Y = 61.0;							
			};
			
			case IDC_DB_B3_LIGHT_SIG_3:
			{
				_numSq_X = 16.25;
				_numSq_Y = 66.50;										
			};
			case IDC_DB_B3_LIGHT_SIG_2:
			{
				_numSq_X = 16.25;
				_numSq_Y = 71.75;										
			};
			case IDC_DB_B3_LIGHT_SIG_1:
			{
				_numSq_X = 16.25;
				_numSq_Y = 77.50;										
			};
			case IDC_DB_B3_LIGHT_BAT_1:
			{
				_numSq_X = 11.75;
				_numSq_Y = 83.75;										
			};	
			case IDC_DB_B3_LIGHT_BAT_2:
			{
				_numSq_X = 14;
				_numSq_Y = 83.75;						
			};
			case IDC_DB_B3_LIGHT_BAT_3:
			{
				_numSq_X = 16.5;
				_numSq_Y = 83.75;						
			};
			case IDC_DB_B3_LIGHT_BAT_4:
			{
				_numSq_X = 19;
				_numSq_Y = 83.75;						
			};
			case IDC_DB_B3_LIGHT_BAT_5:
			{
				_numSq_X = 21.25;
				_numSq_Y = 83.75;
			};
		};
	}
	elseif (_weapon == "bah_cuas_droneBuster_3B") then
	{
		switch (_idc) do
		{
			//drone buster body
			case IDC_DB_B3_PANEL:
			{
				_numSq_X = 3.50;
				_numSq_Y = 54.50;
				_image = "DroneBuster_3B_panel_ca";
				
				_ctrl ctrlSetText format ["%1%2.paa", _projectDataFolder, _image];
			};
			case IDC_DB_B3_KNOB_BRIGHT:
			{
				_numSq_X = 8.50;
				_numSq_Y = 67.25;
				_image = "Generic_knob_ca";
				
				_ctrl ctrlSetText format ["%1%2.paa", _projectDataFolder, _image];
			};		
			case IDC_DB_B3_KNOB_MODE:
			{
				_numSq_X = 18.00;
				_numSq_Y = 79.25;
				_image = "Generic_knob_ca";
				
				_ctrl ctrlSetText format ["%1%2.paa", _projectDataFolder, _image];
			};	
			case IDC_DB_B3_KNOB_BAND:
			{
				_numSq_X = 8.5;
				_numSq_Y = 79.25;
				_image = "Generic_knob_ca";
				
				_ctrl ctrlSetText format ["%1%2.paa", _projectDataFolder, _image];
			};	

			//lights	
			case IDC_DB_B3_LIGHT_JAM:
			{
				_numSq_X = 8;
				_numSq_Y = 75.25;							
			};
			case IDC_DB_B3_LIGHT_SIG_4:
			{
				_numSq_X = 20.12;
				_numSq_Y = 75.25;							
			};
			case IDC_DB_B3_LIGHT_SIG_3:
			{
				_numSq_X = 17.50;
				_numSq_Y = 75.25;										
			};
			case IDC_DB_B3_LIGHT_SIG_2:
			{
				_numSq_X = 15.00;
				_numSq_Y = 75.25;										
			};
			case IDC_DB_B3_LIGHT_SIG_1:
			{
				_numSq_X = 12.50;
				_numSq_Y = 75.25;										
			};
			case IDC_DB_B3_LIGHT_BAT_1:
			{
				_numSq_X = 23.37;
				_numSq_Y = 81.50;										
			};	
			case IDC_DB_B3_LIGHT_BAT_2:
			{
				_numSq_X = 23.37;
				_numSq_Y = 78.25;						
			};
			case IDC_DB_B3_LIGHT_BAT_3:
			{
				_numSq_X = 23.37;
				_numSq_Y = 75.00;						
			};
			case IDC_DB_B3_LIGHT_BAT_4:
			{
				_numSq_X = 23.25;
				_numSq_Y = 72.00;						
			};
			case IDC_DB_B3_LIGHT_BAT_5:
			{
				_numSq_X = 23.25;
				_numSq_Y = 69.25;
			};
		};	
	};

	_xPos = safeZoneX +(_numSq_X*uiPixelWidth*BAH_SQ_PIXEL_W);
	_yPos = _numSq_Y*uiPixelHeight*BAH_SQ_PIXEL_H;

	_ctrl ctrlSetPosition [_xPos, _yPos];
	
	//commit changes
	_ctrl ctrlCommit 0;

}forEach _configControls;


	
	
	
	