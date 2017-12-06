<img src="motom_logo.png">
# MOTOM toolbox: MOtion Tracking with Optotrak and Matlab

## ~ allows you to use the NDI Optotrak device programmatically from Matlab.
Works on Windows (and Linux, but not thoroughly tested), and you don't need NDI's First Principles configure your hardware and collect data!

**Requirements:**
* Successfully installed drivers and bought the C API
* Matlab
* A supported compiler for Matlab:
    * windows: Visual Studio Community, with C++ installed
    * Debian/Ubuntu users: sudo apt-get install gcc-4.9
    
64-bit systems running Windows are recommended, but most functions should work with 32-bit systems too.

Fetch the toolbox cloning this git repository:
```
$ git clone https://github.com/ha5dzs/zoltans-optotrak-toolbox.git
```

This creates the motom-toolbox directory.  

In order to start using the toolbox, you'll need the proprietary files you bought from NDI. These are included in the installation directory.

1. Copy 'oapi64.dll', 'oapi64.lib', 'oapi.dll' and 'oapi.lib' to the 'bin' directory.
2. Copy 'ndhost.h', 'ndoapi.h', 'ndopto.h', and 'ndtypes.h' to the 'source' directory.
3. Edit the freshly copied header files:  
`#include <header_file.h>` -> `#include "header_file.h"` where you see the includes for the header files listed above
4. Execute 'RUNME.m' in Matlab, and follow the instructions.


During compilation and library loading, there will be some warnings about some variable types, these are safe to ignore.

Once the script is finished, you will have all the functions described in the API manual available in Matlab.
There are commonly used scripts in the 'convenience' directory, and some examples are included too.

# Consult the [wiki](../../wiki) for details!
