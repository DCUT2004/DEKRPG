class RuneFlareBurst extends Actor;

var Emitter BurstFX;
var Class<Emitter> BurstFXClass;

//Same as Actor's HurtRadius, except we will exclude Instigator from getting hurt
simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;

	if( bHurtEntry )
		return;
		
	if (Instigator == None)
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if( (Victims != self) && (Victims != Instigator) && (Victims.Role == ROLE_Authority) && (!Victims.IsA('FluidSurfaceInfo')) )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			Victims.TakeDamage
			(
				damageScale * DamageAmount,
				Instigator,
				Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
				(damageScale * Momentum * dir),
				DamageType
			);
			if (Instigator != None && Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);
		}
	}
	SpawnEffects();
	bHurtEntry = false;
}

simulated function SpawnEffects()
{
	BurstFX = Spawn(BurstFXClass,,,Self.Location);
	if (BurstFX != None)
		BurstFX.RemoteRole = ROLE_SimulatedProxy;
}

defaultproperties
{
	DrawType=DT_Sprite
	DrawScale=0.010000
	Skins(0)=FinalBlend'D-E-K-HoloGramFX.NonWireframe.FunkyStuff_0'
	Lifespan=1.00000
	bIgnoreEncroachers=True
}
