# Scilab External C Toolbox Example

This repository demonstrates how to create a Scilab toolbox that calls functions from an external C library using Scilab's gateway mechanism. It combines concepts shown in the Spoken Tutorial "Developing Scilab Toolbox for calling external C libraries" by IIT Bombay.

This approach is useful when you want to:
*   Leverage existing high-performance C/C++ code within the Scilab environment.
*   Integrate specialized algorithms not available directly in Scilab.
*   Improve the performance of computationally intensive tasks.

This repository provides several examples:
1.  A minimal gateway example (`very_simple.*`).
2.  A slightly more standard gateway example (`simple_test.*`).
3.  An example showing how to build a gateway that **statically links** an external C function (`sci_multiply_modified.cpp`, `build_manual.bat`).
4.  The original toolbox structure (`builder.sce`, etc.) which demonstrates **dynamic linking** to a pre-compiled external library placed in a `thirdparty` directory (as shown in the Spoken Tutorial).

## Original Source and Attribution

This example is based on the code files and concepts presented in the Spoken Tutorial:
*   **Tutorial:** Developing Scilab Toolbox for calling external C libraries
*   **Author:** Rupak Rokade
*   **Organization:** IIT Bombay, FOSSEE Project
*   **Original Tutorial Link:** [https://spoken-tutorial.org/watch/Scilab/Developing+Scilab+Toolbox+for+calling+external+C+libraries/English/](https://spoken-tutorial.org/watch/Scilab/Developing+Scilab+Toolbox+for+calling+external+C+libraries/English/)
*   **Original License:** The content from the Spoken Tutorial is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

We thank the original authors and the Spoken Tutorial project at IIT Bombay for providing this valuable learning resource.

## Repository Structure

*   **`.gitignore`, `.gitattributes`**: Git configuration files.
*   **`README.md`**: This file.
*   **`c_library_source/`**: Contains the source code (`mul.c`, `mul.h`) for the external C multiplication library and a script (`run.sh`) to build it for Linux/macOS (creating a `thirdparty` structure).
*   **`scilab_toolbox/`**: Contains the main Scilab toolbox components.
    *   **`etc/`**: Startup/quit scripts, preferences.
    *   **`help/`**: Source files and scripts for building help pages.
    *   **`jar/`**: (Generated) Contains packaged help files.
    *   **`locales/`**: Localization files (`.po`).
    *   **`macros/`**: Scilab function (`.sci`) files.
    *   **`sci_gateway/`**: Gateway source code and build scripts.
        *   **`cpp/`**: C++ gateway implementations and manual build scripts (`.bat`).
            *   `very_simple.*`, `simple_test.*`: Minimal examples.
            *   `sci_multiply_modified.cpp`, `test_toolbox.*`: Gateway for the `multiply` function.
            *   `build_very_simple.bat`, `build_simple.bat`, `build_manual.bat`: Manual build scripts for Windows/MinGW.
            *   `builder_gateway_cpp.sce`: Scilab script used by the main `builder.sce`.
            *   `includes/`: Contains dummy headers needed for manual compilation.
        *   `builder_gateway.sce`, `loader_gateway.sce`, `cleaner_gateway.sce`: Scilab scripts used by the main `builder.sce`.
    *   `builder.sce`, `loader.sce`, `cleaner.sce`, `unloader.sce`: Original Scilab scripts for building/managing the *entire* toolbox (dynamically linked version).
    *   `very_simple_loader.sce`, `simple_loader.sce`, `loader_manual.sce`: Manual Scilab loader scripts corresponding to the `.bat` build scripts.

## Building and Running on Windows (MINGW64/MSYS2) - Manual Methods

These methods use `.bat` scripts for direct compilation via MinGW GCC and dedicated `.sce` loaders. This is currently the most reliable way to build these examples on Windows within this repository setup.

**Prerequisites:**
*   MSYS2 installed with the MINGW64 environment.
*   MINGW64 GCC toolchain installed: `pacman -Syu` then `pacman -S --needed mingw-w64-x86_64-toolchain make`.
*   Your standard Windows Scilab installation (e.g., `C:\Program Files\scilab-2024.0.0`). The batch scripts assume this path; edit them if yours differs.

**Run commands from `cmd.exe` in the repository root directory.**

### 1. Very Simple Example (No External Lib)

This builds a minimal gateway DLL that returns a constant value.

*   **Build:**
    ```cmd
    .\scilab_toolbox\sci_gateway\cpp\build_very_simple.bat
    ```
*   **Load & Test:**
    ```cmd
    "C:\Program Files\scilab-2024.0.0\bin\WScilex-cli.exe" -f ".\scilab_toolbox\very_simple_loader.sce" -quit
    ```
    *(Expected output includes: "Function returned: 42")*

### 2. Simple Example (No External Lib)

This builds a slightly more standard gateway DLL that returns a constant value.

*   **Build:**
    ```cmd
    .\scilab_toolbox\sci_gateway\cpp\build_simple.bat
    ```
*   **Load & Test:**
    ```cmd
    "C:\Program Files\scilab-2024.0.0\bin\WScilex-cli.exe" -f ".\scilab_toolbox\simple_loader.sce" -quit
    ```
    *(Expected output includes: "Function returned: 99")*

### 3. Manual Build with External C Library (Static Linking)

This compiles `mul.c` and the gateway code, then *statically links* `mul.o` directly into the final `test_toolbox.dll`. It does *not* require the `thirdparty` directory setup.

*   **Build:**
    ```cmd
    .\scilab_toolbox\sci_gateway\cpp\build_manual.bat
    ```
*   **Load:** (Run Scilab and execute the loader manually, or use the CLI without `-quit`)
    ```cmd
    "C:\Program Files\scilab-2024.0.0\bin\WScilex-cli.exe" -f ".\scilab_toolbox\loader_manual.sce"
    ```
*   **Test (Inside Scilab):**
    ```scilab
    --> multiply(7, 6)
     ans  =
       42.
    --> exit
    ```

## Original Build Method (Dynamic Linking via `builder.sce`)

This is the method demonstrated in the original Spoken Tutorial. It builds the *entire* toolbox using Scilab's `tbx_build_*` functions and expects a **pre-compiled external C library** (e.g., `libmul.dll` on Windows, `libmul.so` on Linux) to be present in the `scilab_toolbox/thirdparty/` directory structure.

**Steps (Conceptual - may require troubleshooting on Windows):**

1.  **Build External C Library:** Use `c_library_source/run.sh` (Linux/macOS) or compile `mul.c` manually into the appropriate DLL/shared library for your OS.
2.  **Copy `thirdparty`:** Copy the entire generated `thirdparty` directory (containing include/ and lib/ subdirs with `mul.h` and the compiled library) into the `scilab_toolbox/` directory.
3.  **Run Scilab Builders:**
    *   Start Scilab, `cd` to `scilab_toolbox/`.
    *   `exec builder.sce -nogui`
    *   `exec loader.sce`
    *   Test `multiply(3, 5)`

**Note on Windows:** This original method (`builder.sce`) can sometimes be tricky on Windows/MinGW due to how Scilab's internal build functions handle compiler/linker flags and paths compared to the direct `.bat` script approach. You might encounter errors like the `strsubst` issue seen during debugging. For a direct Windows/MinGW build, the `.bat` script methods above are recommended.

## General Prerequisites

*   **Scilab:** Version 6.0.2 or later (as used in the tutorial) or 2024.0.0 (as used in testing).
*   **C/C++ Compiler:**
    *   For manual Windows builds: MINGW64 GCC (via MSYS2).
    *   For Linux/macOS `run.sh`: GCC.
*   **(Optional) Make:** May be needed by Scilab's internal build system.

## License

The original content from the Spoken Tutorial by IIT Bombay is licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/). This combined repository respects and adopts the same license.