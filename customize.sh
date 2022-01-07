# Replace libalsautils.so's

if "$IS64BIT"; then
  REPLACE="
/system/vendor/lib/libalsautils.so
/system/vendor/lib64/libalsautils.so
"
else
  REPLACE="
/system/vendor/lib/libalsautils.so
"
  rm -rf "$MODPATH/system/vendor/lib64"
fi
