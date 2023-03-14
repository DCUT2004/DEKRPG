class FireRingNode extends Node
    config(UT2004RPG);

#exec OBJ LOAD FILE=..\Textures\EpicParticles.utx

simulated event PostNetBeginPlay()
{
	super.PostNetBeginPlay();
 
    // set the shader for this node type   
	if ( TurretSwivel != None )
	{
        TurretSwivel.Skins[0] = Skins[0];
        TurretSwivel.Skins[1] = Skins[1];
    }
}

defaultproperties
{
     VehicleNameString="Fire Ring Node"
	 MaxCharge=1200
     Skins(0)=Texture'EpicParticles.Flares.FlameWave3'
     Skins(1)=Texture'EpicParticles.Flares.FlameWave3'
}
