class ComboSomeFXB extends Emitter;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
}

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         ProjectionNormal=(X=1.000000,Z=0.000000)
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=25,G=255,R=251))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=25,G=255,R=251))
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.900000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationOffset=(X=-2.000000)
         UseRotationFrom=PTRS_Actor
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=75.000000,Max=93.750000))
         InitialParticlesPerSecond=500.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStarRed'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG209A.ComboSomeFXB.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         UseColorScale=True
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=25,G=255,R=251))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=25,G=255,R=251))
         ColorScale(2)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=35
         DetailMode=DM_High
         StartLocationShape=PTLS_Polar
         StartLocationPolarRange=(Y=(Max=65536.000000),Z=(Min=8.000000,Max=64.000000))
         UseRotationFrom=PTRS_Actor
         RotationOffset=(Yaw=16384)
         SpinsPerSecondRange=(X=(Max=0.050000))
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=7.200000,Max=22.500000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2Red'
         LifetimeRange=(Min=0.250000,Max=0.750000)
         StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=-150.000000,Max=150.000000))
         StartVelocityRadialRange=(Min=-100.000000,Max=-150.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(2)=SpriteEmitter'DEKRPG209A.ComboSomeFXB.SpriteEmitter5'

     bNoDelete=False
     bHardAttach=True
}
