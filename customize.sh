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
        -e 's/ro\.audio\.usb\.period_us=.*$/ro\.audio\.usb\.period_us=3875/' \
            "$MODPATH/system.prop"
}

function replaceSystemProps_Kona()
{
    sed -i \
        -e 's/ro\.audio\.usb\.period_us=.*$/ro\.audio\.usb\.period_us=20375/' \
            "$MODPATH/system.prop"
}

function replaceSystemProps_MTK_some()
{
    sed -i \
        -e 's/ro\.audio\.usb\.period_us=.*$/ro\.audio\.usb\.period_us=875/' \
            "$MODPATH/system.prop"
}

function unlocking_notice()
{
    ui_print ""
    ui_print "********************************************"
    ui_print " Up to 768kHz unlocking will be applied! "
    ui_print "   (a known safe device is detected) "
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
    case "`getprop ro.board.platform`" in
        "kona" )
            replaceSystemProps_Kona
            enableMaxFrequency
            ;;
        "sdm660" | "sdm845" )
            enableMaxFrequency
            ;;
        mt68* )
            if [ "`getprop ro.vendor.build.version.release`" -ge "11" ]; then
                replaceSystemProps_MTK_some
            fi
            ;;
        mt67[56]* )
            replaceSystemProps_Old
            ;;
    esac
else
    replaceSystemProps_Old
fi
