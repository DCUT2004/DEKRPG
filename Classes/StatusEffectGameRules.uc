class StatusEffectGameRules extends GameRules
	config(UT2004RPG);
	
var config float DamagePercentPerModifier;

var config int ChanceHitPerModifier;

var config float KnockbackPercent;
var Sound KnockbackSound;
var Material KnockbackOverlay;

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local StatusEffectInventory InstigatorStatusInv, InjuredStatusInv;
	
	if (InstigatedBy != None)
		InstigatorStatusInv = StatusEffectInventory(InstigatedBy.FindInventoryType(Class'StatusEffectInventory'));
	if (Injured != None)
		InjuredStatusInv = StatusEffectInventory(Injured.FindInventoryType(Class'StatusEffectInventory'));
	
	
	//Adjust damage if Instigator has StatusEffect_DamageBonus
	if (InstigatorStatusInv != None && InstigatorStatusInv.DamageBonus != None && InstigatorStatusInv.DamageBonus.Modifier != 0)
	{
		Damage *= 1 + (InstigatorStatusInv.DamageBonus.Modifier * DamagePercentPerModifier);
		if (Damage <= 0)
			Damage = 1;
	}
	
	//Adjust damage if Injured has StatusEffect_DamageReduction
	if (InjuredStatusInv != None && InjuredStatusInv.DamageReduction != None && InjuredStatusInv.DamageReduction.Modifier != 0)
	{
		Damage *= 1 + (-InjuredStatusInv.DamageReduction.Modifier * DamagePercentPerModifier);
		if (Damage <= 0)
			Damage = 1;
	}
	
	//Adjust momentum if Injured has StatusEffect_Momentum
	if (InjuredStatusInv != None && InjuredStatusInv.Momentum != None && InjuredStatusInv.Momentum.Modifier != 0)
	{
		if (InjuredStatusInv.Momentum.Modifier < 0)
			AddMomentum(-InjuredStatusInv.Momentum.Modifier, Damage, Injured, InstigatedBy, HitLocation, Momentum, DamageType);
		else if (InjuredStatusInv.Momentum.Modifier > 0)
			ReduceMomentum(InjuredStatusInv.Momentum.Modifier, Damage, Momentum);
	}
	
	//Adjust damage if Instigator has ChanceHit
	if (InstigatorStatusInv != None && InstigatorStatusInv.ChanceHit != None && InstigatorStatusInv.ChanceHit.Modifier != 0)
	{
		if (Rand(100) <= abs(InstigatorStatusInv.ChanceHit.Modifier)*ChanceHitPerModifier)
		{
			if (InstigatorStatusInv.ChanceHit.Modifier > 0)
			{
				Damage *= 2;
				InstigatedBy.Spawn(Class'GamblerHitEffect',,,InstigatedBy.Location);
				InstigatedBy.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*InstigatedBy.TransientSoundVolume,,InstigatedBy.TransientSoundRadius);
				Injured.Spawn(Class'GamblerHitEffect',,,Injured.Location);
				Injured.PlaySound(sound'GeneralImpacts.Wet.Breakbone_01',,1.1*Injured.TransientSoundVolume,,Injured.TransientSoundRadius);
			}
			else if (InstigatorStatusInv.ChanceHit.Modifier < 0)
			{
				Damage = 1;
				InstigatedBy.Spawn(Class'MissedShotHitEffect',,,InstigatedBy.Location);
				//InstigatedBy.PlaySound(sound'2K4MenuSounds.Generic.msfxFade',,1.1*InstigatedBy.TransientSoundVolume,,InstigatedBy.TransientSoundRadius);
				Injured.Spawn(Class'MissedShotHitEffect',,,Injured.Location);
				//Injured.PlaySound(Sound'2K4MenuSounds.Generic.msfxFade',,1.1*Injured.TransientSoundVolume,,Injured.TransientSoundRadius);
			}
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
	DamagePercentPerModifier=0.02000
	ChanceHitPerModifier=5
	KnockbackPercent=6.0
	KnockbackSound=Sound'WeaponSounds.Misc.ballgun_launch'
	KnockbackOverlay=FinalBlend'AWTroff.Shaders.TroffBackRedFinal'
}
