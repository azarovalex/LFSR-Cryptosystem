//
//  WorkingWithFiles.c
//  LFSR-Cryptosystem
//
//  Created by Alex Azarov on 30/10/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define BYTES_TO_LOAD 50

void LoadFile(const char *path) {
    char *path2 = strdup(path);
    const char *lookup[] = {
        /*  0       1       2       3       4       5       6       7 */
        "0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111",
        /*  8       9       A       B       C       D       E       F */
        "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111",
    };
    
    FILE *f = fopen(path2, "r");
    fseek(f, 0, SEEK_END);
    int size = (int) ftell(f);
    fseek(f, 0, SEEK_SET);
    
    char *newPath = strdup(path2);
    strcat(newPath, ".load");
    FILE *f_load = fopen(newPath, "w");
    
    char first_bytes[BYTES_TO_LOAD], last_bytes[BYTES_TO_LOAD];
    
    if (size > BYTES_TO_LOAD) {
        fread(first_bytes, 50, 1, f);
        fseek(f, -50, SEEK_END);
        fread(last_bytes, 50, 1, f);
        
        for (int i = 0; i < BYTES_TO_LOAD; i++) {
            fprintf(f_load, "%s", lookup[ (first_bytes[i] & 0xF0) >> 4]);
            fprintf(f_load, "%s", lookup[(first_bytes[i] & 0x0f)]);
        }
        
        fwrite("................", 10, 1, f_load);
        
        for (int i = 0; i < BYTES_TO_LOAD; i++) {
            fprintf(f_load, "%s", lookup[(last_bytes[i] & 0xF0) >> 4]);
            fprintf(f_load, "%s", lookup[(last_bytes[i] & 0x0f)]);
        }
    }
    if (size == 0)
        fprintf(f_load, "");
    if (size <= 50) {
        fread(first_bytes, size, 1, f);
        for (int i = 0; i < size; i++) {
            fprintf(f_load, "%s", lookup[(first_bytes[i] & 0xF0) >> 4]);
            fprintf(f_load, "%s", lookup[(first_bytes[i] & 0x0f)]);
        }
    }
    fclose(f);
    fclose(f_load);
    free(path2);
    free(newPath);
}
