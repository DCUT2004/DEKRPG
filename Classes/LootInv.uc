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
    local int randValue;
    local class<AddonPowerPickup> PowerTypePickup;
	local Monster M;
    local int ScoringValue;

	if (PawnOwner == None || PawnOwner.Controller == None)	// but keep checking since we know the victim could disappear anytime
    {
        Super.Destroyed();
		return; 
    }

	M = Monster(PawnOwner);
	if (M == None)
        ScoringValue = M.ScoringValue;
    else
        ScoringValue = PawnOwner.HealthMax/50;
	
	LetterNumber = Rand(99);
	GemNumber = Rand(99);
	if (ScoringValue >= 10)
		ArtifactNumber = Rand(59);
	else if (ScoringValue >= 6)
		ArtifactNumber = Rand(79);
    else
	   ArtifactNumber = Rand(99);
		
	// Log("=== LootInv LetterNumber:" @ LetterNumber @ LetterDropChance @ "Gem:" @ GemNumber @ GemDropChance @ "ArtifactNumber:" @ ArtifactNumber @ ArtifactDropChance @ PawnOwner);
     	
	if (PawnOwner != None && PawnOwner.Controller != None && LetterNumber <= LetterDropChance)
	{
		// based on AbilityLuckyStrike
		if (ClassIsChildOf(PawnOwner.Class, class'SMPTitan') || ClassIsChildOf(PawnOwner.Class, class'SMPStoneTitan'))
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.ArtifactLetterNPickup', None, 1);
		else if (ClassIsChildOf(PawnOwner.Class, class'SMPQueen'))
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.ArtifactLetterUPickup', None, 1);
		else if (ClassIsChildOf(PawnOwner.Class, class'Warlord'))
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.ArtifactLetterBPickup', None, 1);
		else if (ScoringValue > 10)
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.ArtifactLetterSPickup', None, 1);
		else if (ScoringValue > 8)
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.ArtifactLetterOPickup', None, 1);
	}
	
	if (PawnOwner != None && PawnOwner.Controller != None && GemNumber <= GemDropChance)
	{
		if (ScoringValue > 10)
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.GemExperiencePickupPurple', None, 1);
		else if (ScoringValue > 6)
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.GemExperiencePickupGreen', None, 1);
		else
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.GemExperiencePickupBlue', None, 1);
	}
    
	if (PawnOwner != None && PawnOwner.Controller != None && ArtifactNumber <= ArtifactDropChance)
	{
        randValue = Rand(99);
		if (randValue <= 20)
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.DruidArtifactLightningRodPickup', None, 1);
		if (randValue <= 40)
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.ArtifactPlusAddonPickup', None, 1);
		else if (randValue <= 60)
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.DruidArtifactMakeMagicWeaponPickup', None, 1);
		else if (randValue <= 70)
        {
            PowerTypePickup = SelectWeaponPowerup();
            if (PowerTypePickup != None)
                DropPickups(PawnOwner.Controller, PowerTypePickup, None, 1);
        }
		else if (randValue <= 80)
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.DruidArtifactTripleDamagePickup', None, 1);
		else
			DropPickups(PawnOwner.Controller, class'DEKRPG999X.DruidEnhancedArtifactMonsterSummonPickup', None, 1);
	}
	Super.Destroyed();

}

simulated function class<AddonPowerPickup> SelectWeaponPowerup()
{
	local int iSumChance;
	local int q;
	local class<AddonPowerType> PowerType;

	iSumChance = 0;
	for (q = 0; q < class'DEKRPGWeapon'.default.AvailableAddonPowerTypes.Length ; q++) 
		iSumChance += class'DEKRPGWeapon'.default.AvailableAddonPowerTypes[q].LuckChance; 

	for (q = 0; q < class'DEKRPGWeapon'.default.AvailableAddonPowerTypes.Length ; q++) 
		if (Rand(iSumChance) < class'DEKRPGWeapon'.default.AvailableAddonPowerTypes[q].LuckChance)
		{
			PowerType = class'DEKRPGWeapon'.default.AvailableAddonPowerTypes[q].PowerType;
			return PowerType.default.ThisPickupClass;
		}

	// in principle, we should never get here, but due to the non-rand rand (ask Spacey), we will. So try again
	for (q = 0; q < class'DEKRPGWeapon'.default.AvailableAddonPowerTypes.Length ; q++) 
		if (Rand(iSumChance) < class'DEKRPGWeapon'.default.AvailableAddonPowerTypes[q].LuckChance)
		{
			PowerType = class'DEKRPGWeapon'.default.AvailableAddonPowerTypes[q].PowerType;
			return PowerType.default.ThisPickupClass;
		}

	// forget it
	return None;
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
        // Log("LootInv dropping " @ PickupType);
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
