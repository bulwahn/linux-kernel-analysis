## Using Docker for Kernel-Analysis with Infer-014 ##
In this document, you can find how do run infer-0.14.0 on linux v4.16 with using possible maximum-yes configuration  

Please follow these steps:  
- Clone repository ```git clone https://github.com/bulwahn/linux-kernel-analysis.git```  
- Checkout to infer-documentation branch  ```git checkout infer-documentation```  
- Follow [Setup](Setup.md) instructions  
- Navigate to scripts directory ```cd ../scripts```  
- Build Infer Docker Images ```./build-infer-docker.sh```  
- Checkout Linux-Stable to v4.16 ( You cannot compile Linux v4.17 with clang) ```cd $KERNEL_SRC_BASE/stable/linux-stable && git checkout v4.16```  
- Navigate back to linux-kernel-analysis/scripts directory ```cd -```  
- Run analyze-kernel with  ```.analyse-kernel.sh -r stable -c files/v416/maxyesconfig -i files/0140/inferconfig --cc clang  ```(May take a very long time)  
Please visit [Infer-0131](Infer0131OnLinuxKernel.md) file to find parameter explanations  

