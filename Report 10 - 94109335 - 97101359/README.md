# Simple Stack Base CPU

## CPU arichitecture 

To design our stack base cpu I use following link with some changes:
‫‪https://users.ece.cmu.e‬‬du/~koopman/stack_computers/sec3_2.html‬‬

Inputs and outputs of our module are clk, reset, in, out, error respectively, which reset is asynchronous and every time this signal is asserted every signal will be set to zero and our desire instructions will initilize in the memory. Memory[255:248] is dedicated to memory-maped IO, so that memory[255], memory[254], memory[253] are maped to output, input and error signals respectively.
I used a register called 'top_of_stack' which holds the values that are going to use in ADD and SUB instructions( in particular, the first operand).
Memory has a direct access to value stored in MAR and memory instructions fetch and decode are done in 3 cycles. Moreover, instructions length is 12 bit( 4 bits opcode and 8 bits data) and every instruction is saved in 2 memory word due to memory width is 8 bits. After this step cpu goes to execution state. For easier implementation every instruction considered to be executed in 2 clock cycles.
