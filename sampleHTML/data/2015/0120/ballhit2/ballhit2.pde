
final int n = 16;
final float e=0.999;
final float g= 0.05;

float[] x;
float[] y;
float[] vx;
float[] vy;
float[] r;
float[] m;

final int logn =128;
int logindex = 0;
int[] logr;
int[] logs;
int[] logt;

void setup() {
  print("1");
  size(640, 480);
  frameRate(60);
  initVariable();
}

void draw() {
  background(32);
  fill(96);
  text("ballhit2 by みー@atsuhiro-me.net",40,height-40);
  step();
  drawBalls();
}

void initVariable() {
  x = new float[n];
  y = new float[n];
  vx = new float[n];
  vy = new float[n];
  r = new float[n];
  m = new float[n];
  logr = new int[logn];
  logs = new int[logn];
  logt = new int[logn];
  for (int h=0;h<n;h++) {
    x[h]=width*random(1);
    y[h]=width*random(1);
    vx[h]=random(2)-1;
    vy[h]=0.0;
    r[h]=6*random(1)+14;
    m[h]=r[h]*r[h];
    if (x[h]<r[h] || x[h]>width-r[h]) {
      h--; 
      continue;
    }
    if (y[h]<r[h] || y[h]>height-r[h]) { 
      h--; 
      continue;
    }
    boolean hit=false;
    for (int i=0;i<h;i++) {
      float rr = r[h]+r[i];
      float dx = x[h]+vx[h]-x[i]-vx[i];
      if (abs(dx)>rr) continue;
      float dy = y[h]+vy[h]-y[i]-vy[i];
      if (abs(dy)>rr) continue;
      //
      if (dx*dx+dy*dy < rr*rr) {
        hit=true;
        break;
      }
    }
    if (hit) {
      h--; 
      continue;
    }
  }
}

void step() {
  // hittest
  for (int h=1;h<n;h++) {
    for (int i=0;i<h;i++) {
      //
      float rr = r[h]+r[i];
      float dx = x[h]+vx[h]-x[i]-vx[i];
      if (abs(dx)>rr) continue;
      float dy = y[h]+vy[h]-y[i]-vy[i];
      if (abs(dy)>rr) continue;
      //
      if (dx*dx+dy*dy < rr*rr) {
        // hit!
        /*
        float nvxa = ((m[h]-e*m[i]) * vx[h] + (1+e) * m[i]*vx[i]) / (m[h] + m[i]);
        float nvxb = ((m[i]-e*m[h]) * vx[i] + (1+e) * m[h]*vx[h]) / (m[h] + m[i]);
        float nvya = ((m[h]-e*m[i]) * vy[h] + (1+e) * m[i]*vy[i]) / (m[h] + m[i]);
        float nvyb = ((m[i]-e*m[h]) * vy[i] + (1+e) * m[h]*vy[h]) / (m[h] + m[i]);
        */
        float normalizedcx = (x[i]-x[h])/sqrt((x[i]-x[h])*(x[i]-x[h])+(y[i]-y[h])*(y[i]-y[h]));
        float normalizedcy = (y[i]-y[h])/sqrt((x[i]-x[h])*(x[i]-x[h])+(y[i]-y[h])*(y[i]-y[h]));
        float dot = (vx[i]-vx[h])*normalizedcx + (vy[i]-vy[h])*normalizedcy;
        float vxh = (1+e)*m[i]/(m[h]+m[i])*dot*normalizedcx+vx[h];
        float vyh = (1+e)*m[i]/(m[h]+m[i])*dot*normalizedcy+vy[h];
        float vxi = (1+e)*m[h]/(m[h]+m[i])*(-dot)*normalizedcx+vx[i];
        float vyi = (1+e)*m[h]/(m[h]+m[i])*(-dot)*normalizedcy+vy[i];
        
        //print("Hit! ball <"+h+"> & <"+i+">  v :("+nvxa+","+nvya+"), ("+nvxb+","+nvyb+")\n");
        vx[h]=vxh;
        vy[h]=vyh;
        vx[i]=vxi;
        vy[i]=vyi;
        //
        logr[logindex]=i;
        logs[logindex]=h;
        logt[logindex]=10;
        logindex++;
        if (logindex==logn) logindex=0;
      }
    }
  }

  // move
  for (int h=0;h<n;h++) {
    if (x[h]>width-r[h] && vx[h]>0) {
      vx[h] = -vx[h];
    }
    if (x[h]<r[h] && vx[h]<0) {
      vx[h] = -vx[h];
    }
    if (y[h]>height-r[h] && vy[h]>0) {
      vy[h] = -abs(vy[h]);
    }/*
    if (y[h]<r[h] && vy[h]<0) {
     vy[h] = abs(vy[h]);
     }*/
    x[h] += vx[h];
    y[h] += vy[h];
    vy[h]+=g;
  }
}

void drawBalls() {
  fill(64);
  stroke(192);
  for (int h=0;h<n;h++) {
    ellipse(x[h], y[h], r[h]*2, r[h]*2);
  }
  stroke(192,32,32);
  for (int h=0;h<logn;h++) {
    if (logt[h]>0) {
      int p = logr[h];
      int q = logs[h];
      line(x[p],y[p],x[q],y[q]);
      logt[h]--;
    }
  }
}

