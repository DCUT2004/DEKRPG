class ComboCurseInv extends ComboEffectInv;

var RPGRules RPGRules;
var int TimeRemaining;

function PostBeginPlay()
{
	Local GameRules G;
	
	super.PostBeginPlay();
	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			RPGRules = RPGRules(G);
			break;
		}
	}

	if(RPGRules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local RW_MagicalWard W;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;
	
	bBuff = False;
	
	if (Other != None)
	{
		WardInv = ComboWardInv(Other.FindInventoryType(Class'ComboWardInv'));
		if (WardInv != None && Rand(100) <= WardInv.EffectMultiplier)
		{
			if (Other.Controller != None && PlayerController(Other.Controller) != None)
				PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG209E.ComboSounds.Ward');
			Destroy();
			return;
		}

		if (Other.Weapon != None && Other.Weapon.IsA('RW_MagicalWard') && !bBuff)
		{
			W = RW_MagicalWard(Other.Weapon);
			if (Rand(100) <= W.Modifier*W.ChanceToWardPerModifier)
			{
				MWInv = MagicalWardProtectionInv(Other.FindInventoryType(class'MagicalWardProtectionInv'));
				if (MWInv == None)
				{
					MWInv = Other.Spawn(Class'MagicalWardProtectionInv');
					MWInv.GiveTo(Other);
				}
				else
				{
					MWInv.Lifespan = MWInv.default.Lifespan;
					MWInv.ProtectionMultiplier -= MWInv.ProtectionPerWardMultiplier;
					if (MWInv.ProtectionMultiplier < MWInv.MaxProtectionMultiplier)
						MWInv.ProtectionMultiplier = MWInv.MaxProtectionMultiplier;
				}
				if (Other.Controller != None && PlayerController(Other.Controller) != None)
					PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG209E.ComboSounds.Ward');
				Destroy();
				return;
			}
		}
	}
	TimeRemaining = Lifespan;
	if (TimeRemaining <= 0)
	{
		Destroy();
		return;
	}
	Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	Super.GiveTo(Other);
}

simulated function Timer()
{
	local int CurseDamage;
	
	if (PawnOwner != None)
	{
		CurseDamage = PawnOwner.Health * EffectMultiplier;
		if (CurseDamage >= PawnOwner.Health)
			CurseDamage = PawnOwner.Health-1;
		if (Enemy != None)
		{
			Enemy.GiveHealth(CurseDamage, Enemy.HealthMax);
			if (RPGRules != None)
				RPGRules.AwardEXPForDamage(Enemy.Controller, RPGStatsInv(Enemy.FindInventoryType(class'RPGStatsInv')), PawnOwner, CurseDamage);
			// and add the damage as healable
			class'DruidPoisonInv'.static.AddHealableDamage(CurseDamage, PawnOwner);
		}
	}
	TimeRemaining--;
	Super.Timer();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return Default.ComboNameMessage $ Switch $ Default.SecondsMessage;
}

simulated function Destroyed()
{
	local Controller C, NextC;
	local ComboCurseInv Inv;
	//Seek a new target to Curse
	
	if (TimeRemaining > 1)
	{
		C = Level.ControllerList;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.GetTeamNum() == PawnOwner.GetTeamNum() && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.IsA('TarydiumCrystal'))
			{
				Inv = ComboCurseInv(C.Pawn.FindInventoryType(Class'ComboCurseInv'));
				if (Inv == None)
				{
					Inv = C.Pawn.Spawn(Class'ComboCurseInv');
					Inv.EffectMultiplier = EffectMultiplier;
					Inv.Lifespan = TimeRemaining;
					Inv.Enemy = Enemy;
					Inv.GiveTo(C.Pawn);
					Log("A new target has been cursed! Time remaining: " $ TimeRemaining);
					break;
				}
			}
			C = NextC;
		}
	}
	super.destroyed();
}

defaultproperties
{
	 bBuff=False
	 ComboNameMessage="- Curse: "
	 EffectxEmitterClass=Class'DEKRPG209E.ComboCurseFX'
}
