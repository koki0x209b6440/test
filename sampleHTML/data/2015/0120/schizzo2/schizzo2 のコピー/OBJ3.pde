
// ------------------------------------------------------------

void semaforox(PVector pt0) {
  linea(proietta(new PVector(pt0.x -2, 0, pt0.z)), proietta(new PVector(pt0.x -2, 5, pt0.z)));
  linea(proietta(new PVector(pt0.x-28, 0, pt0.z)), proietta(new PVector(pt0.x-28, 5, pt0.z)));
  linea(proietta(new PVector(pt0.x -2, 4, pt0.z)), proietta(new PVector(pt0.x-28, 4, pt0.z)));
  linea(proietta(new PVector(pt0.x -2, 5, pt0.z)), proietta(new PVector(pt0.x-28, 5, pt0.z)));
  rettangolo_bianco(new PVector(pt0.x -4, 4, pt0.z), new PVector(pt0.x -4, 5, pt0.z), new PVector(pt0.x -9, 5, pt0.z), new PVector(pt0.x -9, 4, pt0.z));
  rettangolo_bianco(new PVector(pt0.x-11, 4, pt0.z), new PVector(pt0.x-11, 5, pt0.z), new PVector(pt0.x-19, 5, pt0.z), new PVector(pt0.x-19, 4, pt0.z));
  rettangolo_bianco(new PVector(pt0.x-21, 4, pt0.z), new PVector(pt0.x-21, 5, pt0.z), new PVector(pt0.x-26, 5, pt0.z), new PVector(pt0.x-26, 4, pt0.z));
}

// ------------------------------------------------------------

void semaforoz(PVector pt0) {
  linea(proietta(new PVector(pt0.x, 0, pt0.z -2)), proietta(new PVector(pt0.x, 5, pt0.z -2)));
  linea(proietta(new PVector(pt0.x, 0, pt0.z-18)), proietta(new PVector(pt0.x, 5, pt0.z-18)));
  linea(proietta(new PVector(pt0.x, 4, pt0.z -2)), proietta(new PVector(pt0.x, 4, pt0.z-18)));
  linea(proietta(new PVector(pt0.x, 5, pt0.z -2)), proietta(new PVector(pt0.x, 5, pt0.z-18)));
  rettangolo_bianco(new PVector(pt0.x, 4, pt0.z -4), new PVector(pt0.x, 5, pt0.z -4), new PVector(pt0.x, 5, pt0.z -9), new PVector(pt0.x, 4, pt0.z -9));
  rettangolo_bianco(new PVector(pt0.x, 4, pt0.z-11), new PVector(pt0.x, 5, pt0.z-11), new PVector(pt0.x, 5, pt0.z-16), new PVector(pt0.x, 4, pt0.z-16));
}

// ------------------------------------------------------------

