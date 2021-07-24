class NecromancerBloodWeaponAltFireMessage extends Localmessage;

var(Message) localized string Message;

////////////////////////////////////////////////////////////////////////////////

var(Message) color RedColor;

static function color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
		return Default.RedColor;
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
		return switch @ default.Message;
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
     Message="blood points required to use this and while chaining to a target."
     RedColor=(R=255,A=255)
     bIsUnique=True
     bIsPartiallyUnique=True
     bFadeMessage=True
     Lifetime=4
     PosY=0.700000
}
