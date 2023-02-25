class DEKStingerTurret extends DruidMinigunTurret;

simulated event PostBeginPlay()
{

	local Mutator m;

	DefaultWeaponClassName=string(class'DEKStingerTurretWeapon');

	super(ASTurret_MiniGun).PostBeginPlay();

	if (Level.Game != None)
		for (m = Level.Game.BaseMutator; m != None; m = m.NextMutator)
			if (MutUT2004RPG(m) != None)
			{
				RPGMut = MutUT2004RPG(m);
				break;
			}
			
	if (Role == ROLE_Authority)		
		SetTimer(1, true);	// for calculating number of healers
}


defaultproperties
{
     DefaultWeaponClassName="DEKStingerTurretWeapon"
     VehiclePositionString="manning a Stinger Turret"
     VehicleNameString="Stinger Turret"
     Skins(0)=Combiner'DEKRPGTexturesMaster209B.Skins.StingerMinigunTurret2Combiner'
     Skins(1)=Combiner'DEKRPGTexturesMaster209B.Skins.StingerMinigunTurret1Combiner'
     Skins(2)=FinalBlend'DEKRPGTexturesMaster209B.Skins.StingerMinigunTurretTopFinalBlend'
     Skins(3)=FinalBlend'DEKRPGTexturesMaster209B.Skins.StingerMinigunTurretTopFinalBlend'
}
