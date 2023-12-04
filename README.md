# Computer Architecture 2023

This repository is a collection of practices from the subject Computer Architecture.

# SUMMARY OF THE MODULES

## Implemented in practice 1:

### flopr
A resettable flip-flop

Parameters:
- Input
     - clk 1b
     - reset 1b
     - d Nb
- Output
     - q Nb

always_ff is activated every time there is a positive (rising) clock edge and another positive reset edge. There is an if which determines the behavior of the flip-flop, when reset is positive it sets q (output) to all zeros, on the other hand the else copies the value of input d into q.
In summary, this flopr module represents a flip-flop that can be reset to zero when the reset signal is activated, and copies the input data d to the output q when the reset is not activated.


### signext

Perform a sign extension

Parameters:
- Input
     - at 32b
- Output
     - and 64b

always_comb is a combinational process, that is, the output 'y' is calculated based on the input 'a' immediately in response to any change in 'a'. casez(a[31:21]), examine bits 31 to 21 of 'a';
in the case of LDUR and STUR: if the 11 bits follow the pattern of these instructions (bit ? does not matter if it is 0 or 1), bit a[20] is extended to bit 55, and copied to[20:12 ] in bits y[54:46].
The other cases are similar, there is a generic 'default' case which sets 'y' to all its bits 0 if it does not meet any of the previous cases.

### alu

This ALU performs various logical and arithmetic operations on two operands a and b, controlled by the ALUControl control signal, and produces a result along with a zero signal indicating whether the result is zero.

Parameters:
- Input
     - at 64b
     - b 64b
     - ALUControl 4b
- Output
     - result 64b
     - zero 1b

always_comb, this block is executed every time any of the inputs change, cases are made on the ALUControl bits, where it is determined which operation is executed on the variables a and b (a & b AND, a | b OR, a + b SUM , a - b SUBTRACT, b PASS B) and the result is saved in result, then the default case puts result in all 0s, and then there is a conditional outside the casez where if result == 0, zero is 1.

### imem

It appears to be an implementation of a ROM (Read-Only Memory) in SystemVerilog with a word size of 32 bits. ROM stores data that does not change during system operation and allows that data to be read based on an input address addr.

Parameters:
- Input
     - addr 6b
- Output
     - q 32b

logic [0:N-1] ROM [0:63];: This line declares an array called ROM of 64 elements, each of which is a 32-bit word.
In the initial block the ROM memory is initialized with the specified data from 32b.
Then it assigns q the ROM value at the index given by addr.

### regfile

It appears to be a log file in SystemVerilog. A register file is a component in a processor architecture that stores register values and allows reading and writing of those values.

Parameters:
- Input
     - clk 1b
     - we3 1b
     - ra1 4b
     - ra2 4b
     - wa3 4b
     - wd3 64b
- Output
     - rd1 64b
     - rd2 64b

Where: we3 controls whether to write to the register file, ra1 and ra2 carry the register addresses from which data will be read, wa3 carries the register address to which the data will be written, wd3 carries the data to be written to the register file, rd1 and rd2 will carry the data read from addresses ra1 and ra2, respectively.

logic [63:0] REG [0:31]: This line declares an array called REG of 32 registers, each 64 bits wide. These registers represent the processor's register file.
In the always_ff block, it is activated on each rising edge of the clock that updates the register file if we3 is true and the address wa3 is not 31 (this to avoid writing to register 31, which is a reserved register).
In the always_comb block, if ra1 is equal to wa3, wa3 is checked to be other than 31, if this happens, rd1 is set to wd3 (write), otherwise (if ra1 !== wa3), the value is read of REG[ra1] (read). Then another if that verifies if ra2 is equal to wa3, and the same thing happens as the previous if, except that otherwise the value REG[ra2] is read.

In short, this regfile module represents a register file with 32 registers of 64 bits each. It allows reading and writing data to these registers based on the control signals and addresses provided. When reading from a register that is being written at the same time, you choose between the write value (wd3) or the value of the original register.


### maindec

Main decoder, appears to be a component in a processor design that decodes an instruction represented by the Op signal to drive various control signals within the processor.

Parameters:
- Input
     - Op 11b
- Output
     - Reg2Loc 1b
     - ALUSrc 1b
     - MemtoReg 1b
     - RegWrite 1b
     - MemRead 1b
     - MemWrite 1b
     - Branch 1b
     - AlUOp 2b

Where Op determines the operation or instruction to be decoded, and all the others, the control signals, where according to the practical table, must be assigned.

In the always_comb block it does an analysis by Op cases, where depending on what Op is, it is an instruction, such as, LDUR, STUR, CBZ, ADD and SUB, AND and ORR, and we assign each one as it is in the table, the default case does not perform any of the above operations.

###fetch

It appears to be a stage of the fetch stage in a processor. Its main function is to calculate the memory address of the next instruction to be fetched in the instruction memory (IMem) and provide this address to the fetch stage.

Parameters:
- Input
     - PCSrc_F 1b
     - clk 1b
     - reset 1b
     - PCBranch_F 64b
- Output
     - imem_addr_F 64b

Where: PCSrc_F indicates whether the address of the next instruction comes from the output of the previous stage or the output of the execution stage, it is a control signal that controls the source selection for the instruction address. PCBranch_F carries the address of the jump instruction calculated at the execution stage. imem_addr_F carries the memory address of the next instruction to be fetched in the instruction memory (IMem).

This module builds the following connections: q of 64b that communicates with the flopr module, addB and added of the adder module, and finally d of 64b that communicates with the mux2 module.

flopr PC(clk, reset, d, q): stores the address of the next instruction in q.
adder Add(q, addB, added): Adds the value stored in q with the value addB and places the result in added. This appears to be part of the jump instruction address calculation.
mux2 MUX(added, PCBranch_F, PCSrc_F, d): This mux2 module selects between the calculated address (added) and the potential branch address (PCBranch_F) based on the control signal PCSrc_F and places the selected address in d.

Then in the always_ff block which is activated with the positive edge of clk, it assigns the memory address calculated in 'q' to 'imem_addr_F', which is used to search for the next instruction in the instruction memory.

### execute

the execution stage of a processor.

Parameters:
- Input
     - AluSrc 1b
     - AluControl 4b
     - PC_E 64b
     - signImm_E 64b
     - readData1_E 64b
     - readData2_E 64b
- Output
     - PCBranch_E 64b
     - aluResult_E 64b
     - writeData_E 64b
     - zero_E 1b

Where:
AluSrc controls the source selection for ALU (Arithmetic Logic Unit) operation. AluControl carries the control code to configure the operation of the ALU. PC_E carries the address of the program counter. signImm_E carries a signed immediate value. readData1_E and readData2_E carry data from read registers. PCBranch_E carries the jump address or the address of the next instruction to be executed. aluResult_E carries the result of the ALU operation. writeData_E carries the data that must be written (possibly in registers). zero_E indicates whether the ALU result is zero.

Two 64-bit buses are created, outShift and outMux.

Then call functions from other modules:
adder Add(PC_E, outShift, PCBranch_E) adds the address of the program counter (PC_E) with the value stored in outShift, and the result is placed in PCBranch_E. This may be related to the calculation of jump directions.
mux2 MUX(readData2_E, signImm_E, AluSrc, outMux) selects between readData2_E and signImm_E as input to the ALU based on the AluSrc control signal, and the result is placed into outMux.
alu ALU(readData1_E, outMux, AluControl, aluResult_E, zero_E) performs an operation on the ALU using readData1_E and outMux as inputs, along with the AluControl control signal. The result is placed in aluResult_E, and the zero_E signal indicates whether the result is zero.

Finally, the value of readData2_E is assigned to writeData_E, which could be related to writing data to registers or memory.

In summary, the execute module represents the execution stage of a processor and performs execution operations such as arithmetic and logical calculations, jump calculations, and setting corresponding control signals based on the provided inputs. The outputs reflect the results of these operations and are used in subsequent stages of the processor.

### adder

implements a sum of two N-bit numbers

Parameters:
- Input
     - at 64b
     - b 64b
- Output
     - and 64b

Save in and the sum between a and b.

### mux2

N-bit 2-to-1 multiplexer, takes two data inputs (d0 and d1 in this case), along with a select signal(s), and selects one of the two data inputs to route to the output and based on of the value of the selection signal.

Parameters:
- Input
     - d0 64b
     - d1 64b
     - s 1b
- Output
     - and 64b

Save in y the value of d1 if s is 1,otherwise the value of d0 is saved

### sl2

Shift Left 2, performs a 2-bit shift left operation on a data input a.

Parameters:
- Input
     - at 64b
- Output
     - and 64b

Stores in the least significant bits of y (y[0], y[1]) the value 0, so that these two bits are discarded when doing the shift left, and saves in y from bit 2 to the last, the 62 bits from a, leaving something like this: 0b ???? ...??00 -> 64b

## Given by teachers

### memory

### dmem

### decode

### datapath

### controller

### avalanche
