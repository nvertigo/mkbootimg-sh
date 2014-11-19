#!/bin/sh

KERNELDIR="/usr/local/src/android/kernel/samsung/sh"
PKGDIR="./pkgdir"
RAMFSDIR="./ramfsdir"

if [ -e $KERNELDIR/arch/arm/boot/zImage ]; then
	echo "Copy zImage to Package"
	cp arch/arm/boot/zImage $PACKAGEDIR/zImage

	echo "Make boot.img"
	./mkbootfs $RAMFSDIR | gzip > $PACKAGEDIR/ramdisk.gz
	./mkbootimg --kernel $PACKAGEDIR/zImage --ramdisk $PACKAGEDIR/ramdisk.gz --base 0x10000000 --pagesize 2048 --output $PACKAGEDIR/boot.img 
	export curdate=`date "+%m-%d-%Y"`
	pushd $PACKAGEDIR
	cp -R ../META-INF .
	rm ramdisk.gz
	rm zImage
	rm ../SkyHigh-chagallwifi-cm*.zip
	zip -r ../SkyHigh-chagallwifi-cm-$curdate.zip .
	cd $KERNELDIR
else
	echo "KERNEL DID NOT BUILD! no zImage exist"
fi;
