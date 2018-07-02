#define time_after(a,b)		\
	(((long)((b) - (a)) < 0))
#define time_before(a,b)	time_after(b,a)
