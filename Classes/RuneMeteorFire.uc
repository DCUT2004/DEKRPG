//Trace to a location
//Go vertically up some distance from the traced location
//Spawn meteors front, behind, left, and right at the raised location
class RuneMeteorFire extends RuneInstantFire
	config(DEKWeapons);

var config Vector LocationHeight;	//How far up from the trace's hit location the meteor should spawn
var config int NumMeteors;	//How many meteors should spawn
var config float MinMeteorRange, MaxMeteorRange;	//How far front, back, left and right from the central location meteors should cover

function DoTrace(Vector Start, Rotator Dir)
{
    local Vector Z, End, HitLocation, HitNormal, CentralLocation, SpawnLocation;
	local float MeteorRangeX, MeteorRangeY;
    local Actor Other;
	local Projectile P;
	local int x;

	MaxRange();

	Z = Vector(Dir);
	End = Start + TraceRange * Z;

	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
	
	//HitLocation from Weapon.Trace is an OUT vector. So we now have the location of our crosshair, adjusted for trace range
	//Go up Z units at HitLocation
	
	if (GetSpawnHeight(HitLocation, CentralLocation))	//CentralLocation in GetSpawnHeight is an OUT vector, so we now have our central location for meteors
	{
		for (x = 0; x < NumMeteors; x++)
		{
			MeteorRangeX = RandRange(MinMeteorRange, MaxMeteorRAnge);
			MeteorRangeY = RandRange(MinMeteorRange, MaxMeteorRAnge);
			SpawnLocation = CentralLocation;
			SpawnLocation.X += MeteorRangeX;
			SpawnLocation.Y += MeteorRangeY;

			P = Instigator.Spawn(Class'Meteor', Instigator, , SpawnLocation);
		}
	}
}

//Trace from MyLocation to SpawnLocation
//Returns true if a meteor can spawn at this location
function bool GetSpawnHeight(Vector MyLocation, OUT Vector SpawnLocation)
{
	local vector HitLocation;
	local vector HitNormal;
	local Actor AHit;
	
	SpawnLocation = MyLocation + LocationHeight;

    AHit = Trace(HitLocation, HitNormal, SpawnLocation, MyLocation, true);
	if (AHit == None || !AHit.bWorldGeometry)
		return True;	
	return False;
}

defaultproperties
{
	 TraceRange=10000.0000
	 NumMeteors=4
     MinMeteorRange=-500.000000
     MaxMeteorRange=500.000000
	 LocationHeight=(X=0,Y=0,Z=1000.000)
	 AdrenCost=20
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     FireSound=SoundGroup'WeaponSounds.RocketLauncher.RocketLauncherFire'
     FireForce="RocketLauncherFire"
     FireRate=4.000000
}
