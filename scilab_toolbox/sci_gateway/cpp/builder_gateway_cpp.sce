// Copyright (C) 2015 - IIT Bombay - FOSSEE
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
// Author: Rupak Rokade
// Organization: FOSSEE, IIT Bombay

mode(-1)
lines(0)
exec(get_absolute_file_path("builder_gateway_cpp.sce") + "compiler.sce");

toolbox_title = "test_toolbox";
path_builder = get_absolute_file_path('builder_gateway_cpp.sce');

// Define the function names exactly as expected
Function_Names = ["multiply", "sci_multiply", "csci6"];
Files = ["sci_multiply.cpp"];

// Set up basic paths
third_dir = path_builder + filesep() + ".." + filesep() + ".." + filesep() + "thirdparty";

if getos() == "Windows" then
    lib_dir = third_dir + filesep() + "windows" + filesep() + "lib" + filesep() + "x64";
    inc_dir = third_dir + filesep() + "windows" + filesep() + "include";
    
    // CRITICAL: Define flags as plain strings
    c_flags = "-D__USE_DEPRECATED_STACK_FUNCTIONS__ -I" + inc_dir;
    ld_flags = "-L" + lib_dir + " -lmul";
else
    lib_dir = third_dir + filesep() + "linux" + filesep() + "lib" + filesep() + "x64";
    inc_dir = third_dir + filesep() + "linux" + filesep() + "include";
    
    c_flags = "-I" + inc_dir;
    ld_flags = "-L" + lib_dir + " -lmul -Wl,-rpath=" + lib_dir;
end

// Call with proper argument types - Note exactly 8 arguments with the correct types
tbx_build_gateway(toolbox_title, Function_Names, Files, path_builder, [], ld_flags, c_flags, "");

clear toolbox_title Function_Names Files third_dir lib_dir inc_dir c_flags ld_flags path_builder;