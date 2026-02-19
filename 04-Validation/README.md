# Phase 4 – Compliance & Validation Framework

## Overview

This phase validates that the Windows baseline configuration is correctly applied and operational.

The objective is to:

- Export compliance snapshots
- Validate policy enforcement
- Document firewall posture
- Capture update configuration state
- Produce audit-ready artifacts

---

## Validation Areas

- GPO Result report
- Local user account audit
- Firewall configuration export
- Installed hotfix review
- Defender status check
- Windows Update policy verification

---

## Scripts Included

- `audit-export-script.ps1`

This script:

- Generates timestamped compliance exports
- Captures baseline security posture
- Produces structured validation artifacts

---

## Intended Outcome

A documented validation process enabling:

- Security review
- Internal audit preparation
- Repeatable compliance checks
- Baseline verification after rebuild
