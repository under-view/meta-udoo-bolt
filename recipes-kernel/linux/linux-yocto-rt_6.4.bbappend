require linux-yocto-6.4.inc

PR := "${INC_PR}.1"

KBRANCH:amd ?= "v6.4/standard/preempt-rt/base"
SRCREV_machine:amd ?= "121d700ad4b877fab9238a92356ad32506ef70d5"
SRCREV_meta:amd ?= "88ed9ec49099d69f9546d21137191fd747d06ec4"
