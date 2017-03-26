void palazzo(PVector pt) {  
  int tipo = int(random(10));  
  int h = int(random(50, 100));
  boolean insegne = false;
  switch (tipo) {
  case 0:
    box3d(new PVector(pt.x+20, h, pt.z+10), new PVector(pt.x+21, h+random(20, 40), pt.z+11));
    box3d(new PVector(pt.x+10, h, pt.z+10), new PVector(pt.x+11, h+random(20, 40), pt.z+11));
    rettangolo_bianco(new PVector(pt.x, h, pt.z), new PVector(pt.x+30, h, pt.z), new PVector(pt.x+30, h, pt.z+30), new PVector(pt.x, h, pt.z+30));
    box3d(new PVector(pt.x, 20, pt.z), new PVector(pt.x+30, h-4, pt.z+30));
    for (int fi=30-3; fi>0; fi-=3) {
      linea(proietta(new PVector(pt.x, 20, pt.z+fi)), proietta(new PVector(pt.x, h-4, pt.z+fi)));
      linea(proietta(new PVector(pt.x+fi, 20, pt.z)), proietta(new PVector(pt.x+fi, h-4, pt.z)));
    }
    box3d(pt, new PVector(pt.x+30, 19, pt.z+30));
    insegne = true;
    break;
  case 1:
    int nr = int(random(5, 20));
    for (int i=nr-1; i>=0; i--) {
      box3d(new PVector(pt.x, i*4+4, pt.z), new PVector(pt.x+30, i*4+6, pt.z+30));
    }
    pilotis(pt, 30, 30, 4);
    insegne = true;
    break;
  case 2:
    box3d(new PVector(pt.x+1, h-10, pt.z+1), new PVector(pt.x+29, h, pt.z+29));
    box3d(new PVector(pt.x+ 2, 10, pt.z+22), new PVector(pt.x+ 4, h-10, pt.z+28));
    box3d(new PVector(pt.x+22, 10, pt.z+ 2), new PVector(pt.x+28, h-10, pt.z+ 4));
    box3d(new PVector(pt.x+ 4, 10, pt.z+ 4), new PVector(pt.x+22, h-10, pt.z+22));
    box3d(new PVector(pt.x+ 2, 10, pt.z+ 2), new PVector(pt.x+ 8, h-10, pt.z+ 8));
    basamento(pt, 10);
    insegne = true;
    break;
  case 3:
    box3d(new PVector(pt.x+14.5, h, pt.z+14.5), new PVector(pt.x+15.5, h+40, pt.z+15.5));
    if (h > 50) box3d(new PVector(pt.x+2, 50, pt.z+2), new PVector(pt.x+28, h, pt.z+28));
    if (h > 50) box3d(new PVector(pt.x+4, 42, pt.z+4), new PVector(pt.x+26, 50, pt.z+26));
    if (h > 42) box3d(new PVector(pt.x+2, 16, pt.z+2), new PVector(pt.x+28, 42, pt.z+28));
    if (h > 16) box3d(new PVector(pt.x+4, 12, pt.z+4), new PVector(pt.x+26, 16, pt.z+26));
    if (h > 12) basamento(pt, 12);
    insegne = true;
    break;
  case 4:
    cilindro3d(new PVector(pt.x, 31, pt.z), h-16, 32, 13, true);
    cilindro3d(new PVector(pt.x, 26, pt.z), 4, 32, 13, true);
    cilindro3d(new PVector(pt.x, 21, pt.z), 4, 32, 13, true);
    cilindro3d(new PVector(pt.x, 16, pt.z), 4, 32, 13, true);
    cilindro3d(new PVector(pt.x, 12, pt.z), 4, 32, 11, true);
    cilindro3d(new PVector(pt.x, 0, pt.z), 12, 32, 15, false);
    break;
  case 5:
    cilindro3d(new PVector(pt.x, h-2, pt.z), 2, 8, 13, true);
    cilindro3d(new PVector(pt.x, h-6, pt.z), 4, 8, 9, true);
    cilindro3d(new PVector(pt.x, 8, pt.z), h-14, 8, 13, true);
    basamento(pt, 8);
    insegne = true;
    break;
  case 6: // giardino
    box3d(pt, new PVector(pt.x+30, pt.y+1, pt.z+30));
    for (int i=0; i<10; i++) {
      float pz = map(i, 0, 10, 0, 22);
      float px = random(0, pz);
      PVector pt0 = new PVector(pt.x+26-px, pt.y+1, pt.z+26-pz+px);
      albero(pt0);
    }
    break;
  case 7:
    box3d(new PVector(pt.x+5, 32, pt.z+5), new PVector(pt.x+25, h, pt.z+25));
    box3d(new PVector(pt.x+10, 26, pt.z+10), new PVector(pt.x+20, 32, pt.z+20));
    box3d(new PVector(pt.x+5, 26, pt.z+24), new PVector(pt.x+5, 32, pt.z+25));
    box3d(new PVector(pt.x+5, 26, pt.z+18), new PVector(pt.x+5, 32, pt.z+19));
    box3d(new PVector(pt.x+5, 26, pt.z+11), new PVector(pt.x+5, 32, pt.z+12));
    box3d(new PVector(pt.x+24, 26, pt.z+5), new PVector(pt.x+25, 32, pt.z+6));
    box3d(new PVector(pt.x+18, 26, pt.z+5), new PVector(pt.x+19, 32, pt.z+6));
    box3d(new PVector(pt.x+11, 26, pt.z+5), new PVector(pt.x+12, 32, pt.z+6));
    box3d(new PVector(pt.x+ 5, 26, pt.z+5), new PVector(pt.x+ 6, 32, pt.z+6));
    cilindro3d(new PVector(pt.x, 6, pt.z), 20, 25, 15, false);
    box3d(new PVector(pt.x+10, 0, pt.z+10), new PVector(pt.x+20, 6, pt.z+20));
    box3d(new PVector(pt.x+5, 0, pt.z+24), new PVector(pt.x+5, 6, pt.z+25));
    box3d(new PVector(pt.x+5, 0, pt.z+18), new PVector(pt.x+5, 6, pt.z+19));
    box3d(new PVector(pt.x+5, 0, pt.z+11), new PVector(pt.x+5, 6, pt.z+12));
    box3d(new PVector(pt.x+24, 0, pt.z+5), new PVector(pt.x+25, 6, pt.z+6));
    box3d(new PVector(pt.x+18, 0, pt.z+5), new PVector(pt.x+19, 6, pt.z+6));
    box3d(new PVector(pt.x+11, 0, pt.z+5), new PVector(pt.x+12, 6, pt.z+6));
    box3d(new PVector(pt.x+ 5, 0, pt.z+5), new PVector(pt.x+ 6, 6, pt.z+6));
    insegne = true;
    break;
  case 8:
    box3d(new PVector(pt.x+2, 6, pt.z+2), new PVector(pt.x+18, h-10, pt.z+18));
    box3d(new PVector(pt.x, 0, pt.z+23), new PVector(pt.x+2, h, pt.z+28));
    box3d(new PVector(pt.x, 0, pt.z+18), new PVector(pt.x+2, h-5, pt.z+23));
    box3d(new PVector(pt.x, 0, pt.z+ 7), new PVector(pt.x+2, h-5, pt.z+12));
    box3d(new PVector(pt.x, 0, pt.z+ 2), new PVector(pt.x+2, h, pt.z+ 7));
    box3d(new PVector(pt.x+23, 0, pt.z), new PVector(pt.x+28, h, pt.z+2));
    box3d(new PVector(pt.x+18, 0, pt.z), new PVector(pt.x+23, h-5, pt.z+2));
    box3d(new PVector(pt.x+ 7, 0, pt.z), new PVector(pt.x+12, h-5, pt.z+2));
    box3d(new PVector(pt.x+ 2, 0, pt.z), new PVector(pt.x+ 7, h, pt.z+2));
    insegne = true;
    break;
  case 9:
    cilindro3d(new PVector(pt.x, 0, pt.z), h, 32, 11, true);
    box3d(new PVector(pt.x, 0, pt.z+15), new PVector(pt.x+4, h, pt.z+30));
    box3d(new PVector(pt.x+15, 0, pt.z), new PVector(pt.x+30, h, pt.z+4));
    insegne = true;
    break;
  }

  if (insegne) {
    float iw = random(1, 1.5);
    float ih = random(2, 10);
    float ipos = random(2, 14);
    rettangolo_bianco(new PVector(pt.x+ipos, 4, pt.z-1), new PVector(pt.x+ipos, 4+ih, pt.z-1), new PVector(pt.x+ipos, 4+ih, pt.z-1-iw), new PVector(pt.x+ipos, 4, pt.z-1-iw));
    iw = random(1, 1.5);
    ih = random(2, 10);
    ipos = random(2, 14) + 15;
    rettangolo_bianco(new PVector(pt.x+ipos, 4, pt.z-1), new PVector(pt.x+ipos, 4+ih, pt.z-1), new PVector(pt.x+ipos, 4+ih, pt.z-1-iw), new PVector(pt.x+ipos, 4, pt.z-1-iw));
    iw = random(1, 1.5);
    ih = random(2, 10);
    ipos = random(2, 14);
    rettangolo_bianco(new PVector(pt.x-1, 4, pt.z+ipos), new PVector(pt.x-1, 4+ih, pt.z+ipos), new PVector(pt.x-1-iw, 4+ih, pt.z+ipos), new PVector(pt.x-1-iw, 4, pt.z+ipos));
    iw = random(1, 1.5);
    ih = random(2, 10);
    ipos = random(2, 14) + 15;
    rettangolo_bianco(new PVector(pt.x-1, 4, pt.z+ipos), new PVector(pt.x-1, 4+ih, pt.z+ipos), new PVector(pt.x-1-iw, 4+ih, pt.z+ipos), new PVector(pt.x-1-iw, 4, pt.z+ipos));
  }
}



// ------------------------------------------------------------

void box3d(PVector pt1, PVector pt2) {
  PVector p1 = proietta(new PVector(pt1.x, pt1.y, pt2.z));
  PVector p2 = proietta(new PVector(pt1.x, pt2.y, pt2.z));
  PVector p3 = proietta(new PVector(pt1.x, pt1.y, pt1.z));
  PVector p4 = proietta(new PVector(pt1.x, pt2.y, pt1.z));
  PVector p5 = proietta(new PVector(pt2.x, pt1.y, pt1.z));
  PVector p6 = proietta(new PVector(pt2.x, pt2.y, pt1.z));
  PVector p7 = proietta(new PVector(pt2.x, pt1.y, pt2.z));

  lista.agg(3, (int)p1.x, (int)p1.y);
  lista.agg(3, (int)p2.x, (int)p2.y);
  lista.agg(3, (int)p4.x, (int)p4.y);
  lista.agg(3, (int)p6.x, (int)p6.y);
  lista.agg(3, (int)p5.x, (int)p5.y);
  lista.agg(4, (int)p7.x, (int)p7.y);

  if (p7.y > p1.y) {
    lista.agg(3, (int)p1.x, (int)p1.y);
    lista.agg(3, (int)p3.x, (int)p3.y);
    lista.agg(3, (int)p5.x, (int)p5.y);
    lista.agg(5, (int)p7.x, (int)p7.y);
  }

  dlinea((int)p1.x, (int)p1.y, (int)p3.x, (int)p3.y);
  dlinea((int)p1.x, (int)p1.y, (int)p2.x, (int)p2.y);
  dlinea((int)p2.x, (int)p2.y, (int)p4.x, (int)p4.y);
  dlinea((int)p3.x, (int)p3.y, (int)p4.x, (int)p4.y);
  dlinea((int)p3.x, (int)p3.y, (int)p5.x, (int)p5.y);
  dlinea((int)p5.x, (int)p5.y, (int)p6.x, (int)p6.y);
  dlinea((int)p4.x, (int)p4.y, (int)p6.x, (int)p6.y);
  if (p7.y > p1.y) {
    dlinea((int)p1.x, (int)p1.y, (int)p7.x, (int)p7.y);
    dlinea((int)p5.x, (int)p5.y, (int)p7.x, (int)p7.y);
  }

  striscia(pt2.y - pt1.y, p3, p4, p5, p6);
}

// ------------------------------------------------------------

void cilindro3d(PVector pt, float h, int nrseg, float rad, boolean contorno) {
  PVector [][] pv = new PVector[nrseg][2];
  for (int i=0; i<nrseg; i++) {
    float alfa = map(i, 0, nrseg, 0, TWO_PI);
    pv[i][0] = proietta(new PVector(pt.x+15+rad*cos(alfa), pt.y, pt.z+15-rad*sin(alfa)));
    pv[i][1] = proietta(new PVector(pt.x+15+rad*cos(alfa), pt.y+h, pt.z+15-rad*sin(alfa)));
  }
  for (int i=0; i<nrseg; i++) {
    int j = (i + nrseg - 1) % nrseg;
    if (pv[i][0].x <= pv[j][0].x) {
      if (i > 0) {
        lista.agg(3, (int)pv[j][0].x, (int)pv[j][0].y);
        lista.agg(3, (int)pv[i][0].x, (int)pv[i][0].y);
        lista.agg(3, (int)pv[i][1].x, (int)pv[i][1].y);
        lista.agg(4, (int)pv[j][1].x, (int)pv[j][1].y);
      }
    }
  }
  for (int i=0; i<nrseg; i++) {
    lista.agg(3, (int)pv[i][0].x, (int)pv[i][0].y);
  }
  lista.agg(5, (int)pv[0][0].x, (int)pv[0][0].y);
  for (int i=0; i<nrseg; i++) {
    int j = (i + nrseg - 1) % nrseg;
    float alfa = map(i, 0, nrseg, 0, TWO_PI) + 1;
    if (pv[i][0].x <= pv[j][0].x) {
      if (pv[(i+1)%nrseg][0].x >= pv[i][0].x) {
        linea(pv[i][0], pv[i][1]);
      }
      if (contorno) linea(pv[i][0], pv[i][1]);
      if (i > 0) {
        dlinea(pv[j][0], pv[i][0]);
        dlinea(pv[j][1], pv[i][1]);
        if (sin(alfa) > 0) striscia(h, pv[i][0], pv[i][1], pv[j][0], pv[j][1]);
      }
    }
    else {
      if (pv[(i+1)%nrseg][0].x <= pv[i][0].x) {
        linea(pv[i][0], pv[i][1]);
      }
    }
  }
}




void basamento(PVector pt, float h) {
  int nr1 = int(random(1, 5));
  int nr2 = int(random(1, 5));
  float inter1 = 27.0 / nr1;
  float inter2 = 27.0 / nr2;
  box3d(pt, new PVector(pt.x+30, h, pt.z+30));
  rettangolo_rigato(new PVector(pt.x, 6, pt.z+2), new PVector(pt.x, h-2, pt.z+2), new PVector(pt.x, h-2, pt.z+28), new PVector(pt.x, 6, pt.z+28));
  for (int i=0; i<nr1; i++) {
    rettangolo_rigato(new PVector(pt.x, 0, pt.z+2+i*inter1), new PVector(pt.x, 4, pt.z+2+i*inter1), new PVector(pt.x, 4, pt.z+1+(i+1)*inter1), new PVector(pt.x, 0, pt.z+1+(i+1)*inter1));
  }
  rettangolo_nero(new PVector(pt.x+2, 6, pt.z), new PVector(pt.x+2, h-2, pt.z), new PVector(pt.x+28, h-2, pt.z), new PVector(pt.x+28, 6, pt.z));
  for (int i=0; i<nr2; i++) {
    rettangolo_nero(new PVector(pt.x+2+i*inter2, 0, pt.z), new PVector(pt.x+2+i*inter2, 4, pt.z), new PVector(pt.x+1+(i+1)*inter2, 4, pt.z), new PVector(pt.x+1+(i+1)*inter2, 0, pt.z));
  }
}



