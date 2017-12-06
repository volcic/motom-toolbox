<img src="motom_logo.png">


# MOTOM toolbox: MOtion Tracking with Optotrak and Matlab

## ~ allows you to use the NDI Optotrak device programmatically from Matlab.
Works on Windows (and Linux, but not thoroughly tested), now you can configure your hardware and collect data!

**Requirements:**
* Successfully installed drivers and bought the C API
* Matlab
* A supported compiler for Matlab:
    * windows: Visual Studio Community, with C++ installed
    * Debian/Ubuntu users: sudo apt-get install gcc-4.9
    
64-bit systems running Windows are recommended, but most functions should work with 32-bit systems too.

Get a copy of the toolbox
```
$ git clone https://github.com/volcic/motom-toolbox.git
```
(...or click 'Clone or download -> Download ZIP')

This creates the motom-toolbox directory.  

In order to start using the toolbox, you'll need the proprietary files you bought from NDI. These are included in the installation directory.

# Consult the [wiki](../../wiki) for details!

...or, if you really just want to dive in:
1. Copy 'oapi64.dll', 'oapi64.lib', 'oapi.dll' and 'oapi.lib' to the 'bin' directory.
2. Copy 'ndhost.h', 'ndoapi.h', 'ndopto.h', and 'ndtypes.h' to the 'source' directory.
3. Edit the freshly copied header files so the compiler would use the local copies:  
`#include <header_file.h>` -> `#include "header_file.h"` where you see the includes for the header files listed above
4. Add this to the top of 'ndopto.h':

```
    #include "ndtypes.h"
    #include "ndpack.h"
    #include "ndhost.h"
```

5. Execute 'RUNME.m' in Matlab, and follow the instructions.

During compilation and library loading, there will be some warnings about some variable types, these are safe to ignore.

Once the script is finished, you will have all the functions described in the API manual available in Matlab.
There are commonly used scripts in the 'convenience' directory, and some examples are included too.