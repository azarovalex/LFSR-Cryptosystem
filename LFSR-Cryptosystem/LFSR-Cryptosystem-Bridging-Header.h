//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

void LoadFile(const char *path);
void BinaryRespresentFileWithURL(const char* filePath);
void GenerateLSFRKey(int init, int length, const char *path);

const char *Encipher(const char *plaintext, const char *key);


