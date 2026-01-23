# 🦋 ButterFly RISC-V Core

*A Custom Open-Source RISC-V Processor Project*

---

## 🧠 Overview

**ButterFly** is an educational and research-oriented **RISC-V processor core** designed from scratch, inspired by the open hardware movement and projects like **SHAKTI by IIT Madras**.

The goal of ButterFly is to **design, verify, and prototype a clean, modular, and efficient RISC-V core** — starting from the **specification and microarchitecture** to **simulation, synthesis, and ASIC/FPGA implementation** — using both open-source and industry-standard tools.

This project blends **academic learning**, **hardware design exploration**, and **open-source philosophy** into a single evolving processor design effort.

---

## 🪶 Why “ButterFly”?

Just as a butterfly evolves through distinct stages of growth, this project evolves from
**specification → RTL → simulation → synthesis → layout**, symbolizing transformation and learning.

The name also represents **lightness and modularity**, core design goals of the architecture — a lightweight yet powerful open RISC-V core for exploration, education, and innovation.

---

## 🚀 Current Status (IMPORTANT)

### ✅ **Version: v0.1 — Stable RTL Core**

ButterFly has reached its **first stable milestone**:

* A **fully functional 5-stage pipelined RV32I core**
* Verified through **directed test programs and waveform inspection**
* Clean modular RTL, suitable for further expansion

> This repository currently represents **ButterFly v0.1**, frozen for stability and documentation.

---

## ✨ Implemented Features (v0.1)

### 🧱 Microarchitecture

* 5-stage pipeline: **IF → ID → EX → MEM → WB**
* Separate instruction and data memory interfaces
* Word-aligned instruction fetch

### 🧠 ISA Support (Implemented)

* **RV32I Base ISA (Partial)**

  * Arithmetic: ADD, SUB, AND, OR, XOR
  * Immediate: ADDI, ANDI, ORI
  * Comparison: SLT, SLTU
  * Shifts: SLL, SRL, SRA
  * Memory: LW, SW
  * Branch: BEQ, BNE, BLT, BGE, BLTU, BGEU

> The full RV32IM support described in `specification.md` is the **architectural target**, not yet fully implemented.

---

## 🚦 Hazard Handling (Implemented & Verified)

### ✔ Data Hazards

* EX/MEM forwarding
* MEM/WB forwarding
* Store-data forwarding
* Load-use hazard detection with pipeline stall insertion

### ✔ Control Hazards

* Static **not-taken** branch strategy
* Branch resolution in **EX stage**
* IF/ID flush + ID/EX bubble on taken branch

These mechanisms are visible and verifiable in **GTKWave simulations**.

---

## 🧪 Simulation & Verification

### Run Simulation

```bash
./scripts/run_sim.sh
```

Or manually:

```bash
iverilog -g2012 -I rtl \
  rtl/*.sv tb/soc_tb.sv -o soc_sim
vvp soc_sim
```

### View Waveforms

```bash
gtkwave soc.vcd
```

### Test Programs

Located in `programs/`:

* `test_basic.hex` — arithmetic + load/store
* `test_branch.hex` — branch correctness
* `test_load_use.hex` — load-use hazard validation

---

## 🧩 Repository Structure

| Directory     | Description                                                     |
| ------------- | --------------------------------------------------------------- |
| **rtl/**      | Core RTL modules (pipeline, ALU, decoder, regfile, branch unit) |
| **tb/**       | Module-level and SoC-level testbenches                          |
| **programs/** | RISC-V test programs (HEX format)                               |
| **scripts/**  | Simulation automation                                           |
| **sim/**      | Simulation artifacts                                            |
| **docs/**     | Architecture & specification documents                          |
| **openlane/** | ASIC flow setup (Sky130)                                        |
| **fpga/**     | FPGA prototyping (planned)                                      |
| **results/**  | Reports and waveforms                                           |
| **include/**  | Shared definitions and macros                                   |

---

## 📐 Specification Reference

The architectural intent of ButterFly is fully described in:

📄 **`docs/specification.md`**

That document defines:

* Target ISA: **RV32IM**
* Pipeline organization
* CSR, interrupts, multiplier/divider
* FPGA & ASIC goals

> **README = implementation status**
> **specification.md = architectural contract**

This separation is intentional and professional.

---

## ⚙️ Toolchain & Environment

### 🖥️ Open-Source (Ubuntu 22.04)

* SystemVerilog / Verilog RTL
* Icarus Verilog + GTKWave
* Yosys + OpenLane / OpenROAD
* Git + GitHub

### 🏫 Academic / Industry Tools

* Cadence Genus, Innovus, JasperGold
* Used for synthesis, PnR, and formal exploration

---

## 🚧 Known Limitations (v0.1)

* JAL / JALR writeback not completed
* No CSR or interrupt support yet
* No cache or MMU
* Data memory is stubbed for simulation
* Multiplier/divider unit not yet integrated

These are **planned**, not missing-by-mistake.

---

## 🗺️ Roadmap

| Version  | Goal                            |
| -------- | ------------------------------- |
| **v0.1** | Stable RV32I pipelined core ✅   |
| **v0.2** | JAL/JALR + full RV32I           |
| **v1.0** | RV32IM + FPGA validation        |
| **v2.0** | C extension, interrupts, caches |
| **v3.0** | ASIC-ready Sky130 tapeout study |

---

## 🧑‍💻 About the Creator

**Nidesh Kanna R**
Undergraduate student specializing in **VLSI Design & Technology**,
**Chennai Institute of Technology**, Chennai, India.

Focused on **open-source ASIC design**, **processor microarchitecture**, and **AI-on-chip systems**.

📧 [nideshram01@gmail.com](mailto:nideshram01@gmail.com)
🔗 [LinkedIn: Nidesh Kanna R](https://www.linkedin.com/in/nideshkannar)

---

## 📜 License

MIT License — free to use, learn, modify, and build upon.

---

## 🙏 Acknowledgements

* **SHAKTI Microprocessor Project — IIT Madras**
* RISC-V Foundation & Open Hardware Community
* OpenLane, OpenROAD, SkyWater OpenPDK teams
* Mentors and peers at **Chennai Institute of Technology**

---

> *“The butterfly doesn’t just fly — it transforms.”*
> **ButterFly Core — a journey from RTL to silicon.**

---
