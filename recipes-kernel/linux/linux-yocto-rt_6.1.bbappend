require linux-yocto-6.1.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v6.1/standard/preempt-rt/base"
SRCREV_machine:amd ?= "f974a72071f8b481fc4e38517219bc5c503e14f6"
SRCREV_meta:amd ?= "36901b5b298e601fe73dd79aaff8b615a7762013"
