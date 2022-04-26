

//cuas_dev_defines.hpp


//constants

#define BAH_COLOR_WHITE					{1,1,1,1}	

//#define BAH_CUAS_COLOR_ARRAY			[[1,0,0,1], [0.65,0,0.65,1], [0,1,0,1], [0,0,1,1]]  //[[red], [purple], [green], [ blue]]

#define BAH_CUAS_COLOR_ARRAY			[[0,1,0,1], [0,0,1,1], [1,0,0,1], [0,1,1,1], [0.65,0,0.65,1]] //[[green],[blue],[red],[cyan],[purple]]

//hud defines

#define	BAH_SQ_SIZE_W	safeZoneW/100  //returns % of screen for each square
#define BAH_SQ_SIZE_H	safeZoneH/100  //returns % of screen for each square
#define BAH_VIEWPORT_W	(getResolution select 2)  //viewport width
#define BAH_VIEWPORT_H	(getResolution select 3)  //viewport width
#define BAH_SQ_PIXEL_W	BAH_SQ_SIZE_W*BAH_VIEWPORT_W  //width of each square in pixels
#define BAH_SQ_PIXEL_H	BAH_SQ_SIZE_H*BAH_VIEWPORT_H  //height of each square in pixels

#define IDC_GENERIC						-1

#define IDD_DB_B3_RSC					10000

//panel
#define IDC_DB_B3_PANEL					10001

//knobs
#define IDC_DB_B3_KNOB_BRIGHT			10002
#define IDC_DB_B3_KNOB_MODE				10003
#define IDC_DB_B3_KNOB_BAND				10004

//lights
#define IDC_DB_B3_LIGHT_JAM				10005

#define IDC_DB_B3_LIGHT_SIG_1			10006
#define IDC_DB_B3_LIGHT_SIG_2			10007
#define IDC_DB_B3_LIGHT_SIG_3			10008
#define IDC_DB_B3_LIGHT_SIG_4			10009

#define IDC_DB_B3_LIGHT_BAT_1			10010  
#define IDC_DB_B3_LIGHT_BAT_2			10011  
#define IDC_DB_B3_LIGHT_BAT_3			10012
#define IDC_DB_B3_LIGHT_BAT_4			10013
#define IDC_DB_B3_LIGHT_BAT_5			10014











