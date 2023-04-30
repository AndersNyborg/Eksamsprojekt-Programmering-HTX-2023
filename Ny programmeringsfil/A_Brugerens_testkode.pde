
import java.awt.Robot; //Dette skal være der
Robot robot; //Dette skal være der


simplified3D World = new simplified3D(); //Deklaring og initering af classen (Libraryet vil her blive aflæst, i ikke-prototypen)



void setup() {
  fullScreen(P3D, 1);

  World.intiliazesimplified3D(startXPos, startYPos, startZPos, startViewXPos, startViewYPos, startViewZPos); //Starter verdenen, ved at give oplysniger om koordinater og retning

}

void draw() {

  
  World.drawObejcts(); //Bruges til at tegne alle objekterne
  World.updateCamera(); //Bruges til at opdatere kamaeret
}

//Alle de nedenstående keypressed, keyreleased også videre der refere til classen funktioner er nødvendigheder.

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
