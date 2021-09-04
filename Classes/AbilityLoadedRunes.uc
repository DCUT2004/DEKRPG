class AbilityLoadedRunes extends DruidLoaded
	abstract
	config(UT2004RPG);
	
static function bool OverridePickupQuery(Pawn Other, Pickup item, out byte bAllowPickup, int AbilityLevel)
{
	if (WeaponPickup(item) != None)
	{
			bAllowPickup = 0;
			return true;
	}

	return false;
}

defaultproperties
{
     Weapons(0)="DEKRPG209A.RuneFireball_Meteor"
     Weapons(1)="DEKRPG209A.RuneBeam_Chain"
     Weapons(2)="DEKRPG209A.RuneLaser_Guard"
     Weapons(3)="DEKRPG209A.RuneImmobilize_Magnet"
     Weapons(4)="DEKRPG209A.RuneStreak_Flare"
     ONSWeapons(0)="UTClassic.ClassicSniperRifle"
     SuperWeapons(0)="XWeapons.Redeemer"
     WeaponDamage=0.500000
     AdrenalineDamage=1.000000
     AbilityName="Loaded Runes"
     Description="When you spawn:|Level 1: You are granted a set of runes with the default percentage chance for magic modifiers.|Level 2: You are granted an additional set of runes.|Level 3: You are granted an additional set of runes.|Level 4: Magic modifiers will be generated for all your runes.|Level 5: You receive all positive magic modifiers.|Cost (per level): 10,15,20,25,30..."
     StartingCost=10
     CostAddPerLevel=5
     MaxLevel=5
}
