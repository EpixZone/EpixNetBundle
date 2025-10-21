cd /d "%~dp0"

@echo * Compiling...
py -3 -m PyInstaller script/pyinstaller_win.spec -y

@echo * Installing binary dependencies to dist/EpixNet/lib...
py -3 -m pip download -d .pip-cache gevent msgpack coincurve greenlet
py -3 -m pip install --no-deps --target=dist/EpixNet/lib --no-index --find-links=.pip-cache gevent msgpack coincurve greenlet

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
@echo * Adding platform dependent dist utils (OS: %OS%)

@mkdir dist\EpixNet\core
@mkdir dist\EpixNet\core\tools
@if %OS% == 32BIT xcopy /E tools_win32 dist\EpixNet\core\tools
@if %OS% == 64BIT xcopy /E tools_win64 dist\EpixNet\core\tools

@echo * Cleanup working dir...
rmdir /s /q build
del *.pkg
cd dist\
rmdir lib

@echo * Move pyd/dll files to lib...
cd EpixNet
move *.pyd lib
move lib*.dll lib
move sqlite3.dll lib

@echo * Move cli binary to lib...
del EpixNet-cli.pkg
move EpixNet-cli.exe lib\EpixNet-cli.dat
copy ..\..\script\EpixNet.cmd lib\EpixNet.cmd

@echo * Cleanup dist/EpixNet...
rmdir /s /q Include
del /s *.pyc
del *.manifest

@echo * Cleanup dist/EpixNet/lib...
cd lib
del /s *.c
del /s *.h
del /s *.html
del /s *.pxd
del /s *.pyx
rmdir /s /q include
for /d %%G in ("*dist-info") do rd /s /q "%%~G"
rmdir /s /q gevent\tests
rmdir /s /q gevent\testing

@echo * Back to initial dir...
cd /d "%~dp0"