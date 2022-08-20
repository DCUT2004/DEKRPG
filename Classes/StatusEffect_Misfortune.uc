class StatusEffect_Misfortune extends StatusEffect
	config(UT2004RPG);
	
var Class<Emitter> MisfortuneFXClass;	
var Emitter MisfortuneFX;
var config int MaxModifierWeapons, MaxModifierPickups;
var config float MisfortuneRadius;

function StartEffect(Pawn Target)
{
	MisfortuneFX = Target.Spawn(MisfortuneFXClass, Target);
	SetTimer(0.5, True);
}

function Timer()
{
	local Pickup P;
	
	if (Modifier >= 0 || Instigator == None || Instigator.Health <= 0)
		Destroy();
	else if (Modifier < 0)
	{
		foreach Instigator.CollidingActors(class'Pickup', P, MisfortuneRadius)
		if ( P.ReadyToPickup(0) && WeaponLocker(P) == None )
		{
			if (-Modifier >= -MaxModifierPickups && P.IsA('AdrenalinePickup') || ClassIsChildOf(P.Class, Class'TournamentHealth') || ClassIsChildOf(P.Class, Class'ShieldPickup') )
				DestroyPickup(P);
			else if (-Modifier >= -MaxModifierWeapons && P.IsA('AdrenalinePickup') || ClassIsChildOf(P.Class, Class'TournamentHealth') || ClassIsChildOf(P.Class, Class'ShieldPickup') || P.IsA('WeaponPickup') || P.IsA('UDamagePack'))
				DestroyPickup(P);
			else if ( P.IsA('AdrenalinePickup') || ClassIsChildOf(P.Class, Class'TournamentHealth') || ClassIsChildOf(P.Class, Class'ShieldPickup') || P.IsA('WeaponPickup') || P.IsA('UDamagePack') || P.IsA('RPGArtifactPickup'))
				DestroyPickup(P);
		}
		Instigator.ReceiveLocalizedMessage(class'MisfortuneMessage');
	}
}

function DestroyPickup(Pickup P)
{
	local Actor A;
	
	if (!P.bDropped && WeaponPickup(P) != None && WeaponPickup(P).bWeaponStay && P.RespawnTime != 0.0)
		P.GotoState('Sleeping');
	else
		P.SetRespawn();
		
	A = spawn(class'RocketExplosion',,, P.Location);
	if (A != None)
	{
		A.RemoteRole = ROLE_SimulatedProxy;
		A.PlaySound(sound'WeaponSounds.BExplosion3',,2.5*P.TransientSoundVolume,,P.TransientSoundRadius);
	}
}

function StopEffect(Pawn Target)
{
	SetTimer(0, False);
	if (MisfortuneFX != None)
		MisfortuneFX.Kill();
}


defaultproperties
{
	 MaxModifier=3
	 MaxModifierPickups=1		//Modifier must be 1 to destroy pickups
	 MaxModifierWeapons=2		//Modifier must be 2 to destroy pickups and weapons; 3 to destroy all the above and artifacts
	 StatusEffectName="Misfortune"
	 bOnlyNegativeModifier=True
	 MisfortuneRadius=400.000
	 MisfortuneFXClass=Class'DEKRPG999X.MisfortuneEffect'
}
