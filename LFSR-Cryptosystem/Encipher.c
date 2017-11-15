//
//  Encipher.c
//  LFSR-Cryptosystem
//
//  Created by Alex Azarov on 31/10/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void Encipher(const char *path) {
    FILE *f = fopen(path, "r");
    fseek(f, 0, SEEK_END);
    int length = (int) ftell(f);
    fseek(f, 0, SEEK_SET);
    FILE *key = fopen(strcat(strdup(path), ".key"), "r");
    FILE *xor = fopen(strcat(strdup(path), ".xor"), "w");
    
    char byte, key_byte, xor_byte;
    for (int i = 0; i < length; i++) {
        byte = getc(f);
        key_byte = getc(key);
        xor_byte = byte ^ key_byte;
        fprintf(xor, "%c", xor_byte);
    }
    fclose(f);
    fclose(key);
    fclose(xor);
}
