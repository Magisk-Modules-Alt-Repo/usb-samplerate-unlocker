#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script and module are placed.
# This will make sure your module will still work if Magisk changes its mount point in the future

MODDIR=${0%/*}
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
    
    for lname in "audio_usb_aoc.so"; do
        for ld in "lib" "lib64"; do
            if [ -r "${MAGISKTMP}/mirror/vendor/${ld}/${lname}"  -a  -w "${MODDIR}/system/vendor/${ld}/${lname}" ]; then
                patchClearTensorOffloadLock "${MAGISKTMP}/mirror/vendor/${ld}/${lname}" "${MODDIR}/system/vendor/${ld}/${lname}"
            fi
        done
    done

# End of patch
