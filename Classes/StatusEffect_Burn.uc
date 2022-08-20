class StatusEffect_Burn extends StatusEffect
	config(UT2004RPG);
	
var RPGRules Rules;
var config float BasePercentage;
var config float Curve;
var config int MaxBurnDamage;
var SuperHeatFX FX;

function StartEffect(Pawn Target)
{
	CheckRPGRules();
	if (Target != None)
	{
		FX = Spawn(class'SuperHeatFX', Target,, Target.Location);
		if (FX != None)
		{
			FX.SetLocation(Target.Location);
			FX.SetRotation(Target.Rotation + rot(0, -16384, 0));
			FX.SetBase(Target);
			FX.bOwnerNoSee = true;
			FX.Emitters[0].LifetimeRange.Min = Lifespan;
			FX.Emitters[0].LifetimeRange.Max = Lifespan;
			FX.RemoteRole = ROLE_SimulatedProxy;
		}
	}
	SetTimer(1, True);
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function Timer()
{
	local int BurnDamage;
	
	if (Instigator == None || Instigator.Health <= 0)
		Destroy();
	if (Modifier > 0)		//This is an ailment only
		Destroy();
		
	BurnDamage = int(float(Instigator.Health) * (Curve **(abs(Modifier)-1)*BasePercentage));
	if (BurnDamage > MaxBurnDamage)
		BurnDamage = MaxBurnDamage;
	if(BurnDamage > 0)
	{
		if(Instigator.Controller != None && Instigator.Controller.bGodMode == False
			&& InvulnerabilityInv(Instigator.FindInventoryType(class'InvulnerabilityInv')) == None)
		{
			if (Instigator.Health <= BurnDamage)
				BurnDamage = Instigator.Health -1;
			Instigator.Health -= BurnDamage;
			
			if(Producer != None && Producer.Controller != None && Instigator != Producer) //exp only for harming others.
			{
				if (Rules != None)
					Rules.AwardEXPForDamage(Producer.Controller, RPGStatsInv(Producer.FindInventoryType(class'RPGStatsInv')), Instigator, BurnDamage);
				// and add the damage as healable
				class'StatusEffect_Burn'.static.AddHealableDamage(BurnDamage, Instigator);
			}
		}
	}
}

static function AddHealableDamage(int Damage, Pawn Injured)
{
	Local HealableDamageInv Inv;

	if(Injured == None || Injured.Controller == None || Injured.Health <= 0 || Damage < 1)
		return; // Not EXP Healable

	if(Injured.isA('Monster') && !Injured.Controller.isA('DEKFriendlyMonsterController'))
		return; 	// No tracking for not friendly monsters.

	Inv = HealableDamageInv(Injured.FindInventoryType(class'HealableDamageInv'));
	if(Inv == None)
	{
		Inv = Injured.spawn(class'HealableDamageInv');
		Inv.giveTo(Injured);
	}

	if(Inv == None)
	    return;

	Inv.Damage += Damage;

	if(Inv.Damage > Injured.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus)
		Inv.Damage = Injured.HealthMax + Class'HealableDamageGameRules'.default.MaxHealthBonus;
}

function StopEffect(Pawn Target)
{
	SetTimer(0, False);
	if (FX != None)
	{
		FX.Kill();
		FX.Destroy();
	}
}

defaultproperties
{
	 MaxModifier=5
	 StatusEffectName="Burn"
	 bOnlyNegativeModifier=True
     BasePercentage=0.050000
     Curve=1.300000
     MaxBurnDamage=50
}
