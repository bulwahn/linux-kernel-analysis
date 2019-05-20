Some of my work-notes, that I used them during my job, and I hope they may be useful for other developers.

### LLVM vs GNU ###

| Component | LLVM | GNU | Notes |
| --- | --- | --- | --- |
| Compiler | clang | gcc | ? | 
| Assembler | clang-integrated-assembler | as | To use as in clang pass -no-integrated-as argument as a flag |
| Linker | ld.lld | ldbfd , ldgold | To use another linker in clang use --fuse-ld={bfd, gold etc} |
| Runtime | compiler-rt | libgcc | To use different runtime-libraries with clang, use --rtlib={libgcc etc} |


### Clockwise Spiral Rule to understand complicated C declarations ###
When you read linux-kernel source code, you may encounter with some complex declarations. You can use  
clockwise spiral rule to understand them faster and better: 
[Clockwise-Spiral-Rule](http://c-faq.com/decl/spiral.anderson.html)

### Pass multiple arguments to Dockerfile from command line ###
If you want to pass multiple arguments to a Dockerfile when to use them during your Dockerfile build, you can use ```--build-arg={your_param}``` option.
However if you want to pass multiple arguments, you must pass them seperately.  
For example: ```--build-arg={your_param1} --build-arg={your_param2}```

