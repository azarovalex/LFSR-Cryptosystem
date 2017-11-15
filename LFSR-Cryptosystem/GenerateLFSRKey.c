//
//  LFSR_Logic.c
//  LFSR-Cryptosystem
//
//  Created by Alex Azarov on 31/10/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

#include <stdio.h>
#include <string.h>

#define BYTES_TO_PRINT 30

unsigned long shift_lfsr(unsigned long v);

void GenerateLSFRKey(unsigned long init, const char *path) {
    FILE *f = fopen(path, "r");
    fseek(f, 0, SEEK_END);
    int length = (int) ftell(f);
    fclose(f);
    
    FILE *f_key = fopen(strcat((char *) path, ".key"), "w");
    int currByteNum = 0;
    unsigned long lfsr = init;
    for (;currByteNum < length;currByteNum++) {
        for (int i = 0; i < 8; i++)
            lfsr = shift_lfsr(lfsr);
        fprintf(f_key,"%c", (char) ((lfsr >> 26) & 0xFF));
    }
    fclose(f_key);
}

unsigned long shift_lfsr(unsigned long v)
{
    enum {
        length         = 26,
        tap_0          = 26,
        tap_1          =  8,
        tap_2          =  7,
        tap_3          =  1,
        shift_amount_0 =  1
    };
    const unsigned int zero = (unsigned long)(0);
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


