# Analysis Report 0005 #

## General ##
**Warning Type:** Memory Leak  
**Warning Explanation:**
```
`return` is not reachable after line 586, column 3.
  584.   		if (copy_from_user(&event, timer_event_spec, sizeof (event)))
  585.   			return -EFAULT;
  586. > 		return do_timer_create(which_clock, &event, created_timer_id);
  587.   	}
  588.   	return do_timer_create(which_clock, NULL, created_timer_id);
```  
```
`return` is not reachable after line 588, column 2.
  586.   		return do_timer_create(which_clock, &event, created_timer_id);
  587.   	}
  588. > 	return do_timer_create(which_clock, NULL, created_timer_id);
  589.   }
  590.
```
```
`return` is not reachable after line 601, column 3.
  599.   		if (get_compat_sigevent(&event, timer_event_spec))
  600.   			return -EFAULT;
  601. > 		return do_timer_create(which_clock, &event, created_timer_id);
  602.   	}
  603.   	return do_timer_create(which_clock, NULL, created_timer_id);
```
```
`return` is not reachable after line 603, column 2.
  601.   		return do_timer_create(which_clock, &event, created_timer_id);
  602.   	}
  603. > 	return do_timer_create(which_clock, NULL, created_timer_id);
  604.   }
  605.   #endif
```

**File Location:** kernel/time/posix-timers.c
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --
## Manuel Assesment ##
**Classification:** STILL NOT SURE,
### Rationale ###
I will investigate errors in two groups since 1 & 2 in the SYSCALL_DEFINE3 function and 3 & 4 in COMPAT_SYSCALL_DEFINE3 function.
#### Error 1 & 2 #####
Lets start with SYSCALL_DEFINE3 function, Infer claims that this function always exists with return -EFAULT.
```
SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
		struct sigevent __user *, timer_event_spec,
		timer_t __user *, created_timer_id)
{
	if (timer_event_spec) {
		sigevent_t event;

		if (copy_from_user(&event, timer_event_spec, sizeof (event)))
			return -EFAULT;
		return do_timer_create(which_clock, &event, created_timer_id);
	}
	return do_timer_create(which_clock, NULL, created_timer_id);
}
```
To understand current workflow in there, lets look at what is timer_event_spec ,which is inside include/linux/compat.h as:
```
asmlinkage long compat_sys_timer_create(clockid_t which_clock,
			struct compat_sigevent __user *timer_event_spec,
			timer_t __user *created_timer_id);
```

Continue modifiying current notes more readable and suitable for report structure.

