class AutoGunONSController extends AutoGunController;

function Possess(Pawn aPawn)
{
	Super.Possess(aPawn);

	if (ONSWeaponPawn(aPawn) != None && ONSWeaponPawn(aPawn).Gun != None)
		ONSWeaponPawn(aPawn).Gun.bActive = true;
}

state Engaged
{
	function BeginState()
	{
		Focus = Enemy;
		Target = Enemy;
		bFire = 1;
		Pawn.Fire(0);
	}
}

State WaitForTarget
{
	function BeginState()
	{
		Target = Enemy;
		bFire = 1;
		Pawn.Fire(0);
	}
}

defaultproperties
{
}
