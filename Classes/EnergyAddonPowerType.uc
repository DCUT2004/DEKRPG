class EnergyAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float EnergyPercent;

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local int AdrenalineBonus;
	local MagicShieldInv MInv;
	local Actor A;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (Damage > P.Health)
		AdrenalineBonus = P.Health;
	else
		AdrenalineBonus = Damage;
	AdrenalineBonus *= (EnergyPercent/100.0) * TheWeapon.GetModifier() * PerformanceIncrease;

	MInv = MagicShieldInv(Pawn(Victim).FindInventoryType(class'MagicShieldInv'));
	if (MInv == None)
    {
    	TheWeapon.Instigator.Controller.Adrenaline = FMAx(0,FMin(TheWeapon.Instigator.Controller.Adrenaline + AdrenalineBonus, TheWeapon.Instigator.Controller.AdrenalineMax));

        A = Spawn(Class'DEKEffectEnergy',,,TheWeapon.Owner.Location,rotator(Normal(HitLocation - Location)));
        if ( A != None )
        {
            A.RemoteRole = ROLE_SimulatedProxy;
            A.PlaySound(Sound'PickupSounds.AdrenelinPickup',,1.0 * TheWeapon.Owner.TransientSoundVolume,,TheWeapon.Owner.TransientSoundRadius);
        }
    }
}

defaultproperties
{
	EnergyPercent=2.0
	PosName="Energy"
	ZeroName="Energy"
	NegName="Draining"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=true
	AIBonus=0.1
	PowerOverlay=Shader'XGameShaders.PlayerShaders.LightningHit'
	ThisPickupClass=Class'EnergyAddonPowerPickup'
}

