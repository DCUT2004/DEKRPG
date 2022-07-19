//=============================================================================
// AddonPowerType
//
// Parent class of all Power classes that can be attached to weapons.
// PowerType items are placed in the holding weapon's PowerTypes chain, a linked list
// of PowerType actors.  
//
//=============================================================================
class AddonPowerType extends Actor
	abstract
	config(UT2004RPG);

var DEKRPGWeapon TheWeapon;	// the weapon we are attached to
var bool CanHaveZeroModifier;		// if false, then this Power type cannot exist on weapon with a zero modifier
var bool CanHaveNegativeModifier;	// if false, then this Power type cannot exist on weapon with a negative modifier
var string PosName;			// name to give with a positive modifier
var string ZeroName;			// name to give with a zero modifier
var string NegName;			// name to give with a negative modifier
var float AIBonus;			// increase in AI rating to be given to this weapon due to powerup
var Material PowerOverlay;		// what shader to use if this is the only Power type
var class<AddonPowerPickup> ThisPickupClass;	// Pickup class that gives this Power type

var config float DamagePercent;		// extra damage bonus for this particular Power type
var config bool bCanThrow;		// set to true if can throw a weapon with this type
var config bool bCanShare;		// set to true if can clone a weapon with this type

// Network replication.
replication
{
	// Things the server should send to the client.
	reliable if( bNetOwner && bNetDirty && (Role==ROLE_Authority) )
		TheWeapon;  
}


// returns increase in AI rating to be given to this weapon due to powerup
function GetAIRating(out float AIRating)
{
	AIRating += AIBonus;
}


// Function which lets existing Powertypes on a weapon
// prevent another type being added. Return false to abort add
function bool CanCoexist( class<AddonPowerType> NewType )
{
	return true;
}

// check this modifier is ok on this weapon
function bool Generateok(RPGWeapon ForcedWeapon, int Modifier)
{
	if (Modifier<0 && !CanHaveNegativeModifier)
		return false;
	if (Modifier==0 && !CanHaveZeroModifier)
		return false;
	return true;
}

// CanThrow return false if weapons with this type cannot be thrown
function bool CanThrow()
{
	return bCanThrow;
}

// CanShare return false if weapons with this type cannot be shared with other players
function bool CanShare()
{
	return bCanShare;
}

// function called to inform this Power type it is attached to a weapon
function AttachToWeapon( DEKRPGWeapon W )
{
	TheWeapon = W;
}


// Can this Power type work on this weapon
static function bool AllowedFor(DEKRPGWeapon W)
{
	return true;
}

// adjust any damage done to the player by incoming hits
function AdjustPlayerDamage(out int Damage, Pawn InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType);
function PlayerTakenDamage(out int Damage, Pawn InstigatedBy, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType);

// AddDamageBonus - add on the damage bonus.
function AddDamageBonus(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	if (Damage > 0)
	{
		Damage = Max(1, Damage * (1.0 + ((DamagePercent/100.0) * TheWeapon.GetModifier())));
		Momentum = Momentum * (1.0 + ((DamagePercent/100.0) * TheWeapon.GetModifier()));
	}
}

// AdjustDamage - change the damage done here. Healing sets to zero here. Piercing chooses best of damage or original
function AdjustDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType);

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType);

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
	return false;
}

simulated function WeaponTick(float dt);
simulated function bool StartFire(int Mode);
function bool ConsumeAmmo(int Mode, float Load, bool bAmountNeededIsMax);
function GiveAmmo(int m, WeaponPickup WP, bool bJustSpawned);

simulated function StartBerserk();
simulated function StopBerserk();

simulated function SetShader()
{
	if (TheWeapon != None)
		TheWeapon.ModifierOverlay = PowerOverlay;
}

defaultproperties
{
	DamagePercent=0.0
	bCanThrow=true
	bCanShare=true

	PosName=""
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=true
	CanHaveNegativeModifier=false
	AIBonus=0.0
	PowerOverlay=FinalBlend'EpicParticles.Shaders.IonFallFinal'
	bOnlyRelevantToOwner=true
	DrawType=DT_None
	AmbientGlow=0
	bOnlyOwnerSee=true
	bHidden=true
	Physics=PHYS_None
	bReplicateMovement=false
	ThisPickupClass=None
}

