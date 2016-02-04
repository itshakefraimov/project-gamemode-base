# project-gamemode-base
Based on modular programming, this gamemode is intended to make big projects become more readable and easy to modify

##Requirements
* MySQL by BlueG & maddinat0r
* YSI by Y_Less
* sscanf by Y_Less
* zcmd by Zeex

##Installation
First, you need to create a new database with the specific table(s) by importing the .sql file in the repository.

Then simply put all the files and folders in the gamemode folder of your server.

Modify **modules\core\server\database-connection** to your database login information.
```pawn
define MYSQL_HOST					"localhost"
define MYSQL_USER          				"root"
define MYSQL_DATABASE				"sa-mp"
define MYSQL_PASSWORD				""
```


> **Note:** Change the variable **MAX_PLAYERS** to your server's maximum players.