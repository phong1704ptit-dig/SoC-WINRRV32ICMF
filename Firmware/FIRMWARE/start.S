.section .text
.globl _start
_start:

    la   sp, __stack_top      # set stack pointer

    la   t0, _sbss       # t0 = start of BSS
    la   t1, _ebss       # t1 = end of BSS

1:  
    bge  t0, t1, 2f      # if t0 >= t1, done
    sw   zero, 0(t0)      # store 0
    addi t0, t0, 4        # advance 4 bytes
    j    1b

2:
    la  t0, _sdata        # VMA start (RAM)
    la  t1, _edata        # VMA end   (RAM)
    la  t2, _sidata       # LMA start (FLASH)

copy_data:
    beq t0, t1, copy_done
    lw  t3, 0(t2)
    sw  t3, 0(t0)
    addi t2, t2, 4
    addi t0, t0, 4
    j   copy_data

copy_done:

    # Run C/C++ constructors
    call __libc_init_array     

    call main
    ebreak