class VoidedCube extends Actor;

var Pawn PawnOwner;
var MutTeamAdrenaline TeamAdrenaline;
var int AdrenAmount;
var MissionPortalFX FX;

#exec  AUDIO IMPORT NAME="VoidedCubeExplosion" FILE="Sounds\VoidedCubeExplosion.WAV" GROUP="ComboSounds"

simulated function PostBeginPlay()
{
	local Mutator m;

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutTeamAdrenaline(m) != None)
			{
				TeamAdrenaline = MutTeamAdrenaline(m);
				break;
			}
	SetTimer(1, True);
	SetCollisionSize(default.CollisionRadius*0.50, default.CollisionHeight*0.50);
	Super.PostBeginPlay();
}


function Touch(Actor Other)
{
	local Actor A;
    if (Other != None)
	{
		if (Pawn(Other) != None && Pawn(Other).Health > 0 && PawnOwner != None && PawnOwner.Health > 0 && Pawn(Other).GetTeamNum() != PawnOwner.GetTeamNum() && BossInv(Pawn(Other).FindInventoryType(Class'BossInv')) == None)
		{
			if (!Pawn(Other).IsA('HealerNali') && !Pawn(Other).IsA('MissionCow'))
			{
				Pawn(Other).Died(PawnOwner.Controller, class'DamTypeVoidedCube', Pawn(Other).Location);
				if (TeamAdrenaline != None)
				{
					if (PawnOwner.IsA('Monster'))	//A monster cast voided cube. So enemy will be human
					{
						TeamAdrenaline.PlayerTeamAdrenaline -= AdrenAmount;
						if (TeamAdrenaline.PlayerTeamAdrenaline < 0)
							TeamAdrenaline.PlayerTeamAdrenaline = 0;
					}
					else
					{
						TeamAdrenaline.MonsterTeamAdrenaline -= AdrenAmount;
						if (TeamAdrenaline.MonsterTeamAdrenaline < 0)
							TeamAdrenaline.MonsterTeamAdrenaline = 0;
					}
				}
				PlaySound(Sound'VoidedCubeExplosion', SLOT_None, 1.0, , 800.00);
				A = Spawn(class'ShockComboFlash',,, Self.Location);
				if (A != None)
					A.RemoteRole = ROLE_SimulatedProxy;
				Destroy();
			}
		}
	}
}

simulated function Timer()
{
	if (FX == None)
	{
		FX = Spawn(class'MissionPortalFX',,,Self.Location);
		if (FX != None)
		{
			FX.SetBase(Self);
			FX.RemoteRole = ROLE_SimulatedProxy;
		}
	}
}

simulated function Destroyed()
{
	if (FX != None)
		FX.Destroy();
	Super.Destroyed();
}

defaultproperties
{
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=135
     LightBrightness=255.000000
     LightRadius=15.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'Editor.TexPropCube'
     bDynamicLight=True
     bIgnoreVehicles=True
     Physics=PHYS_None
     //Skins(0)=FinalBlend'XEffectMat.Combos.InvisOverlayFB'
     //Skins(1)=FinalBlend'XEffectMat.Combos.InvisOverlayFB'
	 Skins(0)=FinalBlend'MutantSkins.Shaders.MutantGlowFinal'
	 Skins(1)=FinalBlend'MutantSkins.Shaders.MutantGlowFinal'
     CollisionRadius=60.000000
     CollisionHeight=60.000000
     bCollideActors=True
     bCollideWorld=True
     Mass=2000.000000
	 bUseCollisionStaticMesh=True
}
