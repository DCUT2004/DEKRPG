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

			NextEffectTime = (Rand(15) + LuckCheckTime) / (PerformanceIncrease * max(1,TheWeapon.GetModifier()));
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
    local bool AddedSomethingUseful;
    local float AdjustmentFactor;

    AddedSomethingUseful = false;
	if (TheWeapon.Instigator.Health < TheWeapon.Instigator.HealthMax)
	{
		Potentials[i++] = class'LuckyHealthPack';
		Potentials[i++] = class'LuckyHealthPack';
		Potentials[i++] = class'LuckyHealthPack';
		Potentials[i++] = class'MiniHealthPack';
        AddedSomethingUseful = true;
	}
	else
	{
		if (TheWeapon.Instigator.Health < TheWeapon.Instigator.HealthMax + 100)
		{
			Potentials[i++] = class'MiniHealthPack';
			Potentials[i++] = class'LuckyHealthPack';
			Potentials[i++] = class'MiniHealthPack';
            AddedSomethingUseful = true;
		}
	}
    
	if (TheWeapon.Instigator.ShieldStrength < TheWeapon.Instigator.GetShieldStrengthMax())
    {
		Potentials[i++] = class'ShieldPack';
        AddedSomethingUseful = true;
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
                {
					Potentials[i++] = AmmoPickupClass;
                    AddedSomethingUseful = true;
                }
			}
			else if (W.NeedAmmo(1))
			{
				AmmoPickupClass = W.AmmoPickupClass(1);
				if (AmmoPickupClass != None)
                {
					Potentials[i++] = AmmoPickupClass;
                    AddedSomethingUseful = true;
                }
			}
		}
		Count++;
		if (Count > 1000)
			break;
	}
    
	if (TheWeapon.Instigator.Controller != None && TheWeapon.Instigator.Controller.Adrenaline < TheWeapon.Instigator.Controller.AdrenalineMax)
    {
		Potentials[i++] = class'DruidAdrenalinePickup';
    	Potentials[i++] = class'AdrenalinePickup';
    	Potentials[i++] = class'LuckyAdrenalinePickup';
    	Potentials[i++] = class'LuckyAdrenalinePickup';
        AddedSomethingUseful = true;
    }

    // if we have added something useful to the player, let's not then add too much junk     
    if (AddedSomethingUseful)
    {
        AdjustmentFactor = 0.8;
    }
    else
    {
        AdjustmentFactor = 2.5;
    }
            
	if (FRand() < (ChanceLuckPowerups * PerformanceIncrease * TheWeapon.GetModifier() * AdjustmentFactor) )
	{
		PowerPickup = SelectWeaponPowerup();
		if (PowerPickup != None)
        {
			Potentials[i++] = PowerPickup;
        }
	}
    
	if (FRand() < 0.003 * TheWeapon.GetModifier() * AdjustmentFactor)
		Potentials[i++] = class'ArtifactLetterBPickup';
	if (FRand() < 0.003 * TheWeapon.GetModifier() * AdjustmentFactor)
		Potentials[i++] = class'ArtifactLetterOPickup';
	if (FRand() < 0.003 * TheWeapon.GetModifier() * AdjustmentFactor)
		Potentials[i++] = class'ArtifactLetterNPickup';
	if (FRand() < 0.003 * TheWeapon.GetModifier() * AdjustmentFactor)
		Potentials[i++] = class'ArtifactLetterUPickup';
	if (FRand() < 0.003 * TheWeapon.GetModifier() * AdjustmentFactor)
		Potentials[i++] = class'ArtifactLetterSPickup';

	if (FRand() < 0.06 * TheWeapon.GetModifier() * AdjustmentFactor * PerformanceIncrease)
		Potentials[i++] = class'UDamagePack';
	if (FRand() < 0.1 * TheWeapon.GetModifier() * AdjustmentFactor)
	   Potentials[i++] = class'ArtifactPlusAddonPickup';
	if (FRand() < 0.08 * TheWeapon.GetModifier() * AdjustmentFactor)
	   Potentials[i++] = class'DruidArtifactMakeMagicWeaponPickup';
	if (FRand() < 0.08 * TheWeapon.GetModifier() * AdjustmentFactor)
	   Potentials[i++] = class'DruidArtifactTripleDamagePickup';
	if (FRand() < 0.1 * TheWeapon.GetModifier() * AdjustmentFactor)
	   Potentials[i++] = class'DruidEnhancedArtifactMonsterSummonPickup';	

    if (i == 0)
    { 
        // add something just to make sure we have something
        Potentials[i++] = class'AdrenalinePickup';
    	Potentials[i++] = class'LuckyHealthPack';
    }

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
	ChanceLuckPowerups=0.025
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

