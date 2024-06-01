inherit deploy

do_deploy() {
    mkdir -p ${DEPLOYDIR}/${PN}-bios
    cp -ra ${B}/* ${DEPLOYDIR}/${PN}-bios
}

addtask do_deploy
