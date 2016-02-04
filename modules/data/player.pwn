enum E_PLAYER_DATA
{
	ID,
	Name[MAX_PLAYER_NAME],
	Password[129]
}

enum E_PLAYER_FLAGS:(<<= 1) {
	PLAYER_IS_LOGGED = 1, // First flag must be equal to 1 else everything will be 0.
	// ...
};

new
	Player[MAX_PLAYERS][E_PLAYER_DATA],
	E_PLAYER_FLAGS:PlayerFlags[MAX_PLAYERS];