class LuckAddonPowerType extends AddonPowerType
	config(UT2004RPG);

var config float LuckCheckTime;
var config float ChanceLuckPowerups;
var float NextEffectTime;

simulated event WeaponTick(float dt)
{
	local Pickup P;
	local Actor A;
	local class<Pickup> ChosenClass;
	local vector HitLocation, HitNormal, EndTrace;

	if (Role < ROLE_Authority)
		return;

	NextEffectTime -= dt;
	if (NextEffectTime <= 0)
	{
		if (TheWeapon.GetModifier() < 0)
		{
			foreach TheWeapon.Instigator.CollidingActors(class'Pickup', P, 300)
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
					break;
				}
			NextEffectTime = (1.25 + FRand() * 1.25) / (1 - TheWeapon.GetModifier() );
		}
		else if (TheWeapon.GetModifier() > 0)
		{
			ChosenClass = ChoosePickupClass();
			EndTrace = TheWeapon.Instigator.Location + vector(TheWeapon.Instigator.Rotation) * TheWeapon.Instigator.GroundSpeed;
			if (TheWeapon.Instigator.Trace(HitLocation, HitNormal, EndTrace, TheWeapon.Instigator.Location) != None)
			{
				HitLocation -= vector(TheWeapon.Instigator.Rotation) * 40;
				P = spawn(ChosenClass,,, HitLocation);
			}
			else
				P = spawn(ChosenClass,,, EndTrace);

			if (P == None)
				return;

			if (MiniHealthPack(P) != None)
				MiniHealthPack(P).HealingAmount *= 2;
			else if (AdrenalinePickup(P) != None)
				AdrenalinePickup(P).AdrenalineAmount *= 2;
			P.RespawnTime = 0.0;
			P.bDropped = true;
			P.GotoState('Sleeping');

			NextEffectTime = (Rand(15) + LuckCheckTime) / max(1,TheWeapon.GetModifier());
		}
	}
}

function class<AddonPowerPickup> SelectWeaponPowerup()
{
	local int iSumChance;
	local int q;
	local class<AddonPowerType> PowerType;

	iSumChance = 0;
	for (q = 0; q < TheWeapon.AvailableAddonPowerTypes.Length ; q++) 
		iSumChance += TheWeapon.AvailableAddonPowerTypes[q].LuckChance; 

	for (q = 0; q < TheWeapon.AvailableAddonPowerTypes.Length ; q++) 
		if (Rand(iSumChance) < TheWeapon.AvailableAddonPowerTypes[q].LuckChance)
		{
			PowerType = TheWeapon.AvailableAddonPowerTypes[q].PowerType;
			return PowerType.default.ThisPickupClass;
		}

	// in principle, we should never get here, but due to the non-rand rand (ask Spacey), we will. So try again
	for (q = 0; q < TheWeapon.AvailableAddonPowerTypes.Length ; q++) 
		if (Rand(iSumChance) < TheWeapon.AvailableAddonPowerTypes[q].LuckChance)
		{
			PowerType = TheWeapon.AvailableAddonPowerTypes[q].PowerType;
			return PowerType.default.ThisPickupClass;
		}

	// forget it
	return None;
}

//choose a pickup to spawn, favoring those that are most useful to Instigator
function class<Pickup> ChoosePickupClass()
{
	local array<class<Pickup> > Potentials;
	local Inventory Inv;
	local Weapon W;
	local class<Pickup> AmmoPickupClass;
	local class<AddonPowerPickup> PowerPickup;
	local int i, Count;

	if (TheWeapon.Instigator.Health < TheWeapon.Instigator.HealthMax)
	{
		Potentials[i++] = class'LuckyHealthPack';
		Potentials[i++] = class'LuckyHealthPack';
		Potentials[i++] = class'MiniHealthPack';
	}
	else
	{
		if (TheWeapon.Instigator.Health < TheWeapon.Instigator.HealthMax + 100)
		{
			Potentials[i++] = class'MiniHealthPack';
			Potentials[i++] = class'LuckyHealthPack';
			Potentials[i++] = class'MiniHealthPack';
		}
		if (TheWeapon.Instigator.ShieldStrength < TheWeapon.Instigator.GetShieldStrengthMax())
			Potentials[i++] = class'ShieldPack';
	}
	for (Inv = TheWeapon.Instigator.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		W = Weapon(Inv);
		if (W != None)
		{
			if (W.NeedAmmo(0))
			{
				AmmoPickupClass = W.AmmoPickupClass(0);
				if (AmmoPickupClass != None)
					Potentials[i++] = AmmoPickupClass;
			}
			else if (W.NeedAmmo(1))
			{
				AmmoPickupClass = W.AmmoPickupClass(1);
				if (AmmoPickupClass != None)
					Potentials[i++] = AmmoPickupClass;
			}
		}
		Count++;
		if (Count > 1000)
			break;
	}
    
	if (FRand() < 0.012 * TheWeapon.GetModifier())
		Potentials[i++] = class'UDamagePack';
	if (FRand() < 0.012 * TheWeapon.GetModifier())
		Potentials[i++] = class'ArtifactLetterBPickup';
        
	if ((ChanceLuckPowerups>0) && (FRand() < (ChanceLuckPowerups * TheWeapon.GetModifier())) )
	{
		PowerPickup = SelectWeaponPowerup();
		if (PowerPickup != None)
        {
			Potentials[i++] = PowerPickup;

        }
	}
	if (i == 0 || (TheWeapon.Instigator.Controller != None && TheWeapon.Instigator.Controller.Adrenaline < TheWeapon.Instigator.Controller.AdrenalineMax))
    {
		Potentials[i++] = class'DruidAdrenalinePickup';
    	Potentials[i++] = class'AdrenalinePickup';
    	Potentials[i++] = class'AdrenalinePickup';
    	Potentials[i++] = class'LuckyAdrenalinePickup';
    	Potentials[i++] = class'LuckyAdrenalinePickup';
    }

	Potentials[i++] = class'ArtifactPlusAddonPickup';
	Potentials[i++] = class'DruidArtifactMakeMagicWeaponPickup';
	Potentials[i++] = class'DruidArtifactTripleDamagePickup';
	Potentials[i++] = class'DruidEnhancedArtifactMonsterSummonPickup';	

    // and some others just to make the numbers up
    Potentials[i++] = class'AdrenalinePickup';
	Potentials[i++] = class'LuckyHealthPack';

	return Potentials[Rand(i)];
}

function bool CanCoexist( class<AddonPowerType> NewType )
{
	if (!Super.CanCoexist(NewType ))
		return false;

	if (NewType == class'LuckAddonPowerType')	// double gets complicated
		return false;
    
	return true;
}

defaultproperties
{
	LuckCheckTime=25
	ChanceLuckPowerups=0.02
	NextEffectTime=20
	PosName="Luck"
	ZeroName="Luck"
	NegName="Misfortune"
	CanHaveZeroModifier=false
	CanHaveNegativeModifier=false	// do not allow misfortune by default
	AIBonus=0.1
	PowerOverlay=FinalBlend'MutantSkins.Shaders.MutantGlowFinal'
	ThisPickupClass=Class'LuckAddonPowerPickup'
}

