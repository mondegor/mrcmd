@echo off
rem https://www.tutorialspoint.com/batch_script/
rem https://ss64.com/nt/syntax-substring.html

SET regKey=HKCU\Environment
FOR /f "tokens=2*" %%a IN ('Reg.exe query "%regKey%" /v Path') DO SET userPath=%%~b

SET lastChar=%userPath:~-1%

IF not "%lastChar%" == ";" (
  SET userPath=%userPath%;
)

SET toolDir=%cd%
CALL SET _userPath=%%userPath:%toolDir%=%%

IF "%userPath%" == "%_userPath%" (
  SET userPath=%userPath%%toolDir%;
  Reg.exe add "%regKey%" /v Path /t REG_EXPAND_SZ /d "%userPath%" /f
  echo The tool successfully registered
) else (
  echo The tool already registered
)

echo See User Environment Variables:
echo User PATH: %userPath%

pause