class AbilityDualityProficiency extends AbilityNiche
	config(UT2004RPG) 
	abstract;
	
var config float DamageMultiplier;

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local DualityInv Inv;
	local ArtifactDualOne ADO;
	local ArtifactDualTwo ADT;
	local int x, y;
	local RPGStatsInv StatsInv;

	StatsInv = RPGStatsInv(Other.FindInventoryType(class'RPGStatsInv'));

	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
		if (StatsInv.Data.Abilities[x] == class'AbilityWeaponsProficiency')
			y = StatsInv.Data.AbilityLevels[x];
			
	Inv = DualityInv(Other.FindInventoryType(class'DualityInv'));
	if (Inv == None)
	{
		Inv = Other.spawn(class'DualityInv');		
		Inv.giveTo(Other);
	}
	
	if (Inv!= None)
	{
		if (Inv.DualWeaponOne == None)
		{
			ADO = ArtifactDualOne(Other.FindInventoryType(class'ArtifactDualOne'));
			if (ADO == None)
			{
				ADO = Other.spawn(class'ArtifactDualOne');		
				ADO.giveTo(Other);
			}
		}
		if (Inv.DualWeaponTwo == None)
		{
			ADT = ArtifactDualTwo(Other.FindInventoryType(class'ArtifactDualTwo'));
			if (ADT == None)
			{
				ADT = Other.spawn(class'ArtifactDualTwo');		
				ADT.giveTo(Other);
			}
		}
	}
	if(Other.SelectedItem == None)
		Other.NextItem();
}

static function ScoreKill(Controller Killer, Controller Killed, bool bOwnedByKiller, int AbilityLevel)
{
	local DualityInv Inv;
	local Weapon W;
    local class<weapon> WClass;
	
	if ( Killed == Killer || Killed == None || Killer == None || Killed.Level == None || Killed.Level.Game == None)
		return;
	
	if (Killer != None && Killer.Pawn != None && Killer.Pawn.Health > 0)
		Inv = DualityInv(Killer.Pawn.FindInventoryType(class'DualityInv'));
        
	if (RPGWeapon(Killer.Pawn.Weapon) != None)
		W = RPGWeapon(Killer.Pawn.Weapon).ModifiedWeapon;
	else
		W = Killer.Pawn.Weapon;
    WClass = W.Class;
        
	if (bOwnedByKiller)
	{
		if (Inv != None)
		{
			if (Inv.DualWeaponOne != None || Inv.DualWeaponTwo != None)
			{
				if (WClass == Inv.DualWeaponOne || WClass == Inv.DualWeaponTwo)
				{
					Inv.AddKill(1);
				}
			}
		}
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if (bOwnedByInstigator)
		return;

	if (Damage > 0)
		Damage *= (1 + (AbilityLevel * default.DamageMultiplier));
}

defaultproperties
{
     DamageMultiplier=0.250000
     ExcludingAbilities(0)=Class'DEKRPG999X.AbilitySpecialistProficiency'
     RequiredAbilities(0)=Class'DEKRPG999X.AbilityWeaponsProficiency'
     AbilityName="Niche: Duality"
     Description="You are granted the Duality artifacts. Use the artifact to select two weapons. Making kills with either weapons will increase the proficiency bonus for both weapons. If you die, your proficiency bonus will save and can be reapplied to two new weapons after respawning.|In exchange, the proficiency bonus will not apply to other weapons, and your damage reduction is lowered.|You must have Weapons Proficiency before purchasing this ability. You must be level 180 to buy a niche. You can not be in more than one niche at a time.|Cost: 50."
     StartingCost=50
     MaxLevel=1
}
