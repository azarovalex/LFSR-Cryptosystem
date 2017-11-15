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

const char *Encipher(const char *plaintext, const char *key) {
    int ciphertextLen = (int) strlen(plaintext + 1);
    char *ciphertext = malloc(ciphertextLen);
    int i;
    for (i = 0; i < ciphertextLen; i++) {
        ciphertext[i] = (plaintext[i] == key[i])? '0' : '1';
    }
    ciphertext[i++] = '\0';
    return ciphertext;
}
