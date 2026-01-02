/*--------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------CORE CONFIG--------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------*/

/*===========================================================================
3. Advanced Mode (Pipelined – 1 Cycle per Instruction)
When FIVES_PIPELINE_EN is defined, the CPU uses pipeline techniques to overlap multiple i-
-nstruction stages (e.g., while one instruction is in Decode, another can be in Execute).
With this approach, once the pipeline is filled, the CPU can achieve a throughput of 1 in-
-struction per clock cycle, significantly improving performance compared to non-pipelined
modes.
                            `define FIVES_PIPELINE_EN
===========================================================================*/
`define FIVES_PIPELINE_EN


/*===========================================================================
The macro DEBUG_EN is used as a conditional compilation flag for debugging.
When this macro is enabled, additional debug information (such as internal 
signals, intermediate values, or status messages) will be displayed.

It is recommended to enable DEBUG_EN only during simulation or testing, so 
you can observe all relevant parameters and verify the design’s behavior.
For synthesis or real hardware implementation, DEBUG_EN should remain disabled
to avoid unnecessary logic, improve performance, and save resources.
                            `define DEBUG_EN
===========================================================================*/
//`define DEBUG_EN







/*--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------INSTRUCTION ENABLE----------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------------
These two Verilog defines are used to enable optional RISC-V ISA extensions in the processor
design. The first define, COMPRESSED_EXTENTIONS, enables the Compressed (C) extension, which
allows the CPU to execute 16-bit compressed instructions instead of the standard 32-bit for-
-mat, reducing code size and improving instruction fetch efficiency. The second define, MUL-
-TIPLY_DIVIDE_EXTENSIONS, enables the Multiply/Divide (M) extension, which adds hardware su-
-pport for integer multiplication and division operations, allowing instructions such as mu-
-l, mulh, div, and rem to be executed directly by the ALU. These defines are typically plac-
-ed in a common header file like defines.vh, allowing different modules (decoder, ALU, cont-
-rol unit, etc.) to conditionally include the corresponding logic using ifdef directives, m-
-aking the CPU configurable and easy to customize.
----------------------------------------------------------------------------------*/

`define COMPRESSED_EXTENTIONS
`define MULTIPLY_DIVIDE_EXTENSIONS
`define FLOATING_POINT_EXTENSIONS


/*--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------DIVISION OPERATION----------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------
The DSP-based implementation achieves the highest operating frequency, since it leverages
dedicated hardware multipliers optimized within the FPGA fabric. It also provides the sho-
-rtest computation latency (single-cycle or near single-cycle operation). However, it con-
-sumes the least amount of general logic resources. The main drawback of the DSP approach 
is limited flexibility: it depends heavily on the specific FPGA architecture. Some devices
 may not provide enough DSP blocks or may implement them differently, requiring design mo-
-dification or reconfiguration for portability across FPGA families. (XC7Z020CLG400-2)
                                        `define USE_DSP


The Radix-4 15-cycle design offers a balanced trade-off. It requires slightly more logic t-
-han the DSP-based version but significantly less than the 9-cycle version. Its computatio-
-n latency is higher than the DSP multiplier but lower than the 9-cycle version, making it
 a good compromise between speed and resource efficiency. Because it is implemented purely
 with logic elements, it remains portable across FPGA platforms.
                                    `define RADIX_4_15CYC


The Radix-4 9-cycle implementation targets faster throughput at the expense of resource eff-
iciency. By processing more partial products per cycle, it reduces the number of cycles nee-
ded for one multiplication. However, this parallelism increases the logic depth and resourc-
e consumption, which in turn limits the achievable maximum frequency. As a result, its fmax
 is typically the lowest among the three configurations.
                                    `define RADIX_4_9CYC
            

In summary, the maximum frequency follows 15CYC > 9CYC > DSP, the resource utilization foll-
-ows DSP < 15CYC < 9CYC, and the latency follows 15CYC < 9CYC < DSP. The DSP option is fast-
-est but least flexible, while the Radix-4 implementations trade performance for portabilit-
-y and tunable resource usage.
-----------------------------------------------------------------------------------*/

//`define RADIX_8
`define RADIX_4
//`define DIV_USE_DSP


/*--------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------MULTIPLY OPERATION----------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------
The DSP-based implementation achieves the highest operating frequency, since it leverages
dedicated hardware multipliers optimized within the FPGA fabric. It also provides the sho-
-rtest computation latency (single-cycle or near single-cycle operation). However, it con-
-sumes the least amount of general logic resources. The main drawback of the DSP approach 
is limited flexibility: it depends heavily on the specific FPGA architecture. Some devices
 may not provide enough DSP blocks or may implement them differently, requiring design mo-
-dification or reconfiguration for portability across FPGA families. (XC7Z020CLG400-2)
                                        `define USE_DSP


The Radix-4 15-cycle design offers a balanced trade-off. It requires slightly more logic t-
-han the DSP-based version but significantly less than the 9-cycle version. Its computatio-
-n latency is higher than the DSP multiplier but lower than the 9-cycle version, making it
 a good compromise between speed and resource efficiency. Because it is implemented purely
 with logic elements, it remains portable across FPGA platforms.
                                    `define RADIX_4_15CYC


The Radix-4 9-cycle implementation targets faster throughput at the expense of resource eff-
iciency. By processing more partial products per cycle, it reduces the number of cycles nee-
ded for one multiplication. However, this parallelism increases the logic depth and resourc-
e consumption, which in turn limits the achievable maximum frequency. As a result, its fmax
 is typically the lowest among the three configurations.
                                    `define RADIX_4_9CYC
            

In summary, the maximum frequency follows 15CYC > 9CYC > DSP, the resource utilization foll-
-ows DSP < 15CYC < 9CYC, and the latency follows 15CYC < 9CYC < DSP. The DSP option is fast-
-est but least flexible, while the Radix-4 implementations trade performance for portabilit-
-y and tunable resource usage.
-----------------------------------------------------------------------------------*/
//RADIX_4_15CYC đang lỗi thôi bỏ đi không dùng nữa. Lười sửa kệ

`define RADIX_4_9CYC
//`define RADIX_4_15CYC
//`define MUL_USE_DSP