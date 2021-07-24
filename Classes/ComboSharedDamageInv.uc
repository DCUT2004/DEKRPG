class ComboSharedDamageInv extends ComboEffectInv;

var int TotalPlayers;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	bBuff = True;
	
	if (Other != None)
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	Super.GiveTo(Other);
}

function Timer()
{
	local Controller C, NextC;
	local int Count;
	
	C = Level.ControllerList;
	Count = 0;
	
	while (C != None)
	{
		NextC = C.NextController;
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && PawnOwner != None &&
		(PawnOwner.IsA('Monster') && ((C.Pawn.IsA('Monster') && FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv')) == None))) ||
		(!PawnOwner.IsA('Monster') && C.SameTeamAs(PawnOwner.Controller) && !C.Pawn.IsA('Vehicle')) ) 
		{
			if (C.Pawn != None && ComboSharedDamageInv(C.Pawn.FindInventoryType(class'ComboSharedDamageInv')) != None)
			{
				Count++;
			}
		}
		C = NextC;
	}
	if (Count < 1)
		Count = 1;
	TotalPlayers = Count;
}

//Shares damage to all teammembers
//Does NOT apply damage to the PawnOwner. PawnOwner damage will be applied directly
function ServeDamage(int Damage, Pawn instigatedBy)
{
	local Controller C, NextC;
	local ComboSharedDamageInv Inv;
	
	if (instigatedBy == None || instigatedBy.Controller == None || PawnOwner == None || PawnOwner.Controller == None)
		return;
	if (instigatedBy.Controller.SameTeamAs(PawnOwner.Controller))
		return;
	
	if (TotalPlayers > 1)
		Damage /= TotalPlayers;
	if (Damage < 1)
		Damage = 1;
	
	if (Damage > 0)
	{
		C = Level.ControllerList;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && PawnOwner != None && PawnOwner.Controller != None && C.Pawn != PawnOwner && !C.bGodMode &&
			(PawnOwner.IsA('Monster') && ((C.Pawn.IsA('Monster') && FriendlyMonsterInv(C.Pawn.FindInventoryType(class'FriendlyMonsterInv')) == None))) ||
			(!PawnOwner.IsA('Monster') && C.SameTeamAs(PawnOwner.Controller) && !C.Pawn.IsA('Vehicle') ) )
			{
				if (C.Pawn != None)
					Inv = ComboSharedDamageInv(C.Pawn.FindInventoryType(class'ComboSharedDamageInv'));
				if (C.Pawn != None && Inv != None && instigatedBy != None)
				{
					C.Pawn.TakeDamage(Damage, instigatedBy, C.Pawn.Location, vect(0,0,0), class'DamTypeSharedDamage');
					//Log("Sharing damage. C.Pawn is a monster?" $ C.Pawn.IsA('Monster'));
				}
			}
			C = NextC;
		}
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return Default.ComboNameMessage $ Switch $ Default.SecondsMessage;
}

defaultproperties
{
	 bBuff=True
	 ComboNameMessage="+ Shared Damage: "
}
