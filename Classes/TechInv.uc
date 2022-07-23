class TechInv extends Inventory;

var config float NetworkRadius;

static function GiveTechInv(Pawn P)
{
	local TechInv Inv;
	if (P != None)
	{
		Inv = TechInv(P.FindInventoryType(class'TechInv'));
		if (Inv == None)
		{
			Inv = P.Spawn(Class'TechInv');
			Inv.GiveTo(P);
		}
	}
}

static function bool SpreadDamage(Pawn InitialTarget, int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	//Check to see if other tech monsters are nearby when taking damage
	//If there are other nearby tech monsters, divide the damage by the number of tech monsters and distribute the damage equally
	//Otherwise, just take the normal damage
	
	local Controller C, NextC;
	local Array < Pawn > TechMonsters;
	local int x;
	local int NetworkDamage;
    local xEmitter NetworkChain;
	
	if (InitialTarget == None || damageType == Class'DamTypeSharedDamage' || instigatedBy == None || instigatedBy.Weapon == None)
		return false;
	
	if (DEKRPGWeapon(instigatedBy.Weapon) != None && DEKRPGWeapon(instigatedBy.Weapon).HasThisAddon(class'WaterfallAddonPowerType'))
        return false;
    
	TechMonsters.Length = 0;
	TechMonsters.Insert(0, 1);	//Insert 1 Monster element at index 0
	TechMonsters[0] = InitialTarget;
	x = 1;
	
	C = instigatedBy.Level.ControllerList;
	
	while (C != None)
	{
		NextC = C.NextController;
		if (C != None && C.Pawn != None && C.Pawn.Health > 0 && InitialTarget != None && C.Pawn != InitialTarget &&  C.Pawn.GetTeamNum() == InitialTarget.GetTeamNum() && TechInv(C.Pawn.FindInventoryType(Class'TechInv')) != None && VSize(C.Pawn.Location - InitialTarget.Location) <= default.NetworkRadius && C.Pawn.FastTrace(C.Pawn.Location, InitialTarget.Location))
		{
			TechMonsters[x] = C.Pawn;
			x++;
		}
		C = NextC;
	}
	
	if (TechMonsters.Length > 1)	//We have an additional tech monster besides InitialTarget that we can split the damage with
	{
		NetworkDamage = Damage/TechMonsters.Length;
		if (NetworkDamage < 1)
			NetworkDamage = 1;
		for (x = 0; x < TechMonsters.Length; x++)
		{
			TechMonsters[x].TakeDamage(NetworkDamage, instigatedBy, TechMonsters[x].Location, Vect(0,0,0), Class'DamTypeSharedDamage');

			NetworkChain = InitialTarget.Spawn(class'TechNetworkChain',InitialTarget,,InitialTarget.Location,rotator(InitialTarget.Location - TechMonsters[x].Location));
			if (NetworkChain != None)
			{
				NetworkChain.mSpawnVecA = TechMonsters[x].Location;
				NetworkChain.SetRotation(rotator(TechMonsters[x].Location - InitialTarget.Location));
				NetworkChain.SetBase(InitialTarget);
			}
		}
        return true;
	}
    
    return false;
}


defaultproperties
{
	 NetworkRadius=1000.0000
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
