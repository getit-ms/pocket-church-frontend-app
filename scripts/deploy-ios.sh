#!/bin/bash

echo "Capturando screenshots"

flutter pub global run screenshots:main -c screenshots-ios.yaml || exit 1

cd ios

fastlane ios beta || exit 1

