# KeVleX Project Overview

## Purpose

KeVleX is a PowerShell 7 WinForms application for CNC tooling management.

The application combines information from multiple sources and presents it through a single dashboard for machine preparation and tooling analysis.

---

# Architecture

## Main Application

KeVleX.ps1

Entry point of the application.

Responsible for:

- Loading configuration
- Loading data
- Initializing UI
- Registering events
- Starting the application

---

# Folder Structure

scripts/

## core

General functionality:

- config.ps1
- logging.ps1
- data.ps1
- InitializeData.ps1
- VericutTimes.ps1

## UI

User interface:

- CreateForm.ps1
- CreateTree.ps1
- CreateTabs.ps1
- CreateGrids.ps1
- CreateInfoPanel.ps1
- RegisterEvents.ps1
- LoadDetails.ps1
- Colors.ps1
- ViewHelpers.ps1

## Actions

User actions:

- RefreshMachine.ps1
- RefreshTDM.ps1
- RunCompare.ps1

---

# Main Features

## Overview

Dashboard showing:

- Machine name
- Total pockets
- Used pockets
- Blocked pockets
- Free pockets

## Tool-Info

Displays:

- Tool ID
- Tool name
- Availability
- Pocket

Features:

- Color filtering
- Print functionality

## Tool-Life

Displays:

- Tool ID
- Tool name
- TIME1
- TIME2
- CUR.TIME
- VERICUT.TIME

Features:

- Life-status coloring
- Green filter
- Orange filter
- Red filter
- Print functionality

## Components

Displays:

- Component IDs
- Component names

Based on selected tool.

---

# Data Sources

## Machine Data

Machine tooling information.

## TDM Data

Tooling master data.

## VericutTimes

Vericut exported tooling usage file.

Used to determine expected tool usage duration for a selected NC program.

---

# Color Logic

## Tool-Info

Green:
Tool available.

Red:
Tool missing.

## Tool-Life

Green:
Usage below warning threshold.

Orange:
Usage above warning threshold.

Red:
Tool exceeds life limit.

---

# Current Development Focus

- UI improvements
- Reporting
- TDM synchronization
- Vericut integration
- Tool-life analysis
- Performance improvements

---

# Future Ideas

- PDF export
- EXE packaging
- Multi-machine support
- Automatic updates
- Database backend
- Web dashboard