;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.0 #15242 (Mac OS X x86_64)
;--------------------------------------------------------
	.module main
	
	.optsdcc -mz80 sdcccall(1)
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _Width
	.globl _SetColors
	.globl _Screen
	.globl _Getche
	.globl _Print
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;src/main.c:10: void main(void)
;	---------------------------------
; Function main
; ---------------------------------
_main::
;src/main.c:13: Screen(0);
	xor	a, a
	call	_Screen
;src/main.c:14: Width(40);
	ld	a, #0x28
	call	_Width
;src/main.c:17: Print("****************************************");
	ld	hl, #___str_0
	call	_Print
;src/main.c:18: Print("*                                      *");
	ld	hl, #___str_1
	call	_Print
;src/main.c:19: Print("*   MSX C Programming met Fusion-C    *");
	ld	hl, #___str_2
	call	_Print
;src/main.c:20: Print("*                                      *");
	ld	hl, #___str_1
	call	_Print
;src/main.c:21: Print("****************************************");
	ld	hl, #___str_0
	call	_Print
;src/main.c:22: Print("");
	ld	hl, #___str_3
	call	_Print
;src/main.c:23: Print("SDCC + Fusion-C werkt!");
	ld	hl, #___str_4
	call	_Print
;src/main.c:24: Print("");
	ld	hl, #___str_3
	call	_Print
;src/main.c:25: Print("Druk op een toets om verder te gaan...");
	ld	hl, #___str_5
	call	_Print
;src/main.c:28: Getche();
	call	_Getche
;src/main.c:31: Screen(0);
	xor	a, a
	call	_Screen
;src/main.c:32: Width(40);
	ld	a, #0x28
	call	_Width
;src/main.c:35: SetColors(10, 15, 4);  // Lichtgroen op wit met rode border
	ld	a, #0x04
	push	af
	inc	sp
	ld	l, #0x0f
	ld	a, #0x0a
	call	_SetColors
;src/main.c:36: Print("Dit is lichtgroene tekst op witte achtergrond");
	ld	hl, #___str_6
	call	_Print
;src/main.c:38: SetColors(15, 4, 4);   // Wit op rood
	ld	a, #0x04
	push	af
	inc	sp
	ld	l, #0x04
	ld	a, #0x0f
	call	_SetColors
;src/main.c:39: Print("Dit is witte tekst op rode achtergrond");
	ld	hl, #___str_7
	call	_Print
;src/main.c:41: SetColors(1, 15, 4);   // Zwart op wit
	ld	a, #0x04
	push	af
	inc	sp
	ld	l, #0x0f
	ld	a, #0x01
	call	_SetColors
;src/main.c:42: Print("Dit is zwarte tekst op witte achtergrond");
	ld	hl, #___str_8
	call	_Print
;src/main.c:45: SetColors(15, 4, 4);   // Wit op zwart met zwarte border
	ld	a, #0x04
	push	af
	inc	sp
	ld	l, #0x04
	ld	a, #0x0f
	call	_SetColors
;src/main.c:46: Print("");
	ld	hl, #___str_3
	call	_Print
;src/main.c:47: Print("Druk op een toets om af te sluiten...");
	ld	hl, #___str_9
	call	_Print
;src/main.c:48: Getche();
	call	_Getche
;src/main.c:51: Screen(0);
	xor	a, a
	call	_Screen
;src/main.c:52: Width(40);
	ld	a, #0x28
	call	_Width
;src/main.c:53: SetColors(15, 4, 4);
	ld	a, #0x04
	push	af
	inc	sp
	ld	l, #0x04
	ld	a, #0x0f
	call	_SetColors
;src/main.c:54: Print("Tot ziens!");
	ld	hl, #___str_10
;src/main.c:55: }
	jp	_Print
_Done_Version:
	.ascii "Made with FUSION-C 1.2 (ebsoft)"
	.db 0x00
___str_0:
	.ascii "****************************************"
	.db 0x00
___str_1:
	.ascii "*                                      *"
	.db 0x00
___str_2:
	.ascii "*   MSX C Programming met Fusion-C    *"
	.db 0x00
___str_3:
	.db 0x00
___str_4:
	.ascii "SDCC + Fusion-C werkt!"
	.db 0x00
___str_5:
	.ascii "Druk op een toets om verder te gaan..."
	.db 0x00
___str_6:
	.ascii "Dit is lichtgroene tekst op witte achtergrond"
	.db 0x00
___str_7:
	.ascii "Dit is witte tekst op rode achtergrond"
	.db 0x00
___str_8:
	.ascii "Dit is zwarte tekst op witte achtergrond"
	.db 0x00
___str_9:
	.ascii "Druk op een toets om af te sluiten..."
	.db 0x00
___str_10:
	.ascii "Tot ziens!"
	.db 0x00
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
