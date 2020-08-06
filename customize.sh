# check android
if [ "$API" -lt 21 ]; then
  abort "- ! Unsupported sdk: $API. You have to upgrade your Android version at least ICS sdk API 21 to use this module!"
else
  ui_print "- Device sdk: $API"
fi

# remove unused file
rm -f $MODPATH/LICENSE

# check files
SELINUX=$(getenforce)
ui_print "- SE Linux is $SELINUX"
PRIV=$(getprop ro.control_privapp_permissions)
ui_print "- ro.control_privapp_permissions=$PRIV"
TEST=$MODPATH/test
echo $MODPATH > $TEST
MODPATHM=$(sed 's/_update//g' $TEST)
rm -f $TEST
if [ ! -e "$MODPATHM/service.sh" ]; then
  if [ "$SELINUX" != "Enforcing" ]; then
    rm -f $MODPATH/service.sh
  fi
fi
if [ ! -e "$MODPATHM/system.prop" ]; then
  if [ "$PRIV" == "enforce" ] || [ "$PRIV" == "log" ]; then
    rm -f $MODPATH/system.prop
  fi
fi

