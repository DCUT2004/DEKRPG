class LinkNode extends Node
    config(UT2004RPG);

#exec OBJ LOAD FILE=..\Textures\UT2004Weapons.utx

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
     VehicleNameString="Link Node"
	 MaxCharge=800
     Skins(0)=Shader'UT2004Weapons.Shaders.PowerPulseShader'
     Skins(1)=Shader'UT2004Weapons.Shaders.PowerPulseShader'
}
