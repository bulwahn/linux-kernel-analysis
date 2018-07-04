# Analysis Report 0002 #

## General ##
**Warning Type:** RESOURCE_LEAK  
**Warning Explanation:** 
resource of type _IO_FILE acquired by call to ```fopen()``` at line 561, column 25 is not released after line 568, column 9.   
```C
while (fgets(line, LINE_SIZE, cpio_list)) {
  int type_idx;
  size_t slen = strlen(line);
```
resource of type _IO_FILE acquired by call to ```fopen()``` at line 561, column 25 is not released after line 580, column 12.   
```C
if (! (type = strtok(line, " \t"))) {
	fprintf(stderr,
  	"ERROR: incorrect format, could not locate file type line %d: '%s'\n",
 	line_nr, line);
```
**File Location:** usr/gen_init_cpio.c:568 , usr/gen_init_cpio.c:580  
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --  

## Manuel Assesment ##
**Classification:** FALSE-POSITIVE  
### Rationale ###
Since these two warnings are closely related with each other, I want to investigate both of them together.  
```C
filename = argv[optind];
if (!strcmp(filename, "-"))
	cpio_list = stdin;
else if (!(cpio_list = fopen(filename, "r"))) {
	fprintf(stderr, "ERROR: unable to open '%s': %s\n\n",
		filename, strerror(errno));
	usage(argv[0]);
	exit(1);
}
```   
It is very clear that, programmer opens a file with ```fopen(filename, "r"))``` function and then start reading it line by line inside a while loop:  
```C
while (fgets(line, LINE_SIZE, cpio_list)) {
	int type_idx;
	size_t slen = strlen(line);

	line_nr++;

	if ('#' == *line) {
		/* comment - skip to next line */
		continue;
	}

	if (! (type = strtok(line, " \t"))) {
		fprintf(stderr,
			"ERROR: incorrect format, could not locate file type line %d: '%s'\n",
			line_nr, line);
		ec = -1;
		break;
	}

	if ('\n' == *type) {
		/* a blank line */
		continue;
	}

	if (slen == strlen(type)) {
		/* must be an empty line */
		continue;
	}

	if (! (args = strtok(NULL, "\n"))) {
		fprintf(stderr,
			"ERROR: incorrect format, newline required line %d: '%s'\n",
			line_nr, line);
		ec = -1;
	}

	for (type_idx = 0; file_handler_table[type_idx].type; type_idx++) {
		int rc;
		if (! strcmp(line, file_handler_table[type_idx].type)) {
			if ((rc = file_handler_table[type_idx].handler(args))) {
				ec = rc;
				fprintf(stderr, " line %d\n", line_nr);
			}
			break;
		}
	}

	if (NULL == file_handler_table[type_idx].type) {
		fprintf(stderr, "unknown file type line %d: '%s'\n",
			line_nr, line);
		}
}
if (ec == 0)
	cpio_trailer();

exit(ec);
```
However in any case, this function will execute ```exit(ec)``` command, and that command will close all opened streams.   

