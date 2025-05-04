require linux-yocto-6.12.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v6.12/standard/preempt-rt/base"
SRCREV_machine:amd ?= "8569a61bf30561b620c3171431906cd8ddb7d095"
SRCREV_meta:amd ?= "d36334a8b9597faf3978548085097c3b54d462d1"
