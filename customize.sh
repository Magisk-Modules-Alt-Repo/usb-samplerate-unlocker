# Making dummies for replacing libalsautils.so's

REPLACE=""
for d in "/system/vendor/lib" "/system/vendor/lib64"; do
    if [ -r "${d}/libalsautils.so" ]; then
        mkdir -p "${MODPATH}${d}"
        touch "${MODPATH}${d}/libalsautils.so"
        chmod 644 "${MODPATH}${d}/libalsautils.so"
        chmod -R a+rX "${MODPATH}${d}"
        if [ -z "${REPLACE}" ]; then
            REPLACE="${d}/libalsautils.so"
        else
            REPLACE="${REPLACE} ${d}/libalsautils.so"
        fi
    fi
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
