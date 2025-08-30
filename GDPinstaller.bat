@echo off
CD /d %~dp0
color 0E
title Gaming Dependency Pack v25.9.0
:: Brought to you by AnubyteCode

:: Redistributables are redistributable so here's a megapack.
:: If you can think of more, let me know. This seems to work for me.


:::::::::::::::::::
:: Are we admin? ::
:::::::::::::::::::
>nul 2>&1 reg query "HKU\S-1-5-19\Environment"
if '%errorlevel%' NEQ '0' (
	(echo.Set UAC = CreateObject^("Shell.Application"^)&echo.UAC.ShellExecute "%~s0", "", "", "runas", 1)>"%temp%\getadmin.vbs"
	"%temp%\getadmin.vbs"
	del "%temp%\getadmin.vbs" 2>nul
	exit /B
) else ( >nul 2>&1 del "%temp%\getadmin.vbs" )
:::::::::::::::::::
:: Admin granted ::
:::::::::::::::::::



:start
:: All Arch
call :banner
echo This may take some time...
echo.
echo.
pause

call :banner
echo Legacy support...
dism /online /enable-feature /featurename:LegacyComponents

call :banner
echo DirectPlay...
dism /online /enable-feature /featurename:DirectPlay

call :banner
REM echo Old DX Files (online)...
REM start /wait dxwebsetup.exe /Q
echo Old DX Files...
start /wait directx_Jun2010_redist.exe /Q

:: Set the dotnet telemetry environment variable
setx DOTNET_CLI_TELEMETRY_OPTOUT 1 /M


:next
:: Arch Detect
set IS_X64=0 && if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (set IS_X64=1) else (if "%PROCESSOR_ARCHITEW6432%"=="AMD64" (set IS_X64=1))
if "%IS_X64%" == "1" goto :X64x

:X86x
call :banner
echo VC 2005...
start /wait vcredist2005_x86.exe /q

call :banner
echo VC 2008...
start /wait vcredist2008_x86.exe /qb

call :banner
echo VC 2010...
start /wait vcredist2010_x86.exe /passive /norestart

call :banner
echo VC 2012...
start /wait vcredist2012_x86.exe /passive /norestart

call :banner
echo VC 2013...
start /wait vcredist2013_x86.exe /passive /norestart

call :banner
echo VC 2015 - 2022...
start /wait vcredist2015_2017_2019_2022_x86.exe /passive /norestart

call :banner
echo .Net 8...
start /wait windowsdesktop-runtime-8.0.19-win-x86.exe /passive /norestart

call :banner
echo .Net 9...
start /wait windowsdesktop-runtime-9.0.8-win-x86.exe /passive /norestart

goto :exitx


:X64x
call :banner
echo VC 2005...
start /wait vcredist2005_x86.exe /q
start /wait vcredist2005_x64.exe /q

call :banner
echo VC 2008...
start /wait vcredist2008_x86.exe /qb
start /wait vcredist2008_x64.exe /qb

call :banner
echo VC 2010...
start /wait vcredist2010_x86.exe /passive /norestart
start /wait vcredist2010_x64.exe /passive /norestart

call :banner
echo VC 2012...
start /wait vcredist2012_x86.exe /passive /norestart
start /wait vcredist2012_x64.exe /passive /norestart

call :banner
echo VC 2013...
start /wait vcredist2013_x86.exe /passive /norestart
start /wait vcredist2013_x64.exe /passive /norestart

call :banner
echo VC 2015 - 2022...
start /wait vcredist2015_2017_2019_2022_x86.exe /passive /norestart
start /wait vcredist2015_2017_2019_2022_x64.exe /passive /norestart

call :banner
echo .Net 8...
start /wait windowsdesktop-runtime-8.0.19-win-x86.exe /passive /norestart
start /wait windowsdesktop-runtime-8.0.19-win-x64.exe /passive /norestart

call :banner
echo .Net 9...
start /wait windowsdesktop-runtime-9.0.8-win-x86.exe /passive /norestart
start /wait windowsdesktop-runtime-9.0.8-win-x64.exe /passive /norestart


:exitx
call :banner
echo.
echo Installation completed...
echo.
echo.
timeout /t 5
exit


:banner
timeout /t 2 /nobreak > nul
cls
echo ==========================
echo The Gaming Dependency Pack
echo ==========================
echo.
echo.
goto:eof
