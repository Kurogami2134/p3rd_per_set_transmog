.psp

.relativeinclude on

SET_SAVE_HOOK       equ 0x0A12FF20
SET_MOVE_HOOK       equ 0x0A130668
SET_MOVE_CONT       equ 0x09FC5364
SET_LOAD_HOOK       equ 0x0A129488

SET_SAVE_FIX_OFF    equ 0x3640
EQ_SET_OFFSET       equ 0x4B7E

SAVE_SLOT           equ 0x09FB5690
EQUIPMENT_BOX       equ 0x09F4FE14

SETS_FILE_PATH      equ "ms0:/P3RHDDML/TRANSMOG_SETS"

PSP_O_RDONLY        equ 0x00000001
PSP_O_WRONLY        equ 0x00000002
PSP_O_CREAT         equ 0x00000200

sceIoWrite          equ 0x08965690
sceIoClose          equ 0x089656B0
sceIoGetStat        equ 0x089656B8
sceIoOpen           equ 0x089656D0
sceIoRead           equ 0x089656A0


.createfile "../bin/hd.bin", 0

.include "main.asm"

.close
