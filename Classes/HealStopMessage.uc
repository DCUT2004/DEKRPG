class HealStopMessage extends LocalMessage;

var localized string HealStopMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	return default.HealStopMessage;
}

defaultproperties
{
     HealStopMessage="Heal Stop"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(B=0,G=0,R=255)
     PosY=0.800000
}
