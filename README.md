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
* URI: https://github.com/under-view/meta-amd-embed
    * branch: master
    * revision: HEAD

## Build

```
$ bitbake-layers add-layer ../meta-udoo-bolt

# Emmc wic may be built standalone
$ MACHINE="udoo-bolt-emmc" bitbake emmc-wic

# Liveusb will build emmc-wic and place into images partition
$ MACHINE="udoo-bolt-live-usb" bitbake liveusb-wic
```

## Flashing

**USB Drive**

```
$ sudo bmaptool copy --bmap tmp/deploy/images/udoo-bolt-live-usb/liveusb-wic-udoo-bolt-live-usb.rootfs.wic.bmap tmp/deploy/images/udoo-bolt-live-usb/liveusb-wic-udoo-bolt-live-usb.rootfs.wic.gz <block device>
```
