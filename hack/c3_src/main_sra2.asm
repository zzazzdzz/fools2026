SECTION "SRA2PARENT", ROMX[$4000], BANK[1]
LOAD "SRA2", SRAM[$A000], BANK[2]

db 0

SRA2Start:   
    call WhiteOutPals
    call SaveScreenTilesToBuffer1
    call SaveScreenTilesToBuffer2
    call SpriteClearAnimCounters
    call LoadFontTilePatterns
    xor a
    ldh [$ffb0], a
    inc a
    ldh [$ffba], a
    call DelayFrame
    call ClearScreen
    call UpdateSprites
    call DelayFrame
    ld a, $e4
	ld [rBGP], a
    call PlayUnusedTheme
    ld a, b_DisplayNamingScreen
    ldh [$ffb8], a
    ld [$2000], a
    ld hl, $de00
    ld bc, 16
    xor a
    call FillMemory
	ld hl, $d730
	set 6, [hl]
    ld a, 2
	ld [wNamingScreenType], a
    ld b, 8
    call RunPaletteCommand
    call LoadHpBarAndStatusTilePatterns
	call LoadEDTile
    ld hl, $c3f0
    ld bc, $0912
    call TextBoxBorder
    ld hl, $c3b4
    ld de, PasswordString
    call PlaceString
    ld hl, .rets
    push hl
    ld hl, $de00
    push hl
    jp $65c5
.rets
    call LoadSubleqState
    ld de, SubleqMem+6
    ld hl, $de00
    ld c, 10
.copyInput
    ld a, [hli]
    ld [de], a
    inc de
    inc de
    dec c
    jr nz, .copyInput
    ld a, 1
    ld [wIsInBattle], a
    farcall PrintWaitingText
.subleqPrep
    ld a, LOW(SubleqMem)
    ld [wSubleqIP], a
    ld a, HIGH(SubleqMem)
    ld [wSubleqIP+1], a
.subleqVM
    ld a, [wSubleqIP]
    ld l, a
    ld a, [wSubleqIP+1]
    ld h, a
    ; read a,b,c
    ld a, [hli]
    ld [wSubleqA], a
    ld a, [hli]
    ld [wSubleqA+1], a
    ld a, [hli]
    ld [wSubleqB], a
    ld a, [hli]
    ld [wSubleqB+1], a
    ld a, [hli]
    ld [wSubleqC], a
    ld a, [hl]
    ld [wSubleqC+1], a
    ; read *a,*b
    call SubleqGetMemPtrA
    ld a, [hli]
    ld [wSubleqAtA], a
    ld a, [hl]
    ld [wSubleqAtA+1], a
    call SubleqGetMemPtrB
    ld a, [hli]
    ld [wSubleqAtB], a
    ld a, [hl]
    ld [wSubleqAtB+1], a
    ; if b == -1
    ld a, [wSubleqB]
    inc a
    jr nz, .dontTerminate
    ld a, [wSubleqB+1]
    inc a
    jr nz, .dontTerminate
.terminate
    ld a, [wSubleqAtA]
    and a
    jp z, IncorrectPassword
    jp CorrectPassword
.dontTerminate
    ; *b -= *a
    ld a, [wSubleqAtA]
    ld c, a
    ld a, [wSubleqAtB]
    sub c
    ld [wSubleqAtB], a
    ld a, [wSubleqAtA+1]
    ld c, a
    ld a, [wSubleqAtB+1]
    sbc c
    ld [wSubleqAtB+1], a
    ; write mem[b]
    call SubleqGetMemPtrB
    ld a, [wSubleqAtB]
    ld [hli], a
    ld a, [wSubleqAtB+1]
    ld [hl], a
    ; don't change ip by default
    xor a
    ld [wSubleqShouldUpdateIP], a
.checkCond
    ; is zero?
    ld a, [wSubleqAtB]
    and a
    jr nz, .checkCond2
    ld a, [wSubleqAtB+1]
    and a
    jr nz, .checkCond2
.isZero
    ld a, 1
    ld [wSubleqShouldUpdateIP], a
.checkCond2
    ; is negative?
    ld a, [wSubleqAtB+1]
    bit 7, a
    jr z, .checked
.isNeg
    ld a, 1
    ld [wSubleqShouldUpdateIP], a
.checked
    ld a, [wSubleqShouldUpdateIP]
    and a
    jr z, .incIP
.moveIP
    call SubleqGetMemPtrC
    ld a, l
    ld [wSubleqIP], a
    ld a, h
    ld [wSubleqIP+1], a
    jp .subleqVM
.incIP
    ld a, [wSubleqIP]
    ld l, a
    ld a, [wSubleqIP+1]
    ld h, a
    ld bc, 6
    add hl, bc
    ld a, l
    ld [wSubleqIP], a
    ld a, h
    ld [wSubleqIP+1], a
    jp .subleqVM

SubleqGetMemPtrA:
    ld a, [wSubleqA]
    ld l, a
    ld a, [wSubleqA+1]
    ld h, a
    ld b, h
    ld c, l
    add hl, bc
    ld bc, SubleqMem
    add hl, bc
    ret

SubleqGetMemPtrB:
    ld a, [wSubleqB]
    ld l, a
    ld a, [wSubleqB+1]
    ld h, a
    ld b, h
    ld c, l
    add hl, bc
    ld bc, SubleqMem
    add hl, bc
    ret

SubleqGetMemPtrC:
    ld a, [wSubleqC]
    ld l, a
    ld a, [wSubleqC+1]
    ld h, a
    ld b, h
    ld c, l
    add hl, bc
    ld bc, SubleqMem
    add hl, bc
    ret

IncorrectPassword:
    ld de, .incorrect
    ld hl, $c480
    call PlaceString
    ld a, $ff
    call PlaySound
    ld a, SFX_DENIED
    call PlaySound
    jr ExitChall
.incorrect
    db $7f,$88,$8d,$82,$8e,$91,$91,$84,$82,$93,$7f,$50

CorrectPassword:
    ld de, .correct
    ld hl, $c480
    call PlaceString
    ld a, $ff
    call PlaySound
    ld a, SFX_GET_ITEM_2
    call PlaySound
    jr ExitChall
.correct
    db $7f,$7f,$82,$8e,$91,$91,$84,$82,$93,$7f,$7f,$50

ExitChall:
    call WaitForSoundToFinish
    ld c, 20
    call DelayFrames
.forever
    jr .forever

SpriteClearAnimCounters:
    xor a
    ld [wPlayerMovingDirection], a
    ld a, [$c102]
    and %11111100
    ld [$c102], a
    ld hl, $c107
    xor a
    ld [hli], a
    ld [hl], a
    jp UpdateSprites

WhiteOutPals:
    xor a
WriteAToPals:
	ld [rBGP], a
    ld [rOBP0], a
    ld [rOBP1], a
    ret

PlayUnusedTheme:
    ; Play the R/B/Y unused trade theme.
    ld a, MUSIC_VERMILION
    ld c, 2
    call PlayMusic
    xor a
    ld hl, $c006
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld [hli], a
    ld [hl], $13
    inc hl
    ld [hl], $69
    inc hl
    ld [hli], a
    ld [hl], a
    ret

PasswordString:
    db $8f,$80,$92,$92,$96,$8e,$91,$83,$e6,$50

SubleqMem:
    db 0

ENDL