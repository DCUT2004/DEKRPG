//The combo that the player has purchased
class ComboAbilityNaliPriestInv extends ComboAbilityInv
	config(UT2004RPG);
	
var config int NaliPriestHealth;
var config float NaliPriestHealthPerc;
var config int NaliPriestHealAmount;
var Monster Priest;
	
function DoEffect()
{
	local HardcoreInv HInv;
	Local GameRules G;
	local TeamAdrenalineGameRules TARules;
	
	if (Owner != None && Pawn(Owner) != None)
	{
		if (Combo != None)
		{
			for(G = Level.Game.GameRulesModifiers; G != None; G = G.NextGameRules)
			{
				if(G.isA('TeamAdrenalineGameRules'))
				{
					TARules = TeamAdrenalineGameRules(G);
					break;
				}
			}
			if (TARules != None)
			{
				if (TARules.TauntPawn != None && TARules.TauntPawn.IsA('NaliPriestProtector'))
				{
					TARules.TauntPawn.GiveHealth(NaliPriestHealAmount, TARules.TauntPawn.HealthMax);
					Pawn(Owner).PlaySound(sound'PickupSounds.HealthPack',, 2 * Pawn(Owner).TransientSoundVolume,, 1.5 * Pawn(Owner).TransientSoundRadius);
					TARules.TauntPawn.PlaySound(sound'PickupSounds.HealthPack',, 2 * TARules.TauntPawn.TransientSoundVolume,, 1.5 * TARules.TauntPawn.TransientSoundRadius);
					TARules.TauntPawn.Spawn(class'DEKEffectHealer', TARules.TauntPawn,, TARules.TauntPawn.Location, TARules.TauntPawn.Rotation);
				}
				else if (TARules.TauntPawn == None)
				{
					Priest = Combo.SummonMinion(Pawn(Owner), class'NaliPriestProtector', NaliPriestHealth, NaliPriestHealthPerc, True, ComboLifespan, 0, EffectMultiplier, bDispellable);
					if (Priest != None)
					{
						HInv = Priest.Spawn(class'HardcoreInv');
						HInv.GiveTo(Priest);
						if (TARules != None)
							TARules.TauntPawn = Priest;	
					}
				}
			}
		}
		//EffectEmitter = Pawn(Owner).Spawn(EffectEmitterClass, Pawn(Owner), , Pawn(Owner).Location, Pawn(Owner).Rotation);
	}
}

/*function Monster SummonMinion(Class<Monster> MonsterClass)
{
	local Monster M;
	
	M = Pawn(Owner).Spawn(MonsterClass,, getSpawnLocation(Pawn(Owner), MonsterClass);
	if (M != None)
		return M;
	else
		return None;
}

function vector getSpawnLocation(Pawn Instigator, Class<Monster> ChosenMonster)
{
	local float Dist, BestDist;
	local vector SpawnLocation;
	local NavigationPoint N, BestDest;

	BestDist = 50000.f;
	for (N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint)
	{
		Dist = VSize(N.Location - Instigator.Location);
		if (Dist < BestDist && Dist > ChosenMonster.default.CollisionRadius * 4)
		{
			BestDest = N;
			BestDist = VSize(N.Location - Instigator.Location);
		}
	}

	if (BestDest != None)
		SpawnLocation = BestDest.Location + (ChosenMonster.default.CollisionHeight - BestDest.CollisionHeight) * vect(0,0,1);
	else
		SpawnLocation = Instigator.Location + ChosenMonster.default.CollisionHeight * vect(0,0,1.5); //is this why monsters spawn on heads?

	return SpawnLocation;	
}*/

defaultproperties
{
	NaliPriestHealAmount=300
	NaliPriestHealth=800
	NaliPriestHealthPerc=0.5000
	//EffectEmitterClass=Class'ComboAbilityBurnFX'
}
