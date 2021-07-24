class BonusWaveMessage extends Localmessage;

var(Message) localized string BonusMessage;

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	return default.BonusMessage;
}

defaultproperties
{
     BonusMessage="Bonus Wave is now unlocked!"
     bIsUnique=True
     bIsPartiallyUnique=True
     bFadeMessage=True
     Lifetime=7
     DrawColor=(B=244,G=168,R=216)
     StackMode=SM_Down
     PosY=0.150000
}
