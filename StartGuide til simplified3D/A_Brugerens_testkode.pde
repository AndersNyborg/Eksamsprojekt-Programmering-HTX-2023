////////////////////////////////////////////LÆS DETTE FØRST//////////////////////////////////////////////////////////
//Dette er en prototype, til at vise hvordan programmet kan bruges. I koden nedenunder er der forklaring på, hvad alting bruges til.
//De linjer koder der på nuværende tidspunkt er markeret som kommentar, kan omdannes til rigtig gode, for at se hvad de gør.
//God fornøjelse.
//For en tom fil, hvor der ikke er programmeret noget i forvejen, se: "Ny programmeringsfil". Der nemlig nogle linjer kode der er nødvendig.
//Bemærk da dette er en prototype, at der ikke er noget libary, det er blot en klasse, som ligger i de andre tabs.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
import java.awt.Robot; //Dette skal være der
Robot robot; //Dette skal være der



float startXPos = 0; //Bruges til senere at sætte spilerens startkoordiant
float startYPos = 0;//Bruges til senere at sætte spilerens startkoordiant
float startZPos = 0;//Bruges til senere at sætte spilerens startkoordiant
float startViewXPos = startXPos+1;//Bruges til senere at sætte spilerens start retning, af hvor man kigger
float startViewYPos = startYPos+0; //Bruges til senere at sætte spilerens start retning, af hvor man kigger
float startViewZPos = startZPos+0; //Bruges til senere at sætte spilerens start retning, af hvor man kigger


simplified3D World = new simplified3D(); //Deklaring og initering af classen (Libraryet vil her blive aflæst, i ikke-prototypen)

int kasse1,kasse2; //deklaring som en global variablen, til senere at kunne initere den.

void setup() {
  fullScreen(P3D, 1);

  World.intiliazesimplified3D(startXPos, startYPos, startZPos, startViewXPos, startViewYPos, startViewZPos); //Starter verdenen, ved at give oplysniger om koordinater og retning
  World.changePlayerHeight(150); //Ændre på højden af spilleren fra standarden på 100 til 150
  World.freeFlyMode(true); //Sætter at man kan flyve, hvis det sættes til false falder man



  kasse1 = World.advObjectBoxAddition(200, 0, 0, 100, 100, 100, 155, 155, 155, 10); //laver en kasse ved koordinatet (200,0,0) med størrelse på (100,100,100) i farven (155,155,155) med stroken (10)
  kasse2 = World.advObjectBoxAddition(200, 0, 300, 100, 100, 100, 155, 255, 155, 10); //laver kasse 300 pixels væk i z-aksen.

//Nedenstående laver et gulv til hvis man skal slå fra man vil kunne flyve
  //for (int xCo=-300; xCo<400; xCo=xCo+100) { 
  //  for (int zCo=-300; zCo<400; zCo=zCo+100) {
  //    World.advObjectBoxAddition(xCo, -250, zCo, 100, 100, 100, 155, 155, 155, 10); 
  //  }
  //}
}

void draw() {
  
  //if (World.collision(kasse1,kasse2)==false){ //Hvis der ikke er kollision mellem kasse1 og kasse 2
  //World.changeObject(kasse1,"zPos",World.objectInfo(kasse1,"zPos")+1); //Vil få kasse1 til at rykke sig
  //}
  
  World.drawObejcts(); //Bruges til at tegne alle objekterne
  World.updateCamera(); //Bruges til at opdatere kamaeret
}

//Alle de nedenstående keypressed, keyreleased også videre der refere til classen funktioner er nødvendigheder.

void keyPressed() {
  World.simplified3DkeyPressed();

  if (key == 'h') { //Hvis man har trykket på h
    World.setView(World.objectInfo(kasse1, "xPos"), World.objectInfo(kasse1, "yPos"), World.objectInfo(kasse1, "zPos")); //med setview kan med give et koordinat, som spilleren som vil kigge på. Her bruges  objectInfo(ID, information) til at få x,y og z koordinattet for kasse 1
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
  int[] objektLookingat = World.lookingAt(); //Looking at bruges til at finde hvad man kigger på. Den retunere følgende liste: [1 eller 0 alt efter om man kigger på noget objekt, ID til det objekt man evt. kigger på, -1 0 eller 1 alt efter hvilken side af x-aksen poå objektet man kan kigger på,1 0 eller 1 alt efter hvilken side af y-aksen poå objektet man kan kigger på,1 0 eller 1 alt efter hvilken side af z-aksen poå objektet man kan kigger på]
  
  if (objektLookingat[0] == 1){ //Hvis objektet eksistere
    World.changeObject(objektLookingat[1],"fillr",255); //Bruger funktionen changeObject(hvilket objekt, hvad der skal ændres, til hvilken værdi) til at ændre r værdien på det objekt man kigger på.
  }

}
