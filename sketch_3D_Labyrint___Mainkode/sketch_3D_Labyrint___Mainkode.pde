import java.awt.Robot;
Robot robot;

float movementSpeed = 10;
float mouseSensivety = 30;


float xPos = 0;
float yPos = 0;
float zPos = 0;
float viewXPos = -10;
float viewYPos = 0;
float viewZPos = 00;


simplified3D World = new simplified3D();

int  Kasse1;
int  Kasse2;
int  Kasse3;
int  Kasse4;

int ståKasse1;
int ståKasse2;
int rykkeKasse;

float rykkeKasseAdd = 1;

int[] test = new int[36];
boolean lockCamera = false;
void setup() {
  fullScreen(P3D);
  World.intiliazesimplified3D(xPos, yPos, zPos, viewXPos, viewYPos, viewZPos);

  World.freeFlyMode(true);

  Kasse1 = World.objectBoxAddition(0, 0, 400, 100, 100, 100, 255, 0, 0, 0); //Rød
  Kasse2 = World.objectBoxAddition(0, -100, 400, 100, 100, 100, 0, 255, 0, 0); //Grøn
  Kasse3 = World.objectBoxAddition(100, -100, 400, 100, 100, 100, 0, 0, 255, 0); //Blue
  Kasse4 = World.objectBoxAddition(-100, 100, 400, 100, 100, 100, 155, 155, 155, 0); //grå
  World.objectBoxAddition(0, 0, 0, 100, 100, 100, 155, 155, 155, 0);

  ståKasse1 = World.objectBoxAddition(-300, 0, -400, 100, 100, 100, 155, 155, 155, 0);
  ståKasse2 = World.objectBoxAddition(300, 0, -400, 100, 100, 100, 155, 155, 155, 0);
  rykkeKasse = World.objectBoxAddition(0, -50, -400, 100, 70, 300, 155, 155, 155, 0);

 
  int counter = 0;
  for (int x=-300; x<300; x=x+100) {
    for (int z=-300; z<300; z=z+100) {

      test[counter]= World.objectBoxAddition(x, -200, z, 100, 10, 100, 155, 155, 155, 2);
      counter++;
    }
  }
}

void draw() {

  background(255);
  World.drawObejcts();
  World.updateCamera();

  if (World.collision(rykkeKasse, ståKasse1)==true ||World.collision(rykkeKasse, ståKasse2)==true) {
    rykkeKasseAdd*=-1;
  }
  //World.setView(World.objectInfo(rykkeKasse,"xPos"),World.objectInfo(rykkeKasse,"yPos"),World.objectInfo(rykkeKasse,"zPos"));
  if (World.objectExist(rykkeKasse)==true) {
    World.changeObject(rykkeKasse, "xPos", World.objectInfo(rykkeKasse, "xPos")+rykkeKasseAdd);
  }


  //for (int i = 0; i<36;i++){


  //  if (World.objectExist(test[i])==true){
  //  World.changeObject(test[i],"yPos",World.objectInfo(test[i],"yPos")+1);
  //  }
  //}
  //println(World.lookingAt());

  //if (frameCount==200){
  //  println(World.lookingAt());
  //}
  //World.changeObject(World.lookingAt(),"fillr",255);
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

void mousePressed() {
  int object = World.lookingAt();
  if (object != 100) {

    //World.deleteObject( object);
  }
}
