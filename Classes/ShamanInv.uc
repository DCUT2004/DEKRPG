class ShamanInv extends Inventory
     config(UT2004RPG);

var config int RegenRate;
var config int RegenAmountPerPlayer;
var config int HealthMaxBonus;
var RPGRules Rules;
var Material EffectOverlay;
var float EXPMultiplier;
var MissionInvBETA MissionInv;

simulated function PostBeginPlay()
{
     Super.PostBeginPlay();
	CheckRPGRules();
     EXPMultiplier = getExpMultiplier();
     SetTimer(RegenRate , True);
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
     Super.GiveTo(Other);

     if (Other == None || Other.Controller == None)
          return;
     
     MissionInv = class'MissionInvBETA'.static.GetMissionInv(Other.Controller);
}

function float getExpMultiplier()
{
     local ArtifactMakeSuperHealer AMSH;

     if (Instigator == None)
          return class'RW_Healer'.default.EXPMultiplier;
     
	AMSH = ArtifactMakeSuperHealer(Instigator.FindInventoryType(class'ArtifactMakeSuperHealer'));
	if(AMSH != None)
		return AMSH.EXPMultiplier;

	return class'RW_Healer'.default.EXPMultiplier;
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function Timer()
{
     local Controller C, NextC;
	local int HealthGiven;
     local Pawn P;

     if (Instigator == None || Instigator.Health <= 0)
     {
          Destroy();
          return;
     }

     C = Level.ControllerList;
     while (C != None)
     {
          NextC = C.NextController;

          if (C != None && C.Pawn != None && C.Pawn != Instigator && C.Pawn.Health > 0 && C.Pawn.Health < C.Pawn.HealthMax + HealthMaxBonus && Instigator.Health > Instigator.HealthMax && C.Pawn.GetTeamNum() == Instigator.GetTeamNum() && !C.Pawn.IsA('Monster') && HardCoreInv(C.Pawn.FindInventoryType(class'HardCoreInv')) == None)
          {
               if (C.Pawn.IsA('Vehicle') && Vehicle(C.Pawn).Driver != None)
                    P = Vehicle(C.Pawn).Driver;
               else
                    P = C.Pawn;
               HealthGiven =
                    Min
                    (
                         (P.HealthMax + HealthMaxBonus) - P.Health,
                         RegenAmountPerPlayer
                    );
               
               if(HealthGiven > 0)
               {
                    P.GiveHealth(HealthGiven, P.HealthMax + HealthMaxBonus);
                    P.SetOverlayMaterial(EffectOverlay, 0.5, false);
                    doHealed(HealthGiven, P);	// no exp for healing pets

                    if(PlayerController(C) != None)	
                    {
                         PlayerController(C).ReceiveLocalizedMessage(class'HealedConditionMessage', 0, Instigator.PlayerReplicationInfo);
               
                         P.PlaySound(sound'PickupSounds.HealthPack',, 2 * P.TransientSoundVolume,, 1.5 * P.TransientSoundRadius);
                    }
                    Instigator.Health -= HealthGiven;
               }
          }

          C = NextC;
     }
}

function doHealed(int HealthGiven, Pawn Victim)
{
	Local HealableDamageInv Inv;
	local int ValidHealthGiven;
	local float GrantExp;
	local RPGStatsInv StatsInv;
	
	Inv = HealableDamageInv(Victim.FindInventoryType(class'HealableDamageInv'));
	if(Inv != None)
	{
		ValidHealthGiven = Min(HealthGiven, Inv.Damage);
		if(ValidHealthGiven > 0)
		{
			StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv == None)
			{
				log("Warning: No stats inv found. Healing exp not granted.");
				return;
			}

			GrantExp = EXPMultiplier * float(ValidHealthGiven);

			Inv.Damage -= ValidHealthGiven;
			
			Rules.ShareExperience(StatsInv, GrantExp);
		}

		//help keep things in check so a player never has surplus damage in storage.
		if(Inv.Damage > (Victim.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus) - Victim.Health)
			Inv.Damage = Max(0, (Victim.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus) - Victim.Health); //never let it go negative.
	}
     if (MissionInv != None && MissionInv.IsMissionActive("Life Mend"))
	     MissionInv.TickMission(MissionInv.GetMissionIndex("Life Mend"), ValidHealthGiven);
}

defaultproperties
{
     RegenRate=2
     RegenAmountPerPlayer=10
     HealthMaxBonus=200
     EffectOverlay=Shader'UTRPGTextures2.Overlays.PulseBlueShader1'
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
