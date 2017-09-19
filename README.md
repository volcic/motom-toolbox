# Zoltan's Optotrak toolbox

## ~ allows you to use the NDI Optotrak device programmatically from Matlab.
Works on Windows (and Linux, but not thoroughly tested), and you don't need NDI's First Principles configure your hardware and collect data!

### [WARNING]: I am still developing this, there is no guarantee for it to be stable or work at all!

**Requirements:**
* Successfully installed drivers and bought the C API
* Matlab
* A supported compiler for Matlab:
    * windows: Visual Studio Community, with C++ installed
    * Debian/Ubuntu users: sudo apt-get install build-essential
    
64-bit systems are recommended, but most functions should work with 32-bit systems too.

In order to start using the toolbox, you'll need the proprietary files you bought from NDI. These are included in the installation directory.

1. Copy 'oapi64.dll', 'oapi64.lib', 'oapi.dll' and 'oapi.lib' to the 'bin' directory.
2. Copy 'ndhost.h', 'ndoapi.h', 'ndopto.h', and 'ndtypes.h' to the 'source' directory.
3. Execute 'RUNME.m' in Matlab, and follow the instructions.

If the compilation fails because the header files couldn't be loaded, try changing the way the header file is being called:
#include <header_file.h> -> #include "header_file.h" to ensure the local files are used.

During compilation, there will be some warnings about some variable types, these are safe to ignore.

Once the script is finished, you will have all the functions described in the API manual available in Matlab.
There are commonly used scripts in the 'convenience' directory, and some examples are included too.

# Consult the [wiki](../../wiki) for details!
