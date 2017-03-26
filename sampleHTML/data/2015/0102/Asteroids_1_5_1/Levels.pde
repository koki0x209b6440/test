abstract class Level
{
  public ArrayList<GameObject> gameObjs = new ArrayList<GameObject>();
  public ArrayList<GameObject> addToWorld = new ArrayList<GameObject>();
  public ArrayList<GameObject> removeFromWorld = new ArrayList<GameObject>();
  public Ship player;

  public void begin()
  {
  }

  public void draw()
  {
    for (GameObject obj : gameObjs)
    {
      obj.update();
    }

    for (GameObject obj : gameObjs)
    {
      checkCollisions(obj);
      
      resetMatrix();
      obj.draw();
    }

    for (GameObject obj : addToWorld)
    {
      gameObjs.add(obj);
    }
    addToWorld.clear();

    for (GameObject obj : removeFromWorld)
    {
      gameObjs.remove(obj);
    }
    removeFromWorld.clear();
  }

  public void keyPressed()
  {
    for (GameObject obj : gameObjs)
    {
      if (obj instanceof AcceptInput)
      {
        ((AcceptInput)obj).keyPressed();
      }
    }
  }
  public void keyReleased()
  {
    for (GameObject obj : gameObjs)
    {
      if (obj instanceof AcceptInput)
      {
        ((AcceptInput)obj).keyReleased();
      }
    }
  }
  public void keyTyped()
  {
    for (GameObject obj : gameObjs)
    {
      if (obj instanceof AcceptInput)
      {
        ((AcceptInput)obj).keyTyped();
      }
    }
    
    if (key == 'c' || key == 'C')
    {
      new ConfigWindow();
    }
  }

  protected void checkCollisions(GameObject other)
  {
    for (GameObject obj : gameObjs)
    {
      if (obj != other && obj.collidingWith(other))
      {
        obj.collidedWith(other);
      }
    }
  }
  protected void newPlayer()
  {
    player = new Ship();
    player.position = new PVector(width/2, height/2);
    addToWorld.add(player);
  }
}

class MainMenu extends Level implements MenuListener
{
  public void begin()
  {
    for (int i = 0; i < 10; i++)
    {
      Asteroid asteroid = new Asteroid();
      addToWorld.add(asteroid);
    }

    Menu menu = new Menu();
    menu.addMenuListener(this);
    menu.setPosition(width/2, height/2);
    menu.setSize(300, 150);
    menu.addItem(new MenuItemButton("btCampaign", "Campaign"));
    menu.addItem(new MenuItemButton("btFreePlay", "Free play"));
    addToWorld.add(menu);
  }
  public void itemSelected(MenuItem source)
  {
    if (source.getName() == "btCampaign")
    {
      loadLevel(new LevelLoader(new Campaign(1)));
    }
    else if (source.getName() == "btFreePlay")
    {
      loadLevel(new FreePlay());
    }
  }

  public void draw()
  {
    background(Config.General.BackgroundColor);

    textAlign(CENTER);
    textSize(48);
    text("Asteroids", width/2, height * 0.3);

    textSize(16);
    text("Press C at any time to customize the game", width/2, height * 0.9);

    super.draw();
  }
}

class LevelLoader extends Level
{
  private Level levelToLoad;

  LevelLoader(Level level)
  {
    this.levelToLoad = level;
  }

  private String info = "~~~~~~~~~~~~Lets<'s kick some ass... ~~~~~~~~<<<<<teroids!";
  private TextWriter textWriter;

  public void begin()
  {
    textSize(20);
    textWriter = new TextWriter(info);
  }

  public void draw()
  {
    background(Config.General.BackgroundColor);

    textWriter.update();
    textAlign(LEFT);
    text(textWriter.getText() + "_", width/2-textWidth(info.replace("~", "").replace("<", ""))/2, height/2);

    if (textWriter.isFinished())
    {
      delay(1000);
      loadLevel(levelToLoad);
    }
    else
    {
      delay((int)random(20, 50));
    }
  }
}

class Campaign extends Level implements MenuListener
{
  private int difficulty;
  private boolean hasWon = false;
  private boolean hasLost = false;
  private Menu menu;

  Campaign(int difficulty)
  {
    this.difficulty = difficulty;
  }

  public void itemSelected(MenuItem source)
  {
    if (source.getName() == "btRestart")
    {
      loadLevel(new Campaign(1));
    }
    else if (source.getName() == "btQuit")
    {
      loadLevel(new MainMenu());
    }
    else if (source.getName() == "btNextLevel")
    {
      loadLevel(new Campaign(this.difficulty + 1));
    }
  }

  public void begin()
  {
    for (int i = 0; i < difficulty; i++)
    {
      Asteroid ast = new Asteroid();
      gameObjs.add(ast);
    }
  }

  public void draw()
  {
    background(Config.General.BackgroundColor);

    if (player == null)
    {
      textAlign(CENTER);
      textSize(48);
      text("Level " + this.difficulty, width/2, height * 0.3);

      textSize(18);
      text("Press enter to begin.", width/2, height * 0.7);
    }

    super.draw();

    check();
    if (hasLost)
    {
      resetMatrix();
      textAlign(CENTER);
      textSize(48);
      text("You lost on\nlevel " + this.difficulty + "!", width/2, height * 0.3);

      if (menu == null)
      {
        menu = new Menu();
        menu.addMenuListener(this);
        menu.setPosition(width/2, height/2);
        menu.setSize(300, 150);
        menu.addItem(new MenuItemButton("btRestart", "Restart"));
        menu.addItem(new MenuItemButton("btQuit", "Quit to Menu"));
        addToWorld.add(menu);
      }
    }
    else
    {
      if (hasWon)
      {
        removeFromWorld.add(player);
        
        resetMatrix();
        textAlign(CENTER);
        textSize(48);
        text("You won!", width/2, height * 0.3);

        if (menu == null)
        {
          menu = new Menu();
          menu.addMenuListener(this);
          menu.setPosition(width/2, height/2);
          menu.setSize(300, 150);
          menu.addItem(new MenuItemButton("btNextLevel", "Next Level"));
          menu.addItem(new MenuItemButton("btQuit", "Quit to Menu"));
          addToWorld.add(menu);
        }
      }
    }
  }

  private void check()
  {
    this.hasWon = true;

    if (player != null && player.life == 0)
    {
      this.hasLost = true;
    }

    for (GameObject obj : gameObjs)
    {
      if (obj instanceof Asteroid)
      {
        this.hasWon = false;
      }
    }
  }

  public void keyReleased()
  {
    super.keyReleased();

    if (keyCode == ENTER && player == null)
    {
      newPlayer();
    }
  }
}

class FreePlay extends Level implements MenuListener
{
  private boolean hasLost = false;
  private Menu menu;

  public void itemSelected(MenuItem source)
  {
    if (source.getName() == "btContinue")
    {
      removeFromWorld.add(this.menu);
      this.menu = null;
      hasLost = false;
      newPlayer();
    }
    else if (source.getName() == "btQuit")
    {
      loadLevel(new MainMenu());
    }
  }

  public void begin()
  {
  }

  public void draw()
  {
    background(Config.General.BackgroundColor);

    if (player == null)
    {
      textAlign(CENTER);
      textSize(48);
      text("Free Play", width/2, height * 0.3);

      textSize(18);
      text("While playing:", width/2, height * 0.45);
      text("Press A to spawn a new Asteroid.", width/2, height * 0.50);
      text("Press X to destroy all Asteroids.", width/2, height * 0.55);

      text("Press enter to begin.", width/2, height * 0.7);
    }

    super.draw();

    check();
    if (hasLost)
    {
      resetMatrix();
      textAlign(CENTER);
      textSize(48);
      text("You lost!", width/2, height * 0.3);

      if (menu == null)
      {
        menu = new Menu();
        menu.addMenuListener(this);
        menu.setPosition(width/2, height/2);
        menu.setSize(300, 150);
        menu.addItem(new MenuItemButton("btContinue", "Continue"));
        menu.addItem(new MenuItemButton("btQuit", "Quit to Menu"));
        addToWorld.add(menu);
      }
    }
  }

  private void check()
  {
    if (player != null && player.life == 0)
    {
      this.hasLost = true;
    }
  }
  public void keyReleased()
  {
    super.keyReleased();
    
    if (player == null && keyCode == ENTER)
    {
      newPlayer();
    }
    if (key == 'a' || key == 'A')
    {
      Asteroid ast = new Asteroid();
      addToWorld.add(ast);
    }
    else if (key == 'x' || key == 'X')
    {
      for (GameObject obj : gameObjs)
      {
        if (obj instanceof Asteroid)
        {
          ((Asteroid)obj).destroy();
        }
      }
    }
  }
}

