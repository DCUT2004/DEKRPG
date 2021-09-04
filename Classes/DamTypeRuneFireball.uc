class DamTypeRuneFireball extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'DEKRPG209A.RuneFireball_Meteor'
     DeathString="%o was fried by %k's fireball."
     FemaleSuicide="%o snuffed herself with the fireball."
     MaleSuicide="%o snuffed himself with the fireball."
     bDetonatesGoop=True
     bDelayedDamage=True
     DamageOverlayMaterial=Shader'DEKRPGTexturesMaster209A.fX.PulseRedShader'
     DamageOverlayTime=0.800000
     bSkeletize=True
}
