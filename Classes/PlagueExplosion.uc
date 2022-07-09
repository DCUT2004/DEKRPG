class PlagueExplosion extends Emitter
	placeable;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=7,G=110))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=7,G=110,A=255))
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-200.000000,Max=200.000000)
         StartSpinRange=(X=(Min=1.055000,Max=2.355000))
         SizeScale(0)=(RelativeTime=3.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=75.000000,Max=75.000000))
         InitialParticlesPerSecond=225.000000
         Texture=Texture'VMParticleTextures.VehicleExplosions.VMExp2_framesANIM'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.750000,Max=0.750000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG209F.PlagueExplosion.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
}
