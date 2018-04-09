## Summary
This MEMORY_LEAK error only exists version 1.1 infer analysis.

##  Error Location
```c
// In file scripts/basic/fixdep.c
269 static void do_config_file(const char *filename)
270 {
271     struct stat st;
272     int fd;
273     char *map;
274 
275     fd = open(filename, O_RDONLY);
276     if (fd < 0) {
277         fprintf(stderr, "fixdep: error opening config file: ");
278         perror(filename);
279         exit(2);
280     }
281     if (fstat(fd, &st) < 0) {
282         fprintf(stderr, "fixdep: error fstat'ing config file: ");
283         perror(filename);
284         exit(2);
285     }
286     if (st.st_size == 0) {
287         close(fd);
288         return;
289     }

scripts/basic/fixdep.c:297: error: MEMORY_LEAK
  memory dynamically allocated by call to `malloc()` at line 290, column 8 is not reachable after line 297, column 3.

290     map = malloc(st.st_size + 1);
291     if (!map) {
292         perror("fixdep: malloc");
293         close(fd);
294         return;
295     }
296     if (read(fd, map, st.st_size) != st.st_size) {
297 >       perror("fixdep: read");
298         close(fd);
299         return;
300     }
301     map[st.st_size] = '\0';
302     close(fd);
303 
304     parse_config_file(map);
305 
306     free(map);
307 }
```


## Analysis
In this function, it opens config file and tries to read the content into
the memory created by malloc, if memory allocation failes or content size 
returned by read is not equal to file size, it will print error message and
exit. 

`296     if (read(fd, map, st.st_size) != st.st_size) {`

In line 297, it returns without freeing map. That's why Infer raises
the warning. It's not serious and we can simply add one extra line 

`free(map);`

in line 298 and disable this error reporting.

## Conclusion
User space tool, Low Severity
