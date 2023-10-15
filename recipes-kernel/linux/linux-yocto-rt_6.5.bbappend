require linux-yocto-6.5.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v6.5/standard/preempt-rt/base"
SRCREV_machine:amd ?= "a97a5e39ecfb8213e1a8f3065f81de1c1027eb4b"
SRCREV_meta:amd ?= "560dad4d406f3134cc55788513be5cecea54a03f"
