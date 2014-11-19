#!/system/bin/sh

mount -o remount,rw /
mount -o remount,rw /system /system


#
# Synapse
#
busybox mount -t rootfs -o remount,rw rootfs
busybox chmod -R 755 /res/synapse
busybox ln -fs /res/synapse/uci /sbin/uci
/sbin/uci


#
# kernel custom test
#
if [ -e /data/Kerneltest.log ]; then
rm /data/Kerneltest.log
fi

echo  Kernel script is working !!! >> /data/Kerneltest.log
echo "excecuted on $(date +"%d-%m-%Y %r" )" >> /data/Kerneltest.log


mount -o remount,rw /

#
# Fast Random Generator (frandom) support on boot
#
if [ -c "/dev/frandom" ]; then
	# Redirect random and urandom generation to frandom char device
	chmod 0666 /dev/frandom
	chmod 0666 /dev/erandom
	mv /dev/random /dev/random.ori
	mv /dev/urandom /dev/urandom.ori
	rm -f /dev/random
	rm -f /dev/urandom
	ln /dev/frandom /dev/random
	chmod 0666 /dev/random
	ln /dev/frandom /dev/urandom
	chmod 0666 /dev/random
fi


/sbin/busybox mount -t rootfs -o remount,ro rootfs
/sbin/busybox mount -o remount,ro /system /system
/sbin/busybox mount -o remount,rw /data
