/**
multiplekeys taken from http://wiki.processing.org/index.php?title=Keep_track_of_multiple_key_presses
@author Yonas Sandbæk http://seltar.wliia.org
*/
 
// usage: 
// if(checkKey("ctrl") && checkKey("s")) println("CTRL+S");  
// Note: DOES NOT WORK WITH MACS
boolean[] keys = new boolean[526];
boolean checkKey(String k) {
  for(int i = 0; i < keys.length; i++)
    if(KeyEvent.getKeyText(i).toLowerCase().equals(k.toLowerCase())) return keys[i];  
  return false;
}
 
void keyPressed() { 
  keys[keyCode] = true;
  println(KeyEvent.getKeyText(keyCode) + " " + keyCode);
  if (keys[40]) { // down
    car.movingForward = false;
  }
  else if (keys[38]) { // up
    car.movingForward = true;
  }
}
void keyReleased() { 
  keys[keyCode] = false;
}

