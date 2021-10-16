//The combo that the player has purchased
class ComboAbilityRavenRitualInv extends ComboAbilityInv
	config(UT2004RPG);
	
var config int HealAmount;
var config float MaxMultiplier;

#exec  AUDIO IMPORT NAME="RavenRitual" FILE="Sounds\RavenRitual1.WAV" GROUP="ComboSounds"
	
function DoEffect()
{
	local Controller C;
	
	if (Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None)
	{
		//Boost health
		Pawn(Owner).GiveHealth(HealAmount, Pawn(Owner).Health + HealAmount);
		if (Pawn(Owner).Health > Pawn(Owner).HealthMax*MaxMultiplier)
			Pawn(Owner).Health = Pawn(Owner).HealthMax*MaxMultiplier;
		
		//Deal damage if health is over max
		if (Pawn(Owner).Health > Pawn(Owner).HealthMax)
		{
			SetTimer(ComboLifespan, True);
		}
			
		//Display message and play sound
		if (Pawn(Owner).PlayerReplicationInfo != None)
			Level.Game.Broadcast(self, Pawn(Owner).PlayerReplicationInfo.PlayerName $ " casted Raven Ritual!");
		for ( C = Level.ControllerList; C != None; C = C.NextController )
			if (C != None && C.Pawn != None && C.IsA('PlayerController') && Pawn(Owner) != None && Pawn(Owner).Controller != None && C.SameTeamAs(Pawn(Owner).Controller))
				PlayerController(C).ClientPlaySound(Sound'DEKRPG209B.ComboSounds.RavenRitual');
	}
}


//Deal damage to all targets based on the amount of damage we've dealt while we were invisible
function Timer()
{
	local Actor A;
	
	if (Pawn(Owner) != None)
	{
		if (Pawn(Owner).Health <= Pawn(Owner).HealthMax)
		{
			SetTimer(0, False);
			return;
		}
		if (Combo != None)
			Combo.ComboDamage(ComboDamage, bAll, False, bSingle, ComboDamageType,  class'RocketExplosion', True);
		if (Pawn(Owner).Controller != None && PlayerController(Pawn(Owner).Controller) != None)
			PlayerController(Pawn(Owner).Controller).ClientPlaySound(Sound'ONSVehicleSounds-S.LaserSounds.Laser17');
		A = Spawn(Class'ONSPlasmaHitPurple', Pawn(Owner), , Pawn(Owner).Location);
		if (A != None)
			A.RemoteRole = ROLE_SimulatedProxy;
	}
}

defaultproperties
{
	MaxMultiplier=2.00000000
	HealAmount=100
}
