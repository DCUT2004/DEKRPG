//After pressing Refund, player must choose whether to fund Subclass and Abilities, Combos, or Niches
class DruidsRPGRefundOptionPage extends GUIPage;

var DruidsRPGStatsMenu StatsMenu;
var GiveItemsInv GiveItems;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	OnClose=MyOnClose;
}

function bool InternalOnClick(GUIComponent Sender)
{	
	if (GiveItems != None && StatsMenu != None)
	{
		if (Sender == Controls[1])
		{
			Controller.OpenMenu(string(class'DruidsRPGSellConfirmPage'));
			DruidsRPGSellConfirmPage(Controller.TopPage()).StatsMenu = StatsMenu;
			DruidsRPGSellConfirmPage(Controller.TopPage()).GiveItems = GiveItems;
		}
		else if (Sender == Controls[2])
		{
			Controller.OpenMenu(string(class'DruidsRPGSellNicheConfirmPage'));
			DruidsRPGSellNicheConfirmPage(Controller.TopPage()).StatsMenu = StatsMenu;
			DruidsRPGSellNicheConfirmPage(Controller.TopPage()).GiveItems = GiveItems;
		}
		else if (Sender == Controls[3])
		{
			Controller.OpenMenu(string(class'DruidsRPGSellComboConfirmPage'));
			DruidsRPGSellComboConfirmPage(Controller.TopPage()).StatsMenu = StatsMenu;
			DruidsRPGSellComboConfirmPage(Controller.TopPage()).GiveItems = GiveItems;
		}
		else
			Controller.CloseMenu(false);
	}

	return true;
}

function MyOnClose(optional bool bCanceled)
{
	StatsMenu = None;
	GiveItems = None;

	Super.OnClose(bCanceled);
}

defaultproperties
{
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
     Controls(0)=GUIButton'DEKRPG208AH.DruidsRPGRefundOptionPage.QuitBackground'

     Begin Object Class=GUIButton Name=RefundAbilityButton
         Caption="Refund Abilities"
         WinTop=0.200000
         WinLeft=0.385000
         WinWidth=0.250000
         bBoundToParent=True
         OnClick=DruidsRPGRefundOptionPage.InternalOnClick
         OnKeyEvent=RefundAbilityButton.InternalOnKeyEvent
     End Object
     Controls(1)=GUIButton'DEKRPG208AH.DruidsRPGRefundOptionPage.RefundAbilityButton'

     Begin Object Class=GUIButton Name=RefundNicheButton
         Caption="Refund Niches"
         WinTop=0.52750000
         WinLeft=0.385000
         WinWidth=0.250000
         bBoundToParent=True
         OnClick=DruidsRPGRefundOptionPage.InternalOnClick
         OnKeyEvent=RefundNicheButton.InternalOnKeyEvent
     End Object
     Controls(2)=GUIButton'DEKRPG208AH.DruidsRPGRefundOptionPage.RefundNicheButton'
	 
     Begin Object Class=GUIButton Name=RefundComboButton
         Caption="Refund Combos"
         WinTop=0.855000
         WinLeft=0.385000
         WinWidth=0.250000
         bBoundToParent=True
         OnClick=DruidsRPGRefundOptionPage.InternalOnClick
         OnKeyEvent=RefundComboButton.InternalOnKeyEvent
     End Object
     Controls(3)=GUIButton'DEKRPG208AH.DruidsRPGRefundOptionPage.RefundComboButton'

     Begin Object Class=GUIButton Name=CloseButton
         Caption="Close"
         WinTop=0.6150000
         WinLeft=0.650000
         WinWidth=0.200000
         bBoundToParent=True
         OnClick=DruidsRPGRefundOptionPage.InternalOnClick
         OnKeyEvent=CloseButton.InternalOnKeyEvent
     End Object
     Controls(4)=GUIButton'DEKRPG208AH.DruidsRPGRefundOptionPage.CloseButton'	

     WinTop=0.375000
     WinHeight=0.250000
}
