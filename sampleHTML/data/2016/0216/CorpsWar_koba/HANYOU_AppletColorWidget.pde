/*
　このタブを追加することで、SUPERCLASS_APPLET_SecondBacisApplet.pdeを利用して、
　カラーを動的・視覚的に変更するウィジェット管理を追加する。
　ただしこのon/offは、エラーの原因となるColorWidget変数や、それを弄る関数など多い。主にHanyouBufferを書き換えるとこが多い。基本的には、置いておく。
　尚、これをoffにしている時、ColorObjectはただのrgb構造体として機能する(はず)
*/
/*
　This program is
　このプログラムは、カラーを動的に選ぶためのGUIとそのオブジェクトColorObject。
　動作させてみればわかると思うが、HanyouAppletやcreateApp()など、別ウインドウで開く機能を利用している。
　このウィジェットは常駐させるつもりなので、メインのsetupやdrawのように自動で動くinit()メソッドの方で初期設定を済ませ、colorwidgetグローバル変数で管理している。
　利用時はこの辺りを意識せずに、HanyouBufferクラス内のcolorcontrolメソッドとColorObjectだけ気にすれば、いけたはず。
*/

class ColorWidget extends HanyouApplet
{
  /* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/57594*@* */
  /* !do not delete the line above, required for linking your tweak if you upload again */
  int 
    ColorPickerX,
    ColorPickerY,
    LineY, //hue line vertical position
    CrossX, //saturation+brightness cross horizontal position
    CrossY; //saturation+brightness cross horizontal position
  boolean
    isDraggingCross = false,
    isDraggingLine = false;
  String
    targetname="none";
  color
    activeColor=color(123,123,123,123),
    interfaceColor = color(255); //change as you want               <------------------------------------------- CHANGE
  ColorObject
    co;
  
  void setColorObject(String name,ColorObject co)
  {  
    targetname=name;  this.co=co;
    CrossX=ColorPickerX+int(saturation(co.getColor() ));/////
    CrossY =255-(      ColorPickerY + int(brightness(co.getColor() ))     );//
    LineY = ColorPickerY + int(hue(co.getColor() ));
  }
  void setVisible(boolean isWork){ Point mouse = MouseInfo.getPointerInfo().getLocation(); frame.setLocation(mouse.x+10, mouse.y+10);   super.setVisible (isWork); }
  
  ColorWidget(ColorObject co)
  {
    super(1.0);
    this.co = co;
  }
  
  void setup()
  {
    size(325 , 255);
    smooth();
    
    colorMode(HSB);
    ColorPickerX=constrain(0,0,283); //set color picker x position to color selector + 40 and avoid it to be out of screen 
    ColorPickerY=constrain(0,0,260); //set color picker y position to color selector + 40 and avoid it to be out of screen 
    LineY=ColorPickerY+int(hue(activeColor)); //set initial Line position
    CrossX=ColorPickerX+int(saturation(activeColor)); //set initial Line position
    CrossY=ColorPickerY+int(brightness(activeColor)); //set initial Line position  
  }
  void draw()
  { 
    background(0);
    drawColorPicker();
    drawCross();
    drawActiveColor();
    drawValues();
    checkMouse();
    drawTitle();
    
    activeColor=color(LineY-ColorPickerY , CrossX-ColorPickerX , 255-(CrossY-ColorPickerY) );
    co.setColor(activeColor);
    
    super.draw();
  }
  
  void drawColorSelector() 
  {
    stroke(interfaceColor);
    strokeWeight(1);
    fill(0);
    rect(0,0,20,20);
    
    stroke(0);
    
    if(mouseX>0&&mouseX<20&&mouseY>0&&mouseY<20)
     fill(hue(activeColor),saturation(activeColor),brightness(activeColor)+30);
    else
     fill(activeColor);
      
    rect(1,1,18,18); //draw the color selector fill 1px inside the border
  }
  void drawValues() 
  {
    fill(255);
    fill(0);
    textSize(10);
    
    text( "H: "+int(  (LineY-ColorPickerY )*1.417647)+"°",                      ColorPickerX+285 , ColorPickerY+100);
    text( "S: "+int(   (CrossX-ColorPickerX )*0.39215+0.5)+"%",             ColorPickerX+286 , ColorPickerY+115);
    text( "B: "+int(100-(   (CrossY-ColorPickerY )*0.39215)   ) + "%" ,     ColorPickerX+285 , ColorPickerY+130);
    
    text( "R: "+int(red(activeColor)),      ColorPickerX+285 , ColorPickerY+155);
    text( "G: "+int(green(activeColor)),   ColorPickerX+285 , ColorPickerY+170);
    text( "B: "+int(blue(activeColor)),     ColorPickerX+285 , ColorPickerY+185);
    
    text(hex(activeColor,6),ColorPickerX+285,ColorPickerY+210);
  }
  
  void drawCross() 
  {
    if(brightness(activeColor)<90)
      stroke(255);
    else
      stroke(0);
      
    line(CrossX-5,CrossY,CrossX+5 ,CrossY);
    line(CrossX,CrossY-5,CrossX,CrossY+5);
  }
  void drawColorPicker() 
  { 
    stroke(interfaceColor);
    //line(10,10,ColorPickerX-3,ColorPickerY-3);//仮に、カラーウィジェットをどこかのオブジェから伸ばすなら、この線つけてColorPickerX,Yの位置その分ずらして
     
    //strokeWeight(1); //where parts?
    //fill(0);
    //rect(ColorPickerX-3 ,ColorPickerY-3 ,283,260);
    
    loadPixels();
    
    for(int j=0 ; j<255 ; j++) //draw a row of pixel with the same brightness but progressive saturation
    {    
      for(int i=0 ; i<255 ; i++) set(ColorPickerX+j,ColorPickerY+i,color(LineY-ColorPickerY,j,255-i) );
    }  
    for(int j=0; j<255; j++)
    {
      for(int i=0 ; i<20 ; i++)    set(ColorPickerX+258+i,ColorPickerY+j ,color( j,255,255) );
    }
    fill(interfaceColor);
    noStroke();
    rect(ColorPickerX+280,ColorPickerY-3,45,261); 
  }
  void drawActiveColor() 
  {
    fill(activeColor);
    stroke(0);
    strokeWeight(1);
    rect(ColorPickerX+282,ColorPickerY-1,41,80);
  }
  void checkMouse() 
  {
    if(mousePressed)  
    {
      if(mouseX>ColorPickerX+258&&mouseX<ColorPickerX+277&&mouseY>ColorPickerY-1&&mouseY<ColorPickerY+255&&!isDraggingCross) 
      {
        LineY=mouseY;
        isDraggingLine=true;
      }
      if(mouseX>ColorPickerX-1&&mouseX<ColorPickerX+255&&mouseY>ColorPickerY-1&&mouseY<ColorPickerY+255&&!isDraggingLine)
      {
        CrossX=mouseX;
        CrossY=mouseY;
        isDraggingCross=true;
      }    
    }
    else
    {
      isDraggingCross=false;
      isDraggingLine=false;
    }
  }
  
  void drawTitle()
  {
    fill(0);
    textSize(32);
    text(targetname,10,30);
    //textSize(16);
    //text("   activeColor("+red(activeColor)+","+green(activeColor)+","+blue(activeColor)+")",10,50);
    //text("   co             ("+red(co.getColor())+","+green(co.getColor())+","+blue(co.getColor() )+")",10,70);
    
  }
  
}
