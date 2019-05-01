# Warning Type Classifications #

Clang compiler creates a lot of warning while compiling Linux-Kernel. Some of them are false-positive , or they don't cause any problem right now, but in future, after a commit, they may create runtime problems. In here we try to classify clang warnings.

### Mathematically Impossible ###
This classifier contains cases , that are impossible in mathematic operations, they are definitly false-positive warnings created by Clang compiler

Such as :  integer x : x < 10 && x > 9  

### Tool can detect during compile time ###
In this subclass of Warnings, we have some code, that is not problematic right now but in the future with some new commits they may become problematic.  
Such as : setting an array size to bigger than ```INT_MAX```. 

If we use a more-smarter tool, during runtime we can get information about these suspicious code lines will create a warning or not  more accurately.



