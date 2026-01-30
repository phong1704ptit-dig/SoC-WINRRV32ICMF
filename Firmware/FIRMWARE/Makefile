# ===================== Toolchain settings =====================
RISCV_TOOLCHAIN_DIR = /opt/riscv32/bin
CC       = $(RISCV_TOOLCHAIN_DIR)/riscv32-unknown-elf-gcc
CXX      = $(RISCV_TOOLCHAIN_DIR)/riscv32-unknown-elf-g++
OBJDUMP  = $(RISCV_TOOLCHAIN_DIR)/riscv32-unknown-elf-objdump
OBJCOPY  = $(RISCV_TOOLCHAIN_DIR)/riscv32-unknown-elf-objcopy

# ===================== Project structure =====================
SRC_DIR     = .
BUILD_DIR   = build
INCLUDE_DIR = inc
ASM_SRC     = $(SRC_DIR)/start.S
LDSCRIPT    = $(SRC_DIR)/sections.lds

INSTR_MEM_SIZE = 600000
DATA_MEM_SIZE  = 600000
FLASH_MEM_SIZE = 5000

# ===================== Recursive wildcard =====================
# rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

# ===================== Source files =====================
CXX_SRC = main.cpp
CXX_SRC += syscalls.cpp
CXX_SRC += ei_classifier_porting.cpp
CXX_SRC += 	$(wildcard inc/tflite-model/*.cpp) \
				$(wildcard inc/edge-impulse-sdk/dsp/kissfft/*.cpp) \
				$(wildcard inc/edge-impulse-sdk/dsp/dct/*.cpp) \
				$(wildcard inc/edge-impulse-sdk/dsp/memory.cpp) \
				$(wildcard inc/edge-impulse-sdk/porting/posix/*.c*) \
				$(wildcard inc/edge-impulse-sdk/porting/mingw32/*.c*)

CXX_SRC +=
CXX_SRC +=	$(wildcard inc/edge-impulse-sdk/tensorflow/lite/kernels/*.cc) \
				$(wildcard inc/edge-impulse-sdk/tensorflow/lite/kernels/internal/*.cc) \
				$(wildcard inc/edge-impulse-sdk/tensorflow/lite/micro/kernels/*.cc) \
				$(wildcard inc/edge-impulse-sdk/tensorflow/lite/micro/*.cc) \
				$(wildcard inc/edge-impulse-sdk/tensorflow/lite/micro/memory_planner/*.cc) \
				$(wildcard inc/edge-impulse-sdk/tensorflow/lite/core/api/*.cc)

C_SRC += $(wildcard inc/edge-impulse-sdk/CMSIS/DSP/Source/TransformFunctions/*.c) \
		$(wildcard inc/edge-impulse-sdk/CMSIS/DSP/Source/CommonTables/*.c) \
		$(wildcard inc/edge-impulse-sdk/CMSIS/DSP/Source/BasicMathFunctions/*.c) \
		$(wildcard inc/edge-impulse-sdk/CMSIS/DSP/Source/ComplexMathFunctions/*.c) \
		$(wildcard inc/edge-impulse-sdk/CMSIS/DSP/Source/FastMathFunctions/*.c) \
		$(wildcard inc/edge-impulse-sdk/CMSIS/DSP/Source/SupportFunctions/*.c) \
		$(wildcard inc/edge-impulse-sdk/CMSIS/DSP/Source/MatrixFunctions/*.c) \
		$(wildcard inc/edge-impulse-sdk/CMSIS/DSP/Source/StatisticsFunctions/*.c)
C_SRC +=	inc/edge-impulse-sdk/tensorflow/lite/c/common.c

# ===================== Object files =====================
ASM_OBJ = $(BUILD_DIR)/$(ASM_SRC:.S=.o)
CXX_OBJ_CPP = $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(filter %.cpp,$(CXX_SRC)))
CXX_OBJ_CC  = $(patsubst %.cc,$(BUILD_DIR)/%.o,$(filter %.cc,$(CXX_SRC)))
CXX_OBJ     = $(CXX_OBJ_CPP) $(CXX_OBJ_CC)
C_OBJ       = $(patsubst %,$(BUILD_DIR)/%,$(C_SRC:.c=.o))

OBJ     = $(ASM_OBJ) $(CXX_OBJ) $(C_OBJ)

ELF_FILE  = $(BUILD_DIR)/firmware.elf
MAP_FILE  = $(BUILD_DIR)/firmware.map
DUMP_FILE = $(BUILD_DIR)/dumpfile

INSTR_BIN = $(BUILD_DIR)/firmware_instr.bin
DATA_BIN  = $(BUILD_DIR)/firmware_data.bin
FLASH_BIN = $(BUILD_DIR)/firmware_flash.bin
INSTR_HEX = $(BUILD_DIR)/firmware_instr.hex
DATA_HEX  = $(BUILD_DIR)/firmware_data.hex
FLASH_HEX = $(BUILD_DIR)/firmware_flash.hex

# ===================== Build rules =====================
all: $(INSTR_HEX) $(DATA_HEX) $(FLASH_HEX) $(DUMP_FILE)

# .bin -> .hex
$(INSTR_HEX): $(INSTR_BIN) makehex_instr.py
	python3 makehex_instr.py $< $(INSTR_MEM_SIZE) > $@

$(DATA_HEX): $(DATA_BIN) makehex_data.py
	python3 makehex_data.py $< $(DATA_MEM_SIZE) > $@

$(FLASH_HEX): $(FLASH_BIN) makehex_flash.py
	python3 makehex_flash.py $< $(FLASH_MEM_SIZE) > $@


# Extract binary sections
$(INSTR_BIN): $(ELF_FILE)
	$(OBJCOPY) -O binary -j .text $< $@

$(DATA_BIN): $(ELF_FILE)
	$(OBJCOPY) -O binary \
		-j .rodata -j .rodata.* \
		-j .srodata -j .srodata.* \
		-j .gcc_except_table -j .gcc_except_table.* \
		-j .data.* -j .sdata.* -j .sdata2.* \
		-j .init_array -j .fini_array \
		$< $@

$(FLASH_BIN): $(ELF_FILE)
	$(OBJCOPY) -O binary -j .data $< $@

# Dump file
$(DUMP_FILE): $(ELF_FILE)
	$(OBJDUMP) -d $< > $@

# Build ELF
$(ELF_FILE): $(OBJ) $(LDSCRIPT)
	$(CXX) -Ofast -flto -funroll-loops -fno-common -mabi=ilp32f -march=rv32icmf_zicsr -fno-exceptions -fno-rtti -fno-use-cxa-atexit \
	    -nostartfiles \
	    -o $@ -Wl,-e,_start,-Bstatic,-T,$(LDSCRIPT),-Map,$(MAP_FILE),--strip-debug,--gc-sections \
	    $(OBJ) -lc -lgcc

# ===================== Compile rules =====================
# C++
$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) -c -I$(INCLUDE_DIR) -mabi=ilp32f -march=rv32icmf_zicsr -Ofast -flto -funroll-loops -fno-common -std=c++14 \
	    -fno-exceptions -fno-rtti -fno-use-cxa-atexit \
		-ffunction-sections -fdata-sections \
		-o $@ $<

$(BUILD_DIR)/%.o: %.cc
	@mkdir -p $(dir $@)
	$(CXX) -c -I$(INCLUDE_DIR) -mabi=ilp32f -march=rv32icmf_zicsr -Ofast -flto -funroll-loops -fno-common -std=c++14 \
	    -fno-exceptions -fno-rtti -fno-use-cxa-atexit \
		-ffunction-sections -fdata-sections \
		 -o $@ $<

# C
$(BUILD_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) -c -I$(INCLUDE_DIR) -mabi=ilp32f -march=rv32icmf_zicsr -Ofast -flto -funroll-loops -fno-common -std=c11 -ffreestanding -o $@ $<

# ASM
$(BUILD_DIR)/%.o: %.S
	@mkdir -p $(dir $@)
	$(CC) -c -mabi=ilp32f -march=rv32icmf_zicsr -o $@ $<


clean:
	rm -rf $(BUILD_DIR)
size: 
	$(RISCV_TOOLCHAIN_DIR)/riscv32-unknown-elf-size build/firmware.elf
list_size:
	$(RISCV_TOOLCHAIN_DIR)/riscv32-unknown-elf-nm -S --size-sort build/firmware.elf
entrypoint:
	$(RISCV_TOOLCHAIN_DIR)/riscv32-unknown-elf-readelf -h build/firmware.elf
echoname:
	echo "" | c++filt
searchword:
	grep -rnw ./ -e
seedata:
	$(RISCV_TOOLCHAIN_DIR)/riscv32-unknown-elf-objdump -s build/firmware.elf | grep 2000d4ec
seeVLMA:
	$(RISCV_TOOLCHAIN_DIR)/riscv32-unknown-elf-objdump -h build/firmware.elf
listinstructions:
	grep -oP ':\s*[0-9a-f]+\s+\K([a-z.]+)' build/dumpfile | sort | uniq -c | sort -nr