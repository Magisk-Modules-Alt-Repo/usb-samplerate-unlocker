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

function replaceSystemProps()
{
    sed -i \
        -e 's/ro\.audio\.usb\.period_us=.*$/ro\.audio\.usb\.period_us=5600/' \
            "$MODPATH/system.prop"
}

if "$IS64BIT"; then
    case "`getprop ro.board.platform`" in
        mt67[56]? )
            replaceSystemProps
            ;;
    esac
else
    replaceSystemProps
fi
