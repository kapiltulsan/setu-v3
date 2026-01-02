# 🚀 Setu V3 Project Status

This document tracks the major achievements, feature implementations, and system improvements made to the Setu V3 infrastructure. It serves as a living history of the project's evolution.

## 📅 Recent Achievements (December 2025)

### 1. ✅ Centralized Job Scheduler
**Goal**: Move away from scattered `systemd` timers and `crontab` entries to a unified, manageable system.
- **Implemented**: `setu-admin` service now hosts an internal scheduler (APScheduler).
- **Features**:
  - Database-backed job configuration (`sys.scheduled_jobs`).
  - History tracking with duration and status (`sys.job_history`).
  - **Auto-Discovery**: Jobs are loaded dynamically from the DB on startup.
  - **Self-Healing**: Redundant "Midnight Batch" ensures data collection happens even if individual triggers fail.

### 2. 🎨 Dashboard Separation (Reporting vs. Admin)
**Goal**: Clear separation of concerns between "Monitoring" and "Management".
- **Reporting Panel (:3000)**:
  - Focused purely on **Metrics**, **Portfolio**, and **P&L**.
  - Cleaned up to remove administrative noise (e.g., raw job lists).
  - Fixed SSL Proxy issues to allow secure communication with the backend.
- **Admin Panel (:5000)**:
  - Dedicated **Platform Scheduler** tile.
  - Full visibility into Background Jobs, System Health, and Logs.
  - Capability to **"Run Now"** or **Disable** jobs directly from the UI.

### 3. 🛠️ Critical Bug Fixes & Stability
- **Database Schema Alignment**: Fixed mismatch where code expected `job_id` (Integer) but database used `job_name` (String) for history linking.
- **Execution Path Fix**: Updated all jobs to use the absolute path to the virtual environment python (`venv/bin/python`), resolving "command not found" errors.
- **Duration Tracking**: Implemented dynamic duration calculation for jobs using SQL `EXTRACT(EPOCH...)`.

### 4. 📚 Documentation Sync
- Updated `RUNBOOK.md` to reflect the new architecture.
- Documented the use of the Admin Panel for manual job triggers.

### 5. 🔍 Stock Scanner Module
**Goal**: Interactive interface to build, run, and visualize custom trading logic.
- **Implemented**: Full stack scanner module (Next.js Frontend + Flask Backend + Python Logic Engine).
- **Features**:
  - **Funnel Visualization**: View stats at every filtering stage (Universe -> Primary -> Refiner).
  - **Live Preview**: Test conditions instantly on the latest market data.
  - **Natural Language Rules**: Complex logic translated into human-readable English.
  - **Data Persistence**: Results saved to `trading.scanner_results` for historical analysis.
  - **Refinement (Jan 2026)**: Enhanced logic engine to support hybrid Indicator-vs-Value comparisons and "Index Gatekeeper" filtering.

---

## 🔮 Roadmap / Next Steps
- [ ] **Advanced Charting**: Implementation of TradingView/Lightweight Charts in the Market Data tile.
- [ ] **Alerting Strategy**: Refine Telegram alerts to be less noisy for routine success messages.
- [ ] **Backtesting Engine**: Integration of the core backtesting module with the dashboard.
