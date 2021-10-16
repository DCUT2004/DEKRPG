class RW_Earth extends OneDropRPGWeapon
   HideDropDown
   CacheExempt
   config(UT2004RPG);

var config float EarthOnFireDamageBonus;
var config float DamageBonus;
var config float EarthFlowerChance, MaxFlowerChance;
var config Array < class < Pickup> > Flowers;

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
   if ( ClassIsChildOf(Weapon, class'TransLauncher') )
      return false;

   return true;
}

function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	if(damage > 0)
	{
		if (Damage < (OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent))
			Damage = OriginalDamage * class'OneDropRPGWeapon'.default.MinDamagePercent;
	}
	Super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

function AdjustTargetDamage(out int Damage, Actor Victim, Vector HitLocation, out Vector Momentum, class<DamageType> DamageType)
{
	local Pawn P;
	local FireInv Inv;
	local Actor A;
	local int x;
	local int FlowerChance;

	if (!bIdentified)
	  Identify();

	if (Victim == None)
	  return; //nothing to do

	//Prevents "weaponswitch" exploit allowing a player to use a weapon (e.g. Mines) and then switch to another weapon (e.g. Vorpal) and get the effect applied to the first weapon
	if (!CheckCorrectDamage(ModifiedWeapon, DamageType))
	  return;
	  
	if (Damage <= 0)
		return;

	if (!class'OneDropRPGWeapon'.static.CheckCorrectDamage(ModifiedWeapon, DamageType))
		return;

	P = Pawn(Victim);

	if (Damage > 0)
	{
		if (P != None && P.Health > 0)
		{
			Inv = FireInv(P.FindInventoryType(class'FireInv'));
			if (Inv != None)
			{
				Damage *= (1.0 + EarthOnFireDamageBonus* Modifier);
				Momentum *= 1.0 + EarthOnFireDamageBonus * Modifier;
				A = P.spawn(class'EarthHitEffect', P,, P.Location);
				if (A != None)
					A.RemoteRole = ROLE_SimulatedProxy;
			}
			else
			{
				Damage = Max(1, Damage * (1.0 + DamageBonus * Modifier));
				Momentum *= 1.0 + DamageBonus * Modifier;
			}
		}
		
		if (Damage > P.Health)	//A kill
		{
			FlowerChance = default.EarthFlowerChance*Modifier;
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

defaultproperties
{
     EarthOnFireDamageBonus=0.100000
     DamageBonus=0.020000
     EarthFlowerChance=7.000000
     MaxFlowerChance=50.000000
     Flowers(0)=Class'DEKRPG209B.FlowerBluePickup'
     Flowers(1)=Class'DEKRPG209B.FlowerRedPickup'
     Flowers(2)=Class'DEKRPG209B.FlowerOrangePickup'
     Flowers(3)=Class'DEKRPG209B.FlowerYellowPickup'
     ModifierOverlay=FinalBlend'FireEngine.Liquids.water03GO-finalblend'
     MinModifier=3
     MaxModifier=7
     AIRatingBonus=0.102000
     PrefixPos="Earthly "
}
