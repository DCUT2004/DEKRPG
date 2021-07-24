class HUDTeamAdren extends HUDInvasion
	config(user);

var() NumericWidget PlayerTeamAdrenalineCount, MonsterTeamAdrenalineCount;

// Adrenaline Meter
var() SpriteWidget TeamAdrenalineIcon;
var() SpriteWidget TeamAdrenalineBackground;
var() SpriteWidget TeamAdrenalineBackgroundDisc;

simulated function DrawHudPassA (Canvas C)
{
    Super.DrawHudPassA (C);
	
	if ( PawnOwner != None )
	{
		if( bShowPersonalInfo )
		{
			DrawTeamAdrenaline(C);
		}
	}
}

simulated function UpdateHud()
{
	local Mutator M;
	local MutTeamAdrenaline TeamAdrenMut;
	
	if (Level.Game != None)
		for (M = Level.Game.BaseMutator; m != None; M = M.NextMutator)
			if (MutTeamAdrenaline(M) != None)
			{
				TeamAdrenMut = MutTeamAdrenaline(M);
				break;
			}
	
	if (TeamAdrenMut != None)
	{
		PlayerTeamAdrenalineCount.Value = TeamAdrenMut.PlayerTeamAdrenaline;
		MonsterTeamAdrenalineCount.Value = TeamAdrenMut.MonsterTeamAdrenaline;
	}
    Super.UpdateHud();
}

simulated function DrawTeamAdrenaline( Canvas C )
{
	DrawSpriteWidget( C, TeamAdrenalineBackground );
	DrawSpriteWidget( C, TeamAdrenalineBackgroundDisc );

	//if( CurEnergy == MaxEnergy )
	//{
	//	DrawSpriteWidget( C, AdrenalineAlert );
	//	AdrenalineAlert.Tints[TeamIndex] = HudColorHighLight;
	//}

	DrawSpriteWidget( C, TeamAdrenalineIcon );
	DrawNumericWidget( C, PlayerTeamAdrenalineCount, DigitsBig);
	DrawNumericWidget( C, MonsterTeamAdrenalineCount, DigitsBig);

	//if(CurEnergy > LastEnergy)
	//	LastAdrenalineTime = Level.TimeSeconds;

	//LastEnergy = CurEnergy;
	//DrawHUDAnimWidget( AdrenalineIcon, default.AdrenalineIcon.TextureScale, LastAdrenalineTime, 0.6, 0.6);
	TeamAdrenalineBackground.Tints[TeamIndex] = HudColorBlack;
	TeamAdrenalineBackground.Tints[TeamIndex].A = 150;
}

defaultproperties
{ 
	MonsterTeamAdrenalineCount=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.240000,DrawPivot=DP_MiddleRight,PosX=0.500000,PosY=0.010000,OffsetX=-150,OffsetY=80,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	PlayerTeamAdrenalineCount=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.240000,DrawPivot=DP_MiddleLeft,PosX=0.500000,PosY=0.010000,OffsetX=120,OffsetY=80,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	TeamAdrenalineIcon=(WidgetTexture=Texture'HUDContent.Generic.HUD',RenderStyle=STY_Alpha,TextureCoords=(X1=113,Y1=38,X2=165,Y2=106),TextureScale=0.330000,DrawPivot=DP_UpperMiddle,PosX=0.500000,OffsetY=30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	TeamAdrenalineBackground=(WidgetTexture=Texture'HUDContent.Generic.HUD',RenderStyle=STY_Alpha,TextureCoords=(X1=168,Y1=211,X2=334,Y2=255),TextureScale=0.530000,DrawPivot=DP_UpperMiddle,PosX=0.500000,OffsetY=30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
	TeamAdrenalineBackgroundDisc=(WidgetTexture=Texture'HUDContent.Generic.HUD',RenderStyle=STY_Alpha,TextureCoords=(X1=119,Y1=258,X2=173,Y2=313),TextureScale=0.530000,DrawPivot=DP_UpperMiddle,PosX=0.500000,OffsetY=15,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
}
