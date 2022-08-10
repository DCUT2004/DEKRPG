class GreenBeamEmitter extends ShockBeamEffect;

var() float MaxLength;
var vector HitLocation;

replication
{
	reliable if (bNetInitial)
		HitLocation;
}

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
	return;
}

simulated function SpawnEffects()
{
	return;
}

defaultproperties
{
     Texture=Texture'DEKMonstersTexturesMaster208.EarthMonsters.ShockBeamTexGREEN'
     Skins(0)=Texture'DEKMonstersTexturesMaster208.EarthMonsters.ShockBeamTexGREEN'
}
