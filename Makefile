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
#  Dit Makefile genereert een MSX-DOS executable (.com)
#  klaar om te draaien op een MSX computer met MSX-DOS
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
CRT0        = $(INCLUDEDIR)crt0_msxdos.rel

# Gebruik de gepatchte library (sdcccall(1) toegevoegd aan .rel bestanden)
# voor compatibiliteit met SDCC 4.5.0
FUSION_LIB  = fusion_patched.lib

# SDCC flags voor Z80 MSX-DOS target
ADDR_CODE   = 0x106
ADDR_DATA   = 0x0
CCFLAGS     = --code-loc $(ADDR_CODE) \
              --data-loc $(ADDR_DATA) \
              --disable-warning 196 \
              -mz80 \
              --no-std-crt0 \
              --opt-code-size \
              -I $(abspath $(HEADERDIR))

LDFLAGS     = $(CCFLAGS) \
              --out-fmt-ihx \
              --lib-path $(abspath $(LIBDIR))

# --- Standaard targets ---
.PHONY: all clean fclean run patch-lib

all: $(COMPILED_DIR)$(TARGET).com

# Patch de Fusion-C library voor SDCC 4.5.0 compatibiliteit
patch-lib:
	@echo "..•̀ᴗ•́)و Fusion-C library patchen voor SDCC 4.5.0 ..."
	mkdir -p $(FUSION_DIR)/lib-rebuild
	cd $(FUSION_DIR)/lib-rebuild && sdar -x ../lib/fusion.lib 2>/dev/null
	python3 patch_fusion_lib.py
	cd $(FUSION_DIR)/lib-rebuild && sdar -rc ../lib/$(FUSION_LIB) *.rel 2>/dev/null
	rm -rf $(FUSION_DIR)/lib-rebuild
	@echo "✓ Library gepatcht!"

# Stap 1: compileer C naar .rel object bestand
$(BUILD_DIR)$(TARGET).rel: $(SRC) | $(BUILD_DIR)
	@echo "..•̀ᴗ•́)و Compileren naar .rel ..."
	sdcc -c $(CCFLAGS) -o $(BUILD_DIR) $<
	@echo "✓ Compilatie gelukt!"

# Stap 2: link met de library (direct als .lib, niet uitgepakt)
$(BUILD_DIR)$(TARGET).ihx: $(BUILD_DIR)$(TARGET).rel $(FUSION_DIR)/lib/$(FUSION_LIB)
	@echo "..•̀ᴗ•́)و Linken met Fusion-C library ..."
	sdcc $(LDFLAGS) $(CRT0) $(BUILD_DIR)$(TARGET).rel -l$(FUSION_LIB:.lib=) -o $(BUILD_DIR)$(TARGET)
	@echo "✓ Linken gelukt!"

# Converteer IHX naar COM (MSX-DOS executable)
$(BUILD_DIR)$(TARGET).com: $(BUILD_DIR)$(TARGET).ihx
	@echo "..•̀ᴗ•́)و Converteren naar COM ..."
	$(HEX2BIN) -e com $(BUILD_DIR)$(TARGET)
	@echo "✓ Executable in $(BUILD_DIR)"

# Kopieer de COM naar de compiled/ folder
$(COMPILED_DIR)$(TARGET).com: $(BUILD_DIR)$(TARGET).com | $(COMPILED_DIR)
	@echo "..•̀ᴗ•́)و Kopiëren naar $(COMPILED_DIR)..."
	cp $(BUILD_DIR)$(TARGET).com $(COMPILED_DIR)$(TARGET).com
	@echo "✓ Executable in $(COMPILED_DIR)"

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

# Open de MSX emulator (indien geïnstalleerd)
run:
	@echo "Start openMSX emulator..."
	if command -v openmsx &> /dev/null; then \
		openmsx -diska $(BUILD_DIR); \
	else \
		echo "openMSX is niet geïnstalleerd. Installeer het via: brew install openmsx"; \
	fi

# Eerste keer setup: patch de library
$(FUSION_DIR)/lib/$(FUSION_LIB):
	$(MAKE) patch-lib
