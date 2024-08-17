// toxic waste aftermath
version "4.8.0"

#include "zscript/dedz.zs"
#include "zscript/grell.zs"
#include "zscript/satyr.zs"
#include "shaders.zsc"
#include "zscript/hitmarkers.zsc"
#include "zscript/flashlight.zs"

class NashMoveHandler : EventHandler
{
	override void PlayerEntered(PlayerEvent e)
	{
		players[e.PlayerNumber].mo.A_GiveInventory("Z_NashMove", 1);
	}
}

class Z_NashMove : CustomInventory
{
	Default
	{
		Inventory.MaxAmount 1;
		+INVENTORY.UNDROPPABLE
		+INVENTORY.UNTOSSABLE
		+INVENTORY.AUTOACTIVATE
	}

	// How much to reduce the slippery movement.
	// Lower number = less slippery.
	const DECEL_MULT = 0.8;

	//===========================================================================
	//
	//
	//
	//===========================================================================

	bool bIsOnFloor(void)
	{
		return (Owner.Pos.Z == Owner.FloorZ) || (Owner.bOnMObj);
	}

	bool bIsInPain(void)
	{
		State PainState = Owner.FindState('Pain');
		if (PainState != NULL && Owner.InStateSequence(Owner.CurState, PainState))
		{
			return true;
		}
		return false;
	}

	double GetVelocity (void)
	{
		return Owner.Vel.Length();
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================

	override void Tick(void)
	{
		if (Owner && Owner is "PlayerPawn")
		{
			if (bIsOnFloor())
			{
				// bump up the player's speed to compensate for the deceleration
				// TO DO: math here is shit and wrong, please fix
				double s = 1.0 + (1.0 - DECEL_MULT);
				Owner.A_SetSpeed(s * 2);

				// decelerate the player, if not in pain
				if (!bIsInPain())
				{
					Owner.vel.x *= DECEL_MULT;
					Owner.vel.y *= DECEL_MULT;
				}

				// make the view bobbing match the player's movement
				PlayerPawn(Owner).ViewBob = DECEL_MULT;
			}
		}

		Super.Tick();
	}

	//===========================================================================
	//
	//
	//
	//===========================================================================
	States
	{
	Use:
		TNT1 A 0;
		Fail;
	Pickup:
		TNT1 A 0
		{
			return true;
		}
		Stop;
	}
}

class MBlurHandler : StaticEventHandler
{
	int			pitch, yaw ;
	double		xtravel, ytravel ;
	
	override void PlayerEntered( PlayerEvent e )
	{
		PlayerInfo plr = players[ e.PlayerNumber ];
		if( plr )
		{	
			xtravel = 0 ;
			ytravel = 0 ;
		}
	}
	
	override void WorldTick()
	{
		PlayerInfo	plr = players[ consoleplayer ];
		if( plr && plr.health > 0 && Cvar.GetCVar( "mblur", plr ).GetBool() )
		{
			yaw		= plr.mo.GetPlayerInput( ModInput_Yaw );
			pitch	= -plr.mo.GetPlayerInput( ModInput_Pitch );
		}
	}
	
	override void NetworkProcess( ConsoleEvent e )
	{
		PlayerInfo	plr = players[ e.Player ];
		if( plr && e.Name == "liveupdate" )
		{
			double pitchcurve ;
			if( Cvar.GetCVar( "mblur_pcurve", plr ).GetInt() == 1 )	pitchcurve = sin( 90. - abs( plr.mo.pitch ));
			else														pitchcurve = sqrt( 1. - abs( plr.mo.pitch * 1. / 90 ));
			
			double amount		= Cvar.GetCVar( "mblur_strength", plr ).GetFloat() * 10. / 32767 * pitchcurve ;
			double amount_walk	= Cvar.GetCVar( "mblur_strength_walk", plr ).GetFloat() * .1 ;
			double amount_jump	= Cvar.GetCVar( "mblur_strength_jump", plr ).GetFloat() * .1 * pitchcurve ;
			double decay		= 1. - Cvar.GetCVar( "mblur_recovery", plr ).GetFloat() * .01 ;
			
			xtravel				= xtravel * decay + yaw * amount * .625 ;
			ytravel				= ytravel * decay + pitch * amount ;
			
			if( Cvar.GetCVar( "mblur_autostop", plr ).GetBool() )
			{
				double threshold = Cvar.GetCVar( "mblur_threshold", plr ).GetFloat() * 30 ;
				double decay2 = 1 - Cvar.GetCVar( "mblur_recovery2", plr ).GetFloat() * .01 ;
				if( abs( yaw )		<= threshold ) xtravel *= decay2 ;
				if( abs( pitch )	<= threshold ) ytravel *= decay2 ;
			}
			
			double angle = plr.mo.vel.y >= 0 ? 0 : 180 ;
			if( plr.mo.vel.x != 0 )
			{
				angle = atan( plr.mo.vel.y / plr.mo.vel.x );
				
				if( plr.mo.vel.x < 0 )			angle += 180 ;
				else if( plr.mo.vel.y < 0 )	angle += 360 ;
			}
			angle				-= ( plr.mo.angle + 180 ) % 360 ;
			
			double velocity	= sqrt( plr.mo.vel.x * plr.mo.vel.x + plr.mo.vel.y * plr.mo.vel.y );
			double sidevel		= sin( angle ) * velocity ;
			double walkvel		= cos( angle ) * velocity ;
			if( plr.mo.pitch > 0 ) walkvel = -walkvel ;
			
			xtravel				+= sidevel * amount_walk * .625 ;
			ytravel				+= plr.mo.vel.z * amount_jump + walkvel * amount_walk * ( 1. - pitchcurve );
			
			//console.printf( "%f", angle );
		}
	}
	
	override void UiTick()
	{
		PlayerInfo	plr = players[ consoleplayer ];
		if( plr )
		{
			if( plr.health > 0 && Cvar.GetCVar( "mblur", plr ).GetBool() )//&& yaw && pitch )
			{
				EventHandler.SendNetworkEvent( "liveupdate" );
				
				vector2 travel		= ( xtravel / screen.getwidth(), ytravel / screen.getheight() );
				double dist			= sqrt( travel.x * travel.x + travel.y * travel.y );
				
				double dynsamps = 1. ;
				if( Cvar.GetCVar( "mblur_dynsamps", plr ).GetBool() ) dynsamps = dist * 12 ;
				
				int copies			= 1 + int( Cvar.GetCVar( "mblur_samples", plr ).GetInt() * dynsamps );
				double increment	= 1. / copies ;
				
				Shader.SetUniform2f( plr, "MBlur", "steps", travel * increment );
				Shader.SetUniform1i( plr, "MBlur", "samples", copies );
				Shader.SetUniform1f( plr, "MBlur", "increment", increment );
				Shader.SetUniform1i( plr, "MBlur", "blendmode", Cvar.GetCVar( "mblur_blendmode", plr ).GetInt() );
				//Shader.SetUniform1f( plr, "MBlur", "dist", dist );
					
				Shader.SetEnabled( plr, "MBlur", true );
			}
			else
			{
				Shader.SetEnabled( plr, "MBlur", false );
			}
		}
	}
}
