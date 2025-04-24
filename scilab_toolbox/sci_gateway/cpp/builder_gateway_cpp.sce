// Copyright (C) 2015 - IIT Bombay - FOSSEE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// Author: Rupak Rokade
// Organization: FOSSEE, IIT Bombay

mode(-1);
lines(0);

// -------- START OF MODIFICATION (Method 2) --------
// Explicitly tell the build system to use the MinGW make tools on Windows
// This needs to be done *before* functions that rely on the compiler are called.
if getos() == "Windows" then
    setenv("SCILAB_COMPILER", "mingw");
end
// -------- END OF MODIFICATION --------

toolbox_title = "test_toolbox";
path_builder = get_absolute_file_path('builder_gateway_cpp.sce');

// Define the function names exactly as expected by ilib_build
// Format: ["ScilabFunctionName", "C/C++ GatewayFunctionName", "LanguageType"]
Function_Names = ["multiply", "sci_multiply", "csci6"]; // csci6 is often used for C++

// Define the source files for the gateway relative to path_builder
Files = ["sci_multiply.cpp"];

// Set up basic paths
third_dir = path_builder + filesep() + ".." + filesep() + ".." + filesep() + "thirdparty";

// Platform-specific flags
if getos() == "Windows" then
    // Get Scilab version info if needed
    // [a, opt] = getversion();
    // Version = opt(2); // Example: "x.y"

    // Define paths - STILL NEEDED for reference later if linking fails
    lib_dir = third_dir + filesep() + "windows" + filesep() + "lib" + filesep() + "x64";
    inc_dir = third_dir + filesep() + "windows" + filesep() + "include";

    // -------- MINIMAL FLAGS FOR DEBUGGING --------
    // Define C Flags as empty for now
    C_Flags = []; // Empty matrix

    // Define Linker Flags with only the essential library link
    Linker_Flag = ["-lmul"]; // Just the library name flag as a column vector
    // -------- END MINIMAL FLAGS --------

elseif getos() == "Darwin" then
// ... (Keep Mac flags as they were, likely correct vector format now) ...
    lib_dir = third_dir + filesep() + "Mac" + filesep() + "lib" + filesep() + "x64";
    inc_dir = third_dir + filesep() + "Mac" + filesep() + "include";
    C_Flags = ["-D__USE_DEPRECATED_STACK_FUNCTIONS__"; "-w"; "-fpermissive"; "-I" + path_builder; "-I" + inc_dir; "-Wl,-rpath," + lib_dir];
    Linker_Flag = ["-L" + lib_dir; "-lmul"; "-Wl,-rpath," + lib_dir];

else // Linux/Other Unix-like
// ... (Keep Linux flags as they were, likely correct vector format now) ...
    lib_dir = third_dir + filesep() + "linux" + filesep() + "lib" + filesep() + "x64";
    inc_dir = third_dir + filesep() + "linux" + filesep() + "include";
    C_Flags = ["-I" + inc_dir];
    Linker_Flag = ["-L" + lib_dir; "-lmul"; "-Wl,-rpath=" + lib_dir];
end

// --- Call tbx_build_gateway ---
tbx_build_gateway(toolbox_title, Function_Names, Files, path_builder, [], Linker_Flag, C_Flags, "");

// Clean up variables
clear toolbox_title Function_Names Files third_dir lib_dir inc_dir C_Flags Linker_Flag path_builder;
// clear a opt Version