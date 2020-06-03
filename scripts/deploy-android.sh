#!/bin/bash

echo "Capturando screenshots"

flutter pub global run screenshots:main -c screenshots-android.yaml || exit 1

fastlane android beta

