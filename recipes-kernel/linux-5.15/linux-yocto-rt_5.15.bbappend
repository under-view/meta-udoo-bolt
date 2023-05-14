require linux-yocto-5.15.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v5.15/standard/preempt-rt/base"
SRCREV_meta:amd ?= "e4b95ec17228274acb38bf10061448224df3a312"
SRCREV_machine:amd ?= "8e0611e36c848a07f9cdd778903c9e51bb90b319"
