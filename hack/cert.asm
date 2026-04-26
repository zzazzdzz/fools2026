; cert.asm

Handler_CheckCertificate:
	; Decrypt the input buffer
	call DecryptInputBuffer
	; Terminate the input
	ld a, [wInputLength]
	ld c, a
	ld b, 0
	ld hl, $ca00
	add hl, bc
	xor a
	ld [hl], a
	; Read key-value pairs
	ld hl, $ca00
.readPairsLoop
	; Read key name to $CC00
	ld de, $cc00
	call ValueUntilSep
	jr c, .inval
	; "=" is expected now
	ld a, [hli]
	cp "="
	jr nz, .syntax
	; Read value name to $CC10
	ld de, $cc10
	call ValueUntilSep
	jr c, .inval
	; ";" is expected now
	ld a, [hl]
	cp ";"
	jr z, .syntax
	; Check the pair that was read
	push hl
	call ProcessKVPair
	pop hl
	; Read the next pair
	ld a, [hli]
	and a
	jr nz, .readPairsLoop
.done
	ld hl, OutputStrNotGold
	jp OutputStr
.syntax
	ld hl, OutputStrSyntax
	jp OutputStr
.inval
	ld hl, OutputStrInval
	jp OutputStr
	
ProcessKVPair:
	; Key must be equal to TYPE (case-sensitive)
	ld de, .strType
	ld hl, $cc00
	call StrEq
	ret c
	; Value must be equal to Gold (case-sensitive)
	ld de, .strGold
	ld hl, $cc10
	call StrEq
	ret c
	ld hl, OutputStrGoldCert
	jp OutputStr
.strType
	db "TYPE"
	db 0
.strGold
	db "Gold"
	db 0

DecryptInputBuffer:
	ld hl, KEY_DERIVATION_IV
	call PrepareKeystream
	ld hl, $ca00
	ld c, 48
.loop
	; Get byte from our secure encryption key generator
	call GetKeystreamByte
	; XOR with input
	ld b, [hl]
	xor b
	ld [hl], a
	inc hl
	; Do it for whole input buffer
	dec c
	jr nz, .loop
	ret

ValueUntilSep:
	nop
.cycle
	; At most 15 bytes in length
	ld a, e
	cp $f
	jr z, .doneInval
	; Terminate on [=] [;] [NUL]
	ld a, [hl]
	cp "="
	jr z, .doneOK
	cp ";"
	jr z, .doneOK
	and a
	jr z, .doneOK
	; Only alphanumeric chars
	call IsAlpha
	jr c, .doneInval
	; Copy byte to output buffer if passes checks
	ld a, [hl]
	ld [de], a
	inc hl
	inc de
	jr .cycle
.doneOK
	xor a
	ld [de], a
	ret
.doneInval
	scf
	ret
	
OutputStrInval:
	db "INVAL", 0
OutputStrSyntax:
	db "SYNTAX", 0
OutputStrGoldCert:
	db "Congrats, you got a gold certificate! fools2026\{XXXXXXXXXX\}", 0
OutputStrNotGold:
	db "Sorry, this is not a gold certificate.", 0
