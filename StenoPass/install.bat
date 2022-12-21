@echo off
rem get nessacary input from user
call :getInput
cls
echo installing...

rem get actual pf file name file name is put in global variable pf
echo retrieving file...
call :getlasttoken %pfPath% \

rem move protectedFile to working directory
copy %pfPath% "%~dp0"

rem put username and protectedFileName in batch file
echo editing batch file...
call :editbatchfile

rem create output.bmp
echo encrypting...
java -jar openstego.jar embed --messagefile "%pf%" --coverfile cover.jpg --stegofile "output.bmp" --encrypt --password %password%

rem delete protectedFile from stenoPass directory
del "%~dp0"\%pf%

rem create exe
Bat_To_Exe_Converter_x64.exe /bat openStego.bat /exe OpenStego.exe /icon stegoPassIcon.ico /password %password% /invisible

rem openStego.bat becuase it has the passwords. 
del openStego.bat

rem cd..
rem move "StenoPass" "C:\Users\Caleb\defaultfolders\Documents\StenoPassProject\targetDir"

echo:
echo finished installing
echo make sure to delete original protected file becuase if you don't, this entire app is useless :)
echo you also need to make a shortcut for OpenStego.exe.  You can do that by right clicking on it
echo and clicking create shortcut.  You will then have to move the shortcut to the desktop. 
echo you may also want to consider moving the StenoPass folder to somewhere else on your computer. 
echo you should create the shortcut last because if you make the shortcut and then move the files, the shorrtcut breaks. 
echo in case you forgot, your password is: %password%
pause
exit


rem==================================================subrotines

:editbatchfile
setlocal
call :findreplace thisisapassword %password% openPass.bat Target.bat
call :findreplace file.txt %pf% Target.bat openStego.bat
rem del openPass.bat
del Target.bat
endlocal
exit /b

rem ======================



:findreplace
@echo off
set "replace=%1"
set "replaced=%2"

set "source=%3"
set "target=%4"

setlocal enableDelayedExpansion
(
   for /F "tokens=1* delims=:" %%a in ('findstr /N "^" %source%') do (
      set "line=%%b"
      if defined line set "line=!line:%replace%=%replaced%!"
      echo(!line!
   )
) > %target%
endlocal
exit /b

rem =========================
:getInput
:dataentry
set /p password=Enter a super-memorable password WITHOUT SPACES OR SPECIAL CHARACTERS: 
:fileentry
set /p pfPath=Enter the complete file location of the file you wish to protect: 
IF NOT EXIST %pfPath% (goto noFile) ELSE (goto file)

:noFile
cls
Echo File does not exist
goto fileentry

:file
cls
echo Password: %password%
echo FilePath: %pfPath%
choice /n /m "Are these settings correct? (y/n)"
goto %ERRORLEVEL%
:2
cls
goto dataEntry
:1
exit /b

rem ==================
:getlasttoken
setlocal
set var1=%1
set var2=%var1%
set i=0
:loopprocess
for /F "tokens=1* delims=%2" %%A in ( "%var1%" ) do (
  set /A i+=1
  set var1=%%B
  goto loopprocess )

for /F "tokens=%i% delims=%2" %%G in ( "%var2%" ) do set temp=%%G
endlocal & set pf=%temp%
exit /b
rem===============