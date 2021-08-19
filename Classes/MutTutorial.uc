class MutTutorial extends Mutator
	config(UT2004RPG);

function ModifyPlayer(Pawn Other)
{
	local TutorialInv TutInv;
	
	Super.ModifyPlayer(Other);
	
	if (Other != None && Other.Controller != None)
	{
		Log("Executing MutTutorial");
			
		TutInv = TutorialInv(Other.FindInventoryType(Class'TutorialInv'));
		if (TutInv == None)
		{
			TutInv = Other.Spawn(class'TutorialInv');
			TutInv.GiveTo(Other);
		}
	}
}

defaultproperties
{
     bAddToServerPackages=True
     GroupName="LowLevelTutorial"
     FriendlyName="Low Level Tutorial"
     Description="Provides invulnerability to low level players."
     bAlwaysRelevant=True
}
