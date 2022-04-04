# file
magiskpolicy --live "dontaudit system_server { sdcardfs vfat fuse } file { read write getattr }"
magiskpolicy --live "allow     system_server { sdcardfs vfat fuse } file { read write getattr }"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { sysfs_leds vendor_file } file { read getattr }"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { sysfs_leds vendor_file } file { read getattr }"
magiskpolicy --live "dontaudit magisk_client vendor_file file { read getattr }"
magiskpolicy --live "allow     magisk_client vendor_file file { read getattr }"

# dir
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { sysfs_leds sysfs rootfs } dir { read open }"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { sysfs_leds sysfs rootfs } dir { read open }"
magiskpolicy --live "dontaudit magisk_client { vendor_file system_data_file } dir read"
magiskpolicy --live "allow     magisk_client { vendor_file system_data_file } dir read"


