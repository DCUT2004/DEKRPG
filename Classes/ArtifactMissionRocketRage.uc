class ArtifactMissionRocketRage extends ArtifactMissionBETA
		config(UT2004RPG);

defaultproperties
{
	 ObjectiveClasses(0)=Class'XWeapons.DamTypeRocket'
	 ObjectiveClasses(1)=Class'XWeapons.DamTypeRocketHoming'
	 TickAmount=1
     XPReward=30
     MissionGoal=300
     Description="Use the Rocket Launcher."
     PickupClass=Class'DEKRPG999X.ArtifactMissionRocketRagePickup'
     IconMaterial=Texture'MissionsTex6.WeaponMissions.MissionRocketLauncher'
     ItemName="Rocket Rage"
}
