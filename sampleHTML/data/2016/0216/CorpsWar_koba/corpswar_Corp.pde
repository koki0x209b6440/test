
class Corp
{
	PApplet papp;
        Unit[] units;
        Corp[] corps;

        int CorpID;
	int uColor;	//UnitColor
	float x, y;
        boolean isPlayer;
        Corp(int startunits,Corp[] corps,PApplet papp,boolean isPlayer,int CorpID)
        {
	  this.papp=papp;
          this.corps=corps;
	  this.isPlayer=isPlayer;
          this.CorpID=CorpID;
          x=papp.random(papp.width*.9f);
          y=papp.random(papp.height*.9f);
          if(CorpID==0)uColor=50;
          else uColor=corps[CorpID-1].uColor+60;
          units=new Unit[startunits];
          for(int i=0;i<units.length;i++)
          {
            units[i]=new Unit(papp,corps,x,y,CorpID,i,uColor);
            if(CorpID==0 && i==0)units[i].isPlayerON(UP,LEFT,DOWN,RIGHT);//UP,LEFT,DOWN,RIGHT  //'W','A','S','D'
          }
        }
        void draw()
        {
          papp.fill(uColor,255-uColor,255,255);
          papp.textSize(16);
          papp.text(""+unitsLifeLength(),15,15*(CorpID+1));
          for(int i=0;i<units.length;i++) units[i].run();
          if(isPlayer)
          {
            papp.fill(uColor,255-uColor,255,100);
            handle();
          }
        }
        public Unit[] remove (int valueToRemove,Unit in[])
        {
          /*
          if(in.length<1||in[valueToRemove]==null)return in;
          
          Unit[] temp=new Unit[in.length-1];
          for (int i=0;i<valueToRemove;i++)                temp[i]=in[i];
          for (int i=valueToRemove;i<temp.length;i++) temp[i]=in[i+1];
          return temp;
          */
          in[valueToRemove].isWork=false;//die
          return in;
        }
        int unitsLifeLength()
        {
          int result=0;
          for(int i=0; i<units.length; i++)
          {
            if(units[i].isWork==true)result++;
          }
          return result;
        }

        
        
        
        
        int mnx=0,mny=0;
        int px=0,py=0;
        PVector[] mnpoints = new PVector[4];
        boolean pmousePressed=false;
        boolean mousePressed=false;
        boolean pFlg=false;
        void handle()
        {
          papp.ellipse(papp.mouseX,papp.mouseY,5,5);
          papp.ellipse(px,py,5,5);
          mousePressed=papp.mousePressed;
          if (papp.mousePressed&&papp.mouseButton==papp.LEFT&&!pmousePressed)
          {	
            pFlg=false;
            px=0;
            py=0;
            mnx=(int)papp.mouseX;
            mny=(int)papp.mouseY;
            mnpoints[0] = new PVector(papp.mouseX,papp.mouseY);
          }
	  if (papp.mousePressed&&papp.mouseButton==papp.LEFT&&pmousePressed) 
          {	
	    mnpoints[0] = new PVector(mnx,mny);	
            mnpoints[1] = new PVector(papp.mouseX,mny);
	    mnpoints[2] = new PVector(papp.mouseX,papp.mouseY);	
            mnpoints[3] = new PVector(mnx,papp.mouseY);
	    tsVertex(mnpoints);
          }
	  if (!papp.mousePressed&&papp.mouseButton==papp.LEFT&&pmousePressed)
          {	
            mnpoints[0] = new PVector(mnx,mny);	
            mnpoints[1] = new PVector(papp.mouseX,mny);
            mnpoints[2] = new PVector(papp.mouseX,papp.mouseY);	
            mnpoints[3] = new PVector(mnx,papp.mouseY);
            for(int i=0;i<units.length;i++)
            {
              units[i].isSelected=false;
              if(mnpoints[0].x<mnpoints[1].x&&mnpoints[0].y<mnpoints[2].y)
              {
                if(units[i].x>mnpoints[0].x&&units[i].x<mnpoints[1].x&&
		   units[i].y>mnpoints[0].y&&units[i].y<mnpoints[2].y){    units[i].isSelected=true;}
              }
	      else if(	mnpoints[1].x<mnpoints[0].x&&mnpoints[0].y<mnpoints[2].y)
              {
	        if(units[i].x>mnpoints[1].x&&units[i].x<mnpoints[0].x&&
                   units[i].y>mnpoints[0].y&&units[i].y<mnpoints[2].y){	units[i].isSelected=true;}	
              }
	      else if(	mnpoints[1].x<mnpoints[0].x&&mnpoints[2].y<mnpoints[0].y)
              {
	        if(units[i].x>mnpoints[1].x&&units[i].x<mnpoints[0].x&&
		   units[i].y>mnpoints[2].y&&units[i].y<mnpoints[0].y){	units[i].isSelected=true;}	
              }
	      else if(mnpoints[0].x<mnpoints[1].x&&mnpoints[2].y<mnpoints[0].y)
              {
	        if(units[i].x>mnpoints[0].x&&units[i].x<mnpoints[1].x&&
		   units[i].y>mnpoints[2].y&&units[i].y<mnpoints[0].y){	units[i].isSelected=true;}	
              }
	  } }


          if (papp.mousePressed&&papp.mouseButton==papp.RIGHT) 
          {
              px=papp.mouseX;
              py=papp.mouseY;
	  }
	  pmousePressed=papp.mousePressed;

          if(pFlg=true && px!=0 && py!=0)
          {
	      for(int i=0;i<units.length;i++)
              {
                if (units[i].isSelected)
                {	
                  float angle = papp.atan2(py-units[i].y,px-units[i].x)*180/papp.PI;
                  units[i].direction=angle;
                }
              }
          }
          
        }	
        void tsVertex(PVector[] a)
        {  
            papp.beginShape(); 
                papp.vertex(a[0].x, a[0].y);
                papp.vertex(a[1].x, a[1].y);
                papp.vertex(a[2].x, a[2].y);
            papp.endShape();
            papp.beginShape();
                papp.vertex(a[2].x, a[2].y);
                papp.vertex(a[3].x, a[3].y);
                papp.vertex(a[0].x, a[0].y);
            papp.endShape(); 
        }
}
