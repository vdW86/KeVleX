KeVleX
KeVleX is a PowerShell-based CNC tooling management and machine preparation application designed to provide a centralized overview of machine tooling, TDM data, and Vericut tool-life information.
The project was created to simplify daily tooling management tasks in a production environment by combining information that is normally spread across multiple systems into a single, easy-to-use dashboard.
Features

Machine tooling overview

View all tools currently loaded in a machine.
Monitor free, occupied, and blocked tool pockets.
Quickly identify missing tools.

TDM integration

Synchronize tooling information directly from TDM.
Display tool assemblies and component information.
Compare machine tooling with TDM master data.

Vericut integration

Import Vericut tool usage information.
Compare programmed tool usage with actual machine tool-life values.
Highlight tools approaching or exceeding their life limits.

Tool-Life monitoring

Color-coded status indicators:

🟢 Green = healthy
🟠 Orange = attention required
🔴 Red = exceeded limit


Filter tools by status.
Generate printable reports.

Tool comparison

Compare machine tooling against required tooling for a selected NC program.
Identify missing tools before production starts.

Reporting

Printable Tool-Info reports.
Printable Tool-Life reports.
Status-based filtering to focus only on critical tools.

Benefits
KeVleX helps:

CNC operators prepare machines more efficiently.
Programmers verify tooling requirements before production.
Tool managers identify missing or worn tools.
Reduce machine downtime caused by tooling issues.
Improve production readiness and setup validation.

Current Technology

PowerShell 7
Windows Forms (WinForms)
JSON-based data storage
TDM integration
Vericut tooling analysis

Project Status
KeVleX is an active development project. New functionality is continuously being added and refined based on real-world production requirements.
