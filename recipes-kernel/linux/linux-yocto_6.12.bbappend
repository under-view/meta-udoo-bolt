require linux-yocto-6.12.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v6.12/standard/base"
SRCREV_machine:amd ?= "c2c450e032c7bf2653e50fc0a87329ce5660b6be"
SRCREV_meta:amd ?= "d36334a8b9597faf3978548085097c3b54d462d1"
