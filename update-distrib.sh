#!/bin/bash

( cd src && RELEASE=1 ./make.sh )

pushd distrib
rm -rf bin compiler doc lexgen srlib srmake
cp -R ../build/{compiler,lexgen,srmake,srlib-rich-prefix} .
mkdir bin
cp ../src/scripts/srefc.bat bin
cp ../src/scripts/srefc.sh bin/srefc
cp ../src/scripts/srmake.bat bin
cp ../src/scripts/srmake.sh bin/srmake
cp ../src/scripts/platform-specific.sh bin
mkdir srlib
cp -R ../srlib/scratch srlib/scratch
mkdir srlib/rich
cp ../srlib/rich/*.{rasl,froms} srlib/rich
cp -R ../srlib/common srlib/common
mkdir doc
cp -R ../doc/examples doc/examples
cp ../doc/*.pdf doc
cp ../doc/*.jpg doc
mkdir doc/OptPattern
cp ../doc/OptPattern/*.pdf doc/OptPattern
mkdir doc/historical
cp ../doc/historical/*.txt doc/historical
cp ../doc/historical/*.pdf doc/historical
cp ../doc/historical/*.jpg doc/historical
cp ../doc/historical/*.doc doc/historical
mkdir doc/historical/Дрогунов
cp ../doc/historical/Дрогунов/*.pdf doc/historical/Дрогунов
cp ../LICENSE .
cp ../README.md .
mkdir editors
cp -R ../editors editors
./bootstrap.sh
popd
