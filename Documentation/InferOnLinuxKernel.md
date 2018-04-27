# Installing Infer #
We need to compile and install infer from source code , in order to be able to hack it later. 
You can find facebook/infer's source code [here](https://github.com/facebook/infer) or you can use following command: 
```git clone https://github.com/facebook/infer.git```
## My current setup ##
**Host OS:** Ubuntu 64-bit 16.04  
**Kernel Version To Be Checked with Infer:** Linux 4.15 Stable  
**Kernel Compilation Configuration:** defconfig  
**Infer fork with HEAD commit:** 4799fb6b8226("[racerd] skeleton for testing access path stability")  
**Clang:** clang version 3.8.0-2ubuntu4 (tags/RELEASE_380/final)  

## Prerequisites ##
You can find latest prerequisites for your operating system for building infer [here](https://github.com/facebook/infer/blob/master/INSTALL.md).

## Dependency Problems I have encountered during Compilation ##
Even though I have installed this prerequisites, I had some problems with:
- sqlite3.4.3.2 ```opam depext sqlite3.4.3.2```
- camlzip.1.0.7 ```opam depext camlzip.1.07```
- cmake ```sudo apt-get install cmake```

## Compile Infer ##
After cloning infer to your computer, and installing all required files. You can start compiling with infer with ```./build_infer.sh``` command.

## Install Infer ##
After infer build finished, you can install it with using ```make install``` command. Now you are able to run infer from your command line.

## Packages Needed to build Linux Kernel ##
You need some extra packages, to become able to compile linux 4.15 from source code. In my case they were:  
- libelf-dev ```sudo apt-get install libelf-dev```  
- libssl-dev ```sudo apt-get install libssl-dev```

## Prepare to Run Infer on Linux Kernel ## :

Now you can :
- Compile Linux 4.15 without getting any errors
- Call infer via command line

To use infer with linux-kernel, first you must capture Linux 4.15 source code with ```infer capture -- make``` command , and then analyse infer-out folder with ```infer analyse```. However with current setup Infer can't capture Linux 4.15 source code. To be able to get an output you need to make some modifications. I explained required modifications below, with two solutions for each of them.

## Modify Infer to mark problematic directories blacklisted ##
First of all, we need to mark some linux directories as blacklisted, to avoid compilation errors during ```infer capture``` phase.
To do this you have two options and I prefer second option.

### Modify Infer source code ###
You can directly modify your infer fork, and mark directories as blacklisted with help of [patch](../scripts/files/0001-Blacklist-files-from-infer-source-code.patch), please don't forget to modify file paths which passed as parameter before applying it.

### Add an inferconfig file ###

Thanks to [@Evan Zhao](https://github.com/Tacinight) we have much simplier and flexible way to solve this problem. You can create an ```.inferconfig``` file in linux-kernel root directory and then mark problematics directories as blacklisted as following: (Please do not forget replace file paths with absolute paths.)
You can do it via execute ```echo $PWD``` in linux-stable root directory. Then delete first ``` \ ``` and replace ```[linux-stable-absolute-path]```'s with rest of string.
Example :  
```"home/ozan/linux-stable/stable/linux-stable/mm"```  

```
{
"skip-analysis-in-path": 
[
"[linux-stable-absolute-path]/arch/x86/entry/vdso",
"[linux-stable-absolute-path]/arch/x86/kernel", 
"[linux-stable-absolute-path]/arch/x86/mm", 
"[linux-stable-absolute-path]/arch/x86/boot", 
"[linux-stable-absolute-path]/drivers/acpi", 
"[linux-stable-absolute-path]/fs", 
"[linux-stable-absolute-path]/kernel/bpf", 
"[linux-stable-absolute-path]/mm", 
"[linux-stable-absolute-path]/net/mac80211"
]
}
```
You can find why you should these files into the blacklist; and if you dont them, add what kind of error they create at : [Blacklisted-Files-Explanations](../infer/Documentation/BlacklistExplanation) folder.


## Set default CC to clang for linux-kernel compilation ##

After that, we need to set clang as a default compiler when we start infer capture phase with ```infer capture -- make``` command.  Otherwise Linux Makefiles uses gcc flags, and since infer compiles with clang, we need clang compiler flags for a successfull compilation.
For this issue again we have two different solutions, and I prefer second one.

### GCC Hack ###
It is a serious hack, which may breaks your other builds. Basically we just point ```gcc``` command to clang compiler. If you want to use this method I strongly encourage you to take a backup.

- Open terminal
- ```cd /usr/bin```
- ```sudo ln -sf clang gcc```

### Patch file for Linux ###

Another way is applying [this patch](../scripts/files/0001-Set-default-CC-to-Clang-from-Makefile.patch), to top of linux 4.15. After that you won't have any problems about compiler flags.

## Run Infer on Linux Kernel ##

After all this configurations, you are ready to compile linux kernel with infer:

- Go to Linux-kernel root directory.
- ```make clean && make defconfig```
- ```infer capture -- make```
After ```infer capture -- make``` completed you can observe infer creates a directory named infer-out. So now we should execute```infer analyze``` command and get output from infer-out folder. But it may take a lot of time and need huge computing power.
- Again from linux-kernel root directory,
- Execute ```infer analyze```
- Look for results with ```cat /infer-out/bugs.txt```
## Common problems ##

### Base_64.S problem ###
after executing ```infer capture -- make``` command if you get error messages as:
``` <instantiation>:4:8: error: expected absolute expression
 .skip -(((144f-143f)-(141b-140b)) > 0) * ((144f-143f)-(141b-140b)),0x90
       ^
<instantiation>:4:8: error: expected absolute expression
 .skip -(((144f-143f)-(141b-140b)) > 0) * ((144f-143f)-(141b-140b)),0x90
       ^
<instantiation>:4:8: error: expected absolute expression
 .skip -(((144f-143f)-(141b-140b)) > 0) * ((144f-143f)-(141b-140b)),0x90
       ^
```
during compilation of base64.S file, that means linux makefile still using wrong flags during compilation, I suggest you to look at **Set default CC to clang for linux-kernel compilation** section again. To avoid that kind of errors, Makefiles adds different compiler flags according to selected compiler. For example in this case we need -no-integrated-as flag to avoid using clang's integrated assembler.
### objcopy: 'arch/x86/entry/vdso/vdso64.so.dbg': No such file problem ###
If you get  
```
arch/x86/entry/vdso/vclock_gettime.o: In function `__vdso_time':
vclock_gettime.c:(.text+0x667): undefined reference to `memcpy'
arch/x86/entry/vdso/vclock_gettime.o: In function `gtod_read_begin':
vclock_gettime.c:(.text+0x734): undefined reference to `memcpy'
Error: the following clang command did not run successfully:
```  
error during ```infer capture``` phase, you should re-do mark problematic directories blacklisted step. Maybe you can check if your directory paths are written correctly. Please not that directories shouldn't start with ``` \ ```  
**Invalid:**  
```"/home/ozan/linux-stable/stable/linux-stable/mm"```    
**Valid:**  
```"home/ozan/linux-stable/stable/linux-stable/mm"```  


## Using Docker for Kernel-Analysis with Infer ##

You can do all this process , with using Docker. It is the most basic and straightforward way to run infer on Linux Kernel.
To do this, please follow the instructions below.
- Clone repository ```git clone https://github.com/bulwahn/linux-kernel-analysis.git```
- Follow [Setup](Setup.md) instructions, clone at least linux-stable to your computer and be sure that you set```KERNEL_SRC_BASE```
- Go to scripts directory ```cd ~/linux-kernel-analysis/scripts```
- Run ```./build_infer_docker.sh``` and build docker file.
- Run ```./analyse_kernel.sh```, That script completes all required steps that described above, then runs ```infer capture -- make``` on linux-kernel. You can call it with various parameters. Please see detailed instructions about ```analyse_kernel.sh``` script below.


## Analyse_Kernel Script Manual ##

Aim of analyse_kernel script is , automatize all process for running infer on linux-kernel with using dockerfile. You can call it directly or pass different parameters to run it on different versions/configurations.
Below you can find explanations about each parameter:  
**-r :** Kernel-Repository parameter. You can use this parameter to run infer on different kernel repositories. Valid parameters are torvalds, stable and next.  
Example: ``` ./analyse_kernel -r stable```  
**-c :** Kernel-Configuration parameter. You can use this parameter to run infer with different kernel-configurations. Valid parameters are allnoconfig, allmodconfig, allyesconfig, defconfig, randconfig.  
Example: ``` ./analyse_kernel -c randconfig```  
**Optional Parameters**
**-i :** Parameter for ```.inferconfig``` file. As we stated in above, we need to blacklist several directories, in order to run ```infer capture -- make``` successfully. However if you want use your own ```.inferconfig``` file, you can use this parameter. If you don't pass any parameter, script will use the ```.inferconfig``` file in the root of linux-kernel-source directory.  
Example: ```./analyse_kernel -i /home/abc/inferconfig```  
**--configfile :** Also you can use a configfile, to set all this variable described above. Create a file named ```analysisconfig```. Then inside analysisconfig you can define:  
- KERNEL_HEAD_SHA - If you provide this parameter in your config file, before start building, script will run ```git checkout KERNEL_HEAD_SHA```
- KERNEL_CONFIG - To pass -c parameter
- INFERCONFIG_LOCATION - To pass -i parameter
- KERNEL_REPOSITORY - To pass -r parameter
- DONT_RUN_ANALYZE - Set to 1 for dont run analyze after infer capture finishes.

Example: ``` ./analyse_kernel --configfile /home/xyz/analysisconfig```  
You can find an example of ```.analysisconfig``` file in ```scripts/files/``` directory.  
**--no-analyze :** If you add this parameter, script will not run infer analyze, after infer capture completed. Since infer analyze needs so much computing power and time, you can call script with this parameter and run only infer capture.  

Also you can call analyse_kernel with combination of these parameters. Example: ```./analyse_kernel -r stable -c defconfig -i /home/abc/inferconfig```
 
