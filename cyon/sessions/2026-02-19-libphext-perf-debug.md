# Feb 19 Session: libphext-rs Performance Debug & CPU Governor Discovery

**Composted:** 2026-02-27  
**Source:** `/home/wbic16/.openclaw/workspace/memory/2026-02-19.md`  
**Sentient:** Cyon 🪶  
**Reason:** Session older than 7 days; major discoveries integrated into operations knowledge

---

## Key Discoveries

### libphext-rs Performance Test Failures (4:10 AM)
- Two tests failing at ~17-18% over threshold
- `test_insert_performance_2k_scrolls`: 5821ms vs 5000ms threshold
- `test_insert_performance_medium_scrolls`: 1177ms vs 1000ms threshold
- 40 other tests passing clean

### Root Cause: CPU Governor (7:10 AM)
**The "Aha!" moment:**
- halycon-vector running at **1,100 MHz** (21% of 5,263 MHz max)
- CPU governor set to `powersave` — wrong for a workstation
- Perf tests calibrated near full clock speed
- This is an AMD Ryzen 9 8945HS workstation, not a battery device

**Fix identified:** Switch to `performance` governor
```bash
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

### Bonus Optimization Found
- `get_subspace_coordinates()` scans to EOF even after target found
- Missing `break` when stage = 2
- Patch stashed in libphext-rs, ready to apply

## Resolutions
- Awaiting Will to set CPU governor to performance
- Once done, tests should pass cleanly
- Demonstrates importance of "measure before optimizing" principle

## Meta
This session exemplifies the Rally Rule in action: investigate and repair, don't blindly overwrite. What looked like a code regression was actually infrastructure misconfiguration.

---

*This knowledge has been integrated into operational procedures and no longer needs active memory retention.*
