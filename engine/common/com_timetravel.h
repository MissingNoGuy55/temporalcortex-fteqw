#pragma once

#ifdef TEMPORALCORTEX
typedef enum
{
	TIME_PERIOD_PRESENT,
	TIME_PERIOD_PAST,
	TIME_PERIOD_FUTURE,
	MAX_TIME_PERIODS	// Missi: This is what you want to use with arrays like sv.worldmodel and cl.worldmodel, etc. (2026.5.17)
} timeperiod_t;

#ifdef HAVE_SERVER
// Missi: Incremented as each BSP is found and is used in loops and checks for entity indices.
// The array for worldmodels is a fixed size, but the entity list is initialized based on how many worlds were
// successfully found, not by sv.world.worldmodel indices. So while entity 0 is always xxx_present.bsp, entity 1
// may be the past or the future, depending on if xxx_past.bsp was found. (2026.7.1)
extern int tc_sv_loaded_bsps;

// Missi: Amount of BSPs that are not loaded. Also applies to amount of empty worldmodels that were found
// in sv.world.worldmodel. (2026.5.30)
extern int tc_sv_unloaded_bsps;

// Missi: Incremented as each BSP is parsed in SV_SpawnServer, then reset back to 0. Changes with "cl_changetimeperiod" console command. (2026.7.1)
extern int tc_sv_current_bsp_index;
#endif
#ifdef HAVE_CLIENT

extern int tc_cl_loaded_bsps;

extern int tc_cl_unloaded_bsps;

extern int tc_cl_current_bsp_index;

#endif
#endif
