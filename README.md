<img src="motom_logo.png">


# MOTOM toolbox: MOtion Tracking with Optotrak and Matlab

## ~ allows you to use the NDI Optotrak device programmatically from Matlab.
Works on Windows (and Linux, but not thoroughly tested), now you can configure your hardware and collect data!

## What's new?
- 29/03/2022: Added a simple (6 lines of code) example for testing marker visibility
- 29/09/2021: Added Visual Studio 2019 as a supported compiler
- ??/??/2020: OAPI 3.16 compatibility (2020 was a bit of a blur)
- 03/11/2019: `optotrak_align_my_system` now works with multiple cameras with OAPI 3.15
- 01/11/2019: Updated the rigid body creation example
- 29/05/2019: Added a new method of creating virtual markers using a custom-generated rigid body file
- 10/02/2019: Corrected the rotation matrices with the virtual marker. Added warnings about correctly making rigid bodies
- 24/01/2019: Now it compiles on older 32-bit Matlab versions too.


**Requirements:**

This toolbox was developed using the following configuration. The more you deviate from it, and the more exotic hardware you want to use, the more likely you will run into problems.
* Successfully installed the Optotrak drivers and software
* Obtained a recent (3.14 or newer) version of the Optotrak API from NDI
* Matlab R2017a or newer
* A supported compiler for Matlab:
    * Windows: Visual Studio Community (the free one) 2017, with C++ installed
    * Ubuntu 18.04 users: sudo apt-get install gcc-6

64-bit systems running Windows are recommended, but most functions should work with 32-bit systems too. I tested it on Windows 7 and the 32-bit version of Matlab R2015b, and Ubuntu MATE 18.04 LTS using Matlab R2018a.

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
### Documentation, in particular:

- Some additional [documentation for the Optotrak API functions are here](../../wiki/API-functions-in-Matlab)
- The custom [convenience scripts and wrapper functions that makes life easier are here](../../wiki/Convenience-scripts-and-wrapper-functions)
- For advanced users, there is info about [rigid bodies](../../wiki/Rigid-bodies) and [virtual markers](../../wiki/Virtual-markers)
- Lamentation about the wonders of [coordinate system alignment](../../wiki/Calibration) (aka 'calibration')
- There are some examples in a separate directory where you can see how it is all put together.


...or, if you really just want to dive in, and once you got the Optotrak API files:
1. Copy 'oapi64.dll', 'oapi64.lib', 'oapi.dll' and 'oapi.lib' to the 'bin' directory.
2. Copy 'ndhost.h', 'ndoapi.h', 'ndopto.h', and 'ndtypes.h' to the 'source' directory.
3. Edit the freshly copied header files so the compiler would use the local copies:
The simplest way to do this is to use 'Find and Replace' in a text editor, to change:

Replace every `#include <ndtypes.h>` with -> `#include "ndtypes.h"`

Replace every `#include <ndpack.h>` with -> `#include "ndpack.h"`

Replace every `#include <ndhost.h>` with -> `#include "ndhost.h"`

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

# Like it? Use it? Cite it!
There is an open access paper available about the toolbox. If you are using this software in your research project, please cite it as follows:
***

Derzsi, Z., & Volcic, R. (2018). MOTOM toolbox: MOtion Tracking via Optotrak and Matlab. _Journal of neuroscience methods, 308,_ 129-134.

DOI: [https://doi.org/10.1016/j.jneumeth.2018.07.007](https://doi.org/10.1016/j.jneumeth.2018.07.007)

***
Thank you!