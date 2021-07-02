# Replace libalsautils.so's

# if Magisk change its mount point in the future
  MODDIR=${0%/*}

if "$IS64BIT"; then
  REPLACE="
/system/vendor/lib/libalsautils.so
/system/vendor/lib64/libalsautils.so
"
else
  REPLACE="
/system/vendor/lib/libalsautils.so
"
  rm -rf "$MODDIR/system/vendor/lib64"
fi
