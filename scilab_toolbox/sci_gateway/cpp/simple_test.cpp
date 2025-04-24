// Simple test gateway that doesn't depend on external libraries
extern "C" {
    #include <stdio.h>
    #include <wchar.h>         // Needed for wcscmp and wchar_t
    #include "api_scilab.h"
    #include "Scierror.h"      // Potentially needed if you add error checking
    #include "gateway_c.h"     // For GW_C_FUNC etc. types
    #include "addfunction.h"   // For addCFunction

    static const char fname_sci[] = "simple_test"; // Use consistent naming

    int sci_simple_test(scilabEnv env, int nin, scilabVar* in, int nopt, scilabOpt* opt, int nout, scilabVar* out)
    {
        double* out1 = NULL;

        // Basic argument checking (good practice)
        if (nin != 0) {
            Scierror(77, "%s: Wrong number of input argument(s): %d expected.\n", fname_sci, 0);
            return 1;
        }
        if (nout != 1) {
            Scierror(77, "%s: Wrong number of output argument(s): %d expected.\n", fname_sci, 1);
            return 1;
        }

        // Create output
        out[0] = scilab_createDoubleMatrix2d(env, 1, 1, 0);
        if (out[0] == NULL) {
            Scierror(999, "%s: Memory allocation error.\n", fname_sci);
            return 1;
        }
        scilab_getDoubleArray(env, out[0], &out1);
        if (out1 == NULL) {
             Scierror(999, "%s: Could not get pointer to output data.\n", fname_sci);
             return 1;
        }

        // Assign value
        out1[0] = 99.0;  // Use a different value than very_simple for testing

        return 0; // Success
    }

    // --- Gateway Registration Function ---
    #define MODULE_NAME L"simple_test"

    __declspec(dllexport) int simple_test(wchar_t* _pwstFuncName)
    {
        if(wcscmp(_pwstFuncName, L"simple_test") == 0) {
            addCFunction(L"simple_test", (GW_C_FUNC)sci_simple_test, MODULE_NAME);
        }
        return 1;
    }
} // End extern "C"