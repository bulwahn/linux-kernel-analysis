# Analysis Report 0001 #

## General ##
**Warning Type:** Memory Leak  
**Warning Explanation:**
```

  `tail->next` is not reachable after line 27, column 4.
  25.   		/* if equal, take 'a' -- important for sort stability */
  26.   		if ((*cmp)(priv, a, b) <= 0) {
  27. > 			tail->next = a;
  28.   			a = a->next;
  29.   		} else {
```
```

  `tail->next` is not reachable after line 30, column 4.
  28.   			a = a->next;
  29.   		} else {
  30. > 			tail->next = b;
  31.   			b = b->next;
  32.   		}
```  
**File Location:** lib/list_sort.c
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --
## Manuel Assesment ##
**Classification:** Not sure author did this for optimization, but in my opinion there may be a memory leak.
### Rationale ###
In this example, after assignment infer thinks we cannot get tail->next's previous reference anyway. So it suggests first we should free tail->next value and than assign it to a, or b.

I have created a minimal example for this case as following:
```C
#include<stdio.h>
#include<malloc.h>
struct list_element {
	struct list_element *next, *prev;
	int element;
};

int change(struct list_element *a, struct list_element *b) {
	struct list_element head, *tail = &head;
	while(a && b) {
		if(a->element > b->element) {
			//free(tail->next);
			tail->next = a;
			a = a->next;
		} else {
			//free(tail->next);
			tail->next = b;
			b = b->next;
		}
		tail = tail->next;
	}
	tail->next = a?:b;
	return 1;
}


int main() {
	struct list_element l1 = {NULL, NULL, 5};
	struct list_element l2 = {NULL, NULL ,4};
	change(&l1, &l2);
	return 0;
}
```
With this piece of code, Infer creates an error which is very similar to its output on lib/list_sort.c:
```
list_sort.c:13: error: MEMORY_LEAK
  `tail->next` is not reachable after line 13, column 4.
  11.   		if(a->element > b->element) {
  12.   			//free(tail->next);
  13. > 			tail->next = a;
  14.   			a = a->next;
  15.   		} else {

list_sort.c:17: error: MEMORY_LEAK
  `tail->next` is not reachable after line 17, column 4.
  15.   		} else {
  16.   			//free(tail->next);
  17. > 			tail->next = b;
  18.   			b = b->next;
  19.   		}
```
However if I delete comments that are placed in front of  ```free``` function, Infer won't show any warnings. Actually since this code modified optimized in commit: 835cc0c8477f(lib: more scalable list_sort()), I want to be sure about that author did this in aware of this problem, but wants to get a better speed.
