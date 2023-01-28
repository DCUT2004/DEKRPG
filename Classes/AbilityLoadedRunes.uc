class AbilityLoadedRunes extends DruidLoaded
	abstract
	config(UT2004RPG);
	
var config float NonRuneDamage;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	if(!bOwnedByInstigator)
		return;

	if(Damage > 0)
	{
        if (ClassIsChildOf(DamageType, class'RuneDamageType') == false)
        {
            // not a rune so decrease damage
            Damage *= default.NonRuneDamage;
    		if (Damage == 0)
    			Damage = 1;
        }
	}
}

defaultproperties
{
     PlayerLevelReqd(1)=1
     PlayerLevelReqd(2)=1
     PlayerLevelReqd(3)=1
     Weapons(0)="DEKRPG999X.RuneFireball_Heatwave"
     Weapons(1)="DEKRPG999X.RuneLaser_Guard"
     Weapons(2)="DEKRPG999X.RuneFlurry_Magnet"
     Weapons(3)="DEKRPG999X.RuneSparkle_Barrage"
     ONSWeapons(0)="DEKRPG999X.RuneBeam_Chain"
     ONSWeapons(1)="DEKRPG999X.RuneHeatWhip_Flare"
     ONSWeapons(3)="DEKRPG999X.RuneEarthquake_Blizzard"
     SuperWeapons(0)="DEKRPG999X.RuneMegaBlast_PoisonBlast"
     NonRuneDamage=0.900000
     AbilityName="Loaded Runes"
     Description="NOTE: This class is a work in progress. Visit us on Discord at discord.gg/y8RffrWHTy to learn more about future updates and provide suggestions.||Runes are weapons that consume adrenaline instead of ammo.||You can still use normal weapons, but their damage is slightly reduced.||When you spawn:|Level 1: You are granted a set of runes with the default percentage chance for magic modifiers.|Level 2: You are granted an additional set of runes.|Level 3: You are granted super runes.|Cost (per level): 10,15,20"
     StartingCost=10
     CostAddPerLevel=5
     MaxLevel=3
}