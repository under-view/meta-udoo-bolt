# meta-udoo-bolt

BSP designed specifically for the UDOO bolt (AMD Ryzen™ Embedded V1000 SoC)

## Dependencies

[Yocto project build host packages](https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html#build-host-packages)

* URI: https://github.com/openembedded/openembedded-core
    * branch: kirkstone
    * revision: HEAD
* URI: https://github.com/openembedded/bitbake
    * branch: master
    * revision: 2.0.1
* URI: https://github.com/openembedded/meta-openembedded
    * branch: kirkstone
    * revision: HEAD
* URI: https://git.yoctoproject.org/meta-amd
    * branch: kirkstone
    * revision: HEAD

## Build/Install

```
$ bitbake-layers add-layer ../meta-openembedded/meta-oe
$ bitbake-layers add-layer ../meta-openembedded/meta-python
$ bitbake-layers add-layer ../meta-openembedded/meta-networking
$ bitbake-layers add-layer ../meta-amd/meta-amd-bsp
$ bitbake-layers add-layer ../meta-udoo-bolt
$ MACHINE="udoo-bolt" DISTRO="udoo" bitbake core-image-base
```

## Flashing

**USB Drive**
```
$ sudo bmaptool copy --bmap tmp/deploy/images/udoo-bolt/core-image-base-udoo-bolt.wic.bmap tmp/deploy/images/udoo-bolt/core-image-base-udoo-bolt.wic.gz <block device>
```
