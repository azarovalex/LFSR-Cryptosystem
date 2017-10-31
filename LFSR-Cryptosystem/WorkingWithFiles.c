//
//  WorkingWithFiles.c
//  LFSR-Cryptosystem
//
//  Created by Alex Azarov on 30/10/2017.
//  Copyright © 2017 Alex Azarov. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const char *lookup[] = {
    /*  0       1       2       3       4       5       6       7 */
    "0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111",
    /*  8       9       A       B       C       D       E       F */
    "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111",
};

void BinaryRespresentFileWithURL(const char* filePath) {
    FILE *f = fopen(filePath, "rb");
    FILE *out = fopen(strcat((char *) filePath,".bin"), "w");
    int c;
    size_t bytes_read = 0;
    
    while (EOF != (c = fgetc(f))) {
        fprintf(out, "%s", lookup[ (c & 0xF0) >> 4]);
        fprintf(out, "%s", lookup[(c & 0x0f)]);
        bytes_read += 1;
    }
    
    fclose(f);
    fclose(out);
}

void GenerateLSFRKey(int length) {
    
}
