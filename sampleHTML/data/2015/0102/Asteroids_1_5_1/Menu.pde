class Menu extends GameObject implements AcceptInput
{
  private ArrayList<MenuItem> items = new ArrayList<MenuItem>();
  private PVector size = new PVector(0, 0);
  private int selectedItem = 0;
  private MenuListener menuListener;

  public void addMenuListener(MenuListener obj)
  {
    this.menuListener = obj;
  }
  public void addItem(MenuItem item)
  {
    items.add(item);
  }
  public void setSize(float menuWidth, float menuHeight)
  {
    this.size = new PVector(menuWidth, menuHeight);
  }
  public void setPosition(float x, float y)
  {
    this.position = new PVector(x, y);
  }
  public void draw()
  {
    resetMatrix();
    translate(this.position.x, this.position.y);

    for (int i = 0; i < items.size(); i++)
    {
      MenuItem item = items.get(i);

      stroke(Config.General.ForegroundColor);
      strokeWeight(Config.General.LineWidth);
      
      if (selectedItem == i)
      {
        fill(100, 100);
      }
      else
      {
        noFill();
      }
      item.setSize(this.size.x, this.size.y/items.size());
      item.update();
      item.draw();
      translate(0, item.size.y);
    }
  }
  public void update()
  {
  }
  public void keyReleased()
  {
    if (keyCode == ENTER)
    {
      play(sfxMenuItemSelected);
      menuListener.itemSelected(items.get(selectedItem));
    }
  }
  public void keyPressed()
  {
    if (keyCode == UP)
    {
      play(sfxMenuItem);
      if (selectedItem > 0)
      {
        selectedItem--;
      }
      else
      {
        selectedItem = items.size() - 1;
      }
    }
    else if (keyCode == DOWN)
    {
      play(sfxMenuItem);
      if (selectedItem + 1 < items.size())
      {
        selectedItem++;
      }
      else
      { 
        selectedItem = 0;
      }
    }
  }
  public void keyTyped()
  {
  }
}

class MenuItem extends GameObject
{
  protected String name = "";
  protected PVector size = new PVector(0, 0);

  public void setSize(float menuWidth, float menuHeight)
  {
    this.size = new PVector(menuWidth, menuHeight);
  } 
  public String getName()
  {
    return this.name;
  }
  public void draw() {
  }
  public void update() {
  }
}

class MenuItemButton extends MenuItem
{
  private String label = "";

  MenuItemButton(String name, String label)
  {
    this.name = name;
    this.label = label;
  }
  public void draw()
  {
    rect(-this.size.x/2, -this.size.y/2, this.size.x, this.size.y);

    fill(Config.General.ForegroundColor);
    textSize(28);
    textAlign(CENTER);
    text(this.label, 0, 10);
  }
}

interface MenuListener
{
  public void itemSelected(MenuItem source);
}
