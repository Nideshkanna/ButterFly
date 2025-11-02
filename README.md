# 🦋 ButterFly RISC-V Core  
*A Custom Open-Source RISC-V Processor Project*  

---

### 🧠 Overview  

**ButterFly** is an educational and research-oriented **RISC-V processor core** designed from scratch, inspired by the open hardware movement and projects like **SHAKTI by IIT Madras**.  

The goal of ButterFly is to **design, verify, and prototype a clean, modular, and efficient RISC-V core** — starting from the **specification and microarchitecture** to **simulation, synthesis, and ASIC/FPGA implementation** — using both open-source and industry-standard tools.

This project blends **academic learning**, **hardware design exploration**, and **open-source philosophy** into a single evolving processor design effort.

---

### 🪶 Why “ButterFly”?  

Just as a butterfly evolves through distinct stages of growth, this project evolves from **specification → RTL → simulation → synthesis → layout**, symbolizing transformation and learning.  

The name also represents **lightness and modularity**, core design goals of the architecture — a lightweight yet powerful open RISC-V core for exploration, education, and innovation.

---

### 🎯 Objectives  

- Develop a **fully synthesizable RV32I RISC-V core** from scratch.  
- Understand and document each stage of the **ASIC design flow**.  
- Validate functionality through **simulation and FPGA prototyping**.  
- Prepare the design up to the stage requiring **PDK integration** for fabrication.  
- Bridge **open-source EDA tools** (Yosys, OpenLane, Verilator) with **industry tools** (Cadence Genus, Innovus).  
- Contribute to the open hardware ecosystem with clear documentation and educational value.

---

### 🧩 Repository Structure  

| Directory | Description |
|------------|-------------|
| **rtl/** | Verilog/SystemVerilog RTL source files for the core and submodules (ALU, Register File, Control Unit, etc.) |
| **tb/** | Testbenches for functional and module-level verification |
| **sim/** | Simulation scripts, Makefiles, waveform files, and automation |
| **docs/** | Design specification, microarchitecture diagrams, and project documentation |
| **scripts/** | Utility scripts for building, linting, and automation |
| **synthesis/** | Yosys synthesis scripts, gate-level netlists, and reports |
| **fpga/** | FPGA build scripts and configuration files for prototyping |
| **openlane/** | OpenLane configuration for ASIC flow using open PDKs like Sky130 |
| **results/** | Simulation outputs, synthesis reports, and experimental data |
| **include/** | Parameter and macro definitions used across design files |

---

### ⚙️ Toolchain & Environment  

#### 🖥️ Local (Ubuntu 22.04)
- Verilog/SystemVerilog for RTL Design  
- Verilator / GTKWave for simulation  
- Yosys + OpenROAD/OpenLane for synthesis and layout  
- Python + Cocotb for automated verification  
- Git + GitHub for version control  

#### 🏫 College Lab (CentOS with Cadence Tools)
- Cadence Genus, Innovus, and JasperGold for synthesis, PnR, and formal verification  
- Use of commercial-grade environment for ASIC signoff exploration  

This dual-environment flow ensures the design can be built and tested both **openly (on Ubuntu)** and **professionally (on CentOS/Cadence)**.

---

### 🧱 Development Stages  

1. **Specification & Architecture Design**  
   Define ISA, pipeline stages, and memory subsystem.  
2. **RTL Implementation**  
   Modular Verilog coding of core components.  
3. **Simulation & Verification**  
   Testbench-driven functional validation.  
4. **Synthesis**  
   RTL → gate-level synthesis via Yosys / Genus.  
5. **FPGA Prototyping**  
   Hardware validation on FPGA boards.  
6. **ASIC Flow Preparation**  
   Floorplanning, PnR, DRC/LVS with open-source PDKs (Sky130).  

---

### 🌍 Vision  

ButterFly is built with the idea of **learning by doing** — to deeply understand what it takes to design a processor, and to inspire others to explore hardware from the transistor level up to the instruction pipeline.

The project will evolve through multiple iterations:
- **Stage 1:** Functional RV32I Core  
- **Stage 2:** Pipeline Optimization and Hazard Handling  
- **Stage 3:** Integration with Caches and Interrupts  
- **Stage 4:** FPGA/ASIC readiness and tapeout studies  

---

### 🧑‍💻 About the Creator  

**👋 Hi, I’m Nidesh Kanna R** — an undergraduate student in **Electronics Engineering (VLSI Design and Technology)** at **Chennai Institute of Technology**.  

I’m passionate about **semiconductor design, open-source EDA, and embedded AI**, and I love building systems that merge learning with innovation — from custom ASICs to edge-AI hardware.  

🔗 **LinkedIn:** [linkedin.com/in/nideshkannar/](https://www.linkedin.com/in/nideshkannar/)  
📧 **Email:** [nideshram01@gmail.com](mailto:nideshram01@gmail.com)  

---

### 🪴 Backstory  

The ButterFly core was born out of curiosity and inspiration from the **SHAKTI project by IIT Madras**, which proved that academic open hardware could stand shoulder-to-shoulder with industrial IP cores.  

With access to both open-source and licensed toolchains, the aim is to bridge theory and practical chip design experience — to make learning VLSI **hands-on, exploratory, and deeply technical**.  

This project represents not just a processor, but a **personal journey into silicon**.  

---

### 🧭 License  

This project is licensed under the **MIT License** — open for learning, modification, and contribution.  

---

### 📜 Acknowledgements  

Special inspiration from:  
- **SHAKTI Microprocessor Project, IIT Madras**  
- **RISC-V Foundation & Open Hardware Community**  
- **OpenLane, OpenROAD, and SkyWater OpenPDK teams**  
- Mentors and peers at **Chennai Institute of Technology**

---

> “The butterfly doesn’t just fly — it transforms.”  
> — *ButterFly Core: A student’s journey from RTL to silicon.*
