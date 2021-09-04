class LootInv extends Inventory;

var float LetterDropChance, GemDropChance, ArtifactDropChance;
var Pawn PawnOwner;

replication
{
	reliable if (bNetInitial && Role == ROLE_Authority)
		PawnOwner;
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	if(Other == None)
	{
		destroy();
		return;
	}
	if (Other != None)
		PawnOwner = Other;
	Super.GiveTo(Other);
}

simulated function destroyed()
{
	local float LetterNumber, GemNumber, ArtifactNumber;
	
	LetterNumber = Rand(99);
	GemNumber = Rand(99);
	ArtifactNumber = Rand(99);
	
	if (PawnOwner != None && PawnOwner.Controller != None && LetterNumber <= LetterDropChance)
	{
		if (Rand(99) <= 20)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.ArtifactLetterBPickup', None, 1);
		else if (Rand(99) <= 40)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.ArtifactLetterOPickup', None, 1);
		else if (Rand(99) <= 60)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.ArtifactLetterNPickup', None, 1);
		else if (Rand(99) <= 80)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.ArtifactLetterUPickup', None, 1);
		else if (Rand(99) <= 100)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.ArtifactLetterSPickup', None, 1);
	}
	
	if (PawnOwner != None && PawnOwner.Controller != None && GemNumber <= GemDropChance)
	{
		if (Rand(99) <= 33)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.GemExperiencePickupBlue', None, 1);
		else if (Rand(99) <= 66)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.GemExperiencePickupGreen', None, 1);
		else if (Rand(99) <= 100)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.GemExperiencePickupPurple', None, 1);
	}
	if (PawnOwner != None && PawnOwner.Controller != None && ArtifactNumber <= ArtifactDropChance)
	{
		if (Rand(99) <= 12.5)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.DruidArtifactFlightPickup', None, 1);
		else if (Rand(99) <= 25)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.DruidArtifactInvulnerabilityPickup', None, 1);
		else if (Rand(99) <= 37.5)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.DruidArtifactLightningRodPickup', None, 1);
		else if (Rand(99) <= 50)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.DruidArtifactMakeMagicWeaponPickup', None, 1);
		else if (Rand(99) <= 62.5)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.DruidArtifactTeleportPickup', None, 1);
		else if (Rand(99) <= 75)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.DruidSpiderPickup', None, 1);
		else if (Rand(99) <= 87.5)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.DruidArtifactTripleDamagePickup', None, 1);
		else if (Rand(99) <= 100)
			DropPickups(PawnOwner.Controller, class'DEKRPG209A.DruidEnhancedArtifactMonsterSummonPickup', None, 1);
	}
	Super.Destroyed();

}

simulated function DropPickups(Controller Killed, class<Pickup> PickupType, Inventory Inv, int Num)
{
    local Pickup pickupObj;
	local vector tossdir, X, Y, Z;
    local int i;

    for(i=0; i < Num; i++)
    {
        // This chain of events based on the way that weapon pickups are dropped when a pawn dies
	    // See Pawn.Died()

    	// Find out which direction the new pickup should be thrown

    	// Get a vector indicating direction the dying pawn was looking

        tossdir = Vector(Killed.Pawn.GetViewRotation());

    	// Adding coordinates to the directional vector

        tossdir = tossdir *	((Killed.Pawn.Velocity Dot tossdir) + 100) + Vect(0,0,200);

        // Change the velocity a bit for multiple drops

        tossdir.X += i*Rand(200);
        tossdir.Y += i*Rand(200);
        tossdir.Z += i*Rand(200);


    	Killed.Pawn.GetAxes(Killed.Pawn.Rotation, X,Y,Z);

	    // Set the pickup's location to a realistic position outside of the dying pawn's collision cylinder

        pickupObj = Killed.spawn(PickupType,,,(Killed.Pawn.Location + 0.8 * Killed.Pawn.CollisionRadius * X + -0.5 * Killed.Pawn.CollisionRadius * Y),);

        if(pickupObj == None)
        {
            Log("Pinata2k4 spawn failure");
            return;
        }

		// Now apply the throwing velocity to the position of the pickup
	    pickupObj.velocity = tossdir;

        pickupObj.InitDroppedPickupFor(Inv);
    }
}

defaultproperties
{
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
