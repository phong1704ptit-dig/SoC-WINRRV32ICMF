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

Base address: 0x40000000

| Name                     | Address    | Description |
| :---                     | :---       | :---        |
| [GPIO_IO](#gpio_io)      | 0x00000000 | GPIO Read/Write Register |
| [GPIO_config](#gpio_config) | 0x00000004 | GPIO config Register 0 output, 1 input |

## GPIO_IO

GPIO Read/Write Register

Address offset: 0x00000000

Reset value: 0x00000000

![gpio_io](md_img/gpio_io.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| GPIO_15          | 15     | rw              | 0x0        | GPIO15 |
| GPIO_14          | 14     | rw              | 0x0        | GPIO14 |
| GPIO_13          | 13     | rw              | 0x0        | GPIO13 |
| GPIO_12          | 12     | rw              | 0x0        | GPIO12 |
| GPIO_11          | 11     | rw              | 0x0        | GPIO11 |
| GPIO_10          | 10     | rw              | 0x0        | GPIO10 |
| GPIO_9           | 9      | rw              | 0x0        | GPIO9 |
| GPIO_8           | 8      | rw              | 0x0        | GPIO8 |
| GPIO_7           | 7      | rw              | 0x0        | GPIO7 |
| GPIO_6           | 6      | rw              | 0x0        | GPIO6 |
| GPIO_5           | 5      | rw              | 0x0        | GPIO5 |
| GPIO_4           | 4      | rw              | 0x0        | GPIO4 |
| GPIO_3           | 3      | rw              | 0x0        | GPIO3 |
| GPIO_2           | 2      | rw              | 0x0        | GPIO2 |
| GPIO_1           | 1      | rw              | 0x0        | GPIO1 |
| GPIO_0           | 0      | rw              | 0x0        | GPIO0 |

Back to [Register map](#register-map-summary).

## GPIO_config

GPIO config Register 0 output, 1 input

Address offset: 0x00000004

Reset value: 0x00000000

![gpio_config](md_img/gpio_config.svg)

| Name             | Bits   | Mode            | Reset      | Description |
| :---             | :---   | :---            | :---       | :---        |
| -                | 31:16  | -               | 0x0000     | Reserved |
| GPIO_15config    | 15     | rw              | 0x0        | GPIO15_config |
| GPIO_14config    | 14     | rw              | 0x0        | GPIO14_config |
| GPIO_13config    | 13     | rw              | 0x0        | GPIO13_config |
| GPIO_12config    | 12     | rw              | 0x0        | GPIO12_config |
| GPIO_11config    | 11     | rw              | 0x0        | GPIO11_config |
| GPIO_10config    | 10     | rw              | 0x0        | GPIO10_config |
| GPIO_9config     | 9      | rw              | 0x0        | GPIO9_config |
| GPIO_8config     | 8      | rw              | 0x0        | GPIO8_config |
| GPIO_7config     | 7      | rw              | 0x0        | GPIO7_config |
| GPIO_6config     | 6      | rw              | 0x0        | GPIO6_config |
| GPIO_5config     | 5      | rw              | 0x0        | GPIO5_config |
| GPIO_4config     | 4      | rw              | 0x0        | GPIO4_config |
| GPIO_3config     | 3      | rw              | 0x0        | GPIO3_config |
| GPIO_2config     | 2      | rw              | 0x0        | GPIO2_config |
| GPIO_1config     | 1      | rw              | 0x0        | GPIO1_config |
| GPIO_0config     | 0      | rw              | 0x0        | GPIO0_config |

Back to [Register map](#register-map-summary).
