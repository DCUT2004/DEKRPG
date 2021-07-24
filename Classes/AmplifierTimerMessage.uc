class AmplifierTimerMessage extends LocalMessage;

var(Message) localized string LevelUpString;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	   return Default.LevelUpString @ switch;
}

defaultproperties
{
     LevelUpString="Magic Amplifier:"
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=244,G=66,R=203)
     StackMode=SM_Down
     PosY=0.100000
}
