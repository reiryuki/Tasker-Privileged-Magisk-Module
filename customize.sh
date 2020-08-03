# check android
if [ "$API" -lt 27 ]; then
  ui_print "- ! Unsupported sdk: $API"
  abort "- You have to upgrade your Android version at least Oreo sdk API 27 to use this module!"
else
  ui_print "- Device sdk: $API"
fi

# remove unused file
rm -f $MODPATH/LICENSE

# check selinux
ui_print "- Checking SE Linux state"
SELINUX=$(getenforce)
ui_print "- SE Linux is $SELINUX"
if [ "$SELINUX" == Permissive ]; then
  ui_print "- Deleting service.sh file"
  rm -f $MODPATH/service.sh
fi
