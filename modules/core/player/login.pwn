#include <YSI\y_hooks>

static
	PlayerSQLState[MAX_PLAYERS];

hook OnPlayerConnect(playerid)
{
	TogglePlayerSpectating(playerid, true);
	PlayerSQLState[playerid]++;
	new _resetEnum[E_PLAYER_DATA];
	Player[playerid] = _resetEnum;

	GetPlayerName(playerid, Player[playerid][Name], MAX_PLAYER_NAME);

	new query[75];
	mysql_format(gSQL, query, sizeof(query), "SELECT * FROM `players` WHERE `name` = '%e' LIMIT 1", Player[playerid][Name]);
	mysql_tquery(gSQL, query, "OnPlayerDataLoaded", "dd", playerid, PlayerSQLState[playerid]);
	return 1;
}	

public OnPlayerDisconnect(playerid, reason)
{
	UpdatePlayerData(playerid);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_UNUSED)
		return 1;

	switch(dialogid)
	{
	    case DIALOG_LOGIN:
	    {
	        if(!response)
	            return Kick(playerid);

			if(strlen(inputtext) < 6)
				return ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, SERVER_NAME,
					CHAT_RED "Your password must be longer than 5 characters!\n\n"CHAT_LIGHTBLUE"NOTE: "CHAT_WHITE"You have 60 seconds to log-in.",
					"Login", "Abort");

			new hashed_pass[129];
			WP_Hash(hashed_pass, sizeof(hashed_pass), inputtext);
			
			if(strcmp(hashed_pass, Player[playerid][Password]) == 0)
			{
				// Correct password, logged in
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, SERVER_NAME, "You have been successfully logged in.", "Continue", "");
				t:PlayerFlags[playerid]<PLAYER_IS_LOGGED>;

				TogglePlayerSpectating(playerid, false);	
			    SetSpawnInfo(playerid, 0, 0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
			}
			else
			{
				ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, SERVER_NAME, 
					CHAT_RED"Wrong password!\n\n"CHAT_LIGHTBLUE"NOTE: "CHAT_WHITE"You have 60 seconds to log-in.", 
					"Login", "Abort");
			}
	    }	    
	}
	return 1;
}

function OnPlayerDataLoaded(playerid, playersqlstate)
{
	if(playersqlstate != PlayerSQLState[playerid])
	    return Kick(playerid);
	
	if(cache_num_rows() > 0)
	{
        AssignPlayerData(playerid);
        
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, SERVER_NAME,
			CHAT_WHITE"Welcome back, please login by typing your password below:\n\n"CHAT_LIGHTBLUE"NOTE: "CHAT_WHITE"You have 60 seconds to log-in.",
			"Login", "Abort");
		defer LoginTimer(playerid);
	}
	else
	{
		SendClientMessage(playerid, RED, "ERROR! " CHAT_WHITE "This name is not recognized in our database.");

		new
			string[128];
		format(string, sizeof(string), 
			"INFO: " CHAT_WHITE "Head over to our UCP at (" CHAT_YELLOW "%s" CHAT_WHITE ") and register.", GAMEMODE_UCP);
		SendClientMessage(playerid, YELLOW, string);
		defer DelayedKick(playerid);
	}
	return 1;
}

AssignPlayerData(playerid)
{
	Player[playerid][ID] = cache_get_row_int(0, 0, gSQL);
	cache_get_row(0, 2, Player[playerid][Password], gSQL, 129);
	return 1;
}

UpdatePlayerData(playerid)
{
	if(!get:PlayerFlags[playerid]<PLAYER_IS_LOGGED>)
	    return 0;
	    
	new query[256];
	mysql_format(gSQL, query, sizeof(query), "UPDATE `players` SET `name` = '%e', `password` = '%e' WHERE `id` = '%d' LIMIT 1",
		Player[playerid][Name], Player[playerid][Password], Player[playerid][ID]);
	mysql_tquery(gSQL, query);
	return 1;
}
