#!/usr/bin/env bash
# Scan the chart with trivy. The subcharts cannot be dropped with --skip-dirs
# (helm needs them to render), so their findings get filtered out of the json.
set -euo pipefail
cd "$(dirname "$0")/.."

# pinned so a new rule upstream does not turn someone else's PR red
bundle=mirror.gcr.io/aquasec/trivy-checks@sha256:1583562f8b90ed2a071b99f0e5ffff6b57e4ceb6ca3e4796577b4e6a339eb74c

log=$(mktemp)
trap 'rm -f "$log"' EXIT

report=$(trivy config --format json \
	--checks-bundle-repository "$bundle" \
	--helm-values vre/linter_values.yaml vre 2>"$log")

# without this trivy quietly uses the checks built into the binary
if grep -q "Falling back to embedded checks" "$log"; then
	echo "scan.sh: could not fetch the pinned checks bundle" >&2
	cat "$log" >&2
	exit 1
fi

printf '%s' "$report" | python3 -c '
import json, sys

results = [r for r in json.load(sys.stdin).get("Results") or []
           if not r["Target"].startswith("charts/")]

# nothing scanned means the chart did not render
if not results:
    sys.exit("scan.sh: trivy scanned no templates, is the chart rendering?")

found = [r["Target"] + ":" + str(m.get("CauseMetadata", {}).get("StartLine", 0))
         + "\t" + m["Severity"] + "\t" + m["ID"] + "\t" + m["Title"]
         for r in results for m in r.get("Misconfigurations") or []]

if found:
    print("\n".join(found))
    sys.exit(1)
'
