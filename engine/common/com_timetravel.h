#pragma once

#ifdef TEMPORALCORTEX
typedef enum
{
	TIME_PERIOD_PRESENT,
	TIME_PERIOD_PAST,
	TIME_PERIOD_FUTURE,
	MAX_TIME_PERIODS
} timeperiod_t;

#ifdef HAVE_SERVER
extern int tc_sv_loaded_bsps;	// Missi: Incremented as each BSP is found (2026.2.7)
extern int sv_current_bsp_index;	// Missi: Incremented as each BSP is parsed, then reset back to 0. Changes at the server changes time period, too. (2026.2.7)
#endif
#ifdef HAVE_CLIENT
extern int tc_cl_loaded_bsps;	// Missi: Incremented as each BSP is found (2026.2.7)
extern int cl_current_bsp_index;	// Missi: Incremented as each BSP is parsed, then reset back to 0. Changes at the server changes time period, too. (2026.2.7)
#endif
#endif
