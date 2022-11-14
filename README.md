## Unlocker for the USB (HAL) audio class driver's limitation (up to 96kHz lock) on Android devices

This magisk module has been developed for recent music streaming services which output greater than 96kHz high resolution sound, and behaves as follows:

* 1. hexdump "/vendor/{lib, lib64}/libalsautils{,v2}.so" to "tempfile{,v2}-{lib, lib64}"
       
* 2. edit "tempfile{,v2}-{lib, lib64}" to replace
```
hexdumped "std_sample_rates[]={96000, 88200, 192000, 176400, 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11025, 8000}" (up to 96kHz lock)

  with

hexdumped "std_sample_rates[]={192000, 176400, 96000, 88200, 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11025, 8000}" (up to 192kHz lock)	

  or

hexdumped "std_sample_rates[]={384000, 352800, 192000, 176400, 96000, 88200, 48000, 44100, 32000, 24000, 16000, 12000, 8000}" (up to 384kHz lock)

  or

hexdumped "std_sample_rates[]={768000, 705600, 384000, 352800, 192000, 176400, 96000, 88200, 48000, 44100, 24000, 16000, 8000}" (up to 768kHz lock).
```

* 3. Revert "tempfile{,v2}-{lib, lib64}" to each binary file "$MODDIR/system/vendor/{lib, lib64}/libalsautils{,v2}.so".

* 4. Overlay "$MODDIR/system/vendor/{lib, lib64}/libalsautils{,v2}.so" onto "/vendor/{lib, lib64}/libalsautils{,v2}.so"

* Remark: This module unlocks up to 384kHz unless you have modified "post-fs-data.sh" in its zip file (or "post-fs-data.sh" installed in its "$MODDIR" on your device) except some known devices which don't stutter at 768kHz & 32bit mode. Up to 768kHz unlocking may stutter sound on your device. If you need to automatically connect 192kHz (instead of 384kHz) to your USB DAC, please modify the "post-fs-data.sh" (in this file, "max", "full" and "default" mean "up to 768kHz", "up to 384kHz" and "up to 192kHz" unlocking, respectively).


* This module has been tested on LineageOS based ROMs (Android 10 ~ 13) and ArrowOS (Android 11 ~ 13). See also my companion script ["USB_SampleRate_Changer"](https://github.com/yzyhk904/USB_SampleRate_Changer) to change the sample rate of the USB audio class driver and a 3.5mm jack on the fly like Bluetooth LDAC or Windows mixer.
* In details, see ["modules/usbaudio/audio_hal.c"](https://android.googlesource.com/platform/hardware/libhardware/+/master/modules/usbaudio/audio_hal.c), ["alsa_utils/alsa_device_profile.c"](https://android.googlesource.com/platform/system/media/+/master/alsa_utils/alsa_device_profile.c) and ["alsa_utils/alsa_device_proxy.c"](https://android.googlesource.com/platform/system/media/+/master/alsa_utils/alsa_device_proxy.c) in AOSP sources.
* If your device uses (USB) audio hardware offloading, its UAC driver is capable of outputting up to 384kHz for Qcomm devices and 96kHz for MTK and Tensor devices. So you may not need this magisk module for Qcomm devices unless considering jitter distortion. Try ["USB_SampleRate_Changer"](https://github.com/yzyhk904/USB_SampleRate_Changer).
<br/>

## DISCLAIMER

* I am not responsible for any damage that may occur to your device, so it is your own choice to attempt this module.

## Change logs

# v1.0
* Initial Release

# v1.1
* Recent higher sample rates added

# v1.2
* arm (32bit) bug fixed ("/vendor/lib64/libalsautils.so" phantom overlay makes stutters on arm devices)

# v1.3
* Added new properties related to an audio scheduling

# v1.4
* Added a workaround for Android 12 SELinux bug w.r.t. "ro.audio.usb.period_us" property

##
