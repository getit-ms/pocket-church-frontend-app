#!/usr/bin/env node

// Copy native resources
var rootdir = process.argv[2];
var exec = require('child_process').exec;

// Native resources to copy
var resources = [
    {
      from: 'resources/native/ios/icon.png',
      to: 'platforms/ios/${nomeAplicativo.igreja}/Images.xcassets/AppIcon.appiconset/icon-1024.png'
    }
];

function copyAndroidResources() {
    resources.forEach(function(resource){
        exec('cp -Rf ' + resource.from + ' ' + resource.to);
    });

    process.stdout.write('Copied native resources');
}

if (rootdir) {
    copyAndroidResources();
}
