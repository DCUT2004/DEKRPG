class StatusEffect_AmmoRegen extends StatusEffect
	config(UT2004RPG);

function StartEffect(Pawn Target)
{
	SetTimer(1, True);
}

function Timer()
{
	local Inventory Inv;
	local Ammunition Ammo;
	local Weapon W;

	if (Instigator == None || Instigator.Health <= 0 || Modifier == 0 || Instigator.IsA('Monster'))
	{
		Destroy();
		return;
	}
	
	
	for (Inv = Instigator.Inventory; Inv != None; Inv = Inv.Inventory)
	{
		W = Weapon(Inv);
		if (W != None)
		{
			if (W.bNoAmmoInstances && W.AmmoClass[0] != None && !class'MutUT2004RPG'.static.IsSuperWeaponAmmo(W.AmmoClass[0]))
			{
				if (Modifier > 0)
				{
					W.AddAmmo(Modifier * (1 + W.AmmoClass[0].default.MaxAmmo / 100), 0);
					if (W.AmmoClass[0] != W.AmmoClass[1] && W.AmmoClass[1] != None)
						W.AddAmmo(Modifier * (1 + W.AmmoClass[1].default.MaxAmmo / 100), 1);

				}
				else if (Modifier < 0)
				{
					W.ConsumeAmmo(0, -Modifier * (1 + W.AmmoClass[0].default.MaxAmmo / 100));
					if (W.AmmoClass[0] != W.AmmoClass[1] && W.AmmoClass[1] != None)
						W.ConsumeAmmo(1, -Modifier * (1 + W.AmmoClass[1].default.MaxAmmo / 100));
				}
			}
		}
		else
		{
			Ammo = Ammunition(Inv);
			if (Ammo != None && !class'MutUT2004RPG'.static.IsSuperWeaponAmmo(Ammo.Class))
				if (Modifier > 0)
					Ammo.AddAmmo(Modifier * (1 + Ammo.default.MaxAmmo / 100));
				else if (Modifier < 0)
					Ammo.UseAmmo(-Modifier * (1 + Ammo.default.MaxAmmo / 100));
		}
	}
	
	if (Instigator.Controller != None && PlayerController(Instigator.Controller) != None)
	{
		if (Modifier > 0)
			PlayerController(Instigator.Controller).ClientPlaySound(Sound'WeaponSounds.BaseGunTech.BReload9');
		else if (Modifier < 0)
			PlayerController(Instigator.Controller).ClientPlaySound(Sound'MenuSounds.MS_Edit');
	}
}

function StopEffect(Pawn Target)
{
	SetTimer(0, False);
}

defaultproperties
{
	StatusEffectName="Ammo Regen"
	MaxModifier=5
}
