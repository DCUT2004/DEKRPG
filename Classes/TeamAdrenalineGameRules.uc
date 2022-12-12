class TeamAdrenalineGameRules extends GameRules
	config(UT2004RPG);

var config int MaterialKillChance;	//The chance to unlock a material upon a kill
var config int LowMaterialChance, MediumMaterialChance;
var config float MonsterScoreMultiplier;	//% of the monster's scoring value to add as adrenaline

function ScoreKill(Controller Killer, Controller Killed)
{
	local int MaterialRankChance;
	local GiveItemsInv GInv;
	local Monster M;
	local MutTeamAdrenaline MutTeamAdren;

	if (Killer != None && Killed != None)
	{
		if (Killer.Pawn != None && Killer.Pawn.Health > 0 && Killed.Pawn != None && Killer.Pawn.GetTeamNum() != Killed.Pawn.GetTeamNum() && !Killed.Pawn.IsA('HealerNali') && !Killed.Pawn.IsA('MissionCow'))
		{
			if (Killed.Pawn != None && Killed.Pawn.IsA('Monster'))
			{
				M = Monster(Killed.Pawn);
				class'MutTeamAdrenaline'.static.AddPlayerTeamAdren(M.ScoringValue * MonsterScoreMultiplier);
			}
			else
				class'MutTeamAdrenaline'.static.AddPlayerTeamAdren(1);
		}
		if (Rand(100) <= MaterialKillChance && Killed.Pawn.IsA('Monster'))		//Quick condition for materials, though not proper (i.e. monster kills a pet)
		{
			GInv = class'GiveItemsInv'.static.GetGiveItemsInv(Killer);
			if (GInv != None)
			{
				MutTeamAdren = Class'MutTeamAdrenaline'.static.GetMutTeamAdrenaline(Level.Game);
				if (MutTeamAdren != None)
				{
					MaterialRankChance = Rand(100);
					if (MaterialRankChance <= LowMaterialChance)
						GInv.AddMaterial(MutTeamAdren.LowMaterials[Rand(MutTeamAdren.LOW_MATERIALS_LENGTH)]);
					else if (MaterialRankChance <= MediumMaterialChance)
						GInv.AddMaterial(MutTeamAdren.MediumMaterials[Rand(MutTeamAdren.MED_MATERIALS_LENGTH)]);
					else
						GInv.AddMaterial(MutTeamAdren.HighMaterials[Rand(MutTeamAdren.HIGH_MATERIALS_LENGTH)]);
				}
			}
		}
	}
	
	Super.ScoreKill(Killer, Killed);
}

defaultproperties
{
	MonsterScoreMultiplier=0.50000000
	MaterialKillChance=1
	LowMaterialChance=80	//80% chance to get a low material
	MediumMaterialChance=95	//15% chance to get a medium material, 5% for a high material
}
