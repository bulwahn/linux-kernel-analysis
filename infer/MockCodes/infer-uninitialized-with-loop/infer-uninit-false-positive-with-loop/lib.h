#include<stdio.h>



int assign_func(int* dummy) {
	*dummy = 10;
	return 1;
}

int ret_func(int* dummy) {
	return assign_func(dummy);
}

int first_func(int value) {

	int i;
	int dummy;
	for(i=0; ;i++) {
		ret_func(&dummy);
		if(i == 5) break;
		/* with this break I tried to imitate:
			if (total_time >= HUB_DEBOUNCE_TIMEOUT)
			break;
		*/
	}
	return dummy;
}

