##Error 0001##
**File Location:** fs/exofs/ore.c  
**Error Message:**  
```
fs/exofs/ore.c:153:28: error: fields must have a constant size: 'variable length array in structure' extension will never be supported
                struct ore_per_dev_state per_dev[numdevs];
                                         ^
fs/exofs/ore.c:155:24: error: fields must have a constant size: 'variable length array in structure' extension will never be supported
                        struct osd_sg_entry sglist[sgs_per_dev * numdevs];
                                            ^
fs/exofs/ore.c:156:17: error: fields must have a constant size: 'variable length array in structure' extension will never be supported
                        struct page *pages[num_par_pages];
                                     ^
fs/exofs/ore.c:168:34: error: no member named 'pages' in 'struct __alloc_all_io_state'
                pages = num_par_pages ? _aios->pages : NULL;
                                        ~~~~~  ^
fs/exofs/ore.c:169:34: error: no member named 'sglist' in 'struct __alloc_all_io_state'
                sgilist = sgs_per_dev ? _aios->sglist : NULL;
                                        ~~~~~  ^
fs/exofs/ore.c:174:29: error: fields must have a constant size: 'variable length array in structure' extension will never be supported
                        struct ore_per_dev_state per_dev[numdevs];
                                                 ^
fs/exofs/ore.c:177:24: error: fields must have a constant size: 'variable length array in structure' extension will never be supported
                        struct osd_sg_entry sglist[sgs_per_dev * numdevs];
                                            ^
fs/exofs/ore.c:178:17: error: fields must have a constant size: 'variable length array in structure' extension will never be supported
                        struct page *pages[num_par_pages];
                                     ^
1 warning and 8 errors generated.
scripts/Makefile.build:316: recipe for target 'fs/exofs/ore.o' failed
make[2]: *** [fs/exofs/ore.o] Error 1
make[2]: *** Waiting for unfinished jobs....
```
