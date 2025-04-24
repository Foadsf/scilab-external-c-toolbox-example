@echo off
setlocal enabledelayedexpansion

:: Set paths
set SCILAB_ROOT=C:\Program Files\scilab-2024.0.0
set MINGW_PATH=C:\msys64\mingw64\bin
set PATH=%MINGW_PATH%;%PATH%
set CURRENT_DIR=%~dp0
cd /d "%CURRENT_DIR%"

:: Create includes directory if it doesn't exist
if not exist "includes" mkdir "includes"

:: Set include paths - add core includes
set INCLUDES=-I"%SCILAB_ROOT%\modules\output_stream\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\api_scilab\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\localization\includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\core\includes"
set INCLUDES=%INCLUDES% -I"%CURRENT_DIR%includes"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\ast\includes\types"
set INCLUDES=%INCLUDES% -I"%SCILAB_ROOT%\modules\ast\includes\ast"

:: Common compiler flags - simplified
set CFLAGS=-c -fpermissive -w

:: Scilab library paths
set SCILAB_LIBS=-L"%SCILAB_ROOT%\bin"
set SCILAB_LIBS=%SCILAB_LIBS% -lapi_scilab
set SCILAB_LIBS=%SCILAB_LIBS% -lcore
set SCILAB_LIBS=%SCILAB_LIBS% -loutput_stream
set SCILAB_LIBS=%SCILAB_LIBS% -last

echo Compiling very_simple.cpp...
g++ %CFLAGS% %INCLUDES% very_simple.cpp -o very_simple.o

echo Creating DLL...
g++ -shared -o very_simple.dll very_simple.o %SCILAB_LIBS% -Wl,--subsystem,windows

if exist very_simple.dll (
  echo Build successful!
  echo Copying DLL to appropriate location...
  copy /Y very_simple.dll ..\..
) else (
  echo Build failed!
)

endlocal