require linux-yocto-6.1.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v6.1/standard/preempt-rt/base"
SRCREV_machine:amd ?= "efb2c857761e865cd7947aab42eaa5ba77ef6ee7"
SRCREV_meta:amd ?= "2eaed50911009f9ddbc74460093e17b22ef7daa0"
