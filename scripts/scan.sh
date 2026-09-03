#!/usr/bin/env bash
# Scan the chart with trivy, subcharts excluded.
#
# Neither --skip-dirs nor an ignorefile can drop them (helm needs them to
# render, and path globs do not apply to misconfigurations), so the subchart
# results get filtered out of the json instead.
set -euo pipefail
cd "$(dirname "$0")/.."

# pinned, the bundle is re-pulled every 24h and a new rule upstream
# should not turn someone else's PR red
bundle=mirror.gcr.io/aquasec/trivy-checks@sha256:1583562f8b90ed2a071b99f0e5ffff6b57e4ceb6ca3e4796577b4e6a339eb74c

trivy config --format json \
	--checks-bundle-repository "$bundle" \
	--helm-values vre/linter_values.yaml vre |
	python3 -c '
import json, sys

results = [r for r in json.load(sys.stdin).get("Results") or []
           if not r["Target"].startswith("charts/")]

# nothing scanned means the chart did not render, not that it is clean
if not results:
    sys.exit("scan.sh: trivy scanned no templates, is the chart rendering?")

found = ["\t".join((r["Target"], m["Severity"], m["ID"], m["Title"]))
         for r in results for m in r.get("Misconfigurations") or []]

print("\n".join(found))
sys.exit(1 if found else 0)
'
