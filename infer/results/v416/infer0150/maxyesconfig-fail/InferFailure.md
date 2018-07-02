## Infer Failure Report ##
**Infer Version:** Infer 0.15.0  
**Kernel Version:** Linux-4.16  
**Kernel Configuration:** [Maximalyesconfig](files/maximalyesconfig)  
**Infer Configuration:** [Inferconfig](files/infermaximalyesconfig)  
**Command:**  ```infer analyze --jobs 2```  
**Error Message:** [Error-File](files/infer_failure_log.txt)  

## Summary ##
Since ```infer-out/logs``` file is so huge, I can't upload it to here.It is ```1,2G``` and ```wc -l``` result is ```17808166```.  
I will describe my investigation process.
- First, I looked at end of the log file with using ```cat logs | tail -n 1000``` [tail-file](files/tail_logs.txt), and saw that there are
so many lines related with ```pv_irq_ops``` and ```pv_lock_ops```.
- Then searched in the ```logs``` file, to find out how many lines has ```typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct pv_lock_ops```
with using ```cat logs | grep "typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct pv_irq_ops" | wc -l``` and result was ```5136499```.
- Next, I found the first encounter with ```typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct pv_irq_ops``` in ```bugs``` file with command:
 ```cat logs | grep -n "typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct pv_irq_ops" | head``` and result was:  
```3375898:[392][      debug] typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct pv_irq_ops```.
- So I checked have opened ```bugs``` file again with using: ```awk 'NR >= 3374500 && NR <= 3375900' logs``` command [starting-from-pv-irq-ops](files/logs_starting_from_first_pv_irq_ops.txt). After looking a file , I saw that, before lines about ```struct pv_lock_ops``` started, there are debug messages like ```typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct mod_tree_root```.
- Then I started to investigate ```mod_tree_root``` lines, and checked file with ```cat logs | grep -n "typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct mod_tree_root" | head``` and result was: ```3373979```
- Finally I opened ```logs``` file with ```cat logs | grep -nawk 'NR >= 3373950 && NR <= 3373980' logs```,[starting-from-mod-tree](files/logs_starting_from_first_mod_tree_root.txt). As you can see in the file, Infer started to print```typ_get_recursive_flds: unexpected sizeof(t=) unknown struct type: struct mod_tree_root``` just after ```infer analyze``` started.



