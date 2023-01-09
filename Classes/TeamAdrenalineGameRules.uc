class TeamAdrenalineGameRules extends GameRules
	config(UT2004RPG);

var config int MaterialKillChance;	//The chance to unlock a material upon a kill
var config int LowMaterialChance, MediumMaterialChance;
var config float MonsterScoreMultiplier;	//% of the monster's scoring value to add as adrenaline
var config int GeodeChance;

function int NetDamage( int OriginalDamage, int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	
	//Add to monster team adrenaline on each hit
	if (injured != None && instigatedBy != None)
		if (instigatedBy.IsA('Monster') && !injured.IsA('Monster') && !injured.IsA('DruidBlock') && injured.GetTeamNum() != instigatedBy.GetTeamNum())
			class'MutTeamAdrenaline'.static.AddMonsterTeamAdren();
	return Super.NetDamage(OriginalDamage, Damage, injured, instigatedBy, HitLocation, Momentum, DamageType);
}

function ScoreKill(Controller Killer, Controller Killed)
{
	local int MaterialRankChance;
	local GiveItemsInv GInv;
	local Monster M;
	local MutTeamAdrenaline MutTeamAdren;

	if (Killer != None && Killed != None)
	{
		if (Killer.Pawn != None && Killer.Pawn.Health > 0 && Killed.Pawn != None && Killer.Pawn.GetTeamNum() != Killed.Pawn.GetTeamNum() && !Killed.Pawn.IsA('HealerNali') && !Killed.Pawn.IsA('MissionCow'))
		{
			if (Killed.Pawn != None && Killed.Pawn.IsA('Monster'))
			{
				M = Monster(Killed.Pawn);
				class'MutTeamAdrenaline'.static.AddPlayerTeamAdren(M.ScoringValue * MonsterScoreMultiplier);
			}
			else
				class'MutTeamAdrenaline'.static.AddPlayerTeamAdren(1);
		}
		if (Rand(100) <= MaterialKillChance && Killed.Pawn.IsA('Monster'))		//Quick condition for materials, though not proper (i.e. monster kills a pet)
		{
			GInv = class'GiveItemsInv'.static.GetGiveItemsInv(Killer);
			if (GInv != None)
			{
				MutTeamAdren = Class'MutTeamAdrenaline'.static.GetMutTeamAdrenaline(Level.Game);
				if (MutTeamAdren != None)
				{
					MaterialRankChance = Rand(100);
					if (MaterialRankChance <= LowMaterialChance)
						GInv.AddMaterial(MutTeamAdren.LowMaterials[Rand(MutTeamAdren.LOW_MATERIALS_LENGTH)]);
					else if (MaterialRankChance <= MediumMaterialChance)
						GInv.AddMaterial(MutTeamAdren.MediumMaterials[Rand(MutTeamAdren.MED_MATERIALS_LENGTH)]);
					else
						GInv.AddMaterial(MutTeamAdren.HighMaterials[Rand(MutTeamAdren.HIGH_MATERIALS_LENGTH)]);
				}
			}
		}
		if (Rand(100) <= GeodeChance && Killed.Pawn.IsA('Monster'))
			DropPickups(Killed, Killer, Class'GeodePickup', None, 1);
	}
	
	Super.ScoreKill(Killer, Killed);
}

static function DropPickups(Controller Killed, Controller Killer, class<Pickup> PickupType, Inventory Inv, int Num)
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

        pickupObj = Killer.spawn(PickupType,,,(Killed.Pawn.Location + 0.8 * Killed.Pawn.CollisionRadius * X + -0.5 * Killed.Pawn.CollisionRadius * Y),);

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
	GeodeChance=50
	MonsterScoreMultiplier=0.50000000
	MaterialKillChance=1
	LowMaterialChance=80	//80% chance to get a low material
	MediumMaterialChance=95	//15% chance to get a medium material, 5% for a high material
}
