// Copyright (C) 2008 - INRIA
// Copyright (C) 2009-2011 - DIGITEO

// This file is released under the 3-clause BSD license. See COPYING-BSD.

mode(-1);
lines(0);

function main_builder()
    TOOLBOX_NAME  = "test_toolbox";
    TOOLBOX_TITLE = "test_toolbox";
    toolbox_dir   = get_absolute_file_path("builder.sce");

    // Check Scilab's version
    // =============================================================================

    try
        v = getversion("scilab");
    catch
        error(gettext("Scilab 5.3 or more is required."));
    end

    if v(1) < 5 & v(2) < 3 then
        // new API in scilab 5.3
        error(gettext("Scilab 5.3 or more is required."));
    end

    // Check modules_manager module availability
    // =============================================================================

    if ~isdef("tbx_build_loader") then
        error(msprintf(gettext("%s module not installed."), "modules_manager"));
    end

    // Action
    // =============================================================================
    // Original line
    // help_from_sci("macros","help/en_US");

    // Corrected lines:
    macros_path = toolbox_dir + filesep() + "macros";
    help_output_path = toolbox_dir + filesep() + "help" + filesep() + "en_US";
    help_from_sci(macros_path, help_output_path);
    
    tbx_builder_macros(toolbox_dir);
    tbx_builder_gateway(toolbox_dir);
    tbx_build_localization(toolbox_dir);
    tbx_builder_help(toolbox_dir);
    tbx_build_loader(toolbox_dir);
    tbx_build_cleaner(toolbox_dir);

endfunction
// =============================================================================
main_builder();
clear main_builder; // remove main_builder on stack
// =============================================================================


