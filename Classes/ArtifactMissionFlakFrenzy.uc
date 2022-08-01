class ArtifactMissionFlakFrenzy extends ArtifactMissionBETA
		config(UT2004RPG);

defaultproperties
{
	 ObjectiveClasses(0)=Class'XWeapons.DamTypeFlakChunk'
	 ObjectiveClasses(1)=Class'XWeapons.DamTypeFlakShell'
	 TickAmount=1
     XPReward=30
     MissionGoal=700
     Description="Use the Flak Cannon."
     PickupClass=Class'DEKRPG999X.ArtifactMissionFlakFrenzyPickup'
     IconMaterial=Texture'MissionsTex6.WeaponMissions.MissionFlakCannon'
     ItemName="Flak Frenzy"
}
