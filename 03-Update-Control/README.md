# Phase 3 – Windows Update Management Strategy

## Overview

This phase enforces controlled Windows Update behavior to prevent unplanned configuration drift and downtime.

The objective is to:

- Prevent forced automatic installs
- Disable auto-reboot during active sessions
- Control update deployment cadence
- Enable predictable maintenance windows

---

## Policy Strategy

- Configure AUOptions to “Notify before download”
- Defer feature and quality updates
- Prevent auto-reboot with logged-in users
- Document update lifecycle

---

## Scripts Included

- `enforce-update-policy.ps1`

This script:

- Applies policy-based Windows Update controls
- Configures deferral windows
- Enforces notification-only update model

---

## Intended Outcome

A controlled update lifecycle that:

- Minimizes service disruption
- Prevents unauthorized configuration changes
- Supports enterprise change management processes
