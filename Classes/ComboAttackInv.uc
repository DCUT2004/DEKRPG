class ComboAttackInv extends ComboEffectInv;

var class<xEmitter> EffectDownxEmitterClass;
var xEmitter EffectDownxEmitter;

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local RW_MagicalWard W;
	local MagicalWardProtectionInv MWInv;
	
	if (Other != None)
		PawnOwner = Other;
	
	if (EffectMultiplier > 1.0)
		bBuff = True;
	else if (EffectMultiplier < 1.0)
		bBuff = False;
		
	if (Other != None && Other.Weapon != None && Other.Weapon.IsA('RW_MagicalWard') && !bBuff)
	{
		W = RW_MagicalWard(Other.Weapon);
		if (Rand(100) <= W.Modifier*W.ChanceToWardPerModifier)
		{
			MWInv = MagicalWardProtectionInv(Other.FindInventoryType(class'MagicalWardProtectionInv'));
			if (MWInv == None)
			{
				MWInv = Other.Spawn(Class'MagicalWardProtectionInv');
				MWInv.GiveTo(Other);
			}
			else
			{
				MWInv.Lifespan = MWInv.default.Lifespan;
				MWInv.ProtectionMultiplier -= MWInv.ProtectionPerWardMultiplier;
				if (MWInv.ProtectionMultiplier < MWInv.MaxProtectionMultiplier)
					MWInv.ProtectionMultiplier = MWInv.MaxProtectionMultiplier;
			}
			Destroy();
			return;
		}
	}
	default.EffectMultiplier = EffectMultiplier;	//"Initialize" for static GetLocalString function
	if (Other != None)
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	Super.GiveTo(Other);
}

function Timer()
{
	if (EffectMultiplier > 1.0)
	{
		bBuff = True;
	}
	else if (EffectMultiplier < 1.0)
	{
		bBuff = False;
	}
		
	if (PawnOwner != None)
	{
		//if (Vehicle(PawnOwner) != None)
		//	PawnOwner = Vehicle(PawnOwner).Driver;
		if (EffectMultiplier < 1.0 && EffectDownxEmitter == None)
		{
			EffectDownxEmitter = PawnOwner.Spawn(EffectDownxEmitterClass, PawnOwner,,PawnOwner.Location);
			if (EffectDownxEmitter != None)
			{
				EffectDownxEmitter.bHardAttach = True;
				EffectDownxEmitter.SetBase(PawnOwner);
				EffectDownxEmitter.mSizeRange[0] = PawnOwner.CollisionRadius * 0.05;
				EffectDownxEmitter.mSizeRange[1] =1.571 * PawnOwner.CollisionRadius * 0.05;
			}
			if (EffectxEmitter != None)
				EffectxEmitter.Destroy();
		}
		else if (EffectMultiplier >1.0 && EffectxEmitter == None)
		{
			Log("In attack up");
			EffectxEmitter = PawnOwner.Spawn(EffectxEmitterClass, PawnOwner,,PawnOwner.Location);
			if (EffectxEmitter != None)
			{
				EffectxEmitter.bHardAttach = True;
				EffectxEmitter.SetBase(PawnOwner);
				EffectxEmitter.mSizeRange[0] = PawnOwner.CollisionRadius * 0.05;
				EffectxEmitter.mSizeRange[1] =1.571 * PawnOwner.CollisionRadius * 0.05;
			}
			if (EffectDownxEmitter != None)
				EffectDownxEmitter.Destroy();
		}
		else if (EffectMultiplier == 1.0)
		{
			if (EffectDownxEmitter != None)
				EffectDownxEmitter.Destroy();
			if (EffectxEmitter != None)
				EffectxEmitter.Destroy();
		}
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	local int Percent;
	
	Percent = abs((default.EffectMultiplier - 1)*100);
	if (default.EffectMultiplier > 1.0)
		return Default.ComboNameMessage $ "+ " $ Percent $ "% for " $ Switch $ Default.SecondsMessage;
	else if (default.EffectMultiplier < 1.0)
		return Default.ComboNameMessage $ "- " $ Percent $ "% for " $ Switch $ Default.SecondsMessage;
	else
		return Super.GetLocalString(Switch, RelatedPRI_1, RelatedPRI_2);
}

simulated function Destroyed()
{
	if (EffectxEmitter != None)
		EffectxEmitter.Destroy();
	if (EffectDownxEmitter != None)
		EffectDownxEmitter.Destroy();
	Super.Destroyed();
}

defaultproperties
{
	 ComboNameMessage="Attack: "
     EffectDownxEmitterClass=Class'DEKRPG208AB.ComboAttackDownEffect'
     EffectxEmitterClass=Class'DEKRPG208AB.ComboAttackUpEffect'
}
