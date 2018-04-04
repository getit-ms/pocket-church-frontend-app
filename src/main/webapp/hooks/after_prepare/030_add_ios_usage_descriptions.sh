#!/bin/bash

PLIST=platforms/ios/*/*-Info.plist

cat << EOF |
Delete :NSPhotoLibraryUsageDescription
Add :NSPhotoLibraryUsageDescription string "Acessa a galeria para alterar foto do membro logado"
Delete :NSCameraUsageDescription
Add :NSCameraUsageDescription string "Acesso a camera para alterar foto do membro logado"
Delete :NSPhotoLibraryAddUsageDescription
Add :NSPhotoLibraryAddUsageDescription string "Acessa a galeria para alterar foto do membro logado"
EOF
while read line
do
  /usr/libexec/PlistBuddy -c "$line" $PLIST
done

true
