# 🧠 ButterFly RV32IM Core — RTL Directory

This directory contains all **Register Transfer Level (RTL)** design files for the **ButterFly RISC-V RV32IM** core.
Each module is written in **SystemVerilog (.sv)** for better type checking, parameterization, and cleaner hierarchy separation.

The RTL implements a **5-stage in-order pipeline** architecture — **Fetch, Decode, Execute, Memory, and Write-Back** — along with control logic, CSRs, and optional extensions.

---

## 📂 Directory Structure Overview

| File                  | Description                                                                                                                                                                      |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **butterfly_core.sv** |  **Top-level core module** that connects all submodules. Handles instruction flow between pipeline stages, global control signals, and exception handling.                     |
| **alu.sv**            | Implements the **Arithmetic Logic Unit** supporting addition, subtraction, logical ops, shifts, and set-less-than operations. Also provides flag signals (zero, sign, overflow). |
| **regfile.sv**        | Dual-read and single-write **Register File** for 32 general-purpose registers (`x0–x31`). Register `x0` is hardwired to zero.                                                    |
| **decoder.sv**        | Parses 32-bit RISC-V instructions and generates control signals (ALU operation, register usage, immediate types, branch type, memory access).                                    |
| **control_unit.sv**   | Central **pipeline control logic** that coordinates stalls, flushes, forwarding, and hazard detection.                                                                           |
| **branch_unit.sv**    | Evaluates branch conditions and calculates target addresses. Handles jump and branch misprediction flushes.                                                                      |
| **muldiv_unit.sv**    | Implements RV32M extension — hardware **multiply/divide** operations using iterative or pipelined approach.                                                                      |
| **mem_if.sv**         | **Memory interface** unit for load/store operations. Manages data alignment, sign extension, and handshaking with external memory or cache.                                      |
| **csr_unit.sv**       | Implements **Control and Status Registers (CSRs)** for machine mode, exception handling, and performance counters. Supports `mstatus`, `mepc`, `mtvec`, `mcause`, etc.           |
| **pipeline_regs.sv**  | Defines **pipeline stage registers** (`IF/ID`, `ID/EX`, `EX/MEM`, `MEM/WB`) to store intermediate signals, ensuring clean timing and modular design.                             |

---

## ⚙️ Design Conventions

* **Language:** SystemVerilog (`.sv`)
* **Clock:** Single synchronous positive-edge clock (`clk`)
* **Reset:** Active-low synchronous reset (`rst_n`)
* **Naming Style:**

  * Signals: `snake_case`
  * Parameters: `UPPER_CASE`
  * Ports: `_i` for inputs, `_o` for outputs
* **Pipeline Stages:**

  * `IF` → Instruction Fetch
  * `ID` → Instruction Decode
  * `EX` → Execute
  * `MEM` → Memory Access
  * `WB` → Write-Back

---

## 🔍 Development Flow

1. **Start with:** `regfile.sv`, `alu.sv`, `decoder.sv`
2. **Integrate:** `control_unit.sv`, `branch_unit.sv`, `muldiv_unit.sv`
3. **Finalize core integration:** in `butterfly_core.sv`
4. **Add pipeline registers:** `pipeline_regs.sv`
5. **Interface memory and CSRs:** `mem_if.sv`, `csr_unit.sv`

This modular structure allows each functional block to be designed, simulated, and verified independently before top-level integration.

---

## 🧩 Future Extensions

* **Debug interface (JTAG / DMI)**
* **Interrupt controller**
* **Simple cache subsystem**
* **AXI/AHB memory interface**

---

## 👨‍💻 Author

**Nidesh Kanna R**
VLSI Design & Technology, Chennai Institute of Technology
📧 [nideshram01@gmail.com](mailto:nideshram01@gmail.com)
🔗 [LinkedIn – Nidesh Kanna R](https://www.linkedin.com/in/nideshkannar/)

---


