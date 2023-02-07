class ArtifactRemoveAddon extends EnhancedRPGArtifact;

var bool needsIdentify;

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

	if (Instigator.Controller == None || Instigator.Controller.Adrenaline < AdrenalineRequired)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, AdrenalineRequired, None, None, Class);
		return false;	// can't afford
	}
	CurWeapon = DEKRPGWeapon(Instigator.Weapon);
	if (CurWeapon == None)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 1000, None, None, Class);
		return false;	// can't use except on a RPGWeapon
	}
	if (CurWeapon.class == class'RW_EngineerLink' || CurWeapon.class == class'RW_Superhealer')
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
		return false;	// cannot use this Power type on this type of weapon
	}
	if (CurWeapon.NumPowerTypes == 0)
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 4000, None, None, Class);
		return false;	// no powerups to remove
	}

	return true;
}

function BotConsider()
{
	return;
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
}

function Activate()
{
	local DEKRPGWeapon CurWeapon;
    local AddonPowerType AddonPowerType;
    local class<AddonPowerPickup> ThisPickupClass;
    local class<AddonPowerArtifact> ArtifactClass;
	local RPGArtifact NewArtifact;

	if (Instigator == None)
		return;

	if (!CanUseArtifact())
	{
		bActive = false;
		GotoState('');
		return;
	}

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
    AddonPowerType = CurWeapon.CurrentPowerTypes[0];
	CurWeapon.RemoveFirstPowerType();
	CurWeapon.ConstructItemName();
	CurWeapon.DoDelayedIdentify();
   
    // now create the artifact - if they haven't already got one
    if (AddonPowerType != None)
        ThisPickupClass = AddonPowerType.ThisPickupClass;
    if (ThisPickupClass != None)
        ArtifactClass = class<AddonPowerArtifact>(ThisPickupClass.default.InventoryType);
    if (ArtifactClass != None)
    {
    	if (Instigator.FindInventoryType(ArtifactClass) == None)
        {
        	NewArtifact = Instigator.spawn(ArtifactClass, Instigator,,, rot(0,0,0));
        	NewArtifact.giveTo(Instigator);
        }
    }
    AddonPowerType.Destroy();
    
    // finally take the adrenaline
	Instigator.Controller.Adrenaline -= AdrenalineRequired;
	if (Instigator.Controller.Adrenaline < 0)
		Instigator.Controller.Adrenaline = 0;

	// now get rid of it
	bActive = false;
}

function Timer()
{
	local RPGWeapon CurWeapon;
	CurWeapon = RPGWeapon(Instigator.Weapon);
	if( needsIdentify && CurWeapon != None)
	{
		CurWeapon.Identify();
	}
	setTimer(0, false);

	Destroy();			// was a one shot artifact
	Instigator.NextItem();
}

exec function TossArtifact()
{
	//do nothing. This artifact cant be thrown
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "This artifact cannot work on your current weapon";
	else if (Switch == 2000)
		return "Your weapon is of the wrong type for this artifact";
	else if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	else if (Switch == 4000)
		return "This weapon has no addons to remove";
    else if (Switch > 0)
		return switch @ "Adrenaline is required to use this artifact";
	else
		return "Cannot use this artifact";
}

defaultproperties
{
     AdrenalineRequired=20
     CostPerSec=1
     MinActivationTime=0.000001
     IconMaterial=Texture'AW-2004Particles.Weapons.PlasmaHeadRed'
     ItemName="Remove Addon"
}
