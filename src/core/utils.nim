import random

proc rndStr*(): string =
    for _ in 0..26:
        add(result, char(rand(int('A') .. int('z'))))