class DruidsRPGBuyMaterialsPage extends GUIPage
	DependsOn(RPGStatsInv);

var GiveItemsInv GiveItems;
var RPGStatsInv StatsInv;
var moEditBox PointsAvailableBox;
var GUIListBox Materials;
var string curSubClass;
var int curSubClassLevel;
var localized string CurrentLevelText, MaxText, CostText, CantBuyText;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);
	Materials = GUIListBox(Controls[3]);
	PointsAvailableBox = moEditBox(Controls[6]);

	OnClose=MyOnClose;
}

function InitFor()
{
	local int OldAbilityListIndex, OldAbilityListTop;
	
	Controls[1].MenuStateChange(MSAT_Disabled);
	
	PointsAvailableBox.SetText(string(StatsInv.Data.PointsAvailable));

	//Fill the subclass listbox
	OldAbilityListIndex = Materials.List.Index;
	OldAbilityListTop = Materials.List.Top;
	Materials.List.Clear();
	
	if (GiveItems == None || StatsInv == None)
		return;
	
	// check we have the abilities loaded for this subclass
	if (GiveItems.AbilityConfigs.Length == 0)
	{
		GiveItems.ServerGetAbilities(curSubClasslevel);
		//Log("StatsMenu - InitFor requesting initialization, sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
		SetTimer(0.1, True);
		Materials.List.Add("Please wait - updating list from server");
	}
	else
		UpdateAbilityList();
		
	//restore list's previous state
	if (GiveItems.InitializedAbilities)
	{
		if (OldAbilityListIndex < Materials.ItemCount())
		{
			Materials.List.SetIndex(OldAbilityListIndex);
			Materials.List.SetTopItem(OldAbilityListTop);
		}
		else
		{
			Materials.List.SetIndex(1);
			Materials.List.SetTopItem(0);
		}
		UpdateAbilityButtons(Materials);
	}
}

function UpdateAbilityList()
{
	local RPGPlayerDataObject TempDataObject;
	local int x, y, Index, Cost, Level, MaxLevel;
	local class<AbilityMaterial> cab;

	if (!GiveItems.InitializedAbilities)
	{
		//Log("StatsMenu - UpdateAbilityList not yet initialized, current number of abilities:" $ GiveItems.AbilityConfigs.Length @ "sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
		return;
	}
	
	// the data has finished replicating	
	//Log("StatsMenu - UpdateAbilityList updating ability list, number of abilities:" @ GiveItems.AbilityConfigs.Length @ "sublass:" @ curSubClass @ "time" @ GiveItems.Level.TimeSeconds );
	Materials.List.Clear();
		
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
					Materials.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level@"["$MaxText$"])", StatsInv.AllAbilities[x], string(Cost));
				}
				else
				{
					if (ClassIsChildOf(StatsInv.AllAbilities[x], class'AbilityMaterial'))
					{
						cab = class<AbilityMaterial>(StatsInv.AllAbilities[x]);
						Cost = cab.static.SubClassCost(TempDataObject, Level, curSubClass);	// tell it the subclass to make life easy for it
					}
					else
						Cost =StatsInv.AllAbilities[x].static.Cost(TempDataObject, Level);
		
					if (Cost <= 0)
						Materials.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level$","@CantBuyText$")", StatsInv.AllAbilities[x], string(Cost));
					else
						Materials.List.Add(StatsInv.AllAbilities[x].default.AbilityName@"("$CurrentLevelText@Level$","@CostText@Cost$")", StatsInv.AllAbilities[x], string(Cost));
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

function bool UpdateAbilityButtons(GUIComponent Sender)
{
	local int Cost;

	Cost = int(Materials.List.GetExtra());
	if (Cost <= 0 || Cost > StatsInv.Data.PointsAvailable)
		Controls[1].MenuStateChange(MSAT_Disabled);
	else
		Controls[1].MenuStateChange(MSAT_Blurry);

	return true;
}

function bool BuyMaterial(GUIComponent Sender)
{
	//local GUIController OldController;

	//Controls[1].MenuStateChange(MSAT_Disabled);

	StatsInv.ServerAddAbility(class<RPGAbility>(Materials.List.GetObject()));
	
	return true;
}

function bool MaterialInfo(GUIComponent Sender)
{
	local class<AbilityMaterial> Ability;

	Ability = class<AbilityMaterial>(Materials.List.GetObject());
	Controller.OpenMenu("UT2004RPG.RPGAbilityDescMenu");
	RPGAbilityDescMenu(Controller.TopPage()).t_WindowTitle.Caption = Ability.default.AbilityName;
	RPGAbilityDescMenu(Controller.TopPage()).MyScrollText.SetContent(Ability.default.Description);

	return true;
}

function bool CloseClick(GUIComponent Sender)
{
	Controller.CloseMenu(false);

	return true;
}


function MyOnClose(optional bool bCanceled)
{
	StatsInv = None;
	GiveItems = None;

	Super.OnClose(bCanceled);
}

defaultproperties
{
     CurrentLevelText="You have:"
     MaxText="MAX"
     CostText="Cost:"
     CantBuyText="Can't Buy"
     bRenderWorld=True
     bRequire640x480=False
     Begin Object Class=GUIButton Name=QuitBackground
         WinHeight=1.000000
         bBoundToParent=True
         bScaleToParent=True
         bAcceptsInput=False
         bNeverFocus=True
         OnKeyEvent=QuitBackground.InternalOnKeyEvent
     End Object
     Controls(0)=GUIButton'DEKRPG999X.DruidsRPGBuyMaterialsPage.QuitBackground'

     Begin Object Class=GUIButton Name=MaterialBuyButton
         Caption="Buy"
         WinTop=0.850000
         WinWidth=0.250000
         bBoundToParent=True
         bScaleToParent=True
         OnClick=DruidsRPGBuyMaterialsPage.BuyMaterial
         OnKeyEvent=MaterialBuyButton.InternalOnKeyEvent
     End Object
     Controls(1)=GUIButton'DEKRPG999X.DruidsRPGBuyMaterialsPage.MaterialBuyButton'

     Begin Object Class=GUIButton Name=CloseButton
         Caption="Close"
         WinTop=0.850000
         WinLeft=0.750000
         WinWidth=0.250000
         bBoundToParent=True
         bScaleToParent=True
         OnClick=DruidsRPGBuyMaterialsPage.CloseClick
         OnKeyEvent=CloseButton.InternalOnKeyEvent
     End Object
     Controls(2)=GUIButton'DEKRPG999X.DruidsRPGBuyMaterialsPage.CloseButton'

     Begin Object Class=GUIListBox Name=MaterialList
         bVisibleWhenEmpty=True
         OnCreateComponent=MaterialList.InternalOnCreateComponent
         StyleName="AbilityList"
         Hint="These are the Materials you can purchase."
         WinTop=0.250000
         WinLeft=0.200000
         WinWidth=0.600000
         WinHeight=0.500000
         bBoundToParent=True
         bScaleToParent=True
         OnClick=DruidsRPGBuyMaterialsPage.UpdateAbilityButtons
     End Object
     Controls(3)=GUIListBox'DEKRPG999X.DruidsRPGBuyMaterialsPage.MaterialList'

     Begin Object Class=GUILabel Name=SelectText
         Caption="Material Shop"
         TextAlign=TXTA_Center
         TextColor=(B=0,G=180,R=220)
         TextFont="UT2HeaderFont"
         WinTop=0.100000
         WinHeight=0.100000
         bBoundToParent=True
         bScaleToParent=True
     End Object
     Controls(4)=GUILabel'DEKRPG999X.DruidsRPGBuyMaterialsPage.SelectText'

     Begin Object Class=GUIButton Name=MaterialInfoButton
         Caption="Info"
         WinTop=0.850000
         WinLeft=0.385000
         WinWidth=0.250000
         bBoundToParent=True
         bScaleToParent=True
         OnClick=DruidsRPGBuyMaterialsPage.MaterialInfo
         OnKeyEvent=ClassBuyButton.InternalOnKeyEvent
     End Object
     Controls(5)=GUIButton'DEKRPG999X.DruidsRPGBuyMaterialsPage.MaterialInfoButton'
	 
     Begin Object Class=moEditBox Name=PointsAvailableSelect
         bReadOnly=True
         CaptionWidth=0.775000
         Caption="Stat Points Available"
         OnCreateComponent=PointsAvailableSelect.InternalOnCreateComponent
         IniOption="@INTERNAL"
         WinTop=0.750000
         WinLeft=0.250000
         WinWidth=0.362500
         WinHeight=0.040000
     End Object
     Controls(6)=moEditBox'DEKRPG999X.DruidsRPGBuyMaterialsPage.PointsAvailableSelect'

     WinTop=0.150000
     WinLeft=0.200000
     WinWidth=0.600000
     WinHeight=0.700000
}
