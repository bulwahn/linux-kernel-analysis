## Summary
There are 2 MEMORY_LEAK errors in both raw and version 1.1 infer analysis which would decriped below.

##  Error Location
```c
// In file tools/lib/subcmd/sigchain.c
 21 static int sigchain_push(int sig, sigchain_fun f)
 22 {
 23     struct sigchain_signal *s = signals + sig;
 24     check_signum(sig);
 25 

 tools/lib/subcmd/sigchain.c:30: error: MEMORY_LEAK
  memory dynamically allocated by call to `xrealloc()` at line 26, column 2 is not reachable after line 30, column 2.

 26     ALLOC_GROW(s->old, s->n + 1, s->alloc);
 27     s->old[s->n] = signal(sig, f);
 28 >    if (s->old[s->n] == SIG_ERR)
 29         return -1; 

 tools/lib/subcmd/sigchain.c:29: error: MEMORY_LEAK
  memory dynamically allocated to `return` by call to `xrealloc()` at line 26, column 2 is not reachable after line 29, column 3.

 30     s->n++;
 31     return 0;
 32 } 
```


## Analysis
Within this function, the variable `signals` is a global static array with the type of struct sigchain_signal.

`static struct sigchain_signal signals[SIGCHAIN_MAX_SIGNALS];`

the pointer `*s` get the slot from `signals` and resize the space in macro `ALLOC_GROW` where the xrealloc was called.
```c
#define ALLOC_GROW(x, nr, alloc) \
	do { \
		if ((nr) > alloc) { \
			if (alloc_nr(alloc) < (nr)) \
				alloc = (nr); \
			else \
				alloc = alloc_nr(alloc); \
			x = xrealloc((x), alloc * sizeof(*(x))); \
		} \
	} while(0)
```

Then it assigns the value of `signal(sig, f)` to `s->old[s->n]` and decides to return or continue. To sum up, It uses pointer `*s` to manipulate the variable `singals` and wouldn't cause any memory leak.

## Conclusion
User space tool, False Positive
