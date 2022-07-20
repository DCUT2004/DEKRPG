class FreezeAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var Sound FreezeSound;

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local FreezeInv FrInv;
	local MagicShieldInv MInv;
	local Pawn P;
	local Actor A;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.IsSameTeam(P))
		return;

	if (Damage <= 0 || Victim.isA('Vehicle') || TheWeapon.GetModifier() <= 0)
		return;

	if (P != None && TheWeapon.static.NullCanTriggerPhysics(P))
	{
		MInv = MagicShieldInv(P.FindInventoryType(class'MagicShieldInv'));
		if (MInv == None)
		{
    		//dont add to the time a pawn is already frozen. It just wouldn't be fair.
            FrInv = FreezeInv(P.FindInventoryType(class'FreezeInv'));
    		if (FrInv == None)
    		{
    			FrInv = spawn(class'FreezeInv', P,,, rot(0,0,0));
    			FrInv.Modifier = TheWeapon.GetModifier();
    			FrInv.LifeSpan = TheWeapon.GetModifier();
    			FrInv.GiveTo(P);
    			A = P.spawn(class'IceSmoke', P,, P.Location, P.Rotation);
    			if (A != None)
    			{
    				A.RemoteRole = ROLE_SimulatedProxy;
    				A.PlaySound(FreezeSound,,2.5*Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
    			}
    		}
        }
	}
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'FreezeAddonPowerType')	   	// too similar
		return false;

	return true;
}

defaultproperties
{
	DamagePercent=2.0      // since Freezing hurts
	FreezeSound=Sound'Slaughtersounds.Machinery.Heavy_End'
	PosName="Freezing"
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=TexPanner'DEKWeaponsMaster206.fX.GreyPanner'
	ThisPickupClass=Class'FreezeAddonPowerPickup'
}

