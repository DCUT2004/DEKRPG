class CurrentWeaponsPlusOne extends EnhancedRPGArtifact;

var config int XPforUse;
var config int ModifierPlusValue;
var config int LimitOverMaximum;

var RPGRules Rules;

function BotConsider()
{
    Local RPGWeapon Weapon;

	if (Instigator.Controller.Adrenaline < getCost())
		return;

	Weapon = RPGWeapon(Instigator.Weapon);
	if(Weapon == None || Weapon.Modifier > Weapon.MaxModifier || Weapon.MaxModifier <= 0 || Weapon.class == class'RW_EngineerLink' || Weapon.class == class'RW_Superhealer')	// save it for a different weapon
		return;

	if ( !bActive && NoArtifactsActive() && FRand() < 0.7 )
		Activate();
}

function PostBeginPlay()
{
	super.PostBeginPlay();
	disable('Tick');
    
	CheckRPGRules();
}

function CheckRPGRules()
{
	Local GameRules G;

	if (Level.Game == None)
		return;		//try again later

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if(Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. EXP will not be properly awarded");
}

function Activate()
{
	Local Vehicle V;
	Local Controller C;
	Local Controller NextC;
    Local RPGWeapon Weapon;

	if (Instigator != None && Instigator.Controller != None)
	{
		if(Instigator.Controller.Adrenaline < getCost())
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, getCost(), None, None, Class);
			bActive = false;
			GotoState('');
			return;
		}
		
		V = Vehicle(Instigator);
		if (V != None )
		{
			Instigator.ReceiveLocalizedMessage(MessageClass, 3000, None, None, Class);
			bActive = false;
			GotoState('');
			return;	// can't use in a vehicle
		}

        // set all payer weapons plus one if possible
    	C = Level.ControllerList;
    	while (C != None)
    	{
            // loop round finding all players on same team
            NextC = C.NextController;
            if ( C.Pawn != None && C.Pawn.Health > 0 && C.SameTeamAs(Instigator.Controller)
                 && Vehicle(C.Pawn) == None && RedeemerWarhead(C.Pawn) == None)
            {
                if(PhantomGhostInv(C.Pawn.FindInventoryType(class'PhantomGhostInv')) == None && PhantomDeathGhostInv(C.Pawn.FindInventoryType(class'PhantomDeathGhostInv')) == None)
                {
                    Weapon = RPGWeapon(C.Pawn.Weapon);
                    if (Weapon != None)
                    {
                        if (((Weapon.Modifier + ModifierPlusValue == 0) && !Weapon.bCanHaveZeroModifier) 
                            || Weapon.MaxModifier == 0       
                            || Weapon.class == class'RW_EngineerLink' || Weapon.class == class'RW_Superhealer'
                            || Weapon.Modifier + ModifierPlusValue > Weapon.MaxModifier + LimitOverMaximum)
                        {
                             // do nothing. Cannot update this weapon
                            Log("***** PlusOne weapon" @ Weapon @ "could not be changed" @ "for" @C.Pawn.PlayerReplicationInfo.PlayerName);
                        }
                    	else
                    	{
                            Log("***** PlusOne increasing" @ Weapon @ "from" @ Weapon.Modifier @ "to be +1 for" @C.Pawn.PlayerReplicationInfo.PlayerName);
                            Weapon.Modifier += ModifierPlusValue;
                            Weapon.ConstructItemName();
                            if (DEKRPGWeapon(Weapon) != None)
                                DEKRPGWeapon(Weapon).DoDelayedIdentify();
                            else
                                Weapon.bIdentified = false;
                            Log("***** Weapon is now" @ Weapon @ "with modifier" @ Weapon.Modifier);
                            PlayerController(C).ReceiveLocalizedMessage(class'PlusOneConditionMessage', 0, Instigator.PlayerReplicationInfo);
                    	}
                    }
                }	
            }
            C = NextC;
    	}
        
		// take off adrenaline, and add xp
		Instigator.Controller.Adrenaline -= AdrenalineRequired;
		if (Instigator.Controller.Adrenaline < 0)
			Instigator.Controller.Adrenaline = 0;

		// ok, lets see if the initiator gets any xp
		if ((XPforUse > 0) && (Rules != None))
		{
			Rules.ShareExperience(RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv')), XPforUse);
		}
	}
	else
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
	}
    
	bActive = false;
	GotoState('');
	return;
}

exec function TossArtifact()
{
	//do nothing. This artifact cant be thrown
}

function DropFrom(vector StartLocation)
{
	if (bActive)
		GotoState('');
	bActive = false;

	Destroy();
	Instigator.NextItem();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 2000)
		return "Unable to modify magic weapon";
	if (Switch == 3000)
		return "Cannot use this artifact inside a vehicle";
	else
		return switch @ "Adrenaline is required to increase weapon modifiers";
}

function int getCost()
{
	return AdrenalineRequired;
}

defaultproperties
{
     CostPerSec=1
     AdrenalineRequired=250
     XPforUse=20
     ModifierPlusValue=1
     LimitOverMaximum=1
     MinActivationTime=0.000001
     IconMaterial=Combiner'XGameTextures.SuperPickups.DOMPabRc'
     ItemName="Current Weapons Plus One"
}
