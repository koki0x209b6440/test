// ------------------------------------------------------------

void albero(PVector pt0) {
  PVector pt1 = pt0.get();
  pt1.y += 4;
  PVector pt2 = pt1.get();
  pt2.x += 2;
  pt2.z -= 2;
  PVector pp0 = proietta(pt0);
  PVector pp1 = proietta(pt1);
  PVector pp2 = proietta(pt2);
  lista.agg(0, (int)pp1.x, (int)pp1.y);
  lista.agg(6, int(pp2.x-pp1.x), 0);
  dlinea(pp0, pp1);
}

