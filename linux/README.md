## Installation
The file `us` contains a patched version of the ubuntu xkb file for the us keyboard layout.

It patches the "English (US, euro on 5)" layout to include a dead key "<ALT-GR>u" with `"`, so that 
`<ALT-GR>u + A` evaluates to Ä.

It has to be copied to `/usr/share/X11/xkb/symbols`.

