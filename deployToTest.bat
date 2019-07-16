rem Very useful with https://marketplace.visualstudio.com/items?itemName=wk-j.save-and-run

for /f "delims=. tokens=1" %%x in (.\template.selected.cfg) do set arma3ProfileName=%%x
for /f "delims=. tokens=2" %%x in (.\template.selected.cfg) do set template=%%x
for /f "delims=. tokens=3" %%x in (.\template.selected.cfg) do set map=%%x
echo %arma3ProfileName%
echo %template%
echo %map%

set source=".\A3-Antistasi"
set destination="C:\Users\%USERNAME%\Documents\Arma 3 - Other Profiles\%arma3ProfileName%\mpmissions\A3-Antistasi.%map%"

xcopy %source% %destination% /s /d /i /y /exclude:template.files.cfg > Antistasi.xcopy.log

xcopy %source%"\Templates\%template%.%map%" %destination% /s /d /i /y > AntistasiTemplate.xcopy.log