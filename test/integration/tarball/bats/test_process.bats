#!/usr/bin/env bats
@test "Created the ProcessResourcesCollector.conf file" {
[ -f "/opt/diamond/etc/diamond/collectors/ProcessResourcesCollector.conf" ]
}

@test "ProcessResourcesCollector.conf is correct" {
file="/opt/diamond/etc/diamond/collectors/ProcessResourcesCollector.conf"
shouldbe=$(cat <<EOF
### Options for ProcessResourcesCollector
enabled = true
unit = B

[process]

[[diamond]]
selfmon = true

EOF
)
[ "$shouldbe" == "$(cat "$file")" ]
}
