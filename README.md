# Control-Flow Integrity (CFI) FSM

This repository contains my solution for the **RISC-V LFX Mentorship Coding Challenge** requiring the implementation of a **3-state Finite State Machine (FSM)** in SystemVerilog.

## Overview

The FSM accepts a **32-bit packet** every clock cycle:

* **Bits [31:24]** – Command
* **Bits [23:0]** – Data

Supported commands:

* `SET (0x01)` – Store the 24-bit data into the internal `label` register.
* `JUMP (0x02)` – Transition from **IDLE** to **CHECK**.
* `LPAD (0x03)` – In **CHECK**, compare the received data with the stored label.

The FSM implements three states:

* **IDLE** – Waits for commands. `SET` updates the label, while `JUMP` enters the CHECK state.
* **CHECK** – Accepts a valid `LPAD` only if its data matches the stored label. A successful match returns the FSM to **IDLE**; any other packet transitions to **ERROR**.
* **ERROR** – Sticky state. Once entered, the FSM remains in this state permanently.

## Verification

A self-checking SystemVerilog testbench is included to verify:

* Correct storage of the label using the `SET` command.
* Valid `SET → JUMP → LPAD` sequence returning to **IDLE**.
* Incorrect landing pad causing transition to **ERROR**.
* Sticky behavior of the **ERROR** state.

The simulation successfully passes all test cases.
