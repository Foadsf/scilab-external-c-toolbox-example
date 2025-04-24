@echo off
setlocal enabledelayedexpansion

:: Set paths
set SCILAB_ROOT=C:\Program Files\scilab-2024.0.0
set MINGW_PATH=C:\msys64\mingw64\bin
set PATH=%MINGW_PATH%;%PATH%
set CURRENT_DIR=%~dp0
cd /d "%CURRENT_DIR%"

:: Set include paths
set INCLUDES=-I"%CURRENT_DIR%includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\output_stream\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\ast\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\ast\includes\types"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\ast\includes\ast"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\core\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\api_scilab\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\localization\includes"
set INCLUDES=%INCLUDES% -I"..\..\..\c_library_source"

:: Common compiler flags
set CFLAGS=-c -D__USE_DEPRECATED_STACK_FUNCTIONS__ -fpermissive -fcommon -w

:: Scilab library paths
set SCILAB_LIBS=-L"%SCILAB_ROOT%\bin"
set SCILAB_LIBS=%SCILAB_LIBS% -lapi_scilab -loutput_stream -lcore -last

:: Compile mul.c directly - corrected path
echo Compiling mul.c directly...
gcc %CFLAGS% %INCLUDES% ..\..\..\c_library_source\mul.c -o mul.o

echo Compiling sci_multiply_modified.cpp...
g++ %CFLAGS% %INCLUDES% sci_multiply_modified.cpp -o sci_multiply.o

echo Compiling gateway...
g++ %CFLAGS% %INCLUDES% test_toolbox.cpp -o test_toolbox.o

echo Creating DLL with static linking...
g++ -shared -o test_toolbox.dll sci_multiply.o test_toolbox.o mul.o %SCILAB_LIBS% -Wl,--subsystem,windows

if exist test_toolbox.dll (
  echo Build successful!
  echo Copying DLL to appropriate location...
  copy /Y test_toolbox.dll ..\..
) else (
  echo Build failed!
)

endlocal