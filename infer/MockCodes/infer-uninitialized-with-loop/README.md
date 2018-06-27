## Infer UNINITIALIZED_VALUE false-posive problem ##
**Infer Version:** : Infer version v0.14.0
**Original Warning:** : [drivers/usb/core/hub.c](https://github.com/OzanAlpay/linux-kernel-analysis/blob/clang-warning-reports/reports/v416/infer-014/drivers:usb:core:hub:c:uninitializedvalue:0004.md)  
### Testing ###
**Case 1:**  
```
cd infer-uninit-false-positive-with-loop
infer capture -- make
infer analyze
```
**Output:**  
```
lib.h:21: error: UNINITIALIZED_VALUE
  The value read from dummy was never initialized.
  19.   		ret_func(&dummy);
  20.   	}
  21. > 	return dummy;
  22.   }
  23.   
```
**Expected Output:**  
```
No issues found.
```  
**Case 2:**
```
cd infer-no-false-positive-without-loop
infer capture -- make
infer analyze
```
**Output:**
```
No issues found
```
**Expected Output:**
```
No issues found
```

**Summary:**
Only difference between this two examples is:  
In infer-uinit-false-positive-with-loop/lib.h, we call ret_func and assign a value to dummy inside a loop  
```C
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
```  
However infer-no-false-positive-without-loop/lib.h, we call ret_func and then assign a value to dummy without using a loop  
```C
int first_func(int value) {

	int i;
	int dummy;
	ret_func(&dummy);
	printf("Dummy is = %d \n", dummy);
	return dummy;
}
```
These two files infer output should be equal to ```No issues found```. Because in both cases, we assign a value to ```int dummy```



