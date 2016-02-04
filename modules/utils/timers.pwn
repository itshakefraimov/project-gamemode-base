timer DelayedKick[500](playerid)
	Kick(playerid);

timer LoginTimer[60000](playerid)
{
	if(get:PlayerFlags[playerid]<PLAYER_IS_LOGGED>)
		Kick(playerid);
}	