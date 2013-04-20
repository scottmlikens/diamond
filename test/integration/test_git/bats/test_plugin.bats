#!/usr/bin/env bats
@test "CPU Collector should be enabled" {
[ -f "/opt/diamond/etc/diamond/collectors/CPUCollector.conf" ]
}
@test "NetworkCollector should be enabled" {
[ -f "/opt/diamond/etc/diamond/collectors/NetworkCollector.conf" ]
}
