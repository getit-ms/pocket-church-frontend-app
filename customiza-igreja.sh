#!/bin/bash

TMP_DIR=/tmp/build-igreja
CONFIG_FILE=$TMP_DIR/config.properties
ASSETS_FILE=$TMP_DIR/assets.zip

getProperty()
{
   PROP_KEY=$1
   PROP_VALUE=`cat $CONFIG_FILE | grep "$PROP_KEY" | cut -d'=' -f2`
   echo $PROP_VALUE
}

echo "=== BUILDANDO PARA IGREJA $1 VERSÃO $2 ==="

mkdir /tmp/build-igreja

echo "Baixando propriedades adicionais"

curl -H "Device-UUID:build-igreja.sh" "https://admin.getitmobilesolutions.com/api/igreja/$1/config.properties?username=gafsel@gmail.com&password=123456" --output $CONFIG_FILE || exit 1

echo "Carregando propriedades"

chaveIgreja=$(getProperty "chaveIgreja")
nomeAplicativo=$(getProperty "nomeAplicativo")
nomeIgreja=$(getProperty "nomeIgreja")
bundleAndroid=$(getProperty "bundleAndroid")
bundleIOS=$(getProperty "bundleIOS")
appleId=$(getProperty "appleId")
appleTeamId=$(getProperty "appleTeamId")
appleAppSpecificPassword=$(getProperty "appleAppSpecificPassword")

echo "Substituindo valores de arquivos do app"

sed -i  -E "s#applicationId \".+\"#applicationId \"$bundleAndroid\"#g" android/app/build.gradle || exit 1
sed -i  -E "s#package=\".+\"#package=\"$bundleAndroid\"#g" android/app/src/main/AndroidManifest.xml || exit 1
sed -i  -E "s#package=\".+\"#package=\"$bundleAndroid\"#g" android/app/src/debug/AndroidManifest.xml || exit 1
sed -i  -E "s#package=\".+\"#package=\"$bundleAndroid\"#g" android/app/src/profile/AndroidManifest.xml || exit 1
sed -i  -E "s#android:label=\".+\"#android:label=\"$nomeAplicativo\"#g" android/app/src/main/AndroidManifest.xml || exit 1

sed -i  -E "s#PRODUCT_BUNDLE_IDENTIFIER = .+;#PRODUCT_BUNDLE_IDENTIFIER = $bundleIOS;#g" ios/Runner.xcodeproj/project.pbxproj || exit 1
sed -i  -E "s#<key>CFBundleName</key>(\s+)<string>.+</string>#<key>CFBundleName</key>\1<string>$nomeAplicativo</string>#g" ios/Runner/Info.plist || exit 1
sed -i  -E "{:a;N;\$!ba;s#<key>CFBundleDisplayName</key>(\s+)<string>.+</string>#<key>CFBundleDisplayName</key>\1<string>$nomeAplicativo</string>#g}" ios/Runner/Info.plist
sed -i  -E "{:a;N;\$!ba;s#<key>CFBundleName</key>(\s+)<string>.+</string>#<key>CFBundleName</key>\1<string>$nomeAplicativo</string>#g}" ios/Runner/Info.plist
sed -i  -E "{:a;N;\$!ba;s#<key>CFBundleName</key>(\s+)<string>.+</string>#<key>CFBundleName</key>\1<string>$nomeAplicativo</string>#g}" ios/Runner/Info.plist
sed -i  -E "{:a;N;\$!ba;s#<key>CFBundleShortVersionString</key>(\s+)<string>.+</string>#<key>CFBundleShortVersionString</key>\1<string>$2</string>#g}" ios/Runner/Info.plist
sed -i  -E "{:a;N;\$!ba;s#<key>CFBundleVersion</key>(\s+)<string>.+</string>#<key>CFBundleVersion</key>\1<string>$2</string>#g}" ios/Runner/Info.plist

echo "Baixando assets"

curl -H "Device-UUID:build-igreja.sh" "https://admin.getitmobilesolutions.com/api/igreja/$1/v/$2/assets.zip?username=gafsel@gmail.com&password=123456" --output $ASSETS_FILE || exit 1

echo "Aplicando assets no projeto"

unzip -o /tmp/build-igreja/assets.zip  || exit 1

flutter pub run flutter_launcher_icons:main || exit 1

echo "Removendo diretório temporário"

rm -Rf $TMP_DIR
