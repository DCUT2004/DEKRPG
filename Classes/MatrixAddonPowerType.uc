class MatrixAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float MatrixRadius;
var config float SpeedMultiplier;

static function bool AllowedFor(Weapon W)
{
//	local int x;
	local RPGStatsInv StatsInv;

	// check if superweapon 
	if (W == None)
		return false;

	if (  W.default.FireModeClass[0] != None && W.default.FireModeClass[0].default.AmmoClass != None
		&& class'MutUT2004RPG'.static.IsSuperWeaponAmmo(W.default.FireModeClass[0].default.AmmoClass) )
		return false;
        
    // not really sure this check should be in here, but simpler to keep rather than change
    If (W.Instigator == None)
        return false;
	StatsInv = RPGStatsInv(W.Instigator.FindInventoryType(class'RPGStatsInv'));

//	for (x = 0; StatsInv != None && x < StatsInv.Data.Abilities.length; x++)
//		if (StatsInv.Data.Abilities[x] == class'AbilityMagicVault' && StatsInv.Data.AbilityLevels[x] >= 1)
//		return true;

	return false;
}

simulated event WeaponTick(float dt)
{
	local Projectile P;
	local SyncMatrix Sync;
	local float SpeedToMultiply;

	Super.WeaponTick(dt);
	
	SpeedToMultiply = (1 - (TheWeapon.GetModifier() * default.SpeedMultiplier));
	if (SpeedToMultiply < 0.1)
		SpeedToMultiply = 0.1;	//don't allow full stop, can cause some problems (AVRiL).
	
	if(Role == ROLE_Authority && TheWeapon.Instigator.Controller != None)
	{
		foreach TheWeapon.Instigator.VisibleCollidingActors(class'Projectile', P, MatrixRadius)
		{
			if(P.Tag != 'Matrix' && P.InstigatorController != None && P.InstigatorController != TheWeapon.Instigator.Controller && TranslocatorBeacon(P) == None && BombTrapProjectile(P) == None && AerialTrapProjectile(P) == None && ShockTrapProjectile(P) == None && FrostTrapProjectile(P) == None && WildfireTrapProjectile(P) == None && (P.Instigator == None || P.Instigator.Controller == None || !P.InstigatorController.SameTeamAs(TheWeapon.Instigator.Controller)))
			{
  				P.Tag = 'Matrix';
 				P.Speed *= 0;
 				P.MaxSpeed *= 0;
 				P.Velocity *= 0;
				
				//Tell clients
				if(Level.NetMode == NM_DedicatedServer)
				{
					Sync = P.Instigator.Spawn(class'SyncMatrix');
					Sync.Proj = P;
					Sync.ProjClass = P.class;
 					Sync.ProcessedTag = 'Matrix';
					Sync.SpeedMultiplier = 0;
					Sync.ProjVelocity *= 0;
					Sync.ProjLocation = P.Location;
				}
			}
		}
	}
}


function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'MatrixAddonPowerType')	// double gets complicated
		return false;
    
	return true;
}

defaultproperties
{
	MatrixRadius=150.000000
	SpeedMultiplier=0.100000
	PosName="Bullet Time"
	ZeroName="Bullet Time"
	NegName="Bullet Time"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false	// do not allow misfortune by default
	AIBonus=0.1
	PowerOverlay=FinalBlend'DEKWeaponsMaster206.fX.Matrix'
	ThisPickupClass=Class'MatrixAddonPowerPickup'
}

