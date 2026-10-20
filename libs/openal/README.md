hlopenal
========

HLOpenAL is a OpenAL backend for HashLink 
Read http://openal-soft.org/ for more information on OpenAL (using open source OpenAL Soft)

Download the Win32 binaries and unzip into the hashlink/include/openal directory so you have the directories hashlink/include/openal/include and hashlink/include/openal/libs available.



With DOWNLOAD_DEPENDENCIES, OpenAL Soft is downloaded and built from source. On Android it is built with the OpenSL ES backend, which it loads from the system libOpenSLES.so at run time; the configuration fails if OpenSL ES is not found.
