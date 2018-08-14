#!/bin/bash

PLIST=platforms/ios/*/*-Info.plist

cat << EOF |
Delete :NSCalendarsUsageDescription
Add :NSCalendarsUsageDescription string "Gravar eventos da IPB na agenda do celular"
EOF
while read line
do
  /usr/libexec/PlistBuddy -c "$line" $PLIST
done

true
