## Infer Analyse Script ##
In this document you can find how to use [analyse-kernel.sh](../scripts/analyse-kernel.sh), in order to run different infer versions(0.13.1, 0.14.0, 0.15.0) on various kernel versions(v4.15, v4.16) with using kernel-configurations(defconfig, maximalyesconfig)  

## Test System Configuration ##
**Operating-System:** Ubuntu 16.04.4 LTS 64-bit  
**Docker-Version:** Docker version 18.03.0-ce, build 0520e24
### Prerequirements ###
To be able to run ```analyse-kernel.sh``` on your system successfully, please follow these steps:
- Clone this repo  
- Install Docker [Tutorial](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04)  
- Complete Setup instructions [Setup](Setup.md)  
- Build Dockerfiles that required for Infer run: ```cd scripts && build-infer-docker.sh```  

Now you are ready to use ```analyse-kernel.sh```, to understand how to use it and parameter explanations please follow next section.  


## Analyse-Kernel.sh Parameters ##
#### Mandatory Parameters ####
**Kernel Repository Parameter ( -r ):**  
Possible values are torvalds, stable and next.  
Example:  
```./analyse-kernel.sh -r stable```  

**Kernel Configuration Parameter ( -c ):**   
You can either pass a string or a file path for this parameter  
We already prepared a maximalyesconfig for Linux-Kernel v4.16 that compiles with clang  
You can find it in ```/scripts/files/v416/maximalyesconfig```  
Examples:  
```./analyse-kernel.sh -c defconfig```  
```./analyse-kernel.sh -c files/v416/maximalyesconfig```  

#### Optional Parameters ####

**Compiler Parameter ( -cc ):**  
You can pass compiler parameter that will be used for infer capture and infer analyze phases:  
Possible values:  
Default value: ```clang```  
Example:  
```./analyse-kernel.sh -cc clang-6.0```  

! Be sure that your selected compiler is included in Dockerfile, You may need to modify and build your dockerfiles again, if you select a currently unsupported parameter !  

**Infer Version Parameter (-infer-version):**  
You can select an infer version, in order to use it for infer capture an infer analyze phases:  
Possible values: 0.13.1, 0.14.0, 0.15.0  
Default value: 0.14.0  
Example:  
```./analyse-kernel.sh -infer-version 0.15.0```  

**Inferconfig File Path Parameter (-i):**  
Since there are some problems about running Infer on Linux-Kernel, we need different inferconfig files to avoid crashes.  
We also prepared some inferconfig files according to infer-version and kernel-configuration.  
You can find them in ```scripts/files/{infer-version-number}```  
Examples:
```./analyse-kernel.sh -i files/infer0131/inferconfig```  
```./analyse-kernel.sh -i files/infer0150/infermaximalyesconfig```  

**Analysis File Configuration (--analysisconfig):**  
Instead of passing this parameters from command-line, you can provide a custom ```analysisconfig``` as a parameter, and ```./analyse-kernel.sh``` will read that file and set parameters according to file content.  
You can find an example analysisconfig at ```scripts/files/analysisconfig```  
!This method is not tested very well, so there may some problems if you use an analysisconfig!  
Example:  
```./analyse-kernel.sh --analysisconfig files/analysisconfig```  

**Dont Run Analyze Parameter (--no-analyze):**  
Infer Analyze needs a lot of time and computing power. If you don't want to run infer analyze after infer capture finishes, you can call this script with passing --no-analyze as an parameter  
Example:  
```./analyse-kernel.sh --no-analyze```  

## Notes ##
To understand why we blacklisted some files or want to know how to build infer from source etc, please see:[Infer-On-Linux-Kernel-Documentation](InferOnLinuxKernel.md)  





