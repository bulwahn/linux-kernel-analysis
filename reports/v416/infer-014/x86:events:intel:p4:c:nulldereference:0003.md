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
So Let's look at ```p4_config_get_bind``` function to be understand if bind may be an invalid value(like NULL) or not.
```C
static struct p4_event_bind *p4_config_get_bind(u64 config)
{
	unsigned int evnt = p4_config_unpack_event(config);
	struct p4_event_bind *bind = NULL;

	if (evnt < ARRAY_SIZE(p4_event_bind_map))
		bind = &p4_event_bind_map[evnt];

	return bind;
	static struct p4_event_bind p4_event_bind_map[] = {
}
```

Where p4_event_bind_map is an static struct arrat
