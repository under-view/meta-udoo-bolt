require linux-yocto-6.12.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v6.12/standard/preempt-rt/base"
SRCREV_machine:amd ?= "fed5fbc6b68a11d4a9055ea8aa481bb2945c9c89"
SRCREV_meta:amd ?= "2506ff7d20ee515e70964844fa40b35e4fdfbe92"
