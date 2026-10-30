.psp

.relativeinclude on

SET_SAVE_HOOK       equ 0x09D2E320
SET_MOVE_HOOK       equ 0x09D2EA68
SET_MOVE_CONT       equ 0x0883BAC8
SET_LOAD_HOOK       equ 0x09D27888

SET_SAVE_FIX_OFF    equ -0x3180
EQ_SET_OFFSET       equ 0x4B7E

SAVE_SLOT           equ 0x09BAEA00
EQUIPMENT_BOX       equ 0x09B49364

SETS_FILE_PATH      equ "ms0:/P3RDML/TRANSMOG_SETS"

PSP_O_RDONLY        equ 0x00000001
PSP_O_WRONLY        equ 0x00000002
PSP_O_CREAT         equ 0x00000200

sceIoWrite          equ 0x08960A00
sceIoClose          equ 0x08960A20
sceIoGetStat        equ 0x08960A28
sceIoOpen           equ 0x08960A40
sceIoRead           equ 0x08960A10


.createfile "../bin/psp.bin", 0

.include "main.asm"

.close
