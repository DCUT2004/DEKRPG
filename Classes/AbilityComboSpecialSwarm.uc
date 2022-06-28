class AbilityComboSpecialSwarm extends AbilityCombo
	config(UT2004RPG)
	abstract;
	
static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	local ComboAbilitySwarmInv Inv;

	if (Other != None)
	{
		Inv = ComboAbilitySwarmInv(Other.FindInventoryType(class'ComboAbilitySwarmInv'));
		if (Inv == None)
		{
			Inv = Other.Spawn(class'ComboAbilitySwarmInv');
			Inv.GiveTo(Other);
		}
		if (Inv != None)
		{
			Inv.EffectMultiplier = default.BaseMultiplier*AbilityLevel;
			Inv.bAll = default.All;
			Inv.bSingle = default.Single;
			Inv.ComboLifespan = default.BaseLifespan;
		}
	}
}

static function HandleDamage(out int Damage, Pawn Injured, Pawn Instigator, out vector Momentum, class<DamageType> DamageType, bool bOwnedByInstigator, int AbilityLevel)
{
	// need to check that summoned monsters do not get xp for not doing damage to same species
	local DEKFriendlyMonsterController C;
	
	if (Instigator == None || Injured == None)
		return;

	if(!bOwnedByInstigator)
	{   // this is hitting a pet, so the pet will not get xp.
	    // while we are here, let's make sure the pet is not hurt by the spawner. This is a deliberate ommission in RPGRules
		C = DEKFriendlyMonsterController(injured.Controller);
		if (C != None && C.Master != None && C.Master == Instigator.Controller)
		{
			Damage *= TeamGame(injured.Level.Game).FriendlyFireScale;
		}
		return;
 	}

	if (Monster(Instigator) == None || Monster(Injured) == None)
		return;
		
	// now know this is damage done by a monster on a pet
	if ( Monster(Injured).SameSpeciesAs(Instigator) )
		Damage = 0;

}

defaultproperties
{
    ExcludingAbilities(0)=Class'DEKRPG209D.AbilityComboSpecialVoidedCubes'
    ExcludingAbilities(1)=Class'DEKRPG209D.AbilityComboSpecialTeleStealth'
    ExcludingAbilities(2)=Class'DEKRPG209D.AbilityComboSpecialBeastsRevenge'
    ExcludingAbilities(3)=Class'DEKRPG209D.AbilityComboSpecialRavenRitual'
	AbilityName="Special: Swarm"
	Description="Summons five Leech Gnats. Each Leech Gnat heals the caster for 2% of the damage dealt to an enemy per level.||You can only have one type of Special combo at a time.||You must be level 90 to purchase this.||REQUIRED MATERIALS:|You need 5 times the ability level of Arcane Hourglass you wish to purchase.||Cost(per level): 10, 20, 30, 40...||NOTE: Use the combo BBFF(back back forward forward) with 100 adrenaline to activate this combo."
	MaxLevel=10
	StartingCost=10
	CostAddPerLevel=10
	BaseMultiplier=0.02000
	MultiplierAddPerStep=25.000000
	MultiplierStep=1.00000
	BaseLifespan=250.000
	Dispellable=True
	All=True
	Single=False
	Materials(0)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialHourglass'),RequiredMaterialLevels=(5))
	Materials(1)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialHourglass'),RequiredMaterialLevels=(10))
	Materials(2)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialHourglass'),RequiredMaterialLevels=(15))
	Materials(3)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialHourglass'),RequiredMaterialLevels=(20))
	Materials(4)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialHourglass'),RequiredMaterialLevels=(25))
	Materials(5)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialHourglass'),RequiredMaterialLevels=(30))
	Materials(6)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialHourglass'),RequiredMaterialLevels=(35))
	Materials(7)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialHourglass'),RequiredMaterialLevels=(40))
	Materials(8)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialHourglass'),RequiredMaterialLevels=(45))
	Materials(9)=(RequiredMaterials=(Class'DEKRPG209D.AbilityMaterialHourglass'),RequiredMaterialLevels=(50))
}