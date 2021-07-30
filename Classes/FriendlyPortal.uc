class FriendlyPortal extends UntargetedProjectile
	config(UT2004RPG);

var class<Emitter> OrbEffectClass;
var Emitter OrbEffect;
var config float SpawnInterval;
var int SkillLevel;
var float MonsterLifespan;

var config Array < class < Monster > > FriendlyMonsterClass;

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
	
	if (Level.NetMode != NM_DedicatedServer)
	{
		OrbEffect = Spawn(OrbEffectClass, Self);
		OrbEffect.SetBase(Self);
	}
	SetTimer(SpawnInterval, true);
}

function Timer() 
{
	SpawnMonster();
}

function SpawnMonster()
{
	local class<Monster> MClass;
	local Monster M;
	local DEKFriendlyMonsterController C;
	local Inventory Inv;
	local FriendlyMonsterInv FriendlyInv;
	local RPGStatsInv StatsInv;
	local int x;
	
	MClass = FriendlyMonsterClass[RandRange(0, FriendlyMonsterClass.Length)];
	M = Spawn(MClass,,,Location);
	if (M != None)
	{
		if (M.Controller != None)
			M.Controller.Destroy();
		FriendlyInv = M.Spawn(class'FriendlyMonsterInv');
		FriendlyInv.MasterPRI = Instigator.PlayerReplicationInfo;
		FriendlyInv.Skill = SkillLevel;
		FriendlyInv.GiveTo(M);				
		FriendlyInv.MonsterPointsInv = None;
		Spawn(class'FriendlyPortalDeres',M,,M.Location);
		Spawn(class'FriendlyPortalDeresEffect',M,,M.Location);
		M.Lifespan = MonsterLifespan;
		
		C = spawn(class'DEKFriendlyMonsterController');
		if(C == None)
		{
			FriendlyInv.Destroy();
			M.Destroy();
			return;
		}
		C.Possess(M); //do not call InitializeSkill before this line.
		C.SetMaster(Instigator.Controller);
		C.InitializeSkill(SkillLevel);
		
		//allow Instigator's abilities to affect the monster
		for (Inv = Instigator.Controller.Inventory; Inv != None; Inv = Inv.Inventory)
		{
			StatsInv = RPGStatsInv(Inv);
			if (StatsInv != None)
				break;
		}
		if (StatsInv == None) //fallback, should never happen
			StatsInv = RPGStatsInv(Instigator.FindInventoryType(class'RPGStatsInv'));
		if (StatsInv != None) //this should always be the case
		{
			for (x = 0; x < StatsInv.Data.Abilities.length; x++)
			{
				if(ClassIsChildOf(StatsInv.Data.Abilities[x], class'MonsterAbility'))
					class<MonsterAbility>(StatsInv.Data.Abilities[x]).static.ModifyMonster(M, StatsInv.Data.AbilityLevels[x]);
				else
					StatsInv.Data.Abilities[x].static.ModifyPawn(M, StatsInv.Data.AbilityLevels[x]);
			}

			if (C.Inventory == None) //should never be the case.
				C.Inventory = StatsInv;
			else
			{
				for (Inv = C.Inventory; Inv.Inventory != None; Inv = Inv.Inventory)
				{}
				Inv.Inventory = StatsInv;
			}
		}
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	return;
	//do nothing.
}

simulated function DestroyTrails()
{
	if (OrbEffect != None)
		OrbEffect.Destroy();
}

simulated function Destroyed()
{
	if (OrbEffect != None)
	{
		if (bNoFX)
			OrbEffect.Destroy();
		else
			OrbEffect.Kill();
	}
	Super.Destroyed();
}

defaultproperties
{
	OrbEffectClass=Class'DEKRPG208AC.FriendlyPortalEffect'
	SpawnInterval=10.000000
	FriendlyMonsterClass(0)=Class'SkaarjPack.SkaarjPupae'
	MaxSpeed=0.000000
	TossZ=0.000000
	LightType=LT_Steady
	LightEffect=LE_QuadraticNonIncidence
	LightHue=90
	LightBrightness=100.000000
	LightRadius=10.000000
	DrawType=DT_None
	bDynamicLight=True
	Physics=PHYS_Flying
	AmbientSound=Sound'GeneralAmbience.aliendrone2'
	LifeSpan=12.000000
	bFullVolume=True
	SoundVolume=232
	TransientSoundVolume=1000.000000
}
