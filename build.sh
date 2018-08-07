#!/bin/env bash

# Make build folder
if [ -d "build" ]; then rm -r build; fi
mkdir -p build

# Define variant template folders
variants=( A3-AATemplate.Altis A3-AA-BLUFORTemplate.Altis A3-WotPTemplate.Tanoa )

# Build each template
for variant in "${variants[@]}"
do
    cp -r A3-Antistasi/Templates/$variant build/$variant
    cp -r A3-Antistasi/* build/$variant
    rm -rf build/$variant/Templates/*/

    makepbo -PN build/$variant/ build/$variant.pbo

    rm -rf build/$variant/
done
