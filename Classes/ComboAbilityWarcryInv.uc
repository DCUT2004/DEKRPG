//The combo that the player has purchased
class ComboAbilityWarcryInv extends ComboAbilityInv
	config(UT2004RPG);
	
function DoEffect()
{
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			Combo.AddBuff(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboAttackInv', EffectMultiplier, bDispellable);
			EffectEmitter = Pawn(Owner).Spawn(EffectEmitterClass, Pawn(Owner), , Pawn(Owner).Location, Pawn(Owner).Rotation);
		}
	}
}

defaultproperties
{

}
