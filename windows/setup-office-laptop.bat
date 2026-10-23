@echo off
setlocal EnableExtensions
cd /d "%~dp0"

set "TOOLS=%USERPROFILE%\GitHubTools"
set "GITDIR=%TOOLS%\PortableGit"
set "GHDIR=%TOOLS%\gh"
set "DESK=%~dp0desktop"
set "SETUP=%DESK%\GitHubDesktopSetup-x64.exe"
set "EXPECTED=2E38DB8D986884474A1E45AFDDF554A7187F42124BD38A3D7EA165BE7F77F90D"

echo.
echo Git and GitHub setup
echo Files install into: %TOOLS%
echo Administrator rights are not required for the portable option.
echo.

if not exist "%TOOLS%" mkdir "%TOOLS%"

echo Choose how to install Git:
echo   1  Portable Git. No administrator. Recommended.
echo   2  Full installer. Use this if you are allowed to install programs.
set /p CHOICE=Type 1 or 2, then press Enter [1]: 
if "%CHOICE%"=="" set "CHOICE=1"

if "%CHOICE%"=="2" goto fullgit
goto portablegit

:portablegit
if exist "%GITDIR%\cmd\git.exe" (
  echo Portable Git is already extracted.
  goto extractgh
)
echo Extracting Portable Git...
if not exist "%GITDIR%" mkdir "%GITDIR%"
"%~dp0PortableGit-2.56.0.3-64-bit.7z.exe" -y -gm2 -o"%GITDIR%"
if not exist "%GITDIR%\cmd\git.exe" (
  echo.
  echo Automatic extract did not finish.
  echo Double-click PortableGit-2.56.0.3-64-bit.7z.exe and extract it to:
  echo   %GITDIR%
  echo Then run this script again.
  pause
  exit /b 1
)
goto extractgh

:fullgit
echo Starting the Git for Windows installer...
start /wait "" "%~dp0Git-2.56.0.3-64-bit.exe"
goto extractgh

:extractgh
if exist "%GHDIR%\bin\gh.exe" (
  echo GitHub CLI is already extracted.
  goto addpath
)
echo Extracting GitHub CLI...
if not exist "%GHDIR%" mkdir "%GHDIR%"
tar -xf "%~dp0gh_2.103.0_windows_amd64.zip" -C "%GHDIR%"
if not exist "%GHDIR%\bin\gh.exe" (
  echo Could not extract gh.exe. Unzip gh_2.103.0_windows_amd64.zip into %GHDIR% and run this script again.
  pause
  exit /b 1
)

:addpath
echo Adding GitHub CLI to PATH for Git Bash and new terminals...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0add-gh-to-path.ps1"
if errorlevel 1 (
  echo Could not add gh to PATH.
  pause
  exit /b 1
)

:joindesktop
if exist "%SETUP%" goto checkhash
echo Joining the GitHub Desktop installer...
copy /b "%DESK%\GitHubDesktopSetup-x64.exe.001+%DESK%\GitHubDesktopSetup-x64.exe.002+%DESK%\GitHubDesktopSetup-x64.exe.003" "%SETUP%" >nul
if not exist "%SETUP%" (
  echo Could not join the GitHub Desktop installer parts.
  pause
  exit /b 1
)

:checkhash
echo Checking the GitHub Desktop installer...
powershell -NoProfile -Command "$h=(Get-FileHash -Algorithm SHA256 -LiteralPath '%SETUP%').Hash; if ($h -ne '%EXPECTED%') { Write-Host ('HASH MISMATCH: ' + $h); exit 1 } else { Write-Host 'GitHub Desktop installer hash OK' }"
if errorlevel 1 (
  echo The joined installer does not match the official file. Delete %SETUP% and run this script again.
  pause
  exit /b 1
)

echo Starting GitHub Desktop setup...
start /wait "" "%SETUP%"

set "PROMPTBAT=%TOOLS%\Git and GitHub Prompt.bat"
(
  echo @echo off
  echo set "PATH=%GITDIR%\cmd;C:\Program Files\Git\cmd;%GHDIR%\bin;%%PATH%%"
  echo echo.
  echo git --version
  echo gh --version
  echo echo.
  echo echo Sign in to GitHub once with:  gh auth login
  echo echo.
  echo cd /d "%%USERPROFILE%%"
  echo cmd /k
) > "%PROMPTBAT%"

copy /y "%PROMPTBAT%" "%USERPROFILE%\Desktop\Git and GitHub Prompt.bat" >nul

echo.
echo Setup files are ready.
echo A command window will open. In that window, run:  gh auth login
echo.
pause
start "" "%PROMPTBAT%"
exit /b 0
