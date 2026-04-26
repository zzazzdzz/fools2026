SECTION "SRA3PARENT", ROMX[$6000], BANK[1]
LOAD "SRA3", SRAM[$A000], BANK[3]

db 0

SubleqMemSaved:
incbin "mem.bin"

ENDL