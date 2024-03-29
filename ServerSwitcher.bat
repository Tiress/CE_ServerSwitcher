echo off

:: search through the config file and print the user what his server options are
echo These are your server options:
echo:
for /f "delims=; tokens=1,2" %%i in ('findstr /rbc:"[1-5];*" config.txt') do echo %%i - %%j
echo:
echo Please use numbers 1-5 on your keyboard to pick the server you want to connect to.
echo:

:: ask for user input and remeber it
choice /C 12345 /N

set userchoice=%errorlevel%

:: based on user input set up necessary variables
:: first we need an IP adress and password
for /f "tokens=3,4 delims=;" %%i in ('findstr /rbc:"%userchoice%;*" config.txt') do (
	set "sip=%%i"
	set "spwd=%%j"
)

:: we also need a path to the executable
for /f "tokens=2 delims=^=" %%i in ('findstr /rbc:"ConanPath=*" config.txt') do set "ConanPath=%%i"

:: and we also need a path to the mod folder
set "ConanMods=%ConanPath%ConanSandbox\Mods\"

:: aand we also need a path to steam executable
for /f "tokens=2 delims=^=" %%i in ('findstr /rbc:"SteamPath=*" config.txt') do set "SteamPath=%%i"

:: we check if the paths are correct
if not exist "%ConanPath%\ConanSandbox.exe" goto :nopath_conan
if not exist "%SteamPath%\steam.exe" goto :nopath_steam

:: we make a backup first, just in case..
md "%ConanMods%_backup"
copy "%ConanMods%modlist.txt" "%ConanMods%_backup\modlist.txt"

:: now we copy our chosen server modlist to ConanMods folder
copy "server%userchoice%\modlist.txt" "%ConanMods%modlist.txt"

:: finaly we run the game
"%steampath%steam.exe" -applaunch 440900 +connect %sip% +password %spwd%

goto :end

:nopath_conan

echo:
echo *----------------------------------------------------*
echo *   Error:    ConanPath isn't filled up correctly.   *
echo *----------------------------------------------------*
echo:
pause
goto :end

:nopath_steam

echo:
echo *----------------------------------------------------*
echo *   Error:    ConanPath isn't filled up correctly.   *
echo *----------------------------------------------------*
echo:
pause
goto :end

:end
exit