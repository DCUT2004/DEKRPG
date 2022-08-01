class ArtifactMissionLinkLunatic extends ArtifactMissionBETA
		config(UT2004RPG);

defaultproperties
{
	 ObjectiveClasses(0)=Class'XWeapons.DamTypeLinkPlasma'
	 ObjectiveClasses(1)=Class'XWeapons.DamTypeLinkShaft'
	 TickAmount=1
     XPReward=30
     MissionGoal=500
     Description="Use the Link Gun."
     PickupClass=Class'DEKRPG999X.ArtifactMissionLinkLunaticPickup'
     IconMaterial=Texture'MissionsTex6.WeaponMissions.MissionLinkGun'
     ItemName="Link Lunatic"
}
