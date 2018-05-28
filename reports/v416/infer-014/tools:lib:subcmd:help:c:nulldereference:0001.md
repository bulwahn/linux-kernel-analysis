# Analysis Report 0001 #

## General ##
**Warning Type:** NULL_DEREFERENCE  
**Warning Explanation:** Pointer `ent` last assigned on line 18 could be null and is dereferenced at line 20, column 2.   
```C
    	struct cmdname *ent = malloc(sizeof(*ent) + len + 1);
     
   		ent->len = len;
    	memcpy(ent->name, name, len);
     	ent->name[len] = 0;
```
**File Location:** tools/lib/subcmd/help.c:20
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --

## Manuel Assesment ##
**Classification:** POSITIVE, There may be an error during runtime
### Rationale ###
It is very clear that, If malloc function fails, then there will be a segmentation error at line 20:
```C
void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
{
	struct cmdname *ent = malloc(sizeof(*ent) + len + 1);

	ent->len = len;
	memcpy(ent->name, name, len);
	ent->name[len] = 0;

	ALLOC_GROW(cmds->names, cmds->cnt + 1, cmds->alloc);
	cmds->names[cmds->cnt++] = ent;
}
```
**Resolution:**
We can simply add an if line after malloc, and check if ent is null or not:
```C
void add_cmdname(struct cmdnames *cmds, const char *name, size_t len)
{
	struct cmdname *ent = malloc(sizeof(*ent) + len + 1);
	if(!ent) return;
	ent->len = len;
	memcpy(ent->name, name, len);
	ent->name[len] = 0;

	ALLOC_GROW(cmds->names, cmds->cnt + 1, cmds->alloc);
	cmds->names[cmds->cnt++] = ent;
}
```
