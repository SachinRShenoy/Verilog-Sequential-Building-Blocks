# Verilog Sequential Building Blocks  
*A structured Verilog implementation of registers, shift registers, FIFO, and stack memory*

---

## 📘 Overview

This repository contains Verilog implementations of fundamental **sequential digital design components**.  
The project focuses on understanding how hardware stores, shifts, buffers, and organises data using clocked logic.

The modules are written as reusable RTL building blocks commonly used in processors, controllers, and digital systems.

---

## 🏗 Repository Structure

```
📦 Verilog-Sequential-Building-Blocks
┣ 📂 rtl
┃ ┣ regs.v
┃ ┣ siso.v
┃ ┣ sipo.v
┃ ┣ piso.v
┃ ┣ pipo.v
┃ ┣ lifo.v
┃ ┗ fifo.v 
┣ 📂 tb
┃ ┗ top_tb.v
┣ 📂 sim
┃ ┗ waveforms/
┗ README.md
```

---

## 🎯 Learning Goals

- Strengthen understanding of sequential logic
- Implement storage and data movement circuits
- Explore FIFO and stack memory behaviour
- Practise parameterised RTL design
- Develop waveform-based debugging skills

---

## 🧠 Topics Covered

### Registers
Basic synchronous storage elements.

- N-bit register
- Reset behaviour
- Clocked updates

---

### Shift Registers

Shift registers enable controlled bit/data movement.

Implemented variants:

- **SISO** – Serial In Serial Out  
- **SIPO** – Serial In Parallel Out  
- **PISO** – Parallel In Serial Out  
- **PIPO** – Parallel In Parallel Out  

Key concepts:

- Bit shifting
- Serial ↔ Parallel conversion
- Load vs shift control
- Concatenation and slicing

---

### Parameterised Shift Register

A configurable-width shift register using Verilog parameters.

Benefits:

- RTL reuse
- Easy scaling (8 / 16 / 32 / N-bit)

---

### FIFO (First In First Out)

Queue-based memory buffer preserving data order.

Features:

- Memory array
- Read/write pointers
- Full / Empty detection
- Overflow / underflow protection

Applications:

- Data buffering
- Streaming systems
- Producer–consumer decoupling

---

### Stack (LIFO – Last In First Out)

Reverse-order memory structure.

Features:

- Stack pointer
- Push / Pop operations
- Boundary protection

Applications:

- Temporary storage
- Function call handling
- Expression evaluation

---

## 🔍 Module Summary

| Module | Description |
|--------|-------------|
| `regs.v` | Parameterised synchronous register |
| `siso.v` | Serial-in serial-out shift register |
| `sipo.v` | Serial-in parallel-out shift register |
| `piso.v` | Parallel-in serial-out shift register |
| `pipo.v` | Parallel-in parallel-out register |
| `fifo.v` | FIFO buffer with status flags |
| `lifo.v` | Stack (LIFO) memory |

---

## Verification Approach

A single **top-level testbench (`top_tb.v`)** is used to:

- Instantiate and test multiple modules
- Generate clock and reset
- Apply stimulus
- Observe behavioural correctness

Waveform inspection validates:

✔ Reset behaviour  
✔ Data shifting  
✔ Pointer movement  
✔ Full/empty transitions  
✔ Push/pop correctness  

---

## Simulation Flow (ModelSim / QuestaSim)

```bash
vlog rtl/*.v
vlog tb/top_tb.v
vsim work.top_tb
run -all
```

## Skills Reinforced

- Sequential RTL design  
- Parameterised modules  
- Memory modelling  
- Safe hardware design practices  
- Debugging using waveforms  

---

## Future Extensions

**Potential upgrades:**

- Circular FIFO (ring buffer)  
- Asynchronous FIFO  
- Dual-clock FIFO  
- Register file  
- UART with FIFO buffering  

---

## Author

**Sachin R Shenoy**  
BTech – Electronics & Communication Engineering  

---
