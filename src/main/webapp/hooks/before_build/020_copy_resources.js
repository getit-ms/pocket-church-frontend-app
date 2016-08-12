#!/usr/bin/env node

// Copy native resources
var rootdir = process.argv[2];
var exec = require('child_process').exec;

// Native resources to copy
var resources = [
    {
        from: 'resources/native/android/drawable/',
        to: 'platforms/android/res/drawable-hdpi-v4/'
    },
    {
        from: 'resources/native/android/drawable/',
        to: 'platforms/android/res/drawable-mdpi-v4/'
    },
    {
        from: 'resources/native/android/drawable/',
        to: 'platforms/android/res/drawable-xhdpi-v4/'
    },
    {
        from: 'resources/native/android/drawable/',
        to: 'platforms/android/res/drawable-xxhdpi-v4/'
    }
];

function copyAndroidResources() {
    resources.forEach(function(resource){
        exec('cp -Rf ' + resource.from + '* ' + resource.to);
    });
    
    process.stdout.write('Copied android native resources');
}

if (rootdir) {
    copyAndroidResources();
}