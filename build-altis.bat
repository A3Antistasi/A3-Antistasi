@echo off
cd /d "%~dp0"
del Antistasi.Altis.pbo
mkdir "Antistasi.Altis"
xcopy "A3-Antistasi\*.*" "Antistasi.Altis" /E/Y
xcopy "A3-Antistasi\Templates\A3-AATemplate.Altis\*.*" "Antistasi.Altis" /E/Y
rmdir "Antistasi.Altis\Templates\A3-AATemplate.Altis" /S/Q
rmdir "Antistasi.Altis\Templates\A3-AA-BLUFORTemplate.Altis" /S/Q
rmdir "Antistasi.Altis\Templates\A3-ArmiaKrajowaTemplate.chernarus_summer" /S/Q
rmdir "Antistasi.Altis\Templates\A3-WotPTemplate.Tanoa" /S/Q
tools\armake_w64.exe build Antistasi.Altis Antistasi.Altis.pbo
rmdir "Antistasi.Altis" /S/Q
