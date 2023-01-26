require linux-yocto-5.15.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v5.15/standard/preempt-rt/base"
SRCREV_machine:amd ?= "29d051cc421a76432897019edc33edae35b16e39"
