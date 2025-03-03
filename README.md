# iPatch with MacOS 10.10-11.x support
GUI tool to inject dynamic libraries into IPA files

![Screenshot of the iPatch window](https://github.com/ExeRhythm/iPatch/raw/main/Screen%20Shot%202021-04-09%20at%2011.49.55.png)

## Explanation

An IPA file is a compressed version of an iOS application. You can attain IPA files online or with tools like flexdecrypt and CrackerXI+. iPatch supports injecting dynamic libraries into an app contained in an IPA file. iOS jailbreak tweaks are dynamic libraries stored in debian packages. iPatch supports injecting app jailbreak tweaks for use on jailed devices, and supports injecting substrate (using libhooker) so the tweak can load hooks.

## Usage

Download iPatch.app in [releases](https://github.com/ExeRhythm/iPatch/releases), move it to your `Applications` directory, and open the app. Insert a dylib or tweak debian package. Insert an IPA file. Modify the display name to your liking (this is the name the app will have on the Home Screen). Choose whether to inject substrate. Click `Patch` and wait.

## Compatibility

iPatch is compatible with macOS versions >=10.10.
