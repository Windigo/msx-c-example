//
// Fusion-C voorbeeldprogramma
// MSX C met SDCC en Fusion-C library
//
// Compileer met: make
//

#include "msx_fusion.h"

void main(void)
{
    // Wis het scherm en zet tekstmodus
    Screen(0);
    Width(80);

    // Toon een welkomstbericht
    Print("****************************************");
    Print("*                                      *");
    Print("*   MSX C Programming met Fusion-C    *");
    Print("*                                      *");
    Print("****************************************");
    Print("");
    Print("SDCC + Fusion-C werkt!");
    Print("");
    Print("Druk op een toets om verder te gaan...");

    // Wacht op een toets
    Getche();

    // Wis het scherm
    Screen(0);
    Width(80);

    // Stel kleuren in: foreground, background, border
    SetColors(10, 15, 4);  // Lichtgroen op wit met rode border
    Print("Dit is lichtgroene tekst op witte achtergrond");

    SetColors(15, 4, 4);   // Wit op rood
    Print("Dit is witte tekst op rode achtergrond");

    SetColors(1, 15, 4);   // Zwart op wit
    Print("Dit is zwarte tekst op witte achtergrond");

    // Terug naar standaard kleuren
    SetColors(15, 4, 4);   // Wit op zwart met zwarte border
    Print("");
    Print("Druk op een toets om af te sluiten...");
    Getche();

    // Terug naar tekstmodus
    Screen(0);
    Width(40);
    SetColors(15, 4, 4);
    Print("Tot ziens!");
}
