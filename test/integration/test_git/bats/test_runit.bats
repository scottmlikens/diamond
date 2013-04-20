#!/usr/bin/env bats
@test "/etc/init/diamond.conf should not exist" {
[ ! -f "/etc/init/diamond.conf" ]
}

@test "/etc/sv/diamond/run should exist" {
[ -f "/etc/sv/diamond/run" ]
}
