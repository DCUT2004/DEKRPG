class ArtifactMissionBioBerserk extends ArtifactMission
		config(UT2004RPG);

function Activate()
{
	local MissionInvBETA MissionInv;
	
	if (Instigator == None || Instigator.Controller == None)
		return;
		
	MissionInv = class'MissionInvBETA'.static.GetMissionInv(Instigator.Controller);
	
	if (MissionInv == None)
		return;
	if (!MissionInv.SetMission(ItemName, MissionGoal, XPReward, 1, Class'XWeapons.DamTypeBioGlob'))
	{
		Instigator.ReceiveLocalizedMessage(MessageClass, 2000, None, None, Class);
		bActive = false;
		GotoState('');
		return;
	}
	
	Instigator.ReceiveLocalizedMessage(MessageClass, 7000, None, None, Class);
	if (PlayerController(Instigator.Controller) != None)
	PlayerController(Instigator.Controller).ClientPlaySound(Sound'AssaultSounds.HumanShip.HnShipFireReadyl01');
	SetTimer(0.2,True);
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 1000)
		return "Cannot access mission.";
	else if (Switch == 2000)
		return "You currently have too many active missions.";
	else if (Switch == 3000)
		return "Mission activated!";
	if (Switch == 4000)
		return "Mission is already active.";
	else if (Switch == 5000)
		return "Mission forfeited.";
	else if (Switch == 6000)
		return "Mission already completed.";
	else if (Switch == 7000)
		return "Use the Bio Rifle.";
}

defaultproperties
{
     XPReward=30
     MissionGoal=300
     Description="Use the Bio Rifle."
     PickupClass=Class'DEKRPG999X.ArtifactMissionBioBerserkPickup'
     IconMaterial=Texture'MissionsTex6.WeaponMissions.MissionBioRifle'
     ItemName="Bio Berserk"
}
