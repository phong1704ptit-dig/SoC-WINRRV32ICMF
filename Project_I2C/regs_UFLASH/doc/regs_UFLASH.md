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

Base address: 0x00000000

| Name                     | Address    | Description |
| :---                     | :---       | :---        |
| [UFLASH_KEY1](#uflash_key1) | 0x00000000 | Unlock key for User Flash region |
| [UFLASH_KEY2](#uflash_key2) | 0x00000004 | Unlock key for Text Flash region |
| [UFLASH_KEY3](#uflash_key3) | 0x00000008 | Unlock key for Boot Flash region |
| [UFLASH_CR](#uflash_cr)  | 0x0000000c | Flash Control Register |
| [UFLASH_SR](#uflash_sr)  | 0x00000010 | Flash Status Register |
| [UFLASH_XADR](#uflash_xadr) | 0x00000014 | Flash X Address Register |
| [UFLASH_YADR](#uflash_yadr) | 0x00000018 | Flash Y Address Register |
| [UFLASH_DOR](#uflash_dor) | 0x0000001c | Flash data out Register |
| [UFLASH_DIR](#uflash_dir) | 0x00000020 | Flash data in Register |

## UFLASH_KEY1

Unlock key for User Flash region

Address offset: 0x00000000

Reset value: 0x00000000

![uflash_key1](md_img/uflash_key1.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| KEY              | 31:0   | wo              | 0x00000000 | 32-bit unlock key value(0x57494E44 - WIND) |

Back to [Register map](#register-map-summary).

## UFLASH_KEY2

Unlock key for Text Flash region

Address offset: 0x00000004

Reset value: 0x00000000

![uflash_key2](md_img/uflash_key2.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| KEY              | 31:0   | wo              | 0x00000000 | 32-bit unlock key value |

Back to [Register map](#register-map-summary).

## UFLASH_KEY3

Unlock key for Boot Flash region

Address offset: 0x00000008

Reset value: 0x00000000

![uflash_key3](md_img/uflash_key3.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| KEY              | 31:0   | wo              | 0x00000000 | 32-bit unlock key value |

Back to [Register map](#register-map-summary).

## UFLASH_CR

Flash Control Register

Address offset: 0x0000000c

Reset value: 0x00000000

![uflash_cr](md_img/uflash_cr.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:8   | -               | 0x000000   | Reserved |
| MODE             | 7:6    | rw              | 0x0        | Flash operation mode |
| ERASE_EN         | 5      | rw              | 0x0        | Erase enable |
| READ_EN          | 4      | rw              | 0x0        | Read enable |
| PROG_EN          | 3      | rw              | 0x0        | Program enable |
| BOOT_EN          | 2      | rw              | 0x0        | Enable access to Boot region |
| TEXT_EN          | 1      | rw              | 0x0        | Enable access to Text region |
| USER_EN          | 0      | rw              | 0x0        | Enable access to User region |

Enumerated values for UFLASH_CR.MODE.

| Name             | Value   | Description |
| :---             | :---    | :---        |
| READ             | 0x0    | Read mode |
| PROGRAM          | 0x1    | Program mode |
| ERASE            | 0x2    | Erase mode |
| IDLE             | 0x3    | Idle mode |

Back to [Register map](#register-map-summary).

## UFLASH_SR

Flash Status Register

Address offset: 0x00000010

Reset value: 0x00000000

![uflash_sr](md_img/uflash_sr.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:7   | -               | 0x000000   | Reserved |
| ERASE_DONE       | 6      | ro              | 0x0        | Erase operation finished |
| PROG_DONE        | 5      | ro              | 0x0        | Program operation finished |
| RD_DONE          | 4      | ro              | 0x0        | Read operation finished |
| ERRA_OVF         | 3      | ro              | 0x0        | Error address overflow |
| ERRA_BOOT        | 2      | ro              | 0x0        | Error unauthorized access to Boot region |
| ERRA_TEXT        | 1      | ro              | 0x0        | Error unauthorized access to Text region |
| ERRA_USER        | 0      | ro              | 0x0        | Error unauthorized access to User region |

Back to [Register map](#register-map-summary).

## UFLASH_XADR

Flash X Address Register

Address offset: 0x00000014

Reset value: 0x00000000

![uflash_xadr](md_img/uflash_xadr.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| XADR             | 15:0   | rw              | 0x0000     | Flash X address (row / page select) |

Back to [Register map](#register-map-summary).

## UFLASH_YADR

Flash Y Address Register

Address offset: 0x00000018

Reset value: 0x00000000

![uflash_yadr](md_img/uflash_yadr.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:8   | -               | 0x000000   | Reserved |
| YADR             | 7:0    | rw              | 0x00       | Flash Y address (column / word select) |

Back to [Register map](#register-map-summary).

## UFLASH_DOR

Flash data out Register

Address offset: 0x0000001c

Reset value: 0x00000000

![uflash_dor](md_img/uflash_dor.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| DO               | 31:0   | ro              | 0x00000000 | 32BIT READ DATA |

Back to [Register map](#register-map-summary).

## UFLASH_DIR

Flash data in Register

Address offset: 0x00000020

Reset value: 0x00000000

![uflash_dir](md_img/uflash_dir.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| DI               | 31:0   | wo              | 0x00000000 | 32BIT PROGRAM DATA |

Back to [Register map](#register-map-summary).
