@echo off
setlocal EnableExtensions DisableDelayedExpansion
cd /d "%~dp0"
color 0E
title Gaming Dependency Pack v26.3.0

:: Brought to you by AnubyteCode

:: Redistributables are redistributable, here's a megapack.
:: If you can think of more, let me know.



::::::::::::  
:isit  
:ADMIN  
::::::::::::  
:: DOS5+/Win9x/ME → NT/XP → Vista+ → ElevateAB  
:: If %OS% not defined → DOS/9x/3.x  
if not "%OS%"=="Windows_NT" goto it  
:: Check if user is already admin  
net session >nul 1>nul
if not errorlevel 1 goto :it  
:: Check if fltmc exists (Vista+)  
fltmc >nul 1>nul
if errorlevel 9009 goto fail  
:: Check if PowerShell exists  
powershell -? >nul 1>nul
if errorlevel 9009 goto fail  
:: Try elevation via PowerShell  
powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"  
exit  
:fail  
echo  This script requires Administrator privileges.  
echo    Please elevate or log in as an Administrator.  
exit /b 1  
::::::::::::  
:it  
:hasadmin  
::::::::::::



::---Init-----------------------------------------::

:archpeek
set "IS_X64=0" && if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set IS_X64=1) else (if "%PROCESSOR_ARCHITEW6432%"=="AMD64" (set IS_X64=1))

:start
set "choice="
call :banner
echo - Ready to deploy:
echo    DirectPlay, Dx2010, OpenAL, VCv14
echo    VC2005-2022, .net8/9/10, EnvVars
echo.
echo -- This may take some time, need reboot.
choice /T 10 /c:cre /D c /N /M "-- [C]ontinue? With [R]estart? [E]xit now? >"
set "choice=%errorlevel%"
if "%choice%"=="3" goto :exitx

::---Telemetry------------------------------------::

::-------------------------------
:: Anti-Telemetry Environment Vars
::-------------------------------
title Setting Variables...
call :banner
echo  Setting Variables...

:: --- Broad / Microsoft ---
setx DISABLE_TELEMETRY true /M  1>nul 2>nul
setx TELEMETRY_ENABLED false /M  1>nul 2>nul
setx DOTNET_CLI_TELEMETRY_OPTOUT 1 /M  1>nul 2>nul
setx DOTNET_EnableDiagnostics_IPC 0 /M  1>nul 2>nul
setx DOTNET_EnableDiagnostics_Debugger 0 /M  1>nul 2>nul
setx DOTNET_NO_TELEMETRY 1 /M  1>nul 2>nul
setx DOTNET_SKIP_FIRST_TIME_EXPERIENCE 1 /M  1>nul 2>nul
setx COMPLUS_NODOTNETHEALTHMONITOR 1 /M  1>nul 2>nul
setx POWERSHELL_TELEMETRY_OPTOUT 1 /M  1>nul 2>nul
setx PNPPOWERSHELL_DISABLETELEMETRY true /M  1>nul 2>nul
setx VCPKG_DISABLE_METRICS 1 /M  1>nul 2>nul
setx APPLICATIONINSIGHTS_NO_DIAGNOSTIC_CHANNEL 1 /M  1>nul 2>nul
setx AZURE_CORE_COLLECT_TELEMETRY 0 /M  1>nul 2>nul
setx VSCODE_TELEMETRY_DISABLE 1 /M  1>nul 2>nul
setx VSCODE_CRASH_REPORTER_DISABLE 1 /M  1>nul 2>nul
setx GH_NO_TELEMETRY 1 /M  1>nul 2>nul
setx MLDOTNET_CLI_TELEMETRY_OPTOUT 1 /M  1>nul 2>nul

:: --- Web / JS Tools ---
setx NEXT_TELEMETRY_DISABLED 1 /M  1>nul 2>nul
setx ASTRO_TELEMETRY_DISABLED 1 /M  1>nul 2>nul
setx GATSBY_TELEMETRY_DISABLED 1 /M  1>nul 2>nul
setx STRAPI_TELEMETRY_DISABLED true /M  1>nul 2>nul

:: --- OpenTelemetry (Modern apps / SDKs) ---
setx OTEL_SDK_DISABLED true /M  1>nul 2>nul
setx OTEL_PYTHON_DISABLED_INSTRUMENTATIONS all /M  1>nul 2>nul

:: --- HuggingFace Hub API ---
setx HF_HUB_DISABLE_TELEMETRY 1 /M  1>nul 2>nul


::---Features-------------------------------------::

:features
title Installing Legacy DirectPlay...

call :banner
echo  Legacy support...
dism /online /enable-feature /featurename:LegacyComponents

call :banner
echo  DirectPlay...
dism /online /enable-feature /featurename:DirectPlay


::---DirectX--------------------------------------::

:directx
title Installing DirectX 2010...

call :banner
REM echo Old DX Files (online)...
REM start "" /min /wait cmd /c dxwebsetup.exe" /Q
echo Old DX Files...
start "" /min /wait cmd /c "\".\redist\directx_Jun2010_redist.exe\" /Q /T:\"%TEMP%\""
start "" /min /wait cmd /c "\"%TEMP%\dxsetup.exe\" /silent"


::---OpenAL---------------------------------------::

:openal
title Installing OpenAL...

call :banner
echo  OpenAL...
start "" /min /wait cmd /c "\".\redist\oalinst.exe\" /S"


::---VC/.Net--------------------------------------::

:archvcn
if "%IS_X64%"=="1" (
	title Installing VC/.Net x86/x64...
) else (
	title Installing VC/.Net x86...
)

:visualc
call :banner
echo  VC 2005...
start "" /min /wait cmd /c "\".\redist\vcredist2005_x86.exe\" /Q /T:\"%TEMP%\""
if "%IS_X64%"=="1" (
	start "" /min /wait cmd /c "\".\redist\vcredist2005_x64.exe\" /Q /T:\"%TEMP%\""
)

call :banner
echo  VC 2008...
start "" /min /wait cmd /c "\".\redist\vcredist2008_x86.exe\" /Q"
if "%IS_X64%"=="1" (
	start "" /min /wait cmd /c "\".\redist\vcredist2008_x64.exe\" /Q"
)

call :banner
echo  VC 2010...
start "" /min /wait cmd /c "\".\redist\vcredist2010_x86.exe\" /quiet /norestart"
if "%IS_X64%"=="1" (
	start "" /min /wait cmd /c "\".\redist\vcredist2010_x64.exe\" /quiet /norestart"
)

call :banner
echo  VC 2012...
start "" /min /wait cmd /c "\".\redist\vcredist2012_x86.exe\" /quiet /norestart"
if "%IS_X64%"=="1" (
	start "" /min /wait cmd /c "\".\redist\vcredist2012_x64.exe\" /quiet /norestart"
)

call :banner
echo  VC 2013...
start "" /min /wait cmd /c "\".\redist\vcredist2013_x86.exe\" /quiet /norestart"
if "%IS_X64%"=="1" (
	start "" /min /wait cmd /c "\".\redist\vcredist2013_x64.exe\" /quiet /norestart"
)

call :banner
echo  VC v14...
start "" /min /wait cmd /c "\".\redist\VC_redist_v14.x86.exe\" /quiet /norestart"
if "%IS_X64%"=="1" (
	start "" /min /wait cmd /c "\".\redist\VC_redist_v14.x64.exe\" /quiet /norestart"
)

call :banner
echo  VC 2015-2022...
start "" /min /wait cmd /c "\".\redist\vcredist2015_2017_2019_2022_x86.exe\" /quiet /norestart"
if "%IS_X64%"=="1" (
	start "" /min /wait cmd /c "\".\redist\vcredist2015_2017_2019_2022_x64.exe\" /quiet /norestart"
)

:dotnet
call :banner
echo  .Net 8...
start "" /min /wait cmd /c "\".\redist\windowsdesktop-runtime-8.0.25-win-x86.exe\" /quiet /norestart"
if "%IS_X64%"=="1" (
	start "" /min /wait cmd /c "\".\redist\windowsdesktop-runtime-8.0.25-win-x64.exe\" /quiet /norestart"
)

call :banner
echo  .Net 9...
start "" /min /wait cmd /c "\".\redist\windowsdesktop-runtime-9.0.14-win-x86.exe\" /quiet /norestart"
if "%IS_X64%"=="1" (
	start "" /min /wait cmd /c "\".\redist\windowsdesktop-runtime-9.0.14-win-x64.exe\" /quiet /norestart"
)

call :banner
echo  .Net 10...
start "" /min /wait cmd /c "\".\redist\windowsdesktop-runtime-10.0.5-win-x86.exe\" /quiet /norestart"
if "%IS_X64%"=="1" (
	start "" /min /wait cmd /c "\".\redist\windowsdesktop-runtime-10.0.5-win-x64.exe\" /quiet /norestart"
)

::---END-OF-INSTALL--------------------------------------::
goto :exitx



:::---FUNCTIONS---:::

:exitx
call :banner
echo.
if "%choice%"=="1" (
	echo Installation completed...
	echo Restart recommended ASAP...
	echo.
	set "choice="
	timeout /t 5
	exit /b 1
)
if "%choice%"=="2" (
	echo Installation completed...
	echo Restarting in 10 seconds...
	echo.
	set "choice="
	timeout /t 10
	call :reboot
	exit /b 2
)
if "%choice%"=="3" (
	Installation canceled...
	echo Nothing has been changed...
	echo.
	set "choice="
	timeout /t 5
	exit /b 3
)
goto:eof

:banner
timeout /t 2 /nobreak  1>nul 2>nul
cls
echo  ==========================
echo  The Gaming Dependency Pack
echo  ==========================
echo.
echo.
goto:eof

:reboot
shutdown /r /t 1  1>nul 2>nul
goto:eof
