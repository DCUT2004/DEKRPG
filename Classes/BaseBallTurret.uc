class BaseBallTurret extends ASTurret_BallTurret;

var int TurretLevel;
var int MaxTurretLevel;
var float PercentDamageIncreasePerLevel;
var float PercentHealthIncreasePerLevel;

var float LastHealTime;
var array<Controller> Healers;
var array<float> HealersLastLinkTime;
var int NumHealers;
var MutUT2004RPG RPGMut;
var bool IsLockedForSelf;
var Controller PlayerSpawner;
var Material LockOverlay;


replication
{
	reliable if (Role == ROLE_Authority)
		TurretLevel, NumHealers;
}

simulated event PostBeginPlay()
{
	local Mutator m;
	
	NumHealers = 0;

	super.PostBeginPlay();

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
			
	if (Role == ROLE_Authority)		
		SetTimer(1, true);	// for calculating number of healers
}

function SetPlayerSpawner(Controller PlayerC)
{
	PlayerSpawner = PlayerC;
}

function Timer()
{
	// check how many healers we have
	local int i;
	local int validHealers;
	
	if (Role < ROLE_Authority)	
		return;	

	validHealers = 0;
	for(i = 0; i < Healers.length; i++)
	{
		if (HealersLastLinkTime[i] > Level.TimeSeconds-0.5)
		{	// this healer has healed in the last half a second, so keep.
			if (i > validHealers)
			{	// shuffle down to next valid slot
				HealersLastLinkTime[validHealers] = HealersLastLinkTime[i];
				Healers[validHealers] = Healers[i];
			}
			validHealers++;
		}
	}
	Healers.Length = validHealers;		// and get rid of the non-valid healers.
	HealersLastLinkTime.length = validHealers;
	
	// now update the replicated value
	if (NumHealers != validHealers)
		NumHealers = validHealers;
}

function bool HealDamage(int Amount, Controller Healer, class<DamageType> DamageType)
{
	local int i;
	local bool gotit;
	local bool healret;
	local Mutator m;

	// quick check to make sure we got the RPGMut set
	if (RPGMut == None && Level.Game != None)
	{
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
	}

	// keep a list of who is healing
	gotit = false;
	if (Healer != None && TeamLink(Healer.GetTeamNum()))
	{	
		// check the healer is an engineer
		if (Healer.Pawn != None && ((Healer.Pawn.Weapon != None && RW_EngineerLink(Healer.Pawn.Weapon) != None) || DruidLinkSentinel(Healer.Pawn) != None))
		{

			// now add to list
			for(i = 0; i < Healers.length; i++)
			{
				if (Healers[i] == Healer)
				{
					gotit = true;
					HealersLastLinkTime[i] = Level.TimeSeconds;
					i = Healers.length;
				}
			}
			if (!gotit)
			{
				// add new healer
				Healers[Healers.length] = Healer;
				HealersLastLinkTime[HealersLastLinkTime.length] = Level.TimeSeconds;
			}
		}
	}

	healret = Super.HealDamage(Amount, Healer, DamageType);
	if (healret)
	{
		// healed turret of health, so no damage/xp bonus this second
		LastHealTime = Level.TimeSeconds;
	}
	return healret;
}

function bool TryToDrive(Pawn P)
{
	if ( (P.Controller == None) || !P.Controller.bIsPlayer || Health <= 0 )
		return false;

	// Check for Locking by engineer....
	if ( IsEngineerLocked() && P.Controller != PlayerSpawner )
	{
		if (PlayerController(P.Controller) != None)
		{
		    if (PlayerSpawner != None)
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'VehicleEngLockedMessage', 0, PlayerSpawner.PlayerReplicationInfo);
			else
				PlayerController(P.Controller).ReceiveLocalizedMessage(class'VehicleEngLockedMessage', 0);
		}
		return false;
	}
	else
	{
		return super.TryToDrive(P);
	}
}

function EngineerLock()
{
    IsLockedForSelf = True;
	SetOverlayMaterial(LockOverlay, 50000.0, True);
}

function EngineerUnlock()
{
    IsLockedForSelf = False;
	SetOverlayMaterial(LockOverlay, 0.0, false);
}

function bool IsEngineerLocked()
{
    return IsLockedForSelf;
}

function KDriverEnter(Pawn P)
{
    local float HealthPct;
    
	Super.KDriverEnter(P);
	HealthPct = float(Health) / HealthMax;
    HealthMax *= 1 + (PercentHealthIncreasePerLevel * TurretLevel);
	Health = Min(HealthMax, HealthPct * HealthMax);    // otherwise we are always not maxed when we enter the turret

    if (Weapon != None && Driver != None && xPawn(Driver) != None && Driver.HasUDamage())
		Weapon.SetOverlayMaterial(xPawn(Driver).UDamageWeaponMaterial, xPawn(Driver).UDamageTime - Level.TimeSeconds, false);

}

function bool KDriverLeave( bool bForceLeave )
{
	if (Weapon != None && Controller != None && xPawn(Controller.Pawn) != None && Controller.Pawn.HasUDamage())
		Weapon.SetOverlayMaterial(xPawn(Controller.Pawn).UDamageWeaponMaterial, 0, false);

	return Super.KDriverLeave(bForceLeave);
}

function DriverDied()
{
	if (Weapon != None && xPawn(Driver) != None && Driver.HasUDamage())
		Weapon.SetOverlayMaterial(xPawn(Driver).UDamageWeaponMaterial, 0, false);

	Super.DriverDied();
}

function bool HasUDamage()
{
	return (Driver != None && Driver.HasUDamage());
}

function LevelUp()
{
    if (TurretLevel == MaxTurretLevel)
        return;
        
    TurretLevel += 1;
    HealthMax *= (1 + PercentHealthIncreasePerLevel);              // for if anyone is currently in it. Overriden on DriverEnter
    
    // no increase in the weapon fire rate due to driver enter/leave problems combining with other abilities.
    // no increase in range as they don't have a range
    
    // damage increased handled in RPGClass.
}

defaultproperties
{
     TurretLevel=0
     MaxTurretLevel=5
     PercentDamageIncreasePerLevel=0.14
     PercentHealthIncreasePerLevel=0.1
}
