class KnockbackAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float KnockbackPercent;
var Sound KnockbackSound;

#exec OBJ LOAD FILE="..\Textures\AWTroff.utx"

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	Local KnockbackInv InvKnock;
	Local Vector newLocation;
	local MagicShieldInv MInv;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.GetModifier() <= 0)
		return;

	if (TheWeapon.IsSameTeam(P))
		return;

	if (Victim.isA('Vehicle'))
		return;

	if (!TheWeapon.static.NullcanTriggerPhysics(P))
		return;
        
    if (P.HealthMax > 5000)    // Bosses too big to throw around
        return;
        
    if (Damage <= 0)
        return;

	MInv = MagicShieldInv(Pawn(Victim).FindInventoryType(class'MagicShieldInv'));
	if (MInv != None)
        return;
    
    if (P.FindInventoryType(class'KnockbackInv') == None)
	{
		InvKnock = spawn(class'KnockbackInv', P,,, rot(0,0,0));
		if(InvKnock != None)
		{
			InvKnock.LifeSpan = Max(1,(TheWeapon.MaxModifier + 2) - TheWeapon.GetModifier());
			InvKnock.Modifier = TheWeapon.GetModifier();
			InvKnock.GiveTo(P);

			// if they're not walking, falling, or hovering, 
			// the momentum won't affect them correctly, so make them hover.
			// this effect will end when the KnockbackInv expires.
			if(P.Physics != PHYS_Walking && P.Physics != PHYS_Falling && P.Physics != PHYS_Hovering)
				P.SetPhysics(PHYS_Hovering);
			//I check the x,y, and z to see if this projectile has no momentum (some weapons have none)
			if
			( (Momentum.X == 0 && Momentum.Y == 0 && Momentum.Z == 0 )  || 
				ClassIsChildOf(DamageType, class'DamTypeSniperShot') || 
				ClassIsChildOf(DamageType, class'DamTypeClassicSniper') ||
				ClassIsChildOf(DamageType, class'DamTypeLinkShaft') ||
				ClassIsChildOf(DamageType, class'DamTypeONSAVRiLRocket') ||
				instr(caps(string(DamageType)), "AVRIL") > -1 //hack for vinv avril
			)
			{
				if(TheWeapon.Instigator == Victim)
					 Momentum = TheWeapon.Instigator.Location - HitLocation;
				else
					 Momentum = TheWeapon.Instigator.Location - Victim.Location;
				Momentum = Normal(Momentum);
				Momentum *= -200;
				// if they're walking, I need to bump them up 
				// in the air a bit or they won't be knocked back 
				// on no momentum weapons.
				if(P.Physics == PHYS_Walking)
				{
					newLocation = P.Location;
					newLocation.z += 10;
					P.SetLocation(newLocation);
				}
			}
			Momentum *= Max(2.0, Max(TheWeapon.GetModifier() * 0.5,(Damage * (KnockbackPercent/100.0)))); //kawham!
			P.SetOverlayMaterial(PowerOverlay, 1.0, false);
			if(PlayerController(P.Controller) != None)
		 		PlayerController(P.Controller).ReceiveLocalizedMessage(class'KnockbackConditionMessage', 0);
			P.PlaySound(KnockbackSound,,1.5 * Victim.TransientSoundVolume,,Victim.TransientSoundRadius);
		}
	}
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	// Put in a test for nullentropy and freeze Power type, and bounce
	if (NewType == class'ForceAddonPowerType')
		return false;
	if (NewType == class'FreezeAddonPowerType')
		return false;
	if (NewType == class'KnockbackAddonPowerType')	// I don't think two of them will help
		return false;
	return true;
}

defaultproperties
{
	KnockbackPercent=6.0
	KnockbackSound=Sound'WeaponSounds.Misc.ballgun_launch'
	PosName="Knockback"
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=FinalBlend'AWTroff.Shaders.TroffBackRedFinal'
	ThisPickupClass=Class'KnockbackAddonPowerPickup'
}

