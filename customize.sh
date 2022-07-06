ui_print " "

# magisk
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`find /dev -mindepth 2 -maxdepth 2 -type d -name .magisk`
fi

# optionals
OPTIONALS=/sdcard/optionals.prop

# boot mode
if [ "$BOOTMODE" != true ]; then
  abort "- Please flash via Magisk Manager only!"
fi

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
ui_print " MagiskVersion=$MAGISK_VER"
ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
ui_print " "

# sdk
NUM=21
if [ "$API" -lt $NUM ]; then
  ui_print "! Unsupported SDK $API."
  ui_print "  You have to upgrade your Android version"
  ui_print "  at least SDK API $NUM to use this module."
  abort
else
  ui_print "- SDK $API"
  ui_print " "
fi

# sepolicy.rule
if [ "$BOOTMODE" != true ]; then
  mount -o rw -t auto /dev/block/bootdevice/by-name/persist /persist
  mount -o rw -t auto /dev/block/bootdevice/by-name/metadata /metadata
fi
FILE=$MODPATH/sepolicy.sh
DES=$MODPATH/sepolicy.rule
if [ -f $FILE ] && [ "`grep_prop sepolicy.sh $OPTIONALS`" != 1 ]; then
  mv -f $FILE $DES
  sed -i 's/magiskpolicy --live "//g' $DES
  sed -i 's/"//g' $DES
fi

# cleaning
ui_print "- Cleaning..."
rm -rf /metadata/magisk/$MODID
rm -rf /mnt/vendor/persist/magisk/$MODID
rm -rf /persist/magisk/$MODID
rm -rf /data/unencrypted/magisk/$MODID
rm -rf /cache/magisk/$MODID
ui_print " "

# function
permissive() {
  SELINUX=`getenforce`
  if [ "$SELINUX" == Enforcing ]; then
    setenforce 0
    SELINUX=`getenforce`
    if [ "$SELINUX" == Enforcing ]; then
      ui_print "  ! Your device can't be turned to Permissive state."
    fi
    setenforce 1
  fi
  sed -i '1i\
SELINUX=`getenforce`\
if [ "$SELINUX" == Enforcing ]; then\
  setenforce 0\
fi\' $MODPATH/post-fs-data.sh
}

# permissive
if [ "`grep_prop permissive.mode $OPTIONALS`" == 1 ]; then
  ui_print "- Using permissive method"
  rm -f $MODPATH/sepolicy.rule
  permissive
  ui_print " "
fi

# oat/odex
APP=Tasker
PKG=net.dinglisch.android.taskerm
CURRENT=`pm list packages --show-versioncode | grep $PKG | sed -n -e "s/package:$PKG versionCode://p"`
NEW=5312
DIR=/system/priv-app/$APP
ui_print "- Current versionCode: $CURRENT"
ui_print "  New versionCode: $NEW"
ui_print " "
if [ "$CURRENT" == "$NEW" ]; then
  if [ -d $DIR/oat ]; then
    ui_print "- Copying oat..."
    cp -rf $DIR/oat $MODPATH/$DIR
    ui_print " "
  elif [ -d $DIR/odex ]; then
    ui_print "- Copying odex..."
    cp -rf $DIR/odex $MODPATH/$DIR
    ui_print " "
  elif [ -f $DIR/$APP.odex ]; then
    ui_print "- Copying odex..."
    cp -f $DIR/$APP.odex $MODPATH/$DIR
    ui_print " "
  fi
fi

# power save
FILE=$MODPATH/system/etc/sysconfig/*
if [ "`grep_prop power.save $OPTIONALS`" == 1 ]; then
  ui_print "- $MODNAME will not be allowed in power save."
  ui_print "  It may save your battery but decreasing $MODNAME performance."
  for PKGS in $PKG; do
    sed -i "s/<allow-in-power-save package=\"$PKGS\"\/>//g" $FILE
    sed -i "s/<allow-in-power-save package=\"$PKGS\" \/>//g" $FILE
  done
  ui_print " "
fi

# install
FILE=$MODPATH/system/priv-app/$APP/$APP.apk
if [ "$CURRENT" -lt "$NEW" ] || [ ! $CURRENT ]; then
  ui_print "- Installing Tasker as a user app and granting all"
  ui_print "  runtime permissions..."
  ui_print "  This will keep the app installed even you disable"
  ui_print "  or uninstall the module."
  pm install -g -i com.android.vending $FILE
  ui_print " "
fi

# sensor
if [ "`grep_prop disable.proximity $OPTIONALS`" == 1 ]; then
  ui_print "- Proximity sensor will be disabled"
  sed -i 's/#p//g' $MODPATH/system.prop
  ui_print " "
fi




