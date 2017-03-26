



/*利用例その1*/
class Scene1 implements Scene {//テストなオブジェクト。
  int objColor;
  Scene1()
  {
    objColor = color(random(100, 200), random(100, 200), random(100, 200)   );
  }
  Scene sceneWork() {
    draw_contents();

    if (mousePressed) {
      return new PageFlipEffect(new Scene1(), 100, width/3, height/3, width/2, height/2);//ページ捲りシーンを挿んで、次のシーン1へ遷移する。
    } 
    else {
      return this;
    }
  }

  void draw_contents()
  {
    camera();
    lights();
    background(0, 0, 0);
    noStroke();
    fill(objColor);
    pushMatrix();
    translate(width/2, height/2, -width/2);
    box(250);
    popMatrix();
    noLights();
  }
}

/*利用例その2*/
class Scene2 extends Scene1//super_class only need "implements scene"
{
  Scene2()
  {
    objColor = color(255, 0, 0);
  }
}

