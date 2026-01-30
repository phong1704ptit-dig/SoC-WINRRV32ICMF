ENTRY(_start)
MEMORY {
    instr_mem (rx) : ORIGIN = 0x00000000, LENGTH = 187k
    flash     (rx) : ORIGIN = 0x10000000, LENGTH = 10k
    data_mem  (rw) : ORIGIN = 0x20000000, LENGTH = 120k
}

SECTIONS {
    .text : {
        KEEP(*(.text.start))
        *(.text*)
        _etext = .;
        . = ALIGN(4);
    } > instr_mem

    .rodata : {
        _srodata = .;
        *(.rodata*)
        _erodata = .;
        . = ALIGN(4);
    } > data_mem

    .srodata : {
        _ssrodata = .;
        *(.srodata*)
        *(.srodata.*)
        _esrodata = .;
        . = ALIGN(4);
    } > data_mem

    .gcc_except_table : {
        _sgcc_except_table = .;
        *(.gcc_except_table)
        *(.gcc_except_table.*)
        _egcc_except_table = .;
        . = ALIGN(4);
    } > data_mem

    .data : {
        _sdata = .;
        *(.data*)
        *(.sdata*)
        *(.sdata2*)
        _edata = .;
        . = ALIGN(4);
    } > data_mem AT > flash

    .bss : {
        _sbss = .;
        *(.bss*)
        *(.sbss*)
        *(COMMON)
        _ebss = .;
        . = ALIGN(4);
    } > data_mem AT > data_mem

    .init : {
        KEEP (*crti.o(.init))
        KEEP (*crtbegin.o(.init))
        KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o *crtn.o ).init))
        KEEP (*crtend.o(.init))
        KEEP (*crtn.o(.init))
        . = ALIGN(4) ;
    } > data_mem AT > data_mem

    .fini : {
        KEEP (*(.fini))
        . = ALIGN(4) ;
    } > data_mem AT > data_mem

    .preinit_array :{
        HIDDEN (__preinit_array_start = .);
        KEEP (*(.preinit_array))
        HIDDEN (__preinit_array_end = .);
        . = ALIGN(4) ;
    } > data_mem AT > data_mem

    .init_array : {
        HIDDEN (__init_array_start = .);
        KEEP (*(SORT_BY_INIT_PRIORITY(.init_array.*)))
        KEEP (*(.init_array))
        HIDDEN (__init_array_end = .);
        . = ALIGN(4) ;
    } > data_mem AT > data_mem

    .fini_array :{
        HIDDEN (__fini_array_start = .);
        KEEP (*(SORT_BY_INIT_PRIORITY(.fini_array.*)))
        KEEP (*(.fini_array))
        HIDDEN (__fini_array_end = .);
        . = ALIGN(4) ;
        PROVIDE_HIDDEN (__heapst = .);
    } > data_mem AT > data_mem
}


_sidata = LOADADDR(.data);

/* Heap setup */
__stack_top = ORIGIN(data_mem) + LENGTH(data_mem);
__heap_start = __heapst;
__heap_end   = ORIGIN(data_mem) + LENGTH(data_mem); 

