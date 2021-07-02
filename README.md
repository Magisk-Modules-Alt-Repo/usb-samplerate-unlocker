## Unlocker for the USB audio class driver's limitaion (96kHz lock)

This module behaves as follows:

* 1. hexdump "/vendor/{lib, lib64}/libalsautils.so" to "tempfile-{lib, lib64}"
       
* 2. edit "tempfile-{lib, lib64}" to replace

    
  hexdumped 'std_sample_rate[]={96000, 88200, 192000, 176400, 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11025, 8000}'  with
  
  
	  hexdumped 'std_sample_rate[]={192000, 176400, 96000, 88200, 48000, 44100, 32000, 24000, 22050, 16000, 12000, 11025, 8000}'
    
	     or
       
	  hexdumped 'std_sample_rate[]={384000, 352800, 192000, 176400, 96000, 88200, 48000, 44100, 32000, 24000, 16000, 12000, 8000}'
    
	     or
       
	  hexdumped 'std_sample_rate[]={768000, 705600, 384000, 352800, 192000, 176400, 96000, 88200, 48000, 44100, 24000, 16000, 8000}' .

* 3. Revert "tempfile-{lib, lib64}" to binary files in "$MODDIR/system/vendor/{lib, lib64}/libalsautils.so".

* 4. Overlay "$MODDIR/system/vendor/{lib, lib64}/libalsautils.so" onto "/vendor/{lib, lib64}/linalsautils.so"


Tested on LineageOS 18.1 based ROMs (Android 11).

## DISCLAIMER

* I am not responsible for any damage that may occur to your device, 
   so it is your own choice to attempt this module.

## Change logs

# v1.0
* Initial Release

# v1.1
* Recent higher sample rates added

# v1.2
* arm (32bit) bug fixed ("/vendor/lib64/libalsautils.so" phantom overlay makes stutters on arm devices)

##
