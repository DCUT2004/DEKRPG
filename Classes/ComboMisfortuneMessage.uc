class ComboMisfortuneMessage extends LocalMessage;

var localized string ComboMessage, Seconds;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	return Default.ComboMessage $ Switch $ default.Seconds;
}

defaultproperties
{
     ComboMessage="Misfortune: "
	 Seconds=" seconds"
     bIsUnique=True
     bIsConsoleMessage=True
}
