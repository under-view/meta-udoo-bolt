do_deploy:append:class-target() {
    mkdir -p ${DEPLOYDIR}/${PN}
    cp -ra ${B}/* ${DEPLOYDIR}/${PN}
}
