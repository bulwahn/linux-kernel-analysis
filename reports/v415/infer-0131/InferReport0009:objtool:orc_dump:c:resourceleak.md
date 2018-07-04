# Analysis Report 0009 #

## General ##
**Warning Type:** Resource Leak  
**Warning Explanation:**
```
  resource acquired by call to `open()` at line 94, column 7 is not released after line 102, column 3.
  100.   	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
  101.   	if (!elf) {
  102. > 		WARN_ELF("elf_begin");
  103.   		return -1;
  104.   	}
```
```
  resource acquired by call to `open()` at line 94, column 7 is not released after line 107, column 3.
  105.   
  106.   	if (elf_getshdrnum(elf, &nr_sections)) {
  107. > 		WARN_ELF("elf_getshdrnum");
  108.   		return -1;
  109.   	}
```
```
  resource acquired by call to `open()` at line 94, column 7 is not released after line 112, column 3.
  110.   
  111.   	if (elf_getshdrstrndx(elf, &shstrtab_idx)) {
  112. > 		WARN_ELF("elf_getshdrstrndx");
  113.   		return -1;
  114.   	}
```
```
  resource acquired by call to `open()` at line 94, column 7 is not released after line 119, column 4.
  117.   		scn = elf_getscn(elf, i);
  118.   		if (!scn) {
  119. > 			WARN_ELF("elf_getscn");
  120.   			return -1;
  121.   		}
```
```
  resource acquired by call to `open()` at line 94, column 7 is not released after line 124, column 4.
  122.   
  123.   		if (!gelf_getshdr(scn, &sh)) {
  124. > 			WARN_ELF("gelf_getshdr");
  125.   			return -1;
  126.   		}
```
```
  resource acquired by call to `open()` at line 94, column 7 is not released after line 130, column 4.
  128.   		name = elf_strptr(elf, shstrtab_idx, sh.sh_name);
  129.   		if (!name) {
  130. > 			WARN_ELF("elf_strptr");
  131.   			return -1;
  132.   		}
```
```
  resource acquired by call to `open()` at line 94, column 7 is not released after line 136, column 4.
  134.   		data = elf_getdata(scn, NULL);
  135.   		if (!data) {
  136. > 			WARN_ELF("elf_getdata");
  137.   			return -1;
  138.   		}

```  
**File Location:** tools/objtool/orc_dump.c
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --
## Manuel Assesment ##
**Classification:** It is an obvious error, but maybe programmer do that on purpose, I should continue to read documentation.
### Rationale ###
Facebook infer creates resource leak errors about, a file opened , however function exists without closing it and it may lead an resource leak.
Lets look at this function more detailed:
```C
int orc_dump(const char *_objname)
{
....
	fd = open(objname, O_RDONLY);
	if (fd == -1) {
		perror("open");
		return -1;
	}

	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
	if (!elf) {
		WARN_ELF("elf_begin");
		return -1;
	}

	if (elf_getshdrnum(elf, &nr_sections)) {
		WARN_ELF("elf_getshdrnum");
		return -1;
	}

	if (elf_getshdrstrndx(elf, &shstrtab_idx)) {
		WARN_ELF("elf_getshdrstrndx");
		return -1;
	}

	for (i = 0; i < nr_sections; i++) {
		scn = elf_getscn(elf, i);
		if (!scn) {
			WARN_ELF("elf_getscn");
			return -1;
		}

		if (!gelf_getshdr(scn, &sh)) {
			WARN_ELF("gelf_getshdr");
			return -1;
		}

		name = elf_strptr(elf, shstrtab_idx, sh.sh_name);
		if (!name) {
			WARN_ELF("elf_strptr");
			return -1;
		}

		data = elf_getdata(scn, NULL);
		if (!data) {
			WARN_ELF("elf_getdata");
			return -1;
		}
    .....
    .....
	if (!symtab || !orc || !orc_ip)
		return 0;

	if (orc_size % sizeof(*orc) != 0) {
		WARN("bad .orc_unwind section size");
		return -1;
	}

	nr_entries = orc_size / sizeof(*orc);
	for (i = 0; i < nr_entries; i++) {
		if (rela_orc_ip) {
			if (!gelf_getrela(rela_orc_ip, i, &rela)) {
				WARN_ELF("gelf_getrela");
				return -1;
			}

			if (!gelf_getsym(symtab, GELF_R_SYM(rela.r_info), &sym)) {
				WARN_ELF("gelf_getsym");
				return -1;
			}

			scn = elf_getscn(elf, sym.st_shndx);
			if (!scn) {
				WARN_ELF("elf_getscn");
				return -1;
			}

			if (!gelf_getshdr(scn, &sh)) {
				WARN_ELF("gelf_getshdr");
				return -1;
			}

			name = elf_strptr(elf, shstrtab_idx, sh.sh_name);
			if (!name || !*name) {
				WARN_ELF("elf_strptr");
				return -1;
			}

			printf("%s+%llx:", name, (unsigned long long)rela.r_addend);

		} else {
			printf("%llx:", (unsigned long long)(orc_ip_addr + (i * sizeof(int)) + orc_ip[i]));
		}
.....
	}

	elf_end(elf);
	close(fd);

	return 0;
}
```
As it can easily observed, in the ```int orc dump()``` function programmer opens a file using ```open(objname, O_RDONLY);``` function  
However after that he/she makes different control to be sure about that workflow is going well, but if he/she find a problem, exits with only  
printing  ```WARN_ELF``` and then returns -1. In my opinion before return -1, he/she should close file. However since it is a really obvious error,  
I have some doubts about , programmer does that on purpose. I read some documentation about objtool , however couldn't find a section about this topic.
