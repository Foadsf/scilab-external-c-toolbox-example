// Very simple test gateway using standard registration
extern "C" {
    #include <stdio.h>
    #include <wchar.h> // Needed for wcscmp and wchar_t

    // Core Scilab includes needed for gateway functionality
    #include "api_scilab.h"    // Main Scilab API definitions
    #include "Scierror.h"      // For Scierror function
    #include "gateway_c.h"     // For GW_C_FUNC etc. types (needed by addfunction.h)
    #include "addfunction.h"   // Needed for addCFunction

    // Define the name used inside Scilab
    static const char fname_sci[] = "very_simple";

    // Define the actual C/C++ implementation of the Scilab function
    int sci_very_simple(scilabEnv env, int nin, scilabVar* in, int nopt, scilabOpt* opt, int nout, scilabVar* out)
    {
        double* out1 = NULL;

        // --- Argument Checking ---
        // Check number of input arguments (expecting 0)
        // Although not strictly needed for this simple example, it's good practice
        if (nin != 0)
        {
            Scierror(77, "%s: Wrong number of input argument(s): %d expected.\n", fname_sci, 0);
            return 1; // Indicate error
        }

        // Check number of output arguments (expecting 1)
        if (nout != 1)
        {
            Scierror(77, "%s: Wrong number of output argument(s): %d expected.\n", fname_sci, 1);
            return 1; // Indicate error
        }

        // --- Create Output Variable ---
        // Create a 1x1 double matrix
        out[0] = scilab_createDoubleMatrix2d(env, 1, 1, 0);
        // Check if creation failed (memory allocation error)
        if(out[0] == NULL)
        {
             Scierror(999, "%s: Memory allocation error creating output variable.\n", fname_sci);
             return 1; // Indicate error
        }
        // Get a pointer to the data of the output matrix
        scilab_getDoubleArray(env, out[0], &out1);
        if (out1 == NULL) // Should not happen if creation succeeded, but good check
        {
            Scierror(999, "%s: Could not get pointer to output data.\n", fname_sci);
            // Need to free the allocated variable if pointer retrieval fails
            // scilab_freeVar(env, out[0]); // This function might not exist directly, handle memory appropriately
            return 1;
        }


        // --- Core Logic ---
        // Assign the constant value
        out1[0] = 42.0;

        return 0; // Indicate success
    }


    // --- Gateway Registration Function ---
    // This function IS the entry point addinter looks for.
    // Its name MUST match the second argument of the addinter call in the loader script.
    #define MODULE_NAME L"very_simple" // Logical module name used by Scilab

    __declspec(dllexport) int very_simple(wchar_t* _pwstFuncName)
    {
        // The _pwstFuncName argument allows a single DLL entry point to potentially
        // register multiple Scilab functions. Scilab calls this entry point once
        // for each function name listed in the third argument of addinter.

        // Check if the function name requested by Scilab matches what this gateway provides
        if(wcscmp(_pwstFuncName, L"very_simple") == 0)
        {
            // Register the Scilab-callable function named "very_simple"
            // It maps to the C implementation function pointed to by &sci_very_simple
            // It belongs to the logical module defined by MODULE_NAME
            // The cast (GW_C_FUNC) ensures type compatibility.
            addCFunction(L"very_simple", (GW_C_FUNC)sci_very_simple, MODULE_NAME);
        }
        // Add more `else if(wcscmp(...) == 0)` blocks here if this DLL
        // were to register more functions via this single entry point.

        return 1; // Indicate success to Scilab's loader mechanism
    }

} // End extern "C"