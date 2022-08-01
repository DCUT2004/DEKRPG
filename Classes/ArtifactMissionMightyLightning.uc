class ArtifactMissionMightyLightning extends ArtifactMissionBETA
		config(UT2004RPG);

defaultproperties
{
	 ObjectiveClasses(0)=Class'XWeapons.DamTypeSniperShot'
	 ObjectiveClasses(1)=Class'XWeapons.DamTypeSniperHeadShot'
	 TickAmount=1
     XPReward=30
     MissionGoal=100
     Description="Use the Lightning Gun."
     PickupClass=Class'DEKRPG999X.ArtifactMissionMightyLightningPickup'
     IconMaterial=Texture'MissionsTex6.WeaponMissions.MissionLightningGun'
     ItemName="Mighty Lightning"
}
