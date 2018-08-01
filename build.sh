#!/bin/env bash

# Make build folder
if [ -d "build" ]; then rm -r build; fi
mkdir -p build

# Build greenfor Altis
cp -r A3-Antistasi/Templates/A3-AATemplate.Altis build/A3-AATemplate.Altis
cp -r A3-Antistasi/* build/A3-AATemplate.Altis
rm -rf build/A3-AATemplate.Altis/Templates/*/

makepbo -PN build/A3-AATemplate.Altis/ build/A3-AATemplate.Altis.pbo

rm -rf build/A3-AATemplate.Altis/

# Build blufor Altis
cp -r A3-Antistasi/Templates/A3-AA-BLUFORTemplate.Altis build/A3-AA-BLUFORTemplate.Altis
cp -r A3-Antistasi/* build/A3-AA-BLUFORTemplate.Altis
rm -rf build/A3-AA-BLUFORTemplate.Altis/Templates/*/

makepbo -PN build/A3-AA-BLUFORTemplate.Altis/ build/A3-AA-BLUFORTemplate.Altis.pbo

rm -rf build/A3-AA-BLUFORTemplate.Altis/

# Build Tanoa
cp -r A3-Antistasi/Templates/A3-WotPTemplate.Tanoa build/A3-WotPTemplate.Tanoa
cp -r A3-Antistasi/* build/A3-WotPTemplate.Tanoa
rm -rf build/A3-WotPTemplate.Tanoa/Templates/*/

makepbo -PN build/A3-WotPTemplate.Tanoa/ build/A3-WotPTemplate.Tanoa.pbo

rm -rf build/A3-WotPTemplate.Tanoa/
