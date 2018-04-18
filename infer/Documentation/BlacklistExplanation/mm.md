**File Location:** linux/mm   
**Kernel Version:**  Linux-stable v4.15  
**Kernel Configuration:** defconfig  
**Infer Version:** HEAD commit: 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Error Explanation When Not Blacklisted:**
```
mm/page_alloc.o: In function `__free_pages_ok':
mm/page_alloc.c:(.text+0xad0): undefined reference to `memcg_kmem_uncharge'
mm/page_alloc.o: In function `__alloc_pages_nodemask':
mm/page_alloc.c:(.text+0x4689): undefined reference to `memcg_kmem_charge'
mm/page_alloc.o: In function `free_pcp_prepare':
mm/page_alloc.c:(.text+0xb5ed): undefined reference to `memcg_kmem_uncharge'
mm/truncate.o: In function `truncate_exceptional_pvec_entries':
mm/truncate.c:(.text+0x123f): undefined reference to `dax_delete_mapping_entry'
mm/truncate.o: In function `invalidate_exceptional_entry2':
mm/truncate.c:(.text+0x2037): undefined reference to `dax_invalidate_mapping_entry_sync'
mm/gup.o: In function `follow_pmd_mask':
mm/gup.c:(.text+0x3227): undefined reference to `follow_trans_huge_pmd'
mm/memory.o: In function `__handle_mm_fault':
mm/memory.c:(.text+0x6ec8): undefined reference to `huge_pud_set_accessed'
mm/memory.c:(.text+0x70cf): undefined reference to `huge_pmd_set_accessed'
mm/memory.o: In function `copy_pud_range':
mm/memory.c:(.text+0xa294): undefined reference to `copy_huge_pud'
mm/memory.o: In function `copy_pmd_range':
mm/memory.c:(.text+0xa4a6): undefined reference to `copy_huge_pmd'
mm/memory.o: In function `zap_pud_range':
mm/memory.c:(.text+0xbac2): undefined reference to `zap_huge_pud'
mm/memory.o: In function `zap_pmd_range':
mm/memory.c:(.text+0xbc90): undefined reference to `zap_huge_pmd'
mm/memory.o: In function `create_huge_pmd':
mm/memory.c:(.text+0xf06f): undefined reference to `do_huge_pmd_anonymous_page'
mm/memory.o: In function `wp_huge_pmd':
mm/memory.c:(.text+0xf19c): undefined reference to `do_huge_pmd_wp_page'
mm/mprotect.o: In function `change_pmd_range':
mm/mprotect.c:(.text+0x1180): undefined reference to `change_huge_pmd'
mm/mremap.o: In function `move_page_tables':
mm/mremap.c:(.text+0x213): undefined reference to `move_huge_pmd'
mm/madvise.o: In function `madvise_free_pte_range':
mm/madvise.c:(.text+0x231f): undefined reference to `madvise_free_huge_pmd'
mm/page_io.o: In function `frontswap_store':
mm/page_io.c:(.text+0x5c8): undefined reference to `__frontswap_store'
mm/page_io.o: In function `frontswap_load':
mm/page_io.c:(.text+0x11c8): undefined reference to `__frontswap_load'
mm/swapfile.o: In function `frontswap_invalidate_page':
mm/swapfile.c:(.text+0x8260): undefined reference to `__frontswap_invalidate_page'
mm/swapfile.o: In function `frontswap_invalidate_area':
mm/swapfile.c:(.text+0xa4a5): undefined reference to `__frontswap_invalidate_area'
mm/slub.o: In function `slab_pre_alloc_hook':
mm/slub.c:(.text+0x3359): undefined reference to `memcg_kmem_get_cache'
mm/slub.o: In function `slab_post_alloc_hook':
mm/slub.c:(.text+0x3860): undefined reference to `memcg_kmem_put_cache'
Makefile:1000: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1
```
