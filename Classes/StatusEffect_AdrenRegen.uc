class StatusEffect_AdrenRegen extends StatusEffect
	config(UT2004RPG);
	
var xEmitter FX;

function StartEffect(Pawn Target)
{
	SetTimer(1, True);
	FX = Instigator.Spawn(xEmitterBuffFX, Instigator,, Instigator.Location);
	if (FX != None)
	{
		FX.bHardAttach = True;
		FX.SetBase(Instigator);
	}
}

function Timer()
{
	if (Instigator == None || Instigator.Health <= 0 || Instigator.Controller == None || Modifier == 0)
		Destroy();
		
	if (Instigator.IsA('Monster'))		//Monsters have no use for adrenaline
		Destroy();
	
	if (Modifier > 0)
		Instigator.Controller.AwardAdrenaline(Modifier);
	else
		Instigator.Controller.Adrenaline += Modifier;		//Modifier is negative
		
	if (Instigator.Controller.Adrenaline < 0)
		Instigator.Controller.Adrenaline = 0;

	if (Instigator.Controller != None && PlayerController(Instigator.Controller) != None)
		if (Modifier > 0)
			PlayerController(Instigator.Controller).ClientPlaySound(Sound'PickupSounds.AdrenelinPickup');
		else
			PlayerController(Instigator.Controller).ClientPlaySound(Sound'ONSVehicleSounds-S.PowerNode.PwrNodeStartBuild03');
}

function StopEffect(Pawn Target)
{
	SetTimer(0, False);
	if (FX != None)
		FX.Destroy();
}

defaultproperties
{
	StatusEffectName="Adren Drip"
	MaxModifier=5
	xEmitterBuffFX=Class'DEKRPG999X.StatusEffect_AdrenRegenFX'
}
