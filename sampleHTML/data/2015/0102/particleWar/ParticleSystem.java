
public class ParticleSystem {
	int maxParticles = 900, particlesRenderSize=6; float particlesLifeFactor = (float)(0.95), particlesGravity = (float)(.0);

	int pNum; Particle[] particles;
	particleWar mSketch;
ParticleSystem(particleWar mparticleWar) {mSketch=mparticleWar; particles = new Particle[maxParticles]; 
for(int i=0; i<maxParticles; i++) particles[i] = new Particle(); 
pNum = 0; }

void updateAndDraw(){
//   if(mMousePressed){    particleSystem.emitter(mMouseX, mMouseY,vmMouseX, vmMouseY, 10,10);   }
for(int i=0; i<maxParticles; i++) { if(particles[i].life > 0) { particles[i].update(); particles[i].draw(); } }
 }
void emitter(float x, float y,float vx, float vy, int count,int emitterSize ){ 
  for(int i=0; i<count; i++) makeParticle(x + mSketch.random(-emitterSize, emitterSize), y +  mSketch.random(-emitterSize, emitterSize),vx,vy); 
  }
void makeParticle(float x, float y,float vx, float vy) { particles[pNum].init(x, y, vx,  vy); pNum++; if(pNum >= maxParticles) pNum = 0;}

public class Particle { float x, y, vx, vy,vyb,  life, mass;//	  final static float MOMENTUM = 0.5f;  final static float FLUID_FORCE = 0.6f;
public Particle() { init(0,0,0,0);}
void init(float x, float y,float vx, float vy) { this.x = x; this.y = y;  life =  mSketch.random(0.3f, 1); mass =  mSketch.random(0.1f, 1);  this.vx = vx+ mSketch.random(-3, 3);/*-alpha*1-10;*/  this.vy = vy+ mSketch.random(-3, 3); }
void update() { if(life == 0) return; // only update if particle is visible
	

if(x<0||x> mSketch.width)vx=-vx;
if(y<0||y> mSketch.height)vy=-vy;
vyb+=particlesGravity;
vyb*=particlesLifeFactor;
x += vx; y += vy+vyb; vx*=life; vy*=life; //vy+=particlesGravity;
if(vx * vx + vy * vy < 1) { vx =  mSketch.random(-1, 1); vy =  mSketch.random(-1, 1); } // make particles glitter when the slow down a lot
life *= particlesLifeFactor; if(life < 0.01) life = 0; } // fade out a bit (and kill if alpha == 0);
void  draw() { 
	 mSketch.stroke(life*(255),life*(255),255-life*100, life*200+55);
	  mSketch.strokeWeight( life*particlesRenderSize);   mSketch.line(x-vx, y-vy,x, y);
}}}

