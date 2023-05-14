require linux-yocto-5.15.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v5.15/standard/base"
SRCREV_meta:amd ?= "e4b95ec17228274acb38bf10061448224df3a312"
SRCREV_machine:amd ?= "e8c818cce43dd720c366d831aeb102c20c237652"
