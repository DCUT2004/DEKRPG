class AddonPowerArtifact extends RPGArtifact
	abstract;

var class<AddonPowerType> ThisPowerType;

function bool CanUseArtifact()
{
	local DEKRPGWeapon CurWeapon;
	local Vehicle V;

	if (Instigator == None)
		return false;

	V = Vehicle(Instigator);
	if (V != None )
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
		return false;	// can't use in a vehicle
	}

	CurWeapon = DEKRPGWeapon(Instigator.Weapon);
	if (CurWeapon == None)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
		return false;	// can't use except on a DEKRPGWeapon
	}
	if (ThisPowerType == None)
		return true;	// no more checking is relevant

	if (CurWeapon.GetModifier() == 0 && !ThisPowerType.default.CanHaveZeroModifier)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 1100, None, None, Class);
		return false;	// if meaningless on zero modifier
	}
	if (CurWeapon.GetModifier() < 0 && !ThisPowerType.default.CanHaveNegativeModifier)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 1200, None, None, Class);
		return false;	// if meaningless on negative modifier
	}
	if (CurWeapon.NumPowerTypes >= CurWeapon.CurMaxPowers || (RuneWeapon(CurWeapon.ModifiedWeapon) == None && CurWeapon.NumPowerTypes >= 2))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
		return false;	// already at maximum number of Powers
	}
	if (ThisPowerType != None && !ThisPowerType.static.AllowedFor(CurWeapon.ModifiedWeapon))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
		return false;	// cannot use this Power type on this type of weapon
	}
	// Will that specific weapon accept it given its current state?
	if (!CurWeapon.CanAddPowerType(ThisPowerType))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
		return false;	// weapon cannot accept
	}

	return true;
}

function BotConsider()
{
	if ( CanUseArtifact() )
		Activate();
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function Activate()
{
	local DEKRPGWeapon CurWeapon;

	if (Instigator == None)
		return;


	if (!CanUseArtifact())
	{
		bActive = false;
		GotoState('');
		return;
	}

	// do it
	CurWeapon = DEKRPGWeapon(Instigator.Weapon);
	CurWeapon.AddPowerType(ThisPowerType);
	CurWeapon.ConstructItemName();
	CurWeapon.DoDelayedIdentify();

	// now get rid of it
	bActive = false;
	Destroy();
	Instigator.NextItem();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 1000)
		return "This artifact cannot work on your current weapon";
	else if (Switch == 1100)
		return "This artifact cannot work on a weapon with a zero modifier";
	else if (Switch == 1200)
		return "This artifact cannot work on a weapon with a negative modifier";
	else if (Switch == 2000)
		return "Cannot add this artifact to your current weapon";
	else if (Switch == 2500)
		return "Your current weapon already has this powerup";
	else if (Switch == 4000)
		return "The powerup was rejected by your current weapon";
	else
		return "Cannot use this artifact";
}

defaultproperties
{
     CostPerSec=1
     MinActivationTime=0.000001
     IconMaterial=FinalBlend'EpicParticles.Shaders.IonFallFinal'
     ItemName="Weapon Power"
}
