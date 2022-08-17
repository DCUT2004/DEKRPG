class StatusEffect_Poison extends StatusEffect
	config(UT2004RPG);

var RPGRules Rules;
var config float BasePercentage;
var config float Curve;

function StartEffect(Pawn Target)
{
	CheckRPGRules();
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
	local int PoisonDamage;
	
	if (Instigator == None || Instigator.Health <= 0)
		Destroy();
	if (Modifier > 0)		//This is an ailment only
		Destroy();
		
	PoisonDamage = int(float(Instigator.Health) * (Curve **(abs(Modifier)-1)*BasePercentage));
	if(PoisonDamage > 0)
	{
		if(Instigator.Controller != None && Instigator.Controller.bGodMode == False
			&& InvulnerabilityInv(Instigator.FindInventoryType(class'InvulnerabilityInv')) == None)
		{
			if (Instigator.Health <= PoisonDamage)
				PoisonDamage = Instigator.Health -1;
			Instigator.Health -= PoisonDamage;
			
			if(Producer != None && Producer.Controller != None && Instigator != Producer) //exp only for harming others.
			{
				if (Rules != None)
					Rules.AwardEXPForDamage(Producer.Controller, RPGStatsInv(Producer.FindInventoryType(class'RPGStatsInv')), Instigator, PoisonDamage);
				// and add the damage as healable
				class'StatusEffect_Burn'.static.AddHealableDamage(PoisonDamage, Instigator);
			}
		}
	}
	Instigator.Spawn(Class'GoopSmoke');
}

function StopEffect(Pawn Target)
{
	SetTimer(0, False);
}

defaultproperties
{
     BasePercentage=0.035000
     curve=1.300000
}
