# Analysis Report 0003 #

## General ##
**Warning Type:** NULL_DEREFERENCE  
**Warning Explanation:**  pointer `bind` last assigned on line 723 could be null and is dereferenced at line 724, column 9.
```C
   	config = p4_general_events[hw_event];
   	bind = p4_config_get_bind(config);
 	esel = P4_OPCODE_ESEL(bind->opcode);
 	config |= p4_config_pack_cccr(P4_CCCR_ESEL(esel));

```
**File Location:** arch/x86/events/intel/p4.c:724:
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --

## Manuel Assesment ##
**Classification:** 
### Rationale ###
As Infer stated, there may be a problem in ```P4_OPCODE_ESEL(bind->opcode);``` call, if bind points to an invalid memory address.
```C
static u64 p4_pmu_event_map(int hw_event)
{
	struct p4_event_bind *bind;
	unsigned int esel;
	u64 config;

	config = p4_general_events[hw_event];
	bind = p4_config_get_bind(config);
	esel = P4_OPCODE_ESEL(bind->opcode);
	config |= p4_config_pack_cccr(P4_CCCR_ESEL(esel));

	return config;
}
```
Let's start with ```config = p4_general_events[hw_event]``` line to check ```config```'s possible values:  
```p4_general_events``` is a huge u64 array as following:  
```C
static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
  /* non-halted CPU clocks */
  [PERF_COUNT_HW_CPU_CYCLES] =
	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_GLOBAL_POWER_EVENTS)		|
		P4_ESCR_EMASK_BIT(P4_EVENT_GLOBAL_POWER_EVENTS, RUNNING))	|
		P4_CONFIG_ALIASABLE,

  /*
   * retired instructions
   * in a sake of simplicity we don't use the FSB tagging
   */
  [PERF_COUNT_HW_INSTRUCTIONS] =
	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_INSTR_RETIRED)		|
		P4_ESCR_EMASK_BIT(P4_EVENT_INSTR_RETIRED, NBOGUSNTAG)		|
		P4_ESCR_EMASK_BIT(P4_EVENT_INSTR_RETIRED, BOGUSNTAG)),

  /* cache hits */
  [PERF_COUNT_HW_CACHE_REFERENCES] =
	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_BSQ_CACHE_REFERENCE)		|
		P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_2ndL_HITS)	|
		P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_2ndL_HITE)	|
		P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_2ndL_HITM)	|
		P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_3rdL_HITS)	|
		P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_3rdL_HITE)	|
		P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_3rdL_HITM)),

  /* cache misses */
  [PERF_COUNT_HW_CACHE_MISSES] =
	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_BSQ_CACHE_REFERENCE)		|
		P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_2ndL_MISS)	|
		P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, RD_3rdL_MISS)	|
		P4_ESCR_EMASK_BIT(P4_EVENT_BSQ_CACHE_REFERENCE, WR_2ndL_MISS)),

  /* branch instructions retired */
  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS] =
	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_RETIRED_BRANCH_TYPE)		|
		P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_BRANCH_TYPE, CONDITIONAL)	|
		P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_BRANCH_TYPE, CALL)		|
		P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_BRANCH_TYPE, RETURN)		|
		P4_ESCR_EMASK_BIT(P4_EVENT_RETIRED_BRANCH_TYPE, INDIRECT)),

  /* mispredicted branches retired */
  [PERF_COUNT_HW_BRANCH_MISSES]	=
	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_MISPRED_BRANCH_RETIRED)	|
		P4_ESCR_EMASK_BIT(P4_EVENT_MISPRED_BRANCH_RETIRED, NBOGUS)),

  /* bus ready clocks (cpu is driving #DRDY_DRV\#DRDY_OWN):  */
  [PERF_COUNT_HW_BUS_CYCLES] =
	p4_config_pack_escr(P4_ESCR_EVENT(P4_EVENT_FSB_DATA_ACTIVITY)		|
		P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DRDY_DRV)		|
		P4_ESCR_EMASK_BIT(P4_EVENT_FSB_DATA_ACTIVITY, DRDY_OWN))	|
	p4_config_pack_cccr(P4_CCCR_EDGE | P4_CCCR_COMPARE),
};
```
Then continue with ```p4_config_get_bind(config)``` function  
```C

static struct p4_event_bind *p4_config_get_bind(u64 config)
{
	unsigned int evnt = p4_config_unpack_event(config);
	struct p4_event_bind *bind = NULL;

	if (evnt < ARRAY_SIZE(p4_event_bind_map))
		bind = &p4_event_bind_map[evnt];

	return bind;
}
```
As you can see, if ```evnt > ARRAY_SIZE(p4_event_bind_map)```, then bind will be returned as a ```NULL``` value.  
However to learn if it is possible during runtime or not, we must find ```evnt```'s possible values and length of ```ARRAY_SIZE(p4_event_bind_map)```  
--> TODO Look Later more detailed

 








