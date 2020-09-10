// font8x8_basic.h から 必要なフォントデータを作る
#include <stdio.h>
#include "font8x8_basic.h"

int main() {
  printf("char[][] fontDat = {\n");
  for (int i=0x20; i<0x7f; i++) {
    printf("    { ");
    for (int j=0; j<8; j++) {
      int code = 0;
      for (int k=0; k<8; k++) {
        int d = font8x8_basic[i][k] << (7-j);
        code = (code >> 1) | (d & 0x80);
      }
      char* nl=",";
      if (j==7) nl=" },";
      if (j==7 && i==0x7e) nl=" } ";
      printf("'\\x%02x'%s", code, nl);
    }
    printf("  // %02x(%c)\n", i, i);
  }
  printf("  };\n");

  printf("public char[] font(int code) {\n");
  printf("  if (code<=0x20) return fontDat[0];\n");
  printf("  if (code>=0x7f) return fontDat[0];\n");
  printf("  return fontDat[code-0x20];\n");
  printf("}\n");

  return 0;
}
