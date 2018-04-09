## Summary
There are 7 RESOURCE_LEAK errors in one file within one function.
They are being detected in both raw and version 1.1 infer analysis.

##  Error Location
```c
// In file tools/objtool/orc_dump.c.
 74 int orc_dump(const char *_objname)
 75 {
        // ....

 94     fd = open(objname, O_RDONLY);
 95     if (fd == -1) {
 96         perror("open");
 97         return -1;
 98     }
 99 
100     elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
101     if (!elf) {

tools/objtool/orc_dump.c:102: error: RESOURCE_LEAK
  resource acquired by call to `open()` at line 94, column 7 is not released after line 102, column 3.
 
102 >       WARN_ELF("elf_begin");
103         return -1;
104     }
105 

tools/objtool/orc_dump.c:107: error: RESOURCE_LEAK
  resource acquired by call to `open()` at line 94, column 7 is not released after line 107, column 3.
 
106     if (elf_getshdrnum(elf, &nr_sections)) {
107 >       WARN_ELF("elf_getshdrnum");
108         return -1;
109     }
110 

tools/objtool/orc_dump.c:112: error: RESOURCE_LEAK
  resource acquired by call to `open()` at line 94, column 7 is not released after line 112, column 3.

111     if (elf_getshdrstrndx(elf, &shstrtab_idx)) {
112 >       WARN_ELF("elf_getshdrstrndx");
113         return -1;
114     }
115 

tools/objtool/orc_dump.c:119: error: RESOURCE_LEAK
  resource acquired by call to `open()` at line 94, column 7 is not released after line 119, column 4.

116     for (i = 0; i < nr_sections; i++) {
117         scn = elf_getscn(elf, i);
118         if (!scn) {
119 >           WARN_ELF("elf_getscn");
120             return -1;
121         }
122 

tools/objtool/orc_dump.c:124: error: RESOURCE_LEAK
  resource acquired by call to `open()` at line 94, column 7 is not released after line 124, column 4.

123         if (!gelf_getshdr(scn, &sh)) {
124 >           WARN_ELF("gelf_getshdr");
125             return -1;
126         }
127 

tools/objtool/orc_dump.c:130: error: RESOURCE_LEAK
  resource acquired by call to `open()` at line 94, column 7 is not released after line 130, column 4.

128         name = elf_strptr(elf, shstrtab_idx, sh.sh_name);
129         if (!name) {
130 >           WARN_ELF("elf_strptr");
131             return -1;
132         }
133 

tools/objtool/orc_dump.c:136: error: RESOURCE_LEAK
  resource acquired by call to `open()` at line 94, column 7 is not released after line 136, column 4.

134         data = elf_getdata(scn, NULL);
135         if (!data) {
136 >           WARN_ELF("elf_getdata");
137             return -1;
138         }
139 

```


## Analysis

It returns without closing fd, so I think it's kind of resource leak,
but it is a user-space tool and it would be invoked by cmd_orc() as a terminal program and return -1 if failed.
Soon it will be fixed by resource reclamation by the OS.

## Conclusion
User space tool, Low Severity
