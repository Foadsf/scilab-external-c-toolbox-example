// Simple test loader
function load_simple_test()
    path = get_absolute_file_path("simple_loader.sce");
    disp("Current path: " + path);
    
    dllpath = path + "simple_test.dll";
    disp("Looking for DLL at: " + dllpath);
    
    if isfile(dllpath) then
      disp("DLL file exists");
    else
      disp("DLL file not found!");
      return;
    end
    
    try
      addinter(dllpath, "simple_test", ["simple_test"]);
      disp("Function ""simple_test"" loaded successfully!");
    catch
      errmsg = lasterror();
      disp("There was an error loading the function:");
      disp(errmsg);
    end
  end
  
  load_simple_test();
  
  // Try to use the function if it loaded
  try
    result = simple_test();
    disp("Function returned: " + string(result));
  catch
    disp("Could not execute simple_test function");
  end