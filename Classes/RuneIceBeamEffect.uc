class RuneIceBeamEffect extends BlueSuperShockBeam;

simulated function SpawnEffects()
{
	local ShockBeamEffect E;
	
	Super.SpawnEffects();
	E = Spawn(class'RuneExtraBlueBeam');
	if ( E != None )
		E.AimAt(mSpawnVecA, HitNormal); 
}

defaultproperties
{
     mSizeRange(0)=48.000000
     mSizeRange(1)=96.000000
     CoilClass=None
     LightHue=230
     bNetTemporary=False
     Skins(0)=ColorModifier'DEKRPGTexturesMaster209A.Runes.IceBeam'
}
