# Scilab External C Toolbox Example

This repository demonstrates how to create a Scilab toolbox that calls functions from an external, pre-compiled C library using Scilab's gateway mechanism. It combines concepts shown in the Spoken Tutorial "Developing Scilab Toolbox for calling external C libraries" by IIT Bombay.

This approach is useful when you want to:
*   Leverage existing high-performance C/C++ code within the Scilab environment.
*   Integrate specialized algorithms not available directly in Scilab.
*   Improve the performance of computationally intensive tasks.

## Original Source and Attribution

This example is based on the code files and concepts presented in the Spoken Tutorial:
*   **Tutorial:** Developing Scilab Toolbox for calling external C libraries
*   **Author:** Rupak Rokade
*   **Organization:** IIT Bombay, FOSSEE Project
*   **Original Tutorial Link:** [https://spoken-tutorial.org/watch/Scilab/Developing+Scilab+Toolbox+for+calling+external+C+libraries/English/](https://spoken-tutorial.org/watch/Scilab/Developing+Scilab+Toolbox+for+calling+external+C+libraries/English/)
*   **Original License:** The content from the Spoken Tutorial is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

We thank the original authors and the Spoken Tutorial project at IIT Bombay for providing this valuable learning resource.

## Repository Structure

This repository contains two main parts:

1.  **`c_library_source/`**:
    *   Contains the source code (`mul.c`, `mul.h`) for a simple external C library function that multiplies two numbers.
    *   Includes a test `main.c` to demonstrate standalone usage (optional).
    *   Provides a `run.sh` script (for Linux/macOS) to compile the C code into a shared library (`libmul.so`) and header file (`mul.h`) and place them into a standard `thirdparty` directory structure (which is *not* committed by default, see `.gitignore`).

2.  **`scilab_toolbox/`**:
    *   Contains the Scilab toolbox structure (`macros/`, `sci_gateway/`, `etc/`, `help/`, etc.).
    *   `macros/multiply.sci`: Defines the Scilab function signature and help comments for `multiply`.
    *   `macros/add.sci`: Defines a simple Scilab macro `add` for comparison.
    *   `sci_gateway/cpp/sci_multiply.cpp`: The C++ gateway function that acts as the interface between Scilab and the `mul` function in the C library.
    *   `builder.sce`, `loader.sce`, `cleaner.sce`: Scilab scripts to build, load, and clean the toolbox.
    *   `help/`: Contains files for generating the toolbox help pages.

## How to Use

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/Foadsf/scilab-external-c-toolbox-example
    cd scilab-external-c-toolbox-example
    ```

2.  **Build the External C Library (Optional but recommended):**
    This step compiles the C code and creates the necessary `thirdparty` directory structure containing the shared library and header.
    ```bash
    cd c_library_source
    bash run.sh # On Linux/macOS with GCC installed
    cd ..
    ```
    *(Note: If you are on Windows, you'll need to compile `mul.c` into a DLL and `mul.h` manually or adapt the build process, then create the `thirdparty/windows/{include,lib}` structure accordingly. The provided `run.sh` also creates Linux/Mac structures.)*

3.  **Prepare the Toolbox Directory:**
    The `run.sh` script automatically creates a `thirdparty` directory within `c_library_source`. Copy this entire `thirdparty` directory into the `scilab_toolbox` directory:
    ```bash
    # On Linux/macOS
    cp -r c_library_source/thirdparty/ scilab_toolbox/

    # On Windows (using Command Prompt or PowerShell, adapt paths)
    # xcopy /E /I c_library_source\thirdparty scilab_toolbox\thirdparty
    ```
    *Crucial Step:* The `builder_gateway_cpp.sce` script expects the compiled library and headers to be in `scilab_toolbox/thirdparty/`.

4.  **Build and Load the Scilab Toolbox:**
    *   Start Scilab.
    *   Change Scilab's current working directory to the `scilab_toolbox` folder within the cloned repository. You can use the file browser in Scilab or the `cd` command:
        ```scilab
        cd /path/to/scilab-external-c-toolbox-example/scilab_toolbox
        ```
    *   Execute the builder script:
        ```scilab
        exec builder.sce -nogui
        ```
        *(You might see popups asking about overwriting help files during the build; click "Create anyway" or equivalent if they appear).*
    *   Execute the loader script:
        ```scilab
        exec loader.sce
        ```

5.  **Test the Function:**
    The `multiply` function from the C library should now be available in Scilab:
    ```scilab
    --> y = multiply(3, 5)
     y  =
       15.

    --> help multiply // View the help page generated from comments
    ```
    You can also test the pure Scilab macro:
    ```scilab
    --> z = add(10, 20)
     z =
        30.
    ```

## Prerequisites

*   **Scilab:** Version 6.0.2 or later (as used in the tutorial).
*   **C Compiler:** A working C compiler (like GCC on Linux/macOS, MinGW or MSVC on Windows) is needed to build the external library using `run.sh` or manually.
*   **(Optional) Make:** Might be needed by Scilab's internal build process depending on the platform.
*   **Operating System:** The `run.sh` script is for Linux/macOS. The Scilab toolbox build process (`builder.sce`) attempts cross-platform compatibility, but testing was primarily done on Linux as per the tutorial. Adjustments might be needed for Windows/macOS compilation of the C library and potentially linker flags in `builder_gateway_cpp.sce`.

## License

The original content from the Spoken Tutorial by IIT Bombay is licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/). This combined repository respects and adopts the same license.