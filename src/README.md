# fools2026 source code archive

This is the source for [TheZZAZZGlitch's April Fools Event 2026](https://zzazzdzz.github.io/fools2026/).

If you just want to play the ROM hack, you don't need to build it from source. Visit the event site (linked above) for more information.

The code sucks, I know. At least all of it was written without clanker assistance.

## Build instructions

Clone the [pret/pmd-red](https://github.com/pret/pmd-red) repository, then **make it your current directory**. Check out the correct version, then apply the patch from the *fools2026.patch* file.

```
git checkout -f 6d8ff1950bbe88555152e9684171344ce83e7e41
patch -p0 < fools2026.patch
```

Next, generate the combined dungeon data and user preference file (very fittingly named *titlegfx.bin*) using the included Python script. You'll need Python 3 to run it, with *xlrd* package installed. If you'd like to customize player data, such as the player name and Pokémon species, you can make appropriate changes within this very clean and easy to read script (it sucks). If you'd like to customize dungeon data, edit the provided *dungeon_data.xls* spreadsheet.

```
python3 mk_data.py
```

Afterwards, you may build the ROM according [to the instructions in the original repository](https://github.com/pret/pmd-red/blob/master/INSTALL.md).