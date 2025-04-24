// Manual loader script for test_toolbox
function load_multiply()
    path = get_absolute_file_path("loader_manual.sce");
    disp("Current path: " + path);
    
    // Check for the main DLL
    dllpath = path + "test_toolbox.dll";
    disp("Looking for main DLL at: " + dllpath);
    if isfile(dllpath) then
      disp("Main DLL file exists");
    else
      disp("Main DLL file not found!");
      return;
    end
    
    // Check for the dependency DLL
    libpath = path + "libmul.dll";
    disp("Looking for libmul.dll at: " + libpath);
    if isfile(libpath) then
      disp("libmul.dll exists");
    else
      disp("libmul.dll not found! Copying it...");
      copyfile(path + "thirdparty\windows\lib\x64\libmul.dll", path);
      if isfile(libpath) then
        disp("libmul.dll copied successfully");
      else
        disp("Failed to copy libmul.dll");
        return;
      end
    end
    
    try
      addinter(dllpath, "test_toolbox", ["multiply"]);
      disp("Function ""multiply"" loaded successfully!");
    catch
      errmsg = lasterror();
      disp("There was an error loading the multiply function:");
      disp(errmsg);
    end
  end
  
  load_multiply();