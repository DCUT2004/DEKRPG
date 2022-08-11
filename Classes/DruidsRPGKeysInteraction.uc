class DruidsRPGKeysInteraction extends RPGInteraction
		config(UT2004RPG);

var GiveItemsInv GiveItemsInv;
// Aliases for artifact switching placed in ArtifactKeyConfigs in the DruidsRPGKeyMut, and transfered via GiveItemsInv.
struct ArtifactKeyConfig
{
	Var String Alias;
	var Class<RPGArtifact> ArtifactClass;
};
var Array<ArtifactKeyConfig> ArtifactKeyConfigs;

var Material HealthBarMaterial;
var float BarUSize, BarVSize;
var color RedColor, OrangeColor, YellowColor, GreenColor, BlueColor, PurpleColor;
var localized string PointsText;
var int dummyi;
var color MPBarColor;
var localized string MPText, AdrenalineText, MonsterPointsText, RewardText;

var EngineerPointsInv EInv;
var MonsterPointsInv MInv;
var SpecialistInv SpInv;
var PlagueSpreader PInv;
var MissionInvBETA MissionInv;
var MissionMultiplayerHUDInv MMPI;

var DruidAwarenessEnemyList EnemyList;

event Initialized()
{
	BarUSize = HealthBarMaterial.MaterialUSize();
	BarVSize = HealthBarMaterial.MaterialVSize();
	EnemyList = ViewportOwner.Actor.Spawn(class'DruidAwarenessEnemyList');
	
	super.Initialized();
}

event NotifyLevelChange()
{
	if (EnemyList != None)
	{
		EnemyList.Destroy();
		EnemyList = None;
	}

	EInv = None;
	MInv = None;
	SPInv = None;
	PInv = None;
	GiveItemsInv = None;
	MissionInv = None;
	MMPI = None;
	
	//close stats menu if it's open, and remove interaction
	super.NotifyLevelChange();
}

//Find local player's GiveItems inventory item
function FindGiveItemsInv()
{
	local Inventory Inv;
	local GiveItemsInv FoundGiveItemsInv;

	for (Inv = ViewportOwner.Actor.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		GiveItemsInv = GiveItemsInv(Inv);
		if (GiveItemsInv != None)
			return;
		else
		{
			//atrocious hack for Jailbreak's bad code in JBTag (sets its Inventory property to itself)
			if (Inv.Inventory == Inv)
			{
				Inv.Inventory = None;
				foreach ViewportOwner.Actor.DynamicActors(class'GiveItemsInv', FoundGiveItemsInv)
				{
					if (FoundGiveItemsInv.Owner == ViewportOwner.Actor || FoundGiveItemsInv.Owner == ViewportOwner.Actor.Pawn)
					{
						GiveItemsInv = FoundGiveItemsInv;
						Inv.Inventory = GiveItemsInv;
						break;
					}
				}
				return;
			}
		}
	}

	ForEach ViewportOwner.Actor.DynamicActors(class'GiveItemsInv',FoundGiveItemsInv)
	{
		if (FoundGiveItemsInv.Owner == ViewportOwner.Actor || FoundGiveItemsInv.Owner == ViewportOwner.Actor.Pawn)
		{
			if(GiveItemsInv == None)
			{
				GiveItemsInv = FoundGiveItemsInv;
				Log("DruidsRPGKeysInteraction found a GiveItemsInv in DynamicActors search");
			}
			else
			{
				if(FoundGiveItemsInv.Owner == None)
					Log("DruidsRPGKeysInteraction found an additional GiveItemsInv in DynamicActors search with owner None. ViewportOwner.Actor also None");
				else
					Log("DruidsRPGKeysInteraction found an additional GiveItemsInv in DynamicActors search that belonged to me");
			}
		}
		else
			Log("*DruidsRPGKeysInteraction found a GiveItemsInv, but not mine.");
	}

}

//Find local player's stats inventory item
function FindEPInv()
{
	local Inventory Inv;
	local EngineerPointsInv FoundEInv;

	for (Inv = ViewportOwner.Actor.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		FoundEInv = EngineerPointsInv(Inv);
		if (FoundEInv != None)
		{
			if (FoundEInv.Owner == ViewportOwner.Actor || FoundEInv.Owner == ViewportOwner.Actor.Pawn)
				EInv = FoundEInv;
			return;
		}
		else
		{
			//atrocious hack for Jailbreak's bad code in JBTag (sets its Inventory property to itself)
			if (Inv.Inventory == Inv)
			{
				Inv.Inventory = None;
				foreach ViewportOwner.Actor.DynamicActors(class'EngineerPointsInv', FoundEInv)
				{
					if (FoundEInv.Owner == ViewportOwner.Actor || FoundEInv.Owner == ViewportOwner.Actor.Pawn)
					{
						EInv = FoundEInv;
						Inv.Inventory = EInv;
						break;
					}
					else
					{
						return;
					}
				}
				return;
			}
		}
	}
}

//Find local player's stats inventory item
function FindMPInv()
{
	local Inventory Inv;
	local MonsterPointsInv FoundMInv;

	for (Inv = ViewportOwner.Actor.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		FoundMInv = MonsterPointsInv(Inv);
		if (FoundMInv != None)
		{
			if (FoundMInv.Owner == ViewportOwner.Actor || FoundMInv.Owner == ViewportOwner.Actor.Pawn)
				MInv = FoundMInv;
			return;
		}
		else
		{
			//atrocious hack for Jailbreak's bad code in JBTag (sets its Inventory property to itself)
			if (Inv.Inventory == Inv)
			{
				Inv.Inventory = None;
				foreach ViewportOwner.Actor.DynamicActors(class'MonsterPointsInv', FoundMInv)
				{
					if (FoundMInv.Owner == ViewportOwner.Actor || FoundMInv.Owner == ViewportOwner.Actor.Pawn)
					{
						MInv = FoundMInv;
						Inv.Inventory = MInv;
						break;
					}
				}
				return;
			}
		}
	}
}

function FindSpInv()
{
	local Inventory Inv;
	local SpecialistInv FoundSpInv;

	for (Inv = ViewportOwner.Actor.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		FoundSpInv = SpecialistInv(Inv);
		if (FoundSpInv != None)
		{
			if (FoundSpInv.Owner == ViewportOwner.Actor || FoundSpInv.Owner == ViewportOwner.Actor.Pawn)
				SpInv = FoundSpInv;
			return;
		}
		else
		{
			//atrocious hack for Jailbreak's bad code in JBTag (sets its Inventory property to itself)
			if (Inv.Inventory == Inv)
			{
				Inv.Inventory = None;
				foreach ViewportOwner.Actor.DynamicActors(class'SpecialistInv', FoundSpInv)
				{
					if (FoundSpInv.Owner == ViewportOwner.Actor || FoundSpInv.Owner == ViewportOwner.Actor.Pawn)
					{
						SpInv = FoundSpInv;
						Inv.Inventory = SpInv;
						break;
					}
				}
				return;
			}
		}
	}
}

function FindPInv()
{
	local Inventory Inv;
	local PlagueSpreader FoundPInv;

	for (Inv = ViewportOwner.Actor.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		FoundPInv = PlagueSpreader(Inv);
		if (FoundPInv != None)
		{
			if (FoundPInv.Owner == ViewportOwner.Actor || FoundPInv.Owner == ViewportOwner.Actor.Pawn)
				PInv = FoundPInv;
			return;
		}
		else
		{
			//atrocious hack for Jailbreak's bad code in JBTag (sets its Inventory property to itself)
			if (Inv.Inventory == Inv)
			{
				Inv.Inventory = None;
				foreach ViewportOwner.Actor.DynamicActors(class'PlagueSpreader', FoundPInv)
				{
					if (FoundPInv.Owner == ViewportOwner.Actor || FoundPInv.Owner == ViewportOwner.Actor.Pawn)
					{
						PInv = FoundPInv;
						Inv.Inventory = PInv;
						break;
					}
				}
				return;
			}
		}
	}
}

//Find local player's stats inventory item
function FindMissionInv()
{
	local Inventory Inv;
	local MissionInvBETA FoundMInv;

	for (Inv = ViewportOwner.Actor.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		FoundMInv = MissionInvBETA(Inv);
		if (FoundMInv != None)
		{
			if (FoundMInv.Owner == ViewportOwner.Actor || FoundMInv.Owner == ViewportOwner.Actor.Pawn)
				MissionInv = FoundMInv;
			return;
		}
		else
		{
			//atrocious hack for Jailbreak's bad code in JBTag (sets its Inventory property to itself)
			if (Inv.Inventory == Inv)
			{
				Inv.Inventory = None;
				foreach ViewportOwner.Actor.DynamicActors(class'MissionInvBETA', FoundMInv)
				{
					if (FoundMInv.Owner == ViewportOwner.Actor || FoundMInv.Owner == ViewportOwner.Actor.Pawn)
					{
						MissionInv = FoundMInv;
						Inv.Inventory = MissionInv;
						break;
					}
				}
				return;
			}
		}
	}
}

function FindMMPI()
{
	local Inventory Inv;
	local MissionMultiplayerHUDInv FoundMMPI;

	for (Inv = ViewportOwner.Actor.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		FoundMMPI = MissionMultiplayerHUDInv(Inv);
		if (FoundMMPI != None)
		{
			if (FoundMMPI.Owner == ViewportOwner.Actor || FoundMMPI.Owner == ViewportOwner.Actor.Pawn)
				MMPI = FoundMMPI;
			return;
		}
		else
		{
			//atrocious hack for Jailbreak's bad code in JBTag (sets its Inventory property to itself)
			if (Inv.Inventory == Inv)
			{
				Inv.Inventory = None;
				foreach ViewportOwner.Actor.DynamicActors(class'MissionMultiplayerHUDInv', FoundMMPI)
				{
					if (FoundMMPI.Owner == ViewportOwner.Actor || FoundMMPI.Owner == ViewportOwner.Actor.Pawn)
					{
						MMPI = FoundMMPI;
						Inv.Inventory = MMPI;
						break;
					}
				}
				return;
			}
		}
	}
}

//Detect pressing of a key bound to one of our aliases
function bool KeyEvent(EInputKey Key, EInputAction Action, float Delta)
{

	local string tmp;
	local Pawn P;


	if (Action != IST_Press)
		return false;

	//Use console commands to get the name of the numeric Key, and then the alias bound to that keyname. On one line for better performance for some reason.
	tmp = ViewportOwner.Actor.ConsoleCommand("KEYBINDING"@ViewportOwner.Actor.ConsoleCommand("KEYNAME"@Key));

	if (ViewportOwner.Actor.Pawn != None)
	{
		P = ViewportOwner.Actor.Pawn;
		//If it's our alias (which doesn't actually exist), then act on it
		if (tmp ~= "DropHealth" ) 
		{
			class'GiveItemsInv'.static.DropHealth(P.Controller);
			return true;
		}
		if (tmp ~= "DropAdrenaline" ) 
		{
			class'GiveItemsInv'.static.DropAdrenaline(P.Controller);
			return true;
		}
		//now the monster master stuff
		if (tmp ~= "AttackEnemy" ) 
		{
			class'MonsterPointsInv'.static.AttackEnemy(P);
			return true;
		}
		else if (tmp ~= "Follow" ) 
		{
			class'MonsterPointsInv'.static.PetFollow(P);
			return true;
		}
		else if (tmp ~= "Stay" ) 
		{
			class'MonsterPointsInv'.static.PetStay(P);
			return true;
		}
		//now the engineer stuff
		else if (tmp ~= "Lock" )
		{
			class'EngineerPointsInv'.static.LockVehicle(P);
			return true;
		}
		else if (tmp ~= "Unlock" )
		{
			class'EngineerPointsInv'.static.UnlockVehicle(P);
			return true;
		}
		//now the missions stuff
		else if (tmp ~= "ExitMissionOne" )
		{
			class'MissionInvBETA'.static.ExitMission(P, 0);
			return true;
		}
		else if (tmp ~= "ExitMissionTwo" )
		{
			class'MissionInvBETA'.static.ExitMission(P, 1);
			return true;
		}
		else if (tmp ~= "ExitMissionThree" )
		{
			class'MissionInvBETA'.static.ExitMission(P, 2);
			return true;
		}
	}
	
	//IOk now check if it is the Stats required
	if (tmp ~= "rpgstatsmenu" || (bDefaultBindings && Key == IK_L))
	{
		if (StatsInv == None)
			FindStatsInv();
		if (StatsInv == None)
			return false;
			
		if (GiveItemsInv == None && ViewportOwner.Actor.Pawn != None && ViewportOwner.Actor.Pawn.Controller != None)
			GiveItemsInv = class'GiveItemsInv'.static.GetGiveItemsInv(ViewportOwner.Actor.Pawn.Controller);
	
		if (GiveItemsInv == None)
			FindGiveItemsInv();		// safety cop out

		//Show stat menu
		if (GiveItemsInv == None)
			return true;		// we haven't really dealt with it, but we do not want anyone else doing it either

		ViewportOwner.GUIController.OpenMenu(string(class'DruidsRPGStatsMenu'));
		DruidsRPGStatsMenu(GUIController(ViewportOwner.GUIController).TopPage()).InitFor2(StatsInv,GiveItemsInv);
		LevelMessagePointThreshold = StatsInv.Data.PointsAvailable;
		return true;
	}

	//Don't care about this event, pass it on for further processing
	return super.KeyEvent(Key, Action, Delta);
}

exec function SelectTriple()
{
	SelectThisArtifact("SelectTriple");
}

exec function SelectGlobe()
{
	SelectThisArtifact("SelectGlobe");
}

exec function SelectMWM()
{
	SelectThisArtifact("SelectMWM");
}

exec function SelectDouble()
{
	SelectThisArtifact("SelectDouble");
}

exec function SelectMax()
{
	SelectThisArtifact("SelectMax");
}

exec function SelectPlusOne()
{
	SelectThisArtifact("SelectPlusOne");
}

exec function SelectBolt()
{
	SelectThisArtifact("SelectBolt");
}

exec function SelectRepulsion()
{
	SelectThisArtifact("SelectRepulsion");
}

exec function SelectFreezeBomb()
{
	SelectThisArtifact("SelectFreezeBomb");
}

exec function SelectPoisonBlast()
{
	SelectThisArtifact("SelectPoisonBlast");
}

exec function SelectMegaBlast()
{
	SelectThisArtifact("SelectMegaBlast");
}

exec function SelectHealingBlast()
{
	SelectThisArtifact("SelectHealingBlast");
}

exec function SelectMedic()
{
	SelectThisArtifact("SelectMedic");
}

exec function SelectFlight()
{
	SelectThisArtifact("SelectFlight");
}

exec function SelectElectroMagnet()
{
	SelectThisArtifact("SelectElectroMagnet");
}

exec function SelectTeleport()
{
	SelectThisArtifact("SelectTeleport");
}

exec function SelectBeam()
{
	SelectThisArtifact("SelectBeam");
}

exec function SelectRod()
{
	SelectThisArtifact("SelectRod");
}

exec function SelectSphereInv()
{
	SelectThisArtifact("SelectSphereInv");
}

exec function SelectSphereHeal()
{
	SelectThisArtifact("SelectSphereHeal");
}

exec function SelectSphereDamage()
{
	SelectThisArtifact("SelectSphereDamage");
}

exec function SelectRemoteDamage()
{
	SelectThisArtifact("SelectRemoteDamage");
}

exec function SelectRemoteInv()
{
	SelectThisArtifact("SelectRemoteInv");
}

exec function SelectRemoteMax()
{
	SelectThisArtifact("SelectRemoteMax");
}

exec function SelectShieldBlast()
{
	SelectThisArtifact("SelectShieldBlast");
}

exec function SelectChain()
{
	SelectThisArtifact("SelectChain");
}

exec function SelectFireBall()
{
	SelectThisArtifact("SelectFireBall");
}

exec function SelectRemoteBooster()
{
	SelectThisArtifact("SelectRemoteBooster");
}

exec function SelectResurrect()
{
	SelectThisArtifact("SelectResurrect");
}

exec function SelectDecay()
{
	SelectThisArtifact("SelectDecay");
}

exec function SelectMassDrain()
{
	SelectThisArtifact("SelectMassDrain");
}

exec function SelectPossess()
{
	SelectThisArtifact("SelectPossess");
}

exec function SelectMagnet()
{
	SelectThisArtifact("SelectMagnet");
}

exec function SelectDecoy()
{
	SelectThisArtifact("SelectDecoy");
}

exec function SelectImmobilize()
{
	SelectThisArtifact("SelectImmobilize");
}

exec function SelectGlowStreak()
{
	SelectThisArtifact("SelectGlowStreak");
}

exec function SelectMeteor()
{
	SelectThisArtifact("SelectMeteor");
}

exec function SelectRemoteAmplifier()
{
	SelectThisArtifact("SelectRemoteAmplifier");
}

function string GetSummonFriendlyName(Inventory Inv)
{
	// if this inventory item is a monster or turret etc, return the FriendlyName
	if (DruidMonsterMasterArtifactMonsterSummon(Inv) != None)
	{
		// its a monster summoning artifact
		return DruidMonsterMasterArtifactMonsterSummon(Inv).FriendlyName;
	}

	if (Summonifact(Inv) != None)
	{
		// its a building/turret/vehicle summoning artifact
		return Summonifact(Inv).FriendlyName;
	}

	return "";	//?
}

function SelectThisArtifact (string ArtifactAlias)
{
	local class<RPGArtifact> ThisArtifactClass;
	local class<RPGArtifact> InitialArtifactClass;
	local int Count;
	local Inventory Inv, StartInv;
	local Pawn P;
	local int i;
	local bool GoneRound;
	local String InitialFriendlyName;
	local String curFriendlyName;

	P = ViewportOwner.Actor.Pawn;
	// first find the exact class we are looking for
	ThisArtifactClass = None;
	for (i = 0; i < ArtifactKeyConfigs.length; i++)
	{
		if (ArtifactKeyConfigs[i].Alias == ArtifactAlias) 
		{
			ThisArtifactClass = ArtifactKeyConfigs[i].ArtifactClass;
			i = ArtifactKeyConfigs.length;
		}
	}
	if (ThisArtifactClass == None)
		return;		// not configured in, so don't use

	// now it would be nice to just step through the artifacts using NextItem() until we get to the required one
	// however, the server responds too slowly.
	// so, we find where we are in the inventory. Find how many more artifacts we have to step over
	// and issue that many NextItem requests. Eventually the server catches up with us.

	InitialArtifactClass = None;

	if (P.SelectedItem == None)
	{
		P.NextItem();
		InitialArtifactClass = class<RPGArtifact>(P.Inventory.Class);
		// it would be nice just to compare the class.
		// however with monsters and construction artifacts we also need to check it is the correct one
		// because there are many artifacts with the same class
		InitialFriendlyName = GetSummonFriendlyName(P.Inventory);
	}
	else
	{
		InitialArtifactClass = class<RPGArtifact>(P.SelectedItem.class);
		InitialFriendlyName = GetSummonFriendlyName(P.SelectedItem);
	}

	if ((InitialArtifactClass != None) && (InitialArtifactClass == ThisArtifactClass ))
	{
		return;
	}

	// first find current item in inventory
	Count = 0;
	for( Inv=P.Inventory; Inv!=None && Count < 500; Inv=Inv.Inventory )
	{
		if ( Inv.class == InitialArtifactClass )
		{
			if (InitialFriendlyName == GetSummonFriendlyName(Inv))	// got the correct one
			{
				StartInv = Inv;
				Count = 501;
			}
		}
		Count++;
	}
	if (count<501)
	{
		// didn't find it. Start at beginning.
		StartInv=P.Inventory;
	}
	if (StartInv == None)
	{
		// don't know what we do here
		return;
	}
	// now step through until we get to the one we want
	Count = 0;
	GoneRound = false;
	P.NextItem();	// for the Inv=StartInv.Inventory step
	for( Inv=StartInv.Inventory; Count < 500; Inv=Inv.Inventory )
	{
		if (Inv == None)
		{
			Inv=P.Inventory;	//loop back to beginning again
			GoneRound = true;
		}

		curFriendlyName = GetSummonFriendlyName(Inv);
		if ( Inv.class == ThisArtifactClass)
		{
			return;
		}
		else if ( Inv.class == InitialArtifactClass && InitialFriendlyName == curFriendlyName && GoneRound)
		{
			return;			// got back to start again, so mustn't have it
		}
		else if (RPGArtifact(Inv) != None)
		{
			// its an artifact, so need to skip
			P.NextItem();
		}
		Count++;
	}
}

function PreRender(Canvas Canvas)
{
	local int i;
	local float Dist, XScale, YScale, HealthScale, ScreenX, HealthMax;
	local vector BarLoc, CameraLocation, X, Y, Z;
	local rotator CameraRotation;
	local Pawn Enemy;
	local Pawn P;
	local float ShieldMax, CurShield;
	local float HM66, HM33, MedMax, SHMax;

	if (ViewportOwner == None || ViewportOwner.Actor == None || ViewportOwner.Actor.Pawn == None || ViewportOwner.Actor.Pawn.Health <= 0)
		return;
		
	if (GiveItemsInv == None && ViewportOwner.Actor.Pawn != None && ViewportOwner.Actor.Pawn.Controller != None)
		GiveItemsInv = class'GiveItemsInv'.static.GetGiveItemsInv(ViewportOwner.Actor.Pawn.Controller);
	if (GiveItemsInv == None)
		FindGiveItemsInv();		// safety cop out
	if (GiveItemsInv == None)
		return;		//bomb out. We can't display
	//Now Mission stuff
	//First, check for all missions.
	if (MissionInv == None)
	{
		FindMissionInv();
		if (MissionInv != None)
		{
			if( MissionInv.InteractionOwner != None )
				MissionInv.InteractionOwner.MissionInv = None;
			MissionInv.InteractionOwner = Self;
		}
	}

	Canvas.GetCameraLocation(CameraLocation, CameraRotation);
	// first the Awareness display
	if (GiveItemsInv.AwarenessLevel > 0 && EnemyList != None)
	{
		for (i = 0; i < EnemyList.Enemies.length; i++)
		{
			Enemy = EnemyList.Enemies[i];
			if (Enemy == None || Enemy.Health <= 0 || (xPawn(Enemy) != None && xPawn(Enemy).bInvis))
				continue;
			if (Normal(Enemy.Location - CameraLocation) dot vector(CameraRotation) < 0)
				continue;
			ScreenX = Canvas.WorldToScreen(Enemy.Location).X;
			if (ScreenX < 0 || ScreenX > Canvas.ClipX)
				continue;
	 		Dist = VSize(Enemy.Location - CameraLocation);
	 		if (Dist > ViewportOwner.Actor.TeamBeaconMaxDist * FClamp(0.04 * Enemy.CollisionRadius, 1.0, 3.0))
	 			continue;
			if (!Enemy.FastTrace(Enemy.Location + Enemy.CollisionHeight * vect(0,0,1), ViewportOwner.Actor.Pawn.Location + ViewportOwner.Actor.Pawn.EyeHeight * vect(0,0,1)))
				continue;
	
			GetAxes(rotator(Enemy.Location - CameraLocation), X, Y, Z);
			if (Enemy.IsA('Monster'))
			{
				BarLoc = Canvas.WorldToScreen(Enemy.Location + (Enemy.CollisionHeight * 1.25 + BarVSize / 2) * vect(0,0,1) - Enemy.CollisionRadius * Y);
			}
			else
			{
				BarLoc = Canvas.WorldToScreen(Enemy.Location + (Enemy.CollisionHeight + BarVSize / 2) * vect(0,0,1) - Enemy.CollisionRadius * Y);
			}
			XScale = (Canvas.WorldToScreen(Enemy.Location + (Enemy.CollisionHeight + BarVSize / 2) * vect(0,0,1) + Enemy.CollisionRadius * Y).X - BarLoc.X) / BarUSize;
			YScale = FMin(0.15 * XScale, 0.50);
	
			HealthScale = Enemy.Health/Enemy.HealthMax;
	 		Canvas.Style = 1;
	 		if (GiveItemsInv.AwarenessLevel > 1)
			{
				Canvas.SetPos(BarLoc.X, BarLoc.Y);
				Canvas.DrawColor = class'HUD'.default.GreenColor;
				Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale, BarVSize*YScale, 0, 0, BarUSize, BarVSize);
	
				if (Enemy.IsA('Monster'))
				{
					HealthMax = Enemy.HealthMax;
				}else
				{
					HealthMax = Enemy.HealthMax + 150;
				}
	
		 		Canvas.DrawColor.R = Clamp(Int(255.0 * 2 * (1.0 - HealthScale)), 0, 255);
		 		Canvas.DrawColor.G = Clamp(Int(255.0 * 2 * HealthScale), 0, 255);
	// Enemies above their Enemy.HealthMax start getting some blue.
				Canvas.DrawColor.B = Clamp(Int(255.0 * ((Enemy.Health - Enemy.HealthMax)/150.0)), 0, 255);
			 	Canvas.DrawColor.A = 255;
	// Base the max width of the bar on what we guess is their "actual max health"
	// Enemy pets will mess this up so we clamp it
				Canvas.SetPos(BarLoc.X+(BarUSize*XScale*Fclamp(((Enemy.Health/HealthMax)/2), 0.0, 0.5)), BarLoc.Y);
				Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale*Fclamp(1.0-(Enemy.Health/HealthMax), 0.0, 1.0), BarVSize*YScale, 0, 0, BarUSize, BarVSize);
				if (Enemy.ShieldStrength > 0 && xPawn(Enemy) != None)
				{
					Canvas.DrawColor = class'HUD'.default.GoldColor;
					YScale /= 2;
					Canvas.SetPos(BarLoc.X, BarLoc.Y - BarVSize * (YScale + 0.05));
					Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale*Enemy.ShieldStrength/xPawn(Enemy).ShieldStrengthMax, BarVSize*YScale, 0, 0, BarUSize, BarVSize);
				}
			}
			else
			{
				Canvas.SetPos(BarLoc.X+(BarUSize*XScale*0.25), BarLoc.Y);
				Canvas.DrawColor.B = 0;
				Canvas.DrawColor.A = 255;
				if (HealthScale < 0.10)
				{
					Canvas.DrawColor.G = 0;
					Canvas.DrawColor.R = 200;
				}else if (HealthScale < 0.90)
				{
					Canvas.DrawColor.G = 150;
					Canvas.DrawColor.R = 150;
				}else
				{
					Canvas.DrawColor.R = 0;
					Canvas.DrawColor.G = 125;
				}
				Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale*0.50, BarVSize*YScale*0.50, 0, 0, BarUSize, BarVSize);
			}
		}
	}
	
	// now the Engineer awareness

	if (GiveItemsInv.EngAwarenessLevel > 0 && EnemyList != None)
	{
		for (i = 0; i < EnemyList.TeamPawns.length; i++)
		{
			P = EnemyList.TeamPawns[i];
			if (P == None || P.Health <= 0 || (xPawn(P) != None && xPawn(P).bInvis))
				continue;
			if (Normal(P.Location - CameraLocation) dot vector(CameraRotation) < 0)
				continue;
			ScreenX = Canvas.WorldToScreen(P.Location).X;
			if (ScreenX < 0 || ScreenX > Canvas.ClipX)
				continue;
	 		Dist = VSize(P.Location - CameraLocation);
	 		if (Dist > ViewportOwner.Actor.TeamBeaconMaxDist * FClamp(0.04 * P.CollisionRadius, 1.0, 3.0))
	 			continue;
			if (!P.FastTrace(P.Location + P.CollisionHeight * vect(0,0,1), ViewportOwner.Actor.Pawn.Location + ViewportOwner.Actor.Pawn.EyeHeight * vect(0,0,1)))
				continue;
	
			GetAxes(rotator(P.Location - CameraLocation), X, Y, Z);
			if (P.IsA('Monster'))
			{
				BarLoc = Canvas.WorldToScreen(P.Location + (P.CollisionHeight * 1.25 + BarVSize / 2) * vect(0,0,1) - P.CollisionRadius * Y);
			}
			else
			{
				BarLoc = Canvas.WorldToScreen(P.Location + (P.CollisionHeight + BarVSize / 2) * vect(0,0,1) - P.CollisionRadius * Y);
			}
			XScale = (Canvas.WorldToScreen(P.Location + (P.CollisionHeight + BarVSize / 2) * vect(0,0,1) + P.CollisionRadius * Y).X - BarLoc.X) / BarUSize;
			YScale = FMin(0.15 * XScale, 0.25);
	
	 		Canvas.Style = 1;
	
			CurShield = P.ShieldStrength;
			if (xPawn(P) != None)
				ShieldMax = xPawn(P).ShieldStrengthMax;
			else
				ShieldMax = 150;	// unfortunately ShieldStrengthMax not replicated, so default to 150
			ShieldMax = max(ShieldMax,CurShield);
	
			if (ShieldMax <= 0)
				continue;
			if (CurShield <0)
				CurShield = 0;
			if (CurShield > ShieldMax)
				CurShield = ShieldMax;
	
			if (EnemyList.HardCorePawns[i] > 0)
			{
				// hardcore player cannot be healed. Make sure in same place for medics and engineers
				Canvas.SetPos(BarLoc.X, BarLoc.Y);
				Canvas.DrawColor = class'HUD'.default.BlackColor;
				Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale, BarVSize*YScale, 0, 0, BarUSize, BarVSize);
			}
			else
			{
				// Make the white bar
				BarLoc.Y += BarVSize*FMin(0.15 * XScale, 0.40);		// position under the medic health bar if any
				Canvas.SetPos(BarLoc.X, BarLoc.Y);
				Canvas.DrawColor = class'HUD'.default.WhiteColor;
				if(CurShield >= ShieldMax)
				{	// want bright yellow as the shield is full
					Canvas.DrawColor.A = 255;
					Canvas.DrawColor.B = 0;
					Canvas.DrawColor.G = 255;
					Canvas.DrawColor.R = 255;
				}
				Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale, BarVSize*YScale, 0, 0, BarUSize, BarVSize);
				Canvas.DrawColor.A = 255;
				Canvas.DrawColor.B = 0;
		
				// want an orange color, with less red as it gets healthier
				Canvas.DrawColor.R = 128;
				Canvas.DrawColor.G = Clamp(Int(128*CurShield/ShieldMax), 0, 255);
				Canvas.SetPos(BarLoc.X+(BarUSize*XScale*((CurShield/ShieldMax)/2)), BarLoc.Y );
				Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale*(1.00 - (CurShield/ShieldMax)), BarVSize*YScale, 0, 0, BarUSize, BarVSize);
			}
		}
	}

	// now the medic awareness
	if (GiveItemsInv.MedicAwarenessLevel > 0 && EnemyList != None)
	{
		for (i = 0; i < EnemyList.TeamPawns.length; i++)
		{
			P = EnemyList.TeamPawns[i];
			if (P == None || P.Health <= 0 || (xPawn(P) != None && xPawn(P).bInvis))
				continue;
			if (Normal(P.Location - CameraLocation) dot vector(CameraRotation) < 0)
				continue;
			ScreenX = Canvas.WorldToScreen(P.Location).X;
			if (ScreenX < 0 || ScreenX > Canvas.ClipX)
				continue;
	 		Dist = VSize(P.Location - CameraLocation);
	 		if (Dist > ViewportOwner.Actor.TeamBeaconMaxDist * FClamp(0.04 * P.CollisionRadius, 1.0, 3.0))
	 			continue;
			if (!P.FastTrace(P.Location + P.CollisionHeight * vect(0,0,1), ViewportOwner.Actor.Pawn.Location + ViewportOwner.Actor.Pawn.EyeHeight * vect(0,0,1)))
				continue;
	
			GetAxes(rotator(P.Location - CameraLocation), X, Y, Z);
			if (P.IsA('Monster'))
			{
				BarLoc = Canvas.WorldToScreen(P.Location + (P.CollisionHeight * 1.25 + BarVSize / 2) * vect(0,0,1) - P.CollisionRadius * Y);
			}
			else
			{
				BarLoc = Canvas.WorldToScreen(P.Location + (P.CollisionHeight + BarVSize / 2) * vect(0,0,1) - P.CollisionRadius * Y);
			}
			XScale = (Canvas.WorldToScreen(P.Location + (P.CollisionHeight + BarVSize / 2) * vect(0,0,1) + P.CollisionRadius * Y).X - BarLoc.X) / BarUSize;
			YScale = FMin(0.15 * XScale, 0.40);
	
	 		Canvas.Style = 1;
	
			MedMax = P.HealthMax + 150.0;
			HM66 = P.HealthMax * 0.66;
			HM33 = P.HealthMax * 0.33;
	// Bah just reset it for everyone.  This *should* be everyone's SuperHealthMax.
			SHMax = P.HealthMax + 99.0;
	
			if (EnemyList.HardCorePawns[i] > 0)
			{
				// hardcore player cannot be healed. Make sure in same place for medics and engineers
				YScale = FMin(0.15 * XScale, 0.20);
				Canvas.SetPos(BarLoc.X, BarLoc.Y);
				Canvas.DrawColor = class'HUD'.default.BlackColor;
				Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale, BarVSize*YScale, 0, 0, BarUSize, BarVSize);
			}
			else
			{
				if (GiveItemsInv.MedicAwarenessLevel > 1)
				{
					Canvas.SetPos(BarLoc.X, BarLoc.Y);
		// When people are ghosting, P.Health way > MedMax
					if(P.Health >= MedMax)
					{
						Canvas.DrawColor = class'HUD'.default.BlueColor;
						Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale, BarVSize*YScale, 0, 0, BarUSize, BarVSize);
					}
					else
					{
		// Make the white bar
						Canvas.DrawColor = class'HUD'.default.WhiteColor;
						Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale, BarVSize*YScale, 0, 0, BarUSize, BarVSize);
						Canvas.DrawColor.A = 255;
						Canvas.DrawColor.R = Clamp(Int((1.00 - ((P.Health - HM66)/(P.HealthMax - HM66)))*255.0), 0, 255);
						Canvas.DrawColor.B = Clamp(Int(((P.Health - P.HealthMax)/(SHMax - P.HealthMax))*255.0), 0, 255);
						if(P.Health > P.HealthMax)
						{
							Canvas.DrawColor.G = Clamp(Int((1.00 - ((P.Health - SHMax)/(MedMax - SHMax)))*255.0), 0, 255);
						}else
						{
							Canvas.DrawColor.G = Clamp(Int(((P.Health - HM33)/(HM66 - HM33))*255.0), 0, 255);
						}
						Canvas.SetPos(BarLoc.X+(BarUSize*XScale*((P.Health/MedMax)/2)), BarLoc.Y);
						Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale*(1.00 - (P.Health/MedMax)), BarVSize*YScale, 0, 0, BarUSize, BarVSize);
					}
				}else
				{
					if (P.Health < HM33)
					{
						Canvas.DrawColor.A = 255;
						Canvas.DrawColor.R = 200;
						Canvas.DrawColor.G = 0;
						Canvas.DrawColor.B = 0;
					}else if (P.Health < HM66)
					{
						Canvas.DrawColor.A = 255;
						Canvas.DrawColor.R = 150;
						Canvas.DrawColor.G = 150;
						Canvas.DrawColor.B = 0;
					}else if (P.Health < SHMax)
					{
						Canvas.DrawColor.A = 255;
						Canvas.DrawColor.R = 0;
						Canvas.DrawColor.G = 125;
						Canvas.DrawColor.B = 0;
					}else
					{
						Canvas.DrawColor.A = 255;
						Canvas.DrawColor.R = 0;
						Canvas.DrawColor.G = 0;
						Canvas.DrawColor.B = 100;
					}
					Canvas.SetPos(BarLoc.X+(BarUSize*XScale*0.25),BarLoc.Y);
					Canvas.DrawTile(HealthBarMaterial, BarUSize*XScale*0.50, BarVsize*YScale*0.50, 0, 0, BarUSize, BarVSize);
				}
			}
		}
	}
}

// now show the timers
function PostRender(Canvas Canvas)
{
	local Pawn P;
	local float XL, YL;
	local EnhancedRPGArtifact ea;
	local string pText;
	local Summonifact Sf;
	local int UsedPoints, TotalPoints, PointsLeft, iRecoveryTime;
	local int UsedVPoints, TotalVPoints, UsedTPoints, TotalTPoints, UsedSPoints, TotalSPoints, UsedBPoints, TotalBPoints;
	local int UsedMonsterPoints, TotalMonsterPoints;
	local int iNumHealers;
	local float XLSmall, YLSmall, MPBarX, MPBarY;
	local DruidMonsterMasterArtifactMonsterSummon DMMAMS;
	local ArtifactMissionBETA AM;
	local ArtifactMissionTeam AMT;
	local ArtifactPaladin AP;
	local ArtifactGuardianHeal AGH;
	local RPGClassInv RPGInv;
	
	if ( ViewportOwner == None || ViewportOwner.Actor == None || ViewportOwner.Actor.Pawn == None || ViewportOwner.Actor.Pawn.Health <= 0
	     || (ViewportOwner.Actor.myHud != None && ViewportOwner.Actor.myHud.bShowScoreBoard)
	     || (ViewportOwner.Actor.myHud != None && ViewportOwner.Actor.myHud.bHideHUD) )
	{
		super.PostRender(Canvas);
		if (ViewportOwner == None || ViewportOwner.Actor == None || ViewportOwner.Actor.Pawn == None || ViewportOwner.Actor.Pawn.Health <= 0)
			return;
		if(ViewportOwner.Actor != ViewportOwner.Actor.Level.GetLocalPlayerController())
			return; //this is a spectating player.
	}
	P = ViewportOwner.Actor.Pawn;
	if(P != None && P.isA('Vehicle'))
		P = Vehicle(P).Driver;
	if (P != None)
	{
		RPGInv = RPGClassInv(P.FindInventoryType(class'RPGClassInv'));
		if (RPGInv == None)
		{
			if (bDefaultBindings)
			{
				P.ReceiveLocalizedMessage(class'NoClassMessage', 0);
			}
			else
				P.ReceiveLocalizedMessage(class'NoClassMessage', 1);
		}
	}

	if (TextFont != None)
		Canvas.Font = TextFont;
	Canvas.FontScaleX = Canvas.ClipX / 1024.f;
	Canvas.FontScaleY = Canvas.ClipY / 768.f;

// first the AM stuff. Just the timer for the moment
	ea = EnhancedRPGArtifact(ViewportOwner.Actor.Pawn.SelectedItem);
	if (ea != None && ea.GetRecoveryTime() >0)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		Canvas.FontScaleX *= 2.0; //make it larger
		Canvas.FontScaleY *= 2.0;
	
		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;

		Canvas.SetPos(XL+11, Canvas.ClipY * 0.75 - YL * 3.6); 
		pText = String(ea.GetRecoveryTime());
		Canvas.DrawText(pText);
	}
// now the engineer stuff
	// now lets check if we are linked in a turret - not dependent upon being an Engineer
	iNumHealers = -1;
	if (DruidBallTurret(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DruidBallTurret(ViewportOwner.Actor.Pawn).NumHealers;
	else if (DruidEnergyTurret(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DruidEnergyTurret(ViewportOwner.Actor.Pawn).NumHealers;
	else if (DruidIonCannon(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DruidIonCannon(ViewportOwner.Actor.Pawn).NumHealers;
	else if (DruidMinigunTurret(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DruidMinigunTurret(ViewportOwner.Actor.Pawn).NumHealers;
	else if (DEKOdinTurret(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DEKOdinTurret(ViewportOwner.Actor.Pawn).NumHealers;
	else if (DEKSolarTurret(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DEKSolarTurret(ViewportOwner.Actor.Pawn).NumHealers;
	else if (DEKLynxTurret(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DEKLynxTurret(ViewportOwner.Actor.Pawn).NumHealers;
	else if (DEKLightningTurret(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DEKLightningTurret(ViewportOwner.Actor.Pawn).NumHealers;
	else if (DEKPlasmaTurret(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DEKPlasmaTurret(ViewportOwner.Actor.Pawn).NumHealers;
	else if (DEKStingerTurret(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DEKStingerTurret(ViewportOwner.Actor.Pawn).NumHealers;
	else if (DEKSkyMineTurret(ViewportOwner.Actor.Pawn) != None)
		iNumHealers = DEKSkyMineTurret(ViewportOwner.Actor.Pawn).NumHealers;
	if (iNumHealers > 0)
	{
		Canvas.FontScaleX = Canvas.default.FontScaleX;
		Canvas.FontScaleY = Canvas.default.FontScaleY;
		
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		// first draw the links
		Canvas.SetPos(2, Canvas.ClipY * 0.75 - YL * 7.6);
		Canvas.DrawTile(Material'HudContent.Generic.fbLinks', 64, 32, 0, 0, 128, 64);
		
		// then the number linked
		pText = String(iNumHealers);
		Canvas.SetPos(30, Canvas.ClipY * 0.75 - YL * 7.1);
		Canvas.DrawColor = GreenColor;
		Canvas.DrawText(PText);	
	}

	if (EInv == None)
	{
		FindEPInv();
		if (EInv != None)
		{
			if( EInv.InteractionOwner != None )
				EInv.InteractionOwner.EInv = None;
			EInv.InteractionOwner = Self;
		}
	}
	if (EInv != None && EInv.Isa('EngineerPointsInv'))       // shouldn't be necessary. but...
	{
		UsedVPoints=EInv.UsedVehiclePoints;
		TotalVPoints=EInv.TotalVehiclePoints;
		UsedTPoints=EInv.UsedTurretPoints;
		TotalTPoints=EInv.TotalTurretPoints;
		UsedBPoints=EInv.UsedBuildingPoints;
		TotalBPoints=EInv.TotalBuildingPoints;
		UsedSPoints=EInv.UsedSentinelPoints;
		TotalSPoints=EInv.TotalSentinelPoints;
		TotalPoints = TotalSPoints+TotalTPoints+TotalVPoints+TotalBPoints;
		iRecoveryTime = EInv.GetRecoveryTime();
	}
	else 
	{
		TotalPoints = 0;
		iRecoveryTime = 0;
 	}

// Spectators shouldn't get the Total/UsedXObjPoints replicated now, so
// this should detect them appropriately.  Ideally, EInv won't be found
// either, but I don't know if I trust that - so this for sure will
// result in former spectators not seeing the display on spawn.
	if(TotalPoints > 0)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		Canvas.FontScaleX *= 2.0; //make it larger
		Canvas.FontScaleY *= 2.0;
	
		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;
	
		if (iRecoveryTime >0)
		{
			Canvas.SetPos(XL+11, Canvas.ClipY * 0.75 - YL * 3.6); 
			pText = String(iRecoveryTime);
			Canvas.DrawText(pText);
		}
	
		Sf = Summonifact(ViewportOwner.Actor.Pawn.SelectedItem);
		if (Sf != None)
		{
			//Draw summoning item "Artifact" HUD info
	
			Canvas.FontScaleX = Canvas.default.FontScaleX * 0.80;
			Canvas.FontScaleY = Canvas.default.FontScaleY * 0.80;
	
			Canvas.SetPos(3, Canvas.ClipY * 0.75 - YL * 5.0);
			Canvas.DrawText(Sf.FriendlyName);
	
			UsedPoints=0;
			TotalPoints=0;
			pText = "";
			Canvas.DrawColor = GreenColor;
			if (DruidVehicleSummon(sf) != None)
			{
				UsedPoints=UsedVPoints;
				TotalPoints=TotalVPoints;
			}
			else if (DruidTurretSummon(sf) != None)
			{
				UsedPoints=UsedTPoints;
				TotalPoints=TotalTPoints;
			}
			else if (DruidBuildingSummon(sf) != None)
			{
				UsedPoints=UsedBPoints;
				TotalPoints=TotalBPoints;
			}
			else if (DruidSentinelSummon(sf) != None)
			{
				UsedPoints=UsedSPoints;
				TotalPoints=TotalSPoints;
			}
			PointsLeft = TotalPoints-UsedPoints;
			Canvas.SetPos(4, Canvas.ClipY * 0.75 - YL * 1.3);
			if (iRecoveryTime > 0 || Sf.Points > PointsLeft)
				Canvas.DrawColor = RedColor;
			Canvas.DrawText(PointsText $ Sf.Points $ "/" $ PointsLeft);
		}
	
		Canvas.FontScaleX = Canvas.default.FontScaleX;
		Canvas.FontScaleY = Canvas.default.FontScaleY;
	}
	Canvas.DrawColor = WhiteColor;

	// now the monster master stuff
	if (MInv == None)
	{
		FindMPInv();
		if (MInv != None)
		{
			if( MInv.InteractionOwner != None )
				MInv.InteractionOwner.MInv = None;
			MInv.InteractionOwner = Self;
		}
	}
	if (MInv != None && MInv.Isa('MonsterPointsInv') && MInv.TotalMonsterPoints > 0)
	{
	    TotalMonsterPoints = MInv.TotalMonsterPoints;   // get local copy in case destroyed soon
	    UsedMonsterPoints = MInv.UsedMonsterPoints;

		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		Canvas.FontScaleX *= 0.75; //make it smaller
		Canvas.FontScaleY *= 0.75;
	
		Canvas.TextSize(MPText, XL, YL);
	
		// increase size of the display if necessary for really high levels
		XL = FMax(XL + 9.f * Canvas.FontScaleX, 135.f * Canvas.FontScaleX);
	
		Canvas.Style = 5;
		Canvas.DrawColor = MPBarColor;
		MPBarX = Canvas.ClipX - XL - 1.f;
		MPBarY = Canvas.ClipY * 0.75 - YL * 2.5; //used to be 1.75. 
		Canvas.SetPos(MPBarX, MPBarY);
		Canvas.DrawTile(Material'InterfaceContent.Hud.SkinA', XL * UsedMonsterPoints / TotalMonsterPoints, 15.0 * Canvas.FontScaleY * 1.25, 836, 454, -386 * UsedMonsterPoints / TotalMonsterPoints, 36);
		if ( ViewportOwner.Actor.PlayerReplicationInfo == None || ViewportOwner.Actor.PlayerReplicationInfo.Team == None
		     || ViewportOwner.Actor.PlayerReplicationInfo.Team.TeamIndex != 0 )
			Canvas.DrawColor = BlueTeamTint;
		else
			Canvas.DrawColor = RedTeamTint;
		Canvas.SetPos(MPBarX, MPBarY);
		Canvas.DrawTile(Material'InterfaceContent.Hud.SkinA', XL, 15.0 * Canvas.FontScaleY * 1.25, 836, 454, -386, 36);
		Canvas.DrawColor = WhiteColor;
		Canvas.SetPos(MPBarX, MPBarY);
		Canvas.DrawTile(Material'InterfaceContent.Hud.SkinA', XL, 16.0 * Canvas.FontScaleY * 1.25, 836, 415, -386, 38);
	
		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;
	
		Canvas.SetPos(MPBarX + 9.f * Canvas.FontScaleX, Canvas.ClipY * 0.75 - YL * 3.7); //used to be 3
		Canvas.DrawText(MPText);
	
		Canvas.TextSize(UsedMonsterPoints $ "/" $ TotalMonsterPoints, XLSmall, YLSmall);
		Canvas.SetPos(Canvas.ClipX - XL * 0.5 - XLSmall * 0.5, Canvas.ClipY * 0.75 - YL * 2.5 + 12.5 * Canvas.FontScaleY - YLSmall * 0.5); //used to be 3.75
		Canvas.DrawText(UsedMonsterPoints $ "/" $ TotalMonsterPoints);
	
		DMMAMS = DruidMonsterMasterArtifactMonsterSummon(ViewportOwner.Actor.Pawn.SelectedItem);
		if (DMMAMS != None)
		{
			//Draw Monster Master "Artifact" HUD info
	
			Canvas.FontScaleX = Canvas.default.FontScaleX * 0.80;
			Canvas.FontScaleY = Canvas.default.FontScaleY * 0.80;
	
			Canvas.SetPos(10, Canvas.ClipY * 0.75 - YL * 7.65);
			Canvas.DrawText(DMMAMS.FriendlyName);
			Canvas.SetPos(10, Canvas.ClipY * 0.75 - YL * 6.75);
			Canvas.DrawText(AdrenalineText $ DMMAMS.Adrenaline);
			Canvas.SetPos(10, Canvas.ClipY * 0.75 - YL * 5.85);
			Canvas.DrawText(MonsterPointsText $ DMMAMS.MonsterPoints);
		}
	
		Canvas.FontScaleX = Canvas.default.FontScaleX;
		Canvas.FontScaleY = Canvas.default.FontScaleY;
	}
	
	if (SpInv == None)
	{
		FindSpInv();
		if (SpInv != None)
		{
			if( SpInv.InteractionOwner != None )
				SpInv.InteractionOwner.SpInv = None;
			SpInv.InteractionOwner = Self;
		}
	}
	if (SpInv != None && SPInv.SelectedWeapon != None)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		Canvas.FontScaleX *= 0.85; //make it smaller
		Canvas.FontScaleY *= 0.85;
	
		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;

		Canvas.SetPos(XL+500, Canvas.ClipY * 0.87 - YL * 0.5);
		Canvas.DrawText("Specialized Weapon: " $ SpInv.SelectedWeapon.ItemName);
		
		Canvas.FontScaleX = Canvas.default.FontScaleX;
		Canvas.FontScaleY = Canvas.default.FontScaleY;
	}
	
	if (PInv == None)
	{
		FindPInv();
		if (PInv != None)
		{
			if( PInv.InteractionOwner != None )
				PInv.InteractionOwner.PInv = None;
			PInv.InteractionOwner = Self;
		}
	}
	if (PInv != None)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		Canvas.FontScaleX *= 0.90; //make it smaller
		Canvas.FontScaleY *= 0.90;
	
		Canvas.Style = 2;
		Canvas.DrawColor = GreenColor;

		Canvas.SetPos(XL+500, Canvas.ClipY * 0.87 - YL * 0.5);
		Canvas.DrawText("Plague Infections: " $ PInv.NumInfections);
		
		Canvas.FontScaleX = Canvas.default.FontScaleX;
		Canvas.FontScaleY = Canvas.default.FontScaleY;
	}
	
	if (GiveItemsInv != None && GiveItemsInv.LetterB)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		Canvas.FontScaleX *= 0.95; //make it smaller
		Canvas.FontScaleY *= 0.95;
	
		Canvas.Style = 2;
		Canvas.DrawColor = RedColor;

		pText = "B";
		Canvas.SetPos(10, Canvas.ClipY * 0.75 - YL * 25.0);
		Canvas.DrawText(pText);
		
		Canvas.FontScaleX = Canvas.default.FontScaleX;
		Canvas.FontScaleY = Canvas.default.FontScaleY;
	}
	if (GIveItemsInv != None && GiveItemsInv.LetterO)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		Canvas.FontScaleX *= 0.95; //make it smaller
		Canvas.FontScaleY *= 0.95;
	
		Canvas.Style = 2;
		Canvas.DrawColor = YellowColor;

		pText = "O";
		Canvas.SetPos(50, Canvas.ClipY * 0.75 - YL * 25.0);
		Canvas.DrawText(pText);
		
		Canvas.FontScaleX = Canvas.default.FontScaleX;
		Canvas.FontScaleY = Canvas.default.FontScaleY;
	}
	if (GIveItemsInv != None && GiveItemsInv.LetterN)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		Canvas.FontScaleX *= 0.95; //make it smaller
		Canvas.FontScaleY *= 0.95;
	
		Canvas.Style = 2;
		Canvas.DrawColor = GreenColor;

		pText = "N";
		Canvas.SetPos(90, Canvas.ClipY * 0.75 - YL * 25.0);
		Canvas.DrawText(pText);
		
		Canvas.FontScaleX = Canvas.default.FontScaleX;
		Canvas.FontScaleY = Canvas.default.FontScaleY;
	}
	if (GIveItemsInv != None && GiveItemsInv.LetterU)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		Canvas.FontScaleX *= 0.95; //make it smaller
		Canvas.FontScaleY *= 0.95;
	
		Canvas.Style = 2;
		Canvas.DrawColor = BlueColor;

		pText = "U";
		Canvas.SetPos(130, Canvas.ClipY * 0.75 - YL * 25.0);
		Canvas.DrawText(pText);
		
		Canvas.FontScaleX = Canvas.default.FontScaleX;
		Canvas.FontScaleY = Canvas.default.FontScaleY;
	}
	if (GIveItemsInv != None && GiveItemsInv.LetterS)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		Canvas.FontScaleX *= 0.95; //make it smaller
		Canvas.FontScaleY *= 0.95;
	
		Canvas.Style = 2;
		Canvas.DrawColor = PurpleColor;

		pText = "S";
		Canvas.SetPos(170, Canvas.ClipY * 0.75 - YL * 25.0);
		Canvas.DrawText(pText);
		
		Canvas.FontScaleX = Canvas.default.FontScaleX;
		Canvas.FontScaleY = Canvas.default.FontScaleY;
	}
	//Now draw the main Mission interface.
	//Check for mission inventories.
	if (MissionInv == None)
	{
		FindMissionInv();
		if (MissionInv != None)
		{
			if( MissionInv.InteractionOwner != None )
				MissionInv.InteractionOwner.MissionInv = None;
			MissionInv.InteractionOwner = Self;
		}
	}
	if (MMPI == None)
	{
		FindMMPI();
		if (MMPI != None)
		{
			if( MMPI.InteractionOwner != None )
				MMPI.InteractionOwner.MMPI = None;
			MMPI.InteractionOwner = Self;
		}
	}
	if (MissionInv != None)
	{
		XL = FMax(XL + 9.f * Canvas.FontScaleX, 135.f * Canvas.FontScaleX);

		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
		pText = "200";
		Canvas.TextSize(pText, XL, YL);
	
		Canvas.FontScaleX *= 0.90; //make it smaller
		Canvas.FontScaleY *= 0.90;
	
		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;

		pText = "Missions Completed: " $ MissionInv.NumMissionsCompleted;
		Canvas.SetPos(10, Canvas.ClipY * 0.75 - YL * 24.0);
		Canvas.DrawText(pText);

		//Now draw each individual mission's artifact, description, and name.
		if (MissionInv.MissionNameOne != "")
		{	
			Canvas.FontScaleX = Canvas.ClipX / 1024.f;
			Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
			pText = "200";
			Canvas.TextSize(pText, XL, YL);
					
			Canvas.FontScaleX *= 0.90; //make it smaller
			Canvas.FontScaleY *= 0.90;
	
			Canvas.Style = 2;
			Canvas.DrawColor = WhiteColor;
			Canvas.SetPos(10, Canvas.ClipY * 0.75 - YL * 23.0);
			Canvas.DrawText("1. " $ MissionInv.MissionNameOne $ " " $ MissionInv.MissionCountOne $ "/" $ MissionInv.MissionGoalOne);
		}
		if (MissionInv.MissionNameTwo != "")
		{
			Canvas.FontScaleX = Canvas.ClipX / 1024.f;
			Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
			pText = "200";
			Canvas.TextSize(pText, XL, YL);
					
			Canvas.FontScaleX *= 0.90; //make it smaller
			Canvas.FontScaleY *= 0.90;
	
			Canvas.Style = 2;
			Canvas.DrawColor = WhiteColor;
			Canvas.SetPos(10, Canvas.ClipY * 0.75 - YL * 22.0);
			Canvas.DrawText("2. " $ MissionInv.MissionNameTwo $ " " $ MissionInv.MissionCountTwo $ "/" $ MissionInv.MissionGoalTwo);
		}
		if (MissionInv.MissionNameThree != "")
		{
			Canvas.FontScaleX = Canvas.ClipX / 1024.f;
			Canvas.FontScaleY = Canvas.ClipY / 768.f;
	
			pText = "200";
			Canvas.TextSize(pText, XL, YL);
					
			Canvas.FontScaleX *= 0.90; //make it smaller
			Canvas.FontScaleY *= 0.90;
	
			Canvas.Style = 2;
			Canvas.DrawColor = WhiteColor;
			Canvas.SetPos(10, Canvas.ClipY * 0.75 - YL * 21.0);
			Canvas.DrawText("3. " $ MissionInv.MissionNameThree $ " " $ MissionInv.MissionCountThree $ "/" $ MissionInv.MissionGoalThree);
		}
		if (MMPI != None && !MMPI.Stopped)
		{
			XL = FMax(XL + 9.f * Canvas.FontScaleX, 135.f * Canvas.FontScaleX);
			
			Canvas.FontScaleX *= 0.90; //make it smaller
			Canvas.FontScaleY *= 0.90;
	
			Canvas.Style = 2;
			pText = "Team Mission:";
			Canvas.DrawColor = WhiteColor;
			Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 24.0);
			Canvas.DrawText(pText);
			
			Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 23.0);
			Canvas.DrawText(MMPI.MissionName);
			
			if (MMPI.PowerPartyActive)
			{
				Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 22.0);
				Canvas.DrawText(MMPI.MissionCount $ "/" $ MMPI.MissionGoal);
				
				Canvas.SetPos(Canvas.ClipX - XL - 75.f, Canvas.ClipY * 0.75 - YL * 21.0);
				Canvas.DrawText("Time: " $ MMPI.TimeRemaining);				
			}
			else
			{
				Canvas.Style = 2;
				Canvas.DrawColor = WhiteColor;
				Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 22.0);
				Canvas.DrawText(MMPI.MissionCount $ "/" $ MMPI.MissionGoal $ " Time: " $ MMPI.TimeRemaining);
			}
			if (MMPI.TarydiumKeepActive && MMPI.TC != None)
			{
				Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
				Canvas.DrawText("Tarydium HP: " $ MMPI.TC.Health);
			}
			if (MMPI.RingAndHoldActive)
			{
				if (MMPI.RRActive)
				{
					Canvas.DrawColor = RedColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
					Canvas.DrawText("Red Active");
				}
				if (MMPI.RBActive)
				{
					Canvas.DrawColor = BlueColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 20.0);
					Canvas.DrawText("Blue Active");
				}
				if (MMPI.RGActive)
				{
					Canvas.DrawColor = YellowColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 19.0);
					Canvas.DrawText("Gold Active");
				}
			}
			if (MMPI.MusicalWeaponsActive && MMPI.ActiveWeapon != None)
			{
				if (MMPI.ActiveWeapon == class'DEKWeapons999X.INAVRiL')
				{
					Canvas.DrawColor = WhiteColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
					Canvas.DrawText("AVRiL");
				}
				else if (MMPI.ActiveWeapon == class'XWeapons.BioRifle')
				{
					Canvas.DrawColor = GreenColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
					Canvas.DrawText("Bio Rifle");
				}
				else if (MMPI.ActiveWeapon == class'XWeapons.ShockRifle')
				{
					Canvas.DrawColor = PurpleColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
					Canvas.DrawText("Shock Rifle");
				}
				else if (MMPI.ActiveWeapon == class'UT2004RPG.RPGLinkGun')
				{
					Canvas.DrawColor = GreenColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
					Canvas.DrawText("Link Gun");
				}
				else if (MMPI.ActiveWeapon == class'XWeapons.Minigun')
				{
					Canvas.DrawColor = WhiteColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
					Canvas.DrawText("Minigun");
				}
				else if (MMPI.ActiveWeapon == class'XWeapons.FlakCannon')
				{
					Canvas.DrawColor = OrangeColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
					Canvas.DrawText("Flak Cannon");
				}
				else if (MMPI.ActiveWeapon == class'XWeapons.FlakCannon' || ClassIsChildOf(MMPI.ActiveWeapon, class'XWeapons.FlakCannon'))	//for PumpkinCannon
				{
					Canvas.DrawColor = OrangeColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
					Canvas.DrawText("Flak Cannon");
				}
				else if (MMPI.ActiveWeapon == class'XWeapons.RocketLauncher')
				{
					Canvas.DrawColor = RedColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
					Canvas.DrawText("Rocket Launcher");
				}
				else if (MMPI.ActiveWeapon == class'XWeapons.SniperRifle')
				{
					Canvas.DrawColor = BlueColor;
					Canvas.SetPos(Canvas.ClipX - XL - 70.f, Canvas.ClipY * 0.75 - YL * 21.0);
					Canvas.DrawText("Lightning Gun");
				}
			}
		}
	}
	AM = ArtifactMissionBETA(ViewportOwner.Actor.Pawn.SelectedItem);
	if (AM != None)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;

		pText = "200";
		Canvas.TextSize(pText, XL, YL);

		Canvas.FontScaleX *= 0.8; //make it smaller
		Canvas.FontScaleY *= 0.8;

		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;

		Canvas.SetPos(4, Canvas.ClipY * 0.75 - YL * 1.3);
		Canvas.DrawText(AM.Description);
		
		Canvas.FontScaleX *= 0.9; //make it smaller
		Canvas.FontScaleY *= 0.9;

		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;	
		
		Canvas.SetPos(XL+11, Canvas.ClipY * 0.75 - YL * 3.0);
		if (StatsInv.Data.Level <= AM.LowLevelThreshold)
			Canvas.DrawText(RewardText $ AM.XPReward*AM.LowLevelMultiplier $ "XP");
		else if (StatsInv.Data.Level <= AM.MediumLevelThreshold)
			Canvas.DrawText(RewardText $ AM.XPReward*AM.MediumLevelMultiplier $ "XP");
		else
			Canvas.DrawText(RewardText $ AM.XPReward $ "XP");
	}
	
	AMT = ArtifactMissionTeam(ViewportOwner.Actor.Pawn.SelectedItem);
	if (AMT != None)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;

		pText = "200";
		Canvas.TextSize(pText, XL, YL);

		Canvas.FontScaleX *= 0.8; //make it smaller
		Canvas.FontScaleY *= 0.8;

		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;

		Canvas.SetPos(4, Canvas.ClipY * 0.75 - YL * 1.3);
		Canvas.DrawText(AMT.Description);
		
		Canvas.FontScaleX *= 0.9; //make it smaller
		Canvas.FontScaleY *= 0.9;

		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;	
		
		Canvas.SetPos(XL+11, Canvas.ClipY * 0.75 - YL * 3.0);
	}
	
	AP = ArtifactPaladin(ViewportOwner.Actor.Pawn.SelectedItem);
	if (AP != None)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;

		pText = "200";
		Canvas.TextSize(pText, XL, YL);

		Canvas.FontScaleX *= 0.8; //make it smaller
		Canvas.FontScaleY *= 0.8;

		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;

		Canvas.SetPos(4, Canvas.ClipY * 0.75 - YL * 1.3);
		Canvas.DrawText("Protecting: " $ AP.TargetPlayer.PlayerReplicationInfo.PlayerName);		
	}
	AGH = ArtifactGuardianHeal(ViewportOwner.Actor.Pawn.SelectedItem);
	if (AGH != None)
	{
		Canvas.FontScaleX = Canvas.ClipX / 1024.f;
		Canvas.FontScaleY = Canvas.ClipY / 768.f;

		pText = "200";
		Canvas.TextSize(pText, XL, YL);

		Canvas.FontScaleX *= 0.8; //make it smaller
		Canvas.FontScaleY *= 0.8;

		Canvas.Style = 2;
		Canvas.DrawColor = WhiteColor;

		Canvas.SetPos(4, Canvas.ClipY * 0.75 - YL * 1.3);
		Canvas.DrawText("Guarding: " $ AGH.TargetPlayer.PlayerReplicationInfo.PlayerName);		
	}
	super.PostRender(Canvas);
}

defaultproperties
{
     ArtifactKeyConfigs(0)=(Alias="SelectTriple",ArtifactClass=Class'DEKRPG999X.DruidArtifactTripleDamage')
     HealthBarMaterial=Texture'Engine.WhiteSquareTexture'
     RedColor=(B=159,G=159,R=255,A=159)
     OrangeColor=(B=159,G=223,R=255,A=255)
     YellowColor=(B=159,G=253,R=255,A=255)
     GreenColor=(B=159,G=255,R=159,A=159)
     BlueColor=(B=240,G=255,R=159,A=255)
     PurpleColor=(B=255,G=159,R=199,A=255)
     PointsText="Points:"
     MPBarColor=(B=128,G=255,R=128,A=255)
     MPText="Monster Points:"
     AdrenalineText="Adrenaline:"
     MonsterPointsText="Monster Points:"
     RewardText="Reward:"
     EXPBarColor=(B=255,G=128,R=227)
     RedTeamTint=(B=110,G=130,R=0,A=25)
     BlueTeamTint=(B=110,G=130,R=0,A=25)
     StatsMenuText="L key for stats"
     ArtifactText=""
     bRequiresTick=True
}
