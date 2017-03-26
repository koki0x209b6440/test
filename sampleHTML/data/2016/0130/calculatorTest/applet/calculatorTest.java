import processing.core.*; 
import processing.xml.*; 

import processing.serial.*; 
import java.io.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class calculatorTest extends PApplet {



/* 0806
  sample[http://www.openprocessing.org/sketch/121214]
            [http://www.is.akita-u.ac.jp/~sig/lecture/java/parser.html]
            [http://www.openprocessing.org/sketch/60582]
\u3000\u96fb\u5353\u3002\u5f0f\u304c\u6b8b\u308b\u3002\u95a2\u6570\u96fb\u5353\u7684\u306b\u62ec\u5f27\u3068\u304b\u4f7f\u3048\u308b\u3002
\u3000\u4ed8\u3051\u305f\u3044\u6a5f\u80fd\u306f\u4e8c\u3064\u3002\u7c21\u5358\u306b\u306fcalculator\u7121\u9650\u306e\u3088\u3046\u306b\u3002
\u30001.\u5206\u6570\u306f\u3061\u3083\u3093\u3068\u4e0a\u4e0b\u306b\u5206\u3051\u3066\u8868\u793a
\u30002.\u5f0f\u306e\u9014\u4e2d\u90e8\u5206\u3092\u6539\u5909\u3057\u3066\u518d\u8a08\u7b97\u3055\u305b\u308b  <-clear!
*/


ADText textLines;

ArrayList<CalcButton> Buttons = new ArrayList<CalcButton>();
CalcButton[] spButtons = new CalcButton[3];
 
String answerValue="=";//displayValue="0";
//import-value =textLine.getElement(0).getText();

public void setup() {
  size(340,400);
  frameRate(10);
  
  textLines = new ADText();
  textLines.add(17.0f, 15.0f, 310.0f, "calculator", "importValueLine");
  textLines.setActive(0);
  textLines.getElement(0).setBackgroundBox(0xffc8c896);
  textLines.getElement(0).setFocusOn();
  
  //\u96fb\u5353\u30dc\u30bf\u30f3\u751f\u6210\u3068\u305d\u306e\u63cf\u753b(+\u96fb\u5353\u80cc\u666f)
  int n=0;
  Buttons.add(new CalcButton(10, 345,100,45,177).setContent(""+(n++) )   );
  Buttons.add(new CalcButton(10, 290,45,45,177).setContent(""+(n++) )    );
  Buttons.add(new CalcButton(65, 290,45,45,177).setContent(""+(n++) )    );
  Buttons.add(new CalcButton(120, 290,45,45,177).setContent(""+(n++) )   );
  Buttons.add(new CalcButton(10, 235,45,45,177).setContent(""+(n++) )    );
  Buttons.add(new CalcButton(65, 235,45,45,177).setContent(""+(n++) )    );
  Buttons.add(new CalcButton(120, 235,45,45,177).setContent(""+(n++) )   );
  Buttons.add(new CalcButton(10, 180,45,45,177).setContent(""+(n++) )    );
  Buttons.add(new CalcButton(65, 180,45,45,177).setContent(""+(n++) )    );
  Buttons.add(new CalcButton(120, 180,45,45,177).setContent(""+(n++) )   );
  Buttons.add(new CalcButton(175,290,45,45,133).setContent("+")          );
  Buttons.add(new CalcButton(175,235,45,45,133).setContent("-")          );
  Buttons.add(new CalcButton(175,180,45,45,133).setContent("*")          );
  Buttons.add(new CalcButton(175,125,45,45,133).setContent("/")           );
  Buttons.add(new CalcButton(120,125,45,45,133).setContent("%")           );
  Buttons.add(new CalcButton(230,180,45,45,133).setContent("(")        );
  Buttons.add(new CalcButton(230,235,45,45,133).setContent(")")         );
  Buttons.add(new CalcButton(120, 345,45,45,133).setContent(".")         );
  
  spButtons[0] = new CalcButton(10,125,45,45,0xffd19955).setContent("C");
  spButtons[1] = new CalcButton(285,125,45,45,133).setContent("Pow");
  spButtons[2] = new CalcButton(175,345,100,45,133).setContent("=");
  
  background(50,55,55);
  for (int i=0; i<Buttons.size(); i++)   Buttons.get(i).display();
  for (int i=0; i<spButtons.length; i++) spButtons[i].display();
}

public void draw() {
  //\u96fb\u5353\u306e\u4e0a\u90e8(\u6570\u5b57\u304c\u51fa\u308b\u6db2\u6676\u90e8\u5206)
  fill(200,200,150);
  rect(10,10,320,105);
  fill(0);
  //line(15,45,320,45);//\u5206\u6570\u8868\u793a\u6642\u306e\u6a2a\u68d2\u306e\u4f4d\u7f6e\u53c2\u8003
  textSize(25);
  text(answerValue,20,107);
  
  textLines.update();
}

public void keyPressed()
{
if(key=='1' || key=='2' || key=='3' || key=='4' || key=='5'                                       ||
   key=='6' || key=='7' || key=='8' || key=='9'                                                        ||
   key=='+' || key=='-' || key=='*' || key=='/' || key=='%' || key=='(' || key==')'      ||
   key==CODED&&keyCode==LEFT   ||   key==CODED&&keyCode==RIGHT              ||
   key==BACKSPACE || key==DELETE                                                                       )
  {
    textLines.checkKeyPressed();
  }
  
  if(keyCode==ENTER) answerValue=getCal(textLines.getElement(0).getText() );
  if(keyCode==CONTROL)
  {
    textLines.getElement(0).setText("");
    answerValue="=";
  }
}

public void keyReleased()
{
  textLines.checkKeyReleased();
}


public void mousePressed() {
  
  for(int i=0; i<Buttons.size(); i++)
  {
    if(Buttons.get(i).clickButton() ) textLines.getElement(0).setText(textLines.getElement(0).getText()+Buttons.get(i).content);
  }
  
  for (int i=0; i<spButtons.length; i++)
  {
    if(spButtons[i].clickButton() )
    {
      if(spButtons[i].content.equals("C") )
      {
        textLines.getElement(0).setText("");
        answerValue="=";
      }
      if(spButtons[i].content.equals("=") ) answerValue=getCal(textLines.getElement(0).getText() );
    }
  }
}



public String getCal(String calstr)
{
   try
   {
     double answer=calculate(calstr);
     calstr="=  "+answer;
   }catch (Exception e)
   {
     calstr="=  Error";
   }
   return calstr;
}

public static double calculate(String calstr) throws Exception
{
  
  StringReader r = new StringReader(calstr);
  StreamTokenizer st = new StreamTokenizer(r);
  SimpleCalculator calculator = new SimpleCalculator(st);
  return calculator.expression();
  
}
class CalcButton {
  String content;
  float xpos,ypos;
  int boxSize = 45;
  int buttonW,buttonH;
  int buttonC;
 
  CalcButton(float tempXpos, float tempYpos, int tempButtonW, int tempButtonH, int tempButtonC) {
    xpos = tempXpos;
    ypos = tempYpos;
    buttonW = tempButtonW;
    buttonH = tempButtonH;
    buttonC = tempButtonC;
  }
  public CalcButton setContent(String content) {
    this.content=content;
    return this;
  }
  public boolean clickButton() {
    boolean flag = mouseX > xpos && mouseX < xpos+buttonW && mouseY > ypos && mouseY < ypos+buttonH;
    return flag;
  }
  
  
  public void display() {
    if (content.equals("+/-") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(18);
      text(content, xpos+8, ypos+30);
    } else if (content.equals("%") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(24);
      text(content, xpos+12, ypos+30);
    } else if (content.equals("Sqrt") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(17);
      text(content, xpos+6, ypos+35);
    } else if (content.equals("Sin") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(19);
      text(content, xpos+8, ypos+30);
    } else if (content.equals("Cos") )
    {
      fill(133);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(19);
      text(content, xpos+7, ypos+30);
    } else if (content.equals("-") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(24);
      text(content, xpos+18, ypos+30);
    } else if (content.equals("Sq") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(19);
      text(content, xpos+12, ypos+30);
    } else if (content.equals("C") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(24);
      text(content, xpos+11, ypos+30);
    } else if (content.equals("Pow") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(18);
      text(content, xpos+5, ypos+30);
    } else if(content.equals(".") )
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(0);
      textSize(24);
      text(content, xpos+15, ypos+30);
    }
    else
    {
      fill(buttonC);
      stroke(0);
      strokeWeight(2);
      rect(xpos, ypos, buttonW, buttonH);
      fill(122,44,22);
      textSize(24);
      text(content, xpos+15, ypos+30);
    }
  }
  
}

class ADText
{
  
//////////////////////////////////////////////////////////////////////////////
// BEGIN OF INNER CLASSES
/////////////////////////////////////////////////////////////////////////////
/*
 * ----------------------------------
 *  getText Class for Processing 2.0
 * ----------------------------------
 *
 * this is a simple text catching class. The following shows 
 * you how to use it in a minimalistic way.
 *
 * DEPENDENCIES:
 *   keys Class
 *   timer Class
 *
 * Created:  May, 6 2012
 * Author:   Alejandro Dirgan
 * Version:  0.1
 *  Creation
 * Version:  0.11
 * May 7, 2012
 *  checkCursorPos() method added to determine where the mouse is when it is pressed and translate to cursor coordinates
 *  keyboard recognition added to END,HOME keys.  
 *  focus control added using ENTER key over the field box 
 *  setMaxCharacter() method added. This limits the max number of characters allowed in the string
 *  Add setTextSize() method added to change the font size
 * Version: 0.15  
 * May 10, 2012
 *  setText(String text) method added - Sets the text on the field
 *  setAllowedText(String alllowedText) method added - Defines the characters that are allowed to be typed. By default all characters can be typed
 *  setExceptions(String Exceptions) method added - Defines the characters that are not allowed to be typed. By default there are no exceptions
 *  setDebugOn() method added
 *  setDebugOff() method added
 *  the capacity to change the position of the widget, using CTRL-LEFT-MOUSE, was added
 *  printGeometry() method was added
 *  capacity to print the widget geometry, using SHIFT-LEFT-MOUSE was added
 * Version: 0.16  
 * May 11, 2012
 *  Masking added for passwords (by default is off)
 *  setMaskOn() method added - set the attribute masking on
 *  setMaskOff() method added - set the attribute masking off
 *  isEmpty() method added - Returns true if the field is empty
 * Version: 0.17  
 * May 12, 2012
 *  disableField() method added - disables the posibility to type text on field
 *  enableField() method added - enables the posibility to type text on field
 *  erase Field method added - erases the field's content
 *  Capacity to erase the field's content wutin CTRL-RIGHT-MOUSE added
 *  change has been made with checkKeyboardInput() returns. Now is boolean, so we can detect if ENTER is pressed when this method returns true * Version: 0.17  
 * Version:0.171
 * May 14, 2012
 *  Capacity to use CONTROL+LEFT && CONTROL+RIGHT added. See section keyReleased() on the example
 *  Capacity to erase the entire field using CONTROL+DELETE was added
 *  setArrayOn() method added - enables the posibility to have the text object on a array
 *  setArrayOff() method added
 *  setFocusOn() method added - Select the text field
 *  setFocudOff() method added - deSelect the text field
 *  setText(String text) method added - Sets the text on the field
 * Version:1.0
 * May 15, 2012
 *  Wrapper for handeling several text lines and simplify adminitration was added (ADText). This way we can change from focus from field to field using arrow keys or enter or tab.
 
 * License:  GPLv3
 *   (http://www.fsf.org/licensing/)
 *
 * Follow Us
 *    adirgan.blogspot.com
 *    twitter: @ydirgan
 *    https://www.facebook.com/groups/mmiiccrrooss/
 *    https://plus.google.com/b/111940495387297822358/
 *
 * DISCLAIMER **
 * THIS SOFTWARE IS PROVIDED TO YOU "AS IS," AND WE MAKE NO EXPRESS OR IMPLIED WARRANTIES WHATSOEVER 
 * WITH RESPECT TO ITS FUNCTIONALITY, OPERABILITY, OR USE, INCLUDING, WITHOUT LIMITATION, ANY IMPLIED 
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR INFRINGEMENT. WE EXPRESSLY 
 * DISCLAIM ANY LIABILITY WHATSOEVER FOR ANY DIRECT, INDIRECT, CONSEQUENTIAL, INCIDENTAL OR SPECIAL 
 * DAMAGES, INCLUDING, WITHOUT LIMITATION, LOST REVENUES, LOST PROFITS, LOSSES RESULTING FROM BUSINESS 
 * INTERRUPTION OR LOSS OF DATA, REGARDLESS OF THE FORM OF ACTION OR LEGAL THEORY UNDER WHICH THE LIABILITY 
 * MAY BE ASSERTED, EVEN IF ADVISED OF THE POSSIBILITY OR LIKELIHOOD OF SUCH DAMAGES.

//////////////////////////////////////
ADGetText public methods
//////////////////////////////////////
  Constructor:
  ADGettext(int x, int y, int width, String hint)
    int x,y - coordinates of the upper left corner of the slider on the screen
    int width - width in pixels of the field
    String hint - Help or tile of the field

  ADGettext(int x, int y, int width)
    int x,y - coordinates of the upper left corner of the slider on the screen
    int width - width in pixels of the field

  Public Methods:
     
  public void setBorderWidth(int w) - Sets the border width og the field in pixels
  public void setBackgroundBox(color c) - Sets the color of the field
  public void setBoxBorderColor(color c) - Sets the color of the border of the field
  public void setTextHint(String th) - Sets the text that will appear as a label or help of the field
  public void setTextSize(int size) - Sets the text size
  public int checkKeyboardInput() - Used in the main program ... see the example. This methods gets the input each time a key is released and returns 1000 if ENTER key is pressed or 1001 if TAB key is Pressed. Useful for execute something after enter/tab is pressed.
  public String update() - Used in main program to update the field box and to get the string
  public String getText() - Returns the String updated on the field
  public int textLength() -retuns the length of the string
  public void setMaxCharacters(int v) - Sets the maximun number of characters allowed (1-80)
  public void setText(String text) - Sets the text on the field
  public void setAllowedText(String alllowedText) - Defines the characters that are allowed to be typed. By default all characters can be typed
  public void setExceptions(String Exceptions) - Defines the characters that are not allowed to be typed. By default there are no exceptions
  public void setDebugOn() - enable the flag debug
  public void setDebugOff() - disable the flag debug
  public void printGeometry() - prints out the contructor with the current values
  public void setMaskOn() - sets the attribute masking on
  public void setMaskOff() - sets the attribute masking off
  public void isEmpty() - Returns true if the field is empty
  public void disableField() - disables the posibility to type text on field
  public void enableField() - enables the posibility to type text on field
  public void setArrayOn() - enables the field to be on a array list
  public void setArrayOff() - disables the field to be on a array list
  public void setFocusOn() - when it is enable to be on a array selects the field, so it can be editted.
  public void setFocusOff() - when it is enable to be on a array deselects the field, so it cannot be editted.
  
  Help:
  To type text in the field, just put the mouse over the field and press LEFT+MOUSE, then type what you need.

///////////////////////////////////////
EXAMPLE
///////////////////////////////////////

ADGettext line1, line2, line3, line4, line5;

void setup()
{
  size(500,300);
  smooth();
  
  line1 = new ADGettext(50,30,400,"First Name","fname");
  line1.setBackgroundBox(#F0D29B);
  line2 = new ADGettext(50,80,400,"Last Name", "lname");
  line2.setBackgroundBox(#F0D29B);
  line3 = new ADGettext(50,130,400,"City", "city");
  line3.setBackgroundBox(#F0E39B);
  line4 = new ADGettext(50,180,400,"State", "state");
  line4.setBackgroundBox(#F0E39B);
  line5 = new ADGettext(50,230,400,"Country", "country");
  line5.setBackgroundBox(#F0E39B);
}


void draw()
{
  background(255);
  line1.update();
  line2.update();
  line3.update();
  line4.update();
  line5.update();
}

void keyPressed()
{
   line1.checkKeyboardInput();
   line2.checkKeyboardInput();
   line3.checkKeyboardInput();
   line4.checkKeyboardInput();
   line5.checkKeyboardInput();
}

// This is optional - start
// You can avoid this section
void keyReleased()
{
  line1.checkAdditionalKeys();
  line2.checkAdditionalKeys();
  line3.checkAdditionalKeys();
  line4.checkAdditionalKeys();
  line5.checkAdditionalKeys();
  
}
// This is optional - end
*/

class ADGettext
{     
  PFont gText;
  int textPoints=24;
  int textColor=0xff717171;
  
  int boxOffset=4;
  
  int colorFillBox=0xffEBEDEC;
  int colorBorderBox=0;
  int originalColorBorderBox=0;
  int colorSelectedBorderBox=0xff000000;//#FF7308
  float borderWidth=1;
  float originalBorderWidth=borderWidth;
  int cursorColor=0;
  
  String gtextString="", tempL="", tempR="", showString="";
  int sI=0, sF=0;
  
  String textHint="Type something...";
  int textHintColor=0xffF7F7F7;
  boolean textHintVisible=true;
  
  float textX, textY, textW, textH;
  
  int cursorPos=0; 
  timer cursorBlink;
  boolean cursorVisible=true;
    
  boolean isMouseOver=false;
  boolean focus=false;
  boolean selected=false;
  boolean setArrayOn=false;
  
  int maxCharacters=50;
  
  int keyControl=0;
  
  String ID;
  
  boolean debug=true; 
  boolean pressOnlyOnce=true;
  int deb=0;
  
  String textExceptions="";
  String textAllowed="";
  boolean allTextAllowed=true;
  
  boolean masked=false;
  
  boolean enabled=true;
  
  keys specialKey; 
  boolean analyzeKeys=true;
 
  
  
  ///////////////////////////////////////////////////////
  ADGettext(float x, float y, float w, String i)
  {
    textX=x;
    textY=y;
    textW=w;
    textH=textPoints+textPoints*.28f;
    
    specialKey = new keys();
    
    ID=i;
    
    gText = createFont("Courier",textPoints,true);      
      
    cursorBlink = new timer(600);
    setCursorPos(0);
    
    
    
    
  }
  ///////////////////////////////////////////////////////
  ADGettext(float x, float y, float w, String tHint, String i)
  {
    textX=x;
    textY=y;
    textW=w;
    textH=textPoints+textPoints*.28f;
    ID=i;
    specialKey = new keys();
    
    gText = createFont("Arial",textPoints,true);      
    textFont(gText,textPoints);   
    cursorBlink = new timer(600);
    
    setTextHint(tHint);
  }
  
  ///////////////////////////////////////////////////////  
  public String getID()
  {
    return ID;
  }
  ///////////////////////////////////////////////////////  
  public void enableField()
  {
    enabled=true;
  }
  ///////////////////////////////////////////////////////  
  public void disableField()
  {
    enabled=false;
  }
  ///////////////////////////////////////////////////////  
  public void setDebugOn()
  {
    debug=true;
  }
  ///////////////////////////////////////////////////////  
  public void setDebugOff()
  {
    debug=false;
  }

  ///////////////////////////////////////////////////////  
  public void setMaskOn()
  {
    masked=true;
  }
  ///////////////////////////////////////////////////////  
  public void setMaskOff()
  {
    masked=false;
  }

  ///////////////////////////////////////////////////////  
  public boolean isEmpty()
  {
    if (stringLength()==0)
      return true;
    else
      return false;  
  }

  ///////////////////////////////////////////////////
  public void setTextSize(int s)
  {
    if (s<8) s=8;
    if (s>80) s=80;
    
    textPoints=s;
    textH=textPoints+textPoints*.28f;
  }
  ///////////////////////////////////////////////////
  public void setMaxCharacters(int v)
  {
    if (v<0 || v>80) return;
    
    maxCharacters=v;
  }
  ///////////////////////////////////////////////////
  private String getText()
  {
    return gtextString;
  }
  ///////////////////////////////////////////////////
  private int textLength()
  {
    return gtextString.length();
  }
  ///////////////////////////////////////////////////
  private String trimText(String s)
  {
    String result=s;
    
    if (textWidth(s)>(textW-textWidth("_")/2))
    {
      String temp="";
    
      for (int i=0; i<s.length(); i++)
      {
        if (textWidth(temp)<(textW-textWidth("_")/2))
          temp+=s.charAt(i);
        else
          i=s.length();  
      }
      result=temp;
    }
    
    if (s.length() > maxCharacters)
    {
      result=s.substring(0,maxCharacters);
    }
    
    return result;
  }
  ///////////////////////////////////////////////////
  private void drawBox()
  {
    fill(colorFillBox);
    stroke(colorBorderBox);
    strokeWeight(borderWidth);
    rect(textX-boxOffset,textY,textW+boxOffset,textH);
  }
  ///////////////////////////////////////////////////
  public void setBorderWidth(int w)
  {
    if (w<0) return;
    if (w>20) return;
    
    borderWidth=w;
    originalBorderWidth=w;
  }  
  ///////////////////////////////////////////////////
  public void setBackgroundBox(int c)
  {
    colorFillBox=c;
    colorSelectedBorderBox=c;/////
  }  
  ///////////////////////////////////////////////////
  public void setBoxBorderColor(int c)
  {
    colorBorderBox=c;
  }  
  
  ///////////////////////////////////////////////////
  private String fillString(char c, int n)
  {
    String result="";
    
    for (int i=0; i<n; i++)
       result+=c;
       
    return result;   
  }
  ///////////////////////////////////////////////////
  private String setShowString()
  {
    String result="";
    
    if (masked)
       showString=fillString('*',gtextString.length());
    else   
      showString=gtextString;
    //showString=gtextString.substring(sI,sF);
    
    
    if (gtextString.length()==0 && textHintVisible)
      result=textHint;
    else
      result=showString;
    
    return result; 
  }
  
  ///////////////////////////////////////////////////
  private void drawText()
  {

    textFont(gText,textPoints); 

    if (gtextString.length()==0 && textHintVisible)
      fill(textHintColor);
    else
      fill(textColor);  

    textAlign(LEFT);
    text(setShowString(),textX,textY+textPoints);
    
  }
  ///////////////////////////////////////////////////
  private int stringLength()
  {
    return gtextString.length();
  }
  ///////////////////////////////////////////////////
  private char stringcharAt(int i)
  {
    if (i>stringLength()-1) i=stringLength()-1;
    if (i<0) i=0;
    
    return showString.charAt(i);
  }
  ///////////////////////////////////////////////////
  public void setTextHint(String th)
  {
    textHint=trimText(th);
    textHintVisible=true;
    
  }  
  ///////////////////////////////////////////////////
  public void setText(String t)
  {
    gtextString=trimText(t);
    showString=gtextString;
  }  
  ///////////////////////////////////////////////////
  private int getCursorX()
  {
    int result=0;
    int curPosAnt=cursorPos;

    for (int i=0; i<cursorPos; i++)
    {
      if (cursorPos>=stringLength()+1)
        result+=textWidth("_");
      else
      {
        result+=textWidth(stringcharAt(i));
      }
    }
    return result;
  }
  ///////////////////////////////////////////////////
  private void setCursorPos(int pos)
  {
    if (pos<0) pos=0;
    if (pos>stringLength()) pos=stringLength();
    
    cursorBlink.reset();
    cursorVisible=true;
    cursorPos=pos;
  }
  ///////////////////////////////////////////////////
  private void drawCursor()
  {
    if (!selected) return;
    
    if (cursorBlink.over())
    {
       cursorVisible=!cursorVisible;
       cursorBlink.reset();
    } 
    
    stroke(cursorColor);
    if (cursorVisible)
      line(textX+getCursorX(),textY+textPoints/4,textX+getCursorX(),textY+textH-textPoints/4);
  }
  
  ///////////////////////////////////////////////////
  public boolean getFocus()
  {
    return focus;
  }  
  ///////////////////////////////////////////////////
  public void setFocusOn()
  {
    setCursorPos(cursorPos);
    focus=true;
  }  
  ///////////////////////////////////////////////////
  public void setFocusOff()
  {
    focus=false;
  }  
  ///////////////////////////////////////////////////
  public void setArrayOn()
  {
    setArrayOn=true;
  }  
  ///////////////////////////////////////////////////
  public void setArrayOff()
  {
    setArrayOn=false;
  }  

  ///////////////////////////////////////////////////
  private void checkFocus()
  { 

    if (setArrayOn) //if it belongs to a array of objetcs
    {
      if (focus && enabled) // if it has the focus activated it 
        selected=true;
      else
        selected=false;
      

      if (mouseOver() && mousePressed && mouseButton==LEFT && enabled)
      {
        focus=true;
        selected=true;
      }

    }
    else // if the object is alone
    {
      if (mouseOver()) //only activated it if mouse is over and press mouse-left
      {
        if (mousePressed && mouseButton==LEFT && enabled)
        {
          focus=true;
          selected=true;
        }
      }
      else //if mouse is not over deselect the field
        selected=false;
    }
  
    if (selected)  
    {
      colorBorderBox=colorSelectedBorderBox;
      borderWidth=originalBorderWidth*2;
    }
    else
    {
      colorBorderBox=originalColorBorderBox;
      borderWidth=originalBorderWidth;
    }
    
  }

  ///////////////////////////////////////////////////
  private boolean mouseOver()
  {
    boolean result=false;
    
    if (mouseX>=textX-boxOffset && mouseX<=textX+textW+boxOffset && mouseY>=textY && mouseY<=textY+textH)
      result=true;
      
    isMouseOver=result;
    return result;
    
  }
  
  ///////////////////////////////////////////////////
  private void deleteCharInTheMiddle(boolean back)
  {
    if (back)
    {
      tempL=gtextString.substring(0,cursorPos-1);
      tempR=gtextString.substring(cursorPos,stringLength());
    }  
    else
    {
      tempL=gtextString.substring(0,cursorPos);
      tempR=gtextString.substring(cursorPos+1,stringLength());

    }
    gtextString=tempL+tempR;
    sF--;
    if (sI>0) sI--;
   

  }
  ///////////////////////////////////////////////////
  private void deleteCharFromEnd()
  {
    tempL=gtextString.substring(0,stringLength()-1);
    gtextString=tempL;

    sF--;
    if (sI>0) sI--;
    
  }


  ///////////////////////////////////////////////////
  public void setAllowedText(String a)
  {
    allTextAllowed=false;
    textAllowed=a;
  }

  ///////////////////////////////////////////////////
  private boolean complyAllowed(String a)
  {
    if (allTextAllowed) return true;
    
    boolean result=false;
    
    if (textAllowed.toLowerCase().contains(a.toLowerCase()))
      result=true;
      
    return result;   
  }

  ///////////////////////////////////////////////////
  public void setExceptions(String e)
  {
    textExceptions=e;
  }

  ///////////////////////////////////////////////////
  private boolean complyException(String e)
  {
    boolean result=false;
    
    if (textExceptions.toLowerCase().contains(e.toLowerCase()))
      result=true;

    return result;   
  }
  ///////////////////////////////////////////////////
  public void eraseField()
  {
    gtextString="";
    sI=0; sF=0;
    setCursorPos(0);
    
  }  
  ///////////////////////////////////////////////////
  private void insertChar(char c)
  {
    
    if (!enabled) return;
    if (c==CODED) return;
    
    textFont(gText,textPoints); 
    if ((textWidth(gtextString)>textW-textWidth(c)-textWidth("_")/2) || stringLength()>=maxCharacters) return;

    if (complyException(Character.toString(c))) return;    
    
    if (!complyAllowed(Character.toString(c))) return;
    
    if (cursorPos==0)
    {
      gtextString=Character.toString(c)+gtextString;
      sF++;
      setCursorPos(cursorPos+1);
    }
    else
      if (cursorPos<gtextString.length())
      {
        tempL= gtextString.substring(0,cursorPos);
        tempR=gtextString.substring(cursorPos,stringLength());
        gtextString=tempL+Character.toString(c)+tempR;
        sF++;
        setCursorPos(cursorPos+1);
      }
      else
        if (cursorPos>=gtextString.length())
        {
         tempL=gtextString.substring(0,stringLength());
         gtextString=tempL+Character.toString(c);
         sF++;
         setCursorPos(cursorPos+1);;
        }

     if (textWidth(gtextString)>textW-boxOffset-10) sI++;
    
  }
  ///////////////////////////////////////////////////
  private void delChar()
  {
    if (cursorPos>=0)
    {
      if (cursorPos<stringLength())
      {
        deleteCharInTheMiddle(false);
      }
    }
  }
  ///////////////////////////////////////////////////
  private void backChar()
  {
    if (cursorPos>0)
    {
      if (cursorPos>=stringLength())
      {
        setCursorPos(cursorPos-1);
        deleteCharFromEnd();
        
      }
      if (cursorPos<stringLength())
      {
        deleteCharInTheMiddle(true);
        setCursorPos(cursorPos-1);
      }
    }
  }
  
  ///////////////////////////////////////////////////
  private void checkArrows()
  {
    if (keyCode==LEFT)
    {
      setCursorPos(cursorPos-1);
    }

    if (keyCode==RIGHT)
      setCursorPos(cursorPos+1);
   

  }

  ///////////////////////////////////////////////////
  public void checkAdditionalKeys()
  {
    specialKey.releasedKey();
    analyzeKeys=true;
  }
  ///////////////////////////////////////////////////
  private void checkSpecialKeys()
  {
    
    if (specialKey.checkStrokes("CONTROL+LEFT"))
    {
      for (int i=cursorPos-1; i>=0; i--)
      {
        if (stringcharAt(i)==' ' || i==0)
        {
          setCursorPos(i);
          i=-1;
        }
      }

    } else if (specialKey.checkStrokes("CONTROL+RIGHT")) 
    {
      for (int i=cursorPos+1; i<=stringLength(); i++)
      {
        if (stringcharAt(i)==' ' || i==stringLength())
        {
          setCursorPos(i+1);
          i=stringLength()+1;
        }
      }
      

    } else if (specialKey.checkStrokes("CONTROL+DELETE")) 
    {
      eraseField(); 
    }
    else checkArrows();


  } 

  ///////////////////////////////////////////////////
  public int checkKeyboardInput()
  {
    if (!selected) return 0;
    
    int result=0;

    if (analyzeKeys)
    {
      analyzeKeys=false;
      specialKey.pressedKey();
      checkSpecialKeys();
    }
    else
      checkArrows();  
    
    
    
    if (keyPressed && (key==BACKSPACE || key==DELETE))
    {
      if (key==BACKSPACE)
      {
        backChar();
      }
      if (key==DELETE)
      {
        delChar();  
      }
    }
    else
    {
      if (keyPressed && key!=TAB && key!=ENTER && key!=ESC &&key!=RETURN) 
      {
        insertChar(key);
      }  

      if (keyPressed && keyCode==KeyEvent.VK_END) //END
        setCursorPos(stringLength());
      
      if (keyPressed && keyCode==KeyEvent.VK_HOME) //HOME
        setCursorPos(0);
        
      if (keyPressed &&  (keyCode==ENTER || keyCode==RETURN))
        result=1000; 
      if (keyPressed &&  (keyCode==TAB))
        result=1001;
      if (keyPressed &&  (keyCode==UP))
        result=1002;
      if (keyPressed &&  (keyCode==DOWN))
        result=1003;
  
    }

    return result;
  }
  ///////////////////////////////////////////////////
  private void checkCursorPosition()
  {
    int posX=0, pos=0, i;

    for (i=0; i<stringLength()-1; i++)
    {
      if (mouseX>posX+textX+textWidth(stringcharAt(i))/2)
        pos=i+1;

      posX+=textWidth(stringcharAt(i));
    }
    
    if (mouseX>=posX+textX) 
      pos=i+1;

    setCursorPos(pos);
  }

  ///////////////////////////////////////////////////////  
  private void deBounce(int n)
  {
    if (pressOnlyOnce) 
      return;
    else
      
    if (deb++ > n) 
    {
      deb=0;
      pressOnlyOnce=true;
    }
    
  }
  ///////////////////////////////////////////////////
  private void checkMouseInput()
  {
    if (mouseOver() && mousePressed && mouseButton==LEFT)
    {
      checkCursorPosition();
    }

    if (mouseOver() && mousePressed && mouseButton==RIGHT && keyPressed && keyCode==CONTROL)
    {
      eraseField();
    }
    
    if (debug)
      if (mouseOver())
      {
        if (mousePressed && mouseButton==LEFT && keyPressed)
        {
          if (keyCode==CONTROL)
          {
            textX=textX+(int )((float )(mouseX-pmouseX)*1);
            textY=textY+(int )((float )(mouseY-pmouseY)*1);
          }
          if (keyCode==SHIFT && pressOnlyOnce) 
          {
            printGeometry();
            pressOnlyOnce=false;
          }
          deBounce(5);
          
        }
      }    
  }
  ///////////////////////////////////////////////////////  
  public void printGeometry()
  {
    println("radio = new ADGettext("+textX+", "+textY+", "+textW+", \""+textHint+"\", \""+ID+"\");");

  }
  ///////////////////////////////////////////////////
  public String update()
  {
    drawBox();
    drawText();
    drawCursor();
    checkFocus();
    checkMouseInput();
    //checkKeyboardInput - this is done on the main program after a key is released
        
    return gtextString;
  }
  
///////////////////////////////////////////////////////////////////////  
private class timer
{
  float startTime;
  int tOver;
  
  timer(int millisecs)
  {
    startTime=millis();
    tOver=millisecs;
  }
  
  public boolean over()
  {
    if ((millis() - startTime)>tOver)
      return true;
    else
       return false;
  }
  
  public void reset()
  {
    startTime=millis();
  }
  
  public void setOver(int millisecs)
  {
    tOver=millisecs;
    reset();
  }
  
  
}

////////////////////////////////////////////////////////////////////
class keys
{
  boolean[] keyArray;
  int lastKey=0;
  
  String[] keyCombinations= {
    
    "CONTROL+LEFT","CONTROL+RIGHT","CONTROL+UP", "CONTROL+DOWN", 
    "ALT+LEFT", "ALT+RIGHT", "ALT+UP", "ALT+DOWN",
    "CONTROL+DELETE"
  
  };
  /////////////////////////////////////////////////////////////////////
  keys()
  {
    keyArray = new boolean[526];
  }
  /////////////////////////////////////////////////////////////////////
  public boolean checkKey(int k)
  {
    if (keyArray.length >= k) {
      return keyArray[k];  
    }
    return false;
  }
  /////////////////////////////////////////////////////////////////////
  public void releasedKey()
  {
    if (keyCode>526) return;
    keyArray[keyCode] = false;
  }  
  public void pressedKey()
  {
    if (keyCode>526) return;
    keyArray[keyCode] = true;
    lastKey=keyCode;
  }  
  /////////////////////////////////////////////////////////////////////
  public boolean checkStrokes(String keyComb)
  {
    boolean result=false;
    String kc="";

    
    if (checkKey(CONTROL) && (!checkKey(ALT) && !checkKey(SHIFT)) && checkKey(KeyEvent.VK_LEFT))
      kc=keyCombinations[0];
    if (checkKey(CONTROL) && (!checkKey(ALT) && !checkKey(SHIFT)) && checkKey(KeyEvent.VK_RIGHT))
      kc=keyCombinations[1];
    if (checkKey(CONTROL) && (!checkKey(ALT) && !checkKey(SHIFT)) && checkKey(KeyEvent.VK_UP))
      kc=keyCombinations[2];
    if (checkKey(CONTROL) && (!checkKey(ALT) && !checkKey(SHIFT)) && checkKey(KeyEvent.VK_DOWN))
      kc=keyCombinations[3];

    if (checkKey(ALT) && (!checkKey(CONTROL) && !checkKey(SHIFT)) && checkKey(KeyEvent.VK_LEFT))
      kc=keyCombinations[4];
    if (checkKey(ALT) && (!checkKey(CONTROL) && !checkKey(SHIFT)) && checkKey(KeyEvent.VK_RIGHT))
      kc=keyCombinations[5];
    if (checkKey(ALT) && (!checkKey(CONTROL) && !checkKey(SHIFT)) && checkKey(KeyEvent.VK_UP))
      kc=keyCombinations[6];
    if (checkKey(ALT) && (!checkKey(CONTROL) && !checkKey(SHIFT)) && checkKey(KeyEvent.VK_DOWN))
      kc=keyCombinations[7];
    
    if (checkKey(CONTROL) && (!checkKey(ALT) && !checkKey(SHIFT)) && checkKey(DELETE))
      kc=keyCombinations[8];

    
    if (kc == keyComb)
      result=true;
      
    return result;
  }
  
 }


  ////////////////////////////////////////////////////////////////////  
  // END INNER CLASSES
  ////////////////////////////////////////////////////////////////////  
  }


  
  ////////////////////////////////////////////////////////////////////  
  // START of MAIN CLASS
  ////////////////////////////////////////////////////////////////////  
/*
 * ----------------------------------
 *  ADText Class for Processing 2.0
 * ----------------------------------
 *
 * this is the wrapper to the getText class above. The following shows 
 * you how to use it in a minimalistic way.
 *
 * DEPENDENCIES:
 *   getText Class
 *
 * Created:  May, 15 2012
 * Author:   Alejandro Dirgan
 * Version:  0.1
 *  Creation
 
 * License:  GPLv3
 *   (http://www.fsf.org/licensing/)
 *
 * Follow Us
 *    adirgan.blogspot.com
 *    twitter: @ydirgan
 *    https://www.facebook.com/groups/mmiiccrrooss/
 *    https://plus.google.com/b/111940495387297822358/
 *
 * DISCLAIMER **
 * THIS SOFTWARE IS PROVIDED TO YOU "AS IS," AND WE MAKE NO EXPRESS OR IMPLIED WARRANTIES WHATSOEVER 
 * WITH RESPECT TO ITS FUNCTIONALITY, OPERABILITY, OR USE, INCLUDING, WITHOUT LIMITATION, ANY IMPLIED 
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR INFRINGEMENT. WE EXPRESSLY 
 * DISCLAIM ANY LIABILITY WHATSOEVER FOR ANY DIRECT, INDIRECT, CONSEQUENTIAL, INCIDENTAL OR SPECIAL 
 * DAMAGES, INCLUDING, WITHOUT LIMITATION, LOST REVENUES, LOST PROFITS, LOSSES RESULTING FROM BUSINESS 
 * INTERRUPTION OR LOSS OF DATA, REGARDLESS OF THE FORM OF ACTION OR LEGAL THEORY UNDER WHICH THE LIABILITY 
 * MAY BE ASSERTED, EVEN IF ADVISED OF THE POSSIBILITY OR LIKELIHOOD OF SUCH DAMAGES.

//////////////////////////////////////
ADText public methods
//////////////////////////////////////
  Constructor:
  ADText()
    just creates the object.
    
  Public Methods:
     
    public void add(float xPos, float yPos, float width, String hint, String id) - Add a Text Field to the group. 
    public int size() - returns the number of text fields declared on this class
    public  ADGettext getElement(int i) - returns the text field object, so we can change behavior and characteristics of every text field declared
    public void update() - used on the draw funtion on main. It refresh and draw the text field.
    public void setActive(int textFieldNumber) - change de focus to the fieldtext indicated in the paramater. Remember tar each fieldtext added is identified with a number, from o..n.
    public void checkKeyPressed() - This method has to be invoked on keyPressed() Function on main - see example. This has te responsability to get each keystroke.
    public void checkKeyReleased() - This method has to be invoked on keyRealeased() Function on main - see example. This has te responsability to do some administrative action afeter a key is released.
    public int getLastKey() - this function is used to know what was the last key pressed. checkKeyPressed() function is responsible for update this value every time a key is pressed. 
                              The possible key values that return getLastKey() are: 1000=ENTER, 1001=TAB, 1002=UP; 1003=DOWN. This is useful for i.e. execute a command after having pressed ENTER.
    public int getLastField() - this function is used to know what was the last field updated. 
    
  Help:
  To type text in the field, just put the mouse over the field and press LEFT+MOUSE or user ENTER/TAB or arrow kyes to move amog fields, then type what you need.  */
  
  
  /*
  
///////////////////////////////////////
EXAMPLE
///////////////////////////////////////

ADText textLines;

void setup()
{
  size(500,310);
  smooth();
  
  textLines = new ADText();
  textLines.add(50.0, 24.0, 400.0, "Name", "Name");
  textLines.add(50.0, 66.0, 400.0, "Username", "Username");
  textLines.add(50.0, 109.0, 400.0, "Password", "Passw1");
  textLines.add(50.0, 152.0, 400.0, "Retype Password", "Passw2");
  
  textLines.setActive(1);

  setTextParams();
}
/////////////////////////////////////////////////////////////
void setTextParams()
{
  
  textLines.getElement(0).setBackgroundBox(#F0D29B);
  textLines.getElement(0).setFocusOn();

  textLines.getElement(1).setBackgroundBox(#F0D29B);

  textLines.getElement(2).setBackgroundBox(#F0E39B);
  textLines.getElement(2).setMaskOn();
  
  textLines.getElement(3).setBackgroundBox(#F0E39B);
  textLines.getElement(3).setMaskOn();
   
}
/////////////////////////////////////////////////////////////
void draw()
{
  background(255);
  textLines.update();
  
  if (textLines.getLastKey()!=0 && textLines.getLastField()==0)
  {
   println("Ejecutar Busqueda de campo: "+textLines.getElement(0).getText());
  }
  printOut();  
}
/////////////////////////////////////////////////////////////
void keyPressed()
{
  textLines.checkKeyPressed();
}
/////////////////////////////////////////////////////////////
void keyReleased()
{
  textLines.checkKeyReleased();
}


/////////////////////////////////////////////////////////////
void printOut()
{
  int y=220;

  fill(0);
  textSize(18);
  textAlign(LEFT);
  
  for (int i=0; i<textLines.size(); i++)
  {
    if (textLines.getElement(i).isEmpty())
      text(textLines.getElement(i).getID()+": is empty",50,y+i*20);
    else  
      text(textLines.getElement(i).getID()+": "+textLines.getElement(i).getText(),50,y+i*20);
  }
  

}  
  */


  ArrayList textArray;
  int previousFocus=0;
  int lastField=0, lastKey=0;
  
  ADText()
  {
    textArray = new ArrayList();
  }
  
  ////////////////////////////////////////////////////////////////////////
  public void add(float x, float y, float w, String h, String id)
  {
    textArray.add(new ADGettext(x, y, w, h, id));
    
    getElement(size()-1).setArrayOn();

  }
  ////////////////////////////////////////////////////////////////////////
  public int size()
  {
    return textArray.size();
  }
  ////////////////////////////////////////////////////////////////////////
  public  ADGettext getElement(int i)
  {
    if (i>size()-1) i=size()-1;
    if (i<0) i=0;
    
    if (size()==0)
      return (ADGettext) null;
    else  
      return (ADGettext) textArray.get(i);
  }

  ////////////////////////////////////////////////////////////////////////
  public void update()
  {
    ADGettext textLine;
    for (int i=0; i<size(); i++)
    {
      getElement(i).update(); 
    
      if (getElement(i).getFocus())
      {
        if (i!=previousFocus)
        {
          getElement(previousFocus).setFocusOff();
          changeFocus(i);
          previousFocus=i;
        
        }
      }
    }
  } 

  /////////////////////////////////////////////////////////////
  private void changeFocus(int textFieldNumber)
  {
    for (int i=0; i<size(); i++)
    {
      if (textFieldNumber==i)
        getElement(i).setFocusOn();
      else
        getElement(i).setFocusOff();
    } 
  } 
  /////////////////////////////////////////////////////////////
  public void setActive(int i)
  {
    if (i>size()-1) i=size()-1;
    if (i<0) i=0;
    
    changeFocus(i);
    
  }
  /////////////////////////////////////////////////////////////
  public int getLastKey()
  {
    return lastKey;
  }
  /////////////////////////////////////////////////////////////
  public int getLastField()
  {
    return lastField;
  }
  /////////////////////////////////////////////////////////////
  public void checkKeyPressed()
  {
    lastKey=0; lastField=0;

    for (int i=0; i<size(); i++)
    {   
      int KeyReceived=getElement(i).checkKeyboardInput();

      if (KeyReceived==1000 || KeyReceived==1001 || KeyReceived==1003) //enter/tab/Down arrow was pressed
      {
        this.changeFocus((i+1)%size());
        lastKey=KeyReceived;
        lastField=i;
      }

      if (KeyReceived==1002) //Up Arrow was pressed
      {
        if (i-1<0)
          this.changeFocus(size()-1);
        else  
          this.changeFocus((i-1)%size());

        lastKey=KeyReceived;
        lastField=i;
      }
    }
  }
  /////////////////////////////////////////////////////////////
  public void checkKeyReleased() 
  {
    lastKey=0; lastField=0;
    for (int i=0; i<size(); i++)
    {
      getElement(i).checkAdditionalKeys();
    }
  }
  
  
  
  
}// end class
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "calculatorTest" });
  }
}
