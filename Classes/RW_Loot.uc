class RW_Loot extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);

var config float DamageBonus;
var config int MaterialChanceModifier;
var config int LowMaterialChance, MediumMaterialChance;

var config Array < class < AbilityMaterial > > LowMaterials, MediumMaterials, HighMaterials;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	if ( Weapon.default.FireModeClass[0] != None && Weapon.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Weapon.default.FireModeClass[0].default.AmmoClass) )
		return false;

	return true;
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local LootInv Inv;
	
	P = Pawn(Victim);
	
	if (P != None && P.Health > 0)
		Inv = LootInv(P.FindInventoryType(class'LootInv'));
	
	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;

		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 +DamageBonus * Modifier;
	}

	if (Instigator != None && Instigator.Controller != None && P != None && P.Controller != None && P.Health > 0 && P != Instigator && !P.Controller.SameTeamAs(Instigator.Controller))
	{
		if (Inv == None)
		{
			Inv = spawn(class'LootInv', P,,, rot(0,0,0));
			Inv.LetterDropChance = (Modifier*0.8);
			Inv.ArtifactDropChance = Modifier*1.3;
			Inv.GemDropChance = Modifier*1.8;
			Inv.GiveTo(P);
		}
		
		if (Damage > P.Health)	//A kill
		{
			AddMaterial();
		}
	}
}

function AddMaterial()
{
	local GiveItemsInv GInv;
	local int MaterialRankChance;
	local int RandIndex;
	
	if (Rand(100) <= MaterialChanceModifier*Modifier)
	{
		GInv = class'GiveItemsInv'.static.GetGiveItemsInv(Instigator.Controller);
		if (GInv != None)
		{
			MaterialRankChance = Rand(100);
			if (MaterialRankChance <= LowMaterialChance)
			{
				RandIndex = RandRange(0, LowMaterials.Length);
				GInv.AddMaterial(LowMaterials[RandIndex]);
			}
			else if (MaterialRankChance <= MediumMaterialChance)
			{
				RandIndex = RandRange(0, MediumMaterials.Length);
				GInv.AddMaterial(MediumMaterials[RandIndex]);
			}
			else
			{
				RandIndex = RandRange(0, HighMaterials.Length);
				GInv.AddMaterial(HighMaterials[RandIndex]);
			}
		}
	}
}

defaultproperties
{
	DamageBonus=0.050000
	ModifierOverlay=FinalBlend'XEffectMat.Shock.ShockCoilFB'
	MinModifier=1
	MaxModifier=4
	MaterialChanceModifier=1	//This integer times the Modifier to give the % chance of granting a material
	LowMaterialChance=80
	MediumMaterialChance=95
	LowMaterials(0)=Class'DEKRPG208AG.AbilityMaterialLumber'
	LowMaterials(1)=Class'DEKRPG208AG.AbilityMaterialCombatBoots'
	LowMaterials(2)=Class'DEKRPG208AG.AbilityMaterialTarydiumShards'
	LowMaterials(3)=Class'DEKRPG208AG.AbilityMaterialSteel'
	LowMaterials(4)=Class'DEKRPG208AG.AbilityMaterialNaliFruit'
	LowMaterials(5)=Class'DEKRPG208AG.AbilityMaterialGloves'
	MediumMaterials(0)=Class'DEKRPG208AG.AbilityMaterialLeather'
	MediumMaterials(1)=Class'DEKRPG208AG.AbilityMaterialPlatedArmor'
	MediumMaterials(2)=Class'DEKRPG208AG.AbilityMaterialHoneysuckleVine'
	MediumMaterials(3)=Class'DEKRPG208AG.AbilityMaterialEmbers'
	MediumMaterials(4)=Class'DEKRPG208AG.AbilityMaterialArcticSuit'
	HighMaterials(0)=Class'DEKRPG208AG.AbilityMaterialMoss'
	HighMaterials(1)=Class'DEKRPG208AG.AbilityMaterialDust'
	HighMaterials(2)=Class'DEKRPG208AG.AbilityMaterialNanite'
	HighMaterials(3)=Class'DEKRPG208AG.AbilityMaterialPumice'
	HighMaterials(4)=Class'DEKRPG208AG.AbilityMaterialIcicle'
	PostfixPos=" of Loot"
}
