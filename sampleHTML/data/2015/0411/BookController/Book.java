import processing.core.*;

import java.awt.*;
import java.awt.Graphics2D;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.geom.GeneralPath;
import java.util.LinkedList;

import javax.swing.Timer;



/**
 * A class to manage a collection of pages where each
 * page is an image.
 * It performs all the calculations and drawing actions
 * required to simulate page turning. * 
 * 
 * There is no need to edit this file.
 * 
 * @author Peter Lager
 *
 */
public class Book {
  // Under no circumstances should the values for these constants be changed
  private final int NEXT = 1, PREV = -1, STOPPED = 0;
  private final int PAGE_SIDE = 0, PAGE_TOP = 1;

  private PApplet app;
  private PGraphicsJava2D pg;

  // Used to create the shadow effect
  private BasicStroke bsShadow0 = new BasicStroke(20, BasicStroke.CAP_BUTT, BasicStroke.JOIN_BEVEL);
  private BasicStroke bsShadow1 = new BasicStroke(10, BasicStroke.CAP_BUTT, BasicStroke.JOIN_BEVEL);
  private BasicStroke bsEdge = new BasicStroke(2);

  // Attributes needed to perform the math calculations
  private final PVector[] left, right;
  private PVector[] curr;
  private PVector p1, p2;
  private int turnDir, crossOver;
  private float angle, pageX;
  private boolean isTop_onepage;

  int pageWidth, pageHeight;
  private int sideOffset, topOffset;
  private int bookWidth, bookHeight;

  private LinkedList<Page> pageSide;
  private int currPage;

  private GeneralPath gpReveal, gpBack, gpFront;
  private PImage imgLeft, imgRight, imgBack, imgReveal;

  private int pgEdgeCol;

  private Timer timer;


  public Book(PApplet papp, int pWidth, int pHeight,int turntime,boolean isTop_onepage) {
    app = papp;
    pageWidth = pWidth;
    pageHeight = pHeight;
    this.isTop_onepage=isTop_onepage;
    sideOffset = 2;
    topOffset = PApplet.max(60, pageHeight/10);
    bookWidth = 2 * (pageWidth + sideOffset);
    bookHeight = pageHeight + topOffset + 4;
    pgEdgeCol = app.color(0, 32);
    bsEdge = new BasicStroke(2.5f);
    pg = (PGraphicsJava2D) app.createGraphics(bookWidth, bookHeight, PApplet.JAVA2D);
    pg.imageMode(PApplet.CENTER);
    pageSide = new LinkedList<Page>();
    pageSide.add(new Page());
    pageSide.add(new Page());

    turnDir = STOPPED;
    right = new PVector[] {
      new PVector(0, 0), 
      new PVector(0, pageHeight), 
      new PVector(pWidth, pageHeight), 
      new PVector(pWidth, 0), 
      new PVector(pWidth/2, pageHeight/2)
      };
    left = new PVector[] {
      right[0], 
      right[1], 
      new PVector(-pWidth, pageHeight), 
      new PVector(-pWidth, 0), 
      new PVector(-pWidth/2, pageHeight/2)
      };
    curr = new PVector[] {
      new PVector(), 
      new PVector(), 
      new PVector(), 
      new PVector(), 
      new PVector()
      };
      gpFront = new GeneralPath();
    gpBack = new GeneralPath();
    gpReveal = new GeneralPath();
    createTimer(turntime);
  }

  /**
   * Initialises the book image for first time display. <br>
   * 
   * This method should be called once you have created the 
   * book and you have added at least one page.
   * 
   */
  public void initialiseBook() {
    currPage = 0;
    if(!isTop_onepage) currPage++;
    imgLeft = pageSide.get(currPage).img;
    imgRight = pageSide.get(currPage + 1).img;
    draw(imgLeft, imgRight, null, null);
  }

  //	private void addPage(Page p){
  //		page.add(page.size()-1, p);
  //	}

  /**
   * Adds a page to the end of the book.
   */
  public void addPage(String filename) {
    pageSide.add(pageSide.size()-1, new Page(app,this, filename));
  }

  /**
   * If we are not turning a page and we are not displaying the 
   * very first page then goto the previous page.
   * 
   * @return false if unable to change page else true
   */
  public boolean previousPage() {
    if (currPage < 1 || turnDir != STOPPED)
      return false;
    imgLeft = pageSide.get(currPage).img;
    imgRight = pageSide.get(currPage + 1).img;
    imgBack = pageSide.get(currPage - 1).img;
    imgReveal = pageSide.get(currPage - 2).img;

    pageX = 0;
    turnDir = PREV;
    timer.start();
    return true;
  }

  /**
   * If we are not turning a page and we are not displaying the 
   * very last page then goto the next page.
   * 
   * @return false if unable to change page else true
   */
  public boolean nextPage() {
    if (currPage >= pageSide.size() - 3 || turnDir != STOPPED)
      return false;
    imgLeft = pageSide.get(currPage).img;
    imgRight = pageSide.get(currPage + 1).img;
    imgBack = pageSide.get(currPage + 2).img;
    imgReveal = pageSide.get(currPage + 3).img;

    pageX = 0;
    turnDir = NEXT;
    timer.start();
    return true;
  }

  /**
   * At this moment in time is a page being turned?
   * @return true if a page is turning
   */
  public boolean isTurning() {
    return turnDir != STOPPED;
  }

  /**
   * Get the last image of the book drawn
   * @return the book image
   */
  public PGraphics getBookImage() {
    return pg;
  }

  /**
   * Get the width of the book image
   */
  public int getBookImageWidth() {
    return bookWidth;
  }

  /**
   * Get the height of the book image
   */
  public int getBookImageHeight() {
    return bookHeight;
  }

  /**
   * Draw the book image.
   * 
   * @param imgLeft
   * @param imgRight
   * @param imgBack
   * @param imgReveal
   */
  private void draw(PImage imgLeft, PImage imgRight, PImage imgBack, PImage imgReveal) {
    Graphics2D g2 = pg.g2; // need this to perform clipping
    pg.beginDraw();
    pg.background(pg.color(255, 0));
    pg.pushMatrix();
    pg.translate(pageWidth + sideOffset, topOffset);
    g2.setStroke(bsEdge);
    g2.setColor(new Color(pgEdgeCol, true));
    if (turnDir == STOPPED) {
      if (imgLeft != null) {
        pg.image(imgLeft, left[4].x, left[4].y);
        g2.drawRect((int)left[3].x, (int)left[3].y, pageWidth, pageHeight);
      }
      if (imgRight != null) {
        pg.image(imgRight, right[4].x, right[4].y);
        g2.drawRect((int)right[0].x, (int)right[0].y, pageWidth, pageHeight);
      }
      if (imgLeft != null && imgRight != null) {
        g2.setColor(new Color(0, 0, 0, 16));
        g2.setStroke(bsShadow1);
        g2.drawLine((int)right[0].x, (int)right[0].y, (int)right[1].x, (int)right[1].y);
      }
    }
    else {
      if (imgLeft != null) {
        if (turnDir == PREV) {
          g2.setClip(gpFront);
          pg.image(imgLeft, left[4].x, left[4].y);
          g2.setClip(null);
          g2.draw(gpFront);
        }
        else {
          pg.image(imgLeft, left[4].x, left[4].y);
          g2.drawRect((int)left[3].x, (int)left[3].y, pageWidth, pageHeight);
        }
      }
      if (imgRight != null) {
        if (turnDir == NEXT) {
          g2.setClip(gpFront);
          pg.image(imgRight, right[4].x, right[4].y);
          g2.setClip(null);
          g2.draw(gpFront);
        }
        else {
          pg.image(imgRight, right[4].x, right[4].y);
          g2.drawRect((int)right[0].x, (int)right[0].y, pageWidth, pageHeight);
        }
      }
      // Show the back of the page being turned
      if (imgBack != null) {
        g2.setClip(gpBack);
        // Need to save current matrix for local rotation
        pg.pushMatrix();
        pg.translate(curr[4].x, curr[4].y);
        pg.rotate(turnDir * angle);
        pg.image(imgBack, 0, 0);
        pg.popMatrix();
        g2.setClip(null);
        g2.draw(gpBack);
      }
      // Show the page being revealed / exposed
      if (imgReveal != null) {
        g2.setClip(gpReveal);
        if (turnDir == PREV)
          pg.image(imgReveal, left[4].x, left[4].y);  
        else
          pg.image(imgReveal, right[4].x, right[4].y);
        g2.setClip(null); 
        g2.draw(gpReveal);
      }
      // Draw a shadow at edge of page turn if there is a reveal page
      if (imgReveal != null) {
        g2.setColor(new Color(0, 0, 0, 16));
        g2.setStroke(bsShadow0);
        g2.drawLine((int)p1.x, (int)p1.y, (int)p2.x, (int)p2.y);
        g2.setStroke(bsShadow1);
        g2.drawLine((int)p1.x, (int)p1.y, (int)p2.x, (int)p2.y);
        g2.setStroke(bsEdge);
        g2.drawLine((int)p1.x, (int)p1.y, (int)p2.x, (int)p2.y);
      }
    }
    pg.popMatrix();
    pg.endDraw();
  }

  /**
   * This method performs all the calculations needed to define the clipping
   * regions needed. <br>
   * It first checks which side is being turned and if the animation has
   * stopped then forget the maths and return false. <br>
   * 
   * @param x the distance for the turn must be >=0 or < page width
   * @param direction the direction to turn the page
   * @return
   */
  private boolean doMaths(float x, int direction) {
    PVector[] turnSide = null;
    if (direction == NEXT) 
      turnSide = right;
    else if (direction == PREV) 
      turnSide = left;
    else
      return false;
    // Calculate current angle of turning page
    angle = PApplet.map(x, 0, pageWidth, PApplet.PI/5, 0);
    // Calculate the corner coordinates of the turning page
    // i.e. the mask
    float sx, sy;
    float sinA = PApplet.sin(angle), cosA = PApplet.cos(angle);

    for (int i = 0; i < curr.length; i++) {
      sx = right[i].x - x;
      sy = right[i].y - pageHeight;
      curr[i].x = direction * (sx * cosA - sy * sinA + pageWidth - x);
      curr[i].y = sx * sinA + sy * cosA + pageHeight;
    }
    // Calculate the points that define the mirror plane
    crossOver = PAGE_SIDE;
    p1 = line_line_p(turnSide[1], turnSide[2], curr[1], curr[2]);
    if (p1 == null)
      p1 = turnSide[1];
    p2 = line_line_p(curr[0], curr[1], turnSide[2], turnSide[3]);
    if (p2 == null) {
      crossOver = PAGE_TOP;
      p2 = line_line_p(curr[0], curr[3], turnSide[0], turnSide[3]);
      if (p2 == null)
        p2 = turnSide[0];
    }
    // Calculate the clip paths for the back of the turning page and the
    // page being revealed.
    gpFront.reset();
    gpFront.moveTo(turnSide[0].x, turnSide[0].y);
    gpFront.lineTo(turnSide[1].x, turnSide[1].y);
    gpFront.lineTo(p1.x, p1.y);
    gpFront.lineTo(p2.x, p2.y);
    if (crossOver == PAGE_SIDE)
      gpFront.lineTo(turnSide[3].x, turnSide[3].y);
    gpFront.closePath();

    gpBack.reset();
    gpBack.moveTo(curr[1].x, curr[1].y);
    gpBack.lineTo(p1.x, p1.y);
    gpBack.lineTo(p2.x, p2.y);
    if (crossOver == PAGE_TOP)
      gpBack.lineTo(curr[0].x, curr[0].y);
    gpBack.closePath();

    gpReveal.reset();
    gpReveal.moveTo(p2.x, p2.y);
    gpReveal.lineTo(p1.x, p1.y);
    gpReveal.lineTo(turnSide[2].x, turnSide[2].y);
    if (crossOver == PAGE_TOP)
      gpReveal.lineTo(turnSide[3].x, turnSide[3].y);
    gpReveal.closePath();

    return true;
  }

  /**
   * Create the timer that will be used to generate the action events
   * that will advance the animation.
   * @param delay
   */
  private void createTimer(int delay) {
    timer = new Timer(delay, new ActionListener() {
      public void actionPerformed(ActionEvent e) {
        switch(turnDir) {
        case STOPPED:
          timer.stop();					
          break;
        case PREV:
        case NEXT:
          pageX = PApplet.min(pageWidth, pageX + 2);
          if (pageX >= pageWidth) {
            currPage += (2 *turnDir);
            imgLeft = pageSide.get(currPage).img;
            imgRight = pageSide.get(currPage + 1).img;
            imgBack = imgReveal = null;
            turnDir = STOPPED;	
            timer.stop();
          }
          else {
            doMaths(pageX, turnDir);
          }
          draw(imgLeft, imgRight, imgBack, imgReveal);
          break;
        }
      }
    });
  }

  /**
   * Calculate and return the intersection point between 2 lines. If there is
   * no intersection the result will be null.
   * 
   * @param v0 start position of first line
   * @param v1 end position of first line
   * @param v2 start position of second line
   * @param v3 end position of second line
   * @return intersection point, or null if no intersection.
   */
  private PVector line_line_p(PVector v0, PVector v1, PVector v2, PVector v3) {
    PVector intercept = null;

    float f1 = (v1.x - v0.x);
    float g1 = (v1.y - v0.y);
    float f2 = (v3.x - v2.x);
    float g2 = (v3.y - v2.y);
    float f1g2 = f1 * g2;
    float f2g1 = f2 * g1;
    float det = f2g1 - f1g2;

    if (Math.abs(det) > 1E-30) {
      float s = (f2*(v2.y - v0.y) - g2*(v2.x - v0.x))/ det;
      float t = (f1*(v2.y - v0.y) - g1*(v2.x - v0.x))/ det;
      if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
        intercept = new  PVector(v0.x + f1 * s, v0.y + g1 * s);
    }
    return intercept;
  }
}

