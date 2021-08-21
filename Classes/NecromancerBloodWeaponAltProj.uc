class NecromancerBloodWeaponAltProj extends FlakShell;

simulated function PostBeginPlay()
{
	local Rotator R;
	
	if (Trail != None)
		Trail.mRegen=False;
	if (Glow != None)
		Glow.Destroy();

	Super.PostBeginPlay();
	Velocity = Vector(Rotation) * Speed;  
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	Velocity.z += TossZ; 
	initialDir = Velocity;
}

simulated function PostNetBeginPlay()
{
	if (Glow != None)
		Glow.Destroy();
	if (Trail != None)
		Trail.mRegen=False;
	Super.PostNetBeginPlay();
}

simulated function SpawnEffects( vector HitLocation, vector HitNormal )
{
	local PlayerController PC;

	PlaySound (Sound'PlayerSounds.NewGibs.NewGib1',,3*TransientSoundVolume);
	if ( EffectIsRelevant(Location,false) )
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 3000 )
			spawn(class'NecromancerBloodWeaponExplosion',,,HitLocation + HitNormal*16 );
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority )
	{
		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
	}
    Destroy();
}

defaultproperties
{
     MyDamageType=Class'DEKRPG208AJ.DamTypeBloodBurst'
     StaticMesh=StaticMesh'Editor.TexPropSphere'
     AmbientSound=None
     DrawScale=0.085000
     Skins(0)=Shader'AWGlobal.Shaders.WetBlood01aw'
     Skins(1)=Shader'AWGlobal.Shaders.WetBlood01aw'
}
