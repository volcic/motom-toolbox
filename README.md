<img src="motom_logo.png">


# MOTOM toolbox: MOtion Tracking with Optotrak and Matlab

## ~ allows you to use the NDI Optotrak device programmatically from Matlab.
Works on Windows (and Linux, but not thoroughly tested), now you can configure your hardware and collect data!

**Requirements:**  

This toolbox was developed using the following configuration. The more you deviate from it, and the more exotic hardware you want to use, the more likely you will run into problems.
* Successfully installed drivers and the Optotrak API purchased from NDI
* Matlab R2017a
* A supported compiler for Matlab:
    * Windows: Visual Studio Community (the free one) 2015, with C++ installed
    * Ubuntu 18.04 users: sudo apt-get install gcc-6
    
64-bit systems running Windows are recommended, but most functions should work with 32-bit systems too. I tested it on Windows 7 and the 32-bit version of Matlab R2015b.

Get a release version of the toolbox
```
$ git clone https://github.com/volcic/motom-toolbox.git
```
(...or click 'Clone or download -> Download ZIP')

If you are feeling adventurous, try the development version:
```
$ git clone https://github.com/ha5dzs/motom-toolbox.git
```

This creates the motom-toolbox directory.

In order to start using the toolbox, you'll need the proprietary files you bought from NDI. There are dedicated spaces for the API files in the toolbox directory.
If you are trying to get the toolbox working on some old/weird hardware and you are running into error messages, **don't panic**, read the [Damage Control FAQ](../../wiki/Damage-Control-FAQ)!

# Consult the [wiki](../../wiki) for details!

...or, if you really just want to dive in, and once you got the Optotrak API files:
1. Copy 'oapi64.dll', 'oapi64.lib', 'oapi.dll' and 'oapi.lib' to the 'bin' directory.
2. Copy 'ndhost.h', 'ndoapi.h', 'ndopto.h', and 'ndtypes.h' to the 'source' directory.
3. Edit the freshly copied header files so the compiler would use the local copies:  
The simplest way to do this is to use 'Find and Replace' in a text editor, to change:  

Replace `#include <ndtypes.h>` with -> `#include "ndtypes.h"`  

Replace `#include <ndpack.h>` with -> `#include "ndpack.h"`  

Replace `#include <ndhost.h>` with -> `#include "ndhost.h"`  

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