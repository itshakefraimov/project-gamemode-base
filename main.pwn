/*===============================================================================  

	by hydro
		& Thanks to SouthClaw for the info
=================================================================================*/
#include <a_samp>

#undef MAX_PLAYERS
#define MAX_PLAYERS 20																		

new
bool:	gServerInitialising;

enum // Dialogs
{
	DIALOG_UNUSED = 0, // Without response
	
	DIALOG_LOGIN
}

/*===============================================================================  

	OnGamdeModeInit initialization (called before ANYTHING)

=================================================================================*/   

public OnGameModeInit()
{
	gServerInitialising = true;
	print("\n[Main] Initialising gamemode...");

	OnGameModeInit_Setup();
		
	#if defined main_OnGameModeInit
		return main_OnGameModeInit();
	#else
		return 1;
	#endif
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
 
#define OnGameModeInit main_OnGameModeInit
#if defined main_OnGameModeInit
	forward main_OnGameModeInit();
#endif

/*===============================================================================

	Libraries & Includes

=================================================================================*/ 

#include <sscanf2>					// by Y_Less
#include <YSI\y_timers>				// by Y_Less
#include <YSI\y_hooks>				// by Y_Less

#include <a_mysql>					// by BlueG & maddinat0r
#include <zcmd>						// by Zeex						

native WP_Hash(buffer[], len, const str[]);

/*===============================================================================

	Definitions

=================================================================================*/ 

#define GAMEMODE_NAME								"0.0.1"
#define GAMEMODE_UCP								"www.gamemode.com/ucp"
#define SERVER_NAME									"Project"
#define SERVER_HOSTNAME								"hostname Project Gamemode"
#define SERVER_MAP									"mapname Los Santos"

#define t:%1<%2>					((%1)|=(%2))
#define f:%1<%2>					((%1)&=~(%2))
#define get:%1<%2>            		((%1) & (%2))	

#define function%0(%1)	forward%0(%1); public%0(%1)

/*===============================================================================

	Gamemode Scripts

=================================================================================*/ 

// data
#include "modules\data\player.pwn"

// utilities	
#include "modules\utils\colours.pwn"
#include "modules\utils\timers.pwn"

// core
#include "modules\core\server\database-connection.pwn"
#include "modules\core\player\login.pwn"

OnGameModeInit_Setup()
{
	print("\n[OnGameModeInit_Setup] Setting up...");

	SetGameModeText(GAMEMODE_NAME);
	SendRconCommand(SERVER_HOSTNAME);	
	SendRconCommand(SERVER_MAP);	

	OnMySQLConnection();

	return 1;
}

public OnGameModeExit()
{
	print("\n[OnGameModeExit] Shutting down...");

	mysql_close(gSQL);
	return 1;
}

main()
{
	gServerInitialising = false;

	print("\n\n----------------------------------------\n\n");
	printf("	%s", SERVER_NAME);
	print("\n\n----------------------------------------\n\n");
}

public OnPlayerConnect(playerid)
{
	if(gServerInitialising)
		Kick(playerid);
	return 1;
}