@echo off
cd /d "%~dp0"
copy /Y EpixNet-cli.dat ..\EpixNet-cli.exe >NUL
copy /Y ..\EpixNet.pkg ..\EpixNet-cli.pkg >NUL
..\EpixNet-cli.exe  --open_browser False %*
