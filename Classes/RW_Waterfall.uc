class RW_Waterfall extends OneDropRPGWeapon
	HideDropDown
	CacheExempt
	config(UT2004RPG);	

var config float DamageBonus;
var bool active;
var Pawn PawnOwner;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	PawnOwner = Other;
	active = false;
	enable('tick');
	super.GiveTo(Other, Pickup);
}

function DropFrom(vector StartLocation)
{
	disable('tick');
	deactivate();
	PawnOwner = None;
	super.DropFrom(StartLocation);
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;
	}
	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	if (!bIdentified)
		Identify();

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	if(damage > 0)
	{
		Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
		Momentum *= 1.0 + DamageBonus * Modifier;
	}
}

function Tick(Float deltaTime)
{
	if(PawnOwner != None)
	{
		if(PawnOwner.Weapon != None && PawnOwner.Weapon == self)
			activate();
		else
		{
			if(PawnOwner.Weapon != None && PawnOwner.Weapon.isA('RW_Speedy'))
				active = false;
			else
				deactivate();
		}
	}
	super.Tick(deltaTime);
}

function activate()
{
	if(active)
		return;

	SetTimer(1, True);
	active = true;
}

function deactivate()
{
	if(!active)
		return;

	SetTimer(0, False);
	active = false;
}

simulated function Timer()
{
	Super.Timer();
	if (PawnOwner != None)
		PawnOwner.GiveHealth(Modifier, PawnOwner.HealthMax);
}

defaultproperties
{
     DamageBonus=0.020000
     ModifierOverlay=FinalBlend'AWGlobal.Shaders.ColdFinal'
     //ModifierOverlay=Shader'XGameTextures.SuperPickups.MHInnerS'
     MinModifier=1
     MaxModifier=5
     AIRatingBonus=0.080000
	 PrefixPos="Waterfall "
}
