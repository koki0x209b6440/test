
  Player player;
  WorldData world=new NormalWorld(Config.WORLD_LENGTH_X,
                                  Config.WORLD_LENGTH_Y,
                                  Config.WORLD_LENGTH_Z);
  void setup(){
    
    size(Config.WIN_WIDE, Config.WIN_HIGH, P3D);//ウインドウサイズ
    
    smooth();
    frameRate(20);
    ObjectBlock.init(this);
    
    player=new Player( Config.FIRST_X,      Config.FIRST_Y,     Config.FIRST_Z, 
                       Config.PLAYER_WIDTH, Config.PLAYER_HEIGHT, Config.PLAYER_DEPTH,   world); 
    world.setObj(player);

  }
  
  void draw(){//widthとheightはsetupで指定したウインドウサイズを格納したもの？
    background(0,102,204);
    
    player.control();
    world.draw3D(player);
    world.infoDraw(player);
  }
  
  ////////////////////////
  
  void keyPressed(){
    KeyControl.listenKey(key,keyCode,true);
  }
  
  void keyReleased(){
    KeyControl.listenKey(key,keyCode,false);
  }

  void mousePressed(){
    MouseControl.listenMouseClick(mouseButton,true);
  }
  
  void mouseReleased(){
    MouseControl.listenMouseClick(mouseButton,false);
  }
  
  void mouseMoved(){
    MouseControl.listenMousePoint();
  }
