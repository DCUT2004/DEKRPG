//The combo that the player has purchased
class ComboAbilityTeleStealthInv extends ComboAbilityInv
	config(UT2004RPG);
	
var int AccumulatedDamage;
var config float MinTeleportDist;	//Player will attempt to teleport away at least this distance

#exec  AUDIO IMPORT NAME="TeleStealth" FILE="Sounds\TeleStealth.WAV" GROUP="ComboSounds"
	
function DoEffect()
{
	local Controller C;
	
	AccumulatedDamage = 0;
	
	if (Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None)
	{
		giveInvisibilityInv(Pawn(Owner));
		makeInvisible(Pawn(Owner));
		giveWard(Pawn(Owner));
		teleport(Pawn(Owner));
		SetTimer(ComboLifespan, False);
		if (Pawn(Owner).PlayerReplicationInfo != None)
			Level.Game.Broadcast(self, Pawn(Owner).PlayerReplicationInfo.PlayerName $ " casted Tele-Stealth!");
		for ( C = Level.ControllerList; C != None; C = C.NextController )
			if (C != None && C.Pawn != None && C.IsA('PlayerController') && Pawn(Owner) != None && Pawn(Owner).Controller != None && C.SameTeamAs(Pawn(Owner).Controller))
				PlayerController(C).ClientPlaySound(Sound'DEKRPG209D.ComboSounds.TeleStealth');
	}
}

//Teleport the pawn Other to a random location
function teleport(Pawn Other)
{
	local NavigationPoint Dest;
	local vector PrevLocation;
	local int Count;
	
	Count = 0;
	
	Dest = Other.Controller.FindRandomDest();
	while ((VSize(Dest.Location - Other.Location) <= MinTeleportDist || FastTrace(Dest.Location, Other.Location)) && Count <= 20)
	{
		Dest = Other.Controller.FindRandomDest();
		Count++;
	}
	PrevLocation = Other.Location;
	Other.SetLocation(Dest.Location + vect(0,0,40));
	if (xPawn(Other) != None)
		xPawn(Other).DoTranslocateOut(PrevLocation);
	Other.PlayTeleportEffect(false, false);
}

//Give the invisibility overlay
function makeInvisible(Pawn Other)
{	
	if (xPawn(Other) != None)
		xPawn(Other).SetInvisibility(ComboLifespan);
}

//Give the InvisibilityInv which makes the Pawn undetectable by monsters
function giveInvisibilityInv(Pawn Other)
{
	local InvisibilityInv Inv;
	
	Inv = InvisibilityInv(Other.FindInventoryType(Class'InvisibilityInv'));
	if (Inv == None)
	{
		Inv = Other.Spawn(Class'InvisibilityInv');
		Inv.Lifespan = ComboLifespan;
		Inv.GiveTo(Other);
	}
	else
	{
		Inv.Lifespan = ComboLifespan;
	}
}

//Give the Pawn 100% chance to ward ailments
function giveWard(Pawn Other)
{
	if (Combo != None)
	{
		Combo.AddBuff(Pawn(Owner), bAll, False, bSingle, ComboLifespan, class'ComboWardInv', 100, bDispellable);
	}
}

//Timer is called one second before this inventory item is destroyed
//Deal damage to a single target based on the amount of damage we've dealt while we were invisible
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
		A = Spawn(Class'ONSPlasmaHitRed', Pawn(Owner), , Pawn(Owner).Location);
		if (A != None)
			A.RemoteRole = ROLE_SimulatedProxy;
	}
}

defaultproperties
{
	MinTeleportDist=2000.000000
}
