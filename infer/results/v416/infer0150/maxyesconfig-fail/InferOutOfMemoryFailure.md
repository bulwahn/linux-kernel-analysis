## Infer Failure Report ##
**Infer Version:** Infer 0.15.0  
**Kernel Version:** Linux-4.16  
**Kernel Configuration:** [Maximalyesconfig](failure-files/SigKillFailureFiles/maximalyesconfig)  
**Infer Configuration:** [Inferconfig](failure-files/SigKillFailureFiles/infermaximalyesconfig)  
**Command:**  ```infer analyze --jobs 1```  
**Error Message:** [Out-of-Memory-Error](failure-files/OutOfMemoryFiles/error_message.txt)  

## Summary ##
- First I read end of the log file with using ```cat logs | tail -n 1000``` [tail-file](failure-files/OutOfMemoryFiles/tail_logs.txt)  , as you can see in there there are many debug lines about ```struct driver_attribute```, ```struct pv_irq_ops``` and ```struct pv_lock_ops```.  
- Since before end of file, infer continuously printed about ```struct driver_attribute```, I focused on it.  
- Output of ```cat tail_logs.txt | grep "typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct driver_attribute" | wc -l``` is ```1260``` that value is significanlty low in comparision to values that I found in the previous [sigkill-failure-report](InferSigKillFailure.md)  
- Then I found first ```typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct driver_attribute``` line with using ```cat logs | grep -n "typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct driver_attribute" | head``` command and it's line number is  : ```3843065``` and its result is [here](failure-files/OutOfMemoryFiles/first_struct_driver_attribute_line.txt)  
- As a next step, I checked ```logs``` file with ```awk 'NR >= 3843060 && NR <= 3843066' logs``` command to find-out what was the output of infer, before first ```typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct driver_attribute``` printed. You can find result in [here](failure-files/OutOfMemoryFiles/before_first_driver_attribute.txt)  
- Since we ran this infer analyze with only 1 thread, I think ```struct pv_lock_ops``` is safe.  

