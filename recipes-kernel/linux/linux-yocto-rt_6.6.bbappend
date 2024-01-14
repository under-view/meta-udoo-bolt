require linux-yocto-6.6.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v6.6/standard/preempt-rt/base"
SRCREV_machine:amd ?= "7e43b4538ce1a9084c4a5f1b22372c98aa888958"
SRCREV_meta:amd ?= "11390e802ca72f3549b9356f036b17e54afd7a34"
