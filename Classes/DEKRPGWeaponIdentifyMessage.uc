class DEKRPGWeaponIdentifyMessage extends LocalMessage;

var(Message) localized string IdentifyString, PickupString;

static function ClientReceive( PlayerController P, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
			       optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject )
{
	if (DEKRPGWeapon(OptionalObject) != None && DEKRPGWeapon(OptionalObject).ModifiedWeapon != None)
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

static function color GetConsoleColor( PlayerReplicationInfo RelatedPRI_1 )
{
    return class'HUD'.Default.WhiteColor;
}

static function string GetString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1,
				 optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	DEKRPGWeapon(OptionalObject).ConstructItemName();

	if (Switch == 0)
		return default.IdentifyString@DEKRPGWeapon(OptionalObject).ItemName$"!";
	else
		return default.PickupString@DEKRPGWeapon(OptionalObject).ItemName$".";
}

defaultproperties
{
     IdentifyString="Your weapon is a"
     PickupString="You got the"
     bIsUnique=True
     bFadeMessage=True
     PosY=0.800000
}
