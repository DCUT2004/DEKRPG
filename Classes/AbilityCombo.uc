class AbilityCombo extends CostRPGAbility
	config(UT2004RPG)
	abstract;
	
struct MaterialsStruct
{
	var Array <int> RequiredMaterialLevels;
	var Array < class < RPGAbility > > RequiredMaterials;
};

var Array < MaterialsStruct > Materials;								//Required materials to buy this combo
var Class<Altar> AltarClass;
var byte NumGeodesRequired;

enum EffectRange
{
	RANGE_Single,		//Targets a single enemy
	RANGE_Near,			//Targets all enemies near player
	RANGE_All			//Targets all enemies in level
};

struct StatusCombo
{
	var Class<StatusEffectData> StatusEffectClass;
	var int Modifier;
	var int StatusLifespan;
	var bool bDispellable;
	var bool bStackable;
	var EffectRange Range;
};
var Array <StatusCombo> Combos;

struct DamageStruct
{
	var EffectRange DamageRange;
	var int NumHits;
	var int DamagePerLevel;
	var Class<DamageType> DamageType;
	var float TimeBetweenHits;
};
var DamageStruct AttackCombo;
var int ComboDamage;
var Sound ComboSound;

static simulated function int GetCost(RPGPlayerDataObject Data, int CurrentLevel)
{
	local int x;
	local int y;
	local int ab;
	local int threshold;
	local bool bIsAM;
	
	if (Data == None)
		return 0;
	
	// check the stats
	if (Data.WeaponSpeed < default.MinWeaponSpeed + (CurrentLevel * default.WeaponSpeedStep))
		return 0;
	if (Data.HealthBonus < default.MinHealthBonus + (CurrentLevel * default.HealthBonusStep))
		return 0;
	if (Data.AdrenalineMax < default.MinAdrenalineMax + (CurrentLevel * default.AdrenalineMaxStep))
		return 0;
	if (Data.Attack < default.MinDB + (CurrentLevel * default.DBStep))
		return 0;
	if (Data.Defense < default.MinDR + (CurrentLevel * default.DRStep))
		return 0;
	if (Data.AmmoMax < default.MinAmmo + (CurrentLevel * default.AmmoStep))
		return 0;
	
	// now check the player level
	if(Data.Level < (default.MinPlayerLevel + CurrentLevel*default.PlayerLevelStep))
		return 0;

	if (default.PlayerLevelReqd.length > CurrentLevel+1)		// since zero based need +1
		if (default.PlayerLevelReqd[CurrentLevel+1] > Data.Level)
			return 0;

	// check if already maxed
	if (CurrentLevel >= default.MaxLevel)
		return 0;

	if (default.AltarClass == None || default.NumGeodesRequired <= 0)
		return 0;

	//check if we are an AM
	bIsAM = false;
	for (ab = 0; ab < Data.Abilities.Length; ab++)
	{
		if (Data.Abilities[ab] == Class'ClassAdrenalineMaster')
		{
			bIsAM = true;
			break;
		}
	}
				
	// check for required materials, only for non-AM classes
	// However, if it is a special combo, materials are required no matter the class
	if (!bIsAM)
	{
		for (ab = 0; ab < default.Materials.length; ab++)
		{
			//We are only interested in checking the Materials at the level we want to purchase
			if (ab < CurrentLevel)
				continue;
			
			//If we have all the requisite materials according to the previous iteration of this loop, stop checking for higher level materials
			if (ab > CurrentLevel)
				break;
			
			threshold = 0;
			//Now loop through the RequiredMaterials list
			for (x = 0; x < default.Materials[ab].RequiredMaterials.Length; x++)
			{
				//For each required material, check our current abilities to see if we have the match
				for (y = 0; y < Data.Abilities.Length; y++)
				{
					if (Data.Abilities[y] == default.Materials[ab].RequiredMaterials[x] && Data.AbilityLevels[y] >= default.Materials[ab].RequiredMaterialLevels[x])
					{
						//We have a requisite material. Up the threshold, get out of our current abilities loop and check for the next material
						threshold++;
						break;
					}
				}
			}
			//If our threshold is lower than the number of materials required, return 0 so player can't purchase
			if (threshold < default.Materials[ab].RequiredMaterials.Length)
				return 0;
		}
	}

	// wow. Can buy
	if (default.LevelCost.length <= CurrentLevel)
		return default.StartingCost + default.CostAddPerLevel * CurrentLevel;
	else
		return default.LevelCost[CurrentLevel+1];
}

static function ModifyPawn(Pawn Other, int AbilityLevel)
{
	default.ComboDamage = AbilityLevel * default.AttackCombo.DamagePerLevel;
}

static function bool CanApplyStatusEffect(int Modifier, Pawn Instigator, Pawn Target)
{
	return Modifier > 0 && Target.GetTeamNum() == Instigator.GetTeamNum()
						|| Modifier < 0 && Target.GetTeamNum() != Instigator.GetTeamNum();
}

static function ExecuteCombos(Pawn Instigator, Altar Altar)
{
	local int x;
	local Controller C, NextC;
	local StatusEffectManager StatusManager;
	local Pawn Target;
	local int Modifier;
	local int HighestHealth;
	local OffenseCombo OffenseCombo;

	if (Instigator == None)
		return;

	for (x = 0; x < default.Combos.Length; x++)
	{
		Modifier = default.Combos[x].Modifier;
		if (default.Combos[x].Range == RANGE_Single)
		{
			if (Modifier > 0)		//Buff - apply only to this player
			{
				StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(Instigator);
				if (StatusManager != None)
					StatusManager.AddStatusEffect(default.Combos[x].StatusEffectClass, Modifier, True, default.Combos[x].StatusLifespan, default.Combos[x].bDispellable, default.Combos[x].bStackable);
			}
			else if (Modifier < 0)	//Ailment - search for enemy w/ highest health and apply
			{
				C = Instigator.Level.ControllerList;
				HighestHealth = 0;
				while (C != None)
				{
					NextC = C.NextController;
					if (C != None && C.Pawn != None && C.Pawn.Health > HighestHealth)
					{
						Target = C.Pawn;
						HighestHealth = C.Pawn.Health;
					}
					C = NextC;
				}
				if (Target != None)
				{
					StatusManager = Class'StatusEffectManager'.static.GetStatusEffectManager(Target);
					if (StatusManager != None)
						StatusManager.AddStatusEffect(default.Combos[x].StatusEffectClass, Modifier, True, default.Combos[x].StatusLifespan, default.Combos[x].bDispellable, default.Combos[x].bStackable);
				}
			}
		}
		else if (default.Combos[x].Range == RANGE_Near)
		{
			//Search for enemies and allies nearby activated Altar
			if (Altar != None)
			{
				foreach Altar.TouchingActors(Class'Pawn', Target)
				{
					if (Target != None && Target.Health > 0 && CanApplyStatusEffect(Modifier, Instigator, Target))
					{
						if (Target.IsA('Vehicle') && Vehicle(Target).Driver != None)
							Target = Vehicle(Target).Driver;
						StatusManager = Class'DEKRPG999X.StatusEffectManager'.static.GetStatusEffectManager(Target);
						if (StatusManager != None)
							StatusManager.AddStatusEffect(default.Combos[x].StatusEffectClass, Modifier, True, default.Combos[x].StatusLifespan, default.Combos[x].bDispellable, default.Combos[x].bStackable);
					}
				}
			}

		}
		else if (default.Combos[x].Range == Range_All)
		{
			//Search for all enemies and allies
			C = Instigator.Level.ControllerList;
			while (C != None)
			{
				NextC = C.NextController;
				if (C != None && C.Pawn != None && C.Pawn.Health > 0 && CanApplyStatusEffect(Modifier, Instigator, C.Pawn))
				{
					Target = C.Pawn;
					if (C.Pawn.IsA('Vehicle') && Vehicle(C.Pawn).Driver != None)
						Target = Vehicle(C.Pawn).Driver;
					StatusManager = Class'DEKRPG999X.StatusEffectManager'.static.GetStatusEffectManager(Target);
					if (StatusManager != None)
						StatusManager.AddStatusEffect(default.Combos[x].StatusEffectClass, Modifier, True, default.Combos[x].StatusLifespan, default.Combos[x].bDispellable, default.Combos[x].bStackable);
				}
				C = NextC;
			}
		}
	}
	OffenseCombo = Instigator.Spawn(Class'DEKRPG999X.OffenseCombo', Instigator);
	if (OffenseCombo != None)
	{
		OffenseCombo.Altar = Altar;
		OffenseCombo.NumHits = default.AttackCombo.NumHits;
		Log("ComboDamage is " $default.ComboDamage);
		OffenseCombo.DamageAmount = default.ComboDamage;
		OffenseCombo.DamageType = default.AttackCombo.DamageType;
		OffenseCombo.TimeBetweenHits = default.AttackCombo.TimeBetweenHits;
		if (default.AttackCombo.DamageRange == RANGE_Single)
			OffenseCombo.DamageRange = RANGE_Single;		//Must be assigned directly
		else if (default.AttackCombo.DamageRange == RANGE_Near)
			OffenseCombo.DamageRange = RANGE_Near;
		else if (default.AttackCombo.DamageRange == RANGE_All)
			OffenseCombo.DamageRange = RANGE_All;
		OffenseCombo.StartDamage();
	}

	Altar.PlaySound(default.ComboSound, , Instigator.TransientSoundVolume * 4, , Instigator.TransientSoundRadius*2);
}

defaultproperties
{
	AbilityName="Combo Ability"
	MaxLevel=5
	StartingCost=5
	CostAddPerLevel=5
	AttackCombo=(DamageRange=RANGE_Single,NumHits=1,DamagePerLevel=1,DamageType=Class'DamTypeCombo',TimeBetweenHits=1)
}
