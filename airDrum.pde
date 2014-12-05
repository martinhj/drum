import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;
SimpleOpenNI kinect;
float rotation = 0;
// two AudioSnippet objects this time Minim minim;
AudioSnippet kick;
AudioSnippet snare;
// declare our two hotpoint objects 
Hotpoint snareTrigger;
Hotpoint kickTrigger;
Hotpoint hpToMove;
float s = 1;
void setup() {
  size(640, 480, OPENGL);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  ////////////////minim = new Minim(this);
  // load both audio files
  //snare = minim.loadSnippet("hat.wav"); 
  //kick = minim.loadSnippet("kick.wav");
  // initialize hotpoints with their origins (x,y,z) and their size 
  snareTrigger = new Hotpoint(200, 0, 600, 350);
  kickTrigger = new Hotpoint(-200, 0, 600, 350);
  hpToMove = snareTrigger;
}
void draw() {
  background(0);
  kinect.update();
  translate(width/2, height/2, -1000);
  rotateX(radians(180));
  translate(0, 0, 1400);
  rotateY(radians(map(mouseX, 0, width, -180, 180)));
  translate(0, 0, s*-1000);
  scale(s);
  stroke(255);
  PVector[] depthPoints = kinect.depthMapRealWorld();
    for (int i = 0; i < depthPoints.length; i+=10) {
      PVector currentPoint = depthPoints[i];
      // have each hotpoint check to see if it includes the currentPoint 
      snareTrigger.check(currentPoint); 
      kickTrigger.check(currentPoint);
      if (currentPoint.z < 1500) {
        point(currentPoint.x, currentPoint.y, currentPoint.z);
      }
    }
  //println(snareTrigger.pointsIncluded);
    if(snareTrigger.isHit()) { 
     // snare.play();
    }
  /*
  if(!snare.isPlaying()) {
    //snare.rewind();
  }
  */
  if (kickTrigger.isHit()) {
    //kick.play();
  }
  /*
  if(!kick.isPlaying()) {
    //kick.rewind();
  }
  */
  // display each hotpoint and clear its points 
  snareTrigger.draw();
  snareTrigger.clear();
  kickTrigger.draw();
  kickTrigger.clear();
}
void stop() {
  // make sure to close
  // both AudioPlayer objects
  //kick.close();
  //snare.close();
  //minim.stop();
  super.stop();
}
void keyPressed() {
  if (keyCode == 38) {
    //s = s + 0.01;
    s = s + 0.1;
  }
  if (keyCode == 40) {
    //s = s - 0.01;
    s = s + 0.1;
  }
  switch (key) {
    case 'z': println("-");
              hpToMove.decreaseSize();
              break;
    case 'Z': println("+");
              hpToMove.increaseSize();
              break;
    case 'o': hpToMove.moveUp();
              break;
    case 'u': hpToMove.moveDown();
              break;
    case 'i': hpToMove.moveNorth();
              break;
    case 'k': hpToMove.moveSouth();
              break;
    case 'j': hpToMove.moveEast();
              break;
    case 'l': hpToMove.moveWest();
              break;
    case 'x': hpToMove = (hpToMove == snareTrigger) ? kickTrigger : snareTrigger;
  }
}
