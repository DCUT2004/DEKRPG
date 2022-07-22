class LootAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float DamageBonus;
var config int MaterialChanceModifier;
var config int LowMaterialChance, MediumMaterialChance;

var config Array < class < AbilityMaterial > > LowMaterials, MediumMaterials, HighMaterials;

static function bool AllowedFor(Weapon W)
{
	if (W == None)
		return false;

	if ( W.default.FireModeClass[0] != None && W.default.FireModeClass[0].default.AmmoClass != None
	          && class'MutUT2004RPG'.static.IsSuperWeaponAmmo(W.default.FireModeClass[0].default.AmmoClass) )
		return false;

	return false;
}

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local LootInv Inv;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	P = Pawn(Victim);
 	if (P == None || P.Health < 0)
		return;

	if (TheWeapon.IsSameTeam(P))
		return;		// no loot from hurting teammates

	if (TheWeapon.Instigator != None && TheWeapon.Instigator.Controller != None && P.Controller != None && P != TheWeapon.Instigator)
	{
        Inv = LootInv(P.FindInventoryType(class'LootInv'));
		if (Inv == None)
		{
			Inv = spawn(class'LootInv', P,,, rot(0,0,0));
			Inv.LetterDropChance = (TheWeapon.GetModifier() * 0.8);
			Inv.ArtifactDropChance = TheWeapon.GetModifier() * 1.3;
			Inv.GemDropChance = TheWeapon.GetModifier() * 1.8;
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
	
	if (Rand(100) <= MaterialChanceModifier * TheWeapon.GetModifier())
	{
		GInv = class'GiveItemsInv'.static.GetGiveItemsInv(TheWeapon.Instigator.Controller);
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

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'LootAddonPowerType')    // doesn't work well doubled
		return false;
        
	return true;
}

defaultproperties
{
	MaterialChanceModifier=1	//This integer times the Modifier to give the % chance of granting a material
	LowMaterialChance=80
	MediumMaterialChance=95
	LowMaterials(0)=Class'DEKRPG999X.AbilityMaterialLumber'
	LowMaterials(1)=Class'DEKRPG999X.AbilityMaterialCombatBoots'
	LowMaterials(2)=Class'DEKRPG999X.AbilityMaterialTarydiumShards'
	LowMaterials(3)=Class'DEKRPG999X.AbilityMaterialSteel'
	LowMaterials(4)=Class'DEKRPG999X.AbilityMaterialNaliFruit'
	LowMaterials(5)=Class'DEKRPG999X.AbilityMaterialGloves'
	MediumMaterials(0)=Class'DEKRPG999X.AbilityMaterialLeather'
	MediumMaterials(1)=Class'DEKRPG999X.AbilityMaterialPlatedArmor'
	MediumMaterials(2)=Class'DEKRPG999X.AbilityMaterialHoneysuckleVine'
	MediumMaterials(3)=Class'DEKRPG999X.AbilityMaterialEmbers'
	MediumMaterials(4)=Class'DEKRPG999X.AbilityMaterialArcticSuit'
	HighMaterials(0)=Class'DEKRPG999X.AbilityMaterialMoss'
	HighMaterials(1)=Class'DEKRPG999X.AbilityMaterialDust'
	HighMaterials(2)=Class'DEKRPG999X.AbilityMaterialNanite'
	HighMaterials(3)=Class'DEKRPG999X.AbilityMaterialPumice'
	HighMaterials(4)=Class'DEKRPG999X.AbilityMaterialIcicle'

	PosName="Loot"
	ZeroName="Loot"
	NegName="Loot"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=FinalBlend'XEffectMat.Shock.ShockCoilFB'
	ThisPickupClass=Class'LootAddonPowerPickup'
}

