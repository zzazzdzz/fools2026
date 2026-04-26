def SCREEN_WIDTH equ 20
def SCREEN_HEIGHT equ 18

MACRO coord
    IF _NARG >= 4
        ld \1, \4 + SCREEN_WIDTH * \3 + \2
    ELSE
        ld \1, wTileMap + SCREEN_WIDTH * \3 + \2
    ENDC
ENDM

MACRO farcall
    ld b, b_\1
    ld hl, \1
    call Bankswitch
ENDM

def SFX_DENIED equs "((SFX_Denied_1 - SFX_Headers_1) / 3)"
def SFX_GET_ITEM_2 equs "((SFX_Get_Item2_1 - SFX_Headers_1) / 3)"
def MUSIC_VERMILION equs "((Music_Vermilion - SFX_Headers_1) / 3)"