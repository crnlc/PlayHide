@echo off
taskkill /im PlayHide.exe
bin32\7z.exe x .\PlayHide.7z -y
del .\PlayHide.7z
del .\PlayHide-Installer.exe
start .\PlayHide.exe