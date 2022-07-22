class ComboJinxInv extends ComboEffectInv
	config(UT2004RPG);

var float TimeRemaining;
var config float TargetRadius;
var class<xEmitter> HitEmitterClass;        // for standard defense sentinel

function GiveTo(Pawn Other, optional Pickup Pickup)
{
	local DEKRPGWeapon DW;
	local MagicalWardProtectionInv MWInv;
	local ComboWardInv WardInv;
	
	bBuff = False;
	
	if (Other != None)
	{
		WardInv = ComboWardInv(Other.FindInventoryType(Class'ComboWardInv'));
		if (WardInv != None && Rand(100) <= WardInv.EffectMultiplier)
		{
			if (Other.Controller != None && PlayerController(Other.Controller) != None)
				PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG999X.ComboSounds.Ward');
			Destroy();
			return;
		}

		if (Other.Weapon != None && Other.Weapon.IsA('DEKRPGWeapon') && !bBuff)
		{
            DW = (DEKRPGWeapon(Other.Weapon));
    		if (DW.HasThisAddon(class'MagicalWardAddonPowerType'))
    		{
    			if (Rand(100) <= DW.GetModifier() * class'MagicalWardAddonPowerType'.default.ChanceToWardPerModifier)
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
    				if (Other.Controller != None && PlayerController(Other.Controller) != None)
    					PlayerController(Other.Controller).ClientPlaySound(Sound'DEKRPG999X.ComboSounds.Ward');
    				Destroy();
    				return;
    			}
    		}
        }
	}
	TimeRemaining = Lifespan;
	SetTimer(EffectMultiplier, True);
	Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	Super.GiveTo(Other);
}

simulated function Timer()
{
	// lets target some enemies
	local Projectile P;
	local xEmitter HitEmitter;
	local Projectile ClosestP;
	local Projectile BestGuidedP;
	local Projectile BestP;
	local int ClosestPdist;
	local int BestGuidedPdist;

	if (PawnOwner != None)
	{
		// look for projectiles in range
		ClosestP = None;
		BestGuidedP = None;
		ClosestPdist = TargetRadius+1;
		BestGuidedPdist = TargetRadius+1;
		ForEach DynamicActors(class'Projectile',P)
		{
			if (P != None && FastTrace(P.Location, PawnOwner.Location) && TranslocatorBeacon(P) == None && UntargetedProjectile(P) == None && UntargetedSeekerProjectile(P) == None && DEKLightningTurretProj(P) == None && VSize(PawnOwner.Location - P.Location) <= TargetRadius)
			{
				if ((P.InstigatorController == None ||
					(P.InstigatorController != None &&
						((TeamGame(Level.Game) != None && P.InstigatorController.SameTeamAs(PawnOwner.Controller))	// same team
						 || (TeamGame(Level.Game) == None && P.InstigatorController != PawnOwner)))))	// or just me
				{
					// its an friendly projectile
					// we prefer to target a server guided projectile, so it can be destroyed client side as well
					// otherwise just go for the closest
					if ( BestGuidedPdist > VSize(PawnOwner.Location - P.Location) && P.bNetTemporary == false && !P.bDeleteMe)
					{
						BestGuidedP = P;
						BestGuidedPdist = VSize(PawnOwner.Location - P.Location);
					}
					if ( ClosestPdist > VSize(PawnOwner.Location - P.Location) && !P.bDeleteMe)
					{
						ClosestP = P;
						ClosestPdist = VSize(PawnOwner.Location - P.Location);
					}

				}
			}
		}
		if (BestGuidedP != None)
			BestP = BestGuidedP;
		else
			BestP = ClosestP;

		if (BestP != None && !BestP.bDeleteMe)
		{
			HitEmitter = spawn(HitEmitterClass,,, PawnOwner.Location, rotator(BestP.Location - PawnOwner.Location));
			if (HitEmitter != None)
				HitEmitter.mSpawnVecA = BestP.Location;

			BestP.NetUpdateTime = Level.TimeSeconds - 1;
			BestP.bHidden = true;
			if (BestP.Physics != PHYS_None)	// to stop attacking an exploding redeemer
			{
				// destroy it
				BestP.Explode(BestP.Location,vect(0,0,0));
			}
		}
	}
	TimeRemaining -= EffectMultiplier;
	if (TimeRemaining <= 0)
	{
		Destroy();
		return;
	}
	Super.Timer();
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return Default.ComboNameMessage $ Switch $ Default.SecondsMessage;
}

simulated function Destroyed()
{
	local Controller C, NextC;
	local ComboJinxInv Inv;
	//Seek a new target to Curse
	
	if (TimeRemaining > 1)
	{
		C = Level.ControllerList;
		while (C != None)
		{
			NextC = C.NextController;
			if (C != None && C.Pawn != None && C.Pawn.Health > 0 && C.Pawn.GetTeamNum() == PawnOwner.GetTeamNum() && !C.Pawn.IsA('HealerNali') && !C.Pawn.IsA('MissionCow') && !C.Pawn.IsA('TarydiumCrystal'))
			{
				Inv = ComboJinxInv(C.Pawn.FindInventoryType(Class'ComboJinxInv'));
				if (Inv == None)
				{
					Inv = C.Pawn.Spawn(Class'ComboJinxInv');
					Inv.EffectMultiplier = EffectMultiplier;
					Inv.Lifespan = TimeRemaining;
					Inv.Enemy = Enemy;
					Inv.GiveTo(C.Pawn);
					break;
				}
			}
			C = NextC;
		}
	}
	super.destroyed();
}

defaultproperties
{
     HitEmitterClass=Class'DEKRPG999X.RedBoltEmitter'
	 TargetRadius=750.000
	 bBuff=False
	 ComboNameMessage="- Jinx: "
	 EffectxEmitterClass=Class'DEKRPG999X.ComboJinxFX'
}
