void rettf(int sx, int sy, int ex, int ey) {

  int dex = ex - sx;
  int dey = ey - sy;
  lista.agg(0, sx, sy);
  for (int i=0; i<min(dex, dey); i+=6) {
    lista.agg(1, sx, sy + i);
    lista.agg(1, sx + i, sy);
  }
  if (dex > dey) {
    for (int i=0; i<dex-dey; i+=6) {
      lista.agg(1, sx + i, ey);
      lista.agg(1, sx + dey + i, sy);
    }
  }
  else {
    for (int i=0; i<dey-dex; i+=6) {
      lista.agg(1, sx, sy + dex + i);
      lista.agg(1, ex, sy + i);
    }
  }
  for (int i=min(dex, dey); i>=0; i-=6) {
    lista.agg(1, ex - i, ey);
    lista.agg(1, ex, ey - i);
  }
}
