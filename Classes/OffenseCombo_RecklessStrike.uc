class OffenseCombo_RecklessStrike extends OffenseCombo
	config(UT2004RPG);
	
var config int DefenseModifier;
var config int DefenseLifespan;
var config bool bDefenseDispellable;
var config bool bDefenseStackable;

function DoDamage(Pawn Target)
{
	local Actor FX;
	local StatusEffectInventory StatusInv;
	
	if (Target == None || Target.Health <= 0 || Target.Controller == None)
		return;
	
	FX = Target.Spawn(class'RocketExplosion', Target);
	if (FX != None)
		FX.RemoteRole = ROLE_SimulatedProxy;
	Target.PlaySound(sound'WeaponSounds.BExplosion3',,1.5*Target.TransientSoundVolume,,Target.TransientSoundRadius);
	Target.TakeDamage(DamagePerHit, Instigator, Target.Location, Vect(0,0,0), DamageType);
	
	if (Instigator == None)
		return;
	StatusInv = StatusEffectInventory(Instigator.FindInventoryType(Class'StatusEffectInventory'));
	if (StatusInv == None)
		return;
	StatusInv.AddStatusEffect(Class'StatusEffect_DamageReduction', DefenseModifier, DefenseLifespan, bDefenseDispellable, bDefenseStackable);
}

defaultproperties
{
	DefenseModifier=-15
	DefenseLifespan=25
	bDefenseDispellable=False
	bDefenseStackable=False
}
