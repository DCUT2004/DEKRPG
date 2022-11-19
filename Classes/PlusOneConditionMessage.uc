//This message is sent to players who have their weapon plus one'd
class PlusOneConditionMessage extends LocalMessage;

var localized string MaxedMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if(RelatedPRI_1 == None)
		return "";
	return (default.MaxedMessage @ RelatedPRI_1.PlayerName);
}

defaultproperties
{
     MaxedMessage="Your weapon modifier has been increased by"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=2
     DrawColor=(G=0,R=0)
     PosY=0.750000
}
