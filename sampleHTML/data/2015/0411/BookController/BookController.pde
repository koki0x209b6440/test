/*

sample[http://www.openprocessing.org/sketch/65678]

*/

Book book;
int x,y,w,h;

public void setup() {
  size(680, 440);
  x=8;
  y=10;
  w=330/2;
  h=300/2;
  book = new Book(this, w, h,20,false);//20=pageturnTime(but limit minimum.  example 0time not-different 5time.)
  book.addPage("wackyfront.jpg");
  book.addPage("wack0a.jpg");
  book.addPage("wack0b.jpg");
  book.addPage("wack2.jpg");
  book.addPage("wack8.jpg");
  book.addPage("wack1.jpg");
  book.addPage("wack6.jpg");
  book.addPage("wack9a.jpg");
  book.addPage("wack9b.jpg");
  book.addPage("wack3.jpg");
  book.addPage("wack8.jpg");
  book.addPage("wack4.jpg");
  book.addPage("wack5.jpg");
  book.addPage("wack10.jpg");
  book.addPage("wackyback.jpg");
  book.initialiseBook();
  //image(book.getBookImage(), 0, 0);
}

/**
 * The N and P keys are used to turn a page. If a page is 
 * still turning then the key press will be ignored.
 */
public void keyPressed() {
  if (key == 'p' || key == 'P')
    book.previousPage();
  if (key == 'n' || key == 'N')
    book.nextPage();
  if(keyCode==UP)
  {
    y-=5;
  }
  if(keyCode==DOWN)
  {
    y+=5;
  }
  if(keyCode==RIGHT)
  {
    x+=5;
  }
  if(keyCode==LEFT)
  {
    x-=5;
  }
}

public void draw() {
  background(0);
  pushMatrix();
  //translate((width - book.getBookImageWidth())/2, 10);
  translate(x,y);
  image(book.getBookImage(), 0, 0);
  popMatrix();
  //if (!book.isTurning())
}


