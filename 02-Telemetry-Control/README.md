# Phase 2 – Telemetry & Data Exposure Control

## Overview

This phase focuses on minimizing unnecessary outbound telemetry and reducing Windows data exposure settings in security-sensitive environments.

The objective is to:

- Limit diagnostic data transmission
- Disable consumer experience features
- Reduce tracking identifiers
- Enforce privacy-aligned policies

---

## Strategy

Telemetry controls are applied through:

- Policy-based registry enforcement
- Local security configuration
- Advertising ID restriction
- Feedback & cloud suggestion disablement

---

## Scripts Included

- `telemetry-disable.ps1`

The script:

- Applies policy-based telemetry limits
- Disables advertising identifiers
- Enforces reduced data collection settings

---

## Intended Outcome

A hardened Windows endpoint configuration with:

- Reduced outbound telemetry
- Controlled user experience features
- Baseline privacy alignment
