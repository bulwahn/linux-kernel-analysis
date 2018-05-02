## Report 0006 #  
**Compilation Command:** make CC=clang-5.0 HOSTCC=clang-5.0 -j40  
**Kernel Configuration File:** [final-config](../config-files/final-config)  
**Head Commit:** d3412c7ad6ef ("amdgpu/dc/dml: Support clang option for stack alignment")  
**Filename:** No-Error  
**Error Message:** No-Error, Kernel Built with Clang-5.0 successfully.  
```
Setup is 17276 bytes (padded to 17408 bytes).
System is 114562 kB
CRC 1b915f35
Kernel: arch/x86/boot/bzImage is ready  (#13)
```  
**Final Kernel Repository Status:**  
```
d3412c7 amdgpu/dc/dml: Support clang option for stack alignment
8e28136 amdgpu/dc/dml: Consolidate redundant CFLAGS
0974ac7 drm/amd/display: dc: Remove unused display_mode_vba.c
bae0398 amdgpu/dc/calcs: Support clang option for stack alignment
f4da413 amdgpu/dc/calcs: Consolidate redundant CFLAGS
f221829 exofs: avoid VLA in structures
0adb328 Linux 4.16
```


