//
//  LFSR_Logic.c
//  LFSR-Cryptosystem
//
//  Created by Alex Azarov on 31/10/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

#include <stdio.h>
#include <string.h>

unsigned int shift_lfsr(unsigned int v);

void GenerateLSFRKey(int init, int length, const char *path) {
    FILE *f = fopen(strcat((char *)path, ".key"), "w");
    int currBitNum = 0;
    int lfsr = init;
    for (;currBitNum < length;currBitNum++) {
        lfsr = shift_lfsr(lfsr);
        fprintf(f, "%d", (lfsr >> 26) & 1);
    }
    fclose(f);
}

unsigned int shift_lfsr(unsigned int v)
{
    enum {
        length         = 26,
        tap_0          = 26,
        tap_1          =  8,
        tap_2          =  7,
        tap_3          =  1,
        shift_amount_0 =  1
    };
    const unsigned int zero = (unsigned int)(0);
    v = (
         (
          v << shift_amount_0
          ) | (
               (
                (v >> (tap_0 - shift_amount_0)) ^
                (v >> (tap_1 - shift_amount_0)) ^
                (v >> (tap_2 - shift_amount_0)) ^
                (v >> (tap_3 - shift_amount_0))
                ) & (
                     ~(~zero << shift_amount_0)
                     )
               )
         );
    return v;
}
