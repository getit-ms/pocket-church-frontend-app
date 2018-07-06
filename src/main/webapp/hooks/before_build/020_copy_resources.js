#!/usr/bin/env node

// Copy native resources
var rootdir = process.argv[2];
var exec = require('child_process').exec;

// Native resources to copy
var resources = [
    {
      from: 'resources/native/android/*',
      to: 'platforms/android/res/'
    },
    {
      from: 'resources/splash.png',
      to: 'platforms/ios/${nomeAplicativo.igreja}/Images.xcassets/LaunchStoryboard.imageset/Default@2x~universal~anyany.png'
    }
];

function copyAndroidResources() {
    resources.forEach(function(resource){
        exec('cp -Rf ' + rootdir + resource.from + ' ' + rootdir + resource.to);
    });

    process.stdout.write('Copied native resources');
}

if (rootdir) {
    copyAndroidResources();
}
