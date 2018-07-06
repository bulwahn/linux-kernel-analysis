#include<stdio.h>



int assign_func(int* dummy) {
	*dummy = 10;
	return 1;
}

void ret_func(int* dummy) {
	 assign_func(dummy);
}

int first_func(int value) {

	int i;
	int dummy;
	ret_func(&dummy);
	printf("Dummy is = %d \n", dummy);
	return dummy;
}

