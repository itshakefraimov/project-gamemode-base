#define MYSQL_HOST									"localhost"
#define	MYSQL_USER          						"root"
#define MYSQL_DATABASE								"sa-mp"
#define	MYSQL_PASSWORD								""

new
	gSQL = -1;

function OnMySQLConnection()
{
	print("[OnMySQLConnection] Connecting to database...");

	mysql_log(LOG_WARNING | LOG_ERROR, LOG_TYPE_HTML);

	gSQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DATABASE, MYSQL_PASSWORD);
	if(mysql_errno() != 0) 
		print("[OnMySQLConnection] ERROR! Database connection failed."),
		SendRconCommand("exit");
	else
		print("[OnMySQLConnection] Connection to the database has been established.");
		
	return 1;
}
