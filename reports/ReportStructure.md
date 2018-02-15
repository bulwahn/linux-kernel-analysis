# Structure of Reports and Explanation of Report Sections #
### Report Name & Number ### 
Every report has an unique number. Every report name should follow this convention:  
{subsystem_name}:{file_name}:{file_extension}:{warning_type}:{unique_report_number}.md
### Clang Compiler Warning ###
A short description about Clang compiler warning type
### Warning Explanation ###
A detailed explanation of warning, which created by Clang compiler.
### Introduced By ###
This section author must explain which commit added the code, causes this warning. Refer this commit with 12-digit SHA-1 ID and oneline summary of commit.
### Reported Since ###
In this section, author must refer a commit, starting from that commit clang compiler started to show reported warning.
### File Location ###
Author should give the exact location of file in this section.
### Resolved By ###
If a commit is resolving this warning, author mmust refer that commit with 12-digit SHA-1 ID and oneline summary.
### Manuel Assesment ###
In this section, author must explain:  
1- Why this warning created,  
2- Analysis of source code,  
3- Can this part of code create a bug in theory or in practice.
