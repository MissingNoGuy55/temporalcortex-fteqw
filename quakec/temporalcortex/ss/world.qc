void() InitBodyQue;

void() main =
{
	dprint ("main function\n");
	
// these are just commands the the prog compiler to copy these files

	precache_file ("progs.dat");
	precache_file ("gfx.wad");
	precache_file ("quake.rc");
	precache_file ("default.cfg");

	precache_file ("end1.bin");
	precache_file2 ("end2.bin");

	precache_file ("demo1.dem");
	precache_file ("demo2.dem");
	precache_file ("demo3.dem");

//
// these are all of the lumps from the cached.ls files
//
	precache_file ("gfx/palette.lmp");
	precache_file ("gfx/colormap.lmp");

	precache_file2 ("gfx/pop.lmp");

	precache_file ("gfx/complete.lmp");
	precache_file ("gfx/inter.lmp");

	precache_file ("gfx/ranking.lmp");
	precache_file ("gfx/vidmodes.lmp");
	precache_file ("gfx/finale.lmp");
	precache_file ("gfx/conback.lmp");
	precache_file ("gfx/qplaque.lmp");

	precache_file ("gfx/menudot1.lmp");
	precache_file ("gfx/menudot2.lmp");
	precache_file ("gfx/menudot3.lmp");
	precache_file ("gfx/menudot4.lmp");
	precache_file ("gfx/menudot5.lmp");
	precache_file ("gfx/menudot6.lmp");

	precache_file ("gfx/menuplyr.lmp");
	precache_file ("gfx/bigbox.lmp");
	precache_file ("gfx/dim_modm.lmp");
	precache_file ("gfx/dim_drct.lmp");
	precache_file ("gfx/dim_ipx.lmp");
	precache_file ("gfx/dim_tcp.lmp");
	precache_file ("gfx/dim_mult.lmp");
	precache_file ("gfx/mainmenu.lmp");
	
	precache_file ("gfx/box_tl.lmp");
	precache_file ("gfx/box_tm.lmp");
	precache_file ("gfx/box_tr.lmp");
	
	precache_file ("gfx/box_ml.lmp");
	precache_file ("gfx/box_mm.lmp");
	precache_file ("gfx/box_mm2.lmp");
	precache_file ("gfx/box_mr.lmp");
	
	precache_file ("gfx/box_bl.lmp");
	precache_file ("gfx/box_bm.lmp");
	precache_file ("gfx/box_br.lmp");
	
	precache_file ("gfx/sp_menu.lmp");
	precache_file ("gfx/ttl_sgl.lmp");
	precache_file ("gfx/ttl_main.lmp");
	precache_file ("gfx/ttl_cstm.lmp");
	
	precache_file ("gfx/mp_menu.lmp");
	
	precache_file ("gfx/netmen1.lmp");
	precache_file ("gfx/netmen2.lmp");
	precache_file ("gfx/netmen3.lmp");
	precache_file ("gfx/netmen4.lmp");
	precache_file ("gfx/netmen5.lmp");
	
	precache_file ("gfx/sell.lmp");
	
	precache_file ("gfx/help0.lmp");
	precache_file ("gfx/help1.lmp");
	precache_file ("gfx/help2.lmp");
	precache_file ("gfx/help3.lmp");
	precache_file ("gfx/help4.lmp");
	precache_file ("gfx/help5.lmp");

	precache_file ("gfx/pause.lmp");
	precache_file ("gfx/loading.lmp");

	precache_file ("gfx/p_option.lmp");
	precache_file ("gfx/p_load.lmp");
	precache_file ("gfx/p_save.lmp");
	precache_file ("gfx/p_multi.lmp");

// sounds loaded by C code
	precache_sound ("misc/menu1.wav");
	precache_sound ("misc/menu2.wav");
	precache_sound ("misc/menu3.wav");

	precache_sound ("ambience/water1.wav");
	precache_sound ("ambience/wind2.wav");

// shareware
	precache_file ("maps/start.bsp");

	precache_file ("maps/e1m1.bsp");
	precache_file ("maps/e1m2.bsp");
	precache_file ("maps/e1m3.bsp");
	precache_file ("maps/e1m4.bsp");
	precache_file ("maps/e1m5.bsp");
	precache_file ("maps/e1m6.bsp");
	precache_file ("maps/e1m7.bsp");
	precache_file ("maps/e1m8.bsp");

// registered
	precache_file2 ("gfx/pop.lmp");

	precache_file2 ("maps/e2m1.bsp");
	precache_file2 ("maps/e2m2.bsp");
	precache_file2 ("maps/e2m3.bsp");
	precache_file2 ("maps/e2m4.bsp");
	precache_file2 ("maps/e2m5.bsp");
	precache_file2 ("maps/e2m6.bsp");
	precache_file2 ("maps/e2m7.bsp");

	precache_file2 ("maps/e3m1.bsp");
	precache_file2 ("maps/e3m2.bsp");
	precache_file2 ("maps/e3m3.bsp");
	precache_file2 ("maps/e3m4.bsp");
	precache_file2 ("maps/e3m5.bsp");
	precache_file2 ("maps/e3m6.bsp");
	precache_file2 ("maps/e3m7.bsp");

	precache_file2 ("maps/e4m1.bsp");
	precache_file2 ("maps/e4m2.bsp");
	precache_file2 ("maps/e4m3.bsp");
	precache_file2 ("maps/e4m4.bsp");
	precache_file2 ("maps/e4m5.bsp");
	precache_file2 ("maps/e4m6.bsp");
	precache_file2 ("maps/e4m7.bsp");
	precache_file2 ("maps/e4m8.bsp");

	precache_file2 ("maps/end.bsp");

	precache_file2 ("maps/dm1.bsp");
	precache_file2 ("maps/dm2.bsp");
	precache_file2 ("maps/dm3.bsp");
	precache_file2 ("maps/dm4.bsp");
	precache_file2 ("maps/dm5.bsp");
	precache_file2 ("maps/dm6.bsp");
};


entity	lastspawn;

//=======================
/*QUAKED worldspawn (0 0 0) ?
Only used for the world entity.
Set message to the level name.
Set sounds to the cd track to play.

World Types:
0: medieval
1: metal
2: base
*/
//=======================
void() worldspawn =
{
	lastspawn = world;
	InitBodyQue();

// custom map attributes
	if (self.model == "maps/e1m8.bsp")
		cvar_set ("sv_gravity", "100");
	else
		cvar_set ("sv_gravity", "800");

// the area based ambient sounds MUST be the first precache_sounds

// player precaches	
	W_Precache ();			// get weapon precaches

// sounds used from C physics code
	precache_sound ("demon/dland2.wav");		// landing thud
	precache_sound ("misc/h2ohit1.wav");		// landing splash

// setup precaches allways needed
	precache_sound ("items/itembk2.wav");		// item respawn sound
	precache_sound ("player/plyrjmp8.wav");		// player jump
	precache_sound ("player/land.wav");			// player landing
	precache_sound ("player/land2.wav");		// player hurt landing
	precache_sound ("player/drown1.wav");		// drowning pain
	precache_sound ("player/drown2.wav");		// drowning pain
	precache_sound ("player/gasp1.wav");		// gasping for air
	precache_sound ("player/gasp2.wav");		// taking breath
	precache_sound ("player/h2odeath.wav");		// drowning death

	precache_sound ("misc/talk.wav");			// talk
	precache_sound ("player/teledth1.wav");		// telefrag
	precache_sound ("misc/r_tele1.wav");		// teleport sounds
	precache_sound ("misc/r_tele2.wav");
	precache_sound ("misc/r_tele3.wav");
	precache_sound ("misc/r_tele4.wav");
	precache_sound ("misc/r_tele5.wav");
	precache_sound ("weapons/lock4.wav");		// ammo pick up
	precache_sound ("weapons/pkup.wav");		// weapon up
	precache_sound ("items/armor1.wav");		// armor up
	precache_sound ("weapons/lhit.wav");		//lightning
	precache_sound ("weapons/lstart.wav");		//lightning start
	precache_sound ("items/damage3.wav");

	precache_sound ("misc/power.wav");			//lightning for boss

// player gib sounds
	precache_sound ("player/gib.wav");			// player gib sound
	precache_sound ("player/udeath.wav");		// player gib sound
	precache_sound ("player/tornoff2.wav");		// gib sound

// player pain sounds

	precache_sound ("player/pain1.wav");
	precache_sound ("player/pain2.wav");
	precache_sound ("player/pain3.wav");
	precache_sound ("player/pain4.wav");
	precache_sound ("player/pain5.wav");
	precache_sound ("player/pain6.wav");

// player death sounds
	precache_sound ("player/death1.wav");
	precache_sound ("player/death2.wav");
	precache_sound ("player/death3.wav");
	precache_sound ("player/death4.wav");
	precache_sound ("player/death5.wav");

// ax sounds	
	precache_sound ("weapons/ax1.wav");			// ax swoosh
	precache_sound ("player/axhit1.wav");		// ax hit meat
	precache_sound ("player/axhit2.wav");		// ax hit world

	precache_sound ("player/h2ojump.wav");		// player jumping into water
	precache_sound ("player/slimbrn2.wav");		// player enter slime
	precache_sound ("player/inh2o.wav");		// player enter water
	precache_sound ("player/inlava.wav");		// player enter lava
	precache_sound ("misc/outwater.wav");		// leaving water sound

	precache_sound ("player/lburn1.wav");		// lava burn
	precache_sound ("player/lburn2.wav");		// lava burn

	precache_sound ("misc/water1.wav");			// swimming
	precache_sound ("misc/water2.wav");			// swimming

	precache_model ("progs/player.mdl");
	precache_model ("progs/eyes.mdl");
	precache_model ("progs/h_player.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_model ("progs/s_bubble.spr");	// drowning bubbles
	precache_model ("progs/s_explod.spr");	// sprite explosion

	precache_model ("progs/v_axe.mdl");
	precache_model ("progs/v_shot.mdl");
	precache_model ("progs/v_nail.mdl");
	precache_model ("progs/v_rock.mdl");
	precache_model ("progs/v_shot2.mdl");
	precache_model ("progs/v_nail2.mdl");
	precache_model ("progs/v_rock2.mdl");

	precache_model ("progs/bolt.mdl");		// for lightning gun
	precache_model ("progs/bolt2.mdl");		// for lightning gun
	precache_model ("progs/bolt3.mdl");		// for boss shock
	precache_model ("progs/lavaball.mdl");	// for testing
	
	precache_model ("progs/missile.mdl");
	precache_model ("progs/grenade.mdl");
	precache_model ("progs/spike.mdl");
	precache_model ("progs/s_spike.mdl");

	precache_model ("progs/backpack.mdl");

	precache_model ("progs/zom_gib.mdl");

	precache_model ("progs/v_light.mdl");

#ifdef TEMPORALCORTEX
	// Missi: Temporal Cortex bullets (2026.1.25)
	precache_model ("progs/laser.mdl");

	// Missi: Cvars that used to be part of the C code, but have been moved to QuakeC (2026.7.31)
	autocvar (tc_sv_army_gunner_damage, "6");
	autocvar (tc_sv_army_gunner_accuracy_x, "0.05");
	autocvar (tc_sv_army_gunner_accuracy_y, "0.05");
	autocvar (tc_sv_army_gunner_accuracy_z, "0.0");
	autocvar (tc_sv_friendlyfire_pvp, "0", "Enables/disables friendly fire between players. The bullets will appear to pass through players if disabled.");
	autocvar (tc_sv_friendlyfire_monster, "0", "Enables/disables friendly fire between monsters. The bullets will appear to pass through monsters that are friendly to one another, if disabled.");
	autocvar (tc_sv_friendlyfire_misc, "0", "Enables/disables friendly fire between misc objects.");
	autocvar (tc_sv_hitscan, "0", "Enables/disables hitscan (instant hits from bullet-based weapons). NOTE: Temporal Cortex was not meant to be played with hitscan. In many levels, you WILL get gunned down almost immediately. Take caution with this variable.");
	autocvar (tc_sv_pushable_velocity_scale, "1.0", "Scales the velocity from func_pushable when touched.");
	autocvar (tc_sv_grapple_velocity_scale, "1.0", "Scales the velocity when the grappling hook has a target.");
	autocvar (tc_sv_army_grenadier_damage, "40");
	autocvar (tc_sv_army_grenadier_accuracy_x, "0.0");
	autocvar (tc_sv_army_grenadier_accuracy_y, "0.0");
	autocvar (tc_sv_army_grenadier_accuracy_z, "0.0");
	autocvar (tc_sv_army_grenadier_barrage_accuracy_x, "0.1");
	autocvar (tc_sv_army_grenadier_barrage_accuracy_y, "0.1");
	autocvar (tc_sv_army_grenadier_barrage_accuracy_z, "0.0");
	autocvar (tc_sv_army_shotgunner_damage, "2");
	autocvar (tc_sv_army_shotgunner_barrage_damage, "2");
	autocvar (tc_sv_army_shotgunner_accuracy_x, "0.1");
	autocvar (tc_sv_army_shotgunner_accuracy_y, "0.1");
	autocvar (tc_sv_army_shotgunner_accuracy_z, "0.0");
	autocvar (tc_sv_army_shotgunner_barrage_accuracy_x, "0.2");
	autocvar (tc_sv_army_shotgunner_barrage_accuracy_y, "0.2");
	autocvar (tc_sv_army_shotgunner_barrage_accuracy_z, "0.0");
	autocvar (tc_sv_army_heavygunner_damage, "12");
	autocvar (tc_sv_army_heavygunner_barrage_damage, "8");
	autocvar (tc_sv_army_heavygunner_accuracy_x, "0.01");
	autocvar (tc_sv_army_heavygunner_accuracy_y, "0.01");
	autocvar (tc_sv_army_heavygunner_accuracy_z, "0.0");
	autocvar (tc_sv_army_heavygunner_barrage_accuracy_x, "0.05");
	autocvar (tc_sv_army_heavygunner_barrage_accuracy_y, "0.05");
	autocvar (tc_sv_army_heavygunner_barrage_accuracy_z, "0.0");
	autocvar (tc_sv_army_rocketeer_accuracy_x, "0.0");
	autocvar (tc_sv_army_rocketeer_accuracy_y, "0.0");
	autocvar (tc_sv_army_rocketeer_accuracy_z, "0.0");
	autocvar (tc_sv_army_rocketeer_barrage_accuracy_x, "0.0");
	autocvar (tc_sv_army_rocketeer_barrage_accuracy_y, "0.0");
	autocvar (tc_sv_army_rocketeer_barrage_accuracy_z, "0.0");
	autocvar (tc_sv_timehunter_damage, "6");
	autocvar (tc_sv_timehunter_accuracy_x, "0.05");
	autocvar (tc_sv_timehunter_accuracy_y, "0.05");
	autocvar (tc_sv_timehunter_accuracy_z, "0.0");

	// Guns misc
	autocvar (tc_sv_bullet_penetration, "1");

	// Bullet speeds
	// NOTE: Speeds are real-world ballistic velocities in ft/s multiplied by 4
	// Could not find info on ballistic data for shotgun shells, as they're a lot different.
	autocvar (tc_sv_ammo_12gauge_speed, "6500");
	autocvar (tc_sv_ammo_10gauge_speed, "4500");
	autocvar (tc_sv_ammo_6gauge_speed, "3000");
	autocvar (tc_sv_ammo_9x18mm_speed, "4200");
	autocvar (tc_sv_ammo_9x19mm_speed, "4720");
	autocvar (tc_sv_ammo_357magnum_speed, "5800");
	autocvar (tc_sv_ammo_44magnum_speed, "4720");
	autocvar (tc_sv_ammo_45acp_speed, "3340");
	autocvar (tc_sv_ammo_4570govt_speed, "5400");
	autocvar (tc_sv_ammo_5090sharps_speed, "7256");
	autocvar (tc_sv_ammo_9x39mm_speed, "2500");
	autocvar (tc_sv_ammo_545x39mm_speed, "5400");
	autocvar (tc_sv_ammo_556x45mm_speed, "5300");
	autocvar (tc_sv_ammo_762x39mm_speed, "6500");
	autocvar (tc_sv_ammo_762x51mm_speed, "6500");
	autocvar (tc_sv_ammo_12x7mm_speed, "12176");

	// Guns damage
	autocvar (tc_sv_shotgun_damage, "6");
	autocvar (tc_sv_super_shotgun_damage, "12");
	autocvar (tc_sv_army_helicopter_turret_damage, "4");

	// Missi: Hashed strings for quicker lookups (2026.10.31)
	// Missi: Standard quake weapons (2026.10.31)
	stringpool_add_string("weapon_axe")
	stringpool_add_string("weapon_shotgun");
	stringpool_add_string("weapon_supershotgun")
	stringpool_add_string("weapon_nailgun")
	stringpool_add_string("weapon_supernailgun")
	stringpool_add_string("weapon_grenadelauncher")
	stringpool_add_string("weapon_rocketlauncher")
	stringpool_add_string("weapon_lightning")

	// Missi: Temporal Cortex extra weapons (2026.10.31)
	stringpool_add_string("weapon_uzi")
	stringpool_add_string("weapon_mac10")
	stringpool_add_string("weapon_vector")
#endif

//
// Setup light animation tables. 'a' is total darkness, 'z' is maxbright.
//

	// 0 normal
	lightstyle(0, "m");
	
	// 1 FLICKER (first variety)
	lightstyle(1, "mmnmmommommnonmmonqnmmo");
	
	// 2 SLOW STRONG PULSE
	lightstyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");
	
	// 3 CANDLE (first variety)
	lightstyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");
	
	// 4 FAST STROBE
	lightstyle(4, "mamamamamama");
	
	// 5 GENTLE PULSE 1
	lightstyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");
	
	// 6 FLICKER (second variety)
	lightstyle(6, "nmonqnmomnmomomno");
	
	// 7 CANDLE (second variety)
	lightstyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");
	
	// 8 CANDLE (third variety)
	lightstyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");
	
	// 9 SLOW STROBE (fourth variety)
	lightstyle(9, "aaaaaaaazzzzzzzz");
	
	// 10 FLUORESCENT FLICKER
	lightstyle(10, "mmamammmmammamamaaamammma");

	// 11 SLOW PULSE NOT FADE TO BLACK
	lightstyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");
	
	// styles 32-62 are assigned by the light program for switchable lights

	// 63 testing
	lightstyle(63, "a");

	serverusingcsqc = checkextension("EXT_CSQC") || checkextension("EXT_CSQC_1");
	if (!serverusingcsqc)
	{
		if (checkbuiltin(print))
			print("Server does not support csqc\n");
		else
		{
			cvar_set("developer", "1");
			dprint("Server is not using csqc\n");
		}
	}
};

void() StartFrame =
{
	teamplay = cvar("teamplay");
	skill = cvar("skill");
	framecount = framecount + 1;
};



float(entity ent, float fl) BodyqueCSQC =
{
	return FALSE;
};

entity  bodyque_head;

void() InitBodyQue =
{
	bodyque_head = spawn();
	bodyque_head.classname = "bodyque";
	bodyque_head.owner = spawn();
	bodyque_head.owner.classname = "bodyque";
	bodyque_head.owner.owner = spawn();
	bodyque_head.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner = spawn();
	bodyque_head.owner.owner.owner.classname = "bodyque";
	bodyque_head.owner.owner.owner.owner = bodyque_head;
};


// make a body que entry for the given ent so the ent can be
// respawned elsewhere
void(entity ent) CopyToBodyQue =
{
	bodyque_head.angles = ent.angles;
	bodyque_head.model = ent.model;
	bodyque_head.modelindex = ent.modelindex;
	bodyque_head.frame = ent.frame;
	bodyque_head.colormap = ent.colormap;
	bodyque_head.movetype = ent.movetype;
	bodyque_head.velocity = ent.velocity;
	bodyque_head.flags = 0;
	bodyque_head.SendEntity = BodyqueCSQC;
	setorigin (bodyque_head, ent.origin);
	setsize (bodyque_head, ent.mins, ent.maxs);
	bodyque_head = bodyque_head.owner;
};



