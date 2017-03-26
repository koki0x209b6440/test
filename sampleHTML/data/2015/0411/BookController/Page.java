import processing.core.PApplet;
import processing.core.PImage;

/**
 * A very simple class to represent a 'page'
 * in a book.
 * 
 * The key to this class is the attribute 'img'
 * which is a bitmap image of the page. The only 
 * restriction is that the image size must be the
 * same as the page size specified when creating
 * the book.
 * 
 * It is a straightforward matter to inherit from
 * this class to create pages from other sources
 * than a simple bitmap image.
 * 
 * There is no need to edit this file.
 * 
 * @author Peter Lager
 *
 */
public class Page {
  PApplet app;
  PImage img;


  public Page() {
    app = null;
    img = null;
  }

  public Page(PApplet papp, Book book,PImage img) {
    app = papp;
    this.img = img;
    this.img.resize(book.pageWidth,book.pageHeight);
  }

  public Page(PApplet papp,Book book, String filename) {
    app = papp;
    img = app.loadImage(filename);
    img.resize(book.pageWidth,book.pageHeight);
  }
}

