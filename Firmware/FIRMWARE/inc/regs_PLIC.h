// Created with Corsair v1.0.4
#ifndef __REGS_PLIC_H
#define __REGS_PLIC_H

#define __I  volatile const // 'read only' permissions
#define __O  volatile       // 'write only' permissions
#define __IO volatile       // 'read / write' permissions


#ifdef __cplusplus
#include <cstdint>
extern "C" {
#else
#include <stdint.h>
#endif

#define PLIC_BASE_ADDR 0x30000000

// P_PRIORITY1 - Priority Register IRQ1 (3-bit, 8 levels)
#define PLIC_P_PRIORITY1_ADDR 0x4
#define PLIC_P_PRIORITY1_RESET 0x0
typedef struct {
    uint32_t PRIORITY1 : 3; // Priority level of IRQ1. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority1_t;

// P_PRIORITY1.PRIORITY1 - Priority level of IRQ1. 0 = Interrupt disabled
#define PLIC_P_PRIORITY1_PRIORITY1_WIDTH 3
#define PLIC_P_PRIORITY1_PRIORITY1_LSB 0
#define PLIC_P_PRIORITY1_PRIORITY1_MASK 0x7
#define PLIC_P_PRIORITY1_PRIORITY1_RESET 0x0

// P_PRIORITY2 - Priority Register IRQ2 (3-bit, 8 levels)
#define PLIC_P_PRIORITY2_ADDR 0x8
#define PLIC_P_PRIORITY2_RESET 0x0
typedef struct {
    uint32_t PRIORITY2 : 3; // Priority level of IRQ2. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority2_t;

// P_PRIORITY2.PRIORITY2 - Priority level of IRQ2. 0 = Interrupt disabled
#define PLIC_P_PRIORITY2_PRIORITY2_WIDTH 3
#define PLIC_P_PRIORITY2_PRIORITY2_LSB 0
#define PLIC_P_PRIORITY2_PRIORITY2_MASK 0x7
#define PLIC_P_PRIORITY2_PRIORITY2_RESET 0x0

// P_PRIORITY3 - Priority Register IRQ3 (3-bit, 8 levels)
#define PLIC_P_PRIORITY3_ADDR 0xc
#define PLIC_P_PRIORITY3_RESET 0x0
typedef struct {
    uint32_t PRIORITY3 : 3; // Priority level of IRQ3. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority3_t;

// P_PRIORITY3.PRIORITY3 - Priority level of IRQ3. 0 = Interrupt disabled
#define PLIC_P_PRIORITY3_PRIORITY3_WIDTH 3
#define PLIC_P_PRIORITY3_PRIORITY3_LSB 0
#define PLIC_P_PRIORITY3_PRIORITY3_MASK 0x7
#define PLIC_P_PRIORITY3_PRIORITY3_RESET 0x0

// P_PRIORITY4 - Priority Register IRQ4 (3-bit, 8 levels)
#define PLIC_P_PRIORITY4_ADDR 0x10
#define PLIC_P_PRIORITY4_RESET 0x0
typedef struct {
    uint32_t PRIORITY4 : 3; // Priority level of IRQ4. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority4_t;

// P_PRIORITY4.PRIORITY4 - Priority level of IRQ4. 0 = Interrupt disabled
#define PLIC_P_PRIORITY4_PRIORITY4_WIDTH 3
#define PLIC_P_PRIORITY4_PRIORITY4_LSB 0
#define PLIC_P_PRIORITY4_PRIORITY4_MASK 0x7
#define PLIC_P_PRIORITY4_PRIORITY4_RESET 0x0

// P_PRIORITY5 - Priority Register IRQ5 (3-bit, 8 levels)
#define PLIC_P_PRIORITY5_ADDR 0x14
#define PLIC_P_PRIORITY5_RESET 0x0
typedef struct {
    uint32_t PRIORITY5 : 3; // Priority level of IRQ5. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority5_t;

// P_PRIORITY5.PRIORITY5 - Priority level of IRQ5. 0 = Interrupt disabled
#define PLIC_P_PRIORITY5_PRIORITY5_WIDTH 3
#define PLIC_P_PRIORITY5_PRIORITY5_LSB 0
#define PLIC_P_PRIORITY5_PRIORITY5_MASK 0x7
#define PLIC_P_PRIORITY5_PRIORITY5_RESET 0x0

// P_PRIORITY6 - Priority Register IRQ6 (3-bit, 8 levels)
#define PLIC_P_PRIORITY6_ADDR 0x18
#define PLIC_P_PRIORITY6_RESET 0x0
typedef struct {
    uint32_t PRIORITY6 : 3; // Priority level of IRQ6. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority6_t;

// P_PRIORITY6.PRIORITY6 - Priority level of IRQ6. 0 = Interrupt disabled
#define PLIC_P_PRIORITY6_PRIORITY6_WIDTH 3
#define PLIC_P_PRIORITY6_PRIORITY6_LSB 0
#define PLIC_P_PRIORITY6_PRIORITY6_MASK 0x7
#define PLIC_P_PRIORITY6_PRIORITY6_RESET 0x0

// P_PRIORITY7 - Priority Register IRQ7 (3-bit, 8 levels)
#define PLIC_P_PRIORITY7_ADDR 0x1c
#define PLIC_P_PRIORITY7_RESET 0x0
typedef struct {
    uint32_t PRIORITY7 : 3; // Priority level of IRQ7. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority7_t;

// P_PRIORITY7.PRIORITY7 - Priority level of IRQ7. 0 = Interrupt disabled
#define PLIC_P_PRIORITY7_PRIORITY7_WIDTH 3
#define PLIC_P_PRIORITY7_PRIORITY7_LSB 0
#define PLIC_P_PRIORITY7_PRIORITY7_MASK 0x7
#define PLIC_P_PRIORITY7_PRIORITY7_RESET 0x0

// P_PRIORITY8 - Priority Register IRQ8 (3-bit, 8 levels)
#define PLIC_P_PRIORITY8_ADDR 0x20
#define PLIC_P_PRIORITY8_RESET 0x0
typedef struct {
    uint32_t PRIORITY8 : 3; // Priority level of IRQ8. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority8_t;

// P_PRIORITY8.PRIORITY8 - Priority level of IRQ8. 0 = Interrupt disabled
#define PLIC_P_PRIORITY8_PRIORITY8_WIDTH 3
#define PLIC_P_PRIORITY8_PRIORITY8_LSB 0
#define PLIC_P_PRIORITY8_PRIORITY8_MASK 0x7
#define PLIC_P_PRIORITY8_PRIORITY8_RESET 0x0

// P_PRIORITY9 - Priority Register IRQ9 (3-bit, 8 levels)
#define PLIC_P_PRIORITY9_ADDR 0x24
#define PLIC_P_PRIORITY9_RESET 0x0
typedef struct {
    uint32_t PRIORITY9 : 3; // Priority level of IRQ9. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority9_t;

// P_PRIORITY9.PRIORITY9 - Priority level of IRQ9. 0 = Interrupt disabled
#define PLIC_P_PRIORITY9_PRIORITY9_WIDTH 3
#define PLIC_P_PRIORITY9_PRIORITY9_LSB 0
#define PLIC_P_PRIORITY9_PRIORITY9_MASK 0x7
#define PLIC_P_PRIORITY9_PRIORITY9_RESET 0x0

// P_PRIORITY10 - Priority Register IRQ10 (3-bit, 8 levels)
#define PLIC_P_PRIORITY10_ADDR 0x28
#define PLIC_P_PRIORITY10_RESET 0x0
typedef struct {
    uint32_t PRIORITY10 : 3; // Priority level of IRQ10. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority10_t;

// P_PRIORITY10.PRIORITY10 - Priority level of IRQ10. 0 = Interrupt disabled
#define PLIC_P_PRIORITY10_PRIORITY10_WIDTH 3
#define PLIC_P_PRIORITY10_PRIORITY10_LSB 0
#define PLIC_P_PRIORITY10_PRIORITY10_MASK 0x7
#define PLIC_P_PRIORITY10_PRIORITY10_RESET 0x0

// P_PRIORITY11 - Priority Register IRQ11 (3-bit, 8 levels)
#define PLIC_P_PRIORITY11_ADDR 0x2c
#define PLIC_P_PRIORITY11_RESET 0x0
typedef struct {
    uint32_t PRIORITY11 : 3; // Priority level of IRQ11. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority11_t;

// P_PRIORITY11.PRIORITY11 - Priority level of IRQ11. 0 = Interrupt disabled
#define PLIC_P_PRIORITY11_PRIORITY11_WIDTH 3
#define PLIC_P_PRIORITY11_PRIORITY11_LSB 0
#define PLIC_P_PRIORITY11_PRIORITY11_MASK 0x7
#define PLIC_P_PRIORITY11_PRIORITY11_RESET 0x0

// P_PRIORITY12 - Priority Register IRQ12 (3-bit, 8 levels)
#define PLIC_P_PRIORITY12_ADDR 0x30
#define PLIC_P_PRIORITY12_RESET 0x0
typedef struct {
    uint32_t PRIORITY12 : 3; // Priority level of IRQ12. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority12_t;

// P_PRIORITY12.PRIORITY12 - Priority level of IRQ12. 0 = Interrupt disabled
#define PLIC_P_PRIORITY12_PRIORITY12_WIDTH 3
#define PLIC_P_PRIORITY12_PRIORITY12_LSB 0
#define PLIC_P_PRIORITY12_PRIORITY12_MASK 0x7
#define PLIC_P_PRIORITY12_PRIORITY12_RESET 0x0

// P_PRIORITY13 - Priority Register IRQ13 (3-bit, 8 levels)
#define PLIC_P_PRIORITY13_ADDR 0x34
#define PLIC_P_PRIORITY13_RESET 0x0
typedef struct {
    uint32_t PRIORITY13 : 3; // Priority level of IRQ13. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority13_t;

// P_PRIORITY13.PRIORITY13 - Priority level of IRQ13. 0 = Interrupt disabled
#define PLIC_P_PRIORITY13_PRIORITY13_WIDTH 3
#define PLIC_P_PRIORITY13_PRIORITY13_LSB 0
#define PLIC_P_PRIORITY13_PRIORITY13_MASK 0x7
#define PLIC_P_PRIORITY13_PRIORITY13_RESET 0x0

// P_PRIORITY14 - Priority Register IRQ14 (3-bit, 8 levels)
#define PLIC_P_PRIORITY14_ADDR 0x38
#define PLIC_P_PRIORITY14_RESET 0x0
typedef struct {
    uint32_t PRIORITY14 : 3; // Priority level of IRQ14. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority14_t;

// P_PRIORITY14.PRIORITY14 - Priority level of IRQ14. 0 = Interrupt disabled
#define PLIC_P_PRIORITY14_PRIORITY14_WIDTH 3
#define PLIC_P_PRIORITY14_PRIORITY14_LSB 0
#define PLIC_P_PRIORITY14_PRIORITY14_MASK 0x7
#define PLIC_P_PRIORITY14_PRIORITY14_RESET 0x0

// P_PRIORITY15 - Priority Register IRQ15 (3-bit, 8 levels)
#define PLIC_P_PRIORITY15_ADDR 0x3c
#define PLIC_P_PRIORITY15_RESET 0x0
typedef struct {
    uint32_t PRIORITY15 : 3; // Priority level of IRQ15. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority15_t;

// P_PRIORITY15.PRIORITY15 - Priority level of IRQ15. 0 = Interrupt disabled
#define PLIC_P_PRIORITY15_PRIORITY15_WIDTH 3
#define PLIC_P_PRIORITY15_PRIORITY15_LSB 0
#define PLIC_P_PRIORITY15_PRIORITY15_MASK 0x7
#define PLIC_P_PRIORITY15_PRIORITY15_RESET 0x0

// P_PRIORITY16 - Priority Register IRQ16 (3-bit, 8 levels)
#define PLIC_P_PRIORITY16_ADDR 0x40
#define PLIC_P_PRIORITY16_RESET 0x0
typedef struct {
    uint32_t PRIORITY16 : 3; // Priority level of IRQ16. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority16_t;

// P_PRIORITY16.PRIORITY16 - Priority level of IRQ16. 0 = Interrupt disabled
#define PLIC_P_PRIORITY16_PRIORITY16_WIDTH 3
#define PLIC_P_PRIORITY16_PRIORITY16_LSB 0
#define PLIC_P_PRIORITY16_PRIORITY16_MASK 0x7
#define PLIC_P_PRIORITY16_PRIORITY16_RESET 0x0

// P_PRIORITY17 - Priority Register IRQ17 (3-bit, 8 levels)
#define PLIC_P_PRIORITY17_ADDR 0x44
#define PLIC_P_PRIORITY17_RESET 0x0
typedef struct {
    uint32_t PRIORITY17 : 3; // Priority level of IRQ17. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority17_t;

// P_PRIORITY17.PRIORITY17 - Priority level of IRQ17. 0 = Interrupt disabled
#define PLIC_P_PRIORITY17_PRIORITY17_WIDTH 3
#define PLIC_P_PRIORITY17_PRIORITY17_LSB 0
#define PLIC_P_PRIORITY17_PRIORITY17_MASK 0x7
#define PLIC_P_PRIORITY17_PRIORITY17_RESET 0x0

// P_PRIORITY18 - Priority Register IRQ18 (3-bit, 8 levels)
#define PLIC_P_PRIORITY18_ADDR 0x48
#define PLIC_P_PRIORITY18_RESET 0x0
typedef struct {
    uint32_t PRIORITY18 : 3; // Priority level of IRQ18. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority18_t;

// P_PRIORITY18.PRIORITY18 - Priority level of IRQ18. 0 = Interrupt disabled
#define PLIC_P_PRIORITY18_PRIORITY18_WIDTH 3
#define PLIC_P_PRIORITY18_PRIORITY18_LSB 0
#define PLIC_P_PRIORITY18_PRIORITY18_MASK 0x7
#define PLIC_P_PRIORITY18_PRIORITY18_RESET 0x0

// P_PRIORITY19 - Priority Register IRQ19 (3-bit, 8 levels)
#define PLIC_P_PRIORITY19_ADDR 0x4c
#define PLIC_P_PRIORITY19_RESET 0x0
typedef struct {
    uint32_t PRIORITY19 : 3; // Priority level of IRQ19. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority19_t;

// P_PRIORITY19.PRIORITY19 - Priority level of IRQ19. 0 = Interrupt disabled
#define PLIC_P_PRIORITY19_PRIORITY19_WIDTH 3
#define PLIC_P_PRIORITY19_PRIORITY19_LSB 0
#define PLIC_P_PRIORITY19_PRIORITY19_MASK 0x7
#define PLIC_P_PRIORITY19_PRIORITY19_RESET 0x0

// P_PRIORITY20 - Priority Register IRQ20 (3-bit, 8 levels)
#define PLIC_P_PRIORITY20_ADDR 0x50
#define PLIC_P_PRIORITY20_RESET 0x0
typedef struct {
    uint32_t PRIORITY20 : 3; // Priority level of IRQ20. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority20_t;

// P_PRIORITY20.PRIORITY20 - Priority level of IRQ20. 0 = Interrupt disabled
#define PLIC_P_PRIORITY20_PRIORITY20_WIDTH 3
#define PLIC_P_PRIORITY20_PRIORITY20_LSB 0
#define PLIC_P_PRIORITY20_PRIORITY20_MASK 0x7
#define PLIC_P_PRIORITY20_PRIORITY20_RESET 0x0

// P_PRIORITY21 - Priority Register IRQ21 (3-bit, 8 levels)
#define PLIC_P_PRIORITY21_ADDR 0x54
#define PLIC_P_PRIORITY21_RESET 0x0
typedef struct {
    uint32_t PRIORITY21 : 3; // Priority level of IRQ21. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority21_t;

// P_PRIORITY21.PRIORITY21 - Priority level of IRQ21. 0 = Interrupt disabled
#define PLIC_P_PRIORITY21_PRIORITY21_WIDTH 3
#define PLIC_P_PRIORITY21_PRIORITY21_LSB 0
#define PLIC_P_PRIORITY21_PRIORITY21_MASK 0x7
#define PLIC_P_PRIORITY21_PRIORITY21_RESET 0x0

// P_PRIORITY22 - Priority Register IRQ22 (3-bit, 8 levels)
#define PLIC_P_PRIORITY22_ADDR 0x58
#define PLIC_P_PRIORITY22_RESET 0x0
typedef struct {
    uint32_t PRIORITY22 : 3; // Priority level of IRQ22. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority22_t;

// P_PRIORITY22.PRIORITY22 - Priority level of IRQ22. 0 = Interrupt disabled
#define PLIC_P_PRIORITY22_PRIORITY22_WIDTH 3
#define PLIC_P_PRIORITY22_PRIORITY22_LSB 0
#define PLIC_P_PRIORITY22_PRIORITY22_MASK 0x7
#define PLIC_P_PRIORITY22_PRIORITY22_RESET 0x0

// P_PRIORITY23 - Priority Register IRQ23 (3-bit, 8 levels)
#define PLIC_P_PRIORITY23_ADDR 0x5c
#define PLIC_P_PRIORITY23_RESET 0x0
typedef struct {
    uint32_t PRIORITY23 : 3; // Priority level of IRQ23. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority23_t;

// P_PRIORITY23.PRIORITY23 - Priority level of IRQ23. 0 = Interrupt disabled
#define PLIC_P_PRIORITY23_PRIORITY23_WIDTH 3
#define PLIC_P_PRIORITY23_PRIORITY23_LSB 0
#define PLIC_P_PRIORITY23_PRIORITY23_MASK 0x7
#define PLIC_P_PRIORITY23_PRIORITY23_RESET 0x0

// P_PRIORITY24 - Priority Register IRQ24 (3-bit, 8 levels)
#define PLIC_P_PRIORITY24_ADDR 0x60
#define PLIC_P_PRIORITY24_RESET 0x0
typedef struct {
    uint32_t PRIORITY24 : 3; // Priority level of IRQ24. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority24_t;

// P_PRIORITY24.PRIORITY24 - Priority level of IRQ24. 0 = Interrupt disabled
#define PLIC_P_PRIORITY24_PRIORITY24_WIDTH 3
#define PLIC_P_PRIORITY24_PRIORITY24_LSB 0
#define PLIC_P_PRIORITY24_PRIORITY24_MASK 0x7
#define PLIC_P_PRIORITY24_PRIORITY24_RESET 0x0

// P_PRIORITY25 - Priority Register IRQ25 (3-bit, 8 levels)
#define PLIC_P_PRIORITY25_ADDR 0x64
#define PLIC_P_PRIORITY25_RESET 0x0
typedef struct {
    uint32_t PRIORITY25 : 3; // Priority level of IRQ25. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority25_t;

// P_PRIORITY25.PRIORITY25 - Priority level of IRQ25. 0 = Interrupt disabled
#define PLIC_P_PRIORITY25_PRIORITY25_WIDTH 3
#define PLIC_P_PRIORITY25_PRIORITY25_LSB 0
#define PLIC_P_PRIORITY25_PRIORITY25_MASK 0x7
#define PLIC_P_PRIORITY25_PRIORITY25_RESET 0x0

// P_PRIORITY26 - Priority Register IRQ26 (3-bit, 8 levels)
#define PLIC_P_PRIORITY26_ADDR 0x68
#define PLIC_P_PRIORITY26_RESET 0x0
typedef struct {
    uint32_t PRIORITY26 : 3; // Priority level of IRQ26. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority26_t;

// P_PRIORITY26.PRIORITY26 - Priority level of IRQ26. 0 = Interrupt disabled
#define PLIC_P_PRIORITY26_PRIORITY26_WIDTH 3
#define PLIC_P_PRIORITY26_PRIORITY26_LSB 0
#define PLIC_P_PRIORITY26_PRIORITY26_MASK 0x7
#define PLIC_P_PRIORITY26_PRIORITY26_RESET 0x0

// P_PRIORITY27 - Priority Register IRQ27 (3-bit, 8 levels)
#define PLIC_P_PRIORITY27_ADDR 0x6c
#define PLIC_P_PRIORITY27_RESET 0x0
typedef struct {
    uint32_t PRIORITY27 : 3; // Priority level of IRQ27. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority27_t;

// P_PRIORITY27.PRIORITY27 - Priority level of IRQ27. 0 = Interrupt disabled
#define PLIC_P_PRIORITY27_PRIORITY27_WIDTH 3
#define PLIC_P_PRIORITY27_PRIORITY27_LSB 0
#define PLIC_P_PRIORITY27_PRIORITY27_MASK 0x7
#define PLIC_P_PRIORITY27_PRIORITY27_RESET 0x0

// P_PRIORITY28 - Priority Register IRQ28 (3-bit, 8 levels)
#define PLIC_P_PRIORITY28_ADDR 0x70
#define PLIC_P_PRIORITY28_RESET 0x0
typedef struct {
    uint32_t PRIORITY28 : 3; // Priority level of IRQ28. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority28_t;

// P_PRIORITY28.PRIORITY28 - Priority level of IRQ28. 0 = Interrupt disabled
#define PLIC_P_PRIORITY28_PRIORITY28_WIDTH 3
#define PLIC_P_PRIORITY28_PRIORITY28_LSB 0
#define PLIC_P_PRIORITY28_PRIORITY28_MASK 0x7
#define PLIC_P_PRIORITY28_PRIORITY28_RESET 0x0

// P_PRIORITY29 - Priority Register IRQ29 (3-bit, 8 levels)
#define PLIC_P_PRIORITY29_ADDR 0x74
#define PLIC_P_PRIORITY29_RESET 0x0
typedef struct {
    uint32_t PRIORITY29 : 3; // Priority level of IRQ29. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority29_t;

// P_PRIORITY29.PRIORITY29 - Priority level of IRQ29. 0 = Interrupt disabled
#define PLIC_P_PRIORITY29_PRIORITY29_WIDTH 3
#define PLIC_P_PRIORITY29_PRIORITY29_LSB 0
#define PLIC_P_PRIORITY29_PRIORITY29_MASK 0x7
#define PLIC_P_PRIORITY29_PRIORITY29_RESET 0x0

// P_PRIORITY30 - Priority Register IRQ30 (3-bit, 8 levels)
#define PLIC_P_PRIORITY30_ADDR 0x78
#define PLIC_P_PRIORITY30_RESET 0x0
typedef struct {
    uint32_t PRIORITY30 : 3; // Priority level of IRQ30. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority30_t;

// P_PRIORITY30.PRIORITY30 - Priority level of IRQ30. 0 = Interrupt disabled
#define PLIC_P_PRIORITY30_PRIORITY30_WIDTH 3
#define PLIC_P_PRIORITY30_PRIORITY30_LSB 0
#define PLIC_P_PRIORITY30_PRIORITY30_MASK 0x7
#define PLIC_P_PRIORITY30_PRIORITY30_RESET 0x0

// P_PRIORITY31 - Priority Register IRQ31 (3-bit, 8 levels)
#define PLIC_P_PRIORITY31_ADDR 0x7c
#define PLIC_P_PRIORITY31_RESET 0x0
typedef struct {
    uint32_t PRIORITY31 : 3; // Priority level of IRQ31. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority31_t;

// P_PRIORITY31.PRIORITY31 - Priority level of IRQ31. 0 = Interrupt disabled
#define PLIC_P_PRIORITY31_PRIORITY31_WIDTH 3
#define PLIC_P_PRIORITY31_PRIORITY31_LSB 0
#define PLIC_P_PRIORITY31_PRIORITY31_MASK 0x7
#define PLIC_P_PRIORITY31_PRIORITY31_RESET 0x0

// P_PRIORITY32 - Priority Register IRQ32 (3-bit, 8 levels)
#define PLIC_P_PRIORITY32_ADDR 0x80
#define PLIC_P_PRIORITY32_RESET 0x0
typedef struct {
    uint32_t PRIORITY32 : 3; // Priority level of IRQ32. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority32_t;

// P_PRIORITY32.PRIORITY32 - Priority level of IRQ32. 0 = Interrupt disabled
#define PLIC_P_PRIORITY32_PRIORITY32_WIDTH 3
#define PLIC_P_PRIORITY32_PRIORITY32_LSB 0
#define PLIC_P_PRIORITY32_PRIORITY32_MASK 0x7
#define PLIC_P_PRIORITY32_PRIORITY32_RESET 0x0

// P_PRIORITY33 - Priority Register IRQ33 (3-bit, 8 levels)
#define PLIC_P_PRIORITY33_ADDR 0x84
#define PLIC_P_PRIORITY33_RESET 0x0
typedef struct {
    uint32_t PRIORITY33 : 3; // Priority level of IRQ33. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority33_t;

// P_PRIORITY33.PRIORITY33 - Priority level of IRQ33. 0 = Interrupt disabled
#define PLIC_P_PRIORITY33_PRIORITY33_WIDTH 3
#define PLIC_P_PRIORITY33_PRIORITY33_LSB 0
#define PLIC_P_PRIORITY33_PRIORITY33_MASK 0x7
#define PLIC_P_PRIORITY33_PRIORITY33_RESET 0x0

// P_PRIORITY34 - Priority Register IRQ34 (3-bit, 8 levels)
#define PLIC_P_PRIORITY34_ADDR 0x88
#define PLIC_P_PRIORITY34_RESET 0x0
typedef struct {
    uint32_t PRIORITY34 : 3; // Priority level of IRQ34. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority34_t;

// P_PRIORITY34.PRIORITY34 - Priority level of IRQ34. 0 = Interrupt disabled
#define PLIC_P_PRIORITY34_PRIORITY34_WIDTH 3
#define PLIC_P_PRIORITY34_PRIORITY34_LSB 0
#define PLIC_P_PRIORITY34_PRIORITY34_MASK 0x7
#define PLIC_P_PRIORITY34_PRIORITY34_RESET 0x0

// P_PRIORITY35 - Priority Register IRQ35 (3-bit, 8 levels)
#define PLIC_P_PRIORITY35_ADDR 0x8c
#define PLIC_P_PRIORITY35_RESET 0x0
typedef struct {
    uint32_t PRIORITY35 : 3; // Priority level of IRQ35. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority35_t;

// P_PRIORITY35.PRIORITY35 - Priority level of IRQ35. 0 = Interrupt disabled
#define PLIC_P_PRIORITY35_PRIORITY35_WIDTH 3
#define PLIC_P_PRIORITY35_PRIORITY35_LSB 0
#define PLIC_P_PRIORITY35_PRIORITY35_MASK 0x7
#define PLIC_P_PRIORITY35_PRIORITY35_RESET 0x0

// P_PRIORITY36 - Priority Register IRQ36 (3-bit, 8 levels)
#define PLIC_P_PRIORITY36_ADDR 0x90
#define PLIC_P_PRIORITY36_RESET 0x0
typedef struct {
    uint32_t PRIORITY36 : 3; // Priority level of IRQ36. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority36_t;

// P_PRIORITY36.PRIORITY36 - Priority level of IRQ36. 0 = Interrupt disabled
#define PLIC_P_PRIORITY36_PRIORITY36_WIDTH 3
#define PLIC_P_PRIORITY36_PRIORITY36_LSB 0
#define PLIC_P_PRIORITY36_PRIORITY36_MASK 0x7
#define PLIC_P_PRIORITY36_PRIORITY36_RESET 0x0

// P_PRIORITY37 - Priority Register IRQ37 (3-bit, 8 levels)
#define PLIC_P_PRIORITY37_ADDR 0x94
#define PLIC_P_PRIORITY37_RESET 0x0
typedef struct {
    uint32_t PRIORITY37 : 3; // Priority level of IRQ37. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority37_t;

// P_PRIORITY37.PRIORITY37 - Priority level of IRQ37. 0 = Interrupt disabled
#define PLIC_P_PRIORITY37_PRIORITY37_WIDTH 3
#define PLIC_P_PRIORITY37_PRIORITY37_LSB 0
#define PLIC_P_PRIORITY37_PRIORITY37_MASK 0x7
#define PLIC_P_PRIORITY37_PRIORITY37_RESET 0x0

// P_PRIORITY38 - Priority Register IRQ38 (3-bit, 8 levels)
#define PLIC_P_PRIORITY38_ADDR 0x98
#define PLIC_P_PRIORITY38_RESET 0x0
typedef struct {
    uint32_t PRIORITY38 : 3; // Priority level of IRQ38. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority38_t;

// P_PRIORITY38.PRIORITY38 - Priority level of IRQ38. 0 = Interrupt disabled
#define PLIC_P_PRIORITY38_PRIORITY38_WIDTH 3
#define PLIC_P_PRIORITY38_PRIORITY38_LSB 0
#define PLIC_P_PRIORITY38_PRIORITY38_MASK 0x7
#define PLIC_P_PRIORITY38_PRIORITY38_RESET 0x0

// P_PRIORITY39 - Priority Register IRQ39 (3-bit, 8 levels)
#define PLIC_P_PRIORITY39_ADDR 0x9c
#define PLIC_P_PRIORITY39_RESET 0x0
typedef struct {
    uint32_t PRIORITY39 : 3; // Priority level of IRQ39. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority39_t;

// P_PRIORITY39.PRIORITY39 - Priority level of IRQ39. 0 = Interrupt disabled
#define PLIC_P_PRIORITY39_PRIORITY39_WIDTH 3
#define PLIC_P_PRIORITY39_PRIORITY39_LSB 0
#define PLIC_P_PRIORITY39_PRIORITY39_MASK 0x7
#define PLIC_P_PRIORITY39_PRIORITY39_RESET 0x0

// P_PRIORITY40 - Priority Register IRQ40 (3-bit, 8 levels)
#define PLIC_P_PRIORITY40_ADDR 0xa0
#define PLIC_P_PRIORITY40_RESET 0x0
typedef struct {
    uint32_t PRIORITY40 : 3; // Priority level of IRQ40. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority40_t;

// P_PRIORITY40.PRIORITY40 - Priority level of IRQ40. 0 = Interrupt disabled
#define PLIC_P_PRIORITY40_PRIORITY40_WIDTH 3
#define PLIC_P_PRIORITY40_PRIORITY40_LSB 0
#define PLIC_P_PRIORITY40_PRIORITY40_MASK 0x7
#define PLIC_P_PRIORITY40_PRIORITY40_RESET 0x0

// P_PRIORITY41 - Priority Register IRQ41 (3-bit, 8 levels)
#define PLIC_P_PRIORITY41_ADDR 0xa4
#define PLIC_P_PRIORITY41_RESET 0x0
typedef struct {
    uint32_t PRIORITY41 : 3; // Priority level of IRQ41. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority41_t;

// P_PRIORITY41.PRIORITY41 - Priority level of IRQ41. 0 = Interrupt disabled
#define PLIC_P_PRIORITY41_PRIORITY41_WIDTH 3
#define PLIC_P_PRIORITY41_PRIORITY41_LSB 0
#define PLIC_P_PRIORITY41_PRIORITY41_MASK 0x7
#define PLIC_P_PRIORITY41_PRIORITY41_RESET 0x0

// P_PRIORITY42 - Priority Register IRQ42 (3-bit, 8 levels)
#define PLIC_P_PRIORITY42_ADDR 0xa8
#define PLIC_P_PRIORITY42_RESET 0x0
typedef struct {
    uint32_t PRIORITY42 : 3; // Priority level of IRQ42. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority42_t;

// P_PRIORITY42.PRIORITY42 - Priority level of IRQ42. 0 = Interrupt disabled
#define PLIC_P_PRIORITY42_PRIORITY42_WIDTH 3
#define PLIC_P_PRIORITY42_PRIORITY42_LSB 0
#define PLIC_P_PRIORITY42_PRIORITY42_MASK 0x7
#define PLIC_P_PRIORITY42_PRIORITY42_RESET 0x0

// P_PRIORITY43 - Priority Register IRQ43 (3-bit, 8 levels)
#define PLIC_P_PRIORITY43_ADDR 0xac
#define PLIC_P_PRIORITY43_RESET 0x0
typedef struct {
    uint32_t PRIORITY43 : 3; // Priority level of IRQ43. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority43_t;

// P_PRIORITY43.PRIORITY43 - Priority level of IRQ43. 0 = Interrupt disabled
#define PLIC_P_PRIORITY43_PRIORITY43_WIDTH 3
#define PLIC_P_PRIORITY43_PRIORITY43_LSB 0
#define PLIC_P_PRIORITY43_PRIORITY43_MASK 0x7
#define PLIC_P_PRIORITY43_PRIORITY43_RESET 0x0

// P_PRIORITY44 - Priority Register IRQ44 (3-bit, 8 levels)
#define PLIC_P_PRIORITY44_ADDR 0xb0
#define PLIC_P_PRIORITY44_RESET 0x0
typedef struct {
    uint32_t PRIORITY44 : 3; // Priority level of IRQ44. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority44_t;

// P_PRIORITY44.PRIORITY44 - Priority level of IRQ44. 0 = Interrupt disabled
#define PLIC_P_PRIORITY44_PRIORITY44_WIDTH 3
#define PLIC_P_PRIORITY44_PRIORITY44_LSB 0
#define PLIC_P_PRIORITY44_PRIORITY44_MASK 0x7
#define PLIC_P_PRIORITY44_PRIORITY44_RESET 0x0

// P_PRIORITY45 - Priority Register IRQ45 (3-bit, 8 levels)
#define PLIC_P_PRIORITY45_ADDR 0xb4
#define PLIC_P_PRIORITY45_RESET 0x0
typedef struct {
    uint32_t PRIORITY45 : 3; // Priority level of IRQ45. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority45_t;

// P_PRIORITY45.PRIORITY45 - Priority level of IRQ45. 0 = Interrupt disabled
#define PLIC_P_PRIORITY45_PRIORITY45_WIDTH 3
#define PLIC_P_PRIORITY45_PRIORITY45_LSB 0
#define PLIC_P_PRIORITY45_PRIORITY45_MASK 0x7
#define PLIC_P_PRIORITY45_PRIORITY45_RESET 0x0

// P_PRIORITY46 - Priority Register IRQ46 (3-bit, 8 levels)
#define PLIC_P_PRIORITY46_ADDR 0xb8
#define PLIC_P_PRIORITY46_RESET 0x0
typedef struct {
    uint32_t PRIORITY46 : 3; // Priority level of IRQ46. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority46_t;

// P_PRIORITY46.PRIORITY46 - Priority level of IRQ46. 0 = Interrupt disabled
#define PLIC_P_PRIORITY46_PRIORITY46_WIDTH 3
#define PLIC_P_PRIORITY46_PRIORITY46_LSB 0
#define PLIC_P_PRIORITY46_PRIORITY46_MASK 0x7
#define PLIC_P_PRIORITY46_PRIORITY46_RESET 0x0

// P_PRIORITY47 - Priority Register IRQ47 (3-bit, 8 levels)
#define PLIC_P_PRIORITY47_ADDR 0xbc
#define PLIC_P_PRIORITY47_RESET 0x0
typedef struct {
    uint32_t PRIORITY47 : 3; // Priority level of IRQ47. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority47_t;

// P_PRIORITY47.PRIORITY47 - Priority level of IRQ47. 0 = Interrupt disabled
#define PLIC_P_PRIORITY47_PRIORITY47_WIDTH 3
#define PLIC_P_PRIORITY47_PRIORITY47_LSB 0
#define PLIC_P_PRIORITY47_PRIORITY47_MASK 0x7
#define PLIC_P_PRIORITY47_PRIORITY47_RESET 0x0

// P_PRIORITY48 - Priority Register IRQ48 (3-bit, 8 levels)
#define PLIC_P_PRIORITY48_ADDR 0xc0
#define PLIC_P_PRIORITY48_RESET 0x0
typedef struct {
    uint32_t PRIORITY48 : 3; // Priority level of IRQ48. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority48_t;

// P_PRIORITY48.PRIORITY48 - Priority level of IRQ48. 0 = Interrupt disabled
#define PLIC_P_PRIORITY48_PRIORITY48_WIDTH 3
#define PLIC_P_PRIORITY48_PRIORITY48_LSB 0
#define PLIC_P_PRIORITY48_PRIORITY48_MASK 0x7
#define PLIC_P_PRIORITY48_PRIORITY48_RESET 0x0

// P_PRIORITY49 - Priority Register IRQ49 (3-bit, 8 levels)
#define PLIC_P_PRIORITY49_ADDR 0xc4
#define PLIC_P_PRIORITY49_RESET 0x0
typedef struct {
    uint32_t PRIORITY49 : 3; // Priority level of IRQ49. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority49_t;

// P_PRIORITY49.PRIORITY49 - Priority level of IRQ49. 0 = Interrupt disabled
#define PLIC_P_PRIORITY49_PRIORITY49_WIDTH 3
#define PLIC_P_PRIORITY49_PRIORITY49_LSB 0
#define PLIC_P_PRIORITY49_PRIORITY49_MASK 0x7
#define PLIC_P_PRIORITY49_PRIORITY49_RESET 0x0

// P_PRIORITY50 - Priority Register IRQ50 (3-bit, 8 levels)
#define PLIC_P_PRIORITY50_ADDR 0xc8
#define PLIC_P_PRIORITY50_RESET 0x0
typedef struct {
    uint32_t PRIORITY50 : 3; // Priority level of IRQ50. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority50_t;

// P_PRIORITY50.PRIORITY50 - Priority level of IRQ50. 0 = Interrupt disabled
#define PLIC_P_PRIORITY50_PRIORITY50_WIDTH 3
#define PLIC_P_PRIORITY50_PRIORITY50_LSB 0
#define PLIC_P_PRIORITY50_PRIORITY50_MASK 0x7
#define PLIC_P_PRIORITY50_PRIORITY50_RESET 0x0

// P_PRIORITY51 - Priority Register IRQ51 (3-bit, 8 levels)
#define PLIC_P_PRIORITY51_ADDR 0xcc
#define PLIC_P_PRIORITY51_RESET 0x0
typedef struct {
    uint32_t PRIORITY51 : 3; // Priority level of IRQ51. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority51_t;

// P_PRIORITY51.PRIORITY51 - Priority level of IRQ51. 0 = Interrupt disabled
#define PLIC_P_PRIORITY51_PRIORITY51_WIDTH 3
#define PLIC_P_PRIORITY51_PRIORITY51_LSB 0
#define PLIC_P_PRIORITY51_PRIORITY51_MASK 0x7
#define PLIC_P_PRIORITY51_PRIORITY51_RESET 0x0

// P_PRIORITY52 - Priority Register IRQ52 (3-bit, 8 levels)
#define PLIC_P_PRIORITY52_ADDR 0xd0
#define PLIC_P_PRIORITY52_RESET 0x0
typedef struct {
    uint32_t PRIORITY52 : 3; // Priority level of IRQ52. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority52_t;

// P_PRIORITY52.PRIORITY52 - Priority level of IRQ52. 0 = Interrupt disabled
#define PLIC_P_PRIORITY52_PRIORITY52_WIDTH 3
#define PLIC_P_PRIORITY52_PRIORITY52_LSB 0
#define PLIC_P_PRIORITY52_PRIORITY52_MASK 0x7
#define PLIC_P_PRIORITY52_PRIORITY52_RESET 0x0

// P_PRIORITY53 - Priority Register IRQ53 (3-bit, 8 levels)
#define PLIC_P_PRIORITY53_ADDR 0xd4
#define PLIC_P_PRIORITY53_RESET 0x0
typedef struct {
    uint32_t PRIORITY53 : 3; // Priority level of IRQ53. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority53_t;

// P_PRIORITY53.PRIORITY53 - Priority level of IRQ53. 0 = Interrupt disabled
#define PLIC_P_PRIORITY53_PRIORITY53_WIDTH 3
#define PLIC_P_PRIORITY53_PRIORITY53_LSB 0
#define PLIC_P_PRIORITY53_PRIORITY53_MASK 0x7
#define PLIC_P_PRIORITY53_PRIORITY53_RESET 0x0

// P_PRIORITY54 - Priority Register IRQ54 (3-bit, 8 levels)
#define PLIC_P_PRIORITY54_ADDR 0xd8
#define PLIC_P_PRIORITY54_RESET 0x0
typedef struct {
    uint32_t PRIORITY54 : 3; // Priority level of IRQ54. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority54_t;

// P_PRIORITY54.PRIORITY54 - Priority level of IRQ54. 0 = Interrupt disabled
#define PLIC_P_PRIORITY54_PRIORITY54_WIDTH 3
#define PLIC_P_PRIORITY54_PRIORITY54_LSB 0
#define PLIC_P_PRIORITY54_PRIORITY54_MASK 0x7
#define PLIC_P_PRIORITY54_PRIORITY54_RESET 0x0

// P_PRIORITY55 - Priority Register IRQ55 (3-bit, 8 levels)
#define PLIC_P_PRIORITY55_ADDR 0xdc
#define PLIC_P_PRIORITY55_RESET 0x0
typedef struct {
    uint32_t PRIORITY55 : 3; // Priority level of IRQ55. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority55_t;

// P_PRIORITY55.PRIORITY55 - Priority level of IRQ55. 0 = Interrupt disabled
#define PLIC_P_PRIORITY55_PRIORITY55_WIDTH 3
#define PLIC_P_PRIORITY55_PRIORITY55_LSB 0
#define PLIC_P_PRIORITY55_PRIORITY55_MASK 0x7
#define PLIC_P_PRIORITY55_PRIORITY55_RESET 0x0

// P_PRIORITY56 - Priority Register IRQ56 (3-bit, 8 levels)
#define PLIC_P_PRIORITY56_ADDR 0xe0
#define PLIC_P_PRIORITY56_RESET 0x0
typedef struct {
    uint32_t PRIORITY56 : 3; // Priority level of IRQ56. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority56_t;

// P_PRIORITY56.PRIORITY56 - Priority level of IRQ56. 0 = Interrupt disabled
#define PLIC_P_PRIORITY56_PRIORITY56_WIDTH 3
#define PLIC_P_PRIORITY56_PRIORITY56_LSB 0
#define PLIC_P_PRIORITY56_PRIORITY56_MASK 0x7
#define PLIC_P_PRIORITY56_PRIORITY56_RESET 0x0

// P_PRIORITY57 - Priority Register IRQ57 (3-bit, 8 levels)
#define PLIC_P_PRIORITY57_ADDR 0xe4
#define PLIC_P_PRIORITY57_RESET 0x0
typedef struct {
    uint32_t PRIORITY57 : 3; // Priority level of IRQ57. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority57_t;

// P_PRIORITY57.PRIORITY57 - Priority level of IRQ57. 0 = Interrupt disabled
#define PLIC_P_PRIORITY57_PRIORITY57_WIDTH 3
#define PLIC_P_PRIORITY57_PRIORITY57_LSB 0
#define PLIC_P_PRIORITY57_PRIORITY57_MASK 0x7
#define PLIC_P_PRIORITY57_PRIORITY57_RESET 0x0

// P_PRIORITY58 - Priority Register IRQ58 (3-bit, 8 levels)
#define PLIC_P_PRIORITY58_ADDR 0xe8
#define PLIC_P_PRIORITY58_RESET 0x0
typedef struct {
    uint32_t PRIORITY58 : 3; // Priority level of IRQ58. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority58_t;

// P_PRIORITY58.PRIORITY58 - Priority level of IRQ58. 0 = Interrupt disabled
#define PLIC_P_PRIORITY58_PRIORITY58_WIDTH 3
#define PLIC_P_PRIORITY58_PRIORITY58_LSB 0
#define PLIC_P_PRIORITY58_PRIORITY58_MASK 0x7
#define PLIC_P_PRIORITY58_PRIORITY58_RESET 0x0

// P_PRIORITY59 - Priority Register IRQ59 (3-bit, 8 levels)
#define PLIC_P_PRIORITY59_ADDR 0xec
#define PLIC_P_PRIORITY59_RESET 0x0
typedef struct {
    uint32_t PRIORITY59 : 3; // Priority level of IRQ59. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority59_t;

// P_PRIORITY59.PRIORITY59 - Priority level of IRQ59. 0 = Interrupt disabled
#define PLIC_P_PRIORITY59_PRIORITY59_WIDTH 3
#define PLIC_P_PRIORITY59_PRIORITY59_LSB 0
#define PLIC_P_PRIORITY59_PRIORITY59_MASK 0x7
#define PLIC_P_PRIORITY59_PRIORITY59_RESET 0x0

// P_PRIORITY60 - Priority Register IRQ60 (3-bit, 8 levels)
#define PLIC_P_PRIORITY60_ADDR 0xf0
#define PLIC_P_PRIORITY60_RESET 0x0
typedef struct {
    uint32_t PRIORITY60 : 3; // Priority level of IRQ60. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority60_t;

// P_PRIORITY60.PRIORITY60 - Priority level of IRQ60. 0 = Interrupt disabled
#define PLIC_P_PRIORITY60_PRIORITY60_WIDTH 3
#define PLIC_P_PRIORITY60_PRIORITY60_LSB 0
#define PLIC_P_PRIORITY60_PRIORITY60_MASK 0x7
#define PLIC_P_PRIORITY60_PRIORITY60_RESET 0x0

// P_PRIORITY61 - Priority Register IRQ61 (3-bit, 8 levels)
#define PLIC_P_PRIORITY61_ADDR 0xf4
#define PLIC_P_PRIORITY61_RESET 0x0
typedef struct {
    uint32_t PRIORITY61 : 3; // Priority level of IRQ61. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority61_t;

// P_PRIORITY61.PRIORITY61 - Priority level of IRQ61. 0 = Interrupt disabled
#define PLIC_P_PRIORITY61_PRIORITY61_WIDTH 3
#define PLIC_P_PRIORITY61_PRIORITY61_LSB 0
#define PLIC_P_PRIORITY61_PRIORITY61_MASK 0x7
#define PLIC_P_PRIORITY61_PRIORITY61_RESET 0x0

// P_PRIORITY62 - Priority Register IRQ62 (3-bit, 8 levels)
#define PLIC_P_PRIORITY62_ADDR 0xf8
#define PLIC_P_PRIORITY62_RESET 0x0
typedef struct {
    uint32_t PRIORITY62 : 3; // Priority level of IRQ62. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority62_t;

// P_PRIORITY62.PRIORITY62 - Priority level of IRQ62. 0 = Interrupt disabled
#define PLIC_P_PRIORITY62_PRIORITY62_WIDTH 3
#define PLIC_P_PRIORITY62_PRIORITY62_LSB 0
#define PLIC_P_PRIORITY62_PRIORITY62_MASK 0x7
#define PLIC_P_PRIORITY62_PRIORITY62_RESET 0x0

// P_PRIORITY63 - Priority Register IRQ63 (3-bit, 8 levels)
#define PLIC_P_PRIORITY63_ADDR 0xfc
#define PLIC_P_PRIORITY63_RESET 0x0
typedef struct {
    uint32_t PRIORITY63 : 3; // Priority level of IRQ63. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority63_t;

// P_PRIORITY63.PRIORITY63 - Priority level of IRQ63. 0 = Interrupt disabled
#define PLIC_P_PRIORITY63_PRIORITY63_WIDTH 3
#define PLIC_P_PRIORITY63_PRIORITY63_LSB 0
#define PLIC_P_PRIORITY63_PRIORITY63_MASK 0x7
#define PLIC_P_PRIORITY63_PRIORITY63_RESET 0x0

// P_PRIORITY64 - Priority Register IRQ64 (3-bit, 8 levels)
#define PLIC_P_PRIORITY64_ADDR 0x100
#define PLIC_P_PRIORITY64_RESET 0x0
typedef struct {
    uint32_t PRIORITY64 : 3; // Priority level of IRQ64. 0 = Interrupt disabled
    uint32_t : 29; // reserved
} plic_p_priority64_t;

// P_PRIORITY64.PRIORITY64 - Priority level of IRQ64. 0 = Interrupt disabled
#define PLIC_P_PRIORITY64_PRIORITY64_WIDTH 3
#define PLIC_P_PRIORITY64_PRIORITY64_LSB 0
#define PLIC_P_PRIORITY64_PRIORITY64_MASK 0x7
#define PLIC_P_PRIORITY64_PRIORITY64_RESET 0x0

// P_PENDING0 - Pending bits for IRQ1–IRQ31
#define PLIC_P_PENDING0_ADDR 0x1000
#define PLIC_P_PENDING0_RESET 0x0
typedef struct {
    uint32_t : 1; // reserved
    uint32_t PENDING_IRQ1 : 1; // Pending status of IRQ1
    uint32_t PENDING_IRQ2 : 1; // Pending status of IRQ2
    uint32_t PENDING_IRQ3 : 1; // Pending status of IRQ3
    uint32_t PENDING_IRQ4 : 1; // Pending status of IRQ4
    uint32_t PENDING_IRQ5 : 1; // Pending status of IRQ5
    uint32_t PENDING_IRQ6 : 1; // Pending status of IRQ6
    uint32_t PENDING_IRQ7 : 1; // Pending status of IRQ7
    uint32_t PENDING_IRQ8 : 1; // Pending status of IRQ8
    uint32_t PENDING_IRQ9 : 1; // Pending status of IRQ9
    uint32_t PENDING_IRQ10 : 1; // Pending status of IRQ10
    uint32_t PENDING_IRQ11 : 1; // Pending status of IRQ11
    uint32_t PENDING_IRQ12 : 1; // Pending status of IRQ12
    uint32_t PENDING_IRQ13 : 1; // Pending status of IRQ13
    uint32_t PENDING_IRQ14 : 1; // Pending status of IRQ14
    uint32_t PENDING_IRQ15 : 1; // Pending status of IRQ15
    uint32_t PENDING_IRQ16 : 1; // Pending status of IRQ16
    uint32_t PENDING_IRQ17 : 1; // Pending status of IRQ17
    uint32_t PENDING_IRQ18 : 1; // Pending status of IRQ18
    uint32_t PENDING_IRQ19 : 1; // Pending status of IRQ19
    uint32_t PENDING_IRQ20 : 1; // Pending status of IRQ20
    uint32_t PENDING_IRQ21 : 1; // Pending status of IRQ21
    uint32_t PENDING_IRQ22 : 1; // Pending status of IRQ22
    uint32_t PENDING_IRQ23 : 1; // Pending status of IRQ23
    uint32_t PENDING_IRQ24 : 1; // Pending status of IRQ24
    uint32_t PENDING_IRQ25 : 1; // Pending status of IRQ25
    uint32_t PENDING_IRQ26 : 1; // Pending status of IRQ26
    uint32_t PENDING_IRQ27 : 1; // Pending status of IRQ27
    uint32_t PENDING_IRQ28 : 1; // Pending status of IRQ28
    uint32_t PENDING_IRQ29 : 1; // Pending status of IRQ29
    uint32_t PENDING_IRQ30 : 1; // Pending status of IRQ30
    uint32_t PENDING_IRQ31 : 1; // Pending status of IRQ31
} plic_p_pending0_t;

// P_PENDING0.PENDING_IRQ1 - Pending status of IRQ1
#define PLIC_P_PENDING0_PENDING_IRQ1_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ1_LSB 1
#define PLIC_P_PENDING0_PENDING_IRQ1_MASK 0x2
#define PLIC_P_PENDING0_PENDING_IRQ1_RESET 0x0

// P_PENDING0.PENDING_IRQ2 - Pending status of IRQ2
#define PLIC_P_PENDING0_PENDING_IRQ2_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ2_LSB 2
#define PLIC_P_PENDING0_PENDING_IRQ2_MASK 0x4
#define PLIC_P_PENDING0_PENDING_IRQ2_RESET 0x0

// P_PENDING0.PENDING_IRQ3 - Pending status of IRQ3
#define PLIC_P_PENDING0_PENDING_IRQ3_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ3_LSB 3
#define PLIC_P_PENDING0_PENDING_IRQ3_MASK 0x8
#define PLIC_P_PENDING0_PENDING_IRQ3_RESET 0x0

// P_PENDING0.PENDING_IRQ4 - Pending status of IRQ4
#define PLIC_P_PENDING0_PENDING_IRQ4_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ4_LSB 4
#define PLIC_P_PENDING0_PENDING_IRQ4_MASK 0x10
#define PLIC_P_PENDING0_PENDING_IRQ4_RESET 0x0

// P_PENDING0.PENDING_IRQ5 - Pending status of IRQ5
#define PLIC_P_PENDING0_PENDING_IRQ5_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ5_LSB 5
#define PLIC_P_PENDING0_PENDING_IRQ5_MASK 0x20
#define PLIC_P_PENDING0_PENDING_IRQ5_RESET 0x0

// P_PENDING0.PENDING_IRQ6 - Pending status of IRQ6
#define PLIC_P_PENDING0_PENDING_IRQ6_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ6_LSB 6
#define PLIC_P_PENDING0_PENDING_IRQ6_MASK 0x40
#define PLIC_P_PENDING0_PENDING_IRQ6_RESET 0x0

// P_PENDING0.PENDING_IRQ7 - Pending status of IRQ7
#define PLIC_P_PENDING0_PENDING_IRQ7_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ7_LSB 7
#define PLIC_P_PENDING0_PENDING_IRQ7_MASK 0x80
#define PLIC_P_PENDING0_PENDING_IRQ7_RESET 0x0

// P_PENDING0.PENDING_IRQ8 - Pending status of IRQ8
#define PLIC_P_PENDING0_PENDING_IRQ8_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ8_LSB 8
#define PLIC_P_PENDING0_PENDING_IRQ8_MASK 0x100
#define PLIC_P_PENDING0_PENDING_IRQ8_RESET 0x0

// P_PENDING0.PENDING_IRQ9 - Pending status of IRQ9
#define PLIC_P_PENDING0_PENDING_IRQ9_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ9_LSB 9
#define PLIC_P_PENDING0_PENDING_IRQ9_MASK 0x200
#define PLIC_P_PENDING0_PENDING_IRQ9_RESET 0x0

// P_PENDING0.PENDING_IRQ10 - Pending status of IRQ10
#define PLIC_P_PENDING0_PENDING_IRQ10_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ10_LSB 10
#define PLIC_P_PENDING0_PENDING_IRQ10_MASK 0x400
#define PLIC_P_PENDING0_PENDING_IRQ10_RESET 0x0

// P_PENDING0.PENDING_IRQ11 - Pending status of IRQ11
#define PLIC_P_PENDING0_PENDING_IRQ11_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ11_LSB 11
#define PLIC_P_PENDING0_PENDING_IRQ11_MASK 0x800
#define PLIC_P_PENDING0_PENDING_IRQ11_RESET 0x0

// P_PENDING0.PENDING_IRQ12 - Pending status of IRQ12
#define PLIC_P_PENDING0_PENDING_IRQ12_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ12_LSB 12
#define PLIC_P_PENDING0_PENDING_IRQ12_MASK 0x1000
#define PLIC_P_PENDING0_PENDING_IRQ12_RESET 0x0

// P_PENDING0.PENDING_IRQ13 - Pending status of IRQ13
#define PLIC_P_PENDING0_PENDING_IRQ13_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ13_LSB 13
#define PLIC_P_PENDING0_PENDING_IRQ13_MASK 0x2000
#define PLIC_P_PENDING0_PENDING_IRQ13_RESET 0x0

// P_PENDING0.PENDING_IRQ14 - Pending status of IRQ14
#define PLIC_P_PENDING0_PENDING_IRQ14_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ14_LSB 14
#define PLIC_P_PENDING0_PENDING_IRQ14_MASK 0x4000
#define PLIC_P_PENDING0_PENDING_IRQ14_RESET 0x0

// P_PENDING0.PENDING_IRQ15 - Pending status of IRQ15
#define PLIC_P_PENDING0_PENDING_IRQ15_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ15_LSB 15
#define PLIC_P_PENDING0_PENDING_IRQ15_MASK 0x8000
#define PLIC_P_PENDING0_PENDING_IRQ15_RESET 0x0

// P_PENDING0.PENDING_IRQ16 - Pending status of IRQ16
#define PLIC_P_PENDING0_PENDING_IRQ16_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ16_LSB 16
#define PLIC_P_PENDING0_PENDING_IRQ16_MASK 0x10000
#define PLIC_P_PENDING0_PENDING_IRQ16_RESET 0x0

// P_PENDING0.PENDING_IRQ17 - Pending status of IRQ17
#define PLIC_P_PENDING0_PENDING_IRQ17_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ17_LSB 17
#define PLIC_P_PENDING0_PENDING_IRQ17_MASK 0x20000
#define PLIC_P_PENDING0_PENDING_IRQ17_RESET 0x0

// P_PENDING0.PENDING_IRQ18 - Pending status of IRQ18
#define PLIC_P_PENDING0_PENDING_IRQ18_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ18_LSB 18
#define PLIC_P_PENDING0_PENDING_IRQ18_MASK 0x40000
#define PLIC_P_PENDING0_PENDING_IRQ18_RESET 0x0

// P_PENDING0.PENDING_IRQ19 - Pending status of IRQ19
#define PLIC_P_PENDING0_PENDING_IRQ19_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ19_LSB 19
#define PLIC_P_PENDING0_PENDING_IRQ19_MASK 0x80000
#define PLIC_P_PENDING0_PENDING_IRQ19_RESET 0x0

// P_PENDING0.PENDING_IRQ20 - Pending status of IRQ20
#define PLIC_P_PENDING0_PENDING_IRQ20_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ20_LSB 20
#define PLIC_P_PENDING0_PENDING_IRQ20_MASK 0x100000
#define PLIC_P_PENDING0_PENDING_IRQ20_RESET 0x0

// P_PENDING0.PENDING_IRQ21 - Pending status of IRQ21
#define PLIC_P_PENDING0_PENDING_IRQ21_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ21_LSB 21
#define PLIC_P_PENDING0_PENDING_IRQ21_MASK 0x200000
#define PLIC_P_PENDING0_PENDING_IRQ21_RESET 0x0

// P_PENDING0.PENDING_IRQ22 - Pending status of IRQ22
#define PLIC_P_PENDING0_PENDING_IRQ22_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ22_LSB 22
#define PLIC_P_PENDING0_PENDING_IRQ22_MASK 0x400000
#define PLIC_P_PENDING0_PENDING_IRQ22_RESET 0x0

// P_PENDING0.PENDING_IRQ23 - Pending status of IRQ23
#define PLIC_P_PENDING0_PENDING_IRQ23_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ23_LSB 23
#define PLIC_P_PENDING0_PENDING_IRQ23_MASK 0x800000
#define PLIC_P_PENDING0_PENDING_IRQ23_RESET 0x0

// P_PENDING0.PENDING_IRQ24 - Pending status of IRQ24
#define PLIC_P_PENDING0_PENDING_IRQ24_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ24_LSB 24
#define PLIC_P_PENDING0_PENDING_IRQ24_MASK 0x1000000
#define PLIC_P_PENDING0_PENDING_IRQ24_RESET 0x0

// P_PENDING0.PENDING_IRQ25 - Pending status of IRQ25
#define PLIC_P_PENDING0_PENDING_IRQ25_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ25_LSB 25
#define PLIC_P_PENDING0_PENDING_IRQ25_MASK 0x2000000
#define PLIC_P_PENDING0_PENDING_IRQ25_RESET 0x0

// P_PENDING0.PENDING_IRQ26 - Pending status of IRQ26
#define PLIC_P_PENDING0_PENDING_IRQ26_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ26_LSB 26
#define PLIC_P_PENDING0_PENDING_IRQ26_MASK 0x4000000
#define PLIC_P_PENDING0_PENDING_IRQ26_RESET 0x0

// P_PENDING0.PENDING_IRQ27 - Pending status of IRQ27
#define PLIC_P_PENDING0_PENDING_IRQ27_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ27_LSB 27
#define PLIC_P_PENDING0_PENDING_IRQ27_MASK 0x8000000
#define PLIC_P_PENDING0_PENDING_IRQ27_RESET 0x0

// P_PENDING0.PENDING_IRQ28 - Pending status of IRQ28
#define PLIC_P_PENDING0_PENDING_IRQ28_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ28_LSB 28
#define PLIC_P_PENDING0_PENDING_IRQ28_MASK 0x10000000
#define PLIC_P_PENDING0_PENDING_IRQ28_RESET 0x0

// P_PENDING0.PENDING_IRQ29 - Pending status of IRQ29
#define PLIC_P_PENDING0_PENDING_IRQ29_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ29_LSB 29
#define PLIC_P_PENDING0_PENDING_IRQ29_MASK 0x20000000
#define PLIC_P_PENDING0_PENDING_IRQ29_RESET 0x0

// P_PENDING0.PENDING_IRQ30 - Pending status of IRQ30
#define PLIC_P_PENDING0_PENDING_IRQ30_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ30_LSB 30
#define PLIC_P_PENDING0_PENDING_IRQ30_MASK 0x40000000
#define PLIC_P_PENDING0_PENDING_IRQ30_RESET 0x0

// P_PENDING0.PENDING_IRQ31 - Pending status of IRQ31
#define PLIC_P_PENDING0_PENDING_IRQ31_WIDTH 1
#define PLIC_P_PENDING0_PENDING_IRQ31_LSB 31
#define PLIC_P_PENDING0_PENDING_IRQ31_MASK 0x80000000
#define PLIC_P_PENDING0_PENDING_IRQ31_RESET 0x0

// P_PENDING1 - Pending bits for IRQ32–IRQ62
#define PLIC_P_PENDING1_ADDR 0x1004
#define PLIC_P_PENDING1_RESET 0x0
typedef struct {
    uint32_t : 1; // reserved
    uint32_t PENDING_IRQ32 : 1; // Pending status of IRQ32
    uint32_t PENDING_IRQ33 : 1; // Pending status of IRQ33
    uint32_t PENDING_IRQ34 : 1; // Pending status of IRQ34
    uint32_t PENDING_IRQ35 : 1; // Pending status of IRQ35
    uint32_t PENDING_IRQ36 : 1; // Pending status of IRQ36
    uint32_t PENDING_IRQ37 : 1; // Pending status of IRQ37
    uint32_t PENDING_IRQ38 : 1; // Pending status of IRQ38
    uint32_t PENDING_IRQ39 : 1; // Pending status of IRQ39
    uint32_t PENDING_IRQ40 : 1; // Pending status of IRQ40
    uint32_t PENDING_IRQ41 : 1; // Pending status of IRQ41
    uint32_t PENDING_IRQ42 : 1; // Pending status of IRQ42
    uint32_t PENDING_IRQ43 : 1; // Pending status of IRQ43
    uint32_t PENDING_IRQ44 : 1; // Pending status of IRQ44
    uint32_t PENDING_IRQ45 : 1; // Pending status of IRQ45
    uint32_t PENDING_IRQ46 : 1; // Pending status of IRQ46
    uint32_t PENDING_IRQ47 : 1; // Pending status of IRQ47
    uint32_t PENDING_IRQ48 : 1; // Pending status of IRQ48
    uint32_t PENDING_IRQ49 : 1; // Pending status of IRQ49
    uint32_t PENDING_IRQ50 : 1; // Pending status of IRQ50
    uint32_t PENDING_IRQ51 : 1; // Pending status of IRQ51
    uint32_t PENDING_IRQ52 : 1; // Pending status of IRQ52
    uint32_t PENDING_IRQ53 : 1; // Pending status of IRQ53
    uint32_t PENDING_IRQ54 : 1; // Pending status of IRQ54
    uint32_t PENDING_IRQ55 : 1; // Pending status of IRQ55
    uint32_t PENDING_IRQ56 : 1; // Pending status of IRQ56
    uint32_t PENDING_IRQ57 : 1; // Pending status of IRQ57
    uint32_t PENDING_IRQ58 : 1; // Pending status of IRQ58
    uint32_t PENDING_IRQ59 : 1; // Pending status of IRQ59
    uint32_t PENDING_IRQ60 : 1; // Pending status of IRQ60
    uint32_t PENDING_IRQ61 : 1; // Pending status of IRQ61
    uint32_t PENDING_IRQ62 : 1; // Pending status of IRQ62
} plic_p_pending1_t;

// P_PENDING1.PENDING_IRQ32 - Pending status of IRQ32
#define PLIC_P_PENDING1_PENDING_IRQ32_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ32_LSB 1
#define PLIC_P_PENDING1_PENDING_IRQ32_MASK 0x2
#define PLIC_P_PENDING1_PENDING_IRQ32_RESET 0x0

// P_PENDING1.PENDING_IRQ33 - Pending status of IRQ33
#define PLIC_P_PENDING1_PENDING_IRQ33_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ33_LSB 2
#define PLIC_P_PENDING1_PENDING_IRQ33_MASK 0x4
#define PLIC_P_PENDING1_PENDING_IRQ33_RESET 0x0

// P_PENDING1.PENDING_IRQ34 - Pending status of IRQ34
#define PLIC_P_PENDING1_PENDING_IRQ34_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ34_LSB 3
#define PLIC_P_PENDING1_PENDING_IRQ34_MASK 0x8
#define PLIC_P_PENDING1_PENDING_IRQ34_RESET 0x0

// P_PENDING1.PENDING_IRQ35 - Pending status of IRQ35
#define PLIC_P_PENDING1_PENDING_IRQ35_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ35_LSB 4
#define PLIC_P_PENDING1_PENDING_IRQ35_MASK 0x10
#define PLIC_P_PENDING1_PENDING_IRQ35_RESET 0x0

// P_PENDING1.PENDING_IRQ36 - Pending status of IRQ36
#define PLIC_P_PENDING1_PENDING_IRQ36_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ36_LSB 5
#define PLIC_P_PENDING1_PENDING_IRQ36_MASK 0x20
#define PLIC_P_PENDING1_PENDING_IRQ36_RESET 0x0

// P_PENDING1.PENDING_IRQ37 - Pending status of IRQ37
#define PLIC_P_PENDING1_PENDING_IRQ37_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ37_LSB 6
#define PLIC_P_PENDING1_PENDING_IRQ37_MASK 0x40
#define PLIC_P_PENDING1_PENDING_IRQ37_RESET 0x0

// P_PENDING1.PENDING_IRQ38 - Pending status of IRQ38
#define PLIC_P_PENDING1_PENDING_IRQ38_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ38_LSB 7
#define PLIC_P_PENDING1_PENDING_IRQ38_MASK 0x80
#define PLIC_P_PENDING1_PENDING_IRQ38_RESET 0x0

// P_PENDING1.PENDING_IRQ39 - Pending status of IRQ39
#define PLIC_P_PENDING1_PENDING_IRQ39_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ39_LSB 8
#define PLIC_P_PENDING1_PENDING_IRQ39_MASK 0x100
#define PLIC_P_PENDING1_PENDING_IRQ39_RESET 0x0

// P_PENDING1.PENDING_IRQ40 - Pending status of IRQ40
#define PLIC_P_PENDING1_PENDING_IRQ40_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ40_LSB 9
#define PLIC_P_PENDING1_PENDING_IRQ40_MASK 0x200
#define PLIC_P_PENDING1_PENDING_IRQ40_RESET 0x0

// P_PENDING1.PENDING_IRQ41 - Pending status of IRQ41
#define PLIC_P_PENDING1_PENDING_IRQ41_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ41_LSB 10
#define PLIC_P_PENDING1_PENDING_IRQ41_MASK 0x400
#define PLIC_P_PENDING1_PENDING_IRQ41_RESET 0x0

// P_PENDING1.PENDING_IRQ42 - Pending status of IRQ42
#define PLIC_P_PENDING1_PENDING_IRQ42_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ42_LSB 11
#define PLIC_P_PENDING1_PENDING_IRQ42_MASK 0x800
#define PLIC_P_PENDING1_PENDING_IRQ42_RESET 0x0

// P_PENDING1.PENDING_IRQ43 - Pending status of IRQ43
#define PLIC_P_PENDING1_PENDING_IRQ43_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ43_LSB 12
#define PLIC_P_PENDING1_PENDING_IRQ43_MASK 0x1000
#define PLIC_P_PENDING1_PENDING_IRQ43_RESET 0x0

// P_PENDING1.PENDING_IRQ44 - Pending status of IRQ44
#define PLIC_P_PENDING1_PENDING_IRQ44_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ44_LSB 13
#define PLIC_P_PENDING1_PENDING_IRQ44_MASK 0x2000
#define PLIC_P_PENDING1_PENDING_IRQ44_RESET 0x0

// P_PENDING1.PENDING_IRQ45 - Pending status of IRQ45
#define PLIC_P_PENDING1_PENDING_IRQ45_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ45_LSB 14
#define PLIC_P_PENDING1_PENDING_IRQ45_MASK 0x4000
#define PLIC_P_PENDING1_PENDING_IRQ45_RESET 0x0

// P_PENDING1.PENDING_IRQ46 - Pending status of IRQ46
#define PLIC_P_PENDING1_PENDING_IRQ46_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ46_LSB 15
#define PLIC_P_PENDING1_PENDING_IRQ46_MASK 0x8000
#define PLIC_P_PENDING1_PENDING_IRQ46_RESET 0x0

// P_PENDING1.PENDING_IRQ47 - Pending status of IRQ47
#define PLIC_P_PENDING1_PENDING_IRQ47_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ47_LSB 16
#define PLIC_P_PENDING1_PENDING_IRQ47_MASK 0x10000
#define PLIC_P_PENDING1_PENDING_IRQ47_RESET 0x0

// P_PENDING1.PENDING_IRQ48 - Pending status of IRQ48
#define PLIC_P_PENDING1_PENDING_IRQ48_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ48_LSB 17
#define PLIC_P_PENDING1_PENDING_IRQ48_MASK 0x20000
#define PLIC_P_PENDING1_PENDING_IRQ48_RESET 0x0

// P_PENDING1.PENDING_IRQ49 - Pending status of IRQ49
#define PLIC_P_PENDING1_PENDING_IRQ49_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ49_LSB 18
#define PLIC_P_PENDING1_PENDING_IRQ49_MASK 0x40000
#define PLIC_P_PENDING1_PENDING_IRQ49_RESET 0x0

// P_PENDING1.PENDING_IRQ50 - Pending status of IRQ50
#define PLIC_P_PENDING1_PENDING_IRQ50_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ50_LSB 19
#define PLIC_P_PENDING1_PENDING_IRQ50_MASK 0x80000
#define PLIC_P_PENDING1_PENDING_IRQ50_RESET 0x0

// P_PENDING1.PENDING_IRQ51 - Pending status of IRQ51
#define PLIC_P_PENDING1_PENDING_IRQ51_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ51_LSB 20
#define PLIC_P_PENDING1_PENDING_IRQ51_MASK 0x100000
#define PLIC_P_PENDING1_PENDING_IRQ51_RESET 0x0

// P_PENDING1.PENDING_IRQ52 - Pending status of IRQ52
#define PLIC_P_PENDING1_PENDING_IRQ52_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ52_LSB 21
#define PLIC_P_PENDING1_PENDING_IRQ52_MASK 0x200000
#define PLIC_P_PENDING1_PENDING_IRQ52_RESET 0x0

// P_PENDING1.PENDING_IRQ53 - Pending status of IRQ53
#define PLIC_P_PENDING1_PENDING_IRQ53_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ53_LSB 22
#define PLIC_P_PENDING1_PENDING_IRQ53_MASK 0x400000
#define PLIC_P_PENDING1_PENDING_IRQ53_RESET 0x0

// P_PENDING1.PENDING_IRQ54 - Pending status of IRQ54
#define PLIC_P_PENDING1_PENDING_IRQ54_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ54_LSB 23
#define PLIC_P_PENDING1_PENDING_IRQ54_MASK 0x800000
#define PLIC_P_PENDING1_PENDING_IRQ54_RESET 0x0

// P_PENDING1.PENDING_IRQ55 - Pending status of IRQ55
#define PLIC_P_PENDING1_PENDING_IRQ55_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ55_LSB 24
#define PLIC_P_PENDING1_PENDING_IRQ55_MASK 0x1000000
#define PLIC_P_PENDING1_PENDING_IRQ55_RESET 0x0

// P_PENDING1.PENDING_IRQ56 - Pending status of IRQ56
#define PLIC_P_PENDING1_PENDING_IRQ56_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ56_LSB 25
#define PLIC_P_PENDING1_PENDING_IRQ56_MASK 0x2000000
#define PLIC_P_PENDING1_PENDING_IRQ56_RESET 0x0

// P_PENDING1.PENDING_IRQ57 - Pending status of IRQ57
#define PLIC_P_PENDING1_PENDING_IRQ57_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ57_LSB 26
#define PLIC_P_PENDING1_PENDING_IRQ57_MASK 0x4000000
#define PLIC_P_PENDING1_PENDING_IRQ57_RESET 0x0

// P_PENDING1.PENDING_IRQ58 - Pending status of IRQ58
#define PLIC_P_PENDING1_PENDING_IRQ58_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ58_LSB 27
#define PLIC_P_PENDING1_PENDING_IRQ58_MASK 0x8000000
#define PLIC_P_PENDING1_PENDING_IRQ58_RESET 0x0

// P_PENDING1.PENDING_IRQ59 - Pending status of IRQ59
#define PLIC_P_PENDING1_PENDING_IRQ59_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ59_LSB 28
#define PLIC_P_PENDING1_PENDING_IRQ59_MASK 0x10000000
#define PLIC_P_PENDING1_PENDING_IRQ59_RESET 0x0

// P_PENDING1.PENDING_IRQ60 - Pending status of IRQ60
#define PLIC_P_PENDING1_PENDING_IRQ60_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ60_LSB 29
#define PLIC_P_PENDING1_PENDING_IRQ60_MASK 0x20000000
#define PLIC_P_PENDING1_PENDING_IRQ60_RESET 0x0

// P_PENDING1.PENDING_IRQ61 - Pending status of IRQ61
#define PLIC_P_PENDING1_PENDING_IRQ61_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ61_LSB 30
#define PLIC_P_PENDING1_PENDING_IRQ61_MASK 0x40000000
#define PLIC_P_PENDING1_PENDING_IRQ61_RESET 0x0

// P_PENDING1.PENDING_IRQ62 - Pending status of IRQ62
#define PLIC_P_PENDING1_PENDING_IRQ62_WIDTH 1
#define PLIC_P_PENDING1_PENDING_IRQ62_LSB 31
#define PLIC_P_PENDING1_PENDING_IRQ62_MASK 0x80000000
#define PLIC_P_PENDING1_PENDING_IRQ62_RESET 0x0

// P_ENABLE0 - Enable bits for IRQ1–IRQ31
#define PLIC_P_ENABLE0_ADDR 0x2000
#define PLIC_P_ENABLE0_RESET 0x0
typedef struct {
    uint32_t : 1; // reserved
    uint32_t ENABLE_IRQ1 : 1; // Enable mask for IRQ1
    uint32_t ENABLE_IRQ2 : 1; // Enable mask for IRQ2
    uint32_t ENABLE_IRQ3 : 1; // Enable mask for IRQ3
    uint32_t ENABLE_IRQ4 : 1; // Enable mask for IRQ4
    uint32_t ENABLE_IRQ5 : 1; // Enable mask for IRQ5
    uint32_t ENABLE_IRQ6 : 1; // Enable mask for IRQ6
    uint32_t ENABLE_IRQ7 : 1; // Enable mask for IRQ7
    uint32_t ENABLE_IRQ8 : 1; // Enable mask for IRQ8
    uint32_t ENABLE_IRQ9 : 1; // Enable mask for IRQ9
    uint32_t ENABLE_IRQ10 : 1; // Enable mask for IRQ10
    uint32_t ENABLE_IRQ11 : 1; // Enable mask for IRQ11
    uint32_t ENABLE_IRQ12 : 1; // Enable mask for IRQ12
    uint32_t ENABLE_IRQ13 : 1; // Enable mask for IRQ13
    uint32_t ENABLE_IRQ14 : 1; // Enable mask for IRQ14
    uint32_t ENABLE_IRQ15 : 1; // Enable mask for IRQ15
    uint32_t ENABLE_IRQ16 : 1; // Enable mask for IRQ16
    uint32_t ENABLE_IRQ17 : 1; // Enable mask for IRQ17
    uint32_t ENABLE_IRQ18 : 1; // Enable mask for IRQ18
    uint32_t ENABLE_IRQ19 : 1; // Enable mask for IRQ19
    uint32_t ENABLE_IRQ20 : 1; // Enable mask for IRQ20
    uint32_t ENABLE_IRQ21 : 1; // Enable mask for IRQ21
    uint32_t ENABLE_IRQ22 : 1; // Enable mask for IRQ22
    uint32_t ENABLE_IRQ23 : 1; // Enable mask for IRQ23
    uint32_t ENABLE_IRQ24 : 1; // Enable mask for IRQ24
    uint32_t ENABLE_IRQ25 : 1; // Enable mask for IRQ25
    uint32_t ENABLE_IRQ26 : 1; // Enable mask for IRQ26
    uint32_t ENABLE_IRQ27 : 1; // Enable mask for IRQ27
    uint32_t ENABLE_IRQ28 : 1; // Enable mask for IRQ28
    uint32_t ENABLE_IRQ29 : 1; // Enable mask for IRQ29
    uint32_t ENABLE_IRQ30 : 1; // Enable mask for IRQ30
    uint32_t ENABLE_IRQ31 : 1; // Enable mask for IRQ31
} plic_p_enable0_t;

// P_ENABLE0.ENABLE_IRQ1 - Enable mask for IRQ1
#define PLIC_P_ENABLE0_ENABLE_IRQ1_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ1_LSB 1
#define PLIC_P_ENABLE0_ENABLE_IRQ1_MASK 0x2
#define PLIC_P_ENABLE0_ENABLE_IRQ1_RESET 0x0

// P_ENABLE0.ENABLE_IRQ2 - Enable mask for IRQ2
#define PLIC_P_ENABLE0_ENABLE_IRQ2_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ2_LSB 2
#define PLIC_P_ENABLE0_ENABLE_IRQ2_MASK 0x4
#define PLIC_P_ENABLE0_ENABLE_IRQ2_RESET 0x0

// P_ENABLE0.ENABLE_IRQ3 - Enable mask for IRQ3
#define PLIC_P_ENABLE0_ENABLE_IRQ3_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ3_LSB 3
#define PLIC_P_ENABLE0_ENABLE_IRQ3_MASK 0x8
#define PLIC_P_ENABLE0_ENABLE_IRQ3_RESET 0x0

// P_ENABLE0.ENABLE_IRQ4 - Enable mask for IRQ4
#define PLIC_P_ENABLE0_ENABLE_IRQ4_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ4_LSB 4
#define PLIC_P_ENABLE0_ENABLE_IRQ4_MASK 0x10
#define PLIC_P_ENABLE0_ENABLE_IRQ4_RESET 0x0

// P_ENABLE0.ENABLE_IRQ5 - Enable mask for IRQ5
#define PLIC_P_ENABLE0_ENABLE_IRQ5_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ5_LSB 5
#define PLIC_P_ENABLE0_ENABLE_IRQ5_MASK 0x20
#define PLIC_P_ENABLE0_ENABLE_IRQ5_RESET 0x0

// P_ENABLE0.ENABLE_IRQ6 - Enable mask for IRQ6
#define PLIC_P_ENABLE0_ENABLE_IRQ6_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ6_LSB 6
#define PLIC_P_ENABLE0_ENABLE_IRQ6_MASK 0x40
#define PLIC_P_ENABLE0_ENABLE_IRQ6_RESET 0x0

// P_ENABLE0.ENABLE_IRQ7 - Enable mask for IRQ7
#define PLIC_P_ENABLE0_ENABLE_IRQ7_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ7_LSB 7
#define PLIC_P_ENABLE0_ENABLE_IRQ7_MASK 0x80
#define PLIC_P_ENABLE0_ENABLE_IRQ7_RESET 0x0

// P_ENABLE0.ENABLE_IRQ8 - Enable mask for IRQ8
#define PLIC_P_ENABLE0_ENABLE_IRQ8_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ8_LSB 8
#define PLIC_P_ENABLE0_ENABLE_IRQ8_MASK 0x100
#define PLIC_P_ENABLE0_ENABLE_IRQ8_RESET 0x0

// P_ENABLE0.ENABLE_IRQ9 - Enable mask for IRQ9
#define PLIC_P_ENABLE0_ENABLE_IRQ9_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ9_LSB 9
#define PLIC_P_ENABLE0_ENABLE_IRQ9_MASK 0x200
#define PLIC_P_ENABLE0_ENABLE_IRQ9_RESET 0x0

// P_ENABLE0.ENABLE_IRQ10 - Enable mask for IRQ10
#define PLIC_P_ENABLE0_ENABLE_IRQ10_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ10_LSB 10
#define PLIC_P_ENABLE0_ENABLE_IRQ10_MASK 0x400
#define PLIC_P_ENABLE0_ENABLE_IRQ10_RESET 0x0

// P_ENABLE0.ENABLE_IRQ11 - Enable mask for IRQ11
#define PLIC_P_ENABLE0_ENABLE_IRQ11_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ11_LSB 11
#define PLIC_P_ENABLE0_ENABLE_IRQ11_MASK 0x800
#define PLIC_P_ENABLE0_ENABLE_IRQ11_RESET 0x0

// P_ENABLE0.ENABLE_IRQ12 - Enable mask for IRQ12
#define PLIC_P_ENABLE0_ENABLE_IRQ12_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ12_LSB 12
#define PLIC_P_ENABLE0_ENABLE_IRQ12_MASK 0x1000
#define PLIC_P_ENABLE0_ENABLE_IRQ12_RESET 0x0

// P_ENABLE0.ENABLE_IRQ13 - Enable mask for IRQ13
#define PLIC_P_ENABLE0_ENABLE_IRQ13_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ13_LSB 13
#define PLIC_P_ENABLE0_ENABLE_IRQ13_MASK 0x2000
#define PLIC_P_ENABLE0_ENABLE_IRQ13_RESET 0x0

// P_ENABLE0.ENABLE_IRQ14 - Enable mask for IRQ14
#define PLIC_P_ENABLE0_ENABLE_IRQ14_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ14_LSB 14
#define PLIC_P_ENABLE0_ENABLE_IRQ14_MASK 0x4000
#define PLIC_P_ENABLE0_ENABLE_IRQ14_RESET 0x0

// P_ENABLE0.ENABLE_IRQ15 - Enable mask for IRQ15
#define PLIC_P_ENABLE0_ENABLE_IRQ15_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ15_LSB 15
#define PLIC_P_ENABLE0_ENABLE_IRQ15_MASK 0x8000
#define PLIC_P_ENABLE0_ENABLE_IRQ15_RESET 0x0

// P_ENABLE0.ENABLE_IRQ16 - Enable mask for IRQ16
#define PLIC_P_ENABLE0_ENABLE_IRQ16_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ16_LSB 16
#define PLIC_P_ENABLE0_ENABLE_IRQ16_MASK 0x10000
#define PLIC_P_ENABLE0_ENABLE_IRQ16_RESET 0x0

// P_ENABLE0.ENABLE_IRQ17 - Enable mask for IRQ17
#define PLIC_P_ENABLE0_ENABLE_IRQ17_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ17_LSB 17
#define PLIC_P_ENABLE0_ENABLE_IRQ17_MASK 0x20000
#define PLIC_P_ENABLE0_ENABLE_IRQ17_RESET 0x0

// P_ENABLE0.ENABLE_IRQ18 - Enable mask for IRQ18
#define PLIC_P_ENABLE0_ENABLE_IRQ18_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ18_LSB 18
#define PLIC_P_ENABLE0_ENABLE_IRQ18_MASK 0x40000
#define PLIC_P_ENABLE0_ENABLE_IRQ18_RESET 0x0

// P_ENABLE0.ENABLE_IRQ19 - Enable mask for IRQ19
#define PLIC_P_ENABLE0_ENABLE_IRQ19_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ19_LSB 19
#define PLIC_P_ENABLE0_ENABLE_IRQ19_MASK 0x80000
#define PLIC_P_ENABLE0_ENABLE_IRQ19_RESET 0x0

// P_ENABLE0.ENABLE_IRQ20 - Enable mask for IRQ20
#define PLIC_P_ENABLE0_ENABLE_IRQ20_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ20_LSB 20
#define PLIC_P_ENABLE0_ENABLE_IRQ20_MASK 0x100000
#define PLIC_P_ENABLE0_ENABLE_IRQ20_RESET 0x0

// P_ENABLE0.ENABLE_IRQ21 - Enable mask for IRQ21
#define PLIC_P_ENABLE0_ENABLE_IRQ21_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ21_LSB 21
#define PLIC_P_ENABLE0_ENABLE_IRQ21_MASK 0x200000
#define PLIC_P_ENABLE0_ENABLE_IRQ21_RESET 0x0

// P_ENABLE0.ENABLE_IRQ22 - Enable mask for IRQ22
#define PLIC_P_ENABLE0_ENABLE_IRQ22_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ22_LSB 22
#define PLIC_P_ENABLE0_ENABLE_IRQ22_MASK 0x400000
#define PLIC_P_ENABLE0_ENABLE_IRQ22_RESET 0x0

// P_ENABLE0.ENABLE_IRQ23 - Enable mask for IRQ23
#define PLIC_P_ENABLE0_ENABLE_IRQ23_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ23_LSB 23
#define PLIC_P_ENABLE0_ENABLE_IRQ23_MASK 0x800000
#define PLIC_P_ENABLE0_ENABLE_IRQ23_RESET 0x0

// P_ENABLE0.ENABLE_IRQ24 - Enable mask for IRQ24
#define PLIC_P_ENABLE0_ENABLE_IRQ24_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ24_LSB 24
#define PLIC_P_ENABLE0_ENABLE_IRQ24_MASK 0x1000000
#define PLIC_P_ENABLE0_ENABLE_IRQ24_RESET 0x0

// P_ENABLE0.ENABLE_IRQ25 - Enable mask for IRQ25
#define PLIC_P_ENABLE0_ENABLE_IRQ25_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ25_LSB 25
#define PLIC_P_ENABLE0_ENABLE_IRQ25_MASK 0x2000000
#define PLIC_P_ENABLE0_ENABLE_IRQ25_RESET 0x0

// P_ENABLE0.ENABLE_IRQ26 - Enable mask for IRQ26
#define PLIC_P_ENABLE0_ENABLE_IRQ26_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ26_LSB 26
#define PLIC_P_ENABLE0_ENABLE_IRQ26_MASK 0x4000000
#define PLIC_P_ENABLE0_ENABLE_IRQ26_RESET 0x0

// P_ENABLE0.ENABLE_IRQ27 - Enable mask for IRQ27
#define PLIC_P_ENABLE0_ENABLE_IRQ27_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ27_LSB 27
#define PLIC_P_ENABLE0_ENABLE_IRQ27_MASK 0x8000000
#define PLIC_P_ENABLE0_ENABLE_IRQ27_RESET 0x0

// P_ENABLE0.ENABLE_IRQ28 - Enable mask for IRQ28
#define PLIC_P_ENABLE0_ENABLE_IRQ28_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ28_LSB 28
#define PLIC_P_ENABLE0_ENABLE_IRQ28_MASK 0x10000000
#define PLIC_P_ENABLE0_ENABLE_IRQ28_RESET 0x0

// P_ENABLE0.ENABLE_IRQ29 - Enable mask for IRQ29
#define PLIC_P_ENABLE0_ENABLE_IRQ29_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ29_LSB 29
#define PLIC_P_ENABLE0_ENABLE_IRQ29_MASK 0x20000000
#define PLIC_P_ENABLE0_ENABLE_IRQ29_RESET 0x0

// P_ENABLE0.ENABLE_IRQ30 - Enable mask for IRQ30
#define PLIC_P_ENABLE0_ENABLE_IRQ30_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ30_LSB 30
#define PLIC_P_ENABLE0_ENABLE_IRQ30_MASK 0x40000000
#define PLIC_P_ENABLE0_ENABLE_IRQ30_RESET 0x0

// P_ENABLE0.ENABLE_IRQ31 - Enable mask for IRQ31
#define PLIC_P_ENABLE0_ENABLE_IRQ31_WIDTH 1
#define PLIC_P_ENABLE0_ENABLE_IRQ31_LSB 31
#define PLIC_P_ENABLE0_ENABLE_IRQ31_MASK 0x80000000
#define PLIC_P_ENABLE0_ENABLE_IRQ31_RESET 0x0

// P_ENABLE1 - Enable bits for IRQ32–IRQ62
#define PLIC_P_ENABLE1_ADDR 0x2004
#define PLIC_P_ENABLE1_RESET 0x0
typedef struct {
    uint32_t : 1; // reserved
    uint32_t ENABLE_IRQ32 : 1; // Enable mask for IRQ32
    uint32_t ENABLE_IRQ33 : 1; // Enable mask for IRQ33
    uint32_t ENABLE_IRQ34 : 1; // Enable mask for IRQ34
    uint32_t ENABLE_IRQ35 : 1; // Enable mask for IRQ35
    uint32_t ENABLE_IRQ36 : 1; // Enable mask for IRQ36
    uint32_t ENABLE_IRQ37 : 1; // Enable mask for IRQ37
    uint32_t ENABLE_IRQ38 : 1; // Enable mask for IRQ38
    uint32_t ENABLE_IRQ39 : 1; // Enable mask for IRQ39
    uint32_t ENABLE_IRQ40 : 1; // Enable mask for IRQ40
    uint32_t ENABLE_IRQ41 : 1; // Enable mask for IRQ41
    uint32_t ENABLE_IRQ42 : 1; // Enable mask for IRQ42
    uint32_t ENABLE_IRQ43 : 1; // Enable mask for IRQ43
    uint32_t ENABLE_IRQ44 : 1; // Enable mask for IRQ44
    uint32_t ENABLE_IRQ45 : 1; // Enable mask for IRQ45
    uint32_t ENABLE_IRQ46 : 1; // Enable mask for IRQ46
    uint32_t ENABLE_IRQ47 : 1; // Enable mask for IRQ47
    uint32_t ENABLE_IRQ48 : 1; // Enable mask for IRQ48
    uint32_t ENABLE_IRQ49 : 1; // Enable mask for IRQ49
    uint32_t ENABLE_IRQ50 : 1; // Enable mask for IRQ50
    uint32_t ENABLE_IRQ51 : 1; // Enable mask for IRQ51
    uint32_t ENABLE_IRQ52 : 1; // Enable mask for IRQ52
    uint32_t ENABLE_IRQ53 : 1; // Enable mask for IRQ53
    uint32_t ENABLE_IRQ54 : 1; // Enable mask for IRQ54
    uint32_t ENABLE_IRQ55 : 1; // Enable mask for IRQ55
    uint32_t ENABLE_IRQ56 : 1; // Enable mask for IRQ56
    uint32_t ENABLE_IRQ57 : 1; // Enable mask for IRQ57
    uint32_t ENABLE_IRQ58 : 1; // Enable mask for IRQ58
    uint32_t ENABLE_IRQ59 : 1; // Enable mask for IRQ59
    uint32_t ENABLE_IRQ60 : 1; // Enable mask for IRQ60
    uint32_t ENABLE_IRQ61 : 1; // Enable mask for IRQ61
    uint32_t ENABLE_IRQ62 : 1; // Enable mask for IRQ62
} plic_p_enable1_t;

// P_ENABLE1.ENABLE_IRQ32 - Enable mask for IRQ32
#define PLIC_P_ENABLE1_ENABLE_IRQ32_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ32_LSB 1
#define PLIC_P_ENABLE1_ENABLE_IRQ32_MASK 0x2
#define PLIC_P_ENABLE1_ENABLE_IRQ32_RESET 0x0

// P_ENABLE1.ENABLE_IRQ33 - Enable mask for IRQ33
#define PLIC_P_ENABLE1_ENABLE_IRQ33_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ33_LSB 2
#define PLIC_P_ENABLE1_ENABLE_IRQ33_MASK 0x4
#define PLIC_P_ENABLE1_ENABLE_IRQ33_RESET 0x0

// P_ENABLE1.ENABLE_IRQ34 - Enable mask for IRQ34
#define PLIC_P_ENABLE1_ENABLE_IRQ34_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ34_LSB 3
#define PLIC_P_ENABLE1_ENABLE_IRQ34_MASK 0x8
#define PLIC_P_ENABLE1_ENABLE_IRQ34_RESET 0x0

// P_ENABLE1.ENABLE_IRQ35 - Enable mask for IRQ35
#define PLIC_P_ENABLE1_ENABLE_IRQ35_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ35_LSB 4
#define PLIC_P_ENABLE1_ENABLE_IRQ35_MASK 0x10
#define PLIC_P_ENABLE1_ENABLE_IRQ35_RESET 0x0

// P_ENABLE1.ENABLE_IRQ36 - Enable mask for IRQ36
#define PLIC_P_ENABLE1_ENABLE_IRQ36_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ36_LSB 5
#define PLIC_P_ENABLE1_ENABLE_IRQ36_MASK 0x20
#define PLIC_P_ENABLE1_ENABLE_IRQ36_RESET 0x0

// P_ENABLE1.ENABLE_IRQ37 - Enable mask for IRQ37
#define PLIC_P_ENABLE1_ENABLE_IRQ37_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ37_LSB 6
#define PLIC_P_ENABLE1_ENABLE_IRQ37_MASK 0x40
#define PLIC_P_ENABLE1_ENABLE_IRQ37_RESET 0x0

// P_ENABLE1.ENABLE_IRQ38 - Enable mask for IRQ38
#define PLIC_P_ENABLE1_ENABLE_IRQ38_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ38_LSB 7
#define PLIC_P_ENABLE1_ENABLE_IRQ38_MASK 0x80
#define PLIC_P_ENABLE1_ENABLE_IRQ38_RESET 0x0

// P_ENABLE1.ENABLE_IRQ39 - Enable mask for IRQ39
#define PLIC_P_ENABLE1_ENABLE_IRQ39_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ39_LSB 8
#define PLIC_P_ENABLE1_ENABLE_IRQ39_MASK 0x100
#define PLIC_P_ENABLE1_ENABLE_IRQ39_RESET 0x0

// P_ENABLE1.ENABLE_IRQ40 - Enable mask for IRQ40
#define PLIC_P_ENABLE1_ENABLE_IRQ40_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ40_LSB 9
#define PLIC_P_ENABLE1_ENABLE_IRQ40_MASK 0x200
#define PLIC_P_ENABLE1_ENABLE_IRQ40_RESET 0x0

// P_ENABLE1.ENABLE_IRQ41 - Enable mask for IRQ41
#define PLIC_P_ENABLE1_ENABLE_IRQ41_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ41_LSB 10
#define PLIC_P_ENABLE1_ENABLE_IRQ41_MASK 0x400
#define PLIC_P_ENABLE1_ENABLE_IRQ41_RESET 0x0

// P_ENABLE1.ENABLE_IRQ42 - Enable mask for IRQ42
#define PLIC_P_ENABLE1_ENABLE_IRQ42_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ42_LSB 11
#define PLIC_P_ENABLE1_ENABLE_IRQ42_MASK 0x800
#define PLIC_P_ENABLE1_ENABLE_IRQ42_RESET 0x0

// P_ENABLE1.ENABLE_IRQ43 - Enable mask for IRQ43
#define PLIC_P_ENABLE1_ENABLE_IRQ43_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ43_LSB 12
#define PLIC_P_ENABLE1_ENABLE_IRQ43_MASK 0x1000
#define PLIC_P_ENABLE1_ENABLE_IRQ43_RESET 0x0

// P_ENABLE1.ENABLE_IRQ44 - Enable mask for IRQ44
#define PLIC_P_ENABLE1_ENABLE_IRQ44_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ44_LSB 13
#define PLIC_P_ENABLE1_ENABLE_IRQ44_MASK 0x2000
#define PLIC_P_ENABLE1_ENABLE_IRQ44_RESET 0x0

// P_ENABLE1.ENABLE_IRQ45 - Enable mask for IRQ45
#define PLIC_P_ENABLE1_ENABLE_IRQ45_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ45_LSB 14
#define PLIC_P_ENABLE1_ENABLE_IRQ45_MASK 0x4000
#define PLIC_P_ENABLE1_ENABLE_IRQ45_RESET 0x0

// P_ENABLE1.ENABLE_IRQ46 - Enable mask for IRQ46
#define PLIC_P_ENABLE1_ENABLE_IRQ46_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ46_LSB 15
#define PLIC_P_ENABLE1_ENABLE_IRQ46_MASK 0x8000
#define PLIC_P_ENABLE1_ENABLE_IRQ46_RESET 0x0

// P_ENABLE1.ENABLE_IRQ47 - Enable mask for IRQ47
#define PLIC_P_ENABLE1_ENABLE_IRQ47_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ47_LSB 16
#define PLIC_P_ENABLE1_ENABLE_IRQ47_MASK 0x10000
#define PLIC_P_ENABLE1_ENABLE_IRQ47_RESET 0x0

// P_ENABLE1.ENABLE_IRQ48 - Enable mask for IRQ48
#define PLIC_P_ENABLE1_ENABLE_IRQ48_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ48_LSB 17
#define PLIC_P_ENABLE1_ENABLE_IRQ48_MASK 0x20000
#define PLIC_P_ENABLE1_ENABLE_IRQ48_RESET 0x0

// P_ENABLE1.ENABLE_IRQ49 - Enable mask for IRQ49
#define PLIC_P_ENABLE1_ENABLE_IRQ49_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ49_LSB 18
#define PLIC_P_ENABLE1_ENABLE_IRQ49_MASK 0x40000
#define PLIC_P_ENABLE1_ENABLE_IRQ49_RESET 0x0

// P_ENABLE1.ENABLE_IRQ50 - Enable mask for IRQ50
#define PLIC_P_ENABLE1_ENABLE_IRQ50_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ50_LSB 19
#define PLIC_P_ENABLE1_ENABLE_IRQ50_MASK 0x80000
#define PLIC_P_ENABLE1_ENABLE_IRQ50_RESET 0x0

// P_ENABLE1.ENABLE_IRQ51 - Enable mask for IRQ51
#define PLIC_P_ENABLE1_ENABLE_IRQ51_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ51_LSB 20
#define PLIC_P_ENABLE1_ENABLE_IRQ51_MASK 0x100000
#define PLIC_P_ENABLE1_ENABLE_IRQ51_RESET 0x0

// P_ENABLE1.ENABLE_IRQ52 - Enable mask for IRQ52
#define PLIC_P_ENABLE1_ENABLE_IRQ52_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ52_LSB 21
#define PLIC_P_ENABLE1_ENABLE_IRQ52_MASK 0x200000
#define PLIC_P_ENABLE1_ENABLE_IRQ52_RESET 0x0

// P_ENABLE1.ENABLE_IRQ53 - Enable mask for IRQ53
#define PLIC_P_ENABLE1_ENABLE_IRQ53_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ53_LSB 22
#define PLIC_P_ENABLE1_ENABLE_IRQ53_MASK 0x400000
#define PLIC_P_ENABLE1_ENABLE_IRQ53_RESET 0x0

// P_ENABLE1.ENABLE_IRQ54 - Enable mask for IRQ54
#define PLIC_P_ENABLE1_ENABLE_IRQ54_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ54_LSB 23
#define PLIC_P_ENABLE1_ENABLE_IRQ54_MASK 0x800000
#define PLIC_P_ENABLE1_ENABLE_IRQ54_RESET 0x0

// P_ENABLE1.ENABLE_IRQ55 - Enable mask for IRQ55
#define PLIC_P_ENABLE1_ENABLE_IRQ55_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ55_LSB 24
#define PLIC_P_ENABLE1_ENABLE_IRQ55_MASK 0x1000000
#define PLIC_P_ENABLE1_ENABLE_IRQ55_RESET 0x0

// P_ENABLE1.ENABLE_IRQ56 - Enable mask for IRQ56
#define PLIC_P_ENABLE1_ENABLE_IRQ56_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ56_LSB 25
#define PLIC_P_ENABLE1_ENABLE_IRQ56_MASK 0x2000000
#define PLIC_P_ENABLE1_ENABLE_IRQ56_RESET 0x0

// P_ENABLE1.ENABLE_IRQ57 - Enable mask for IRQ57
#define PLIC_P_ENABLE1_ENABLE_IRQ57_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ57_LSB 26
#define PLIC_P_ENABLE1_ENABLE_IRQ57_MASK 0x4000000
#define PLIC_P_ENABLE1_ENABLE_IRQ57_RESET 0x0

// P_ENABLE1.ENABLE_IRQ58 - Enable mask for IRQ58
#define PLIC_P_ENABLE1_ENABLE_IRQ58_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ58_LSB 27
#define PLIC_P_ENABLE1_ENABLE_IRQ58_MASK 0x8000000
#define PLIC_P_ENABLE1_ENABLE_IRQ58_RESET 0x0

// P_ENABLE1.ENABLE_IRQ59 - Enable mask for IRQ59
#define PLIC_P_ENABLE1_ENABLE_IRQ59_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ59_LSB 28
#define PLIC_P_ENABLE1_ENABLE_IRQ59_MASK 0x10000000
#define PLIC_P_ENABLE1_ENABLE_IRQ59_RESET 0x0

// P_ENABLE1.ENABLE_IRQ60 - Enable mask for IRQ60
#define PLIC_P_ENABLE1_ENABLE_IRQ60_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ60_LSB 29
#define PLIC_P_ENABLE1_ENABLE_IRQ60_MASK 0x20000000
#define PLIC_P_ENABLE1_ENABLE_IRQ60_RESET 0x0

// P_ENABLE1.ENABLE_IRQ61 - Enable mask for IRQ61
#define PLIC_P_ENABLE1_ENABLE_IRQ61_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ61_LSB 30
#define PLIC_P_ENABLE1_ENABLE_IRQ61_MASK 0x40000000
#define PLIC_P_ENABLE1_ENABLE_IRQ61_RESET 0x0

// P_ENABLE1.ENABLE_IRQ62 - Enable mask for IRQ62
#define PLIC_P_ENABLE1_ENABLE_IRQ62_WIDTH 1
#define PLIC_P_ENABLE1_ENABLE_IRQ62_LSB 31
#define PLIC_P_ENABLE1_ENABLE_IRQ62_MASK 0x80000000
#define PLIC_P_ENABLE1_ENABLE_IRQ62_RESET 0x0

// P_THRESHOLD - Priority threshold register
#define PLIC_P_THRESHOLD_ADDR 0x200000
#define PLIC_P_THRESHOLD_RESET 0x0
typedef struct {
    uint32_t THRESHOLD : 3; // Only IRQs with priority > threshold will be signaled
    uint32_t : 29; // reserved
} plic_p_threshold_t;

// P_THRESHOLD.THRESHOLD - Only IRQs with priority > threshold will be signaled
#define PLIC_P_THRESHOLD_THRESHOLD_WIDTH 3
#define PLIC_P_THRESHOLD_THRESHOLD_LSB 0
#define PLIC_P_THRESHOLD_THRESHOLD_MASK 0x7
#define PLIC_P_THRESHOLD_THRESHOLD_RESET 0x0

// P_CLAIMCOMPLETE - Claim/Complete register
#define PLIC_P_CLAIMCOMPLETE_ADDR 0x200004
#define PLIC_P_CLAIMCOMPLETE_RESET 0x0
typedef struct {
    uint32_t CP : 6; // Read = claim IRQ ID, Write = complete IRQ ID
    uint32_t : 26; // reserved
} plic_p_claimcomplete_t;

// P_CLAIMCOMPLETE.CP - Read = claim IRQ ID, Write = complete IRQ ID
#define PLIC_P_CLAIMCOMPLETE_CP_WIDTH 6
#define PLIC_P_CLAIMCOMPLETE_CP_LSB 0
#define PLIC_P_CLAIMCOMPLETE_CP_MASK 0x3f
#define PLIC_P_CLAIMCOMPLETE_CP_RESET 0x0


// Register map structure
typedef struct {
    __IO uint32_t RESERVED0[1];
    union {
        __IO uint32_t P_PRIORITY1; // Priority Register IRQ1 (3-bit, 8 levels)
        __IO plic_p_priority1_t P_PRIORITY1_bf; // Bit access for P_PRIORITY1 register
    };
    union {
        __IO uint32_t P_PRIORITY2; // Priority Register IRQ2 (3-bit, 8 levels)
        __IO plic_p_priority2_t P_PRIORITY2_bf; // Bit access for P_PRIORITY2 register
    };
    union {
        __IO uint32_t P_PRIORITY3; // Priority Register IRQ3 (3-bit, 8 levels)
        __IO plic_p_priority3_t P_PRIORITY3_bf; // Bit access for P_PRIORITY3 register
    };
    union {
        __IO uint32_t P_PRIORITY4; // Priority Register IRQ4 (3-bit, 8 levels)
        __IO plic_p_priority4_t P_PRIORITY4_bf; // Bit access for P_PRIORITY4 register
    };
    union {
        __IO uint32_t P_PRIORITY5; // Priority Register IRQ5 (3-bit, 8 levels)
        __IO plic_p_priority5_t P_PRIORITY5_bf; // Bit access for P_PRIORITY5 register
    };
    union {
        __IO uint32_t P_PRIORITY6; // Priority Register IRQ6 (3-bit, 8 levels)
        __IO plic_p_priority6_t P_PRIORITY6_bf; // Bit access for P_PRIORITY6 register
    };
    union {
        __IO uint32_t P_PRIORITY7; // Priority Register IRQ7 (3-bit, 8 levels)
        __IO plic_p_priority7_t P_PRIORITY7_bf; // Bit access for P_PRIORITY7 register
    };
    union {
        __IO uint32_t P_PRIORITY8; // Priority Register IRQ8 (3-bit, 8 levels)
        __IO plic_p_priority8_t P_PRIORITY8_bf; // Bit access for P_PRIORITY8 register
    };
    union {
        __IO uint32_t P_PRIORITY9; // Priority Register IRQ9 (3-bit, 8 levels)
        __IO plic_p_priority9_t P_PRIORITY9_bf; // Bit access for P_PRIORITY9 register
    };
    union {
        __IO uint32_t P_PRIORITY10; // Priority Register IRQ10 (3-bit, 8 levels)
        __IO plic_p_priority10_t P_PRIORITY10_bf; // Bit access for P_PRIORITY10 register
    };
    union {
        __IO uint32_t P_PRIORITY11; // Priority Register IRQ11 (3-bit, 8 levels)
        __IO plic_p_priority11_t P_PRIORITY11_bf; // Bit access for P_PRIORITY11 register
    };
    union {
        __IO uint32_t P_PRIORITY12; // Priority Register IRQ12 (3-bit, 8 levels)
        __IO plic_p_priority12_t P_PRIORITY12_bf; // Bit access for P_PRIORITY12 register
    };
    union {
        __IO uint32_t P_PRIORITY13; // Priority Register IRQ13 (3-bit, 8 levels)
        __IO plic_p_priority13_t P_PRIORITY13_bf; // Bit access for P_PRIORITY13 register
    };
    union {
        __IO uint32_t P_PRIORITY14; // Priority Register IRQ14 (3-bit, 8 levels)
        __IO plic_p_priority14_t P_PRIORITY14_bf; // Bit access for P_PRIORITY14 register
    };
    union {
        __IO uint32_t P_PRIORITY15; // Priority Register IRQ15 (3-bit, 8 levels)
        __IO plic_p_priority15_t P_PRIORITY15_bf; // Bit access for P_PRIORITY15 register
    };
    union {
        __IO uint32_t P_PRIORITY16; // Priority Register IRQ16 (3-bit, 8 levels)
        __IO plic_p_priority16_t P_PRIORITY16_bf; // Bit access for P_PRIORITY16 register
    };
    union {
        __IO uint32_t P_PRIORITY17; // Priority Register IRQ17 (3-bit, 8 levels)
        __IO plic_p_priority17_t P_PRIORITY17_bf; // Bit access for P_PRIORITY17 register
    };
    union {
        __IO uint32_t P_PRIORITY18; // Priority Register IRQ18 (3-bit, 8 levels)
        __IO plic_p_priority18_t P_PRIORITY18_bf; // Bit access for P_PRIORITY18 register
    };
    union {
        __IO uint32_t P_PRIORITY19; // Priority Register IRQ19 (3-bit, 8 levels)
        __IO plic_p_priority19_t P_PRIORITY19_bf; // Bit access for P_PRIORITY19 register
    };
    union {
        __IO uint32_t P_PRIORITY20; // Priority Register IRQ20 (3-bit, 8 levels)
        __IO plic_p_priority20_t P_PRIORITY20_bf; // Bit access for P_PRIORITY20 register
    };
    union {
        __IO uint32_t P_PRIORITY21; // Priority Register IRQ21 (3-bit, 8 levels)
        __IO plic_p_priority21_t P_PRIORITY21_bf; // Bit access for P_PRIORITY21 register
    };
    union {
        __IO uint32_t P_PRIORITY22; // Priority Register IRQ22 (3-bit, 8 levels)
        __IO plic_p_priority22_t P_PRIORITY22_bf; // Bit access for P_PRIORITY22 register
    };
    union {
        __IO uint32_t P_PRIORITY23; // Priority Register IRQ23 (3-bit, 8 levels)
        __IO plic_p_priority23_t P_PRIORITY23_bf; // Bit access for P_PRIORITY23 register
    };
    union {
        __IO uint32_t P_PRIORITY24; // Priority Register IRQ24 (3-bit, 8 levels)
        __IO plic_p_priority24_t P_PRIORITY24_bf; // Bit access for P_PRIORITY24 register
    };
    union {
        __IO uint32_t P_PRIORITY25; // Priority Register IRQ25 (3-bit, 8 levels)
        __IO plic_p_priority25_t P_PRIORITY25_bf; // Bit access for P_PRIORITY25 register
    };
    union {
        __IO uint32_t P_PRIORITY26; // Priority Register IRQ26 (3-bit, 8 levels)
        __IO plic_p_priority26_t P_PRIORITY26_bf; // Bit access for P_PRIORITY26 register
    };
    union {
        __IO uint32_t P_PRIORITY27; // Priority Register IRQ27 (3-bit, 8 levels)
        __IO plic_p_priority27_t P_PRIORITY27_bf; // Bit access for P_PRIORITY27 register
    };
    union {
        __IO uint32_t P_PRIORITY28; // Priority Register IRQ28 (3-bit, 8 levels)
        __IO plic_p_priority28_t P_PRIORITY28_bf; // Bit access for P_PRIORITY28 register
    };
    union {
        __IO uint32_t P_PRIORITY29; // Priority Register IRQ29 (3-bit, 8 levels)
        __IO plic_p_priority29_t P_PRIORITY29_bf; // Bit access for P_PRIORITY29 register
    };
    union {
        __IO uint32_t P_PRIORITY30; // Priority Register IRQ30 (3-bit, 8 levels)
        __IO plic_p_priority30_t P_PRIORITY30_bf; // Bit access for P_PRIORITY30 register
    };
    union {
        __IO uint32_t P_PRIORITY31; // Priority Register IRQ31 (3-bit, 8 levels)
        __IO plic_p_priority31_t P_PRIORITY31_bf; // Bit access for P_PRIORITY31 register
    };
    union {
        __IO uint32_t P_PRIORITY32; // Priority Register IRQ32 (3-bit, 8 levels)
        __IO plic_p_priority32_t P_PRIORITY32_bf; // Bit access for P_PRIORITY32 register
    };
    union {
        __IO uint32_t P_PRIORITY33; // Priority Register IRQ33 (3-bit, 8 levels)
        __IO plic_p_priority33_t P_PRIORITY33_bf; // Bit access for P_PRIORITY33 register
    };
    union {
        __IO uint32_t P_PRIORITY34; // Priority Register IRQ34 (3-bit, 8 levels)
        __IO plic_p_priority34_t P_PRIORITY34_bf; // Bit access for P_PRIORITY34 register
    };
    union {
        __IO uint32_t P_PRIORITY35; // Priority Register IRQ35 (3-bit, 8 levels)
        __IO plic_p_priority35_t P_PRIORITY35_bf; // Bit access for P_PRIORITY35 register
    };
    union {
        __IO uint32_t P_PRIORITY36; // Priority Register IRQ36 (3-bit, 8 levels)
        __IO plic_p_priority36_t P_PRIORITY36_bf; // Bit access for P_PRIORITY36 register
    };
    union {
        __IO uint32_t P_PRIORITY37; // Priority Register IRQ37 (3-bit, 8 levels)
        __IO plic_p_priority37_t P_PRIORITY37_bf; // Bit access for P_PRIORITY37 register
    };
    union {
        __IO uint32_t P_PRIORITY38; // Priority Register IRQ38 (3-bit, 8 levels)
        __IO plic_p_priority38_t P_PRIORITY38_bf; // Bit access for P_PRIORITY38 register
    };
    union {
        __IO uint32_t P_PRIORITY39; // Priority Register IRQ39 (3-bit, 8 levels)
        __IO plic_p_priority39_t P_PRIORITY39_bf; // Bit access for P_PRIORITY39 register
    };
    union {
        __IO uint32_t P_PRIORITY40; // Priority Register IRQ40 (3-bit, 8 levels)
        __IO plic_p_priority40_t P_PRIORITY40_bf; // Bit access for P_PRIORITY40 register
    };
    union {
        __IO uint32_t P_PRIORITY41; // Priority Register IRQ41 (3-bit, 8 levels)
        __IO plic_p_priority41_t P_PRIORITY41_bf; // Bit access for P_PRIORITY41 register
    };
    union {
        __IO uint32_t P_PRIORITY42; // Priority Register IRQ42 (3-bit, 8 levels)
        __IO plic_p_priority42_t P_PRIORITY42_bf; // Bit access for P_PRIORITY42 register
    };
    union {
        __IO uint32_t P_PRIORITY43; // Priority Register IRQ43 (3-bit, 8 levels)
        __IO plic_p_priority43_t P_PRIORITY43_bf; // Bit access for P_PRIORITY43 register
    };
    union {
        __IO uint32_t P_PRIORITY44; // Priority Register IRQ44 (3-bit, 8 levels)
        __IO plic_p_priority44_t P_PRIORITY44_bf; // Bit access for P_PRIORITY44 register
    };
    union {
        __IO uint32_t P_PRIORITY45; // Priority Register IRQ45 (3-bit, 8 levels)
        __IO plic_p_priority45_t P_PRIORITY45_bf; // Bit access for P_PRIORITY45 register
    };
    union {
        __IO uint32_t P_PRIORITY46; // Priority Register IRQ46 (3-bit, 8 levels)
        __IO plic_p_priority46_t P_PRIORITY46_bf; // Bit access for P_PRIORITY46 register
    };
    union {
        __IO uint32_t P_PRIORITY47; // Priority Register IRQ47 (3-bit, 8 levels)
        __IO plic_p_priority47_t P_PRIORITY47_bf; // Bit access for P_PRIORITY47 register
    };
    union {
        __IO uint32_t P_PRIORITY48; // Priority Register IRQ48 (3-bit, 8 levels)
        __IO plic_p_priority48_t P_PRIORITY48_bf; // Bit access for P_PRIORITY48 register
    };
    union {
        __IO uint32_t P_PRIORITY49; // Priority Register IRQ49 (3-bit, 8 levels)
        __IO plic_p_priority49_t P_PRIORITY49_bf; // Bit access for P_PRIORITY49 register
    };
    union {
        __IO uint32_t P_PRIORITY50; // Priority Register IRQ50 (3-bit, 8 levels)
        __IO plic_p_priority50_t P_PRIORITY50_bf; // Bit access for P_PRIORITY50 register
    };
    union {
        __IO uint32_t P_PRIORITY51; // Priority Register IRQ51 (3-bit, 8 levels)
        __IO plic_p_priority51_t P_PRIORITY51_bf; // Bit access for P_PRIORITY51 register
    };
    union {
        __IO uint32_t P_PRIORITY52; // Priority Register IRQ52 (3-bit, 8 levels)
        __IO plic_p_priority52_t P_PRIORITY52_bf; // Bit access for P_PRIORITY52 register
    };
    union {
        __IO uint32_t P_PRIORITY53; // Priority Register IRQ53 (3-bit, 8 levels)
        __IO plic_p_priority53_t P_PRIORITY53_bf; // Bit access for P_PRIORITY53 register
    };
    union {
        __IO uint32_t P_PRIORITY54; // Priority Register IRQ54 (3-bit, 8 levels)
        __IO plic_p_priority54_t P_PRIORITY54_bf; // Bit access for P_PRIORITY54 register
    };
    union {
        __IO uint32_t P_PRIORITY55; // Priority Register IRQ55 (3-bit, 8 levels)
        __IO plic_p_priority55_t P_PRIORITY55_bf; // Bit access for P_PRIORITY55 register
    };
    union {
        __IO uint32_t P_PRIORITY56; // Priority Register IRQ56 (3-bit, 8 levels)
        __IO plic_p_priority56_t P_PRIORITY56_bf; // Bit access for P_PRIORITY56 register
    };
    union {
        __IO uint32_t P_PRIORITY57; // Priority Register IRQ57 (3-bit, 8 levels)
        __IO plic_p_priority57_t P_PRIORITY57_bf; // Bit access for P_PRIORITY57 register
    };
    union {
        __IO uint32_t P_PRIORITY58; // Priority Register IRQ58 (3-bit, 8 levels)
        __IO plic_p_priority58_t P_PRIORITY58_bf; // Bit access for P_PRIORITY58 register
    };
    union {
        __IO uint32_t P_PRIORITY59; // Priority Register IRQ59 (3-bit, 8 levels)
        __IO plic_p_priority59_t P_PRIORITY59_bf; // Bit access for P_PRIORITY59 register
    };
    union {
        __IO uint32_t P_PRIORITY60; // Priority Register IRQ60 (3-bit, 8 levels)
        __IO plic_p_priority60_t P_PRIORITY60_bf; // Bit access for P_PRIORITY60 register
    };
    union {
        __IO uint32_t P_PRIORITY61; // Priority Register IRQ61 (3-bit, 8 levels)
        __IO plic_p_priority61_t P_PRIORITY61_bf; // Bit access for P_PRIORITY61 register
    };
    union {
        __IO uint32_t P_PRIORITY62; // Priority Register IRQ62 (3-bit, 8 levels)
        __IO plic_p_priority62_t P_PRIORITY62_bf; // Bit access for P_PRIORITY62 register
    };
    union {
        __IO uint32_t P_PRIORITY63; // Priority Register IRQ63 (3-bit, 8 levels)
        __IO plic_p_priority63_t P_PRIORITY63_bf; // Bit access for P_PRIORITY63 register
    };
    union {
        __IO uint32_t P_PRIORITY64; // Priority Register IRQ64 (3-bit, 8 levels)
        __IO plic_p_priority64_t P_PRIORITY64_bf; // Bit access for P_PRIORITY64 register
    };
    __IO uint32_t RESERVED1[959];
    union {
        __I uint32_t P_PENDING0; // Pending bits for IRQ1–IRQ31
        __I plic_p_pending0_t P_PENDING0_bf; // Bit access for P_PENDING0 register
    };
    union {
        __I uint32_t P_PENDING1; // Pending bits for IRQ32–IRQ62
        __I plic_p_pending1_t P_PENDING1_bf; // Bit access for P_PENDING1 register
    };
    __IO uint32_t RESERVED2[1022];
    union {
        __IO uint32_t P_ENABLE0; // Enable bits for IRQ1–IRQ31
        __IO plic_p_enable0_t P_ENABLE0_bf; // Bit access for P_ENABLE0 register
    };
    union {
        __IO uint32_t P_ENABLE1; // Enable bits for IRQ32–IRQ62
        __IO plic_p_enable1_t P_ENABLE1_bf; // Bit access for P_ENABLE1 register
    };
    __IO uint32_t RESERVED3[522238];
    union {
        __IO uint32_t P_THRESHOLD; // Priority threshold register
        __IO plic_p_threshold_t P_THRESHOLD_bf; // Bit access for P_THRESHOLD register
    };
    union {
        __IO uint32_t P_CLAIMCOMPLETE; // Claim/Complete register
        __IO plic_p_claimcomplete_t P_CLAIMCOMPLETE_bf; // Bit access for P_CLAIMCOMPLETE register
    };
} plic_t;

#define PLIC ((plic_t*)(PLIC_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __REGS_PLIC_H */