# Making dummies for replacing libalsautils.so's

REPLACE=""
for d in "/system/vendor/lib" "/system/vendor/lib64"; do
    for lname in "libalsautils.so" "libalsautilsv2.so"; do
        if [ -r "${d}/${lname}" ]; then
            mkdir -p "${MODPATH}${d}"
            touch "${MODPATH}${d}/${lname}"
            chmod 644 "${MODPATH}${d}/${lname}"
            chmod -R a+rX "${MODPATH}${d}"
            if [ -z "${REPLACE}" ]; then
                REPLACE="${d}/${lname}"
            else
                REPLACE="${REPLACE} ${d}/${lname}"
            fi
        fi
    done
done

function replaceSystemProps_Old()
{
    sed -i \
        -e 's/vendor\.audio\.usb\.perio=.*$/vendor\.audio\.usb\.perio=3250/' \
            "$MODPATH/system.prop"
}

function replaceSystemProps_Kona()
{
    sed -i \
        -e 's/vendor\.audio\.usb\.perio=.*$/vendor\.audio\.usb\.perio=20375/' \
            "$MODPATH/system.prop"
}

function replaceSystemProps_SDM()
{
    sed -i \
        -e 's/vendor\.audio\.usb\.perio=.*$/vendor\.audio\.usb\.perio=2625/' \
            "$MODPATH/system.prop"
}

function replaceSystemProps_MTK_Dimensity()
{
    sed -i \
        -e '$avendor.audio.usb.out.period_us=3250\nvendor.audio.usb.out.period_count=2' \
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
        "kona" )
            replaceSystemProps_Kona
            enableMaxFrequency
            ;;
        "sdm660" | "sdm845" )
            replaceSystemProps_SDM
            enableMaxFrequency
            ;;
        mt68* )
            if [ -r "/vendor/lib64/hw/audio.usb.${board}.so" ]; then
                replaceSystemProps_MTK_Dimensity
            fi
            ;;
        mt67[56]* )
            replaceSystemProps_Old
            ;;
    esac
else
    replaceSystemProps_Old
fi
