# Analysis Report 0006 #

## General ##
**Warning Type:** UNINITIALIZED_VALUE  
**Warning Explanation:** The value read from length[_] was never initialized.   
```C 
}
  /* Find largest and smallest lengths in this group */
  minLen = maxLen = length[0];
  for (i = 1; i < symCount; i++) {
```
**File Location:** lib/decompress_bunzip2.c:271  
## History ##
**Introduced By:** TODO  
**Reported Since:** TODO  
**Resolved By:** --  
**Similar Case:** [FalsePositive-Uninitialized-loop-problem](https://github.com/OzanAlpay/linux-kernel-analysis/tree/infer-documentation/infer/MockCodes/infer-uninitialized-with-loop)  
## Manuel Assesment ##
**Classification:** False - Positive  
### Rationale ###
Since it is a huge function, I will examine it part by part.
```C
static int INIT get_next_block(struct bunzip_data *bd)
{
	struct group_data *hufGroup = NULL;
	int *base = NULL;
	int *limit = NULL;
	int dbufCount, nextSym, dbufSize, groupCount, selector,
		i, j, k, t, runPos, symCount, symTotal, nSelectors, *byteCount;
	unsigned char uc, *symToByte, *mtfSymbol, *selectors;
	unsigned int *dbuf, origPtr;

....

	symTotal = 0;
```
In here  symTotal assigned to 0  
```C
	for (i = 0; i < 16; i++) {
		if (t&(1 << (15-i))) {
			k = get_bits(bd, 16);
			for (j = 0; j < 16; j++)
				if (k&(1 << (15-j)))
					symToByte[symTotal++] = (16*i)+j;
		}
	}
```
Depends on bunzip data value, symTotal's value may be increase, but at worst case it is still 0  
```C
	/* How many different Huffman coding groups does this block use? */
	groupCount = get_bits(bd, 3);
	if (groupCount < 2 || groupCount > MAX_GROUPS)
		return RETVAL_DATA_ERROR;
	/* nSelectors: Every GROUP_SIZE many symbols we select a new
	   Huffman coding group.  Read in the group selector list,
	   which is stored as MTF encoded bit runs.  (MTF = Move To
	   Front, as each value is used it's moved to the start of the
	   list.) */
	nSelectors = get_bits(bd, 15);
	if (!nSelectors)
		return RETVAL_DATA_ERROR;
	for (i = 0; i < groupCount; i++)
		mtfSymbol[i] = i;
	for (i = 0; i < nSelectors; i++) {
		/* Get next value */
		for (j = 0; get_bits(bd, 1); j++)
			if (j >= groupCount)
				return RETVAL_DATA_ERROR;
		/* Decode MTF to get the next selector */
		uc = mtfSymbol[j];
		for (; j; j--)
			mtfSymbol[j] = mtfSymbol[j-1];
		mtfSymbol[0] = selectors[i] = uc;
	}
	/* Read the Huffman coding tables for each group, which code
	   for symTotal literal symbols, plus two run symbols (RUNA,
	   RUNB) */
	symCount = symTotal+2;
```
In here programmer assigned symCount value to symTotal+2, so in worst case it is 2  
```C
	for (j = 0; j < groupCount; j++) {
		unsigned char length[MAX_SYMBOLS], temp[MAX_HUFCODE_BITS+1];
		int	minLen,	maxLen, pp;
		/* Read Huffman code lengths for each symbol.  They're
		   stored in a way similar to mtf; record a starting
		   value for the first symbol, and an offset from the
		   previous value for everys symbol after that.
		   (Subtracting 1 before the loop and then adding it
		   back at the end is an optimization that makes the
		   test inside the loop simpler: symbol length 0
		   becomes negative, so an unsigned inequality catches
		   it.) */
		t = get_bits(bd, 5)-1;
```
Programmer assign a value to t in here.
```C
		for (i = 0; i < symCount; i++)  {
			for (;;) {
				if (((unsigned)t) > (MAX_HUFCODE_BITS-1))
					return RETVAL_DATA_ERROR;

				/* If first bit is 0, stop.  Else
				   second bit indicates whether to
				   increment or decrement the value.
				   Optimization: grab 2 bits and unget
				   the second if the first was 0. */

				k = get_bits(bd, 2);
				if (k < 2) {
					bd->inbufBitCount++;
					break;
				}
				/* Add one if second bit 1, else
				 * subtract 1.  Avoids if/else */
				t += (((k+1)&2)-1);
```
There may be an update to value of t, but it depends.(if k<2 then there won't be any update)
```C
			}
			/* Correct for the initial -1, to get the
			 * final symbol length */
			length[i] = t+1;
		}
		/* Find largest and smallest lengths in this group */
		minLen = maxLen = length[0];
```
In here, we know that symCount at least equal to 2. So in this case it will assign values to ```length[0] and length[1]```. So lets look at value of  ```t```. If it is not an uninitialized value, then this function is safe. To understand it better, we must check ```get_bits()``` function.
```C
/* Return the next nnn bits of input.  All reads from the compressed input
   are done through this function.  All reads are big endian */
static unsigned int INIT get_bits(struct bunzip_data *bd, char bits_wanted)
{
	unsigned int bits = 0;

	/* If we need to get more data from the byte buffer, do so.
	   (Loop getting one byte at a time to enforce endianness and avoid
	   unaligned access.) */
	while (bd->inbufBitCount < bits_wanted) {
		/* If we need to read more data from file into byte buffer, do
		   so */
		if (bd->inbufPos == bd->inbufCount) {
			if (bd->io_error)
				return 0;
			bd->inbufCount = bd->fill(bd->inbuf, BZIP2_IOBUF_SIZE);
			if (bd->inbufCount <= 0) {
				bd->io_error = RETVAL_UNEXPECTED_INPUT_EOF;
				return 0;
			}
			bd->inbufPos = 0;
		}
		/* Avoid 32-bit overflow (dump bit buffer to top of output) */
		if (bd->inbufBitCount >= 24) {
			bits = bd->inbufBits&((1 << bd->inbufBitCount)-1);
			bits_wanted -= bd->inbufBitCount;
			bits <<= bits_wanted;
			bd->inbufBitCount = 0;
		}
		/* Grab next 8 bits of input from buffer. */
		bd->inbufBits = (bd->inbufBits << 8)|bd->inbuf[bd->inbufPos++];
		bd->inbufBitCount += 8;
	}
	/* Calculate result */
	bd->inbufBitCount -= bits_wanted;
	bits |= (bd->inbufBits >> bd->inbufBitCount)&((1 << bits_wanted)-1);

	return bits;
}
```
That function returns an ```unsigned int bits```. Programmer assigned ```bits``` value at the beginning of function. I can't find any dangerous part of code in that function, that may return an uninitialized value  
So in my opinion in any case ```length[0]``` will be initialized, before ``` minLen = maxLen = length[0];``` line called. In my opinion since it will assign a value to ```length[0]``` inside a loop, Infer creates a false-positive warning in this case.


