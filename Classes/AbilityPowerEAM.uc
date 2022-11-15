class AbilityPowerEAM extends AbilityNiche
	config(UT2004RPG) 
	abstract;
	
var config float LightningMaxDamageMultiplier;
var config float DamageMultiplier;

static simulated function int Cost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local int x;

	for (x = 0; x < Data.Abilities.length; x++)
	{
		if (Data.Abilities[x] == class'DruidArtifactLoaded')
			if (Data.AbilityLevels[x] > 4)
				return Super.Cost(Data, CurrentLevel);
	}

	return 0;
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local PowerAMInv Inv;
	local DruidArtifactLightningRod Rod;
	
	if (Other != None)
	{
		Inv = PowerAMInv(Other.FindInventoryType(class'PowerAMInv'));		
		Rod = DruidArtifactLightningRod(Other.FindInventoryType(class'DruidArtifactLightningRod'));
		
		if (Inv == None)
		{
			Inv = Other.Spawn(class'PowerAMInv', Other);
			Inv.GiveTo(Other);
		}
		if (Rod != None)
		{
			Rod.MaxDamagePerHit *= default.LightningMaxDamageMultiplier;
			Rod.MinDamagePerHit *=  default.LightningMaxDamageMultiplier;
		}
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if (!bOwnedByInstigator)
		return;
	if (Damage > 0 && bOwnedByInstigator)
	{
		if (ClassIsChildOf(DamageType, class'DamageType') && !ClassIsChildOf(DamageType, class'WeaponDamageType') && !ClassIsChildOf(DamageType, class'VehicleDamageType'))
		{
			Damage *= (1+(AbilityLevel*default.DamageMultiplier));
		}
	}
}

defaultproperties
{
     LightningMaxDamageMultiplier=1.500000
     DamageMultiplier=0.200000
     ExcludingAbilities(0)=Class'DEKRPG999X.AbilityWizardEAM'
     ExcludingAbilities(1)=Class'DEKRPG999X.AbilityMaxedEAM'
     AbilityName="Niche: Power"
     Description="Increases artifact damage by 20% per level, but also increases the adrenaline cost of artifacts.|You must be level 180 to buy a niche. You need Loaded Artifacts 5 before purchasing this ability. You can not be in more than one niche at a time.|Cost (per level): 10."
     StartingCost=10
     MaxLevel=20
}
