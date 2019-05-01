# Structure of Reports and Explanation of Report Sections #
### Report Name & Number ### 
Every report has an unique number. Every report name should follow this convention:  
{subsystem_name}:{file_name}:{file_extension}:{warning_type}:{unique_report_number}.md  
### General ###
General part contains:  
**Warning Type:** Clang warning type.  
**Warning Explanation:** Full clang warning message.  
**File Location:** Full path of file, that causes warning.  
### History ###
History part is about when and which commit introduced this warning and if it is already resolved or still exists.  
**Introduced By:** Commit id and one-line commit message, that caused this warning.  
**Reported Since:** Commit which makes this warning is observable through clang output.  
**Resolved By:** Commit which resolves warning.
### Manuel Assesment ###
**Classification:** Warnings are classifed into different subclasses. Current subclasses can be found at [WarningTypeClassifications](WarningTypeClassifications.md)  
**Rationale:** A summary of manual examination of warning.

