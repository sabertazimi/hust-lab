#include <assert.h>
#include <stdlib.h>
#include <ndl.h>
// #include <stdio.h>

int main() {
  // fprintf(stdout, "bmp1\n");
  NDL_Bitmap *bmp = (NDL_Bitmap*)malloc(sizeof(NDL_Bitmap));
  // fprintf(stdout, "bmp2\n");
  NDL_LoadBitmap(bmp, "/share/pictures/projectn.bmp");
  // fprintf(stdout, "bmp3\n");
  assert(bmp->pixels);
  NDL_OpenDisplay(bmp->w, bmp->h);
  // fprintf(stdout, "bmp4\n");
  NDL_DrawRect(bmp->pixels, 0, 0, bmp->w, bmp->h);
  // fprintf(stdout, "bmp5\n");
  NDL_Render();
  // fprintf(stdout, "bmp6\n");
  NDL_CloseDisplay();
  // fprintf(stdout, "bmp7\n");
  while (1);
  return 0;
}
