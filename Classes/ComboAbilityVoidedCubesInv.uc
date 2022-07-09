//The combo that the player has purchased
class ComboAbilityVoidedCubesInv extends ComboAbilityInv
	config(UT2004RPG);
	
#exec  AUDIO IMPORT NAME="VoidedCube" FILE="Sounds\VoidedCube.WAV" GROUP="ComboSounds"
	
function DoEffect()
{
	local Controller C;
	local VoidedCube Cube;
	local NavigationPoint Dest;
	local int x, y;
	
	if (Owner != None && Pawn(Owner) != None && Pawn(Owner).Controller != None)
	{
		for (x = 0; x < 3; x++)
		{
			Dest = Pawn(Owner).Controller.FindRandomDest();
			//Attempt to spawn Voided Cube
			
			Cube = Pawn(Owner).Spawn(Class'VoidedCube',,, Dest.Location);
			
			if (Cube == None)	//Failed to spawn.. pick a new location and try several more times
			{
				for (y = 0; y < 20; y++)
				{
					Dest = Pawn(Owner).Controller.FindRandomDest();
					Cube = Pawn(Owner).Spawn(Class'VoidedCube',,, Dest.Location);
					if (Cube != None)
						break;
				}
			}
			if (Cube != None)
			{
				Cube.PawnOwner = Pawn(Owner);
				Cube.AdrenAmount = int(EffectMultiplier);
			}
		}
		if (Pawn(Owner).PlayerReplicationInfo != None)
			Level.Game.Broadcast(self, Pawn(Owner).PlayerReplicationInfo.PlayerName $ " casted Voided Cubes!");
		for ( C = Level.ControllerList; C != None; C = C.NextController )
			if (C != None && C.Pawn != None && C.IsA('PlayerController') && Pawn(Owner) != None && Pawn(Owner).Controller != None && C.SameTeamAs(Pawn(Owner).Controller))
				PlayerController(C).ClientPlaySound(Sound'DEKRPG209F.ComboSounds.VoidedCube');
	}
}

defaultproperties
{
}
