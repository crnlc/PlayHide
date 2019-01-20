@echo off
source .\vars.bat
.\clean-all.bat
.\build-ca.bat
.\build-key-server server
.\build-dh.bat
pause