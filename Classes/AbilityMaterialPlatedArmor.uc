class AbilityMaterialPlatedArmor extends AbilityMaterial
	config(UT2004RPG)
	abstract;
	
var config Array < class < DamageType > > IgnoreDamTypeClass;
var config float LevMultiplier;

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	local int x;
	
	if (bOwnedByInstigator)
	{	// the retaliation damage going out
		// do not allow this ability to kill another player. Should already have adjusted for a harm weapon, and for DB/DR differences
		if (DamageType == class'DamTypeRetaliation' && Damage >= Injured.Health + Injured.GetShieldStrength() )
		{
			Damage = Max(1,Injured.Health + Injured.GetShieldStrength() - 1);	// just do one damage. If they notice they can stop firing
		}
		return;
	}
	
	// the initial damage which causes the retaliation to occur
	if (DamageType == class'DamTypeRetaliation' || Injured == Instigator || Instigator == None || Instigator.Health <= 0)
		return;		// can't retaliate
		
	for (x = 0; x < default.IgnoreDamTypeClass.Length; x++)
	{
		if (DamageType == default.IgnoreDamTypeClass[x])
			return;
	}
		
	Instigator.TakeDamage(int(float(Damage) * (default.LevMultiplier * AbilityLevel)), Injured, Instigator.Location, vect(0,0,0), class'DamTypeRetaliation');

	//finally check if we killed it. May happen if we have a DD or triple running
	if (Instigator == None || Instigator.Health <= 0 )
		class'ArtifactLightningBeam'.static.AddArtifactKill(Injured, class'WeaponRetaliate');
}

defaultproperties
{
	 LevMultiplier=0.001000000
     AbilityName="Plated Armor**"
     Description="Protective armor that can endure boulders and rockets. Retaliates 0.1% per level of the damage dealt to you back to the enemy.||Rarity: Medium**||This material can be found by making kills, completing solo and team missions, using Loot magic modifier, winning the game, or defeating bosses.||You must be level 90 to purchase this.||Cost (per level): 3"
	 MaxLevel=50
}
