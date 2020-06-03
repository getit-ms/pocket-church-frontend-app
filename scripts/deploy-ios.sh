#!/bin/bash

echo "Capturando screenshots"

flutter pub global run screenshots:main -c screenshots-ios.yaml || exit 1

fastlane ios beta

