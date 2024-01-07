#!/system/bin/sh

function toHexLE()
{
    if [ $# -eq 1  -a  $1 -gt 0 ]; then
        printf "%2.2x%2.2x%2.2x%2.2x" $(( $1 % 256 ))  $(( $1 / 256 % 256 ))  $(( $1 / 256 / 256 % 256 ))  $(( $1 / 256 / 256 / 256 % 256 ))
        return 0
    else
        return 1
    fi
}

function toHexLineLE()
{
    if [ $# -eq 1 ]; then
        local i
        for i in $1; do
            toHexLE $i
        done
        return 0
    else
        return 1
    fi
}

function toHexString()
{
    if [ $# -ge 1 ]; then
        local tmp
        tmp=`echo -n "$1" | xxd -p | tr -d ' \n'`
        if [ $# -eq 2 ]; then
            if [ ${#tmp} -ge $2 ]; then
                echo -n ${tmp:0:$2}
            else
                local strt=`expr ${#tmp} + 1`
                echo -n "$tmp"
                for i in `seq $strt $2` ; do
                    echo -n "0"
                done
            fi
        else
            echo -n "$tmp"
        fi
    else
        return 1
    fi
}

# Patch libalsautils.so to clear the 96kHz lock of USB audio class drivers
#   arg1: original libalsautils.so file;  arg2: patched libalsautils.so file; 
#     optional arg3: "max" (clearing upto 768kHz), "full" (clearing upto 386kHz), "default" or others (clearing upto 192kHz)
function patchClearLock()
{
    local orig_rates='96000  88200  192000  176400  48000  44100  32000  24000  22050  16000  12000  11025  8000'
    local new_rates='192000  176400  96000  88200  48000  44100  32000  24000  22050  16000  12000  11025  8000'
    
    if [ $# -ge 2  -a  -r "$1"  -a  -w "$2" ]; then
        if [ $# -gt 2 ]; then
            case "$3" in
                "max" )
                    new_rates='768000  705600  384000  352800  192000  176400  96000  88200  48000  44100  24000  16000  8000'
                    ;;
                "full" )
                    new_rates='384000  352800  192000  176400  96000  88200  48000  44100  32000  24000  16000  12000  8000'
                    ;;
                "default" | * )
                    ;;
          esac
      fi

        local pat1=`toHexLineLE "$orig_rates"`
        local pat2=`toHexLineLE "$new_rates"`
      
        # A workaroud for a SELinux permission bug on Android 12
        local prop1=`toHexString "ro.audio.usb.period_us"`
        local prop2=`toHexString "vendor.audio.usb.perio"`
      
        xxd -p <"$1" | tr -d ' \n' | sed -e "s/$prop1/$prop2/" -e "s/$pat1/$pat2/" \
            | awk 'BEGIN {
                foldWidth=60
                getline buf
                len=length(buf)
                for (i=1; i <= len; i+=foldWidth) {
                    if (i + foldWidth - 1 <= len)
                        print substr(buf, i, foldWidth)
                    else
                        print substr(buf, i, len)
                }
                exit
              }'  \
            | xxd -r -p >"$2"
            
        return $?
        
    else
        
        return 1
    fi
}

# Patch audio.primary.${boardname}.so file to clear the 384kHz lock of USB audio class offload drivers
#   arg1: original audio.primary.${boardname}.so file;  arg2: patched audio.primary.${boardname}.so file; 
function patchClearOffloadLock()
{
    local orig_rates='384000  352800  192000  176400  96000  88200  64000  48000  44100  32000  22050  16000  11025  8000'
    local new_rates='768000  705600  384000  352800  192000  176400  96000  88200  48000  44100  22050  16000  11025  8000'
    
    if [ $# -ge 2  -a  -r "$1"  -a  -w "$2" ]; then
        local pat1=`toHexLineLE "$orig_rates"`
        local pat2=`toHexLineLE "$new_rates"`
      
        xxd -p <"$1" | tr -d ' \n' | sed -e "s/$pat1/$pat2/" \
            | awk 'BEGIN {
                 foldWidth=60
                 getline buf
                 len=length(buf)
                 for (i=1; i <= len; i+=foldWidth) {
                     if (i + foldWidth - 1 <= len)
                         print substr(buf, i, foldWidth)
                     else
                         print substr(buf, i, len)
                 }
                 exit
              }'  \
            | xxd -r -p >"$2"
            
        return $?
        
    else
        
        return 1
        
    fi
}

# Patch audio_usb_aoc.so file to clear the 192kHz lock of USB audio class Tensor offload drivers
#   arg1: original audio_usb_aoc.so file;  arg2: patched audio_usb_aoc.so file; 
function patchClearTensorOffloadLock()
{
    local orig_rates='192000  96000  48000  44100  32000  24000  22050  16000  12000  11025  8000'
    local new_rates='768000  705600  384000  352800  192000  176400  96000  88200  48000  44100  8000'

    if [ $# -ge 2  -a  -r "$1"  -a  -w "$2" ]; then
        local pat1=`toHexLineLE "$orig_rates"`
        local pat2=`toHexLineLE "$new_rates"`

        # A workaroud for a SELinux permission bug on Android 12
        local prop1=`toHexString "ro.audio.usb.period_us"`
        local prop2=`toHexString "vendor.audio.usb.perio"`

        # sample rate limiter at 192kHz
        local ul1=`toHexLineLE "192000"`
        local ul2=`toHexLineLE "768000"`
          
#        Don't work yet. Need more inviestigations
#        xxd -p <"$1" | tr -d ' \n' | sed -e "s/$prop1/$prop2/" -e "s/$ul1/$ul2/" -e "s/$pat1/$pat2/" \
        xxd -p <"$1" | tr -d ' \n' | sed -e "s/$prop1/$prop2/" \
            | awk 'BEGIN {
                 foldWidth=60
                 getline buf
                 len=length(buf)
                 for (i=1; i <= len; i+=foldWidth) {
                     if (i + foldWidth - 1 <= len)
                         print substr(buf, i, foldWidth)
                     else
                         print substr(buf, i, len)
                 }
                 exit
               }'  \
             | xxd -r -p >"$2"
             
        return $?
        
    else
        return 1
    fi
}
