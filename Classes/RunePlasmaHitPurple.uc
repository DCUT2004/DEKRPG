class RunePlasmaHitPurple extends ONSPlasmaHitPurple;

simulated function PostNetBeginPlay()
{
	Emitters[2].Disabled = true;
}	
