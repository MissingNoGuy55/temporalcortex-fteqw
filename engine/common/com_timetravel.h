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
extern int tc_sv_loaded_bsps;	// Missi: Incremented as each BSP is found. Do NOT use this with arrays! (2026.2.7)
extern int tc_sv_unloaded_bsps;	// Missi: Amount of BSPs that are not loaded. Also applies to empty worldmodels. (2026.5.30)
extern int sv_current_bsp_index;	// Missi: Incremented as each BSP is parsed, then reset back to 0. Changes at the server changes time period, too. (2026.2.7)
#endif
#ifdef HAVE_CLIENT
extern int tc_cl_loaded_bsps;	// Missi: Incremented as each BSP is found. Do NOT use this with arrays! (2026.2.7)
extern int tc_cl_unloaded_bsps;	// Missi: Amount of BSPs that are not loaded. Also applies to empty worldmodels. (2026.5.30)
extern int cl_current_bsp_index;	// Missi: Incremented as each BSP is parsed, then reset back to 0. Changes at the server changes time period, too. (2026.2.7)
#endif
#endif
