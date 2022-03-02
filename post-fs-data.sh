#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
    MODDIR=${0%/*}

# no longer assume $MAGISKTMP=/sbin/.magisk if Android 11 or later
    MAGISKTMP="$(magisk --path)/.magisk"

# Note: Don't use "${MAGISKTMP}/mirror/system/vendor/*" instaed of "${MAGISKTMP}/mirror/vendor/*".
# In some cases, the former may link to overlaied "/system/vendor" by Magisk itself (not mirrored original one).

# This script will be executed in post-fs-data mode
#   "full" below this line means "up to 386kHz unlock";
#    for "up to 768kHz unlock", replace "full" with "max" below this line;
#    for "up to 192kHz unlock", replace "full" with "default" below this line.

    .  "$MODDIR/functions2.sh"

    for lname in "libalsautils.so" "libalsautilsv2.so"; do
        for ld in "lib" "lib64"; do
            if [ -r "${MAGISKTMP}/mirror/vendor/${ld}/${lname}"  -a  -w "${MODDIR}/system/vendor/${ld}/${lname}" ]; then
                patchClearLock "${MAGISKTMP}/mirror/vendor/${ld}/${lname}" "${MODDIR}/system/vendor/${ld}/${lname}" "full"
            fi
        done
    done

# End of patch
