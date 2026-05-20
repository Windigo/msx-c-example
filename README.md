# MSX C Project met SDCC en Fusion-C

Dit project bevat een complete ontwikkelomgeving voor het programmeren van MSX computers in C, met behulp van **SDCC** (Small Device C Compiler) en de **Fusion-C** library.

## Vereisten

- **SDCC 4.5.0+** - Installeer via: `brew install sdcc`
- **hex2bin** - Inbegrepen in dit project
- **Fusion-C v1.2** - Inbegrepen in `fusion-c-lib/`

## Projectstructuur

```
c-example/
├── Makefile              # Build-script
├── README.md             # Dit bestand
├── patch_fusion_lib.py   # Script om Fusion-C library te patchen
├── src/
│   └── main.c            # Je C-broncode
├── build/                # Build directory (tijdelijke bestanden)
├── compiled/             # Output directory voor .com bestanden
├── fusion-c/             # Standalone Fusion-C distributie
└── fusion-c-lib/         # Fusion-C library
    ├── header/           # Header bestanden (.h)
    ├── include/          # CRT0 bestanden (.rel)
    ├── lib/              # Fusion.lib (gepatcht naar fusion_patched.lib)
    ├── source/           # Broncode van de library
    └── examples/         # Voorbeeldprogramma's
```

## Compileren

```bash
make            # Compileer en genereer main.com
make clean      # Verwijder tijdelijke bestanden
make fclean     # Volledig opschonen en hercompileren
make patch-lib  # Patch Fusion-C library opnieuw (indien nodig)
make run        # Start openMSX emulator met de gegenereerde disk
```

**Eerste keer:** Bij de eerste `make` wordt de Fusion-C library automatisch gepatcht voor compatibiliteit met SDCC 4.5.0. Dit is een eenmalige stap.

Het gecompileerde `.com` bestand wordt gekopieerd naar de `compiled/` directory.

## Testen op een echte MSX of emulator

Kopieer `compiled/main.com` naar een MSX-DOS diskimage en voer het uit op:

- **openMSX** (aanbevolen): `brew install openmsx` → daarna `make run`
- **blueMSX**
- Een echte MSX computer met MSX-DOS

## Voorbeeld

```c
#include "msx_fusion.h"

void main(void)
{
    Screen(0);
    Width(40);
    Print("Hello MSX world!");
}
```

## Beschikbare Fusion-C headers

| Header | Beschrijving |
|--------|-------------|
| `msx_fusion.h` | Hoofdheader met alle MSX functies |
| `vdp_graph1.h` | VDP Grafische mode 1 (SCREEN 1) |
| `vdp_graph2.h` | VDP Grafische mode 2 (SCREEN 2) |
| `vdp_sprites.h` | Sprite functies |
| `vdp_circle.h` | Cirkel tekenfuncties |
| `psg.h` | PSG (geluid) functies |
| `ayfx_player.h` | AY-effecten speler |
| `pt3replayer.h` | PT3 muziek replayer |
| `g9klib.h` | MSX-G9000 VDP functies |
| `gr8net-tcpip.h` | GR8NET TCP/IP functies |
| `rammapper.h` | RAM mapper functies |
| `io.h` | I/O poort functies |
| `newTypes.h` | Nieuwe datatypes |

## Licentie

Fusion-C is ontwikkeld door Eric Boez. Zie `fusion-c-lib/license.txt` voor details.
