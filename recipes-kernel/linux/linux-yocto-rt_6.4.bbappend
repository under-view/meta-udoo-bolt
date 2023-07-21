require linux-yocto-6.4.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v6.4/standard/preempt-rt/base"
SRCREV_machine:amd ?= "0c7d2016a3a548fd8f7caf7b1f46abd71008cd5c"
SRCREV_meta:amd ?= "8a09ea80e6905baf80940dc8c4fe9326bd8d19e2"
