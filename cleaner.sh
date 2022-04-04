PKG=net.dinglisch.android.taskerm
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS/cache/*
done



