# fools2026 Hacking Challenge III source

Note - if you want to attempt the challenge, you shouldn't be looking at this.

Build instructions:

```
rgbasm main.asm -o main.o
rgblink -n fools.sym -O base.sav -o fools.sav -x main.o
python3 savfix.py
```

The file *mem.bin* was generated from *mem.hsq* using (http://mazonka.com/subleq/)[Oleg Mazonka's Higher Subleq Compiler].