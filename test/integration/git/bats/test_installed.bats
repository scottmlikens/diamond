#!/usr/bin/env bats

@test "/opt/diamond should exist" {
[ -d "/opt/diamond" ]
}

@test "chpst should have created /opt/diamond/diamond.lock" {
[ -f "/opt/diamond/diamond.lock" ]
}

@test "/opt/diamond/bin/activate should exist" {
[ -f "/opt/diamond/bin/activate" ]
}

@test "/opt/diamond/bin/diamond should exist" {
[ -f "/opt/diamond/bin/diamond" ]
}

  
