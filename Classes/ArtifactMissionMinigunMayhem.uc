class ArtifactMissionMinigunMayhem extends ArtifactMissionBETA
		config(UT2004RPG);

defaultproperties
{
	 ObjectiveClasses(0)=Class'XWeapons.DamTypeMinigunAlt'
	 ObjectiveClasses(1)=Class'XWeapons.DamTypeMinigunBullet'
	 TickAmount=1
     XPReward=30
     MissionGoal=900
     Description="Use the Minigun."
     PickupClass=Class'DEKRPG999X.ArtifactMissionMinigunMayhemPickup'
     IconMaterial=Texture'MissionsTex6.WeaponMissions.MissionMiniGun'
     ItemName="Minigun Mayhem"
}
