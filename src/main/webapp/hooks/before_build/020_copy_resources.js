#!/usr/bin/env node

// Copy native resources
var rootdir = process.argv[2];
var exec = require('child_process').exec;

// Native resources to copy
var resources = [
    {
      from: 'resources/native/android/*',
      to: 'platforms/android/app/src/main/res/'
    },
    {
      from: 'resources/native/android/push.png',
      to: 'platforms/android/app/src/main/res/mipmap/icon.png'
    }
];

function copyAndroidResources() {
    exec('mkdir platforms/android/app/src/main/res/mipmap');

    resources.forEach(function(resource){
        exec('cp -Rf ' + resource.from + ' ' + resource.to);
    });

    process.stdout.write('Copied native resources');
}

if (rootdir) {
    copyAndroidResources();
}
