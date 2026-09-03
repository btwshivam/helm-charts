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

# kept separate so a trivy failure stops here, not in the parser
report=$(trivy config --format json --quiet \
	--checks-bundle-repository "$bundle" \
	--helm-values vre/linter_values.yaml --helm-kube-version 1.31.0 vre)

printf '%s' "$report" | python3 -c '
import json, sys

report = json.load(sys.stdin)
targets = [r for r in report.get("Results") or [] if not r["Target"].startswith("charts/")]

# no targets at all means the chart did not render, not that it is clean
if not targets:
    print("scan.sh: trivy scanned no templates, is the chart rendering?", file=sys.stderr)
    sys.exit(1)

rows = []
for result in targets:
    target = result["Target"]
    for finding in result.get("Misconfigurations", []):
        if finding.get("Status") != "FAIL":
            continue
        # a few checks report no line, so keep the key a single type
        line = finding.get("CauseMetadata", {}).get("StartLine", 0)
        rows.append((finding["Severity"], target, line, finding["ID"], finding["Title"]))

order = {"CRITICAL": 0, "HIGH": 1, "MEDIUM": 2, "LOW": 3}
for severity, target, line, ident, title in sorted(rows, key=lambda r: (order.get(r[0], 9), r[1], r[2])):
    where = f"{target}:{line}" if line else target
    print(f"{where}\t{severity}\t{ident}\t{title}")

if rows:
    print(f"\n{len(rows)} misconfiguration(s)", file=sys.stderr)
    sys.exit(1)
'
