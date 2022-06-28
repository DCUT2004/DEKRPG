//-----------------------------------------------------------
//
//-----------------------------------------------------------
class IceballEffect extends Emitter;

#exec OBJ LOAD FILE="..\Textures\AW-2k4XP.utx"

function PostBeginPlay()
{
	local PlayerController PC;

	Super.PostBeginPlay();
	PC = Level.GetLocalPlayerController();
	if ( PC == None )
	{
		Destroy();
		return;
	}
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) || (PC.ViewTarget == None) || (VSize(PC.ViewTarget.Location - Location) > 6000) )
	{
		Emitters[0].Disabled = true;
		Emitters[1].Disabled = true;
		Emitters[2].Disabled = true;
		Emitters[6].Disabled = true;
	}
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter7
         UseColorScale=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(A=255,R=108,G=199,B=245))
         ColorScale(1)=(RelativeTime=1.000000,Color=(A=255,R=108,G=199,B=245))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         DetailMode=DM_High
         StartSizeRange=(X=(Min=75.000000,Max=75.000000))
         InitialParticlesPerSecond=500.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'EpicParticles.Flares.SoftFlare'
         LifetimeRange=(Min=0.020000,Max=0.020000)
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG209D.IceballEffect.SpriteEmitter7'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.100000,Color=(R=108,G=199,B=245))
         ColorScale(2)=(RelativeTime=0.600000,Color=(R=108,G=199,B=245))
         ColorScale(3)=(RelativeTime=1.000000)
         Opacity=0.500000
         FadeOutStartTime=0.555100
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         DetailMode=DM_High
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=30.000000,Max=32.500000),Y=(Min=40.000000,Max=42.500000),Z=(Min=40.000000,Max=42.500000))
         InitialParticlesPerSecond=6.000000
         DrawStyle=PTDS_Brighten
         Texture=Texture'AW-2k4XP.Weapons.ShockTankEffectCore'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(1)=SpriteEmitter'DEKRPG209D.IceballEffect.SpriteEmitter9'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter11
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(1)=(RelativeTime=0.200000,Color=(R=108,G=199,B=245))
         ColorScale(2)=(RelativeTime=0.600000,Color=(R=108,G=199,B=245))
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.200000)
         StartSizeRange=(X=(Min=45.000000,Max=45.000000))
         InitialParticlesPerSecond=6.000000
         DrawStyle=PTDS_Darken
         Texture=Texture'AW-2004Particles.Energy.EclipseCircle'
         LifetimeRange=(Min=0.500000,Max=0.500000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(2)=SpriteEmitter'DEKRPG209D.IceballEffect.SpriteEmitter11'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(1)=(RelativeTime=0.200000,Color=(R=108,G=199,B=245))
         ColorScale(2)=(RelativeTime=0.800000,Color=(R=108,G=199,B=245))
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         InitialParticlesPerSecond=6.000000
         SpinsPerSecondRange=(X=(Max=0.100000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000))
         Texture=Texture'AW-2k4XP.Weapons.ShockTankEffectCore2'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(3)=SpriteEmitter'DEKRPG209D.IceballEffect.SpriteEmitter12'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter13
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(1)=(RelativeTime=0.500000,Color=(R=108,G=199,B=245))
         ColorScale(2)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         InitialParticlesPerSecond=6.000000
         SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=40.000000,Max=40.000000))
         DrawStyle=PTDS_Darken
         Texture=Texture'AW-2k4XP.Weapons.ShockTankEffectSwirl'
         LifetimeRange=(Min=2.000000,Max=2.000000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(4)=SpriteEmitter'DEKRPG209D.IceballEffect.SpriteEmitter13'

     Begin Object Class=MeshEmitter Name=MeshEmitter7
         StaticMesh=StaticMesh'AW-2004Particles.Weapons.PlasmaSphere'
         UseParticleColor=True
         Disabled=True
         Backup_Disabled=True
         UniformSize=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         InitialParticlesPerSecond=6.000000
         StartSizeRange=(X=(Min=0.3750000,Max=0.3750000))
         LifetimeRange=(Min=0.100000,Max=0.100000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(5)=MeshEmitter'DEKRPG209D.IceballEffect.MeshEmitter7'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter14
         UseColorScale=True
         SpinParticles=True
         UniformSize=True
         UseRandomSubdivision=True
         ColorScale(1)=(RelativeTime=0.200000,Color=(R=108,G=199,B=245))
         ColorScale(2)=(RelativeTime=0.500000,Color=(R=108,G=199,B=245))
         ColorScale(3)=(RelativeTime=0.600000)
         ColorScale(4)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=4
         InitialParticlesPerSecond=6.000000
         DetailMode=DM_High
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=30.000000,Max=40.000000))
         Texture=Texture'AW-2004Particles.Energy.ElecPanelsP'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         LifetimeRange=(Min=0.250000,Max=0.250000)
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(6)=SpriteEmitter'DEKRPG209D.IceballEffect.SpriteEmitter14'

     AutoDestroy=True
     bNoDelete=False
}
