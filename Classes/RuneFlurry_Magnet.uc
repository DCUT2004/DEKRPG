class RuneFlurry_Magnet extends Weapon
	CacheExempt;
	
var RuneMagnet Magnet;

simulated function Destroyed()
{
	Super.Destroyed();
	if (Magnet != None)
		Magnet.Destroy();
}

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209F.RuneFlurryFire'
     FireModeClass(1)=Class'DEKRPG209F.RuneMagnetFire'
     bCanThrow=False
     HudColor=(R=73,G=19,B=138)
     InventoryGroup=4
     ItemName="Flurry / Magnet"
	 IconMaterial=Texture'DEKRPGTexturesMaster209B.Runes.ImmobilizeMagnet'
	 IconCoords=(X1=1,Y1=1,X2=128,Y2=64)
}
