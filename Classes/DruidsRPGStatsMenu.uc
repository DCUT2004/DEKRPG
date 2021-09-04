class DruidsRPGStatsMenu extends RPGStatsMenu
	DependsOn(RPGStatsInv);

var GiveItemsInv GiveItems;
var class<RPGClass> curClass;
var string curSubClass;			// what it is configured as - the class name or the subclass
var int curSubClasslevel;
var string DisplaySubClass;		// what it is displayed to the user as - None or a valid class
var int curLevel;
var string sNone;
var bool bAbilityTimer, bCurrentListAbility, bCurrentListMaterial, bCurrentListCombo;
var localized string MaterialAmountText;

function bool ForcedSell()
{
	if (bAbilityTimer)
	{
		bAbilityTimer = False;
		KillTimer();
	}
	Controller.OpenMenu(string(class'DruidsRPGForcedSellPage'));
	DruidsRPGForcedSellPage(Controller.TopPage()).StatsMenu = self;
	DruidsRPGForcedSellPage(Controller.TopPage()).GiveItems = GiveItems;
	return true;
}

function bool SellClick(GUIComponent Sender)
{
	if (bAbilityTimer)
	{
		bAbilityTimer = False;
		KillTimer();
	}
	Controller.OpenMenu(string(class'DruidsRPGRefundOptionPage'));
	DruidsRPGRefundOptionPage(Controller.TopPage()).StatsMenu = self;
	DruidsRPGRefundOptionPage(Controller.TopPage()).GiveItems = GiveItems;

	return true;
}

function MyOnClose(optional bool bCanceled)
{
	if (bAbilityTimer)
	{
		bAbilityTimer = False;
		KillTimer();
	}
	if (GiveItems != None)
		GiveItems = None;
	if (curClass != None)
		curClass = None;

	Super.MyOnClose(bCanceled);
}

//Initialize, using the given RPGStatsInv for the stats data and for client->server function calls
function InitFor2(RPGStatsInv Inv, GiveItemsInv GInv)
{
	GiveItems = GInv;
	GiveItems.ClientStatsInv = Inv;
	InitFor(Inv);
}

//Initialize, using the given RPGStatsInv for the stats data and for client->server function calls
//mainly copied from the original, but changes to only show the required abilities
function InitFor(RPGStatsInv Inv)
{
	local int x, y, z, OldAbilityListIndex, OldAbilityListTop;
	local bool bGotSubClass, bAllowSubClasses, bCannotPurchaseSubclass;
    local int MinSubClassLevel;

	StatsInv = Inv;
	StatsInv.StatsMenu = self;
	curSubClasslevel = -1;
	bCannotPurchaseSubclass = False;

	WeaponSpeedBox.SetText(string(StatsInv.Data.WeaponSpeed));
	HealthBonusBox.SetText(string(StatsInv.Data.HealthBonus));
	AdrenalineMaxBox.SetText(string(StatsInv.Data.AdrenalineMax));
	AttackBox.SetText(string(StatsInv.Data.Attack));
	DefenseBox.SetText(string(StatsInv.Data.Defense));
	AmmoMaxBox.SetText(string(StatsInv.Data.AmmoMax));
	PointsAvailableBox.SetText(string(StatsInv.Data.PointsAvailable));
	curLevel = StatsInv.Data.Level;
	GUILabel(Controls[27]).Caption = GUILabel(default.Controls[27]).Caption @ string(StatsInv.Data.Level);
	GUILabel(Controls[28]).Caption = GUILabel(default.Controls[28]).Caption @ string(StatsInv.Data.Experience) $ "/" $ string(StatsInv.Data.NeededExp);

	if (StatsInv.Data.PointsAvailable <= 0)
		DisablePlusButtons();
	else
		EnablePlusButtons();

	//show/hide buttons if stat caps reached
	for (x = 0; x < 6; x++)
		if ( StatsInv.StatCaps[x] >= 0
		     && int(moEditBox(Controls[StatDisplayControlsOffset+x]).GetText()) >= StatsInv.StatCaps[x] )
		{
			Controls[ButtonControlsOffset+x].SetVisibility(false);
			Controls[AmtControlsOffset+x].SetVisibility(false);
		}

	//Fill the ability listbox
	OldAbilityListIndex = Abilities.List.Index;
	OldAbilityListTop = Abilities.List.Top;
	Abilities.List.Clear();
	if (GiveItems != None)
	{
		curClass = None;
		curSubClass = "";
		// first lets find the class
		for (y = 0; y < StatsInv.Data.Abilities.length; y++)
			if (ClassIsChildOf(StatsInv.Data.Abilities[y], class'RPGClass'))
			{
				// found the class
				curClass = class<RPGClass>(StatsInv.Data.Abilities[y]);
			}
			else
			if (ClassIsChildOf(StatsInv.Data.Abilities[y], class'SubClass'))
			{
				//found the subclass
				curSubClassLevel = StatsInv.Data.AbilityLevels[y];
				if (curSubClassLevel < GiveItems.SubClasses.length)
					curSubClass = GiveItems.SubClasses[curSubClassLevel];
			}
		
		// ok now update the text on the screen
		if (curClass == None)
		{
			curSubClass = sNone;		// for no class
			DisplaySubClass = sNone;
			GUILabel(Controls[30]).Caption = GUILabel(default.Controls[30]).Caption @ DisplaySubClass;
			Controls[32].MenuStateChange(MSAT_Blurry);
			Controls[33].MenuStateChange(MSAT_Disabled);
			Controls[18].MenuStateChange(MSAT_Disabled);	//Do not allow to buy abilities if no class purchased first - Hollon
			// Force open Buy Class page - Hollon
			ClassBuyClick(Abilities);
		}
		else
		{
			GUILabel(Controls[30]).Caption = curClass.default.AbilityName;
			Controls[32].MenuStateChange(MSAT_Disabled);
			for (z = 0; z < StatsInv.Data.Abilities.Length; z++)	//As soon as we find an ability that is not a class, not a material and not a combo(ie its a regular ability), disable the buy subclass button
			{
				if (!ClassIsChildOf(StatsInv.Data.Abilities[z], Class'RPGClass') && !ClassIsChildOf(StatsInv.Data.Abilities[z], Class'AbilityMaterial') && !ClassIsChildOf(StatsInv.Data.Abilities[z], Class'AbilityCombo'))
				{
					bCannotPurchaseSubclass = True;
					break;
				}
			}
			if (curSubClass == "" && !bCannotPurchaseSubclass)
				Controls[33].MenuStateChange(MSAT_Blurry);
			else
				Controls[33].MenuStateChange(MSAT_Disabled);
			if (curSubClass == "")
			{
				curSubClass = curClass.default.AbilityName;								// if got a class but no sub class, the abilities are configured under the class ability name
				DisplaySubClass = sNone;
			}
			else
				DisplaySubClass = curSubClass;
				
		}
		// lets just make sure we have curSubClasslevel set
		if (curSubClasslevel < 0)
		{
			for (y = 0; y < GiveItems.SubClasses.length; y++)
				if (GiveItems.SubClasses[y] == curSubClass)
					curSubClasslevel = y;
			if (curSubClasslevel < 0)
				curSubClassLevel = 0;		// minise the damage
			
		}
		GUILabel(Controls[31]).Caption = GUILabel(default.Controls[31]).Caption @ DisplaySubClass;
		// and enable the buying buttons if necessary
		
		// let's see if the subclasses are available
		MinSubClassLevel = 200;
		// ok now add the subclasses for this class
		for (y = 0; y < GiveItems.SubClassConfigs.length; y++)
		{
			if (GiveItems.SubClassConfigs[y].AvailableClass == curClass)
			{	// add subclasses 
				if (MinSubClassLevel > GiveItems.SubClassConfigs[x].MinLevel)
					MinSubClassLevel = GiveItems.SubClassConfigs[x].MinLevel;
			}
		}
		if (curlevel < MinSubClassLevel)
			bAllowSubClasses = false;
		else
			bAllowSubClasses = true;

		if (!bAllowSubClasses) 
		{
			Controls[33].MenuStateChange(MSAT_Disabled);	// disable buy button for now
			//Controls[29].MenuStateChange(MSAT_Disabled);	// disable sell button for now
		}

		// lets check if the subclass is still valid
		if (curClass != None && curSubClass != "" && curSubClass != curClass.default.AbilityName)		// no class is always ok
		{
			// look through the list of classes and subclasses and check it is still there
			bGotSubClass = false;
			for (x = 0; x < GiveItems.SubClassConfigs.length; x++)
			{
				if (GiveItems.SubClassConfigs[x].AvailableClass == curClass && GiveItems.SubClassConfigs[x].AvailableSubClass == curSubClass && GiveItems.SubClassConfigs[x].MinLevel <= curLevel)
				{	// got it, so still valid 
					bGotSubClass = true;
				}
			}
			if (!bGotSubClass)
			{
				// must sell
				ForcedSell();
				return;
			}
		}
		
		// check we have the abilities loaded for this subclass
		if (GiveItems.AbilityConfigs.Length == 0)
		{
			GiveItems.ServerGetAbilities(curSubClasslevel);
			//Log("StatsMenu - InitFor requesting initialization, sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
			SetTimer(0.1, True);
			bAbilityTimer = True;
			Abilities.List.Add("Please wait - updating list from server");
		}
		else
		{
			if (bCurrentListAbility)
				UpdateAbilityList();
			else if (bCurrentListMaterial)
				UpdateMaterialsList();
			else if (bCurrentListCombo)
				UpdateComboList();
			else
				UpdateAbilityList();
		}
			
		//restore list's previous state
		if (GiveItems.InitializedAbilities)
		{
			if (OldAbilityListIndex < Abilities.ItemCount())
			{
				Abilities.List.SetIndex(OldAbilityListIndex);
				Abilities.List.SetTopItem(OldAbilityListTop);
			}
			else
			{
				Abilities.List.SetIndex(1);
				Abilities.List.SetTopItem(0);
			}
			UpdateAbilityButtons(Abilities);
		}
	}
}

function UpdateAbilityList()
{
	local RPGPlayerDataObject TempDataObject;
	local int x, y, Index, Cost, Level, MaxLevel;
	local class<CostRPGAbility> cab;

	if (!GiveItems.InitializedAbilities)
	{
		//Log("StatsMenu - UpdateAbilityList not yet initialized, current number of abilities:" $ GiveItems.AbilityConfigs.Length @ "sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
		return;
	}
	
	// the data has finished replicating	
	//Log("StatsMenu - UpdateAbilityList updating ability list, number of abilities:" @ GiveItems.AbilityConfigs.Length @ "sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
	Abilities.List.Clear();
		
	// on a client, the data object doesn't exist, so make a temporary one for calling the abilities' cost functions
	if (StatsInv.Role < ROLE_Authority)
	{
		TempDataObject = RPGPlayerDataObject(StatsInv.Level.ObjectPool.AllocateObject(class'RPGPlayerDataObject'));
		TempDataObject.InitFromDataStruct(StatsInv.Data);
	}
	else
	{
		TempDataObject = StatsInv.DataObject;
	}

	// now lets list the abilities for this subclass.
	for (x = 0; x < StatsInv.AllAbilities.length; x++)
	{
		if (!ClassIsChildOf(StatsInv.AllAbilities[x], class'RPGClass') && !ClassIsChildOf(StatsInv.AllAbilities[x], class'AbilityMaterial') && !ClassIsChildOf(StatsInv.AllAbilities[x], class'AbilityUnlockable') && !ClassIsChildOf(StatsInv.AllAbilities[x], class'SubClass') 
			&& !ClassIsChildOf(StatsInv.AllAbilities[x], class'BotAbility'))
		{	// do not add classes or subclasses to this abilities list. Handle separately
			Index = -1;
			for (y = 0; y < StatsInv.Data.Abilities.length; y++)
				if (StatsInv.AllAbilities[x] == StatsInv.Data.Abilities[y])
				{
					Index = y;
					y = StatsInv.Data.Abilities.length;
				}
			if (Index == -1)
				Level = 0;	// not got it
			else
				Level = StatsInv.Data.AbilityLevels[Index];
				
			MaxLevel = GiveItems.MaxCanBuy(curSubClassLevel, StatsInv.AllAbilities[x]);	// MaxLevel==0 means this class & subclass can't buy
		
			if (MaxLevel > 0 || Level > 0)
			{
				if (Level >= MaxLevel)
				{
					Cost = 0;
					Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level@"["$MaxText$"])", StatsInv.AllAbilities[x], string(Cost));
				}
				else
				{
					if (ClassIsChildOf(StatsInv.AllAbilities[x], class'CostRPGAbility'))
					{
						cab = class<CostRPGAbility>(StatsInv.AllAbilities[x]);
						Cost = cab.static.SubClassCost(TempDataObject, Level, curSubClass);	// tell it the subclass to make life easy for it
					}
					else
						Cost =StatsInv.AllAbilities[x].static.Cost(TempDataObject, Level);
		
					if (Cost <= 0)
						Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level$","@CantBuyText$")", StatsInv.AllAbilities[x], string(Cost));
					else
						Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
				}
			}
		}
	}
	
	// free the temporary data object on clients
	if (StatsInv.Role < ROLE_Authority)
	{
		StatsInv.Level.ObjectPool.FreeObject(TempDataObject);
	}
}

function UpdateMaterialsList()
{
	local RPGPlayerDataObject TempDataObject;
	local int x, y, z, Index, Cost, Level, MaxLevel;
	local class<AbilityMaterial> cab;

	if (!GiveItems.InitializedAbilities)
	{
		//Log("StatsMenu - UpdateAbilityList not yet initialized, current number of abilities:" $ GiveItems.AbilityConfigs.Length @ "sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
		return;
	}
	
	// the data has finished replicating	
	//Log("StatsMenu - UpdateAbilityList updating ability list, number of abilities:" @ GiveItems.AbilityConfigs.Length @ "sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
	Abilities.List.Clear();
		
	// on a client, the data object doesn't exist, so make a temporary one for calling the abilities' cost functions
	if (StatsInv.Role < ROLE_Authority)
	{
		TempDataObject = RPGPlayerDataObject(StatsInv.Level.ObjectPool.AllocateObject(class'RPGPlayerDataObject'));
		TempDataObject.InitFromDataStruct(StatsInv.Data);
	}
	else
	{
		TempDataObject = StatsInv.DataObject;
	}

	// now lets list the abilities for this subclass.
	for (x = 0; x < StatsInv.AllAbilities.length; x++)
	{
		if (ClassIsChildOf(StatsInv.AllAbilities[x], class'AbilityMaterial'))
		{
			Index = -1;
			for (y = 0; y < StatsInv.Data.Abilities.length; y++)
				if (StatsInv.AllAbilities[x] == StatsInv.Data.Abilities[y])
				{
					Index = y;
					y = StatsInv.Data.Abilities.length;
				}
			if (Index == -1)
				Level = 0;	// not got it
			else
				Level = StatsInv.Data.AbilityLevels[Index];
				
			MaxLevel = GiveItems.MaxCanBuy(curSubClassLevel, StatsInv.AllAbilities[x]);	// MaxLevel==0 means this class & subclass can't buy
		
			if (MaxLevel > 0 || Level > 0)
			{
				if (Level >= MaxLevel)
				{
					Cost = 0;
					Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level@"["$MaxText$"])", StatsInv.AllAbilities[x], string(Cost));
				}
				else
				{
					if (ClassIsChildOf(StatsInv.AllAbilities[x], class'AbilityMaterial'))
					{
						cab = class<AbilityMaterial>(StatsInv.AllAbilities[x]);
						Cost = cab.static.SubClassCost(TempDataObject, Level, curSubClass);	// tell it the subclass to make life easy for it
					}
					else
						Cost = StatsInv.AllAbilities[x].static.Cost(TempDataObject, Level);
		
					if (Cost <= 0)
						Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CantBuyText$")", StatsInv.AllAbilities[x], string(Cost));
					else
					{
						//New way- Show all materials we have at least 1 level of
						//Disable the buy button for these materials if we have not discovered it yet (ie the material boolean is false in GInv)
						//If we have discovered a material(ie the material boolean is true in GInv), enable the buy button
						
						//Below shows only materials we have discovered
						if (GiveItems != None)
						{
							if (StatsInv.AllAbilities[x] == Class'AbilityMaterialLumber' && GiveItems.bLumber)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialCombatBoots' && GiveItems.bBoots)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialTarydiumShards' && GiveItems.bTarydium)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialSteel' && GiveItems.bSteel)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialNaliFruit' && GiveItems.bNaliFruit)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialGloves' && GiveItems.bGloves)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialLeather' && GiveItems.bLeather)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialPlatedArmor' && GiveItems.bArmor)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialHoneysuckleVine' && GiveItems.bVines)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialEmbers' && GiveItems.bEmbers)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialArcticSuit' && GiveItems.bArcticSuit)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialMoss' && GiveItems.bMoss)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialDust' && GiveItems.bDust)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialNanite' && GiveItems.bNanite)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialPumice' && GiveItems.bPumice)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialIcicle' && GiveItems.bIcicle)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialTranslator' && GiveItems.bTranslator)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialStarChart' && GiveItems.bStarChart)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialUranium' && GiveItems.bUranium)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialHourglass' && GiveItems.bHourglass)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else if (StatsInv.AllAbilities[x] == Class'AbilityMaterialMoonlitStone' && GiveItems.bMoonlitStone)
								Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$MaterialAmountText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
							else //Add the material if purchased, even if not discovered
							{
								for (z = 0; z < StatsInv.Data.Abilities.Length; z++)
								{
									if (ClassIsChildOf(StatsInv.Data.Abilities[z], Class'AbilityMaterial') && StatsInv.AllAbilities[x] == StatsInv.Data.Abilities[z] && StatsInv.Data.AbilityLevels[z] >= 1)
										Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"(NOT Discovered. You have: "@Level$")", StatsInv.AllAbilities[x], string(Cost));									
								}
							}
						}
					}
				}
			}
		}
	}
	
	// free the temporary data object on clients
	if (StatsInv.Role < ROLE_Authority)
	{
		StatsInv.Level.ObjectPool.FreeObject(TempDataObject);
	}
}

function UpdateComboList()
{
	local RPGPlayerDataObject TempDataObject;
	local int x, y, Index, Cost, Level, MaxLevel;
	local class<AbilityCombo> cab;

	if (!GiveItems.InitializedAbilities)
	{
		//Log("StatsMenu - UpdateAbilityList not yet initialized, current number of abilities:" $ GiveItems.AbilityConfigs.Length @ "sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
		return;
	}
	
	// the data has finished replicating	
	//Log("StatsMenu - UpdateAbilityList updating ability list, number of abilities:" @ GiveItems.AbilityConfigs.Length @ "sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
	Abilities.List.Clear();
		
	// on a client, the data object doesn't exist, so make a temporary one for calling the abilities' cost functions
	if (StatsInv.Role < ROLE_Authority)
	{
		TempDataObject = RPGPlayerDataObject(StatsInv.Level.ObjectPool.AllocateObject(class'RPGPlayerDataObject'));
		TempDataObject.InitFromDataStruct(StatsInv.Data);
	}
	else
	{
		TempDataObject = StatsInv.DataObject;
	}

	// now lets list the abilities for this subclass.
	for (x = 0; x < StatsInv.AllAbilities.length; x++)
	{
		if (ClassIsChildOf(StatsInv.AllAbilities[x], class'AbilityCombo'))
		{
			Index = -1;
			for (y = 0; y < StatsInv.Data.Abilities.length; y++)
				if (StatsInv.AllAbilities[x] == StatsInv.Data.Abilities[y])
				{
					Index = y;
					y = StatsInv.Data.Abilities.length;
				}
			if (Index == -1)
				Level = 0;	// not got it
			else
				Level = StatsInv.Data.AbilityLevels[Index];
				
			MaxLevel = GiveItems.MaxCanBuy(curSubClassLevel, StatsInv.AllAbilities[x]);	// MaxLevel==0 means this class & subclass can't buy
		
			if (MaxLevel > 0 || Level > 0)
			{
				if (Level >= MaxLevel)
				{
					Cost = 0;
					Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level@"["$MaxText$"])", StatsInv.AllAbilities[x], string(Cost));
				}
				else
				{
					if (ClassIsChildOf(StatsInv.AllAbilities[x], class'AbilityCombo'))
					{
						cab = class<AbilityCombo>(StatsInv.AllAbilities[x]);
						Cost = cab.static.SubClassCost(TempDataObject, Level, curSubClass);	// tell it the subclass to make life easy for it
					}
					else
						Cost =StatsInv.AllAbilities[x].static.Cost(TempDataObject, Level);
		
					if (Cost <= 0)
						Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level$","@CantBuyText$")", StatsInv.AllAbilities[x], string(Cost));
					else
						Abilities.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
				}
			}
		}
	}
	
	// free the temporary data object on clients
	if (StatsInv.Role < ROLE_Authority)
	{
		StatsInv.Level.ObjectPool.FreeObject(TempDataObject);
	}
}

function OnTimer(GUIComponent Sender)
{
	//Log("StatsMenu - OnTimer, initialised:" $ GiveItems.InitializedAbilities @ "current number of abilities:" $ GiveItems.AbilityConfigs.Length @ "sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
	if (!GiveItems.InitializedAbilities)
		return;
			
	if (bAbilityTimer)
	{
		bAbilityTimer = False;
		KillTimer();
	}
	
	UpdateAbilityList();
}
	
//What to do when we highlight an ability in the Ability List
function bool UpdateAbilityButtons(GUIComponent Sender)
{
	local int Cost;
	local class<RPGAbility> Ability;
	
	Ability = class<RPGAbility>(Abilities.List.GetObject());	

	Cost = int(Abilities.List.GetExtra());
	if (Cost <= 0 || Cost > StatsInv.Data.PointsAvailable || curClass == None)
	{
		Controls[18].MenuStateChange(MSAT_Disabled);
		Controls[34].MenuStateChange(MSAT_Disabled);
	}
	else
	{
		Controls[18].MenuStateChange(MSAT_Blurry);
		Controls[34].MenuStateChange(MSAT_Blurry);
		//If the highlighted ability is a material, and the player has not yet discovered the material, disable the buy button
		if (ClassIsChildOf(Ability, Class'AbilityMaterial'))
		{
			if (GiveItems != None)
			{
				if (Ability == Class'AbilityMaterialArcticSuit' && !GiveItems.bArcticSuit)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);				
				}
				else if (Ability == Class'AbilityMaterialCombatBoots' && !GiveItems.bBoots)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialDust' && !GiveItems.bDust)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialEmbers' && !GiveItems.bEmbers)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialGloves' && !GiveItems.bGloves)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialHoneysuckleVine' && !GiveItems.bVines)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialHourglass' && !GiveItems.bHourglass)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialIcicle' && !GiveItems.bIcicle)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialLeather' && !GiveItems.bLeather)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialLumber' && !GiveItems.bLumber)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialMoonlitStone' && !GiveItems.bMoonlitStone)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialMoss' && !GiveItems.bMoss)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialNaliFruit' && !GiveItems.bNaliFruit)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialNanite' && !GiveItems.bNanite)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialPlatedArmor' && !GiveItems.bArmor)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialPumice' && !GiveItems.bPumice)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialStarChart' && !GiveItems.bStarChart)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialSteel' && !GiveItems.bSteel)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialTarydiumShards' && !GiveItems.bTarydium)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialTranslator' && !GiveItems.bTranslator)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
				else if (Ability == Class'AbilityMaterialUranium' && !GiveItems.bUranium)
				{
					Controls[18].MenuStateChange(MSAT_Disabled);
					Controls[34].MenuStateChange(MSAT_Disabled);					
				}
			}
			else
			{
				//Disable just in case
				Controls[18].MenuStateChange(MSAT_Disabled);
				Controls[34].MenuStateChange(MSAT_Disabled);
			}
		}
	}
	if (ClassIsChildOf(Ability, Class'AbilityMaterial'))
		Controls[34].MenuStateChange(MSAT_Disabled);
	
	return true;
}

function bool ClassBuyClick(GUIComponent Sender)
{
	if (curClass != None)
		return false;
		
	DisablePlusButtons();
	Controls[18].MenuStateChange(MSAT_Disabled);
	//Controls[32].MenuStateChange(MSAT_Disabled);
	Controls[33].MenuStateChange(MSAT_Disabled);

	if (bAbilityTimer)
	{
		bAbilityTimer = False;
		KillTimer();
	}
	Controller.OpenMenu(string(class'DruidsRPGBuyClassPage'));
	DruidsRPGBuyClassPage(Controller.TopPage()).StatsInv = StatsInv;
	DruidsRPGBuyClassPage(Controller.TopPage()).GiveItems = GiveItems;
	DruidsRPGBuyClassPage(Controller.TopPage()).InitFor();

	return true;
}

function bool SubClassBuyClick(GUIComponent Sender)
{
	DisablePlusButtons();
	Controls[18].MenuStateChange(MSAT_Disabled);
	Controls[32].MenuStateChange(MSAT_Disabled);
	Controls[33].MenuStateChange(MSAT_Disabled);

	if (bAbilityTimer)
	{
		bAbilityTimer = False;
		KillTimer();
	}
	Controller.OpenMenu(string(class'DruidsRPGBuySubClassPage'));
	DruidsRPGBuySubClassPage(Controller.TopPage()).StatsInv = StatsInv;
	DruidsRPGBuySubClassPage(Controller.TopPage()).GiveItems = GiveItems;
	DruidsRPGBuySubClassPage(Controller.TopPage()).curLevel = curLevel;
	DruidsRPGBuySubClassPage(Controller.TopPage()).InitFor(curClass);

	return true;
}

function bool ShowAbilityDesc(GUIComponent Sender)
{
	local class<RPGAbility> Ability;
	local int Maxl;
	local string classtext;

	Ability = class<RPGAbility>(Abilities.List.GetObject());
	if (Ability == None)
		return true;
		
	Controller.OpenMenu(string(class'DruidRPGAbilityDescMenu'));
	DruidRPGAbilityDescMenu(Controller.TopPage()).t_WindowTitle.Caption = Ability.default.AbilityName;
	DruidRPGAbilityDescMenu(Controller.TopPage()).MyScrollText.SetContent(Ability.default.Description);
	
	if (GiveItems != None)
	{
		MaxL = GiveItems.MaxCanBuy(curSubClassLevel, Ability);	// MaxLevel==0 means this subclass can't buy
	}
	if (curClass == None)
		classtext = "Class: None";
	else
		classtext = curClass.default.AbilityName;
	DruidRPGAbilityDescMenu(Controller.TopPage()).MaxText.SetContent("Max Level for" @ classtext @ "SubClass:" @ DisplaySubClass @ "is" @ string(MaxL));

	return true;
}

function bool ResetClick(GUIComponent Sender)
{
	Controller.OpenMenu(string(class'DruidRPGResetConfirmPage'));
	RPGResetConfirmPage(Controller.TopPage()).StatsMenu = self;
	return true;
}

function bool MaxAbility(GUIComponent Sender)
{
	local int CurL,MaxL,y;
	local class<RPGAbility> Ability;

	Ability = class<RPGAbility>(Abilities.List.GetObject());
	if (Ability == None)
		return true;

	if (GiveItems != None)
	{
		MaxL = GiveItems.MaxCanBuy(curSubClassLevel, Ability);	// MaxLevel==0 means this subclass can't buy
	}
	
	CurL = 0;
	for (y = 0; y < StatsInv.Data.Abilities.length; y++)
		if (Ability == StatsInv.Data.Abilities[y])
		{
			CurL = StatsInv.Data.AbilityLevels[y];
			y = StatsInv.Data.Abilities.length;
		}

	DisablePlusButtons();
	Controls[18].MenuStateChange(MSAT_Disabled);
	
	// buy all the levels we are missing. The server will bounce if can't buy.
	for (y = CurL; y < MaxL; y++)
		StatsInv.ServerAddAbility(Ability);

	return true;
}

function bool ShowMaterials(GUIComponent Sender)
{
	UpdateMaterialsList();
	bCurrentListMaterial = True;
	bCurrentListAbility = False;
	bCurrentListCombo = False;
	
	//Disable Max Button
	Controls[34].MenuStateChange(MSAT_Disabled);

	return true;
}

function bool ShowAbilities(GUIComponent Sender)
{
	UpdateAbilityList();
	bCurrentListAbility = True;
	bCurrentListMaterial = False;
	bCurrentListCombo = False;
	return true;
}

function bool ShowCombos(GUIComponent Sender)
{
	UpdateComboList();
	bCurrentListCombo = True;
	bCurrentListAbility = False;
	bCurrentListMaterial = False;
	return true;
}

defaultproperties
{
     sNone="None"
     MaterialAmountText="Discovered! You have:"
     OnClose=DruidsRPGStatsMenu.MyOnClose 
     Begin Object Class=moEditBox Name=WeaponSpeedSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Weapon Speed Bonus (%)"
         OnCreateComponent=WeaponSpeedSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.112448
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(2)=moEditBox'DEKRPG209A.DruidsRPGStatsMenu.WeaponSpeedSelect'

     Begin Object Class=moEditBox Name=HealthBonusSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Health Bonus"
         OnCreateComponent=HealthBonusSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.187448
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(3)=moEditBox'DEKRPG209A.DruidsRPGStatsMenu.HealthBonusSelect'

     Begin Object Class=moEditBox Name=AdrenalineMaxSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Max Adrenaline"
         OnCreateComponent=AdrenalineMaxSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.262448
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(4)=moEditBox'DEKRPG209A.DruidsRPGStatsMenu.AdrenalineMaxSelect'

     Begin Object Class=moEditBox Name=AttackSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Damage Bonus (0.5%)"
         OnCreateComponent=AttackSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.337448
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(5)=moEditBox'DEKRPG209A.DruidsRPGStatsMenu.AttackSelect'

     Begin Object Class=moEditBox Name=DefenseSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Damage Reduction (0.5%)"
         OnCreateComponent=DefenseSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.412448
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(6)=moEditBox'DEKRPG209A.DruidsRPGStatsMenu.DefenseSelect'

     Begin Object Class=moEditBox Name=MaxAmmoSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Max Ammo Bonus (%)"
         OnCreateComponent=MaxAmmoSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.487448
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(7)=moEditBox'DEKRPG209A.DruidsRPGStatsMenu.MaxAmmoSelect'

     Begin Object Class=moEditBox Name=PointsAvailableSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Stat Points Available"
         OnCreateComponent=PointsAvailableSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.562448
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(8)=moEditBox'DEKRPG209A.DruidsRPGStatsMenu.PointsAvailableSelect'

     Begin Object Class=GUIButton Name=WeaponSpeedButton
         Caption="+"
         WinTop=0.122448
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.StatPlusClick
         OnKeyEvent=WeaponSpeedButton.InternalOnKeyEvent
     End Object
     Controls(9)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.WeaponSpeedButton'

     Begin Object Class=GUIButton Name=HealthBonusButton
         Caption="+"
         WinTop=0.197448
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.StatPlusClick
         OnKeyEvent=HealthBonusButton.InternalOnKeyEvent
     End Object
     Controls(10)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.HealthBonusButton'

     Begin Object Class=GUIButton Name=AdrenalineMaxButton
         Caption="+"
         WinTop=0.272448
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.StatPlusClick
         OnKeyEvent=AdrenalineMaxButton.InternalOnKeyEvent
     End Object
     Controls(11)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.AdrenalineMaxButton'

     Begin Object Class=GUIButton Name=AttackButton
         Caption="+"
         WinTop=0.347448
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.StatPlusClick
         OnKeyEvent=AttackButton.InternalOnKeyEvent
     End Object
     Controls(12)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.AttackButton'

     Begin Object Class=GUIButton Name=DefenseButton
         Caption="+"
         WinTop=0.422448
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.StatPlusClick
         OnKeyEvent=DefenseButton.InternalOnKeyEvent
     End Object
     Controls(13)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.DefenseButton'

     Begin Object Class=GUIButton Name=AmmoMaxButton
         Caption="+"
         WinTop=0.497448
         WinLeft=0.737500
         WinWidth=0.040000
         OnClick=RPGStatsMenu.StatPlusClick
         OnKeyEvent=AmmoMaxButton.InternalOnKeyEvent
     End Object
     Controls(14)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.AmmoMaxButton'
	 
     Begin Object Class=GUIListBox Name=AbilityList
         bVisibleWhenEmpty=True
         OnCreateComponent=AbilityList.InternalOnCreateComponent
         StyleName="AbilityList"
         Hint="These are the abilities you can purchase with stat points."
         WinTop=0.730000
         WinLeft=0.215000
         WinWidth=0.435000
         WinHeight=0.150000
         OnClick=RPGStatsMenu.UpdateAbilityButtons
     End Object
     Controls(16)=GUIListBox'DEKRPG209A.DruidsRPGStatsMenu.AbilityList'

     Begin Object Class=GUIButton Name=AbilityDescButton
         Caption="Info"
         WinTop=0.790000
         WinLeft=0.675000
         WinWidth=0.100000
         OnClick=DruidsRPGStatsMenu.ShowAbilityDesc
         OnKeyEvent=AbilityDescButton.InternalOnKeyEvent
     End Object
     Controls(17)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.AbilityDescButton'
	 
     Begin Object Class=GUIButton Name=AbilityBuyButton
         Caption="Buy"
         WinTop=0.840000
         WinLeft=0.675000
         WinWidth=0.100000
         OnClick=RPGStatsMenu.BuyAbility
         OnKeyEvent=AbilityBuyButton.InternalOnKeyEvent
     End Object
     Controls(18)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.AbilityBuyButton'

     Begin Object Class=GUINumericEdit Name=WeaponSpeedAmt
         Value="5"
         MinValue=1
         MaxValue=5
         WinTop=0.112448
         WinLeft=0.645000
         WinWidth=0.080000
         OnDeActivate=WeaponSpeedAmt.ValidateValue
     End Object
     Controls(19)=GUINumericEdit'DEKRPG209A.DruidsRPGStatsMenu.WeaponSpeedAmt'

     Begin Object Class=GUINumericEdit Name=HealthBonusAmt
         Value="5"
         MinValue=1
         MaxValue=5
         WinTop=0.187448
         WinLeft=0.645000
         WinWidth=0.080000
         OnDeActivate=HealthBonusAmt.ValidateValue
     End Object
     Controls(20)=GUINumericEdit'DEKRPG209A.DruidsRPGStatsMenu.HealthBonusAmt'

     Begin Object Class=GUINumericEdit Name=AdrenalineMaxAmt
         Value="5"
         MinValue=1
         MaxValue=5
         WinTop=0.262448
         WinLeft=0.645000
         WinWidth=0.080000
         OnDeActivate=AdrenalineMaxAmt.ValidateValue
     End Object
     Controls(21)=GUINumericEdit'DEKRPG209A.DruidsRPGStatsMenu.AdrenalineMaxAmt'

     Begin Object Class=GUINumericEdit Name=AttackAmt
         Value="5"
         MinValue=1
         MaxValue=5
         WinTop=0.337448
         WinLeft=0.645000
         WinWidth=0.080000
         OnDeActivate=AttackAmt.ValidateValue
     End Object
     Controls(22)=GUINumericEdit'DEKRPG209A.DruidsRPGStatsMenu.AttackAmt'

     Begin Object Class=GUINumericEdit Name=DefenseAmt
         Value="5"
         MinValue=1
         MaxValue=5
         WinTop=0.412448
         WinLeft=0.645000
         WinWidth=0.080000
         OnDeActivate=DefenseAmt.ValidateValue
     End Object
     Controls(23)=GUINumericEdit'DEKRPG209A.DruidsRPGStatsMenu.DefenseAmt'

     Begin Object Class=GUINumericEdit Name=MaxAmmoAmt
         Value="5"
         MinValue=1
         MaxValue=5
         WinTop=0.487448
         WinLeft=0.645000
         WinWidth=0.080000
         OnDeActivate=MaxAmmoAmt.ValidateValue
     End Object
     Controls(24)=GUINumericEdit'DEKRPG209A.DruidsRPGStatsMenu.MaxAmmoAmt'

     Begin Object Class=GUIButton Name=SellButton
         Caption="Refund"
         WinTop=0.604896
         WinLeft=0.675000
         WinWidth=0.100000
         OnClick=DruidsRPGStatsMenu.SellClick
         OnKeyEvent=SellButton.InternalOnKeyEvent
     End Object
     Controls(29)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.SellButton'

     Begin Object Class=GUILabel Name=ClassLabel
         Caption="Class:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.612448
         WinLeft=0.084000
         WinHeight=0.025000
         bBoundToParent=True
         bScaleToParent=True
     End Object
     Controls(30)=GUILabel'DEKRPG209A.DruidsRPGStatsMenu.ClassLabel'

     Begin Object Class=GUILabel Name=SubClassLabel
         Caption="SubClass:"
         TextColor=(B=255,G=255,R=255)
         WinTop=0.652448
         WinLeft=0.084000
         WinHeight=0.025000
         bBoundToParent=True
         bScaleToParent=True
     End Object
     Controls(31)=GUILabel'DEKRPG209A.DruidsRPGStatsMenu.SubClassLabel'

     Begin Object Class=GUIButton Name=ClassBuyButton
         Caption="Buy a Class"
         WinTop=0.607448
         WinLeft=0.500000
         WinWidth=0.150000
         OnClick=DruidsRPGStatsMenu.ClassBuyClick
         OnKeyEvent=ClassBuyButton.InternalOnKeyEvent
     End Object
     Controls(32)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.ClassBuyButton'

     Begin Object Class=GUIButton Name=SubClassBuyButton
         Caption="Buy a Subclass"
         WinTop=0.642448
         WinLeft=0.500000
         WinWidth=0.150000
         OnClick=DruidsRPGStatsMenu.SubClassBuyClick
         OnKeyEvent=SubClassBuyButton.InternalOnKeyEvent
     End Object
     Controls(33)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.SubClassBuyButton'

     Begin Object Class=GUIButton Name=AbilityMaxButton
         Caption="Max"
         WinTop=0.740000
         WinLeft=0.675000
         WinWidth=0.100000
         OnClick=DruidsRPGStatsMenu.MaxAbility
         OnKeyEvent=AbilityBuyButton.InternalOnKeyEvent
     End Object
     Controls(34)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.AbilityMaxButton'
	 
     Begin Object Class=GUIButton Name=ShowMaterialButton
         Caption="Materials"
		 WinTop=0.680000
         WinLeft=0.315000
         WinWidth=0.100000
         OnClick=DruidsRPGStatsMenu.ShowMaterials
         OnKeyEvent=ShowMaterialButton.InternalOnKeyEvent
     End Object
     Controls(35)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.ShowMaterialButton'
	 
     Begin Object Class=GUIButton Name=ShowAbilityButton
         Caption="Abilities"
		 WinTop=0.680000
         WinLeft=0.215000
         WinWidth=0.100000
         OnClick=DruidsRPGStatsMenu.ShowAbilities
         OnKeyEvent=ShowAbilityButton.InternalOnKeyEvent
     End Object
     Controls(36)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.ShowAbilityButton'
	 
     Begin Object Class=GUIButton Name=ShowComboButton
         Caption="Combos"
		 WinTop=0.680000
         WinLeft=0.415000
         WinWidth=0.100000
         OnClick=DruidsRPGStatsMenu.ShowCombos
         OnKeyEvent=ShowAbilityButton.InternalOnKeyEvent
     End Object
     Controls(37)=GUIButton'DEKRPG209A.DruidsRPGStatsMenu.ShowComboButton'

}
