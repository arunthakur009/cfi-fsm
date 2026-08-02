#!/bin/bash

iverilog -g2012 \
    cfi_fsm.sv \
    tb_cfi_fsm.sv \
    -o sim.out

vvp sim.out