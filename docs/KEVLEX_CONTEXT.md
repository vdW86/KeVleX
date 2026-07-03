# KeVleX Context Document

## What is KeVleX?

KeVleX is a PowerShell 7 WinForms application developed to support CNC production preparation and tooling management.

The application combines data from multiple sources into one interface:

- Machine tooling data
- TDM tooling information
- Vericut tool-life simulations

The goal is to help programmers, operators and tooling specialists identify tooling issues before a machine starts production.

---

# Background

In a typical CNC environment, tool information is scattered across multiple systems:

- CAM systems
- Vericut simulations
- TDM tooling databases
- Machine tooling data

KeVleX acts as a central dashboard that combines this information and presents it in an operator-friendly way.

---

# Main Functional Areas

## Overview

The dashboard displays:

- Machine name
- Total pockets
- Used pockets
- Blocked pockets
- Free pockets

The overview is the landing page when the application starts.

---

## Tool-Info

Shows the tooling required for a selected setup.

Displayed information:

- Tool ID
- Tool Name
- Availability
- Pocket

Features:

- Green tools = available
- Red tools = missing
- Filter by status
- Printable reports

Purpose:

Quickly determine whether all required tools are available before production starts.

---

## Tool-Life

Shows tool-life related information.

Displayed information:

- Tool ID
- Tool Name
- TIME1
- TIME2
- CUR.TIME
- VERICUT.TIME

Color logic:

### Green

Tool is operating within expected limits.

### Orange

Tool is approaching configured limits.

### Red

Tool is likely to exceed its configured life limit.

Features:

- Status filtering
- Print support
- Vericut integration

Purpose:

Identify tooling risks before machining begins.

---

## Components

Displays assembly/component information for the selected tool.

Information is retrieved from TDM assembly data.

Purpose:

Quick inspection of complete tool assemblies.

---

# Data Sources

## Machine Data

Contains:

- Tool pockets
- Tool IDs
- Machine occupancy
- Machine status

---

## TDM Data

Contains:

- Tool master data
- Tool names
- Assemblies
- Components

The following JSON files are used:

- toollists.json
- tools.json
- assemblies.json
- machine_tools.json

---

## VericutTimes

Contains tooling usage exported from Vericut.

The file is parsed by:

scripts/core/VericutTimes.ps1

Purpose:

Estimate future tool usage based on NC program simulation results.

KeVleX compares:

Current Machine Tool Life
+
Expected Vericut Usage
=
Predicted Tool Condition

---

# User Interface Structure

TreeView

```text
Overview

Partname
 ├─ Setup NC01
 ├─ Setup NC02
 └─ Setup NC03