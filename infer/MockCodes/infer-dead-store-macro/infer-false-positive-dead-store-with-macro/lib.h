#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include "macros.h"
#include "str.h"



int dummy_func() {
	unsigned long var = 5;
	srand(time(NULL));
	d_struct rnd;
	rnd.val = (unsigned int) rand();
	if(rnd.val < 10) {
		return 2;
	}
	if(time_before(var, rnd.val)) {
		return 0;
	} else {
		return 1;
	}
	
}
