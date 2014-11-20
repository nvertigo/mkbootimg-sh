#!/bin/sh

KERNELDIR="/usr/local/src/android/kernel/samsung/sh"
PKGDIR="./pkgdir"
RAMFSDIR="./ramfsdir"

rm -rf $PKGDIR
mkdir -p $PKGDIR

if [ -e $KERNELDIR/arch/arm/boot/zImage ]; then
	echo "Copy zImage to Package"
	cp $KERNELDIR/arch/arm/boot/zImage $PKGDIR/zImage

	echo "Make boot.img"
	./mkbootfs $RAMFSDIR | gzip > $PKGDIR/ramdisk.gz
	./mkbootimg --kernel $PKGDIR/zImage --ramdisk $PKGDIR/ramdisk.gz --base 0x10000000 --pagesize 2048 --output $PKGDIR/boot.img 
	export curdate=`date "+%Y%m%d"`
	pushd $PKGDIR
	cp -R ../META-INF .
	rm ramdisk.gz
	rm zImage
	rm ../SkyHigh-chagallwifi-cm*.zip
	zip -r ../SkyHigh-chagallwifi-cm-$curdate.zip .
	popd
else
	echo "KERNEL DID NOT BUILD! no zImage exist"
fi;
