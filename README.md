# Pipelined MIPS CPU (VHDL)

A 5-stage pipelined MIPS-style processor written in VHDL, with data forwarding,
load-use hazard detection, and branch/jump handling. Simulated in ModelSim
against a test program that exercises every implemented instruction.
<img width="1806" height="730" alt="image" src="https://github.com/user-attachments/assets/a3fcfca1-c3d6-41ad-93ce-06d4fb1c12e7" />

## Features

- 5-stage pipeline: IF, ID, EX, MEM, WB, with a dedicated register entity between each stage
- Data forwarding from both MEM and WB back into EX, with MEM taking priority
- Load-use hazard detection stalls IF/ID and injects a bubble into ID/EX
- Control hazards: branches and jumps resolve in EX and flush the two younger instructions
- 20 instructions across R-type, I-type, and J-type
- ALU with add/sub, set-less-than, four logic operations, and signed overflow detection


## Repository layout

```
rtl/
  cpu_pipelined.vhd          top level: datapath wiring, muxes, PC select
  pc_reg.vhd                 program counter register
  icache.vhd                 instruction memory (32 words, annotated program)
  regfile.vhd                32 x 32-bit register file
  alu.vhd                    ALU with overflow and zero flags
  sign_extend.vhd            sign / zero extend and lui shift
  dcache.vhd                 data memory (32 words)
  control_unit.vhd           opcode + funct decode
  hazard_and_forwarding.vhd  hazard detection unit + forwarding unit
  if_id_reg.vhd              IF/ID pipeline register (stall + flush)
  id_ex_reg.vhd              ID/EX pipeline register (flush)
  ex_mem_reg.vhd             EX/MEM pipeline register
  mem_wb_reg.vhd             MEM/WB pipeline register

sim/
  dofile/dofile.do           ModelSim script: wave setup, reset, clock stimulus
  results/                   waveform captures
```

## Running the simulation

The design is driven directly by `force` commands rather than a testbench, so
there is no separate top-level entity to elaborate. From the repository root in
ModelSim:

```tcl
vlib work
vcom -2008 rtl/*.vhd
vsim work.cpu_pipelined
do sim/dofile/dofile.do
```

The `-2008` flag is required (the branch comparator in the top level uses a
VHDL-2008 construct). The dofile sets up the wave window, holds `reset` high for
20 ns, then clocks through the full program.

Signals worth watching: `if_pc_current` for pipeline progress, `stall` and
`forward_a` / `forward_b` for hazard activity, and `wb_reg_d_in` alongside
`wb_write_addr` for committed results.

## Instruction set

```
Type  Instruction  Opcode / funct     Notes
----  -----------  -----------------  -------------------------------------------
R     add          000000 / 100000    signed, sets overflow
R     sub          000000 / 100010    signed, sets overflow
R     and          000000 / 100100
R     or           000000 / 100101
R     xor          000000 / 100110
R     nor          000000 / 100111
R     slt          000000 / 101010
R     jr           000000 / 001000    target taken from forwarded rs
I     addi         001000             sign-extended immediate
I     slti         001010             sign-extended immediate
I     andi         001100             zero-extended immediate
I     ori          001101             zero-extended immediate
I     xori         001110             zero-extended immediate
I     lui          001111             immediate shifted left 16
I     lw           100011
I     sw           101011
I     beq          000100             resolved in EX
I     bne          000101             resolved in EX
I     bltz         000001             tests the sign bit of rs; rt field ignored
J     j            000010
```

## Hazard handling

**Data hazards.** The forwarding unit compares the source registers in EX
against the destination registers in MEM and WB. A match forwards the newer
value into the ALU input mux, with MEM taking priority over WB so the most
recent write wins. `$r0` is excluded from forwarding.

**Load-use hazards.** Forwarding alone cannot fix a load followed immediately by
a dependent instruction, because the data is not available until MEM. The hazard
detection unit spots a `lw` in EX whose destination matches either source
register in ID, then holds the PC and IF/ID for one cycle and flushes ID/EX.
After the bubble, the consumer reaches EX exactly as the load reaches WB, so the
WB forwarding path supplies the loaded value.

**Control hazards.** Branches and jumps resolve in EX using forwarded operand
values, so a branch never compares against a stale register. When one is taken,
both IF/ID and ID/EX are flushed, giving a 2-cycle penalty. There is no branch
predictor; the design is predict-not-taken.

## Test program

`icache.vhd` holds a 23-instruction program, annotated inline with its assembly
and expected results. It covers every implemented instruction plus a store/load
pair, a not-taken branch, a taken branch, a negative-value `bltz`, and a jump
back to the start:

```
 0  addi $r1, $r0, 5        # r1 = 5
 1  addi $r2, $r0, 3        # r2 = 3
 2  add  $r3, $r1, $r2      # r3 = 8   back-to-back dependency, forwarded
 3  sub  $r4, $r1, $r2      # r4 = 2
 4  and  $r5, $r1, $r2      # r5 = 1
 5  or   $r6, $r1, $r2      # r6 = 7
 6  slt  $r7, $r2, $r1      # r7 = 1
 7  sw   $r3, 0($r0)        # mem[0] = 8
 8  lw   $r8, 0($r0)        # r8 = 8
 9  beq  $r1, $r2, +1       # not taken
10  bne  $r1, $r2, +1       # taken, skips to 12
11  nop
12  addi $r9, $r0, -1       # r9 = -1
13  bltz $r9, +1            # taken, skips to 15
14  nop
15  xor  $r10, $r1, $r2     # r10 = 6
16  nor  $r11, $r1, $r2     # r11 = 0xFFFFFFF8
17  andi $r12, $r1, 3       # r12 = 1
18  ori  $r13, $r1, 3       # r13 = 7
19  lui  $r14, 1            # r14 = 0x00010000
20  slti $r15, $r1, 10      # r15 = 1
21  xori $r16, $r1, 7       # r16 = 2
22  j    0                  # loop back to start
```

## License

MIT, see [LICENSE](LICENSE).
