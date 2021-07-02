#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
  MODDIR=${0%/*}

# no longer assume $MAGISKTMP=/sbin/.magisk if Android 11 or later
  MAGISKPATH="$(magisk --path)"
  MAGISKTMP="$MAGISKPATH/.magisk"

# This script will be executed in post-fs-data mode
#   "full" below this line means "upto 386kHz unlock";
#    for "upto 768kHz unlock", replace "full" with "max" below this line;
#    for "upto 192kHz unlock", replace "full" with "default" below this line.

  .  "$MODDIR/functions2.sh"

  if [ -r "$MAGISKTMP/mirror/system/vendor/lib/libalsautils.so" ]; then
    patchClearLock "$MAGISKTMP/mirror/system/vendor/lib/libalsautils.so" "$MODDIR/system/vendor/lib/libalsautils.so" "full"
  fi
  if [ -r "$MAGISKTMP/mirror/system/vendor/lib64/libalsautils.so" ]; then
    patchClearLock "$MAGISKTMP/mirror/system/vendor/lib64/libalsautils.so" "$MODDIR/system/vendor/lib64/libalsautils.so" "full"
  elif [ -e "$MODDIR/system/vendor/lib64" ]; then
    rm -rf "$MODDIR/system/vendor/lib64"
  fi

# End of patch
