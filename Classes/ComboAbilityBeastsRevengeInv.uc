//The combo that the player has purchased
class ComboAbilityBeastsRevengeInv extends ComboAbilityInv
	config(UT2004RPG);
	
var int AccumulatedDamage;

#exec  AUDIO IMPORT NAME="BeastsRevenge" FILE="Sounds\BeastsRevenge.WAV" GROUP="ComboSounds"
	
function DoEffect()
{
	local Controller C;
	
	AccumulatedDamage = 0;
	
	if (Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None)
	{
		//Give defense
		if (Combo != None)
			Combo.AddBuff(Pawn(Owner), False, False, True, ComboLifespan, class'ComboDefenseInv', 0.850000, bDispellable);
		SetTimer(ComboLifespan, False);
		if (Pawn(Owner).PlayerReplicationInfo != None)
			Level.Game.Broadcast(self, Pawn(Owner).PlayerReplicationInfo.PlayerName $ " casted Beast's Revenge!");
		for ( C = Level.ControllerList; C != None; C = C.NextController )
			if (C != None && C.Pawn != None && C.IsA('PlayerController') && Pawn(Owner) != None && Pawn(Owner).Controller != None && C.SameTeamAs(Pawn(Owner).Controller))
				PlayerController(C).ClientPlaySound(Sound'DEKRPG209C.ComboSounds.BeastsRevenge');
	}
}


//Deal damage to all targets based on the amount of damage we've dealt while we were invisible
function Timer()
{
	local Actor A;
	
	if (Pawn(Owner) != None)
	{
		if (AccumulatedDamage > 0)
			if (Combo != None)
				Combo.ComboDamage(AccumulatedDamage*EffectMultiplier, bAll, False, bSingle, ComboDamageType,  class'RocketExplosion', True);
		AccumulatedDamage = 0;
		if (xPawn(Pawn(Owner)) != None)
			xPawn(Pawn(Owner)).SetInvisibility(0.0);
		if (Pawn(Owner).Controller != None && PlayerController(Pawn(Owner).Controller) != None)
			PlayerController(Pawn(Owner).Controller).ClientPlaySound(Sound'ONSVehicleSounds-S.LaserSounds.Laser17');
		A = Spawn(Class'ONSPlasmaHitGreen', Pawn(Owner), , Pawn(Owner).Location);
		if (A != None)
			A.RemoteRole = ROLE_SimulatedProxy;
	}
}

defaultproperties
{
}
