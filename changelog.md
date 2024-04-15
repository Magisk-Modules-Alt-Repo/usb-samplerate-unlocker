## Change logs

#v1.5.6
* Added "compatible Magisk-mirroring" message for incompatible Magisk variants

#v1.5.5
* Tuned the USB period size for SDM845 devices (2500 usec to 2250 usec)
* Tuned the USB period size for other devices (to 2250 usec)
* Fixed logically wrong selinux prop settings (no meaning for magisk's magic mount mechanism)
* Added checking incompatible Magisk variants

# v1.5.4
* Tuned the USB period size for Tensor devices (2625 usec to 2250 usec)
* Fixed for Pixel 8's

# v1.5.3
* Tuned USB transfer period sizes

# v1.5.2
* Tuned USB transfer period sizes

# v1.5.1
* Reduced the jitter of Tensor device's offload driver for USB DAC's
* Unlocked the limiter of Tensor device's offload driver from 96kHz to 192kHz, until now

# v1.5.0
* Fixed some SELinux related bugs for Magisk v26.0's new magic mount feature

# v1.4.1
* Adjusted properties for MTK A12 vendor primary audio HAL

# v1.4.0
* Added a workaround for Android 12 SELinux bug w.r.t. "ro.audio.usb.period_us" property
* Changed vendor.audio_hal.period_multiplier=2 to vendor.audio_hal.period_multiplier=1 for reducing jitter
* Let Dimensity devices (vendor A12 or later) to unlock up to 768kHz. 

Try USB_SampleRate_Changer to use larger than 96kHz modes. Their default is 48kHz, but "usb transfer period" is optimized to reduce jitter

# v1.3.0
* Set an audio scheduling tunable "vendor.audio.adm.buffering.ms" "2" to reduce jitter on all audio outputs
* Adjusted a USB period to reduce jitter on the USB audio output.

# v1.2.9
* Tuned for MTK Dimensity's

# v1.2.8
* Tuned a USB transfer period for POCO F3 to reduce the jitter of PLL in a DAC

# v1.2.7
* Optimized for POCO F3 not to stutter even at 768kHz & 32bit mode
* Up to 768kHz unlocking become to be applied to some known safe devices

# v1.2.5
* Enlarged a USB transfer period for old MTK SoC's not to stutter

# v1.2.4
* Dummy empty libalsautils.so's were removed because some people worried about them

From now on, they will be generated through a Magisk installation process

# v1.2.3
* Added ro.audio.usb.period_us=4000 or 5600 to system.prop to improve audio quality

# v1.2.2
* Initial release on Magisk-Module-Alt-Reo (migrated from mine)

# v1.2.0
* arm (32bit) bug fixed ("/vendor/lib64/libalsautils.so" phantom overlay makes stutters on arm devices)

# v1.1.0
* Recent higher sample rates added

# v1.0.0
* Initial Release

##
