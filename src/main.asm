MAX_SETS equ 0x2D

_path equ (path - MOD_DATA)
_path_end equ (path_end - MOD_DATA)
_TRANSMOG_SETS equ (TRANSMOG_SETS - MOD_DATA)

.word 1 ;  Main Block
.word (main_block_end - main_block) | 0x80000000
.ascii "TSET"
main_block:
.func init
    addiu   sp, sp, -0xC
    sw      ra, 0x0(sp)
    sw      s0, 0x4(sp)
    sw      s1, 0x8(sp)

    bal     @@get_offset
    nop
@@get_offset:
    addiu   s1, ra, (MOD_DATA - @@get_offset)
    
    ; check if file exists
    lbu     at, SAVE_SLOT
    addiu   a0, s1, _path_end
    addiu   at, at, 0x30
    sb      at, 0x0(a0)

    addiu   a0, s1, _path

    jal     sceIoGetStat
    addiu   a1, sp, -0x60

    slt     at, v0, zero
    bne     at, zero, @@ret
    nop
    
    addiu   a0, s1, _path
    li      a1, PSP_O_RDONLY
    jal     sceIoOpen
    li      a2, 0x1B6
    move    s0, v0
    ; save sets
    move    a0, v0
    addiu   a1, s1, _TRANSMOG_SETS
    li      a2, MAX_SETS * 6
    jal     sceIoRead
    li      a3, 0x0
    ; close file
    jal     sceIoClose
    move    a0, s0
@@ret:
    lw      ra, 0x0(sp)
    lw      s0, 0x4(sp)
    lw      s1, 0x8(sp)
    jr      ra
    addiu   sp, sp, 0xC
.endfunc
; hook on set save
; save trans mogs
.func save_set
    addiu   sp, sp, -8
    sw      ra, 0x0(sp)
    sw      a2, 0x4(sp)

    bal     @@get_offset
    nop
@@get_offset:
    addiu   t1, ra, (TRANSMOG_SETS - @@get_offset)
    addiu   v0, v0, EQ_SET_OFFSET
    li      t0, EQUIPMENT_BOX

    sll     t2, v1, 2
    sll     at, v1, 1
    addu    t2, t2, at
    addu    t1, t1, t2 ;  t1 = set de transmog


    li      t2, 6
@@save_loop:
    lh      t3, 0x0(v0)
    slt     at, t3, zero
    bne     at, zero, @@continue

    sll     at, t3, 3
    sll     t3, t3, 2
    addu    t3, at, t3
    addu    t3, t0, t3
    lbu     at, 0x5(t3)
    sb      at, 0x0(t1)
@@continue:
    addiu   v0, v0, 2
    addiu   t2, t2, -1
    bne     t2, 0, @@save_loop
    addiu   t1, t1, 1


    bal     write_sets
    nop
    lw      ra, 0x0(sp)
    lw      a2, 0x4(sp)
    addiu   sp, sp, 8
@@ret:
    lw      v0, SET_SAVE_FIX_OFF(s4)
    j       SET_SAVE_HOOK + 8
    li      a1, 0
.endfunc

.func write_sets
    ; open file
    addiu   sp, sp, -0xC
    sw      ra, 0x4(sp)
    sw      s0, 0x8(sp)

    bal     @@get_offset
    nop
@@get_offset:
    addiu   s0, ra, (MOD_DATA - @@get_offset)

    addiu   a0, s0, _path
    li      a1, PSP_O_CREAT | PSP_O_WRONLY
    jal     sceIoOpen
    li      a2, 0x1B6
    sw      v0, 0x0(sp)
    ; save sets
    lw      a0, 0x0(sp)
    addiu   a1, s0, _TRANSMOG_SETS
    li      a2, MAX_SETS * 6
    jal     sceIoWrite
    li      a3, 0x0
    ; close file
    lw      a0, 0x0(sp)
    jal     sceIoClose
    nop
@@ret:
    lw      ra, 0x4(sp)
    lw      s0, 0x8(sp)
    jr      ra
    addiu   sp, sp, 0xC
.endfunc

; hook on set load
; load trans mogs
.func load_set ;  a0: set
    addiu   sp, sp, -4
    sw      ra, 0x0(sp)
    bal     @@get_offset
    nop
@@get_offset:
    addiu   t1, ra, (TRANSMOG_SETS - @@get_offset)
    addiu   v0, s4, 2
    li      t0, EQUIPMENT_BOX
    
    sll     a0, v1, 2
    sll     at, v1, 1
    addu    a0, a0, at
    addu    t1, t1, a0 ;  t1 = set de transmog

    li      t2, 6
@@load_loop:
    lh      t3, 0x0(v0)
    slt     at, t3, zero
    bne     at, zero, @@continue

    sll     at, t3, 3
    sll     t3, t3, 2
    addu    t3, at, t3
    addu    t3, t0, t3
    lbu     at, 0x0(t1)
    sb      at, 0x5(t3)
@@continue:
    addiu   v0, v0, 2
    addiu   t2, t2, -1
    bne     t2, 0, @@load_loop
    addiu   t1, t1, 1
    
@@ret:
    lui     s6, 0x08AB
    lw      a0, SET_SAVE_FIX_OFF(s6)
    
    lw      ra, 0x0(sp)
    j       SET_LOAD_HOOK + 8
    addiu   sp, sp, 4
.endfunc

; hook on set move
.func move_set ;  a0: src, a1: dst
    addiu   sp, sp, -0x1C
    sw      ra, 0x00(sp)
    sw      a0, 0x04(sp)
    sw      a1, 0x08(sp)
    sw      a2, 0x0C(sp)
    sw      a3, 0x10(sp)
    sw      v0, 0x14(sp)
    sw      v1, 0x18(sp)

    bal     @@get_offset
    nop
@@get_offset:
    addiu   t1, ra, (TRANSMOG_SETS - @@get_offset)

    sll     t2, v1, 2
    sll     at, v1, 1
    addu    t2, t2, at
    addu    a0, t1, t2 ;  a0 = src set
    
    sll     t2, v0, 2
    sll     at, v0, 1
    addu    t2, t2, at
    addu    t1, t1, t2 ;  t1 = dest set

    li      t2, 6
@@move_loop:
    lbu     at, 0x0(a0)
    lbu     a1, 0x0(t1)
    sb      at, 0x0(t1)
    sb      a1, 0x0(a0)

    addiu   a0, a0, 1
    addiu   t2, t2, -1
    bne     t2, 0, @@move_loop
    addiu   t1, t1, 1

    bal     write_sets
    nop

    lw      ra, 0x00(sp)
    lw      a0, 0x04(sp)
    lw      a1, 0x08(sp)
    lw      a2, 0x0C(sp)
    lw      a3, 0x10(sp)
    lw      v0, 0x14(sp)
    lw      v1, 0x18(sp)
    j       SET_MOVE_CONT
    addiu   sp, sp, 0x1C
.endfunc
; data
MOD_DATA:
TRANSMOG_SETS:
.area 6 * MAX_SETS, 0
.endarea

path:
.ascii SETS_FILE_PATH
path_end:
.asciiz "0.BIN"
.align 0x10
main_block_end:

.word 2 ;  Hook Block
.word SET_SAVE_HOOK
.halfword (save_set - main_block)
.byte 8
.byte 0

.word 2 ;  Hook Block
.word SET_LOAD_HOOK
.halfword (load_set - main_block)
.byte 8
.byte 1

.word 2 ;  Hook Block
.word SET_MOVE_HOOK
.halfword (move_set - main_block)
.byte 0xC
.byte 1
