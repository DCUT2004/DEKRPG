class RuneImmobilize_Magnet extends Weapon
	CacheExempt;

defaultproperties
{
     FireModeClass(0)=Class'DEKRPG209B.RuneImmobilizeFire'
     FireModeClass(1)=Class'DEKRPG209B.RuneMagnetFire'
     bCanThrow=False
     HudColor=(R=73,G=19,B=138)
     InventoryGroup=4
     ItemName="Immobilize / Magnet"
	 IconMaterial=Texture'DEKRPGTexturesMaster209B.Runes.ImmobilizeMagnet'
	 IconCoords=(X1=1,Y1=1,X2=128,Y2=64)
}
