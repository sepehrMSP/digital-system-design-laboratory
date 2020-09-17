# Simple Stack Base CPU

## Description

Our purpose is to design a stack-based processor with 8 8bits registers. This processor has 8 instructions in its ISA. Besides, it has 256 words (8bits) memory which its last 8 words (i.e from F8 to FF) are reserved for Memory-Mapped I/O. 
Supporting instructions are listed below:

1. 0000  PUSHC C
This instruction pushes a constant 8bits value into the stack.

2. 0001  PUSH  M
This instruction pushes value stored in memory[M] into the stack.

3. 0010 POP M
This instruction pops a value from the stack and stores it in memory[M].

4. 0011 JUMP 
This instruction pops a value from the stack and stores it in the PC.

5. 0100 JZ
This instruction will pop a value from the stack and if the zero flag is 1 then store the value in the PC.

6. 0101 JS
This instruction will pop a value from the stack and if the sign flag is 1 then store the value in the PC.

7. 0110 ADD
This instruction adds two upper values of the stack together and pops them from the stack and pushes the result in the stack.

8. 0111 SUB
This instruction subtracts two upper values of the stack together and pops them from the stack and pushes the result in the stack.

As said above, in this processor we have two flag S and Z which are changed only when the instruction is ADD or SUB, and in other instructions, their values remain unchanged.
Besides, all of the computations are signed and in the format of 2's complement. 
Now we want to write a machine language program that inputs an 8bits number(like X) and then compute Y = ((X+23)\*2)-12. and finally, show the value of Y by seven segments.
The error signal is asserted either the input is negative or the final result is bigger than 127. 

## CPU architecture 

To design our stack base CPU I've used the following link with some changes:
‫‪https://users.ece.cmu.e‬‬du/~koopman/stack_computers/sec3_2.html‬‬

Inputs and outputs of our module are clk, reset, in, out, error respectively, which reset is asynchronous and every time this signal is asserted every signal will be set to zero and our desire instructions will initialize in the memory. Memory[255:248] is dedicated to Memory-Mapped IO, so that memory[255], memory[254], memory[253] are mapped to output, input, and error signals respectively.
I used a register called 'top_of_stack' which holds the values that are going to use in ADD and SUB instructions (in particular, the first operand).
Memory has direct access to the value stored in MAR and memory instructions fetch and decode are done in 3 cycles. Moreover, instructions length is 12 bit( 4 bits opcode and 8 bits data) and every instruction is saved in 2 memory words due to memory width is 8 bits. After this step CPU goes to execution state. For easier implementation, every instruction is considered to be executed in 2 clock cycles.

## Sevensegment and BCD

BCD module gets its inputs from outputs of CPU in the format of an 8bits number and determines ones, tens, hundreds of this number in three 4 bits output, and each of these 4 bits will be given as an input to seven segment module.

