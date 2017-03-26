

int[][] wall = new int[30][30];
int editmode=0;


void edit(){

  for(int x=0;x<30;x++){
    for(int y=0;y<30;y++){
      if(wall[x][y]>0){
        fill(100-10*wall[x][y]);
      }
      else{
        fill(200);
      }
      rect(x*10,y*10,10,10);
    }
  }
  pushMatrix();
  pushStyle();
  fill(255);
  stroke(0);
  translate(px/64*10,py/64*10);
  ellipse(0,0,10,10);
  stroke(255,0,0);
  rotate(pa);
  line(0,0,15,0);
  popStyle();
  popMatrix();
  text("Light Intensity:"+light,320,40);
}






void mousePressed(){
  if(mouseButton==RIGHT){
    editmode++;
    if(editmode>1){
      editmode=0;
    }
  }
  if(mouseButton==LEFT){
    texon++;
    if(texon>1){
      texon=0;
    }

    if(editmode==1){
      if(mouseX<300&&mouseY<300){
        wall[int(mouseX/10)][int(mouseY/10)]++;
        if(wall[int(mouseX/10)][int(mouseY/10)]>1){
          wall[int(mouseX/10)][int(mouseY/10)]=0;
        }
      }
    }
  }
}
