

//Values for antag preferences, event roles, etc. unified here



//These are synced with the Database, if you change the values of the defines
//then you MUST update the database!
#define ROLE_SYNDICATE "Syndicate"
#define ROLE_TRAITOR "Traitor"
#define ROLE_OPERATIVE "Operative"
#define ROLE_CHANGELING "Changeling"
#define ROLE_WIZARD "Wizard"
#define ROLE_MALF "Malf AI"
#define ROLE_REV "Revolutionary"
#define ROLE_REV_HEAD "Head Revolutionary"
#define ROLE_REV_SUCCESSFUL "Victorious Revolutionary"
#define ROLE_ALIEN "Xenomorph"
#define ROLE_PAI "pAI"
#define ROLE_NINJA "Space Ninja"
#define ROLE_MONKEY "Monkey"
#define ROLE_ABDUCTOR "Abductor"
#define ROLE_REVENANT "Revenant"
#define ROLE_BROTHER "Blood Brother"
#define ROLE_BRAINWASHED "Brainwashed Victim"
#define ROLE_OVERTHROW "Syndicate Mutineer" //Role removed, left here for safety.
#define ROLE_HIVE "Hivemind Host" //Role removed, left here for safety.
#define ROLE_OBSESSED "Obsessed"
#define ROLE_SPACE_DRAGON "Space Dragon"
#define ROLE_SENTIENCE "Sentience Potion Spawn"
#define ROLE_PYROCLASTIC_SLIME "Pyroclastic Anomaly Slime"
#define ROLE_MIND_TRANSFER "Mind Transfer Potion"
#define ROLE_POSIBRAIN "Posibrain"
#define ROLE_DRONE "Drone"
#define ROLE_DEATHSQUAD "Deathsquad"
#define ROLE_LAVALAND "Lavaland"
#define ROLE_INTERNAL_AFFAIRS "Internal Affairs Agent"
#define ROLE_FAMILIES "Familes Antagonists"
#define ROLE_BORER "borer"
#define ROLE_CULTIST "Cultist"

//Missing assignment means it's not a gamemode specific role, IT'S NOT A BUG OR ERROR.
//The gamemode specific ones are just so the gamemodes can query whether a player is old enough
//(in game days played) to play that role
GLOBAL_LIST_INIT(special_roles, list(
	ROLE_TRAITOR = /datum/game_mode/traitor,
	ROLE_BROTHER = /datum/game_mode/traitor/bros,
	ROLE_OPERATIVE = /datum/game_mode/nuclear,
	ROLE_CHANGELING = /datum/game_mode/changeling,
	ROLE_WIZARD = /datum/game_mode/wizard,
	ROLE_MALF,
	ROLE_ALIEN,
	ROLE_PAI,
	ROLE_NINJA,
	ROLE_OBSESSED,
	ROLE_SPACE_DRAGON,
	ROLE_REVENANT,
	ROLE_ABDUCTOR,
	ROLE_INTERNAL_AFFAIRS = /datum/game_mode/traitor/internal_affairs,
	ROLE_SENTIENCE,
	ROLE_BORER,
	ROLE_CULTIST = /datum/game_mode/cult, //PENTEST INCLUSION - Mostly until we can modularize the rest of cult away
))

//Job defines for what happens when you fail to qualify for any job during job selection
#define BERANDOMJOB 1
#define RETURNTOLOBBY 2
