class DruidForceSmallBlock extends DruidSmallBlock;

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local int reducedDamage;
    
    if (Damage > 0)
        reducedDamage = Max(1, Damage / 2);    // force blocks take half damage
    else
        reducedDamage = Damage;
        
    Super.TakeDamage(reducedDamage, instigatedBy, hitlocation, vect(0,0,0), damageType);
}

defaultproperties
{
     Skins(0)=AS_FX_TX.WhiteShield_FB
}
