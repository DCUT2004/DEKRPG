class ReviveMessage extends Localmessage;

var(Message) localized string ReviveMessage;

////////////////////////////////////////////////////////////////////////////////

var(Message) color RedColor;

static function color GetColor(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
		return Default.RedColor;
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo PRI1, optional PlayerReplicationInfo PRI2, optional Object OptionalObject)
{
	if (Switch == 0)
	{
		return default.ReviveMessage @ PRI1.PlayerName;
	}
}

////////////////////////////////////////////////////////////////////////////////

defaultproperties
{
     ReviveMessage="You have resurrected"
     RedColor=(R=255,A=255)
     bIsUnique=True
     bIsPartiallyUnique=True
     bFadeMessage=True
     Lifetime=7
     PosY=0.150000
}
