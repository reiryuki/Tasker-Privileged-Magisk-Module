# check android
if [ "$API" -lt 27 ]; then
  abort "- ! Unsupported sdk: $API. You have to upgrade your Android version at least Oreo sdk API 27 to use this module!"
else
  ui_print "- Device sdk: $API"
fi

# remove unused file
rm -f $MODPATH/LICENSE

# check files
SELINUX=$(getenforce)
ui_print "- SE Linux is $SELINUX"
TEST=$MODPATH/test
echo $MODPATH > $TEST
MODPATHM=$(sed 's/_update//g' $TEST)
rm -f $TEST
if [ ! -e "$MODPATHM/service.sh" ]; then
  if [ "$SELINUX" != "Enforcing" ]; then
    rm -f $MODPATH/service.sh
  else
    ui_print "- Will change to Permissive"
  fi
fi

