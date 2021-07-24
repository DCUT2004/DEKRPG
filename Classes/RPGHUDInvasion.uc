class RPGHUDInvasion extends HUDInvasion
	config(user);

var PlayerController PC;

var() NumericWidget PlayerTeamAdrenalineCount, MonsterTeamAdrenalineCount;
var () NumericWidget ComboCount;

// Adrenaline Meter
var() SpriteWidget TeamAdrenalineIcon;
var() SpriteWidget TeamAdrenalineBackground;
var() SpriteWidget TeamAdrenalineBackgroundDisc;

//Combo 
var() SpriteWidget ComboIcon;
var() SpriteWidget ComboDisc;

#EXEC OBJ LOAD FILE=InterfaceContent.utx
#EXEC OBJ LOAD FILE=AS_FX_TX.utx

simulated function UpdatePrecacheMaterials()
{
	Super.UpdatePrecacheMaterials();
}

simulated function DrawHudPassA (Canvas C)
{
    Super.DrawHudPassA (C);
	
	if ( PawnOwner != None )
	{
		if( bShowPersonalInfo )
		{
			DrawTeamAdrenaline(C);
			DrawCombo(C);
		}
	}
}

simulated function ShowTeamScorePassA(Canvas C)
{
	Super.ShowTeamScorePassA(C);
}

simulated function ShowTeamScorePassC(Canvas C)
{
	local Pawn P;
	local float Dist, MaxDist, RadarWidth, PulseBrightness,Angle,DotSize,OffsetY,OffsetScale;
	local rotator Dir;
	local vector Start;
	local FriendlyMonsterEffect effect;
	local bool bPet;
	local bool bMyPet;

	local int DeltaHealth;

	if(PC == None) //Initialize PC
		PC = Level.GetLocalPlayerController();

	LastDrawRadar = Level.TimeSeconds;
	RadarWidth = 0.5 * RadarScale * C.ClipX;
	DotSize = 24*C.ClipX*HUDScale/1600;
	if ( PawnOwner == None )
		Start = PlayerOwner.Location;
	else
		Start = PawnOwner.Location;
	
	MaxDist = 3000 * RadarPulse;
	C.Style = ERenderStyle.STY_Translucent;
	OffsetY = RadarPosY + RadarWidth/C.ClipY;
	MinEnemyDist = 3000;

	ForEach DynamicActors(class'Pawn',P)
		if ( P.Health > 0  && !ClassIsChildOf(P.Class, class'MissionBalloon'))
		{
			Dist = VSize(Start - P.Location);
			if ( Dist < 3000 )
			{
				if ( Dist < MaxDist )
					PulseBrightness = 255 - 255*Abs(Dist*0.00033 - RadarPulse);
				else
					PulseBrightness = 255 - 255*Abs(Dist*0.00033 - RadarPulse - 1);

				if ( Monster(P) != None )
				{
					bPet = false;
					bMyPet = false;
					// first is it a pet?
					ForEach DynamicActors(class'FriendlyMonsterEffect',Effect)
					{
				        if (Effect.Base != None)
				        {
				            if (Monster(Effect.Base) == Monster(P))
				            {
				                bPet = true;
								if (PC != None && PC.PlayerReplicationInfo != None && PC.PlayerReplicationInfo == Effect.MasterPRI)
							    	bMyPet = true;
							}
				        }
				    }
					if (bPet)
					{
						if (bMyPet)
						{
							//make my monsters look green
							C.DrawColor.R = 0;
							C.DrawColor.G = FMin(PulseBrightness*2, 255);
							C.DrawColor.B = 0;
						}
						else
						{
							//Make friendly monsters an off blue
							C.DrawColor.R = 0;
							C.DrawColor.G = FMin(PulseBrightness*2, 255);
							C.DrawColor.B = FMin(PulseBrightness*2, 255);
						}
					}
					else
					{
						MinEnemyDist = FMin(MinEnemyDist, Dist);
						if(PawnOwner == None)
						{
							//Dont know what color to give it <shrug>
							C.DrawColor.R = PulseBrightness;
							C.DrawColor.G = PulseBrightness;
							C.DrawColor.B = 0;
						}
						else
						{
							DeltaHealth = Max(Min(PawnOwner.Health - P.Health, 255), -255);

							//Green for less dangerous, Red for more dangerous.
							C.DrawColor.R = ((-1 * DeltaHealth) / 2 + 128) * (PulseBrightness / 255.0);
							C.DrawColor.G = (DeltaHealth / 2 + 128) * (PulseBrightness / 255.0);
							C.DrawColor.B = 0;
						}
	 				}
				}
				else if ( Vehicle(P) != None && Vehicle(P).Driver == None)
				{
					//make empty vehicles grey.
					C.DrawColor.R = PulseBrightness/2;
					C.DrawColor.G = PulseBrightness/2;
					C.DrawColor.B = PulseBrightness/2;
				}
				else if ( (DruidBlock(P) != None || DruidExplosive(P) != None) )
				{
					//make blocks grey.
					C.DrawColor.R = PulseBrightness/2;
					C.DrawColor.G = PulseBrightness/2;
					C.DrawColor.B = PulseBrightness/2;
				}
				else
				{
					//make players blue
					C.DrawColor.R = 0;
					C.DrawColor.G = 0;
					C.DrawColor.B = PulseBrightness;
				}
				Dir = rotator(P.Location - Start);
				OffsetScale = RadarScale*Dist*0.000167;
				if ( PawnOwner == None )
					Angle = ((Dir.Yaw - PlayerOwner.Rotation.Yaw) & 65535) * 6.2832/65536;
				else
					Angle = ((Dir.Yaw - PawnOwner.Rotation.Yaw) & 65535) * 6.2832/65536;
				C.SetPos(RadarPosX * C.ClipX + OffsetScale * C.ClipX * sin(Angle) - 0.5*DotSize,
						OffsetY * C.ClipY - OffsetScale * C.ClipX * cos(Angle) - 0.5*DotSize);
				C.DrawTile(Material'InterfaceContent.Hud.SkinA',DotSize,DotSize,838,238,144,144);
			}
		}
}

simulated function UpdateHud()
{
	local GiveItemsInv GInv;
	local Pawn P;
	
	if (PawnOwner != None)
	{
		if (Vehicle(PawnOwner) != None)
		{
			P = Vehicle(PawnOwner).Driver;
		}
		else
			P = PawnOwner;
		if (P != None && P.Controller != None)
			GInv = class'GiveItemsInv'.static.GetGiveItemsInv(P.Controller);
		if (GInv != None)
		{
			ComboCount.Value = GInv.NumCombos;
			PlayerTeamAdrenalineCount.Value = GInv.PlayerTeamAdrenaline;
			MonsterTeamAdrenalineCount.Value = GInv.MonsterTeamAdrenaline;
		}
		else
		{
			ComboCount.Value = 0;
			PlayerTeamAdrenalineCount.Value = 0;
			MonsterTeamAdrenalineCount.Value = 0;
		}
	}
    Super.UpdateHud();
}

simulated function DrawTeamAdrenaline( Canvas C )
{
	DrawSpriteWidget( C, TeamAdrenalineBackground );
	DrawSpriteWidget( C, TeamAdrenalineBackgroundDisc );

	DrawSpriteWidget( C, TeamAdrenalineIcon );
	DrawNumericWidget( C, PlayerTeamAdrenalineCount, DigitsBig);
	DrawNumericWidget( C, MonsterTeamAdrenalineCount, DigitsBig);

	TeamAdrenalineBackground.Tints[TeamIndex] = HudColorBlack;
	TeamAdrenalineBackground.Tints[TeamIndex].A = 150;
}

simulated function DrawCombo( Canvas C )
{
	DrawSpriteWidget( C, ComboDisc );

	DrawSpriteWidget( C, ComboIcon );
	DrawNumericWidget( C, ComboCount, DigitsBig);
}

simulated function DrawTimer(Canvas C)
{
	return;
}

simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
}

defaultproperties
{
	PlayerTeamAdrenalineCount=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.390000,DrawPivot=DP_MiddleRight,PosX=0.500000,OffsetX=-53,OffsetY=70,Tints[0]=(B=0,G=77,R=255,A=255),Tints[1]=(B=0,G=77,R=255,A=255))
	MonsterTeamAdrenalineCount=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.390000,DrawPivot=DP_MiddleLeft,PosX=0.500000,OffsetX=35,OffsetY=70,Tints[0]=(B=255,G=174,R=0,A=255),Tints[1]=(B=255,G=174,R=0,A=255))
	TeamAdrenalineIcon=(WidgetTexture=Texture'HUDContent.Generic.HUD',RenderStyle=STY_Alpha,TextureCoords=(X1=113,Y1=38,X2=165,Y2=106),TextureScale=0.330000,DrawPivot=DP_UpperMiddle,PosX=0.500000,OffsetY=30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=195,G=255,R=0,A=255),Tints[1]=(B=195,G=255,R=0,A=255))
	TeamAdrenalineBackground=(WidgetTexture=Texture'HUDContent.Generic.HUD',RenderStyle=STY_Alpha,TextureCoords=(X1=168,Y1=211,X2=334,Y2=255),TextureScale=0.530000,DrawPivot=DP_UpperMiddle,PosX=0.500000,OffsetY=30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	TeamAdrenalineBackgroundDisc=(WidgetTexture=Texture'HUDContent.Generic.HUD',RenderStyle=STY_Alpha,TextureCoords=(X1=119,Y1=258,X2=173,Y2=313),TextureScale=0.530000,DrawPivot=DP_UpperMiddle,PosX=0.500000,OffsetY=15,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	ComboIcon=(WidgetTexture=Texture'HUDContent.Generic.Links01',RenderStyle=STY_Alpha,TextureCoords=(X2=127,Y2=63),TextureScale=0.230000,ScaleMode=SM_Right,OffsetY=27,OffsetX=-1,Scale=1.000000,Tints[0]=(B=0,G=170,R=255,A=255),Tints[1]=(B=0,G=170,R=255,A=255))
	ComboDisc=(WidgetTexture=Texture'HUDContent.Generic.HUD',RenderStyle=STY_Alpha,TextureCoords=(X1=119,Y1=258,X2=173,Y2=313),TextureScale=0.530000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	ComboCount=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.300000,DrawPivot=DP_MiddleLeft,OffsetY=45,OffsetX=-10,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
}
