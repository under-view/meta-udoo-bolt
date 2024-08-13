inherit deploy

do_deploy() {
    mkdir -p ${DEPLOYDIR}/${PN}-bios
    cp -ra ${B}/* ${DEPLOYDIR}/${PN}-bios || ret=$?
}

addtask do_deploy
