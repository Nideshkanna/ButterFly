# 🦋 **ButterFly RISC-V Core — Architecture Specification**

**Version:** 1.0
**Author:** Nidesh Kanna R
**Email:** [nideshram01@gmail.com](mailto:nideshram01@gmail.com)
**LinkedIn:** [linkedin.com/in/nideshkannar](https://www.linkedin.com/in/nideshkannar)
**License:** Open-Source (to be finalized, e.g., MIT or Apache-2.0)
**Status:** Draft
**Date:** November 2025

---

## 1. Introduction

### 1.1 Overview

The **ButterFly Core** is a lightweight, modular, and educationally scalable **RISC-V processor core** designed with open-source tools and methodologies. It aims to balance **simplicity, performance, and verifiability**, making it ideal for:

* Academic and hobbyist experimentation,
* Embedded and IoT edge computing,
* Entry-level FPGA SoC integration, and
* ASIC flow demonstrations (Yosys → OpenROAD → GDSII).

### 1.2 Design Objectives

* **Simplicity:** Clean 5-stage pipeline with predictable behavior.
* **Scalability:** Modular design supporting future ISA extensions.
* **Portability:** Synthesizable on FPGA and compatible with ASIC flows (Sky130).
* **Verification:** Fully testable using RISC-V compliance suite and custom testbenches.
* **Educational Transparency:** Serve as an accessible teaching and research platform.

### 1.3 Scope

This document defines the **architectural specification** of the ButterFly core — the instruction set, microarchitecture, interfaces, and operational characteristics. It serves as the baseline reference for RTL design, verification, and system integration.

---

## 2. Core Overview

| Attribute                 | Description                                     |
| ------------------------- | ----------------------------------------------- |
| **Core Name**             | ButterFly                                       |
| **ISA**                   | RV32IM                                          |
| **Pipeline**              | 5 stages (IF, ID, EX, MEM, WB)                  |
| **Word Width**            | 32-bit                                          |
| **Privilege Modes**       | Machine Mode (M-mode)                           |
| **Branch Prediction**     | Static (Not Taken)                              |
| **Multiplier/Divider**    | Iterative integer M-extension                   |
| **Target Frequency**      | 50–100 MHz on FPGA                              |
| **Implementation Target** | FPGA / Sky130 ASIC                              |
| **Toolchain**             | GCC/Newlib, Yosys, OpenLane, Magic, GTKWave     |
| **Design Language**       | SystemVerilog (primary), Verilog-2001 (modules) |

---

## 3. Instruction Set Architecture (ISA)

### 3.1 Base ISA Support

Implements **RISC-V RV32I (Integer)** base instructions, including:

* Arithmetic: ADD, SUB, AND, OR, XOR, SLT, etc.
* Control: BEQ, BNE, JAL, JALR, LUI, AUIPC
* Load/Store: LW, SW, LH, SH, LB, SB

### 3.2 Extensions

Implements **M-Extension (Multiply/Divide)**:
MUL, MULH, MULHU, DIV, DIVU, REM, REMU.

### 3.3 Register File

* 32 general-purpose 32-bit registers (`x0–x31`)
* `x0` hardwired to zero
* Program Counter (`PC`) — 32 bits

### 3.4 Instruction Encoding

Follows standard **RISC-V 32-bit fixed instruction encoding**, covering R/I/S/B/U/J formats.

---

## 4. Microarchitecture

### 4.1 Pipeline Organization

| Stage   | Function                                   |
| ------- | ------------------------------------------ |
| **IF**  | Instruction Fetch from IMEM                |
| **ID**  | Decode and Register Read                   |
| **EX**  | ALU Execution or Branch Target Calculation |
| **MEM** | Data Memory Access                         |
| **WB**  | Write-back to Register File                |

### 4.2 Execution Units

* **ALU:** 32-bit combinational for arithmetic/logical ops
* **Multiplier/Divider:** Iterative unit (multi-cycle latency)
* **Branch Unit:** Simple comparator and PC update logic

### 4.3 Data Path

Single-cycle path between register file → ALU → write-back with hazard detection.

### 4.4 Hazards and Forwarding

* **Data Hazards:** Resolved using bypassing paths and stall logic.
* **Control Hazards:** Static “not-taken” strategy with flush mechanism.
* **Structural Hazards:** Avoided via separate instruction/data memory buses.

### 4.5 Clocking and Reset

* Single synchronous clock domain
* Active-low asynchronous reset (RSTn)

---

## 5. Memory and Interfaces

### 5.1 Memory Subsystem

| Memory Type            | Width  | Access     | Notes                           |
| ---------------------- | ------ | ---------- | ------------------------------- |
| **Instruction Memory** | 32-bit | Read-only  | Preloaded or AXI-Lite connected |
| **Data Memory**        | 32-bit | Read/Write | Byte/halfword/word addressing   |

### 5.2 External Interfaces

* **Bus Interface:** Simple Wishbone or AXI-Lite (configurable)
* **Debug Interface:** Optional JTAG or custom UART debug port
* **Interrupt Line:** Single external interrupt pin supported (EXT_INT)

---

## 6. Privilege and Interrupt Architecture

* Supports **Machine Mode (M-mode)** only.
* **CSRs implemented:** `mstatus`, `mtvec`, `mepc`, `mcause`, `mie`, `mip`.
* **Interrupt sources:** Timer, external, software.
* **Trap handling:** Fixed base address (0x00000004 offset).

---

## 7. Performance and Targets

| Parameter                  | Target           | Notes                    |
| -------------------------- | ---------------- | ------------------------ |
| **Clock Frequency (FPGA)** | 50–100 MHz       | On Artix-7 or similar    |
| **CPI (Average)**          | ~1.2             | Depends on memory access |
| **Area (Sky130)**          | TBD              | Expected < 0.25 mm²      |
| **Power**                  | < 20 mW @ 50 MHz | Estimate only            |

---

## 8. Verification and Validation Strategy

* **ISA Compliance:** RISC-V official compliance test suite.
* **RTL Simulation:** Using Icarus Verilog and GTKWave.
* **Testbenches:** Directed + randomized test cases.
* **FPGA Validation:** Xilinx Vivado or OpenFPGA flow.
* **Regression Infrastructure:** Python-based test automation planned.

---

## 9. Implementation Environment

| Category              | Tools                        |
| --------------------- | ---------------------------- |
| **RTL Design**        | SystemVerilog / Verilog-2001 |
| **Synthesis**         | Yosys / OpenLane             |
| **PnR**               | OpenROAD / Magic             |
| **Verification**      | Icarus Verilog / Verilator   |
| **Waveform Analysis** | GTKWave                      |
| **FPGA Flow**         | Vivado / nextpnr             |
| **Documentation**     | Markdown + Draw.io + LaTeX   |

---

## 10. Documentation and Maintenance

### 10.1 Coding Standards

* Follows **SystemVerilog RTL Guidelines (lowRISC/OpenHW style)**.
* Naming convention: `module_functionality_direction`.
* Commenting style: consistent, Doxygen-ready for auto-docs.

### 10.2 Repository Structure

```
butterfly/
├── docs/               # Specifications, diagrams, references
├── rtl/                # Core RTL modules
├── tb/                 # Testbenches
├── scripts/            # Automation scripts
├── synth/              # Synthesis/PNR files
├── sim/                # Simulation outputs
├── results/            # Reports, logs, waveforms
└── README.md
```

### 10.3 Version Control

* Managed via GitHub (`main` for stable, `dev` for development).
* Each change is validated with unit and ISA compliance tests before merge.

---

## 11. Future Roadmap

| Phase    | Goal                                          |
| -------- | --------------------------------------------- |
| **v1.0** | RV32IM, single-core, FPGA validated           |
| **v2.0** | Add C extension, interrupt controller, caches |
| **v3.0** | Dual-core SMP, debug interface                |
| **v4.0** | ASIC tape-out with OpenLane (Sky130)          |

---

## 12. References

* RISC-V ISA Manual (v2.2)
* SHAKTI C-class Core Specification — IIT Madras
* OpenHW Group CV32E40P User Manual
* lowRISC Ibex Core Docs
* RISC-V Debug Specification (v1.0.0)

---

## 13. About the Author

**Nidesh Kanna R**
Undergraduate student specializing in **VLSI Design & Technology**,
**Chennai Institute of Technology**, Chennai, India.

Focused on **open-source ASIC design**, **AI-on-chip**, and **embedded computing systems**.
Passionate about bringing open silicon culture to student and research communities.

📧 [nideshram01@gmail.com](mailto:nideshram01@gmail.com)
🔗 [LinkedIn: Nidesh Kanna R](https://www.linkedin.com/in/nideshkannar)

---
