import processing.core.PVector;


public class Player {
//int units;
Unit[] mUnit;
	particleWar mSketch;
	int mColor;	
	
	float positionX, positionY;
boolean isPlayer;
int playerID;
public Player(int startUnits,particleWar iSketch,boolean isPlayeri,int playerIDi){
	mSketch=iSketch;
	 isPlayer=isPlayeri;
	 playerID=playerIDi;


	positionX=mSketch.random(mSketch.width*.9f);
	positionY=mSketch.random(mSketch.height*.9f);
	
	mColor=(int) mSketch.random(255);
//	units=startUnits;
	mUnit=new Unit[startUnits];
	for(int i=0;i<mUnit.length;i++){mUnit[i]=new Unit(mSketch,positionX,positionY,playerID,i,mColor);}

}	

boolean pmousePressed=false;
boolean mousePressed=false;
	int mnx=0,mny=0;
//	isPlayer
		PVector[] mnpoints = new PVector[4];
		void handle(){
			mSketch.ellipse(mSketch.mouseX,mSketch.mouseY,5,5);

		mousePressed=mSketch.mousePressed; //mousex=mSketch.mouseX;	mousey=mSketch.mouseY;

//{new PVector(0,0),new PVector(0,0),new PVector(0,0),new PVector(0,0)};
	if (mSketch.mousePressed&&mSketch.mouseButton==mSketch.LEFT&&!pmousePressed) {	mnx=(int) mSketch.mouseX;mny=(int) mSketch.mouseY;
	mnpoints[0] = new PVector(mSketch.mouseX,mSketch.mouseY);}
	if (mSketch.mousePressed&&mSketch.mouseButton==mSketch.LEFT&&pmousePressed) {	
	mnpoints[0] = new PVector(mnx,mny);	mnpoints[1] = new PVector(mSketch.mouseX,mny);
	mnpoints[2] = new PVector(mSketch.mouseX,mSketch.mouseY);	mnpoints[3] = new PVector(mnx,mSketch.mouseY);
	tsVertex(mnpoints);}
	if (!mSketch.mousePressed&&mSketch.mouseButton==mSketch.LEFT&&pmousePressed) {	
	mnpoints[0] = new PVector(mnx,mny);	mnpoints[1] = new PVector(mSketch.mouseX,mny);
	mnpoints[2] = new PVector(mSketch.mouseX,mSketch.mouseY);	mnpoints[3] = new PVector(mnx,mSketch.mouseY);
	for(int i=0;i<mUnit.length;i++){mUnit[i].isSelected=false;
	if(		mnpoints[0].x<mnpoints[1].x&&
			mnpoints[0].y<mnpoints[2].y
			){
	
	if(	mUnit[i].positionX>mnpoints[0].x&&
		mUnit[i].positionX<mnpoints[1].x&&
		mUnit[i].positionY>mnpoints[0].y&&
		mUnit[i].positionY<mnpoints[2].y)
	{	mUnit[i].isSelected=true;}	}
	
	else if(		mnpoints[1].x<mnpoints[0].x&&
			mnpoints[0].y<mnpoints[2].y
			){
	
	if(	mUnit[i].positionX>mnpoints[1].x&&
		mUnit[i].positionX<mnpoints[0].x&&
		mUnit[i].positionY>mnpoints[0].y&&
		mUnit[i].positionY<mnpoints[2].y)
	{	mUnit[i].isSelected=true;}	}
	
	else if(		mnpoints[1].x<mnpoints[0].x&&
			mnpoints[2].y<mnpoints[0].y
			){
	
	if(	mUnit[i].positionX>mnpoints[1].x&&
		mUnit[i].positionX<mnpoints[0].x&&
		mUnit[i].positionY>mnpoints[2].y&&
		mUnit[i].positionY<mnpoints[0].y)
	{	mUnit[i].isSelected=true;}	}
	else if(		mnpoints[0].x<mnpoints[1].x&&
			mnpoints[2].y<mnpoints[0].y
			){
	
	if(	mUnit[i].positionX>mnpoints[0].x&&
		mUnit[i].positionX<mnpoints[1].x&&
		mUnit[i].positionY>mnpoints[2].y&&
		mUnit[i].positionY<mnpoints[0].y)
	{	mUnit[i].isSelected=true;}	}
	

	}
	//	PVector[] tmpuv=new PVector[]{new PVector(0,0),new PVector(1,0),new PVector(1,1),new PVector(0,1)};
	//Unit= pappend(new Unit(mnpoints,tmpuv,pa),Unit);addp = false;
	}

	
	if (mSketch.mousePressed&&mSketch.mouseButton==mSketch.RIGHT) {	
		for(int i=0;i<mUnit.length;i++){	
//			mnx=(int) mSketch.mouseX;
//			mny=(int) mSketch.mouseY;
			if (mUnit[i].isSelected) {	

        float angle = mSketch.atan2(mSketch.mouseY-mUnit[i].positionY,mSketch.mouseX-mUnit[i].positionX)*180/mSketch.PI;
//        float angle = mSketch.atan2(positionY-ty,positionX-tx)*180/mSketch.PI+180;
   mUnit[i].direction=angle;
   }}
//		float angle = mSketch.atan2(mSketch.mouseY-mSketch.height/2,mSketch.mouseX-mSketch.width/2)*180/mSketch.PI;
//		mSketch.text(angle,mSketch.width/2,mSketch.height/2);

		}
	pmousePressed=mSketch.mousePressed;
	}	
		
		public Unit[] remove (int valueToRemove,Unit in[]){if(in.length<1||in[valueToRemove]==null)return in; Unit[] temp=new Unit[in.length-1];for (int i=0;i<valueToRemove;i++){temp[i]=in[i];}for (int i=valueToRemove;i<temp.length;i++){temp[i]=in[i+1];}return temp;}
		public Unit[] append (Unit newp,Unit in[]){Unit[] temp=new Unit[in.length + 1];System.arraycopy(in,0,temp,0,in.length);temp[in.length]=newp;return temp;}

public void draw(){


	mSketch.fill(mColor,255-mColor,255,255);
mSketch.text(""+mUnit.length,15,15*(playerID+1));

for(int i=0;i<mUnit.length;i++){mUnit[i].run();}
if(isPlayer)	{mSketch.fill(mColor,255-mColor,255,100);

handle();}

}
public void tsVertex(PVector[] a) {  { mSketch.beginShape();  mSketch.vertex(a[0].x, a[0].y); mSketch.vertex(a[1].x, a[1].y); mSketch.vertex(a[2].x, a[2].y); mSketch.endShape(); mSketch.beginShape(); mSketch.vertex(a[2].x, a[2].y); mSketch.vertex(a[3].x, a[3].y); mSketch.vertex(a[0].x, a[0].y); mSketch.endShape(); }}

}
