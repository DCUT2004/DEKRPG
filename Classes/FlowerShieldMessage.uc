class FlowerShieldMessage extends LocalMessage;

var localized string HealedMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	return default.HealedMessage;
}

defaultproperties
{
     HealedMessage="Shield Regen"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(B=0)
     StackMode=SM_Down
     PosY=0.700000
}
