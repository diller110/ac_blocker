#pragma semicolon 1
#pragma newdecls required

#include <aclib>
#include <ac_zones3>

public Plugin myinfo = {
	name = "AC: Two-way Blocker",	author = "diller110",
	description = "", version = "1.0a",	url = ""
};

JSON_Array blocksA0, blocksA1, blocksB0, blocksB1;
int round = 0;
bool isWarmup = false;

public void OnPluginStart() {
	HookEvent("round_start", Event_RoundStart);
	
	Zone_OnZonesLoaded();
}
public void Zone_OnZonesLoaded() {
	round = 0;
	if(blocksA0 != null) delete blocksA0;
	if(blocksA1 != null) delete blocksA1;
	if(blocksB0 != null) delete blocksB0;
	if(blocksB1 != null) delete blocksB1;
	blocksA0 = Zone_FindZones(Zone_Point, "blocksA0");
	blocksA1 = Zone_FindZones(Zone_Point, "blocksA1");
	blocksB0 = Zone_FindZones(Zone_Point, "blocksB0");
	blocksB1 = Zone_FindZones(Zone_Point, "blocksB1");
}
public void Event_RoundStart(Event event, const char[] name, bool dontBroadcast) {
	isWarmup = GameRules_GetProp("m_bWarmupPeriod") == 1;
	if (isWarmup) return;
	
	round++;
	
	int ct = GetTeamClientCount(CS_TEAM_CT);
	int t = GetTeamClientCount(CS_TEAM_T);
	
	if(ct <= 2 || t <= 2) {
		PrintToChatAll("[\x03!blocker\x01] В одной из команд \x03меньше 3\x01 игроков, \x03плент %s заблокирован.", ((round%2==0)?"A\x01":"B\x01"));
		if(round%2 == 0) {
			SpawnBlocks(blocksB0);
		} else {
			SpawnBlocks(blocksA0);
		}
	} else if(ct<=4 || t <= 4) {
		PrintToChatAll("[\x03!blocker\x01] В одной из команд \x03меньше 5\x01 игроков, \x03плент %s заблокирован.", ((round%2==0)?"A\x01":"B\x01"));
		if(round%2 == 0) {
			if(blocksB1.Length) {
				SpawnBlocks(blocksB1);
			} else {
				SpawnBlocks(blocksB0);
			}
		} else {
			if(blocksA1.Length) {
				SpawnBlocks(blocksA1);
			} else {
				SpawnBlocks(blocksA0);
			}
		}
	}
}
void SpawnBlocks(JSON_Array blocks) {
	Zone z = null;
	for (int i = 0; i < blocks.Length; i++) {
		z = view_as<Zone>(blocks.GetObject(i));
		Zone_Spawn(z, true);
	}
}