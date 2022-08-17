/*
* Positive Modifier = faster speed
* Negative Modifier = slower speed (i.e. Freezing effect)
*/

class StatusEffect_Speed extends StatusEffect
	config(UT2004RPG);
	
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(0.5, true);
}

simulated function Timer()
{
	if (Instigator == None || Instigator.Health <= 0)
		Destroy();
	if (Modifier == 0)
		Destroy();
	if(!class'DEKRPGWeapon'.static.NullCanTriggerPhysics(Instigator))
		Destroy();
	if(Instigator != None)
	{
		if (Modifier < 0)
			Instigator.Spawn(xEmitterAilmentFX, Instigator,, Instigator.Location, Instigator.Rotation);
	}
}
	

function StartEffect(Pawn Target)
{
	if(!class'DEKRPGWeapon'.static.NullCanTriggerPhysics(Target))
		Destroy();
	if (Target != None)
	{
		class'AbilityIncreasedProtection'.static.quickfoot(10 * Modifier, Target);
		if (Modifier < 0)
			Target.PlaySound(AilmentSound,,2.5*Target.TransientSoundVolume,,Target.TransientSoundRadius);
	}
}
function StopEffect(Pawn Target)
{
	if (Target != None)
		class'AbilityIncreasedProtection'.static.quickfoot(0, Target);
}

defaultproperties
{
	bStackable=False
	bDispellable=True
	xEmitterAilmentFX=Class'DEKRPG999X.IceSmoke'
	AilmentSound=Sound'Slaughtersounds.Machinery.Heavy_End'
}
