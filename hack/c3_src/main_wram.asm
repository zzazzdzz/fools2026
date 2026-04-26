SECTION "WRAMPARENT", ROM0[$30C0]
LOAD "WRAM", WRAMX[$DA80], BANK[1]

NumInBox:
    db 20

EntryPoint:
    call SwitchToSRA2
    jp $a001

SwitchToSRA2:
    ld a, 2
SwitchToSRA:
    ld [$4000], a
    ld a, $0a
    ld [$0000], a
    ret

LoadSubleqState:
    ld de, SubleqMem
    ld hl, SubleqMemSaved
    ld bc, $1600
.loop
    ld a, 3
    ld [$4000], a
    ld a, [hli]
    push af
    ld a, 2
    ld [$4000], a
    pop af
    ld [de], a
    inc de
    dec bc
    ld a, c
    or b
    jr nz, .loop
    jr SwitchToSRA2

db "[["

wSubleqIP:
    dw 0
wSubleqA:
    dw 0
wSubleqB:
    dw 0
wSubleqC:
    dw 0
wSubleqAtA:
    dw 0
wSubleqAtB:
    dw 0
wSubleqShouldUpdateIP:
    db 0

db "]]"

ds $DE80 - @, 0

RealEntryPoint:
    jp EntryPoint

ENDL