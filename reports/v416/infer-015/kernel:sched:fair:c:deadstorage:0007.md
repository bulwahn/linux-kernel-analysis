# Analysis Report 0007 #

## General ##
**Warning Type:** DEAD_STORE  
**Warning Explanation:** The value written to &now (type unsigned long) is never used.   
```C 
static inline bool nohz_kick_needed(struct rq *rq)
{
	unsigned long now = jiffies;
	struct sched_domain_shared *sds;
	struct sched_domain *sd;
```
**File Location:** kernel/sched/fair.c:9312  
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --  
**Similar Case:**
## Manuel Assesment ##
**Classification:** False - Positive  
### Rationale ###
```C
static inline bool nohz_kick_needed(struct rq *rq)
{
	unsigned long now = jiffies;
	struct sched_domain_shared *sds;
	struct sched_domain *sd;
	int nr_busy, i, cpu = rq->cpu;
	bool kick = false;

	if (unlikely(rq->idle_balance))
		return false;

       /*
	* We may be recently in ticked or tickless idle mode. At the first
	* busy tick after returning from idle, we will update the busy stats.
	*/
	set_cpu_sd_state_busy();
	nohz_balance_exit_idle(cpu);

	/*
	 * None are in tickless mode and hence no need for NOHZ idle load
	 * balancing.
	 */
	if (likely(!atomic_read(&nohz.nr_cpus)))
		return false;

	if (time_before(now, nohz.next_balance))
		return false;
```  
As we can observe in here, it is very obvious that ```unsigned long now``` value passed to ```time_before(now, nohz.next_balance)```. This function defined as a macro in ```include/linux/jiffies.h```  
```C
#define time_after(a,b)		\
	(typecheck(unsigned long, a) && \
	 typecheck(unsigned long, b) && \
	 ((long)((b) - (a)) < 0))
#define time_before(a,b)	time_after(b,a)
```  
So thats a very obvious false-positive warning, and its suprising that Infer created a warning in this case
