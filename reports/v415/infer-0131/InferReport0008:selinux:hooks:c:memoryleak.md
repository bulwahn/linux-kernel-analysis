# Analysis Report 0008 #

## General ##
**Warning Type:** Memory Leak  
**Warning Explanation:**
```
  `return` is not reachable after line 3149, column 3.
  3147.   
  3148.   	if (cap_capable(cred, &init_user_ns, CAP_MAC_ADMIN, cap_audit))
  3149. > 		return false;
  3150.   	if (cred_has_capability(cred, CAP_MAC_ADMIN, cap_audit, true))
  3151.   		return false;
```  
**File Location:** security/selinux/hooks.c
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --
## Manuel Assesment ##
**Classification:** False-Positive
### Rationale ###
```C
static bool has_cap_mac_admin(bool audit)
{
	const struct cred *cred = current_cred();
	int cap_audit = audit ? SECURITY_CAP_AUDIT : SECURITY_CAP_NOAUDIT;

	if (cap_capable(cred, &init_user_ns, CAP_MAC_ADMIN, cap_audit))
		return false;
	if (cred_has_capability(cred, CAP_MAC_ADMIN, cap_audit, true))
		return false;
	return true;
}
```
To understand if it is false positive or not, we must check ```cap_capable``` functions return values.
It is located in: security/commoncap.c file, and defined as:
```C
int cap_capable(const struct cred *cred, struct user_namespace *targ_ns,
		int cap, int audit)
{
	struct user_namespace *ns = targ_ns;

	/* See if cred has the capability in the target user namespace
	 * by examining the target user namespace and all of the target
	 * user namespace's parents.
	 */
	for (;;) {
		/* Do we have the necessary capabilities? */
		if (ns == cred->user_ns)
			return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;

		/*
		 * If we're already at a lower level than we're looking for,
		 * we're done searching.
		 */
		if (ns->level <= cred->user_ns->level)
			return -EPERM;

		/* 
		 * The owner of the user namespace in the parent of the
		 * user namespace has all caps.
		 */
		if ((ns->parent == cred->user_ns) && uid_eq(ns->owner, cred->euid))
			return 0;

		/*
		 * If you have a capability in a parent user ns, then you have
		 * it over all children user namespaces as well.
		 */
		ns = ns->parent;
	}

	/* We never get here */
}
```
It may return either ```0``` or ```-EPERM``` value. We need to look at ```EPERM``` value more carefully. This value defined in:
include/uapi/asm-generic/errno-base.h file as:  
``` #define	EPERM		 1	/* Operation not permitted */```

It is very obvious that this function will return ```-EPERM``` value if user doesn't has capability, which that lead an evaluation of
```if (cap_capable(cred, &init_user_ns, CAP_MAC_ADMIN, cap_audit))``` function true. However Infer couldn't detect that and raises an error about memory leak.


