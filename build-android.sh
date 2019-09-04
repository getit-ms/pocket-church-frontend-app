#!/bin/bash

d1=$(echo $2 | cut -d'.' -f1)
d2=$(echo $2 | cut -d'.' -f2)
d3=$(echo $2 | cut -d'.' -f3)

BUILD_NUMBER=$(printf "%d%02d%02d" $d1 $d2 $d3) || exit 1

echo "Construindo AppBundle $BUILD_NUMBER"

flutter build appbundle --build-number=$BUILD_NUMBER --build-name=$2 || exit

bundle install || exit

bundle exec fastlane android beta || exit