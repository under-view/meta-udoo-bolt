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
* URI: https://git.openembedded.org/meta-openembedded
    * branch: master
    * revision: HEAD
* URI: https://git.yoctoproject.org/meta-amd
    * branch: master
    * revision: HEAD

## Build/Install

```
$ bitbake-layers add-layer ../meta-openembedded/meta-oe
$ bitbake-layers add-layer ../meta-openembedded/meta-python
$ bitbake-layers add-layer ../meta-openembedded/meta-networking
$ bitbake-layers add-layer ../meta-amd/meta-amd-bsp
$ bitbake-layers add-layer ../meta-udoo-bolt
$ MACHINE="udoo-bolt-live-usb" DISTRO="udoo" bitbake core-image-base
```

## Flashing

**USB Drive**
```
$ sudo bmaptool copy --bmap tmp/deploy/images/udoo-bolt-live-usb/core-image-base-udoo-bolt-live-usb.wic.bmap tmp/deploy/images/udoo-bolt-live-usb/core-image-base-udoo-bolt-live-usb.wic.gz <block device>
```
