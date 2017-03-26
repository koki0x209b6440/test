class cLista {
  int mat[][] = new int [100000][3];
  int nr = 0;
  PVector [] pv = new PVector[100];
  int nrv = 0;

  cLista() {
    for (int i=0; i<pv.length; i++) {
      pv[i] = new PVector(0, 0);
    }
  }

  void agg(int tipo, int px, int py) {
    mat[nr][0] = tipo;
    mat[nr][1] = px + int(random(-de, de));
    mat[nr][2] = py + int(random(-de, de));
    nr++;
  }

  void _draw(int el) {
    switch(mat[el][0]) {
    case 0: // move to
      penx = mat[el][1];
      peny = mat[el][2];
      break;
    case 1: // line to
      stroke(0, 0, 0, 0.5);
      noFill();
      line(penx, peny, mat[el][1], mat[el][2]);
      penx = mat[el][1];
      peny = mat[el][2];
      break;
    case 2: // rettangolo pieno
      noStroke();
      fill(0, 0, 1);
      rect(penx, peny, mat[el][1] - penx, mat[el][2] - peny);
      break;
    case 3: // vertice poligono pieno
      pv[nrv].x = mat[el][1];
      pv[nrv].y = mat[el][2];
      nrv++;
      break;
    case 4: // chiusura poligono pieno bianco
      pv[nrv].x = mat[el][1];
      pv[nrv].y = mat[el][2];
      nrv++;
      noStroke();
      fill(0, 0, 1);
      beginShape();
      for (int i=0; i<nrv; i++) {
        vertex(pv[i].x, pv[i].y);
      }
      endShape(CLOSE);
      nrv = 0;
      break;
    case 5: // chiusura poligono pieno nero
      pv[nrv].x = mat[el][1];
      pv[nrv].y = mat[el][2];
      nrv++;
      noStroke();
      fill(0, 0, 0);
      beginShape();
      for (int i=0; i<nrv; i++) {
        vertex(pv[i].x, pv[i].y);
      }
      endShape(CLOSE);
      nrv = 0;
      break;
    case 6: // sfera
      int px0;
      int py0;      
      int px1 = 0;
      int py1 = 0;
      int nrs = height / 6;
      float ra = random(2.1, 2.4);
      noStroke();
      fill(0, 0, 1);
      ellipse(penx, peny, 2*mat[el][1], 2*mat[el][1]);   
      stroke(0, 0, 0, 0.5);
      noFill();
      for (int i=0; i<nrs; i++) {
        float alfa = map(i, 0, nrs, 0, 2 * TWO_PI);
        px0 = px1;
        py0 = py1;
        float rad = mat[el][1] + 2 * de * sin(ra*alfa);
        px1 = penx + int(rad * cos(alfa));
        py1 = peny + int(rad * sin(alfa));
        if (i > 0) {
          line(px0, py0, px1, py1);
        }
      }
      break;
    }
  }
}
