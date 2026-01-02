# Register map

Created with [Corsair](https://github.com/esynr3z/corsair) v1.0.4.

## Conventions

| Access mode | Description               |
| :---------- | :------------------------ |
| rw          | Read and Write            |
| rw1c        | Read and Write 1 to Clear |
| rw1s        | Read and Write 1 to Set   |
| ro          | Read Only                 |
| roc         | Read Only to Clear        |
| roll        | Read Only / Latch Low     |
| rolh        | Read Only / Latch High    |
| wo          | Write only                |
| wosc        | Write Only / Self Clear   |

## Register map summary

Base address: 0x30000000

| Name                     | Address    | Description |
| :---                     | :---       | :---        |
| [P_PRIORITY1](#p_priority1) | 0x00000004 | Priority Register IRQ1 (3-bit, 8 levels) |
| [P_PRIORITY2](#p_priority2) | 0x00000008 | Priority Register IRQ2 (3-bit, 8 levels) |
| [P_PRIORITY3](#p_priority3) | 0x0000000c | Priority Register IRQ3 (3-bit, 8 levels) |
| [P_PRIORITY4](#p_priority4) | 0x00000010 | Priority Register IRQ4 (3-bit, 8 levels) |
| [P_PRIORITY5](#p_priority5) | 0x00000014 | Priority Register IRQ5 (3-bit, 8 levels) |
| [P_PRIORITY6](#p_priority6) | 0x00000018 | Priority Register IRQ6 (3-bit, 8 levels) |
| [P_PRIORITY7](#p_priority7) | 0x0000001c | Priority Register IRQ7 (3-bit, 8 levels) |
| [P_PRIORITY8](#p_priority8) | 0x00000020 | Priority Register IRQ8 (3-bit, 8 levels) |
| [P_PRIORITY9](#p_priority9) | 0x00000024 | Priority Register IRQ9 (3-bit, 8 levels) |
| [P_PRIORITY10](#p_priority10) | 0x00000028 | Priority Register IRQ10 (3-bit, 8 levels) |
| [P_PRIORITY11](#p_priority11) | 0x0000002c | Priority Register IRQ11 (3-bit, 8 levels) |
| [P_PRIORITY12](#p_priority12) | 0x00000030 | Priority Register IRQ12 (3-bit, 8 levels) |
| [P_PRIORITY13](#p_priority13) | 0x00000034 | Priority Register IRQ13 (3-bit, 8 levels) |
| [P_PRIORITY14](#p_priority14) | 0x00000038 | Priority Register IRQ14 (3-bit, 8 levels) |
| [P_PRIORITY15](#p_priority15) | 0x0000003c | Priority Register IRQ15 (3-bit, 8 levels) |
| [P_PRIORITY16](#p_priority16) | 0x00000040 | Priority Register IRQ16 (3-bit, 8 levels) |
| [P_PRIORITY17](#p_priority17) | 0x00000044 | Priority Register IRQ17 (3-bit, 8 levels) |
| [P_PRIORITY18](#p_priority18) | 0x00000048 | Priority Register IRQ18 (3-bit, 8 levels) |
| [P_PRIORITY19](#p_priority19) | 0x0000004c | Priority Register IRQ19 (3-bit, 8 levels) |
| [P_PRIORITY20](#p_priority20) | 0x00000050 | Priority Register IRQ20 (3-bit, 8 levels) |
| [P_PRIORITY21](#p_priority21) | 0x00000054 | Priority Register IRQ21 (3-bit, 8 levels) |
| [P_PRIORITY22](#p_priority22) | 0x00000058 | Priority Register IRQ22 (3-bit, 8 levels) |
| [P_PRIORITY23](#p_priority23) | 0x0000005c | Priority Register IRQ23 (3-bit, 8 levels) |
| [P_PRIORITY24](#p_priority24) | 0x00000060 | Priority Register IRQ24 (3-bit, 8 levels) |
| [P_PRIORITY25](#p_priority25) | 0x00000064 | Priority Register IRQ25 (3-bit, 8 levels) |
| [P_PRIORITY26](#p_priority26) | 0x00000068 | Priority Register IRQ26 (3-bit, 8 levels) |
| [P_PRIORITY27](#p_priority27) | 0x0000006c | Priority Register IRQ27 (3-bit, 8 levels) |
| [P_PRIORITY28](#p_priority28) | 0x00000070 | Priority Register IRQ28 (3-bit, 8 levels) |
| [P_PRIORITY29](#p_priority29) | 0x00000074 | Priority Register IRQ29 (3-bit, 8 levels) |
| [P_PRIORITY30](#p_priority30) | 0x00000078 | Priority Register IRQ30 (3-bit, 8 levels) |
| [P_PRIORITY31](#p_priority31) | 0x0000007c | Priority Register IRQ31 (3-bit, 8 levels) |
| [P_PRIORITY32](#p_priority32) | 0x00000080 | Priority Register IRQ32 (3-bit, 8 levels) |
| [P_PRIORITY33](#p_priority33) | 0x00000084 | Priority Register IRQ33 (3-bit, 8 levels) |
| [P_PRIORITY34](#p_priority34) | 0x00000088 | Priority Register IRQ34 (3-bit, 8 levels) |
| [P_PRIORITY35](#p_priority35) | 0x0000008c | Priority Register IRQ35 (3-bit, 8 levels) |
| [P_PRIORITY36](#p_priority36) | 0x00000090 | Priority Register IRQ36 (3-bit, 8 levels) |
| [P_PRIORITY37](#p_priority37) | 0x00000094 | Priority Register IRQ37 (3-bit, 8 levels) |
| [P_PRIORITY38](#p_priority38) | 0x00000098 | Priority Register IRQ38 (3-bit, 8 levels) |
| [P_PRIORITY39](#p_priority39) | 0x0000009c | Priority Register IRQ39 (3-bit, 8 levels) |
| [P_PRIORITY40](#p_priority40) | 0x000000a0 | Priority Register IRQ40 (3-bit, 8 levels) |
| [P_PRIORITY41](#p_priority41) | 0x000000a4 | Priority Register IRQ41 (3-bit, 8 levels) |
| [P_PRIORITY42](#p_priority42) | 0x000000a8 | Priority Register IRQ42 (3-bit, 8 levels) |
| [P_PRIORITY43](#p_priority43) | 0x000000ac | Priority Register IRQ43 (3-bit, 8 levels) |
| [P_PRIORITY44](#p_priority44) | 0x000000b0 | Priority Register IRQ44 (3-bit, 8 levels) |
| [P_PRIORITY45](#p_priority45) | 0x000000b4 | Priority Register IRQ45 (3-bit, 8 levels) |
| [P_PRIORITY46](#p_priority46) | 0x000000b8 | Priority Register IRQ46 (3-bit, 8 levels) |
| [P_PRIORITY47](#p_priority47) | 0x000000bc | Priority Register IRQ47 (3-bit, 8 levels) |
| [P_PRIORITY48](#p_priority48) | 0x000000c0 | Priority Register IRQ48 (3-bit, 8 levels) |
| [P_PRIORITY49](#p_priority49) | 0x000000c4 | Priority Register IRQ49 (3-bit, 8 levels) |
| [P_PRIORITY50](#p_priority50) | 0x000000c8 | Priority Register IRQ50 (3-bit, 8 levels) |
| [P_PRIORITY51](#p_priority51) | 0x000000cc | Priority Register IRQ51 (3-bit, 8 levels) |
| [P_PRIORITY52](#p_priority52) | 0x000000d0 | Priority Register IRQ52 (3-bit, 8 levels) |
| [P_PRIORITY53](#p_priority53) | 0x000000d4 | Priority Register IRQ53 (3-bit, 8 levels) |
| [P_PRIORITY54](#p_priority54) | 0x000000d8 | Priority Register IRQ54 (3-bit, 8 levels) |
| [P_PRIORITY55](#p_priority55) | 0x000000dc | Priority Register IRQ55 (3-bit, 8 levels) |
| [P_PRIORITY56](#p_priority56) | 0x000000e0 | Priority Register IRQ56 (3-bit, 8 levels) |
| [P_PRIORITY57](#p_priority57) | 0x000000e4 | Priority Register IRQ57 (3-bit, 8 levels) |
| [P_PRIORITY58](#p_priority58) | 0x000000e8 | Priority Register IRQ58 (3-bit, 8 levels) |
| [P_PRIORITY59](#p_priority59) | 0x000000ec | Priority Register IRQ59 (3-bit, 8 levels) |
| [P_PRIORITY60](#p_priority60) | 0x000000f0 | Priority Register IRQ60 (3-bit, 8 levels) |
| [P_PRIORITY61](#p_priority61) | 0x000000f4 | Priority Register IRQ61 (3-bit, 8 levels) |
| [P_PRIORITY62](#p_priority62) | 0x000000f8 | Priority Register IRQ62 (3-bit, 8 levels) |
| [P_PRIORITY63](#p_priority63) | 0x000000fc | Priority Register IRQ63 (3-bit, 8 levels) |
| [P_PRIORITY64](#p_priority64) | 0x00000100 | Priority Register IRQ64 (3-bit, 8 levels) |
| [P_PENDING0](#p_pending0) | 0x00001000 | Pending bits for IRQ1–IRQ31 |
| [P_PENDING1](#p_pending1) | 0x00001004 | Pending bits for IRQ32–IRQ62 |
| [P_ENABLE0](#p_enable0)  | 0x00002000 | Enable bits for IRQ1–IRQ31 |
| [P_ENABLE1](#p_enable1)  | 0x00002004 | Enable bits for IRQ32–IRQ62 |
| [P_THRESHOLD](#p_threshold) | 0x00200000 | Priority threshold register |
| [P_CLAIMCOMPLETE](#p_claimcomplete) | 0x00200004 | Claim/Complete register |

## P_PRIORITY1

Priority Register IRQ1 (3-bit, 8 levels)

Address offset: 0x00000004

Reset value: 0x00000000

![p_priority1](md_img/p_priority1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY1        | 2:0    | rw              | 0x0        | Priority level of IRQ1. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY2

Priority Register IRQ2 (3-bit, 8 levels)

Address offset: 0x00000008

Reset value: 0x00000000

![p_priority2](md_img/p_priority2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY2        | 2:0    | rw              | 0x0        | Priority level of IRQ2. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY3

Priority Register IRQ3 (3-bit, 8 levels)

Address offset: 0x0000000c

Reset value: 0x00000000

![p_priority3](md_img/p_priority3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY3        | 2:0    | rw              | 0x0        | Priority level of IRQ3. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY4

Priority Register IRQ4 (3-bit, 8 levels)

Address offset: 0x00000010

Reset value: 0x00000000

![p_priority4](md_img/p_priority4.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY4        | 2:0    | rw              | 0x0        | Priority level of IRQ4. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY5

Priority Register IRQ5 (3-bit, 8 levels)

Address offset: 0x00000014

Reset value: 0x00000000

![p_priority5](md_img/p_priority5.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY5        | 2:0    | rw              | 0x0        | Priority level of IRQ5. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY6

Priority Register IRQ6 (3-bit, 8 levels)

Address offset: 0x00000018

Reset value: 0x00000000

![p_priority6](md_img/p_priority6.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY6        | 2:0    | rw              | 0x0        | Priority level of IRQ6. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY7

Priority Register IRQ7 (3-bit, 8 levels)

Address offset: 0x0000001c

Reset value: 0x00000000

![p_priority7](md_img/p_priority7.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY7        | 2:0    | rw              | 0x0        | Priority level of IRQ7. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY8

Priority Register IRQ8 (3-bit, 8 levels)

Address offset: 0x00000020

Reset value: 0x00000000

![p_priority8](md_img/p_priority8.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY8        | 2:0    | rw              | 0x0        | Priority level of IRQ8. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY9

Priority Register IRQ9 (3-bit, 8 levels)

Address offset: 0x00000024

Reset value: 0x00000000

![p_priority9](md_img/p_priority9.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY9        | 2:0    | rw              | 0x0        | Priority level of IRQ9. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY10

Priority Register IRQ10 (3-bit, 8 levels)

Address offset: 0x00000028

Reset value: 0x00000000

![p_priority10](md_img/p_priority10.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY10       | 2:0    | rw              | 0x0        | Priority level of IRQ10. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY11

Priority Register IRQ11 (3-bit, 8 levels)

Address offset: 0x0000002c

Reset value: 0x00000000

![p_priority11](md_img/p_priority11.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY11       | 2:0    | rw              | 0x0        | Priority level of IRQ11. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY12

Priority Register IRQ12 (3-bit, 8 levels)

Address offset: 0x00000030

Reset value: 0x00000000

![p_priority12](md_img/p_priority12.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY12       | 2:0    | rw              | 0x0        | Priority level of IRQ12. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY13

Priority Register IRQ13 (3-bit, 8 levels)

Address offset: 0x00000034

Reset value: 0x00000000

![p_priority13](md_img/p_priority13.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY13       | 2:0    | rw              | 0x0        | Priority level of IRQ13. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY14

Priority Register IRQ14 (3-bit, 8 levels)

Address offset: 0x00000038

Reset value: 0x00000000

![p_priority14](md_img/p_priority14.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY14       | 2:0    | rw              | 0x0        | Priority level of IRQ14. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY15

Priority Register IRQ15 (3-bit, 8 levels)

Address offset: 0x0000003c

Reset value: 0x00000000

![p_priority15](md_img/p_priority15.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY15       | 2:0    | rw              | 0x0        | Priority level of IRQ15. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY16

Priority Register IRQ16 (3-bit, 8 levels)

Address offset: 0x00000040

Reset value: 0x00000000

![p_priority16](md_img/p_priority16.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY16       | 2:0    | rw              | 0x0        | Priority level of IRQ16. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY17

Priority Register IRQ17 (3-bit, 8 levels)

Address offset: 0x00000044

Reset value: 0x00000000

![p_priority17](md_img/p_priority17.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY17       | 2:0    | rw              | 0x0        | Priority level of IRQ17. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY18

Priority Register IRQ18 (3-bit, 8 levels)

Address offset: 0x00000048

Reset value: 0x00000000

![p_priority18](md_img/p_priority18.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY18       | 2:0    | rw              | 0x0        | Priority level of IRQ18. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY19

Priority Register IRQ19 (3-bit, 8 levels)

Address offset: 0x0000004c

Reset value: 0x00000000

![p_priority19](md_img/p_priority19.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY19       | 2:0    | rw              | 0x0        | Priority level of IRQ19. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY20

Priority Register IRQ20 (3-bit, 8 levels)

Address offset: 0x00000050

Reset value: 0x00000000

![p_priority20](md_img/p_priority20.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY20       | 2:0    | rw              | 0x0        | Priority level of IRQ20. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY21

Priority Register IRQ21 (3-bit, 8 levels)

Address offset: 0x00000054

Reset value: 0x00000000

![p_priority21](md_img/p_priority21.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY21       | 2:0    | rw              | 0x0        | Priority level of IRQ21. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY22

Priority Register IRQ22 (3-bit, 8 levels)

Address offset: 0x00000058

Reset value: 0x00000000

![p_priority22](md_img/p_priority22.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY22       | 2:0    | rw              | 0x0        | Priority level of IRQ22. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY23

Priority Register IRQ23 (3-bit, 8 levels)

Address offset: 0x0000005c

Reset value: 0x00000000

![p_priority23](md_img/p_priority23.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY23       | 2:0    | rw              | 0x0        | Priority level of IRQ23. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY24

Priority Register IRQ24 (3-bit, 8 levels)

Address offset: 0x00000060

Reset value: 0x00000000

![p_priority24](md_img/p_priority24.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY24       | 2:0    | rw              | 0x0        | Priority level of IRQ24. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY25

Priority Register IRQ25 (3-bit, 8 levels)

Address offset: 0x00000064

Reset value: 0x00000000

![p_priority25](md_img/p_priority25.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY25       | 2:0    | rw              | 0x0        | Priority level of IRQ25. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY26

Priority Register IRQ26 (3-bit, 8 levels)

Address offset: 0x00000068

Reset value: 0x00000000

![p_priority26](md_img/p_priority26.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY26       | 2:0    | rw              | 0x0        | Priority level of IRQ26. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY27

Priority Register IRQ27 (3-bit, 8 levels)

Address offset: 0x0000006c

Reset value: 0x00000000

![p_priority27](md_img/p_priority27.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY27       | 2:0    | rw              | 0x0        | Priority level of IRQ27. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY28

Priority Register IRQ28 (3-bit, 8 levels)

Address offset: 0x00000070

Reset value: 0x00000000

![p_priority28](md_img/p_priority28.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY28       | 2:0    | rw              | 0x0        | Priority level of IRQ28. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY29

Priority Register IRQ29 (3-bit, 8 levels)

Address offset: 0x00000074

Reset value: 0x00000000

![p_priority29](md_img/p_priority29.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY29       | 2:0    | rw              | 0x0        | Priority level of IRQ29. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY30

Priority Register IRQ30 (3-bit, 8 levels)

Address offset: 0x00000078

Reset value: 0x00000000

![p_priority30](md_img/p_priority30.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY30       | 2:0    | rw              | 0x0        | Priority level of IRQ30. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY31

Priority Register IRQ31 (3-bit, 8 levels)

Address offset: 0x0000007c

Reset value: 0x00000000

![p_priority31](md_img/p_priority31.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY31       | 2:0    | rw              | 0x0        | Priority level of IRQ31. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY32

Priority Register IRQ32 (3-bit, 8 levels)

Address offset: 0x00000080

Reset value: 0x00000000

![p_priority32](md_img/p_priority32.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY32       | 2:0    | rw              | 0x0        | Priority level of IRQ32. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY33

Priority Register IRQ33 (3-bit, 8 levels)

Address offset: 0x00000084

Reset value: 0x00000000

![p_priority33](md_img/p_priority33.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY33       | 2:0    | rw              | 0x0        | Priority level of IRQ33. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY34

Priority Register IRQ34 (3-bit, 8 levels)

Address offset: 0x00000088

Reset value: 0x00000000

![p_priority34](md_img/p_priority34.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY34       | 2:0    | rw              | 0x0        | Priority level of IRQ34. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY35

Priority Register IRQ35 (3-bit, 8 levels)

Address offset: 0x0000008c

Reset value: 0x00000000

![p_priority35](md_img/p_priority35.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY35       | 2:0    | rw              | 0x0        | Priority level of IRQ35. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY36

Priority Register IRQ36 (3-bit, 8 levels)

Address offset: 0x00000090

Reset value: 0x00000000

![p_priority36](md_img/p_priority36.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY36       | 2:0    | rw              | 0x0        | Priority level of IRQ36. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY37

Priority Register IRQ37 (3-bit, 8 levels)

Address offset: 0x00000094

Reset value: 0x00000000

![p_priority37](md_img/p_priority37.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY37       | 2:0    | rw              | 0x0        | Priority level of IRQ37. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY38

Priority Register IRQ38 (3-bit, 8 levels)

Address offset: 0x00000098

Reset value: 0x00000000

![p_priority38](md_img/p_priority38.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY38       | 2:0    | rw              | 0x0        | Priority level of IRQ38. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY39

Priority Register IRQ39 (3-bit, 8 levels)

Address offset: 0x0000009c

Reset value: 0x00000000

![p_priority39](md_img/p_priority39.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY39       | 2:0    | rw              | 0x0        | Priority level of IRQ39. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY40

Priority Register IRQ40 (3-bit, 8 levels)

Address offset: 0x000000a0

Reset value: 0x00000000

![p_priority40](md_img/p_priority40.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY40       | 2:0    | rw              | 0x0        | Priority level of IRQ40. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY41

Priority Register IRQ41 (3-bit, 8 levels)

Address offset: 0x000000a4

Reset value: 0x00000000

![p_priority41](md_img/p_priority41.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY41       | 2:0    | rw              | 0x0        | Priority level of IRQ41. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY42

Priority Register IRQ42 (3-bit, 8 levels)

Address offset: 0x000000a8

Reset value: 0x00000000

![p_priority42](md_img/p_priority42.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY42       | 2:0    | rw              | 0x0        | Priority level of IRQ42. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY43

Priority Register IRQ43 (3-bit, 8 levels)

Address offset: 0x000000ac

Reset value: 0x00000000

![p_priority43](md_img/p_priority43.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY43       | 2:0    | rw              | 0x0        | Priority level of IRQ43. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY44

Priority Register IRQ44 (3-bit, 8 levels)

Address offset: 0x000000b0

Reset value: 0x00000000

![p_priority44](md_img/p_priority44.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY44       | 2:0    | rw              | 0x0        | Priority level of IRQ44. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY45

Priority Register IRQ45 (3-bit, 8 levels)

Address offset: 0x000000b4

Reset value: 0x00000000

![p_priority45](md_img/p_priority45.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY45       | 2:0    | rw              | 0x0        | Priority level of IRQ45. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY46

Priority Register IRQ46 (3-bit, 8 levels)

Address offset: 0x000000b8

Reset value: 0x00000000

![p_priority46](md_img/p_priority46.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY46       | 2:0    | rw              | 0x0        | Priority level of IRQ46. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY47

Priority Register IRQ47 (3-bit, 8 levels)

Address offset: 0x000000bc

Reset value: 0x00000000

![p_priority47](md_img/p_priority47.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY47       | 2:0    | rw              | 0x0        | Priority level of IRQ47. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY48

Priority Register IRQ48 (3-bit, 8 levels)

Address offset: 0x000000c0

Reset value: 0x00000000

![p_priority48](md_img/p_priority48.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY48       | 2:0    | rw              | 0x0        | Priority level of IRQ48. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY49

Priority Register IRQ49 (3-bit, 8 levels)

Address offset: 0x000000c4

Reset value: 0x00000000

![p_priority49](md_img/p_priority49.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY49       | 2:0    | rw              | 0x0        | Priority level of IRQ49. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY50

Priority Register IRQ50 (3-bit, 8 levels)

Address offset: 0x000000c8

Reset value: 0x00000000

![p_priority50](md_img/p_priority50.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY50       | 2:0    | rw              | 0x0        | Priority level of IRQ50. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY51

Priority Register IRQ51 (3-bit, 8 levels)

Address offset: 0x000000cc

Reset value: 0x00000000

![p_priority51](md_img/p_priority51.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY51       | 2:0    | rw              | 0x0        | Priority level of IRQ51. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY52

Priority Register IRQ52 (3-bit, 8 levels)

Address offset: 0x000000d0

Reset value: 0x00000000

![p_priority52](md_img/p_priority52.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY52       | 2:0    | rw              | 0x0        | Priority level of IRQ52. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY53

Priority Register IRQ53 (3-bit, 8 levels)

Address offset: 0x000000d4

Reset value: 0x00000000

![p_priority53](md_img/p_priority53.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY53       | 2:0    | rw              | 0x0        | Priority level of IRQ53. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY54

Priority Register IRQ54 (3-bit, 8 levels)

Address offset: 0x000000d8

Reset value: 0x00000000

![p_priority54](md_img/p_priority54.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY54       | 2:0    | rw              | 0x0        | Priority level of IRQ54. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY55

Priority Register IRQ55 (3-bit, 8 levels)

Address offset: 0x000000dc

Reset value: 0x00000000

![p_priority55](md_img/p_priority55.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY55       | 2:0    | rw              | 0x0        | Priority level of IRQ55. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY56

Priority Register IRQ56 (3-bit, 8 levels)

Address offset: 0x000000e0

Reset value: 0x00000000

![p_priority56](md_img/p_priority56.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY56       | 2:0    | rw              | 0x0        | Priority level of IRQ56. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY57

Priority Register IRQ57 (3-bit, 8 levels)

Address offset: 0x000000e4

Reset value: 0x00000000

![p_priority57](md_img/p_priority57.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY57       | 2:0    | rw              | 0x0        | Priority level of IRQ57. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY58

Priority Register IRQ58 (3-bit, 8 levels)

Address offset: 0x000000e8

Reset value: 0x00000000

![p_priority58](md_img/p_priority58.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY58       | 2:0    | rw              | 0x0        | Priority level of IRQ58. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY59

Priority Register IRQ59 (3-bit, 8 levels)

Address offset: 0x000000ec

Reset value: 0x00000000

![p_priority59](md_img/p_priority59.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY59       | 2:0    | rw              | 0x0        | Priority level of IRQ59. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY60

Priority Register IRQ60 (3-bit, 8 levels)

Address offset: 0x000000f0

Reset value: 0x00000000

![p_priority60](md_img/p_priority60.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY60       | 2:0    | rw              | 0x0        | Priority level of IRQ60. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY61

Priority Register IRQ61 (3-bit, 8 levels)

Address offset: 0x000000f4

Reset value: 0x00000000

![p_priority61](md_img/p_priority61.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY61       | 2:0    | rw              | 0x0        | Priority level of IRQ61. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY62

Priority Register IRQ62 (3-bit, 8 levels)

Address offset: 0x000000f8

Reset value: 0x00000000

![p_priority62](md_img/p_priority62.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY62       | 2:0    | rw              | 0x0        | Priority level of IRQ62. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY63

Priority Register IRQ63 (3-bit, 8 levels)

Address offset: 0x000000fc

Reset value: 0x00000000

![p_priority63](md_img/p_priority63.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY63       | 2:0    | rw              | 0x0        | Priority level of IRQ63. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PRIORITY64

Priority Register IRQ64 (3-bit, 8 levels)

Address offset: 0x00000100

Reset value: 0x00000000

![p_priority64](md_img/p_priority64.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| PRIORITY64       | 2:0    | rw              | 0x0        | Priority level of IRQ64. 0 = Interrupt disabled |

Back to [Register map](#register-map-summary).

## P_PENDING0

Pending bits for IRQ1–IRQ31

Address offset: 0x00001000

Reset value: 0x00000000

![p_pending0](md_img/p_pending0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| PENDING_IRQ31    | 31     | ro              | 0x0        | Pending status of IRQ31 |
| PENDING_IRQ30    | 30     | ro              | 0x0        | Pending status of IRQ30 |
| PENDING_IRQ29    | 29     | ro              | 0x0        | Pending status of IRQ29 |
| PENDING_IRQ28    | 28     | ro              | 0x0        | Pending status of IRQ28 |
| PENDING_IRQ27    | 27     | ro              | 0x0        | Pending status of IRQ27 |
| PENDING_IRQ26    | 26     | ro              | 0x0        | Pending status of IRQ26 |
| PENDING_IRQ25    | 25     | ro              | 0x0        | Pending status of IRQ25 |
| PENDING_IRQ24    | 24     | ro              | 0x0        | Pending status of IRQ24 |
| PENDING_IRQ23    | 23     | ro              | 0x0        | Pending status of IRQ23 |
| PENDING_IRQ22    | 22     | ro              | 0x0        | Pending status of IRQ22 |
| PENDING_IRQ21    | 21     | ro              | 0x0        | Pending status of IRQ21 |
| PENDING_IRQ20    | 20     | ro              | 0x0        | Pending status of IRQ20 |
| PENDING_IRQ19    | 19     | ro              | 0x0        | Pending status of IRQ19 |
| PENDING_IRQ18    | 18     | ro              | 0x0        | Pending status of IRQ18 |
| PENDING_IRQ17    | 17     | ro              | 0x0        | Pending status of IRQ17 |
| PENDING_IRQ16    | 16     | ro              | 0x0        | Pending status of IRQ16 |
| PENDING_IRQ15    | 15     | ro              | 0x0        | Pending status of IRQ15 |
| PENDING_IRQ14    | 14     | ro              | 0x0        | Pending status of IRQ14 |
| PENDING_IRQ13    | 13     | ro              | 0x0        | Pending status of IRQ13 |
| PENDING_IRQ12    | 12     | ro              | 0x0        | Pending status of IRQ12 |
| PENDING_IRQ11    | 11     | ro              | 0x0        | Pending status of IRQ11 |
| PENDING_IRQ10    | 10     | ro              | 0x0        | Pending status of IRQ10 |
| PENDING_IRQ9     | 9      | ro              | 0x0        | Pending status of IRQ9 |
| PENDING_IRQ8     | 8      | ro              | 0x0        | Pending status of IRQ8 |
| PENDING_IRQ7     | 7      | ro              | 0x0        | Pending status of IRQ7 |
| PENDING_IRQ6     | 6      | ro              | 0x0        | Pending status of IRQ6 |
| PENDING_IRQ5     | 5      | ro              | 0x0        | Pending status of IRQ5 |
| PENDING_IRQ4     | 4      | ro              | 0x0        | Pending status of IRQ4 |
| PENDING_IRQ3     | 3      | ro              | 0x0        | Pending status of IRQ3 |
| PENDING_IRQ2     | 2      | ro              | 0x0        | Pending status of IRQ2 |
| PENDING_IRQ1     | 1      | ro              | 0x0        | Pending status of IRQ1 |

Back to [Register map](#register-map-summary).

## P_PENDING1

Pending bits for IRQ32–IRQ62

Address offset: 0x00001004

Reset value: 0x00000000

![p_pending1](md_img/p_pending1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| PENDING_IRQ62    | 31     | ro              | 0x0        | Pending status of IRQ62 |
| PENDING_IRQ61    | 30     | ro              | 0x0        | Pending status of IRQ61 |
| PENDING_IRQ60    | 29     | ro              | 0x0        | Pending status of IRQ60 |
| PENDING_IRQ59    | 28     | ro              | 0x0        | Pending status of IRQ59 |
| PENDING_IRQ58    | 27     | ro              | 0x0        | Pending status of IRQ58 |
| PENDING_IRQ57    | 26     | ro              | 0x0        | Pending status of IRQ57 |
| PENDING_IRQ56    | 25     | ro              | 0x0        | Pending status of IRQ56 |
| PENDING_IRQ55    | 24     | ro              | 0x0        | Pending status of IRQ55 |
| PENDING_IRQ54    | 23     | ro              | 0x0        | Pending status of IRQ54 |
| PENDING_IRQ53    | 22     | ro              | 0x0        | Pending status of IRQ53 |
| PENDING_IRQ52    | 21     | ro              | 0x0        | Pending status of IRQ52 |
| PENDING_IRQ51    | 20     | ro              | 0x0        | Pending status of IRQ51 |
| PENDING_IRQ50    | 19     | ro              | 0x0        | Pending status of IRQ50 |
| PENDING_IRQ49    | 18     | ro              | 0x0        | Pending status of IRQ49 |
| PENDING_IRQ48    | 17     | ro              | 0x0        | Pending status of IRQ48 |
| PENDING_IRQ47    | 16     | ro              | 0x0        | Pending status of IRQ47 |
| PENDING_IRQ46    | 15     | ro              | 0x0        | Pending status of IRQ46 |
| PENDING_IRQ45    | 14     | ro              | 0x0        | Pending status of IRQ45 |
| PENDING_IRQ44    | 13     | ro              | 0x0        | Pending status of IRQ44 |
| PENDING_IRQ43    | 12     | ro              | 0x0        | Pending status of IRQ43 |
| PENDING_IRQ42    | 11     | ro              | 0x0        | Pending status of IRQ42 |
| PENDING_IRQ41    | 10     | ro              | 0x0        | Pending status of IRQ41 |
| PENDING_IRQ40    | 9      | ro              | 0x0        | Pending status of IRQ40 |
| PENDING_IRQ39    | 8      | ro              | 0x0        | Pending status of IRQ39 |
| PENDING_IRQ38    | 7      | ro              | 0x0        | Pending status of IRQ38 |
| PENDING_IRQ37    | 6      | ro              | 0x0        | Pending status of IRQ37 |
| PENDING_IRQ36    | 5      | ro              | 0x0        | Pending status of IRQ36 |
| PENDING_IRQ35    | 4      | ro              | 0x0        | Pending status of IRQ35 |
| PENDING_IRQ34    | 3      | ro              | 0x0        | Pending status of IRQ34 |
| PENDING_IRQ33    | 2      | ro              | 0x0        | Pending status of IRQ33 |
| PENDING_IRQ32    | 1      | ro              | 0x0        | Pending status of IRQ32 |

Back to [Register map](#register-map-summary).

## P_ENABLE0

Enable bits for IRQ1–IRQ31

Address offset: 0x00002000

Reset value: 0x00000000

![p_enable0](md_img/p_enable0.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| ENABLE_IRQ31     | 31     | rw              | 0x0        | Enable mask for IRQ31 |
| ENABLE_IRQ30     | 30     | rw              | 0x0        | Enable mask for IRQ30 |
| ENABLE_IRQ29     | 29     | rw              | 0x0        | Enable mask for IRQ29 |
| ENABLE_IRQ28     | 28     | rw              | 0x0        | Enable mask for IRQ28 |
| ENABLE_IRQ27     | 27     | rw              | 0x0        | Enable mask for IRQ27 |
| ENABLE_IRQ26     | 26     | rw              | 0x0        | Enable mask for IRQ26 |
| ENABLE_IRQ25     | 25     | rw              | 0x0        | Enable mask for IRQ25 |
| ENABLE_IRQ24     | 24     | rw              | 0x0        | Enable mask for IRQ24 |
| ENABLE_IRQ23     | 23     | rw              | 0x0        | Enable mask for IRQ23 |
| ENABLE_IRQ22     | 22     | rw              | 0x0        | Enable mask for IRQ22 |
| ENABLE_IRQ21     | 21     | rw              | 0x0        | Enable mask for IRQ21 |
| ENABLE_IRQ20     | 20     | rw              | 0x0        | Enable mask for IRQ20 |
| ENABLE_IRQ19     | 19     | rw              | 0x0        | Enable mask for IRQ19 |
| ENABLE_IRQ18     | 18     | rw              | 0x0        | Enable mask for IRQ18 |
| ENABLE_IRQ17     | 17     | rw              | 0x0        | Enable mask for IRQ17 |
| ENABLE_IRQ16     | 16     | rw              | 0x0        | Enable mask for IRQ16 |
| ENABLE_IRQ15     | 15     | rw              | 0x0        | Enable mask for IRQ15 |
| ENABLE_IRQ14     | 14     | rw              | 0x0        | Enable mask for IRQ14 |
| ENABLE_IRQ13     | 13     | rw              | 0x0        | Enable mask for IRQ13 |
| ENABLE_IRQ12     | 12     | rw              | 0x0        | Enable mask for IRQ12 |
| ENABLE_IRQ11     | 11     | rw              | 0x0        | Enable mask for IRQ11 |
| ENABLE_IRQ10     | 10     | rw              | 0x0        | Enable mask for IRQ10 |
| ENABLE_IRQ9      | 9      | rw              | 0x0        | Enable mask for IRQ9 |
| ENABLE_IRQ8      | 8      | rw              | 0x0        | Enable mask for IRQ8 |
| ENABLE_IRQ7      | 7      | rw              | 0x0        | Enable mask for IRQ7 |
| ENABLE_IRQ6      | 6      | rw              | 0x0        | Enable mask for IRQ6 |
| ENABLE_IRQ5      | 5      | rw              | 0x0        | Enable mask for IRQ5 |
| ENABLE_IRQ4      | 4      | rw              | 0x0        | Enable mask for IRQ4 |
| ENABLE_IRQ3      | 3      | rw              | 0x0        | Enable mask for IRQ3 |
| ENABLE_IRQ2      | 2      | rw              | 0x0        | Enable mask for IRQ2 |
| ENABLE_IRQ1      | 1      | rw              | 0x0        | Enable mask for IRQ1 |

Back to [Register map](#register-map-summary).

## P_ENABLE1

Enable bits for IRQ32–IRQ62

Address offset: 0x00002004

Reset value: 0x00000000

![p_enable1](md_img/p_enable1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| ENABLE_IRQ62     | 31     | rw              | 0x0        | Enable mask for IRQ62 |
| ENABLE_IRQ61     | 30     | rw              | 0x0        | Enable mask for IRQ61 |
| ENABLE_IRQ60     | 29     | rw              | 0x0        | Enable mask for IRQ60 |
| ENABLE_IRQ59     | 28     | rw              | 0x0        | Enable mask for IRQ59 |
| ENABLE_IRQ58     | 27     | rw              | 0x0        | Enable mask for IRQ58 |
| ENABLE_IRQ57     | 26     | rw              | 0x0        | Enable mask for IRQ57 |
| ENABLE_IRQ56     | 25     | rw              | 0x0        | Enable mask for IRQ56 |
| ENABLE_IRQ55     | 24     | rw              | 0x0        | Enable mask for IRQ55 |
| ENABLE_IRQ54     | 23     | rw              | 0x0        | Enable mask for IRQ54 |
| ENABLE_IRQ53     | 22     | rw              | 0x0        | Enable mask for IRQ53 |
| ENABLE_IRQ52     | 21     | rw              | 0x0        | Enable mask for IRQ52 |
| ENABLE_IRQ51     | 20     | rw              | 0x0        | Enable mask for IRQ51 |
| ENABLE_IRQ50     | 19     | rw              | 0x0        | Enable mask for IRQ50 |
| ENABLE_IRQ49     | 18     | rw              | 0x0        | Enable mask for IRQ49 |
| ENABLE_IRQ48     | 17     | rw              | 0x0        | Enable mask for IRQ48 |
| ENABLE_IRQ47     | 16     | rw              | 0x0        | Enable mask for IRQ47 |
| ENABLE_IRQ46     | 15     | rw              | 0x0        | Enable mask for IRQ46 |
| ENABLE_IRQ45     | 14     | rw              | 0x0        | Enable mask for IRQ45 |
| ENABLE_IRQ44     | 13     | rw              | 0x0        | Enable mask for IRQ44 |
| ENABLE_IRQ43     | 12     | rw              | 0x0        | Enable mask for IRQ43 |
| ENABLE_IRQ42     | 11     | rw              | 0x0        | Enable mask for IRQ42 |
| ENABLE_IRQ41     | 10     | rw              | 0x0        | Enable mask for IRQ41 |
| ENABLE_IRQ40     | 9      | rw              | 0x0        | Enable mask for IRQ40 |
| ENABLE_IRQ39     | 8      | rw              | 0x0        | Enable mask for IRQ39 |
| ENABLE_IRQ38     | 7      | rw              | 0x0        | Enable mask for IRQ38 |
| ENABLE_IRQ37     | 6      | rw              | 0x0        | Enable mask for IRQ37 |
| ENABLE_IRQ36     | 5      | rw              | 0x0        | Enable mask for IRQ36 |
| ENABLE_IRQ35     | 4      | rw              | 0x0        | Enable mask for IRQ35 |
| ENABLE_IRQ34     | 3      | rw              | 0x0        | Enable mask for IRQ34 |
| ENABLE_IRQ33     | 2      | rw              | 0x0        | Enable mask for IRQ33 |
| ENABLE_IRQ32     | 1      | rw              | 0x0        | Enable mask for IRQ32 |

Back to [Register map](#register-map-summary).

## P_THRESHOLD

Priority threshold register

Address offset: 0x00200000

Reset value: 0x00000000

![p_threshold](md_img/p_threshold.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:3   | -               | 0x0000000  | Reserved |
| THRESHOLD        | 2:0    | rw              | 0x0        | Only IRQs with priority > threshold will be signaled |

Back to [Register map](#register-map-summary).

## P_CLAIMCOMPLETE

Claim/Complete register

Address offset: 0x00200004

Reset value: 0x00000000

![p_claimcomplete](md_img/p_claimcomplete.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:6   | -               | 0x000000   | Reserved |
| CP               | 5:0    | rw              | 0x0        | Read = claim IRQ ID, Write = complete IRQ ID |

Back to [Register map](#register-map-summary).
