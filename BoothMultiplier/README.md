# Design a multiplier

## Description

Our purpose is to design a multiplier unit that uses the Booth algorithm for computation. We intend to design the Control path and Data path separately and at the end by connecting these two make a multiplier.

## Design 

Our top module is `booth_multiplier` which contains and connects the Data path and the Control path. Its functionality is so that every 4(this number is `size` which is defined in `constants.v` and shows inputs width) clock cycles shows the result. Controler has two signals `last_round` and `first_round` which by asserting `first_round` data path load the inputs and starts its work. Although the Controler has a variable named `counter` that counts how many clock cycles have been passed and when this value equals to `size` (i.e last clock) the Controler asserts `last_round` and put the computed number by data path on the `booth_multiplier` output. Also during the process of multiplication, we consider value 0 for the output. 

## simulation

As you see in the two pictures below when `last_round` is 1 the result of the multiplication is moved to `res`. Besides, you can see the result of every step of the Booth algorithm in `temp_result`. 
***NOTE that in the simulation we've changed the size to 5. ***

![Booth multiplier](https://github.com/sepehrMSP/digital-system-design-laboratory/tree/master/BoothMultiplier/images/booth1.JPG)

![Booth multiplier](https://github.com/sepehrMSP/digital-system-design-laboratory/tree/master/BoothMultiplier/images/booth2.JPG)

***Note1: The report pdf is provided in Persian***

***Note2: Verilog codes has been synthesised and tested on Intel FPGAs Cyclone II EP2C35F672C6***

