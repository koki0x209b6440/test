

/* 0806
  sample[http://www.openprocessing.org/sketch/121214]
            [http://www.is.akita-u.ac.jp/~sig/lecture/java/parser.html]
            [http://www.openprocessing.org/sketch/60582]
　電卓。式が残る。関数電卓的に括弧とか使える。
　付けたい機能は二つ。簡単にはcalculator無限のように。
　1.分数はちゃんと上下に分けて表示
　2.式の途中部分を改変して再計算させる  <-clear!
*/
import processing.serial.*;

ADText textLines;

ArrayList<CalcButton> Buttons = new ArrayList<CalcButton>();
CalcButton[] spButtons = new CalcButton[3];
 
String answerValue="=";//displayValue="0";
//import-value =textLine.getElement(0).getText();

void setup() {
  size(340,400);
  frameRate(10);
  
  textLines = new ADText();
  textLines.add(17.0, 15.0, 310.0, "calculator", "importValueLine");
  textLines.setActive(0);
  textLines.getElement(0).setBackgroundBox(#c8c896);
  textLines.getElement(0).setFocusOn();
  
  //電卓ボタン生成とその描画(+電卓背景)
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
  
  spButtons[0] = new CalcButton(10,125,45,45,#d19955).setContent("C");
  spButtons[1] = new CalcButton(285,125,45,45,133).setContent("Pow");
  spButtons[2] = new CalcButton(175,345,100,45,133).setContent("=");
  
  background(50,55,55);
  for (int i=0; i<Buttons.size(); i++)   Buttons.get(i).display();
  for (int i=0; i<spButtons.length; i++) spButtons[i].display();
}

void draw() {
  //電卓の上部(数字が出る液晶部分)
  fill(200,200,150);
  rect(10,10,320,105);
  fill(0);
  //line(15,45,320,45);//分数表示時の横棒の位置参考
  textSize(25);
  text(answerValue,20,107);
  
  textLines.update();
}
