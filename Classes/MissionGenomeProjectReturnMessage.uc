class MissionGenomeProjectReturnMessage extends LocalMessage;

var(Message) localized string LevelUpString;
var(Message) color GreenColor;

static function color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
		return Default.GreenColor;
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	   return Default.LevelUpString;
}

defaultproperties
{
     LevelUpString="Return the vial to the node!"
     GreenColor=(B=66,G=244,R=89,A=255)
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     Lifetime=1
     DrawColor=(B=66,G=244,R=89)
     StackMode=SM_Down
     PosY=0.100000
}
