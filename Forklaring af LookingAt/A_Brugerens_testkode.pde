import java.awt.Robot;
Robot robot;





float xPos = -400;
float yPos = 900;
float zPos = -1000;
float viewXPos = xPos+1;
float viewYPos = yPos-1.4;
float viewZPos = zPos+3;


simplified3D World = new simplified3D();

int gulv,mand;

void setup() {
  fullScreen(P3D,1);
  
  World.intiliazesimplified3D(xPos, yPos, zPos, viewXPos, viewYPos, viewZPos);
  World.changePlayerHeight(150);
  World.freeFlyMode(true);

  gulv = World.advObjectBoxAddition(0, 0, 0, 500, 20, 500, 155, 155, 155, 10); //Grå
  mand =  World.advObjectBoxAddition(0, 75, 0, 20, 150, 50, 0, 0, 255, 10); //Blå
  
  for (int i=0;i<800;i++){
    World.advObjectBoxAddition(0+i, 120+i, i, 1, 1, 1, 255, 0, 0, 10); //Rød
  }
  World.advObjectBoxAddition(500, 120+500-50, 500-50, 100, 100, 100, 155, 255, 155, 10); //Blå Kassen der bliver kigget på
  World.advObjectBoxAddition(500, 120+500-50+100, 500-50, 100, 100, 100, 155, 155, 155, 10); //Grå kasse over den blå kasse der bliver kigget på
  World.advObjectBoxAddition(500, 120+500-50-100, 500-50, 100, 100, 100, 155, 155, 155, 10); //Grå kasse under den blå kasse der bliver kigget på
  World.advObjectBoxAddition(500, 120+500-50, 500+100-50, 100, 100, 100, 155, 155, 155, 10); //Grå kasse til venstre den blå kasse der bliver kigget på
  World.advObjectBoxAddition(500, 120+500-50, 500-100-50, 100, 100, 100, 155, 155, 155, 10); //Grå kasse til højre den blå kasse der bliver kigget på
  
  World.advObjectBoxAddition(0.5*500, 0.5*(120+500)-80, 500, 100, 100, 100, 255, 0, 0, 10); //Grå kasser halvvejs oppe der ikke bliver kigget på
   
  //World.advObjectBoxAddition(0.5*(0+800), 0.5*(75+920), 0.5*(0+800), 800, 920-75, 800, 255, 0, 0, 10); //Hele kollisionkasse
  World.advObjectBoxAddition(0.5*(0+800)*0.5, 0.5*(75+920)*0.5, 0.5*(0+800)*0.5, 800*0.5, (920-75)*0.5, 800*0.5, 255, 0, 0, 10); //Halve kollisionkasse
  World.advObjectBoxAddition(0.5*(0+800)*1.5, 0.5*(75+920)*1.5, 0.5*(0+800)*1.5, 800*0.5, (920-75)*0.5, 800*0.5, 255, 0, 0, 10); //Halvde kollisionkasse

}

void draw() {

  
  World.drawObejcts();
  World.updateCamera();

    
  
}

void keyPressed() {
  World.simplified3DkeyPressed();

}

void keyReleased() {
  World.simplified3DkeyReleased();
}

void mouseMoved() {

  World.simplified3DmouseMoved();
}
void mouseDragged() {

  World.simplified3DmouseMoved();
}

void mousePressed() {
  int[] object = World.lookingAt();

  if (object[0] == 1) {
    if (mouseButton==RIGHT) {
      World.advObjectBoxAddition(World.objectInfo(object[1], "xPos")+World.objectInfo(object[1], "xDim")*object[2], World.objectInfo(object[1], "yPos")+World.objectInfo(object[1], "yDim")*object[3], World.objectInfo(object[1], "zPos")+World.objectInfo(object[1], "zDim")*object[4], 100, 100, 100, 155, 155, 155, 010);
    }
    if (mouseButton==LEFT) {
      World.deleteObject(object[1]);
    }
  }

}
