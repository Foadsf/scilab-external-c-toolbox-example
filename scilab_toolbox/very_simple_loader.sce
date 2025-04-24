// Very simple loader
function load_very_simple()
    path = get_absolute_file_path("very_simple_loader.sce");
    disp("Current path: " + path);
    
    dllpath = path + "very_simple.dll";
    disp("Looking for DLL at: " + dllpath);
    
    if isfile(dllpath) then
      disp("DLL file exists");
    else
      disp("DLL file not found!");
      return;
    end
    
    try
      addinter(dllpath, "very_simple", ["very_simple"]);
      disp("Function ""very_simple"" loaded successfully!");
    catch
      errmsg = lasterror();
      disp("There was an error loading the function:");
      disp(errmsg);
    end
  end
  
  load_very_simple();
  
  // Try to use the function if it loaded
  try
    result = very_simple();
    disp("Function returned: " + string(result));
  catch
    disp("Could not execute very_simple function");
  end