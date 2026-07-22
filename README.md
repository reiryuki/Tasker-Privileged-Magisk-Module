# Tasker Privileged Magisk Module

## Descriptions
- Fixes some unfunctional tasks and profiles in Tasker app due to restrictions in newer Android API versions like "Set Light" task, "Settings Panel" task, "Connect to WiFi" task, "Application Services" profile, and any other else.
- Access some permissions through priv-app whitelist permissions instead of root permission so it can work faster.
- What app is this? Tap here: https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm. Tap the "About this app" there.

## Sources
- https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm
- libmagiskpolicy.so: Magisk (stable) 30.7 (30700)

## Changelog

v2.17
- Update Tasker.apk versions
- Update libmagiskpolicy.so from Magisk (stable) 30.7 (30700)
- Resets module folders/files permissions at post-fs-data
- Move _uninstall.log to /data/adb/logs/

v2.16
- Update Tasker.apk v6.4.13
- Fix permissions
- Add Action button to clear app caches
- Fix bug in uninstall.sh

v2.15
- Fix conflict with modules_update while installing via recovery if Magisk installed
- Fix selinux denial

v2.14
- Fix MagiskHide & SUList

v2.13
- Redirect /sdcard to /data/media/"$UID"
- Add optional debug.log=1 for more detailed install log
- Remove proximity sensor disabler optional (you can use the standalone module instead)
- Fix MagiskHide & SUList

v2.12
- Allow installation via Recovery if Magisk installed
- Fix "Connect to WiFi" action failure caused by selinux denials (note: the action requires location mode turned on)
- Move uninstall log to /data/media/0/..._uninstall.log

v2.11
- KernelSU support
- Cleaning protected storage
- Creates /sdcard/optionals.prop file if doesn't exist
- Fix optional permissive mode
- Fix sepolicy denials
- Using sys.boot_completed=1 detection
- Fix permissions
- Set blacklist/whitelist
- Save uninstall log to /data/adb/modules/..._uninstall.log

v2.10
- package_cache deletion
- Fix permissions
- Script enhancements
- Move dalvik cache cleaning to cleaner.sh
- Using optionals.prop instead of terminal commands for any optionals installation

v2.9
- Fix permissions
- Enable debug log

v2.8
- Add some optionals via terminal commands
- Remove hide functions

## Requirements
- Paid Tasker app installed as user app
- Magisk or Kitsune Mask or KernelSU or Apatch installed

## Installation Guide & Download Link
- If you are using KernelSU, you need to disable Unmount Modules by Default in KernelSU app settings and install https://github.com/KernelSU-Modules-Repo/meta-overlayfs or https://github.com/KernelSU-Modules-Repo/magic_mount_rs or https://github.com/KernelSU-Modules-Repo/hybrid_mount or https://github.com/maxsteeel/nomount first depending on ROM compatibility
- Install paid Tasker app first at Play Store: https://play.google.com/store/apps/details?id=net.dinglisch.android.taskerm
- Download the right module according to your device architecture and Android version:
  - Minimum SDK 27 arm64-v8a or armeabi-v7a: https://devuploads.com/eowvww6wrru8
  - Minimum SDK 21: https://devuploads.com/zuf0wvf22bqf
- Install the module via Magisk/Kitsune Mask/KernelSU/Apatch app or Recovery if Magisk/Kitsune Mask installed
- Reboot
- If you are using KernelSU, you need to allow superuser list manually all package name listed in package.txt (and your home launcher app also) (enable show system apps) and reboot afterwards
- If you are using SUList, you need to allow list manually your home launcher app (enable show system apps) and reboot afterwards

## Optionals
Global: https://t.me/ryukinotes/35

## Troubleshootings
Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/ryukinotes/54
- If you don't do above, issues will be closed immediately

## Credits and Contributors
- https://t.me/androidryukimodsdiscussions
- https://t.me/androidappsportdevelopment

## Sponsors
https://t.me/ryukinotes/25

## Other
My xml projects/tasks that can be imported to your Tasker app: https://github.com/reiryuki/Tasker-Projects-and-Tasks-XML


