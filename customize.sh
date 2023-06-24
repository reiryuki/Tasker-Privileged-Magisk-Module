# boot mode
if [ "$BOOTMODE" != true ]; then
  abort "- Please flash via Magisk app only!"
fi

# space
ui_print " "

# log
if [ "$BOOTMODE" != true ]; then
  FILE=/sdcard/$MODID\_recovery.log
  ui_print "- Log will be saved at $FILE"
  exec 2>$FILE
  ui_print " "
fi

# run
. $MODPATH/function.sh

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
if [ "$KSU" == true ]; then
  ui_print " KSUVersion=$KSU_VER"
  ui_print " KSUVersionCode=$KSU_VER_CODE"
  ui_print " KSUKernelVersionCode=$KSU_KERNEL_VER_CODE"
  sed -i 's|#k||g' $MODPATH/post-fs-data.sh
else
  ui_print " MagiskVersion=$MAGISK_VER"
  ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
fi
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

# optionals
OPTIONALS=/sdcard/optionals.prop
if [ ! -f $OPTIONALS ]; then
  touch $OPTIONALS
fi

# sepolicy
FILE=$MODPATH/sepolicy.rule
DES=$MODPATH/sepolicy.pfsd
if [ "`grep_prop sepolicy.sh $OPTIONALS`" == 1 ]\
&& [ -f $FILE ]; then
  mv -f $FILE $DES
fi

# cleaning
ui_print "- Cleaning..."
remove_sepolicy_rule
ui_print " "

# function
permissive_2() {
sed -i 's|#2||g' $MODPATH/post-fs-data.sh
}
permissive() {
FILE=/sys/fs/selinux/enforce
SELINUX=`cat $FILE`
if [ "$SELINUX" == 1 ]; then
  if ! setenforce 0; then
    echo 0 > $FILE
  fi
  SELINUX=`cat $FILE`
  if [ "$SELINUX" == 1 ]; then
    ui_print "  Your device can't be turned to Permissive state."
    ui_print "  Using Magisk Permissive mode instead."
    permissive_2
  else
    if ! setenforce 1; then
      echo 1 > $FILE
    fi
    sed -i 's|#1||g' $MODPATH/post-fs-data.sh
  fi
else
  sed -i 's|#1||g' $MODPATH/post-fs-data.sh
fi
}

# permissive
if [ "`grep_prop permissive.mode $OPTIONALS`" == 1 ]; then
  ui_print "- Using device Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive
  ui_print " "
elif [ "`grep_prop permissive.mode $OPTIONALS`" == 2 ]; then
  ui_print "- Using Magisk Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive_2
  ui_print " "
fi

# oat/odex
APP=Tasker
PKG=net.dinglisch.android.taskerm
CURRENT=`pm list packages --show-versioncode | grep $PKG | sed "s/package:$PKG versionCode://"`
NEW=5312
DIR=`find /data/adb/modules/"$MODID"/system -type d -name "$APP"`
ui_print "- Current app versionCode: $CURRENT"
ui_print "  New app versionCode: $NEW"
if [ "$CURRENT" == "$NEW" ]; then
  if [ -f $DIR/oat/$APP.odex ]; then
    ui_print "  Copying oat..."
    cp -rf $DIR/oat $MODPATH/$DIR
  elif [ -f $DIR/odex/$APP.odex ]; then
    ui_print "  Copying odex..."
    cp -rf $DIR/odex $MODPATH/$DIR
  elif [ -f $DIR/$APP.odex ]; then
    ui_print "  Copying odex..."
    cp -f $DIR/$APP.odex $MODPATH/$DIR
  fi
fi
ui_print " "
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
FILE=`find $MODPATH/system -type f -name $APP.apk`
if [ "$CURRENT" -lt "$NEW" ] || [ ! "$CURRENT" ]; then
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











