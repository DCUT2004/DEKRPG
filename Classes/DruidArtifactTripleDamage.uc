class DruidArtifactTripleDamage extends EnhancedRPGArtifact
	config(UT2004RPG);

var config Array< class<AddonPowerType> > Invalid;
var Weapon LastWeapon;

function BotConsider()
{
	if (bActive && (Instigator.Controller.Enemy == None || !Instigator.Controller.CanSee(Instigator.Controller.Enemy)))
	{
		Activate();
		return;
	}
		
	if (Instigator.Controller.Adrenaline < 30)
		return;

	if ( !bActive && Instigator.Controller.Enemy != None && Instigator.Weapon != None && Instigator.Weapon.AIRating > 0.5
		  && Instigator.Controller.Enemy.Health > 70 && Instigator.Controller.CanSee(Instigator.Controller.Enemy) && NoArtifactsActive() && FRand() < 0.7 )
		Activate();
}

function bool HandlePickupQuery(Pickup Item)
{
	if (Super.HandlePickupQuery(Item))
		return true;
	if (UDamagePack(Item) != None && bActive)
		Activate();

	return false;
}

function EnhanceAdrenalineRequired(float AdRequired)
{
	CostPerSec = AdRequired;               // Timed artifacts may want to overwrite CostPerSec
}

function EnhancePerformance(float PerfIncrease)
{
	CostPerSec *= 2.0 / (PerformanceIncrease + 1.0);       
}

function Activate()
{
	if (!bActive && Instigator.HasUDamage())
		return;

	Super.Activate();
}

state Activated
{
	function BeginState()
	{
		local Vehicle V;

		Instigator.DamageScaling *= 1.5;
		V = Vehicle(Instigator);
		if (V != None && V.Driver != None)
		{
			V.Driver.EnableUDamage(1000000.f);
		}
		else
		{
			Instigator.EnableUDamage(1000000.f);
		}
		bActive = true;
	}

	function EndState()
	{
		local Vehicle V;

		if (Instigator != None)
		{
			Instigator.DamageScaling /= 1.5;
			V = Vehicle(Instigator);
			if (V != None && V.Driver != None)
			{
				V.Driver.DisableUDamage();
			}
			else
			{
				Instigator.DisableUDamage();
			}
		}
		bActive = false;
	}
    
	function Tick(float deltatime)
	{
		local int i;

		if (bActive)
		{
			if (Instigator != None && Instigator.Controller != None)	// not ghosting
			{
				Instigator.Controller.Adrenaline -= deltaTime * CostPerSec;
				if (Instigator.Controller.Adrenaline <= 0.0)
				{
					Instigator.Controller.Adrenaline = 0.0;
					UsedUp();
				}
			}
		}

		if(Instigator == None || DEKRPGWeapon(Instigator.Weapon) == None )
		{
			return;
		}
		for(i = 0; i < Invalid.length; i++)
		{
			if(DEKRPGWeapon(Instigator.Weapon).HasThisAddon(Invalid[i]))
			{
				Instigator.ReceiveLocalizedMessage(MessageClass, 2906, None, None, Class);
				GotoState('');
				bActive=false;
				return;
			}
		}
	}
}

static function string GetLocalString(optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2)
{
	if (Switch == 2906)
		return "Unable to use Triple Damage on this magic weapon type.";
	else 
		return(super.getLocalString(switch, RelatedPRI_1, RelatedPRI_2));
}

defaultproperties
{
     Invalid(0)=Class'DEKRPG999X.RageAddonPowerType'
     Invalid(1)=Class'DEKRPG999X.VorpalAddonPowerType'
     CostPerSec=13
     PickupClass=Class'DEKRPG999X.DruidArtifactTripleDamagePickup'
     IconMaterial=Texture'UTRPGTextures.Icons.TripleDamageIcon'
     ItemName="Triple Damage"
}
