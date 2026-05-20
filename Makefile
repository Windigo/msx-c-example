# ___________________________________________________________
#/               __           _                              \
#|              / _|         (_)                             |
#|             | |_ _   ___ _ ___  ___  _ __                   |
#|             |  _| | | / __| |/ _ \| '_ \                  |
#|             | | | |_| \__ \ | (_) | | | |                 |
#|             |_|  \__,_|___/_|\___/|_| |_| *               |
#|                                                           |
#|               The MSX C Library for SDCC                  |
#|                     V1.2 - August 2019                    |
#|                                                           |
#|          Makefile voor MSX C-project met Fusion-C         |
#|                                                           |
#\___________________________________________________________/
#
#  Dit Makefile genereert een MSX-DOS executable (.com) of
#  een MSX cartridge ROM (.rom) voor Fusion-C projecten.
#
#  Vereisten:
#    - SDCC (Small Device C Compiler)
#    - hex2bin (van Fusion-C tools)
#    - Fusion-C library
#

# --- Configuratie ---
TARGET      = main
SRC         = src/main.c
FUSION_DIR  = fusion-c-lib
HEX2BIN     = ./hex2bin
BUILD_DIR   = build/
COMPILED_DIR = compiled/

# Fusion-C paths
INCLUDEDIR  = $(FUSION_DIR)/include/
HEADERDIR   = $(FUSION_DIR)/header/
LIBDIR      = $(FUSION_DIR)/lib/

# Gebruik de gepatchte library (sdcccall(1) toegevoegd aan .rel bestanden)
# voor compatibiliteit met SDCC 4.5.0
FUSION_LIB  = fusion_patched.lib

# --- MSX-DOS (.com) target configuratie ---
# Startadres voor MSX-DOS .COM executables is 0x0100
DOS_CRT0     = $(INCLUDEDIR)crt0_msxdos.rel
DOS_ADDR_CODE = 0x106
DOS_ADDR_DATA = 0x0

# --- MSX ROM (.rom) target configuratie ---
# 32KB ROM startend op 0x4000 (standaard MSX cartridge)
ROM_CRT0     = $(INCLUDEDIR)crt0_MSX32k_ROM4000.rel
ROM_ADDR_CODE = 0x4050
ROM_ADDR_DATA = 0xC000

# --- SDCC flags (basis) ---
BASE_CFLAGS  = --disable-warning 196 \
               -mz80 \
               --no-std-crt0 \
               --opt-code-size \
               -I $(abspath $(HEADERDIR))

# --- Standaard targets ---
.PHONY: all com rom clean fclean run run-rom patch-lib

# Standaard: bouw .com (MSX-DOS)
all: com

# Bouw MSX-DOS executable (.com)
com: $(COMPILED_DIR)$(TARGET).com

# Bouw MSX cartridge ROM (.rom)
rom: $(COMPILED_DIR)$(TARGET).rom

# Patch de Fusion-C library voor SDCC 4.5.0 compatibiliteit
patch-lib:
	@echo "..•̀ᴗ•́)و Fusion-C library patchen voor SDCC 4.5.0 ..."
	mkdir -p $(FUSION_DIR)/lib-rebuild
	cd $(FUSION_DIR)/lib-rebuild && sdar -x ../lib/fusion.lib 2>/dev/null
	python3 patch_fusion_lib.py
	cd $(FUSION_DIR)/lib-rebuild && sdar -rc ../lib/$(FUSION_LIB) *.rel 2>/dev/null
	rm -rf $(FUSION_DIR)/lib-rebuild
	@echo "✓ Library gepatcht!"

# ============================================================
# MSX-DOS (.com) build rules
# ============================================================

# SDCC flags voor Z80 MSX-DOS target
DOS_CFLAGS   = $(BASE_CFLAGS) \
               --code-loc $(DOS_ADDR_CODE) \
               --data-loc $(DOS_ADDR_DATA)

DOS_LDFLAGS  = $(DOS_CFLAGS) \
               --out-fmt-ihx \
               --lib-path $(abspath $(LIBDIR))

# Stap 1: compileer C naar .rel object bestand (DOS)
$(BUILD_DIR)dos_$(TARGET).rel: $(SRC) | $(BUILD_DIR)
	@echo "..•̀ᴗ•́)و Compileren naar .rel (DOS) ..."
	sdcc -c $(DOS_CFLAGS) -o $@ $<
	@echo "✓ Compilatie gelukt!"

# Stap 2: link met de library (DOS)
$(BUILD_DIR)dos_$(TARGET).ihx: $(BUILD_DIR)dos_$(TARGET).rel $(FUSION_DIR)/lib/$(FUSION_LIB)
	@echo "..•̀ᴗ•́)و Linken met Fusion-C library (DOS) ..."
	sdcc $(DOS_LDFLAGS) $(DOS_CRT0) $< -l$(FUSION_LIB:.lib=) -o $(BUILD_DIR)dos_$(TARGET)
	@echo "✓ Linken gelukt!"

# Converteer IHX naar COM (MSX-DOS executable)
$(BUILD_DIR)dos_$(TARGET).com: $(BUILD_DIR)dos_$(TARGET).ihx
	@echo "..•̀ᴗ•́)و Converteren naar COM ..."
	$(HEX2BIN) -e com $(BUILD_DIR)dos_$(TARGET)
	@echo "✓ Executable in $(BUILD_DIR)"

# Kopieer de COM naar de compiled/ folder
$(COMPILED_DIR)$(TARGET).com: $(BUILD_DIR)dos_$(TARGET).com | $(COMPILED_DIR)
	@echo "..•̀ᴗ•́)و Kopiëren naar $(COMPILED_DIR)..."
	cp $< $@
	@echo "✓ Executable in $(COMPILED_DIR)"

# ============================================================
# MSX ROM (.rom) build rules
# ============================================================

# SDCC flags voor Z80 MSX ROM target (32KB cartridge op 0x4000)
ROM_CFLAGS   = $(BASE_CFLAGS) \
               --code-loc $(ROM_ADDR_CODE) \
               --data-loc $(ROM_ADDR_DATA)

ROM_LDFLAGS  = $(ROM_CFLAGS) \
               --out-fmt-ihx \
               --lib-path $(abspath $(LIBDIR))

# Stap 1: compileer C naar .rel object bestand (ROM)
$(BUILD_DIR)rom_$(TARGET).rel: $(SRC) | $(BUILD_DIR)
	@echo "..•̀ᴗ•́)و Compileren naar .rel (ROM) ..."
	sdcc -c $(ROM_CFLAGS) -o $@ $<
	@echo "✓ Compilatie gelukt!"

# Stap 2: link met de library (ROM)
$(BUILD_DIR)rom_$(TARGET).ihx: $(BUILD_DIR)rom_$(TARGET).rel $(FUSION_DIR)/lib/$(FUSION_LIB)
	@echo "..•̀ᴗ•́)و Linken met Fusion-C library (ROM) ..."
	sdcc $(ROM_LDFLAGS) $(ROM_CRT0) $< -l$(FUSION_LIB:.lib=) -o $(BUILD_DIR)rom_$(TARGET)
	@echo "✓ Linken gelukt!"

# Converteer IHX naar ROM (32KB MSX cartridge)
# -s 4000: startadres in binary file = 0x4000 (zodat data op juiste offset staat)
# -l 8000: vul aan tot 32KB (0x8000 bytes)
$(BUILD_DIR)rom_$(TARGET).rom: $(BUILD_DIR)rom_$(TARGET).ihx
	@echo "..•̀ᴗ•́)و Converteren naar ROM (32KB cartridge) ..."
	$(HEX2BIN) -e rom -s 0x4000 -l 0x8000 $(BUILD_DIR)rom_$(TARGET)
	@echo "✓ ROM in $(BUILD_DIR)"

# Kopieer de ROM naar de compiled/ folder
$(COMPILED_DIR)$(TARGET).rom: $(BUILD_DIR)rom_$(TARGET).rom | $(COMPILED_DIR)
	@echo "..•̀ᴗ•́)و Kopiëren naar $(COMPILED_DIR)..."
	cp $< $@
	@echo "✓ ROM in $(COMPILED_DIR)"

# ============================================================
# Algemene regels
# ============================================================

# Zorg dat de build directory bestaat
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Zorg dat de compiled directory bestaat
$(COMPILED_DIR):
	mkdir -p $(COMPILED_DIR)

# Opruimen van tijdelijke bestanden
clean:
	rm -rf $(BUILD_DIR)
	@echo "....(╯°□°） Tijdelijke bestanden verwijderd!"

# Alles opnieuw bouwen
fclean: clean all

# Open de MSX emulator met .com (disk image)
run:
	@echo "Start openMSX emulator met disk image..."
	if command -v openmsx &> /dev/null; then \
		openmsx -diska $(BUILD_DIR); \
	else \
		echo "openMSX is niet geïnstalleerd. Installeer het via: brew install openmsx"; \
	fi

# Open de MSX emulator met .rom (cartridge)
run-rom:
	@echo "Start openMSX emulator met cartridge..."
	if command -v openmsx &> /dev/null; then \
		openmsx -carta $(COMPILED_DIR)$(TARGET).rom; \
	else \
		echo "openMSX is niet geïnstalleerd. Installeer het via: brew install openmsx"; \
	fi

# Eerste keer setup: patch de library
$(FUSION_DIR)/lib/$(FUSION_LIB):
	$(MAKE) patch-lib
