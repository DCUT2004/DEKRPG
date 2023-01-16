class Altar_IceMessage extends LocalMessage;

var localized string Message;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	return default.Message $ " : " $ Switch $ "/3 Geodes";
}

defaultproperties
{
     Message="Ice Altar"
	 StackMode=SM_Down
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(R=0,B=255,G=128)
     PosY=0.800000
	 Lifetime=2
}
