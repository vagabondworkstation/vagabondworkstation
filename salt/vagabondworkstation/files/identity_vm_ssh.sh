#!/bin/sh

# Helper to SSH directly from red_identity_vm to another identity vm.

set -e

VM=$1

[ -z "$VM" ] && exit 1

# shellcheck disable=SC2046
ssh root@127.0.0.1 -p $(sporestackv2 get_attribute "$VM" slot) -i $(keyplease private "$VM")
