# R1.2 Backlog

## Bootstrap UX

### Make `--sync` output less noisy

Current `--sync` output prints full Lazy.nvim plugin fetch/checkout/log output directly to the terminal.

Future improvement:

- Capture Lazy.nvim sync output to a log file.
- Print a concise summary during normal successful runs.
- Show or reference the full log only when failures occur.
- Preserve debuggability; do not hide useful failure information.

Status: Backlog
Priority: Low / polish
