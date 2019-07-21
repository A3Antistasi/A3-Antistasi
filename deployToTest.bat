::@ECHO OFF
rem Very useful with https://marketplace.visualstudio.com/items?itemName=wk-j.save-and-run

:: template switches (0 OR 1)
::	0 - A3-AA-BLUFORTemplate.Altis
::	1 - A3-AATemplate.Altis
::	2 - A3-ArmiaKrajowaTemplate.chernarus_summer
::	3 - A3-WotPTemplate.Tanoa

setlocal enabledelayedexpansion 
set tempList[0].name="A3-AA-BLUFORTemplate"
set tempList[0].map="Altis"
set tempList[1].name="A3-AATemplate"
set tempList[1].map="Altis"
set tempList[2].name="A3-ArmiaKrajowaTemplate"
set tempList[2].map="chernarus_summer"
set tempList[3].name="A3-WotPTemplate"
set tempList[3].map="Tanoa"

for /f "delims=," %%a in (.\template.selected.cfg) do set arma3ProfileName=%%a & set template[0]=%%b & set template[1]=%%c & set template[2]=%%d & set template[3]=%%e

echo %arma3ProfileName%":"

set source = ".\A3-Antistasi"
set mpMissions = "%USERPROFILE%\Documents\Arma 3 - Other Profiles\%arma3ProfileName%\mpmissions\A3-Antistasi.%"

for /l %%x in (0, 1, 3) do (
	IF %template[%%x]%=="1" 
	(
		echo !tempList[%%x].name!"."!tempList[%%bx].map!
		set destination=!mpMissions!!tempList[%%x].map!

		xcopy %source% %destination% /s /d /i /y /exclude:tempList.files.cfg > Antistasi.xcopy.log
		xcopy %source%"\Templates\"!tempList[%%x]!"."name%"."%tempList[%%x].map% %destination% /s /d /i /y > AntistasiTemplate.xcopy.log

	)
)


SET interactive=1
ECHO %CMDCMDLINE% | FIND /I "/c" >NUL 2>&1
IF %ERRORLEVEL% == 0 SET interactive=0

IF "%interactive%"=="0" PAUSE
EXIT /B 0