#!/bin/bash
set -e
netlab status >status.out
grep "mgmt IP" status.out >/dev/null
grep "192.168.121.21" status.out >/dev/null
grep "192.168.121.22" status.out >/dev/null
grep "graphite" status.out >/dev/null
netlab status --format json >status.json
python3 - <<'PY'
import json

with open("status.json", encoding="utf-8") as status_file:
  nodes = json.load(status_file)["nodes"]

assert nodes["vm"]["mgmt"] == "192.168.121.21"
assert nodes["ctr"]["mgmt"] == "192.168.121.22"
assert nodes["graphite"]["device"] == "(tool)"
assert "mgmt" not in nodes["graphite"]
assert "mgmt6" not in nodes["graphite"]
PY
echo "netlab status displays IPv4 management addresses for nodes and keeps tool JSON unchanged"
