public class Mundo {
  Coord[][] grid;
  int size;
  public float lado = 35;

  public Mundo(int size) {
    this.size = size;
    grid = new Coord[size][size];
    //ellipseMode(CORNER);
    for (int x = 0; x<grid.length; x++) {
      for (int y=0; y<grid[x].length; y++) {
        grid[x][y] = new Coord( (x- grid.length/2)*lado, (y - grid.length/2)*lado, x, y);
        grid[x][y].setEstado(1);
        if (random(0, 100)>75) {
          grid[x][y].setEstado(-3);
        }
      }
    }

  } 

  public void draw() {
    for (int i=0; i<grid.length; i++) {
      for (int j=0; j<grid.length; j++) {
        grid[i][j].dibujar();
      }
    }
   
  }

  public Coord getOrigen() {
    grid[0][7].setEstado(2);
    return grid[0][7];
  }

  public float getLado() {
    return lado;
  }

  public Coord getDerecha(int cx, int cy) {
    if (cx<size-1) {
      return  grid[cx+1][cy];
    }
    else return null;
  }

  public Coord getIzquierda(int cx, int cy) {
    if (cx>0) {
      return  grid[cx-1][cy];
    }
    else return null;
  }

  public Coord getAbajo(int cx, int cy) {
    if (cy<size-1) {
      return  grid[cx][cy+1];
    }
    else return null;
  }

  public Coord getArriba(int cx, int cy) {
    if (cy>0) {
      return  grid[cx][cy-1];
    }
    else return null;
  }



}




