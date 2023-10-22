package main

import data.json

deny[msg] {
    some i
    provisioner := json.resource_changes[i].change.after.provisioner["remote-exec"]
    command := provisioner.inline[_]
    contains(command, "nc")
    msg := sprintf("Potential shell or bad code detected: %v", [command])
}
