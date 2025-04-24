@echo off
setlocal enabledelayedexpansion

:: Set paths
set SCILAB_ROOT=C:\Program Files\scilab-2024.0.0
set MINGW_PATH=C:\msys64\mingw64\bin
set PATH=%MINGW_PATH%;%PATH%
set CURRENT_DIR=%~dp0
cd /d "%CURRENT_DIR%"

:: Create includes directory if it doesn't exist (though we made one before)
if not exist "includes" mkdir "includes"

:: Set include paths - Make sure all needed paths are here
set INCLUDES=-I"%SCILAB_ROOT%\modules\output_stream\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\api_scilab\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\localization\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\core\includes"
set INCLUDES=%INCLUDES% -I"%CURRENT_DIR%includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\ast\includes\types"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\ast\includes\ast"

:: Common compiler flags
set CFLAGS=-c -D__USE_DEPRECATED_STACK_FUNCTIONS__ -fpermissive -fcommon -w

:: Scilab library paths - Ensure all needed libs are here
set SCILAB_LIBS=-L"%SCILAB_ROOT%\bin"
set SCILAB_LIBS=%SCILAB_LIBS% -lapi_scilab
set SCILAB_LIBS=%SCILAB_LIBS% -lcore
set SCILAB_LIBS=%SCILAB_LIBS% -loutput_stream
set SCILAB_LIBS=%SCILAB_LIBS% -last

:: ---> Clean previous artifacts <---
del simple_test.o simple_test.dll > nul 2>&1

echo Compiling simple_test.cpp...
g++ %CFLAGS% %INCLUDES% simple_test.cpp -o simple_test.o

echo Creating DLL...
g++ -shared -o simple_test.dll simple_test.o %SCILAB_LIBS% -Wl,--subsystem,windows

if exist simple_test.dll (
  echo Build successful!
  echo Copying DLL to appropriate location...
  :: Copy to the main toolbox directory for simple_loader.sce
  copy /Y simple_test.dll ..\..
) else (
  echo Build failed!
)

endlocal