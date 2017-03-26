
class Grass extends HanyouBuffer
{
  ArrayList<GrassObject> objs;
  //boolean stop=true;
  float camera_p_x=0,camera_p_y=0,
         camera_p_z=200, // <- high
         camera_s_x,camera_s_y,camera_s_z;
  //float 
  Grass(PApplet papp)
  {
    super(papp);
  }
  void setup()
  {
    size(300,300,"P3D");
    objs=new ArrayList<GrassObject>();
    //     [camera_position PATTERN-02]  //tesaguri
    camera_p_x=559.0;
    camera_p_y=502.0;
    camera_p_z=1100.0;
    camera_s_x=610.0;
    camera_s_y=550.0;
    camera_s_z=-60.0;

    int num = 1000;//1000
    for(int i=0;i<num;i++)  //0~(width,height)よりも広い範囲に草原を展開する。
    {
      objs.add(new GrassObject(pg,random(0,pg.width*4),random(0,pg.height*4),0,   windVector,windDirection) );
    }
    //objs.add(new GrassObject(pg,pg.width/2,pg.height/2,0,   windVector,windDirection) );
    camera_set();
  }
  void draw()
  {
    wind_update();
    
    pg.background(255);
    
    for(int i=0; i<objs.size(); i++) objs.get(i).effect();
    
    pg.pushMatrix();
    pg.fill(255);
    pg.translate(camera_s_x,camera_s_y,camera_s_z);
    pg.box(10);
    pg.popMatrix();
  }

  PVector windVector = new PVector(random(-0.0f,0.0f),0.0f,random(-0.0f,0.0f));
  PVector windDirection = new PVector(random(-0.005f,0.005f),0.0f,random(-0.005f,0.005f));
  final float MAX_WIND_VECTOR= 0.1f;
  void wind_update()
  {
    if(random(50)<1)
    {
       windDirection = new PVector(random(0.00f,0.05f),0.0f,random(-0.005f,0.005f));
    }
    //if(stop) ;
    //else 
               windVector.add(windDirection);
    if(windVector.mag() > MAX_WIND_VECTOR)
    {
      windVector.normalize();
      windVector.mult(MAX_WIND_VECTOR);
      windDirection = new PVector(random(-0.005f,0.005f),0.0f,random(-0.005f,0.005f));
    }
  }
  
  void camera_set()
  {
    pg.beginCamera();
    pg.camera(camera_p_x, camera_p_y, camera_p_z, 
                    camera_s_x, camera_s_y, camera_s_z,
                    0, 1, 0);
    pg.endCamera();
  }

}
