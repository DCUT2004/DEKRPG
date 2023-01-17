//This message is sent to the player informing him of the weapon proficiency
class ProficiencyMessage extends LocalMessage;

var localized string ProfMessage1,ProfMessage2;

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
    local string bonus;
    if (switch >= 0)
        bonus = "+" $ Switch $ "%";
    else
        bonus = Switch $ "%";
	if(OptionalObject == None || Weapon(OptionalObject) == None)
		return (default.ProfMessage1 @ default.ProfMessage2 $ bonus);
	return (Weapon(OptionalObject).Class.default.ItemName @ default.ProfMessage2 $ bonus);
}

defaultproperties
{
     ProfMessage1="Proficiency: "
     ProfMessage2="has a proficiency bonus of "
     bIsUnique=True
     bIsConsoleMessage=False
     bFadeMessage=True
     DrawColor=(B=198,G=32,R=32)
     PosY=0.880000
}
