REM Start qemu on windows.
@ECHO OFF

echo "Starting KQEMU service"
net start kqemu

REM SDL_VIDEODRIVER=directx is faster than windib. But keyboard cannot work well.
SET SDL_VIDEODRIVER=windib

REM SDL_AUDIODRIVER=waveout or dsound can be used. Only if QEMU_AUDIO_DRV=sdl.
SET SDL_AUDIODRIVER=dsound

REM QEMU_AUDIO_DRV=dsound or fmod or sdl or none can be used. 
REM See qemu -audio-help.
SET QEMU_AUDIO_DRV=dsound

REM QEMU_AUDIO_LOG_TO_MONITOR=1 displays log messages in QEMU monitor.
SET QEMU_AUDIO_LOG_TO_MONITOR=0

C:\Apps\qemu-0.9.0\qemu.exe -L . -m 192 -hda disk1.qcow2 -cdrom C:\Apps\DiskImages\debian-40r0-i386-CD-1.iso -boot c -redir tcp:22222::22 -redir tcp:9000::9000 -redir tcp:24000::24000 -redir tcp:24001::24001 -redir tcp:24002::24002 -redir tcp:24003::24003 -redir tcp:24004::24004 -usb -usbdevice disk:demo0.qcow -usbdevice disk:demo1.qcow -usbdevice disk:demo2.qcow -usbdevice disk:demo3.qcow -usbdevice disk:demo4.qcow -usbdevice disk:demo5.qcow -usbdevice tablet -usb -soundhw all -localtime

echo "Stopping KQEMU service"
net stop kqemu
