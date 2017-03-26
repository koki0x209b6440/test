public class Unit {
particleWar mSketch;
boolean isSelected;
float direction;
int mColor;
int life;
float positionX, positionY, speed;
int playerID, unitID;

public Unit(particleWar iSketch, float positionX2, float positionY2,
int groupIDi, int unitIDi, int mColori) {
mSketch = iSketch;
direction = mSketch.random(-180, 180);
playerID = groupIDi;
mColor = mColori;
life = 100;
unitID = unitIDi;
speed = 5;
positionX = mSketch.random(positionX2 - mSketch.width * .1f, positionX2
+ mSketch.width * .1f);
positionY = mSketch.random(positionY2 - mSketch.height * .1f,
positionY2 + mSketch.height * .1f);
isSelected = false;}
public void run() {move();ki();draw();}
public void ki() {swarm();fight();}
public void swarm() {
speed = 5;
for (int i = 0; i < mSketch.mPlayer.length; i++) {for (int j = 0; j < mSketch.mPlayer[i].mUnit.length; j++) {
if (!(i == playerID && j == unitID)) {float tx = mSketch.mPlayer[i].mUnit[j].positionX, ty = mSketch.mPlayer[i].mUnit[j].positionY, vx, vy;
float radius = mSketch.dist(positionX, positionY, tx, ty);
if (radius < 135) {float angle = mSketch.atan2(positionY - ty, positionX- tx)* 180 / mSketch.PI - 180;
if (i == playerID) {direction = (direction * 499 + mSketch.mPlayer[i].mUnit[j].direction) / 500f;
if (direction > angle) {direction += .3f;} 
else {direction -= .3f;}
if (radius < 55) {
if (direction < angle) {direction += .6f;} 
else {direction -= .6f;}}}}
mSketch.stroke(255);
mSketch.strokeWeight(1);
}}}}

public void fight() {
boolean canShoot = true;
speed = 5;
for (int i = 0; i < mSketch.mPlayer.length; i++) {for (int j = 0; j < mSketch.mPlayer[i].mUnit.length; j++) {
if (!(i == playerID && j == unitID)) {float tx = mSketch.mPlayer[i].mUnit[j].positionX, ty = mSketch.mPlayer[i].mUnit[j].positionY, vx, vy;
float radius = mSketch.dist(positionX, positionY, tx, ty);
if (radius < 135) {float angle = mSketch.atan2(positionY - ty, positionX- tx)
* 180 / mSketch.PI + 180;
if (i != playerID && canShoot) {mSketch.stroke(mColor, 255 - mColor, 255, 255);
speed = 1;
canShoot = false;
mSketch.strokeWeight(3);
mSketch.line(positionX, positionY, tx, ty);
mSketch.mPlayer[i].mUnit[j].life--;
mSketch.mParticleSystem.emitter(tx, ty, 0, 0, 1, 5);
if (mSketch.mPlayer[i].mUnit[j].life < 1) {mSketch.mPlayer[i].mUnit = mSketch.mPlayer[i].remove(j, mSketch.mPlayer[i].mUnit);
mSketch.mParticleSystem.emitter(tx, ty, 0, 0,100, 10);}
direction = angle;}}
mSketch.stroke(255);
mSketch.strokeWeight(1);
}}}
for (int i = mSketch.mPlayer.length - 1; i > 0; i--) {for (int j = 0; j < mSketch.mPlayer[i].mUnit.length; j++) {
if (!(i == playerID && j == unitID)) {
float tx = mSketch.mPlayer[i].mUnit[j].positionX, ty = mSketch.mPlayer[i].mUnit[j].positionY, vx, vy;
float radius = mSketch.dist(positionX, positionY, tx, ty);
if (radius < 135) {float angle = mSketch.atan2(positionY - ty, positionX- tx)* 180 / mSketch.PI + 180;
if (i != playerID && canShoot) {mSketch.stroke(mColor, 255 - mColor, 255, 255);
speed = 1;
canShoot = false;
mSketch.strokeWeight(3);
mSketch.line(positionX, positionY, tx, ty);
mSketch.mPlayer[i].mUnit[j].life--;
mSketch.mParticleSystem.emitter(tx, ty, 0, 0, 1, 5);
if (mSketch.mPlayer[i].mUnit[j].life < 1) {mSketch.mPlayer[i].mUnit = mSketch.mPlayer[i].remove(j, mSketch.mPlayer[i].mUnit);
mSketch.mParticleSystem.emitter(tx, ty, 0, 0,100, 10);}
direction = angle;}}
mSketch.stroke(255);
mSketch.strokeWeight(1);
}}}}

public void move() {
float radians = (float) ((Math.PI * (direction)) / 180);
positionX += speed * Math.cos(radians);
positionY += speed * Math.sin(radians);
direction += mSketch.random(-10, 10);
if (positionX < 10) {positionX = 10;direction += mSketch.random(-100, 100);}
if (positionX > mSketch.width - 10) {positionX = mSketch.width - 10;direction += mSketch.random(-100, 100);}
if (positionY < 10) {positionY = 10;direction += mSketch.random(-100, 100);}
if (positionY > mSketch.height - 10) {positionY = mSketch.height - 10;direction += mSketch.random(-100, 100);}
}

public void draw() {
mSketch.pushMatrix();
mSketch.translate(positionX, positionY);
mSketch.stroke(255 - life * 2.5f, life * 2.5f, 0, 255);
mSketch.line(-life / 4, -10, life / 4, -10);
mSketch.stroke(255);
mSketch.rotate(mSketch.radians(direction + 90));
if (isSelected) {
mSketch.fill(mColor, 255 - mColor, 255, 55);
mSketch.ellipse(0, 0, 22, 22);
mSketch.fill(mColor, 255 - mColor, 255, 255);
}
mSketch.ellipse(0, 0, 6, 12);
mSketch.ellipse(0, 6, 10, 6);
mSketch.popMatrix();
}
}
