# meta-udoo-bolt

BSP designed specifically for the UDOO bolt (AMD Ryzen™ Embedded V1000 SoC). Useful notes can be found on the [wiki
page](https://github.com/under-view/meta-udoo-bolt/wiki).

## Dependencies

* URI: https://git.openembedded.org/openembedded-core
    * branch: master
    * revision: HEAD
* URI: https://git.openembedded.org/bitbake
    * branch: master
    * revision: HEAD

## Build

```
$ bitbake-layers add-layer ../meta-udoo-bolt

# Require by liveusb-wic for the installation of system image
$ MACHINE="udoo-bolt-emmc" bitbake emmc-wic

# Liveusb can ether install emmc-wic or run standalone
$ MACHINE="udoo-bolt-live-usb" bitbake liveusb-wic
```

## Flashing

**USB Drive**
```
$ sudo bmaptool copy --bmap tmp/deploy/images/udoo-bolt-live-usb/liveusb-wic-udoo-bolt-live-usb.rootfs.wic.bmap tmp/deploy/images/udoo-bolt-live-usb/liveusb-wic-udoo-bolt-live-usb.rootfs.wic.gz <block device>
```
