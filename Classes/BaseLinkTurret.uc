class BaseLinkTurret extends ASTurret_LinkTurret;

var int TurretLevel;
var int MaxTurretLevel;
var float PercentDamageIncreasePerLevel;
var float PercentHealthIncreasePerLevel;

var bool IsLockedForSelf;
var Controller PlayerSpawner;
var Material LockOverlay;

replication
{
	reliable if (Role == ROLE_Authority)
		TurretLevel;
}

function SetPlayerSpawner(Controller PlayerC)
{
    local AutoGunController NewController;
    
    PlayerSpawner = PlayerC;

    // start off with a autogun controller
    NewController = spawn(class'AutoGunController');
    NewController.Possess(self);
    NewController.SetPlayerSpawner(PlayerSpawner) ;
    VehicleProjSpawnOffset.Z = 0;
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

function bool IsEngineerLocked()
{
    return IsLockedForSelf;
}

function KDriverEnter(Pawn P)
{
    local float HealthPct;
    
    Controller.Destroy();
    Controller = None;
    
    Super.KDriverEnter(P);
    
    HealthPct = float(Health) / HealthMax;
    HealthMax *= 1 + (PercentHealthIncreasePerLevel * TurretLevel);
    Health = Min(HealthMax, HealthPct * HealthMax);    // otherwise we are always not maxed when we enter the turret
    VehicleProjSpawnOffset = default.VehicleProjSpawnOffset;

    if (Weapon != None && Driver != None && xPawn(Driver) != None && Driver.HasUDamage())
    	Weapon.SetOverlayMaterial(xPawn(Driver).UDamageWeaponMaterial, xPawn(Driver).UDamageTime - Level.TimeSeconds, false);

}

function bool KDriverLeave( bool bForceLeave )
{
    local AutoGunController NewController;
    local bool retval;

	if (Weapon != None && Controller != None && xPawn(Controller.Pawn) != None && Controller.Pawn.HasUDamage())
		Weapon.SetOverlayMaterial(xPawn(Controller.Pawn).UDamageWeaponMaterial, 0, false);

	retval = Super.KDriverLeave(bForceLeave);

    // now add controller back in
    NewController = spawn(class'AutoGunController');
    NewController.Possess(self);
    NewController.SetPlayerSpawner(PlayerSpawner) ;
    VehicleProjSpawnOffset.Z = 0;
    return retval;
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

simulated event Destroyed()
{
	Controller.Destroy();
	Controller = None;

	super.Destroyed();
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
