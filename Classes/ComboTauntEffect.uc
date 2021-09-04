class ComboTauntEffect extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseColorScale=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(R=222,G=148,B=0))
         ColorScale(1)=(RelativeTime=1.000000)
         FadeInEndTime=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=28.000000,Max=28.000000))
         InitialParticlesPerSecond=4.000000
         Texture=Texture'AW-2004Particles.Energy.AirBlast'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         InitialDelayRange=(Min=0.150000,Max=0.150000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG209A.ComboTauntEffect.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseColorScale=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.750000,Color=(R=181,G=227,B=89))
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.250000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=68.000000,Max=68.000000))
         InitialParticlesPerSecond=4.000000
         Texture=Texture'AW-2004Particles.Energy.EclipseCircle'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         InitialDelayRange=(Min=0.250000,Max=0.250000)
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG209A.ComboTauntEffect.SpriteEmitter5'

     AutoReset=True
     CullDistance=5000.000000
     bNoDelete=False
     RemoteRole=ROLE_SimulatedProxy
     bOwnerNoSee=True
}
