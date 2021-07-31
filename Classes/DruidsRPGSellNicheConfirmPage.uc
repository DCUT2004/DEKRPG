//Confirm the player really, really wants to sell all his niche abilities
class DruidsRPGSellNicheConfirmPage extends GUIPage;

var DruidsRPGStatsMenu StatsMenu;
var GiveItemsInv GiveItems;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

	OnClose=MyOnClose;
}

function bool InternalOnClick(GUIComponent Sender)
{
	local GUIController OldController;

	if (Sender==Controls[1] && GiveItems != None)
	{
		OldController = Controller;
		GiveItems.ServerSellData(PlayerOwner().PlayerReplicationInfo,StatsMenu.StatsInv,False,False,True);
		Controller.ViewportOwner.Console.DelayedConsoleCommand("Reconnect");
		Controller.CloseMenu(false);
		OldController.CloseMenu(false);
	}
	else
		Controller.CloseMenu(false);

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
     Controls(0)=GUIButton'DEKRPG208AD.DruidsRPGSellNicheConfirmPage.QuitBackground'

     Begin Object Class=GUIButton Name=YesButton
         Caption="YES"
         WinTop=0.750000
         WinLeft=0.125000
         WinWidth=0.200000
         bBoundToParent=True
         OnClick=DruidsRPGSellNicheConfirmPage.InternalOnClick
         OnKeyEvent=YesButton.InternalOnKeyEvent
     End Object
     Controls(1)=GUIButton'DEKRPG208AD.DruidsRPGSellNicheConfirmPage.YesButton'

     Begin Object Class=GUIButton Name=NoButton
         Caption="NO"
         WinTop=0.750000
         WinLeft=0.650000
         WinWidth=0.200000
         bBoundToParent=True
         OnClick=DruidsRPGSellNicheConfirmPage.InternalOnClick
         OnKeyEvent=NoButton.InternalOnKeyEvent
     End Object
     Controls(2)=GUIButton'DEKRPG208AD.DruidsRPGSellNicheConfirmPage.NoButton'

     Begin Object Class=GUILabel Name=SellDesc
         Caption="This will refund your niche."
         TextAlign=TXTA_Center
         TextColor=(B=0,G=180,R=220)
         TextFont="UT2HeaderFont"
         WinTop=0.400000
         WinHeight=32.000000
     End Object
     Controls(3)=GUILabel'DEKRPG208AD.DruidsRPGSellNicheConfirmPage.SellDesc'

     Begin Object Class=GUILabel Name=SellDesc2
         Caption="You will be automatically reconnected."
         TextAlign=TXTA_Center
         TextColor=(B=0,G=180,R=220)
         TextFont="UT2HeaderFont"
         WinTop=0.450000
         WinHeight=32.000000
     End Object
     Controls(4)=GUILabel'DEKRPG208AD.DruidsRPGSellNicheConfirmPage.SellDesc2'

     Begin Object Class=GUILabel Name=SellDesc3
         Caption="Are you SURE?"
         TextAlign=TXTA_Center
         TextColor=(B=0,G=180,R=220)
         TextFont="UT2HeaderFont"
         WinTop=0.500000
         WinHeight=32.000000
     End Object
     Controls(5)=GUILabel'DEKRPG208AD.DruidsRPGSellNicheConfirmPage.SellDesc3'

     WinTop=0.375000
     WinHeight=0.250000
}
