#!/bin/bash

echo "Capturando screenshots"

flutter pub global run screenshots:main -c screenshots-android.yaml || exit 1

cd android

fastlane android prints || exit 1

fastlane android release || exit 1

