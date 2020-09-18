# UART

## Description

Our purpose is to design a Universal Asynchronous Receiver Transmitter(UART).
In the transmitter, each time a 7bits ASCII code is sent serially. At first, a `start-bit` is sent. Then `parity` and 7bits data is sent respectively. And finally, a `stop-bit` is sent (10bits in total).
In the receiver, after receiving `start-bit`, 8bits of data and `parity` is serially received and stored in an 8bits register.
After the connecting transmitter and receiver, we will have a complete UART module.

## Design

At first, we define our UART protocol. firstly we should put the data we intend to send on `data_in`, then assert the `in_ready` to take out the transmitter state from `IDLE`. As mentioned in description `start-bit`, `parity`, 7bits data, `stop-bit` is sent respectively. 
In UART a parameter is used to synchronize transmitter and receiver called `buad_rate` which shows how many bits are sent per second. I use another parameter called `CLKS_PER_BIT` which shows how many clocks do we need to transfer a single bit and this parameter is obtained by dividing the CPU clock rate by `baud rate`. To have easier simulation, I assumed that `CLOCKS_PER_BIT` is 2. 
Receiver is initially at `IDLE` state and after deasserting `RX` it goes to `START_BIT` state and checks whether the `start-bit` is still zero or not for `CLOCKS_PER_BIT-1` clock cycles. If there is any fault it goes back to `IDLE` state. Then in `parity` and receiving data states, receives corresponding data after 2 clock cycles and finally, it remains in `stop` state for 2 clocks cycles and assert `out_valid` for one clock cycle and returns to `IDLE` state waiting for `RX` to be deasserted. Note that in the final state `TX` must be 1 which means ends of transmitting so that every time by deasserting it signals the receiver that a new transfer is started.
Receiver stores receiving data in a register called `current_data` and whenever the transfer is finished it will move to the output of receiver module. LSB of this register is `parity` and others are data. 

## Simulation

In the following image, you can see signals. The bottommost signal is `current_data` of receiver. The next signal from the bottom is the wire between receiver and sender(transmitter). Between to yellow pointers sender(transmitter) is at `IDLE` state. You can see `TX` is zero for 2 clocks which means the transfer has started. Then send corresponding data bits by 2 clocks delay(due to `CLOCKS_PER_BIT`) which you can see changes of `current_data` after each 2 clock cycles. you can use yellow pointer to ease of following images.

https://github.com/sepehrMSP/digital-system-design-laboratory/tree/master/UART/images/uart1.JPG

https://github.com/sepehrMSP/digital-system-design-laboratory/tree/master/UART/images/uart2.JPG

https://github.com/sepehrMSP/digital-system-design-laboratory/tree/master/UART/images/uart3.JPG

https://github.com/sepehrMSP/digital-system-design-laboratory/tree/master/UART/images/uart4.JPG

As you see in the above image 2 clocks after changing `current_data` to the data originally sent, output of UART changes, and assert `out_ready` for one clock cycle. In the next images, you can see the transfer of the next data which is `0101010`.

https://github.com/sepehrMSP/digital-system-design-laboratory/tree/master/UART/images/uart5.JPG

https://github.com/sepehrMSP/digital-system-design-laboratory/tree/master/UART/images/uart6.JPG

https://github.com/sepehrMSP/digital-system-design-laboratory/tree/master/UART/images/uart7.JPG

https://github.com/sepehrMSP/digital-system-design-laboratory/tree/master/UART/images/uart8.JPG
