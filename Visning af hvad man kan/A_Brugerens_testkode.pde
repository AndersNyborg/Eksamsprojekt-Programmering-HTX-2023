import java.awt.Robot;
Robot robot;



float movementSpeed = 10;
float mouseSensivety = 30;


float xPos = 100;
float yPos = 150;
float zPos = 0;
float viewXPos = xPos-1;
float viewYPos = yPos+0;
float viewZPos = zPos+0;


simplified3D World = new simplified3D();

int  Kasse1, Kasse2, Kasse3, Kasse4, ståKasse1, ståKasse2, rykkeKasse;

float rykkeKasseAdd = 1;

int[] test = new int[36];
boolean lockCamera = false;
void setup() {
  fullScreen(P3D);
  
  World.intiliazesimplified3D(xPos, yPos, zPos, viewXPos, viewYPos, viewZPos);
  World.changePlayerHeight(150);
  World.freeFlyMode(true);

  Kasse1 = World.advObjectBoxAddition(0, 0, 400, 100, 100, 100, 255, 0, 0, 0); //Rød
  Kasse2 = World.advObjectBoxAddition(0, -100, 400, 100, 100, 100, 0, 255, 0, 0); //Grøn
  Kasse3 = World.advObjectBoxAddition(100, -100, 400, 100, 100, 100, 0, 0, 255, 0); //Blue
  Kasse4 = World.advObjectBoxAddition(-100, 100, 400, 100, 100, 100, 155, 155, 155, 0); //grå
  World.advObjectBoxAddition(0, 0, 0, 100, 100, 100, 155, 155, 155, 0);

  ståKasse1 = World.advObjectBoxAddition(-300, 0, -400, 100, 100, 100, 155, 155, 155, 0);
  ståKasse2 = World.advObjectBoxAddition(300, 0, -400, 100, 100, 100, 155, 155, 155, 0);
  rykkeKasse = World.advObjectBoxAddition(0, -50, -400, 100, 70, 300, 155, 155, 155, 0);

  World.advObjectBoxAddition(0, 180, 0, 100, 100, 100, 155, 155, 155, 0); //grå


  int counter = 0;
  for (int x=-300; x<300; x=x+100) {
    for (int z=-300; z<300; z=z+100) {

      test[counter]= World.advObjectBoxAddition(x, -100, z, 100, 10, 100, 155, 155, 155, 2);
      counter++;
    }
  }
}

void draw() {

  if (World.collision(rykkeKasse, ståKasse1)==true ||World.collision(rykkeKasse, ståKasse2)==true) {
    rykkeKasseAdd*=-1;
  }
  //World.setView(World.objectInfo(rykkeKasse,"xPos"),World.objectInfo(rykkeKasse,"yPos"),World.objectInfo(rykkeKasse,"zPos"));
  if (World.objectExist(rykkeKasse)==true) {
    World.changeObject(rykkeKasse, "xPos", World.objectInfo(rykkeKasse, "xPos")+rykkeKasseAdd);
  }
  
  if (World.insideCollision(Kasse1, Kasse2)) {
    print("True");
  }
  
  World.drawObejcts();
  World.updateCamera();

    
  
}

void keyPressed() {
  World.simplified3DkeyPressed();

  if (key == 'h') {
    World.setView(World.objectInfo(rykkeKasse, "xPos"), World.objectInfo(rykkeKasse, "yPos"), World.objectInfo(rykkeKasse, "zPos"));
  }
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
  //if (object[0] == 1) {
  //  World.deleteObject(object[1]);
  //}
}
