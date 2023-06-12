#

# no longer assume $MAGISKTMP=/sbin/.magisk if Android 11 or later
    MAGISKTMP="$(magisk --path)/.magisk"

# Note: Don't use "${MAGISKTMP}/mirror/system/vendor/*" instaed of "${MAGISKTMP}/mirror/vendor/*".
# In some cases, the former may link to overlaied "/system/vendor" by Magisk itself (not mirrored original one).

# Making dummies for replacing libalsautils.so's and audio_usb_aoc.so's

REPLACE=""
for d in "/system/vendor/lib" "/system/vendor/lib64"; do
    for lname in "libalsautils.so" "libalsautilsv2.so" "audio_usb_aoc.so"; do
        if [ -r "${d}/${lname}" ]; then
            mkdir -p "${MODPATH}${d}"
            touch "${MODPATH}${d}/${lname}"
            chmod 644 "${MODPATH}${d}/${lname}"
            chcon u:object_r:vendor_file:s0 "${MODPATH}${d}/${lname}"
            chown root:root "${MODPATH}${d}/${lname}"
            chmod -R a+rX "${MODPATH}${d}"
            if [ -z "${REPLACE}" ]; then
                REPLACE="${d}/${lname}"
            else
                REPLACE="${REPLACE} ${d}/${lname}"
            fi
        fi
    done
done

fname="/system/vendor/etc/audio_platform_configuration.xml"
if [ -r "$fname" ]; then
    mkdir -p "${MODPATH}${fname%/*}"
    sed -e 's/min_rate="[1-9][0-9]*"/min_rate="44100"/g' \
        -e 's/"MaxSamplingRate=[1-9][0-9]*,/"MaxSamplingRate=192000,/' <"${MAGISKTMP}/mirror${fname#/system}" >"${MODPATH}${fname}"
    touch "${MODPATH}${fname}"
    chmod 644 "${MODPATH}${fname}"
    chcon u:object_r:vendor_file:s0 "${MODPATH}${fname}"
    chown root:root "${MODPATH}${fname}"
    chmod -R a+rX "${MODPATH}${fname}"
    if [ -z "${REPLACE}" ]; then
        REPLACE="${fname}"
    else
        REPLACE="${REPLACE} ${fname}"
    fi
fi

function replaceSystemProps_Old()
{
    sed -i \
        -e 's/vendor\.audio\.usb\.perio=.*$/vendor\.audio\.usb\.perio=3875/' \
        -e 's/vendor\.audio\.usb\.out\.period_us=.*$/vendor\.audio\.usb\.out\.period_us=3875/' \
            "$MODPATH/system.prop"
}

function replaceSystemProps_Kona()
{
    if [ "`getprop ro.vendor.build.version.release_or_codename`" -ge "12" ]; then
        sed -i \
            -e 's/vendor\.audio\.usb\.perio=.*$/vendor\.audio\.usb\.perio=3500/' \
            -e 's/vendor\.audio\.usb\.out\.period_us=.*$/vendor\.audio\.usb\.out\.period_us=3500/' \
                "$MODPATH/system.prop"
    else
        sed -i \
            -e 's/vendor\.audio\.usb\.perio=.*$/vendor\.audio\.usb\.perio=20375/' \
            -e 's/vendor\.audio\.usb\.out\.period_us=.*$/vendor\.audio\.usb\.out\.period_us=20375/' \
                "$MODPATH/system.prop"
    fi
}

function replaceSystemProps_SDM845()
{
    sed -i \
        -e 's/vendor\.audio\.usb\.perio=.*$/vendor\.audio\.usb\.perio=2500/' \
        -e 's/vendor\.audio\.usb\.out\.period_us=.*$/vendor\.audio\.usb\.out\.period_us=2500/' \
            "$MODPATH/system.prop"
}

function replaceSystemProps_SDM()
{
    sed -i \
        -e 's/vendor\.audio\.usb\.perio=.*$/vendor\.audio\.usb\.perio=2500/' \
        -e 's/vendor\.audio\.usb\.out\.period_us=.*$/vendor\.audio\.usb\.out\.period_us=2500/' \
            "$MODPATH/system.prop"
}

function replaceSystemProps_MTK_Dimensity()
{
    sed -i \
        -e 's/vendor\.audio\.usb\.perio=.*$/vendor\.audio\.usb\.perio=2500/' \
        -e 's/vendor\.audio\.usb\.out\.period_us=.*$/vendor\.audio\.usb\.out\.period_us=2500/' \
            "$MODPATH/system.prop"
}

function unlocking_notice()
{
    ui_print ""
    ui_print "********************************************"
    ui_print " Up to 768kHz unlocking will be applied! "
    ui_print "   (a known safe device was detected) "
    ui_print "********************************************"
    ui_print ""
}

function enableMaxFrequency()
{
    sed -i \
        -e 's/"full"$/"max"/' \
            "$MODPATH/post-fs-data.sh"
            
    unlocking_notice
}

if "$IS64BIT"; then
    local board="`getprop ro.board.platform`"
    case "$board" in
        "kona" | "kalama" | "shima" | "yupik" )
            replaceSystemProps_Kona
            enableMaxFrequency
            ;;
        "sdm845" | gs* )
            replaceSystemProps_SDM845
            enableMaxFrequency
            ;;
        "sdm660" | "bengal" | "holi" )
            replaceSystemProps_SDM
            enableMaxFrequency
            ;;
        mt68* )
            if [ -r "/vendor/lib64/hw/audio.usb.${board}.so" ]; then
                replaceSystemProps_MTK_Dimensity
            elif [ "`getprop ro.vendor.build.version.release`" -ge "12"  -o  "`getprop ro.vendor.build.version.release_or_codename`" -ge "12" ]; then
                # Latest MTK kernels are capable of the 768kHz 32bit mode output, and set to be a hardware offload tunneling mode as default
                replaceSystemProps_MTK_Dimensity
                enableMaxFrequency
            fi
            ;;
        mt67[56]* )
            replaceSystemProps_Old
            ;;
    esac
else
    replaceSystemProps_Old
fi
