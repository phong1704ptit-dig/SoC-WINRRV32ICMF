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
| [U_DATA](#u_data)        | 0x00000000 | UART Data register |
| [U_STAT](#u_stat)        | 0x00000004 | UART Status register |
| [U_CTRL](#u_ctrl)        | 0x00000008 | UART Control register |

## U_DATA

UART Data register

Address offset: 0x00000000

Reset value: 0x00000000

![u_data](md_img/u_data.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:8   | -               | 0x000000   | Reserved |
| DATA             | 7:0    | rw              | 0x00       | Data To Send Via UART TX |

Back to [Register map](#register-map-summary).

## U_STAT

UART Status register

Address offset: 0x00000004

Reset value: 0x00000020

![u_stat](md_img/u_stat.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:14  | -               | 0x0000     | Reserved |
| TX_DONE          | 13     | roc             | 0x0        | Done Transmitting The Last Char (8-bit) |
| -                | 12:6   | -               | 0x0        | Reserved |
| READY            | 5      | ro              | 0x1        | UART is Ready |

Back to [Register map](#register-map-summary).

## U_CTRL

UART Control register

Address offset: 0x00000008

Reset value: 0x00000000

![u_ctrl](md_img/u_ctrl.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:10  | -               | 0x00000    | Reserved |
| START            | 9      | wosc            | 0x0        | TX Begin Signal, Valid For Only One Cycle |

Back to [Register map](#register-map-summary).
