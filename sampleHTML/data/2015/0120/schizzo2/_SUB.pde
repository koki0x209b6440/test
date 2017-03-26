
PVector proietta(PVector pt) {
  float d = 60.00;
  float h = 1.50;  
  float alfa = radians(30);

  float a = pt.x * sin(alfa) - pt.z * cos(alfa);
  float b = pt.x * cos(alfa) + pt.z * sin(alfa);
  float x = d * a / (b + d);
  float y = d * (pt.y - h) / (b + d);

  float sc = height / 90;
  return new PVector(0.63*width + sc*x, 0.95*height - sc*y);
}

void pilotis(PVector pt0, float dex, float dez, float h) {
  int nrx = int((dex - 1) / 6);
  int nrz = int((dez - 1) / 6);
  float delx = (dex-1) / nrx;
  float delz = (dez-1) / nrz;
  for (int i=nrz; i>0; i--) {
    box3d(new PVector(pt0.x, 0, pt0.z+i*delz), new PVector(pt0.x+1, h, pt0.z+i*delz+1));
  }
  for (int i=nrx; i>=0; i--) {
    box3d(new PVector(pt0.x+i*delx, 0, pt0.z), new PVector(pt0.x+i*delx+1, h, pt0.z+1));
  }
}

// ------------------------------------------------------------

void linea(int sx, int sy, int ex, int ey) {
  lista.agg(0, sx, sy);
  lista.agg(1, ex, ey);
}

void linea(PVector p1, PVector p2) {
  linea((int)p1.x, (int)p1.y, (int)p2.x, (int)p2.y);
}

// ------------------------------------------------------------

void dlinea(int sx, int sy, int ex, int ey) {
  linea(sx, sy, ex, ey);
  linea(sx, sy, ex, ey);
}

void dlinea(PVector p1, PVector p2) {
  dlinea((int)p1.x, (int)p1.y, (int)p2.x, (int)p2.y);
}

// ------------------------------------------------------------

void rettangolo_bianco(PVector pt1, PVector pt2, PVector pt3, PVector pt4) {
  PVector p1 = proietta(pt1);
  PVector p2 = proietta(pt2);
  PVector p3 = proietta(pt3);
  PVector p4 = proietta(pt4);
  lista.agg(3, (int)p1.x, (int)p1.y);
  lista.agg(3, (int)p2.x, (int)p2.y);
  lista.agg(3, (int)p3.x, (int)p3.y);
  lista.agg(4, (int)p4.x, (int)p4.y);
  linea(p1, p2);
  linea(p2, p3);
  linea(p3, p4);
  linea(p4, p1);
}

void rettangolo_rigato(PVector pt1, PVector pt2, PVector pt3, PVector pt4) {
  rettangolo_bianco(pt1, pt2, pt3, pt4);
  striscia(pt2.y - pt1.y, proietta(pt1), proietta(pt2), proietta(pt4), proietta(pt3));
}

void rettangolo_nero(PVector pt1, PVector pt2, PVector pt3, PVector pt4) {
  PVector p1 = proietta(pt1);
  PVector p2 = proietta(pt2);
  PVector p3 = proietta(pt3);
  PVector p4 = proietta(pt4);
  lista.agg(3, (int)p1.x, (int)p1.y);
  lista.agg(3, (int)p2.x, (int)p2.y);
  lista.agg(3, (int)p3.x, (int)p3.y);
  lista.agg(5, (int)p4.x, (int)p4.y);
}

void striscia(float del, PVector p1, PVector p2, PVector p3, PVector p4) {
  float r1 = (p1.y - p2.y) / del;
  float r2 = (p3.y - p4.y) / del;
  float pp = 0;
  while (pp < del) {
    linea(int(p1.x), int(p2.y + pp * r1), int(p3.x), int(p4.y + pp * r2));
    pp += 0.5;
  }
}

