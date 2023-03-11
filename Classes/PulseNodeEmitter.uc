class PulseNodeEmitter extends Emitter
	placeable;

#exec OBJ LOAD FILE=ParticleMeshes.usx

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseDirectionAs=PTDU_Forward
        UseColorScale=True
        ColorScale(1)=(RelativeTime=0.330000)
        ColorScale(2)=(RelativeTime=0.660000,Color=(B=255,G=128,R=128))
        ColorScale(3)=(RelativeTime=1.000000)
        FadeInEndTime=0.100000
        FadeIn=True
        MaxParticles=40
        RespawnDeadParticles=False
        StartLocationOffset=(Z=-64.000000)
        MeshSpawningStaticMesh=StaticMesh'ParticleMeshes.Simple.ParticleSphere3'
        MeshSpawning=PTMS_Linear
        MeshScaleRange=(Z=(Min=2.000000,Max=2.000000))
        UniformMeshScale=False
        UseRevolution=True
        RevolutionsPerSecondRange=(Z=(Min=-0.200000,Max=0.200000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.100000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=0.800000,RelativeSize=16.000000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=25.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=4000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'EpicParticles.Smoke.Smokepuff2'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(Z=(Min=-1.000000,Max=1.000000))
        StartVelocityRadialRange=(Min=-1.000000,Max=-1.000000)
        VelocityLossRange=(X=(Max=0.100000),Y=(Max=0.100000))
        GetVelocityDirectionFrom=PTVD_AddRadial
        UseVelocityScale=True
        VelocityScale(1)=(RelativeTime=0.500000)
        VelocityScale(2)=(RelativeTime=0.700000,RelativeVelocity=(X=3000.000000,Y=3000.000000,Z=1000.000000))
        VelocityScale(3)=(RelativeTime=1.000000)
        SecondsBeforeInactive=0
        Name="SpriteEmitter0"
     End Object
     Emitters(0)=SpriteEmitter'DEKRPG999X.PulseNodeEmitter.SpriteEmitter0'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
     Style=STY_Masked
     bDirectional=True
     bGameRelevant=true
}
