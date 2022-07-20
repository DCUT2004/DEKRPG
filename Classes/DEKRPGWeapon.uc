//DEKRPGweapons based on RPGWeapons, but allows more flexibility in Power types
class DEKRPGWeapon extends RPGWeapon
	DependsOn(RPGStatsInv)
	config(UT2004RPG)
	HideDropDown
	CacheExempt;

var config int MaxNumPowers;
var config int MinNumPowers;
var config float ChanceZeroPower;
var config float ChanceOnePower;
var config float ChanceTwoPower;
var config float ChanceMultiplePower;
var config float PerCentNormalWeapons;

var config int MaxPowersWeaponsMasters;
var config int MaxPowersEngineers;
var config int MaxPowersAdrenalineMasters;
var config int MaxPowersMonsterMasters;
var config int MaxPowersClassicRPG;
var config int MaxPowersGeneral;
var config int MaxPowersNecromancer;

var config int MaxNumPowersDroppable;
var config int MaxNumPowersClonable;
var config int ModifierLossPerPowerup;

var config float DamagePercent;
var config float MinDamageFraction;

var config bool AllowWeaponSwitch;

var config int AdjustableMinModifier;
var config int AdjustableMaxModifier;

struct AddonChance
{
	var class<AddonPowerType> PowerType;
	var int GenerateChance;
	var int LuckChance;
};
var config array<AddonChance> AvailableAddonPowerTypes;	// complete list of all types available;

const cMaxPowerTypes=10;
var array<AddonPowerType > CurrentPowerTypes[cMaxPowerTypes];	// types added to this weapon
var int NumPowerTypes;						// number of Power types in CurrentPowerTypes

var RPGRules Rules;
var int CurMaxPowers;
var String sBaseName;
var String sMyItemName;
var bool needsIdentify;
var bool bSetPowerTypes;
var float EXPMultiplier;
var int MaxHealth;
var bool bModifierSet;
var ArtifactMakeSuperHealer AMSH; //set on construction. Used to obtain health and exp bonus numbers.

replication
{
	reliable if (Role == ROLE_Authority)
		CurrentPowerTypes, bSetPowerTypes, sBaseName, sMyItemName, CurMaxPowers, NumPowerTypes;
	reliable if (Role < ROLE_Authority)
		AddPowerType;
}

// *** startup functions

function PreBeginPlay()
{
	local GameRules G;
	Local HealableDamageGameRules SG;
	super.PreBeginPlay();

	MaxHealth = class'RW_Healer'.default.MaxHealth;
	EXPMultiplier = class'RW_Healer'.default.EXPMultiplier;

	if (MaxNumPowers > cMaxPowerTypes)
		MaxNumPowers = cMaxPowerTypes;	// Dynamic arrays will not replicate. Arbitary limit imposed.
						// must be same size as array definition

	// now set the min and max
	MinModifier = AdjustableMinModifier;
	MaxModifier = AdjustableMaxModifier;

	if (Level.Game == None)
		return;

	if ( Level.Game.GameRulesModifiers == None )
	{
		SG = Level.Game.Spawn(class'HealableDamageGameRules');
		if(SG == None)
			log("Warning: Unable to spawn HealableDamageGameRules for Druids RW_Healer. Healing for EXP will not occur.");
		else
			Level.Game.GameRulesModifiers = SG;
	}
	else
	{
		for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
		{
			if(G.isA('HealableDamageGameRules'))
			{
				SG = HealableDamageGameRules(G);
				break;
			}
			if(G.NextGameRules == None)
			{
				SG = Level.Game.Spawn(class'HealableDamageGameRules');
				if(SG == None)
				{
					log("Warning: Unable to spawn HealableDamageGameRules for Druids RW_Healer. Healing for EXP will not occur.");
					return; //try again next time?
				}

				//this will also add it after UT2004RPG, which will be necessarry.
				Level.Game.GameRulesModifiers.AddGameRules(SG);
				break;
			}
		}
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	setupRules();
}

function setupRules()
{
	Local GameRules G;

	if (Rules != None)
		return;
	
	if ( Level.Game == None || Level.Game.GameRulesModifiers == None )
	{
		log("Unable to find RPG Rules. Will retry");
		return;
	}

	for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
	{
		if(G.isA('RPGRules'))
		{
			Rules = RPGRules(G);
			break;
		}
	}

	if (Rules == None)
		Log("WARNING: Unable to find RPGRules in GameRules. Will retry later.");
}

// *** timer functions

simulated function Timer()
{
	super.Timer();
	if (needsIdentify )
	{
		needsIdentify=false;
		setTimer(0, false);
		Identify();
	}
}


// *** Functions for finding out information about the player

function RPGStatsInv GetStatsInvFor(Controller C, optional bool bMustBeOwner)
{
	local Inventory Inv;

	for (Inv = C.Inventory; Inv != None; Inv = Inv.Inventory)
		if ( Inv.IsA('RPGStatsInv') && ( !bMustBeOwner || Inv.Owner == C || Inv.Owner == C.Pawn
						   || (Vehicle(C.Pawn) != None && Inv.Owner == Vehicle(C.Pawn).Driver) ) )
			return RPGStatsInv(Inv);

	//fallback - shouldn't happen
	if (C.Pawn != None)
	{
		Inv = C.Pawn.FindInventoryType(class'RPGStatsInv');
		if ( Inv != None && ( !bMustBeOwner || Inv.Owner == C || Inv.Owner == C.Pawn
				      || (Vehicle(C.Pawn) != None && Inv.Owner == Vehicle(C.Pawn).Driver) ) )
			return RPGStatsInv(Inv);
	}

	return None;
}

function bool HasThisItem(RPGPlayerDataObject Data, class DesiredClass)
{
	local int x;

	for (x = 0; x < Data.Abilities.length ; x++)
		if (Data.Abilities[x] == DesiredClass)
			return true;

	return false;
}

function bool IsSameTeam(Pawn P)
{
	// returns true for friendly monster or another player/bot on same team. 
	// returns false for self or enemy or own pet

	if (Instigator == None || P == None)
		return false;

	if ( P == Instigator)
		return false;		// self isnt same team

	if (Instigator.GetTeam() == None)
		return false;		// cant really check

	if (P.Controller.IsA('FriendlyMonsterController') && FriendlyMonsterController(P.Controller).Master != Instigator.Controller && P.GetTeam() == Instigator.GetTeam())
		return true;		// pet, but not mine

	if (P.GetTeam() == Instigator.GetTeam())
		return true;		// same team

	return false;
}

// *** functions regarding doing the initial generation of the weapon

function int MaxPowersForThisPlayer(Pawn Other)
{
	local RPGPlayerDataObject Data;
	local RPGStatsInv StatsInv;		// needed because HolderStatsInv not set yet
	local int iLocalMaxPowers;
	local bool bGotClass;

	iLocalMaxPowers = MaxNumPowers;
	if (iLocalMaxPowers <= 0)
		iLocalMaxPowers = cMaxPowerTypes;	// limited to max we can have at one time

	bGotClass = false;

	if (Other != None && PlayerController(Other.Controller) != None)
	{
    	StatsInv = GetStatsInvFor(Other.Controller);
    	if (StatsInv != None)
    	{
    		Data = StatsInv.DataObject;
            
            if (HasThisItem(Data, class'ClassWeaponsMaster'))
        	{
        		bGotClass = true;
                if (MaxPowersWeaponsMasters<=iLocalMaxPowers)
                    iLocalMaxPowers = MaxPowersWeaponsMasters;
        	}
        	else if (HasThisItem(Data, class'ClassEngineer'))
        	{
        		bGotClass = true;
                if (MaxPowersEngineers<=iLocalMaxPowers)
                    iLocalMaxPowers = MaxPowersEngineers;
        	}
        	else if (HasThisItem(Data, class'ClassAdrenalineMaster'))
        	{
        		bGotClass = true;
                if (MaxPowersAdrenalineMasters<=iLocalMaxPowers)
                    iLocalMaxPowers = MaxPowersAdrenalineMasters;
        	}
        	else if (HasThisItem(Data, class'ClassMonsterMaster'))
        	{
        		bGotClass = true;
                if (MaxPowersMonsterMasters<=iLocalMaxPowers)
                    iLocalMaxPowers = MaxPowersMonsterMasters;
        	}
        	else if (HasThisItem(Data, class'ClassGeneral'))
        	{
        		bGotClass = true;
                if (MaxPowersGeneral<=iLocalMaxPowers)
                    iLocalMaxPowers = MaxPowersGeneral;
        	}
        	else if (HasThisItem(Data, class'ClassClassicRPG'))
        	{
        		bGotClass = true;
                if (MaxPowersClassicRPG<=iLocalMaxPowers)
                    iLocalMaxPowers = MaxPowersClassicRPG;
        	}
        	else if (HasThisItem(Data, class'ClassNecromancer'))
        	{
        		bGotClass = true;
                if (MaxPowersNecromancer<=iLocalMaxPowers)
                    iLocalMaxPowers = MaxPowersNecromancer;
        	}
        }
    }
    
	if (!bGotClass)
	{	// no class, so set to min
        iLocalMaxPowers = min(MaxPowersWeaponsMasters,MaxPowersEngineers);
        iLocalMaxPowers = min(iLocalMaxPowers,MaxPowersAdrenalineMasters);
        iLocalMaxPowers = min(iLocalMaxPowers,MaxPowersMonsterMasters);
        iLocalMaxPowers = min(iLocalMaxPowers,MaxPowersClassicRPG);
        iLocalMaxPowers = min(iLocalMaxPowers,MaxPowersGeneral);
        iLocalMaxPowers = min(iLocalMaxPowers,MaxPowersNecromancer);
 		//Log("****DEKRPGWeapon MaxPowers - no class, max now:"$iLocalMaxPowers);
	}
	if (iLocalMaxPowers <= 0)
		iLocalMaxPowers = cMaxPowerTypes;	// check again, in case a class has a negative value configured.

	return iLocalMaxPowers;
}

function AddInitialPowerTypes(RPGWeapon ForcedWeapon)
{
	local int iSumChance;
	local int iReqdPowers;
	local int iRandValue;
	local int iCount;
	local int iLocalMaxPowers;
	local class<AddonPowerType> newType;
	local int x;
	local int q;
	local bool ok;
	local AddonPowerType NewPowerup;

	if (Instigator != None)
		iLocalMaxPowers = MaxPowersForThisPlayer(Instigator);
	else
		iLocalMaxPowers = MaxPowersForThisPlayer(Pawn(Owner));
	NumPowerTypes = 0;
	bIdentified = false;
	if (sBaseName == "")
	{
		if (ForcedWeapon == None)
		{
			sBaseName = ItemName;
		}
		else
		{
			if (DEKRPGWeapon(ForcedWeapon) != None)
			{
				bSetPowerTypes = DEKRPGWeapon(ForcedWeapon).bSetPowerTypes;
				sBaseName = DEKRPGWeapon(ForcedWeapon).sBaseName;
				sMyItemName = DEKRPGWeapon(ForcedWeapon).sMyItemName;
				NumPowerTypes = DEKRPGWeapon(ForcedWeapon).NumPowerTypes;
				for (x=0; x<NumPowerTypes; x++)
				{
					NewPowerup = spawn(DEKRPGWeapon(ForcedWeapon).CurrentPowerTypes[x].class,instigator);
					NewPowerup.AttachToWeapon(self);
					CurrentPowerTypes[x] = NewPowerup;
				}
				for (x=NumPowerTypes; X<MaxNumPowers; x++)
					CurrentPowerTypes[x] = None;

			} 
			else
				sBaseName = ForcedWeapon.ItemName;
		}
	}

	CurMaxPowers = iLocalMaxPowers;	// for addonartifacts to check against

	// may need to reset weapon here!

	if (!bSetPowerTypes)
	{
	    //now set what type of weapon it is
	    AIRatingBonus=0.040000;
	    bModifierSet = false;

	    if (Rand(100) < PerCentNormalWeapons)
	    {
		  // tough luck, its a normal weapon
		  modifier = 0;
		  bModifierSet = true;
		  bSetPowerTypes = true;
		  return;
	    }

	    // ok, lets see how many Powers we should give it
	    iSumChance = ChanceZeroPower;
	    if (iLocalMaxPowers >= 1)
		  iSumChance += ChanceOnePower;
	    if (iLocalMaxPowers >= 2)
		  iSumChance += ChanceTwoPower;
	    if (iLocalMaxPowers >= 3)
		  iSumChance += ChanceMultiplePower;
	    iReqdPowers = 0;
	    iRandValue = Rand(iSumChance);
	    if (iRandValue < ChanceZeroPower)
		  iReqdPowers = 0;
	    else if (iRandValue < (ChanceZeroPower+ChanceOnePower))
		  iReqdPowers = 1;
	    else if (iRandValue < (ChanceZeroPower+ChanceOnePower+ChanceTwoPower))
		  iReqdPowers = 2;
	    else 
	    {
  		    // multiple, but how many?
  		    iRandValue = Rand(iLocalMaxPowers-2);
  		    iReqdPowers = iRandValue + 3;
	    }

	    iSumChance = 0;
	    for (q = 0; q < AvailableAddonPowerTypes.Length ; q++) 
		  iSumChance += AvailableAddonPowerTypes[q].GenerateChance; 

	    iCount = 0;
	    while ((NumPowerTypes < iReqdPowers) && (iCount<200))
	    {
      		iCount++;
  		    newType = none;
  
  		    q = 0;
  		    while (q < AvailableAddonPowerTypes.Length && newType == none)
  		    {
  			   if (Rand(iSumChance) < AvailableAddonPowerTypes[q].GenerateChance)
  			   {
  				  // lets try this one
  				  newType = AvailableAddonPowerTypes[q].PowerType;
  				  ok = true;
  				  for (x = 0; x < NumPowerTypes ; x++)
  				  {
  					if (CurrentPowerTypes[x] != None)
  					{
  						if (CurrentPowerTypes[x].CanCoexist(newType) == false)
  							ok = false;
  						if (!CurrentPowerTypes[x].static.AllowedFor(self.ModifiedWeapon))
  							ok = false;
  					}
  				  }
  				  if (ok)
  					AddPowerType(newType);	// increments NumPowerTypes
  				  else
  					newType = none;
  			   }
  			   q += 1;
  		    }
	    }
	    bSetPowerTypes = true;
	}

}

function Generate(RPGWeapon ForcedWeapon)
{
	local int Count;
	local bool ok;
	local int x;

	Super.Generate(ForcedWeapon);
	if (!bSetPowerTypes)
	{
		AddInitialPowerTypes(ForcedWeapon);
	}
	if ((ForcedWeapon == None) && !bModifierSet)
	{
		do
		{
			Count++;
			Modifier = Rand(MaxModifier+1-MinModifier) + MinModifier;
			ok = true;
			for (x = 0; x < NumPowerTypes ; x++)
				if (CurrentPowerTypes[x] != None)
					if (CurrentPowerTypes[x].Generateok(ForcedWeapon, Modifier) == false)
						ok = false;
		} until (ok || Count > 200)
		if (ok == false)
			modifier = 0;
		else
			bModifierSet = true;
	}
	bSetPowerTypes = true;
    
    SetShaderBasedOnAddons();
}

function SetShaderBasedOnAddons()
{
    local AddonPowerType firstPowerType;
    local bool singleType;
	local int x;

	if (NumPowerTypes == 1)
	{
		CurrentPowerTypes[0].SetShader();
	}
	else if (NumPowerTypes > 1)
    {
        // see if they are all the same
        singleType = true;
        firstPowerType = CurrentPowerTypes[0];
 		for (x = 1; x < NumPowerTypes ; x++)
			if (CurrentPowerTypes[x] != firstPowerType)
                singleType = false;
       
        if (singleType)
            CurrentPowerTypes[0].SetShader();
        else
        {
            if (ModifiedWeapon != None)
                SetOverlayMaterial(FinalBlend'EpicParticles.Shaders.IonFallFinal', 1000000, true);
            ModifierOverlay = FinalBlend'EpicParticles.Shaders.IonFallFinal';
        }
    }
}

function SetModifiedWeapon(Weapon w, bool bIdentify)
{
	if (w == None)
	{
		Destroy();
		return;
	}
	ModifiedWeapon = w;
	SetWeaponInfo();
	if (bIdentify)
	{
		Instigator = None; //don't want to send an identify message to anyone here
		Identify();
	}
}

static function bool AllowedFor(class<Weapon> Weapon, Pawn Other)
{
	return true;
}

// *** identification functions

simulated function DoDelayedIdentify()
{
	if (!needsIdentify)
	{
		bIdentified = false;		// cause regeneration of ItemName
		needsIdentify = true;
		setTimer(0.7, true);
	}
}

simulated function ConstructItemName()
{
	local int x;

	if (Role == Role_Authority)
	{
		if (sBaseName == "")
		{
			if (ModifiedWeapon != None)
				sBaseName = ModifiedWeapon.ItemName;
			else
				sBaseName = ItemName;
		}
		if (NumPowerTypes > 0)
		{
			sMyItemName = sBaseName @ "of";
			for (x = 0; x < NumPowerTypes ; x++)
				if (CurrentPowerTypes[x] != None)
				{
					if (Modifier<0)
						sMyItemName = sMyItemName @ CurrentPowerTypes[x].NegName;
					else if (Modifier == 0)
						sMyItemName = sMyItemName @ CurrentPowerTypes[x].ZeroName;
					else
						sMyItemName = sMyItemName @ CurrentPowerTypes[x].PosName;
				}
		}
		else
			sMyItemName = sBaseName;

	}

	if (sMyItemName != "")
	{
		if (Modifier>0)
			ItemName = sMyItemName@"+"$Modifier;
		else if (Modifier == 0)
			ItemName = sMyItemName;
		else
			ItemName = sMyItemName@Modifier;
		if (NumPowerTypes > MaxNumPowersDroppable)
			ItemName = ItemName @ "**";
		else if (NumPowerTypes > MaxNumPowersClonable)
			ItemName = ItemName @ "*";
	}

	if (Role == Role_Authority)
	{
		if (ModifiedWeapon != None)
		{
			if (sMyItemName != "")
				ModifiedWeapon.ItemName = ItemName;
		}
	}

}

function int GetModifier()
{
	local int TempModifier;
	TempModifier = Modifier - (ModifierLossPerPowerup * NumPowerTypes);
	if (TempModifier <= 0 && Modifier > 0)
		TempModifier = 1;
	return TempModifier;
}

// *** now the checks on what Power types are allowed where

// return true to allow player to have w
function bool AllowRPGWeapon(RPGWeapon w)
{
	return Super.AllowRPGWeapon(w);
}

// check to see if can add the new Power type to the existing weapon
function bool CanAddPowerType(class<AddonPowerType> NewType)
{
	local int x;

	// the check for the specific Power type on this weapon will already have been done in the calling class
	// as will the check for number of Power types

	// check the other Power types already on the weapon
	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			if (CurrentPowerTypes[x].CanCoexist(NewType) == false)
				return false;
	return true;
}

simulated function AddPowerType(class<AddonPowerType> NewClass)
{
	// add the Power type to the weapon
	local AddonPowerType NewType;

	NewType = spawn(NewClass,instigator);
	NewType.AttachToWeapon(self);
	CurrentPowerTypes[NumPowerTypes] = NewType;
	NumPowerTypes++;  
    
    SetShaderBasedOnAddons();
                
	bIdentified = false;		// cause regeneration of ItemName
}

// *** Now the functions for doing damage etc. To be passed on to any attached Power types
function bool CheckCorrectDamage(Weapon W, class<DamageType> DamageType)
{
	local int x;
	local class<ProjectileFire> ProjFire;
	local class<InstantFire> InstFire;

	if (!ClassIsChildOf(DamageType, class'WeaponDamageType'))
		return false;		// cannot be damage done by this weapon

	for (x = 0; x < NUM_FIRE_MODES; x++)
	{
		if (ClassIsChildOf(W.default.FireModeClass[x], class'ProjectileFire'))
		{
			ProjFire = class<ProjectileFire>(W.default.FireModeClass[x]);
			if (ProjFire != None && ProjFire.default.ProjectileClass != none && DamageType == ProjFire.default.ProjectileClass.default.MyDamageType)
				return true;
		}
		else
		{
			if (ClassIsChildOf(W.default.FireModeClass[x], class'InstantFire'))
			{
				InstFire = class<InstantFire>(W.default.FireModeClass[x]);
				if (InstFire != None && DamageType == InstFire.default.DamageType)
					return true;
			}
		}
	}
	
	// ok, time for the specials. Why can't things ever be simple?
	if ( ClassIsChildOf(W.Class,class'RocketLauncher') && ClassIsChildOf(DamageType,class'DamTypeRocketHoming'))
		return true;
	else
	if ( ClassIsChildOf(W.Class,class'Painter') && ClassIsChildOf(DamageType,class'DamTypeIonBlast'))
		return true;
	else
	if ( ClassIsChildOf(W.Class,class'ShockRifle') && ClassIsChildOf(DamageType,class'DamTypeShockCombo'))
		return true;
	else
	if ( ClassIsChildOf(W.Class,class'SniperRifle') && ClassIsChildOf(DamageType,class'DamTypeSniperHeadShot'))
		return true;
	else
	if ( ClassIsChildOf(W.Class,class'ShieldGun') && ClassIsChildOf(DamageType,class'DamTypeShieldImpact'))
		return true;
	else
	if ( ClassIsChildOf(W.Class,class'LinkGun') && ClassIsChildOf(DamageType,class'DamTypeLinkShaft'))
		return true;
	
	return false;	// wrong damage type
}

//adjust amount of damage done to victim
function NewAdjustTargetDamage(out int Damage, int OriginalDamage, Actor Victim, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
	local int x;

	// ok, let's see if they fired one weapon and switched to another
	if (!AllowWeaponSwitch)
	{
		if (!CheckCorrectDamage(ModifiedWeapon, DamageType))
		{
			// log("*****DEKRPGWeapon: Weapon changed, weapon"@sMyItemName@"does not support damagetype"@DamageType);
			return;
		}
	}

	// Ok, so now add on any extra damage we do
	if (Damage > 0)
	{
		Damage = Max(1, Damage * (1.0 + ((DamagePercent/100.0) * GetModifier())));
		Momentum = Momentum * (1.0 + ((DamagePercent/100.0) * GetModifier()));
	}

	// loop through all attached Power types and adjust the damage based on bonuses (+3% etc)
	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].AddDamageBonus(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);

	// now check for minimum damage being done against monsters with high DR
	if ((Damage > 0) && (Damage < (OriginalDamage * MinDamageFraction)))
	{
		Damage = OriginalDamage * MinDamageFraction;
	}

	// loop through all attached Power types and adjust the damage based on Power types (piercing healing)
	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].AdjustDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);

	// loop through all attached Power types and action any Power effects
	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].DoPowerEffect(Damage, Victim, HitLocation, Momentum, DamageType);

	super.NewAdjustTargetDamage(Damage, OriginalDamage, Victim, HitLocation, Momentum, DamageType);
}

function AdjustPlayerDamage( out int Damage, Pawn InstigatedBy, Vector HitLocation,
                             out Vector Momentum, class<DamageType> DamageType)
{
	local int x;

	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].AdjustPlayerDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

	Super.AdjustPlayerDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].PlayerTakenDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

}

// *** Weapon functions

function float GetAIRating()
{
	local float tempAIRating;
	local int x;

	tempAIRating = ModifiedWeapon.GetAIRating() + (Modifier * 0.01);

	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].GetAIRating(tempAIRating);

	return tempAIRating;
}

function GiveAmmo(int m, WeaponPickup WP, bool bJustSpawned)
{
	local int x;

	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].GiveAmmo(m, WP, bJustSpawned);

	Super.GiveAmmo(m, WP, bJustSpawned);

}

simulated event WeaponTick(float dt)
{
	local int x;

	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].WeaponTick(dt);

	Super.WeaponTick(dt);
}

simulated function bool StartFire(int Mode)
{
	local int x;

	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].StartFire(Mode);

	return Super.StartFire(Mode);
}

simulated function StartBerserk()
{
	local int x;

	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].StartBerserk();

	Super.StartBerserk();
}

simulated function StopBerserk()
{
	local int x;

	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			CurrentPowerTypes[x].StopBerserk();

	Super.StopBerserk();
}

function bool CheckReflect(Vector HitLocation, out Vector RefNormal, int Damage)
{
	local int x;

	//make the call first in case the weapon actually does the reflect on it's own.
	if(super.CheckReflect(HitLocation, RefNormal, Damage))
		return true;

	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			if (CurrentPowerTypes[x].CheckReflect(HitLocation, RefNormal, Damage))
				return true;
	return false;
}

simulated function bool CanThrow()
{
	local int x;

	if (Modifier < 0 || Modifier > MaxModifier)
		return false; //can't throw cursed weapons or plus oned

	if (NumPowerTypes > MaxNumPowersDroppable)
		return false;

	// loop through all attached Power types and check
	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
			if (CurrentPowerTypes[x].CanThrow() == false)
				return false;

	return ModifiedWeapon.CanThrow();
}

function DropFrom(vector StartLocation)
{
	local int x;
	local bool bCanShare;

	super.DropFrom(StartLocation);

	// loop through all attached Power types and check if can share weapon
	bCanShare = True;

	if (NumPowerTypes > MaxNumPowersClonable)
		bCanShare = false;

	for (x = 0; x < NumPowerTypes ; x++)
		if (CurrentPowerTypes[x] != None)
 			if (CurrentPowerTypes[x].CanShare() == false)
				bCanShare = false;

	if (bCanShare)
		return;

	// weapon cannot be shared, so remove from OldWeapons
	if(Instigator == None)
		return;

	if (HolderStatsInv == None)
	{
		HolderStatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
		if (HolderStatsInv == None)
			return;
	}

	for (x = 0; x < HolderStatsInv.OldRPGWeapons.length; x++)
		if(self == HolderStatsInv.OldRPGWeapons[x].Weapon)
			break;

	if (x == HolderStatsInv.OldRPGWeapons.length)
		return;
	
	HolderStatsInv.OldRPGWeapons.Remove(x, 1);

}

static function bool NullCanTriggerPhysics(Pawn victim)
{
	local DruidGhostInv dgInv;
	local GhostInv gInv;

	if(victim == None)
		return true;
		
	dgInv = DruidGhostInv(Victim.FindInventoryType(class'DruidGhostInv'));
	if(dgInv != None && !dgInv.bDisabled)
		return false;

	gInv = GhostInv(Victim.FindInventoryType(class'GhostInv'));
	if(gInv != None && !gInv.bDisabled)
		return false;
	else if(Victim.PlayerReplicationInfo != None && Victim.PlayerReplicationInfo.HasFlag != None)
		return false;
	
	return true;
}

// *** healing functions

//this function does no healing. it serves to figure out the correct amount of exp to grant to the player, and grants it.
function doHealed(int HealthGiven, Pawn Victim, int localMaxHealth)
{
	Local HealableDamageInv Inv;
	local int ValidHealthGiven;
	local float GrantExp;
	local RPGStatsInv StatsInv;
	local float localEXPMultiplier;
	
	setupRules();
	if(rules == None)
		return;
		
	if(Victim.Controller != None && Victim.Controller.IsA('FriendlyMonsterController'))
		return; //no exp for healing friendly pets. It's already self serving

	if(Instigator == Victim) 
		return; //no exp for self healing. It's already self benificial.

	Inv = HealableDamageInv(Victim.FindInventoryType(class'HealableDamageInv'));
	if(Inv != None)
	{
		ValidHealthGiven = Min(HealthGiven, Inv.Damage);
		if(ValidHealthGiven > 0)
		{
			StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
			if (StatsInv == None)
			{
				log("Warning: No stats inv found. Healing exp not granted.");
				return;
			}

			localExpMultiplier = getExpMultiplier();

			GrantExp = localEXPMultiplier * float(ValidHealthGiven);

			Inv.Damage -= ValidHealthGiven;
			
			Rules.ShareExperience(StatsInv, GrantExp);
		}

		//help keep things in check so a player never has surplus damage in storage.
		if(Inv.Damage > (Victim.HealthMax + localMaxHealth) - Victim.Health)
			Inv.Damage = Max(0, (Victim.HealthMax + localMaxHealth) - Victim.Health); //never let it go negative.
	}
}

//function that can be overridden in subclass.
function int getMaxHealthBonus()
{
	if(AMSH == None)
		AMSH = ArtifactMakeSuperHealer(Instigator.FindInventoryType(class'ArtifactMakeSuperHealer'));
	if(AMSH != None)
		return AMSH.MaxHealth;
	else
		return MaxHealth;
}

//funciton that can be overridden in subclass.
function float getExpMultiplier()
{
	if(AMSH == None)
		AMSH = ArtifactMakeSuperHealer(Instigator.FindInventoryType(class'ArtifactMakeSuperHealer'));
	if(AMSH != None)
		return AMSH.EXPMultiplier;
	else
		return EXPMultiplier;
}

// *** destroying functions

simulated function Destroyed() 
{
	local int x;

	// destroy any added Power types
	for (x = NumPowerTypes-1; x >= 0  ; x--)
		if (CurrentPowerTypes[x] != None)
		{
			CurrentPowerTypes[x].TheWeapon = None;
			CurrentPowerTypes[x].Destroy();
			CurrentPowerTypes[x] = None;
		}
	NumPowerTypes = 0;
	Rules = None;

	Super.Destroyed();
}

defaultproperties
{
     bCanHaveZeroModifier=True
     Modifier=0
     needsIdentify=false
     bModifierSet=false
     MinModifier=-2
     MaxModifier=3
     AdjustableMinModifier=-2
     AdjustableMaxModifier=5
     MaxHealth=0
     EXPMultiplier=0.0
     NumPowerTypes=0
     PickupClass=Class'DEKRPGWeaponPickup'

     MaxNumPowers=3
     MinNumPowers=0
     ChanceZeroPower=1
     ChanceOnePower=5
     ChanceTwoPower=8
     ChanceMultiplePower=0
     PerCentNormalWeapons=10.0

     MaxPowersWeaponsMasters=2
     MaxPowersEngineers=1
     MaxPowersAdrenalineMasters=2
     MaxPowersMonsterMasters=1
     MaxPowersClassicRPG=1
     MaxPowersGeneral=1
     MaxPowersNecromancer=1
     
     MaxNumPowersDroppable=2
     MaxNumPowersClonable=1
     ModifierLossPerPowerup=0

     DamagePercent=2.0
     MinDamageFraction=0.1

     AllowWeaponSwitch=false

}
