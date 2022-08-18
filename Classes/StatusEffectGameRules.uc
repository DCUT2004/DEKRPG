class StatusEffectGameRules extends GameRules
	config(UT2004RPG);
	
var config float KnockbackPercent;
var Sound KnockbackSound;
var Material KnockbackOverlay;

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local StatusEffectInventory StatusInv;
	local int Modifier;
	
	if (Injured != None)
	{
		StatusInv = StatusEffectInventory(Injured.FindInventoryType(Class'StatusEffectInventory'));
		if (StatusInv == None)
			return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
		Modifier = StatusInv.GetStatusEffectModifier(Class'StatusEffect_Momentum');
		if (Modifier < 0 )	//Add knockback to Injured
		{
			AddMomentum(-Modifier, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType);
		}
		else if (Modifier > 0)
		{
			ReduceMomentum(Modifier, Damage, Momentum);
		}
	}
	return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
}

function AddMomentum(int Modifier, int Damage, Pawn Injured, Pawn InstigatedBy, Vector HitLocation, OUT Vector Momentum, Class<DamageType> DamageType)
{
	local Vector NewLocation;
	
	if
	( (Momentum.X == 0 && Momentum.Y == 0 && Momentum.Z == 0 )  || 
		ClassIsChildOf(DamageType, class'DamTypeSniperShot') || 
		ClassIsChildOf(DamageType, class'DamTypeClassicSniper') ||
		ClassIsChildOf(DamageType, class'DamTypeLinkShaft') ||
		ClassIsChildOf(DamageType, class'DamTypeONSAVRiLRocket') ||
		instr(caps(string(DamageType)), "AVRIL") > -1 //hack for vinv avril
	)
	{
		if(Injured == Instigator)
			 Momentum = Injured.Location - HitLocation;
		else
			 Momentum = InstigatedBy.Location - Injured.Location;
		Momentum = Normal(Momentum);
		Momentum *= -200;
		// if they're walking, I need to bump them up 
		// in the air a bit or they won't be knocked back 
		// on no momentum weapons.
		if(Injured.Physics == PHYS_Walking)
		{
			NewLocation = Injured.Location;
			NewLocation.z += 10;
			Injured.SetLocation(NewLocation);
		}
	}
	Injured.SetOverlayMaterial(KnockbackOverlay, 1.0, false);
	if(PlayerController(Injured.Controller) != None)
		PlayerController(Injured.Controller).ReceiveLocalizedMessage(class'KnockbackConditionMessage', 0);
	Injured.PlaySound(KnockbackSound,,1.5 * Injured.TransientSoundVolume,,Injured.TransientSoundRadius);
	Momentum *= Max(2.0, Max(Modifier * 0.5,(Damage * (KnockbackPercent/100.0))));
}

function ReduceMomentum(int Modifier, int Damage, OUT Vector Momentum)
{
	Momentum /= Max(2.0, Max(Modifier * 0.5,(Damage * (KnockbackPercent/100.0))));
}

defaultproperties
{
	KnockbackPercent=6.0
	KnockbackSound=Sound'WeaponSounds.Misc.ballgun_launch'
	KnockbackOverlay=FinalBlend'AWTroff.Shaders.TroffBackRedFinal'
}
