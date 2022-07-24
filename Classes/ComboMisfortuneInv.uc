class ComboMisfortuneInv extends ComboEffectInv;

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
		
		Other.ReceiveLocalizedMessage(MessageClass, Lifespan, None, None, Class);
	}
	SetTimer(0.1, True);
	Super.GiveTo(Other);
}

simulated function Timer()
{
	local Pickup P;
	local Actor A;
	
	
	if (Role == ROLE_Authority)
	{
		if (PawnOwner == None || PawnOwner.Health <= 0)
		{
			Destroy();
			return;
		}
		
		if(!class'DEKRPGWeapon'.static.NullCanTriggerPhysics(PawnOwner))
		{
			return;
		}
		if (PawnOwner != None)
		{
			foreach PawnOwner.CollidingActors(class'Pickup', P, EffectMultiplier)
			if ( P.ReadyToPickup(0) && WeaponLocker(P) == None )
			{
				A = spawn(class'RocketExplosion',,, P.Location);
				if (A != None)
				{
					A.RemoteRole = ROLE_SimulatedProxy;
					A.PlaySound(sound'WeaponSounds.BExplosion3',,2.5*P.TransientSoundVolume,,P.TransientSoundRadius);
				}
				if (!P.bDropped && WeaponPickup(P) != None && WeaponPickup(P).bWeaponStay && P.RespawnTime != 0.0)
					P.GotoState('Sleeping');
				else
					P.SetRespawn();
			}
			PawnOwner.ReceiveLocalizedMessage(class'MisfortuneMessage');
		}
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	return Default.ComboNameMessage $ Switch $ Default.SecondsMessage;
}

defaultproperties
{
	 bBuff=False
	 ComboNameMessage="- Misfortune: "
     bOnlyRelevantToOwner=False
     bAlwaysRelevant=True
     bReplicateInstigator=True
}
