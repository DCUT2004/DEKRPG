class MissionPortalBall extends Pawn;

event EncroachedBy( actor Other )
{
	// do nothing. Adding this stub stops telefragging
}

defaultproperties
{
     bCanBeBaseForPawns=True
     bNoTeamBeacon=True
     AirSpeed=100.000000
     AccelRate=1000.000000
     HealthMax=99999.000000
     Health=99999
     ControllerClass=None
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'Editor.TexPropSphere'
     bOrientOnSlope=True
     bAlwaysRelevant=True
     bIgnoreVehicles=True
     Physics=PHYS_Falling
     NetUpdateFrequency=4.000000
     DrawScale=0.200000
     Skins(0)=Texture'MissionsTex6.Colors.Yellow'
     AmbientGlow=10
     bCanBeDamaged=False
     bShouldBaseAtStartup=False
     CollisionRadius=29.500000
     CollisionHeight=25.000000
     bBlockPlayers=True
     bUseCollisionStaticMesh=True
     bBounce=True
     Mass=50.000000
}
