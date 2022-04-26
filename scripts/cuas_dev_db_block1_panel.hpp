

//cuas_dev_db_block1_panel.hpp


class CUAS_DEV_DB_B1_RSC
{
	idd = IDD_DB_B1_RSC;
	duration = 999999;   //how long the resource stays on the screen
	enableSimulation = true;
	movingEnable = true;
	onload = "BAH_CUAS_DEV_RSC = (_this select 0);";

	
	class BAH_CUAS_DEV_IMAGE : RscPicture
	{
		idc = IDC_GENERIC;
		style = ST_PICTURE;
		x = safeZoneX;
		y = safeZoneY;
		w = 0.5;
		h = 0.5;
		
		SizeEx = 0.03;
		
		//insert image
		text = "";	
	};

	class Controls
	{
		//*****************************************************
		//drone buster panel
		class DB_B3_PANEL : BAH_CUAS_DEV_IMAGE
		{
			idc=IDC_DB_B3_PANEL;
		
			x = 3.5*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;
			y = 54.5*uiPixelHeight*BAH_SQ_PIXEL_H;
			w = 26*uiPixelWidth*BAH_SQ_PIXEL_W;
			h = 48*uiPixelHeight*BAH_SQ_PIXEL_H;
			
			text = __CurrentDir__\data\Drone_Buster_3B_panel_ca;	
		};	

		//*****************************************************
		//knobs
		class DB_B3_KNOB_BRIGHT : BAH_CUAS_DEV_IMAGE
		{
			idc=IDC_DB_B3_KNOB_BRIGHT;
			
			x = 8.5*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;
			y = 67.25*uiPixelHeight*BAH_SQ_PIXEL_H;
			w = 4*uiPixelWidth*BAH_SQ_PIXEL_W;
			h = 6*uiPixelHeight*BAH_SQ_PIXEL_H;
			
			text = __CurrentDir__\data\Generic_knob_ca;	
		};	
		class DB_B3_KNOB_MODE : DB_B3_KNOB_BRIGHT
		{
			idc=IDC_DB_B3_KNOB_MODE;
			
			x = 18.0*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;
			y = 79.25*uiPixelHeight*BAH_SQ_PIXEL_H;
		};	
		class DB_B3_KNOB_BAND : DB_B3_KNOB_BRIGHT
		{
			idc=IDC_DB_B3_KNOB_BAND;
			
			x = 8.5*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;
			y = 79.25*uiPixelHeight*BAH_SQ_PIXEL_H;
		};	

		//*****************************************************
		//lights
		class DB_B3_LIGHT_JAM : BAH_CUAS_DEV_IMAGE
		{
			idc=IDC_DB_B3_LIGHT_JAM;
			
			x = 8*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;
			y = 75.25*uiPixelHeight*BAH_SQ_PIXEL_H;
			w = 1.25*uiPixelWidth*BAH_SQ_PIXEL_W;
			h = 2.25*uiPixelHeight*BAH_SQ_PIXEL_H;
			
			text = __CurrentDir__\data\Generic_light_ca;	
		};	

		class DB_B3_LIGHT_SIG_1 : DB_B3_LIGHT_JAM
		{
			idc=IDC_DB_B3_LIGHT_SIG_1;
			
			x = 12.5*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;
		};
		class DB_B3_LIGHT_SIG_2 : DB_B3_LIGHT_JAM
		{
			idc=IDC_DB_B3_LIGHT_SIG_2;
			
			x = 15*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;
		};
		class DB_B3_LIGHT_SIG_3 : DB_B3_LIGHT_JAM
		{
			idc=IDC_DB_B3_LIGHT_SIG_3;
			
			x = 17.5*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;
		};
		class DB_B3_LIGHT_SIG_4 : DB_B3_LIGHT_JAM
		{
			idc=IDC_DB_B3_LIGHT_SIG_4;
			
			x = 20.12*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;
		};

		class DB_B3_LIGHT_BAT_1 : DB_B3_LIGHT_JAM
		{
			idc=IDC_DB_B3_LIGHT_BAT_1;
			
			x = 23.37*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;
			y = 81.5*uiPixelHeight*BAH_SQ_PIXEL_H;
		};
		class DB_B3_LIGHT_BAT_2 : DB_B3_LIGHT_BAT_1
		{
			idc=IDC_DB_B3_LIGHT_BAT_2;
			
			y = 78.25*uiPixelHeight*BAH_SQ_PIXEL_H;
		};
		class DB_B3_LIGHT_BAT_3 : DB_B3_LIGHT_BAT_1
		{
			idc=IDC_DB_B3_LIGHT_BAT_3;
			
			y = 75*uiPixelHeight*BAH_SQ_PIXEL_H;	
		};
		class DB_B3_LIGHT_BAT_4 : DB_B3_LIGHT_BAT_1
		{
			idc=IDC_DB_B3_LIGHT_BAT_4;

			x = 23.25*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;		
			y = 72*uiPixelHeight*BAH_SQ_PIXEL_H;
		};
		class DB_B3_LIGHT_BAT_5 : DB_B3_LIGHT_BAT_1
		{
			idc=IDC_DB_B3_LIGHT_BAT_5;

			x = 23.25*uiPixelWidth*BAH_SQ_PIXEL_W+safeZoneX;					
			y = 69.25*uiPixelHeight*BAH_SQ_PIXEL_H;
		};
	};
};







