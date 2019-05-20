# Abstract #

During my six months as a working-student in BMW Car-IT(01.2018 - 07.2018), under supervision and mentorship of Lukas Bulwahn, I get involved with Linux kernel, clang compiler, C, Docker and Facebook Infer static analysis tool.  
I have started with compiling linux-v4.15 with clang and investigating compiler warnings. Then I started to run facebook-infer on linux-kernel-v4.15 and linux-kernel-v4.16.  
After analyzing and classifying infer-warnings, I created docker-containers and scripts in order to make this process automatized, reproducible and platform-independent.  
As a next task, I found compilable maximalyesconfig for linux-4.15 and linux-4.16 with clang-5.0 and clang-7.0 and documented every step and gathered all required patches/files.  
Even though I have tried to run infer with using maximalyesconfig, every trial resulted with an infer error. I documented all my work as separate branches.  
Below, I explained every branch ,and also some minor tasks I didn't mentioned above more detailed.  

# Infer Capture and Analyze Results #

| Results  | Linux-4.16 maximalyesconfig | Linux-4.16 defconfig | Linux-4.15 maximalyesconfig | Linux-4.15 defconfig |
| ------------- | ------------- | ------------- | ------------- |  ------------- |
| Infer 0.13.1  | TODO[1]  | OK[4] | TODO[7] | OK[10] |
| Infer 0.14.0  | ERR[2]  | OK[5] | TODO[8] | TODO[11] |
| Infer 0.15.0  | ERR[3]  | OK[6] | TODO[9] | OK[12] |

To be able to run infer-analyze on kernel, first clone repository and then checkout into infer-documentation branch:  
```git clone https://github.com/OzanAlpay/linux-kernel-analysis.git && cd linux-kernel-analysis && git checkout infer-documentation-v2```  
Then please follow [setup instructions](https://github.com/OzanAlpay/linux-kernel-analysis/blob/master/Documentation/Setup.md)  
**Results:**
- [4:](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/infer/results/v416/infer0131/bugs.txt)  ```cd scripts && ./build-infer-docker.sh && ./analyse-kernel.sh -r stable -c defconfig -i files/infer0131/inferconfig -infer-version 0.13.1```  
- [5:](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/infer/results/v416/infer0140/defconfig/bugs.txt)  ```cd scripts && ./build-infer-docker.sh && ./analyse-kernel.sh -r stable -c defconfig -i files/infer0140/inferdefconfig```  
- [6:](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/infer/results/v416/infer0150/defconfig/bugs.txt) ``` cd scripts && ./build-infer-docker.sh && ./analyse-kernel.sh -r stable -c defconfig -i files/infer0150/inferdefconfig -infer-version 0.15.0```  
- [10:](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/infer/results/v415/infer0131/defconfig/bugs.txt)  ```cd scripts && ./build-infer-docker.sh && ./analyse-kernel.sh -r stable -c defconfig -i files/infer0131/inferconfig -infer-version 0.13.1```
- [12:](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/infer/results/v415/infer0150/defconfig/bugs.txt) ``` cd scripts && ./build-infer-docker.sh && ./analyse-kernel.sh -r stable -c defconfig -i files/infer0131/inferconfig -infer-version 0.15.0```
    
**Errors:**  
- [2:](https://github.com/OzanAlpay/mdfile/blob/master/infer-capture-errors/v416/infer-0140/maximalyesconfig/error_maximalyesconfig_0140.txt) Internal Error: Error in infer subprocess: died after receiving sigkill (signal number 9) ```cd scripts && ./analyse-kernel.sh -r stable -c files/v416/maximalyesconfig -i files/infer0140/infermaximalyesconfig```  
- [3.1:](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/infer/results/v416/infer0150/maxyesconfig-fail/failure-files/OutOfMemoryFiles/error_message.txt) Out of memory error ```cd scripts && ./analyse-kernel.sh -r stable -c files/v416/maximalyesconfig -i files/infer0150/infermaximalyesconfig -infer-version 0.15.0```. [Error-Investigation](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/infer/results/v416/infer0150/maxyesconfig-fail/InferOutOfMemoryFailure.md), 
- [3.2:](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/infer/results/v416/infer0150/maxyesconfig-fail/failure-files/SigKillFailureFiles/infer_failure_log.txt) died after receiving sigkill ```cd scripts && ./analyse-kernel.sh -r stable -c files/v416/maximalyesconfig -i files/infer0150/infermaximalyesconfig -infer-version 0.15.0```. [Error-Investigation](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/infer/results/v416/infer0150/maxyesconfig-fail/InferSigKillFailure.md)  

Note: According to infer-developers Translating Statement Errors are internal for infer, and we shouldn't really care about them. [See](https://github.com/facebook/infer/issues/937)  
 
# Branches in Summary #
- Run Infer on Linux Kernel  
- Create Clang Rectification reports  
- Run docker container as user  
- Create Clang warning reports  
- Create Infer analysis reports  
- Create Documentation reports  

## Run Infer on Linux Kernel ##
**Repository Addresses:**  
New Branch: https://github.com/OzanAlpay/linux-kernel-analysis/tree/infer-documentation-v2  
Old Branch: https://github.com/OzanAlpay/linux-kernel-analysis/tree/infer-documentation  

- Dockerfiles created, in order to make our work reproducible in different environment:  
	[docker/infer-0.13.1/Dockerfile](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation/docker/infer-0.13.1/Dockerfile), [docker/infer-0.14.0/Dockerfile](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation/docker/infer-0.13.1/Dockerfile), [docker/infer-0.15.0/Dockerfile](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation/docker/infer-0.13.1/Dockerfile)  
- Scripts created be intended for automate building docker images and analyzing kernel with infer processes:  
	[scripts/build-infer-docker.sh](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/scripts/build-infer-docker.sh), [scripts/analyze-kernel.sh](https://github.com/OzanAlpay/linux-kernel-analysis/blob/infer-documentation-v2/scripts/analyse-kernel.sh)  
- Different inferconfig files created to be able to run analyze-kernel script with different kernel configurations and different infer versions:  
	[scripts/files](https://github.com/OzanAlpay/linux-kernel-analysis/tree/infer-documentation-v2/scripts/files)  


## Clang Rectification Reports ##
**Repository Addresses:**  
New Branch: https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-compilation-analysis  
Old Branch: https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-compilation  

- Tried to compile linux kernel v4.15 and v4.16 using different configurations with clang-5.0 clang-6.0 and clang-7.0, created compilation reports:  
	[clang/{clang-version}/{kernel-version}/{kernel-config}](https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-compilation-analysis/clang)  
- Created rectification reports and error reports according to compilation results:  
	[clang/rectification-reports](https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-compilation-analysis/clang/rectification-reports), [clang/error-files](https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-compilation-analysis/clang/error-files)  
- Tried to fix these errors with trying find appropriate patches from linux-next and/or mailing lists:  
	[clang/fix-patches](https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-compilation-analysis/clang/fix-patches)  
- Found the maximal-yes-configuration for each kernel with each clang version after applying patches:  
	[clang/config-files/{kernel-version}](https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-compilation-analysis/clang/config-files)  

## Run docker container as user ##
**Repository Address:**  
https://github.com/OzanAlpay/linux-kernel-analysis/tree/run-docker-as-user  

- Modified script in order to run docker container as a user instead of root:  
	[scripts/compile-kernel.sh](https://github.com/OzanAlpay/linux-kernel-analysis/blob/run-docker-as-user/scripts/compile-kernel.sh)  

## Create Clang Warning Reports ##
**Repository Addresses:**  
New Branch: https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-and-infer-warning-reports  
Old Branch: https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-warning-reports  

- Compiled Linux-4.15 kernel with defconfig configuration using clang-5.0, analyzed clang warnings  
	[reports/v415/clang-5.0](https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-and-infer-warning-reports/reports/v415/clang-5.0)  
- Created clang warning reports and classified each investigated clang warning.  
	[reports/v415/clang-5.0/WarningTypeClassifications](https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-and-infer-warning-reports/reports/v415/clang-5.0/WarningTypeClassifications.md)

## Create Infer Analysis Reports ##
**Repository Addresses:**  
New Branch: https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-and-infer-warning-reports  
Old Branch: https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-warning-reports  

- Created Reports for infer-0.13.1 warnings on linux-4.15 kernel.[While I was creating these reports, actually my knowledge is not really enough to create good reports, so there may several false-classifications in 0.13.1 reports)  
	[reports/v415/infer-013](https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-and-infer-warning-reports/reports/v415/infer-0131)  
- Created Reports for infer-0.14.0 warnings on linux-4.16 kernel.  
	[reports/v416/infer-014](https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-and-infer-warning-reports/reports/v416/infer-014)  
- Created Reports for infer-0.15.0  warnings on linux-4.16 kernel.  
	[reports/v416/infer-015](https://github.com/OzanAlpay/linux-kernel-analysis/tree/clang-and-infer-warning-reports/reports/v416/infer-015)  
- Mock programs to check infer behaviour.  
	[mock-programs](https://github.com/OzanAlpay/linux-kernel-analysis/tree/infer-documentation-v2/infer/MockCodes)  

## Create Documentation Reports ##
- A summary of my selected work notes  
	[work-notes](Notes.md)  

## After Compilation Clean-up ##
After compiling linux-kernel with ```make defconfig && make -j40```, If  you do not want to leave any leftover you should run ```make mrproper && make -C tools objtool_clean```.  
Otherwise there will be some leftover files in ```tools/objtool``` directory.



