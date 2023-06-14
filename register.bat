@echo off
rem Registration of Mrcmd Tool for Windows GitBash
rem https://www.tutorialspoint.com/batch_script/
rem https://ss64.com/nt/syntax-substring.html

set MRCMD_PATH=%cd:\=/%
set MRCMD_PATH=/%MRCMD_PATH::=%/cmd.sh
set MRCMD_DIR_BIN=%USERPROFILE%\AppData\Local\Mrcmd
set MRCMD_PATH_BIN=%MRCMD_DIR_BIN%\mrcmd

if not exist %MRCMD_DIR_BIN% (
  mkdir %MRCMD_DIR_BIN%
)

echo #!/usr/bin/env bash > %MRCMD_PATH_BIN%
echo %MRCMD_PATH% "$@" >> %MRCMD_PATH_BIN%

set REG_KEY=HKCU\Environment
for /f "tokens=2*" %%a IN ('Reg.exe query "%REG_KEY%" /v Path') DO set USER_PATH=%%~b

set lastChar=%USER_PATH:~-1%

if not "%lastChar%" == ";" (
  set USER_PATH=%USER_PATH%;
)

call set _USER_PATH=%%USER_PATH:%MRCMD_DIR_BIN%;=%%

if "%USER_PATH%" == "%_USER_PATH%" (
  set USER_PATH=%USER_PATH%%MRCMD_DIR_BIN%;
  goto :success
) else (
  echo Mrcmd Tool has been updated in %MRCMD_PATH_BIN%
  goto :ok
)

:success
Reg.exe add "%REG_KEY%" /v Path /t REG_EXPAND_SZ /d "%USER_PATH%" /f
echo Mrcmd Tool has been successfully registered in %MRCMD_PATH_BIN%

:ok
rem echo See User Environment Variables:
rem echo User PATH: %USER_PATH%

pause