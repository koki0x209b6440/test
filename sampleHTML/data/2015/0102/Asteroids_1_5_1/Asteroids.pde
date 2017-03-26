/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/110150*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
import ddf.minim.*;

PFont font;
static Level currentLevel;

Minim minim;
AudioPlayer sfxBullet;
AudioPlayer sfxExplosion;
AudioPlayer sfxMenuItem;
AudioPlayer sfxMenuItemSelected;
AudioPlayer sfxTyping;

void play(AudioPlayer sfx)
{
  sfx.pause();
  sfx.rewind();
  sfx.play();
}

void setup()
{
  size(500, 500);
  //size(displayWidth, displayHeight);
  //frameRate(60);

  font = loadFont("LCDSolid-48.vlw");
  textFont(font);
  
  minim = new Minim(this);
  sfxBullet = minim.loadFile("bullet.wav");
  sfxExplosion = minim.loadFile("explosion.wav");
  sfxMenuItem = minim.loadFile("menuItem.wav");
  sfxMenuItemSelected = minim.loadFile("menuItemSelected.wav");
  sfxTyping = minim.loadFile("typing.wav");

  loadLevel(new MainMenu());
}
void stop()
{
  sfxBullet.close();
  sfxExplosion.close();
  sfxMenuItem.close();
  sfxMenuItemSelected.close();
  sfxTyping.close();
  minim.stop();
  
  super.stop();
}

void draw()
{
  currentLevel.draw();
}

void keyPressed()
{
  currentLevel.keyPressed();
}
void keyReleased()
{
  currentLevel.keyReleased();
}
void keyTyped()
{
  currentLevel.keyTyped();
}

void loadLevel(Level level)
{
  currentLevel = level;
  level.begin();
}
