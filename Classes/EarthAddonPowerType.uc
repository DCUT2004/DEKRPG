class EarthAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float EarthFlowerChance, MaxFlowerChance;
var config Array < class < Pickup> > Flowers;

// DoPowerEffect - use the damage here (e.g. energy vampire etc)
function DoPowerEffect(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local Actor A;
	local int x;
	local int FlowerChance;

	Super.DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	if (Pawn(Victim) == None)
		return;
	P = Pawn(Victim);

	if (TheWeapon.IsSameTeam(P))
		return;

	if (Damage <= 0 || Victim.isA('Vehicle') || TheWeapon.GetModifier() <= 0)
		return;

	if (P != None && Damage > P.Health)	//A kill
	{
		FlowerChance = default.EarthFlowerChance  * TheWeapon.GetModifier();
		if (FlowerChance > default.MaxFlowerChance)
			FlowerChance = default.MaxFlowerChance;
		if (Rand(99) <= FlowerChance)
		{
				x = Rand(default.Flowers.Length);
				DropPickups(P, default.Flowers[x], None, 1);
				A = P.Spawn(class'ONSPlasmaHitGreen',,,P.Location);
				if (A != None)
					A.RemoteRole = ROLE_SimulatedProxy;
		}
	}
}

simulated function DropPickups(Pawn Killed, class<Pickup> PickupType, Inventory Inv, int Num)
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

        tossdir = Vector(Killed.GetViewRotation());

    	// Adding coordinates to the directional vector

        tossdir = tossdir *	((Killed.Velocity Dot tossdir) + 100) + Vect(0,0,200);

        // Change the velocity a bit for multiple drops

        tossdir.X += i*Rand(200);
        tossdir.Y += i*Rand(200);
        tossdir.Z += i*Rand(200);


    	Killed.GetAxes(Killed.Rotation, X,Y,Z);

	    // Set the pickup's location to a realistic position outside of the dying pawn's collision cylinder

        pickupObj = Killed.spawn(PickupType,,,(Killed.Location + 0.8 * Killed.CollisionRadius * X + -0.5 * Killed.CollisionRadius * Y),);

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

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'EarthAddonPowerType')	   	// 2 of them doesn't really work
		return false;

	if (NewType == class'FreezeAddonPowerType')	   	// it can't be both
		return false;

	if (NewType == class'SuperHeatAddonPowerType')	   	// it can't be both
		return false;

	return true;
}

defaultproperties
{
	DamagePercent=2.0      // since Freezing hurts
    DamageBonusAgainstEarthMonsters=0.000000
    DamageBonusAgainstIceMonsters=-0.020000
    DamageBonusAgainstFireMonsters=0.100000
    EarthFlowerChance=7.000000
    MaxFlowerChance=50.000000
    Flowers(0)=Class'DEKRPG999X.FlowerBluePickup'
    Flowers(1)=Class'DEKRPG999X.FlowerRedPickup'
    Flowers(2)=Class'DEKRPG999X.FlowerOrangePickup'
    Flowers(3)=Class'DEKRPG999X.FlowerYellowPickup'

	PosName="Freezing"
	ZeroName=""
	NegName=""
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false
	AIBonus=0.1
	PowerOverlay=FinalBlend'FireEngine.Liquids.water03GO-finalblend'
	ThisPickupClass=Class'FreezeAddonPowerPickup'
}

