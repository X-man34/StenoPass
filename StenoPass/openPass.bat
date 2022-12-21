set password=thisisapassword
set protectedfile=file.txt
java -jar openstego.jar extract --stegofile "output.bmp" --password %password%
if %ERRORLEVEL% NEQ 0 (echo failure) else (echo success)
start /W %protectedFile%
java -jar openstego.jar embed --messagefile "%protectedFile%" --coverfile cover.jpg --stegofile "output.bmp" --encrypt --password %password%
del "%protectedFile%"