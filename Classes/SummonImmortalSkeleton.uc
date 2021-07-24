class SummonImmortalSkeleton extends SummonMortalSkeleton;

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	return;
}

defaultproperties
{
     ClawDamage=35
     LifeSpan=180.000000
     Skins(0)=Shader'DEKMonstersTexturesMaster208.NecroMonsters.SkeletonShader'
     Skins(1)=Shader'DEKMonstersTexturesMaster208.NecroMonsters.SkeletonShader'
}
