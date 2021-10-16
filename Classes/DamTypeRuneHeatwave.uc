class DamTypeRuneHeatwave extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'DEKRPG209B.RuneFireball_Heatwave'
     DeathString="%o was fried by %k's Heatwave."
     FemaleSuicide="%o fried herself with the Heatwave."
     MaleSuicide="%o fried himself with the Heatwave."
     bDetonatesGoop=True
     bDelayedDamage=True
     DamageOverlayMaterial=Shader'DEKRPGTexturesMaster209B.fX.PulseRedShader'
     DamageOverlayTime=0.800000
     bSkeletize=True
}
