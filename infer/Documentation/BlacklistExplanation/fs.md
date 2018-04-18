**File Location:** linux/fs  
**Kernel Version:**  Linux-stable v4.15  
**Kernel Configuration:** defconfig  
**Infer Version:** HEAD commit: 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Error Explanation When Not Blacklisted:**  
```
fs/pipe.o: In function `anon_pipe_buf_steal':
fs/pipe.c:(.text+0x3423): undefined reference to `memcg_kmem_uncharge'
fs/block_dev.o: In function `blkdev_writepages':
fs/block_dev.c:(.text+0x43be): undefined reference to `dax_writeback_mapping_range'
fs/proc/task_mmu.o: In function `clear_refs_pte_range':
fs/proc/task_mmu.c:(.text+0x4727): undefined reference to `pmdp_test_and_clear_young'
fs/ext4/inode.o: In function `ext4_writepages':
fs/ext4/inode.c:(.text+0xebab): undefined reference to `dax_writeback_mapping_range'
Makefile:1000: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1
```
