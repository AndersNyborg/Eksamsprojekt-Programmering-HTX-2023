boolean currentlyJumping = false;
float jumpAdd = 0;

void updateCamera() {

  //Kameraets (spillerens syn) placering bliver opdateret ved at tage den nuværende position for kameraet og addere cameraAddXPos, cameraAddYPos og cameraAddZPos
  resetCameraAddValues();//Først bliver tilføjeses variablerne cameraAddXPos osv. sat til 0



  if (controls.size()>0) { //Hvis listen "controls" (som indeholder hvilke knapper der lige nu er trykket ned) inderholder en eller flere knapper (W,A,S,D,Shift, mellemrum) køres funktionen til udregning af nye cameraAddXPos, cameraAddYPos og cameraAddZPos
    updateCameraXZAddValues(controls); //Beregn de nye værdier af X og Y, ud fra hvad er er input'et

    if (freeFly == true) { //Hvis man kan flyve
      updateCameraYAddValuesWithFreeFly(controls); //y tilføjelse skal bare opdateres efter om man har mellemrum eller shift nede
    } else { //Hvis man ikke kan flyve
      if (currentlyJumping == false) { //Hvis man ikke er igang med et hop
        if (standingOnground()==true) { //Hvis man står på noget.
          if (isJumpPressed(controls)==true) {
            startJump(); //Starter hoppet
          }
        } else {//Hvis man ikke står på noget
          cameraAddYPos=-1; ///////////// DDDDDDDDDDDDDDDDDDDDDEEEEEEEEEEEEEEEETTTTTTTTTTTT EEEEEEEEEEEEEERRRRRRRRR HHHHHHHHHHHHHHH EEEEEEEEEEEEEEEEERRRRRRRRRRRR jeg er nået til
        }
      } else { //Hvis et hop er igang
        calcOngoingJump();
      }
    }


    //Kommer der til at ske en kollision ved bevægelsen:
    if (afterMovementInsideObjectCheck()==true) {
      resetCameraAddValues(); //Hvis man vil komme til at støde ind i noget, sættes tillæggelserne til 0
      insideObjectCalc(); //Beregn evt. x,y og z værditillægelser, hvis man er inde i et object
    }
  } else { //Hvis der ikke er trykket nogen knapper ned
    insideObjectCalc(); //Beregn evt. x,y og z værditillægelser, hvis man er inde i et object
    if (standingOnground()==false){
      cameraAddYPos=-1;
    }
  }

  cameraXPos+=cameraAddXPos; //Opdatere positionen
  cameraYPos+=cameraAddYPos;
  cameraZPos+=cameraAddZPos;


  camera(cameraXPos, cameraYPos, cameraZPos, cameraXPos+cameraViewXPos, cameraYPos+cameraViewYPos, cameraZPos+cameraViewZPos, 0, -1, 0); // Her opdaters kameraet.
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------Hjælpefunktioner------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
void resetCameraAddValues() {
  cameraAddXPos=0;
  cameraAddYPos=0;
  cameraAddZPos=0;
}


void updateCameraXZAddValues(IntList keysPressed) {
  //Beregningen for hvad cameraAddXPos osv. skal være fungerer ved at tage en knap ad gangen fra controls listen.
  //Herefter bliver fx. cameraAddXPos beregnet alt efter hvor meget man kigger mod x og hvad movementspeed er.
  //Hvis der så er holdt flere knapper nede, fx. 2, skal være knap kun udgør 50% af hvad den ellers ville
  cameraAddXPos = 0;
  cameraAddZPos = 0;

  float averageDivider = 1/float(keysPressed.size()); //Bruges til at kunne finde gennemsnit hvis flere knapper holdes ned samtidig.


  for (int i=0; i<keysPressed.size(); i++) { //Kør igennem knapperne der holdes nede

    int  keyen = keysPressed.get(i); //Få knappen (om det er w,s,a eller d)

    if (keyen==87) {
      cameraAddZPos += movementSpeed*cameraViewZPos*averageDivider; //Først er det movementSpeed * cameraViewZPos (Altså den vej man kigger) * averagedivider (Til hvis der er flere knapper nede samtidig)
      cameraAddXPos += movementSpeed*cameraViewXPos*averageDivider; //Det samme ned cameraViewXPos
    }
    if (keyen==83) {
      cameraAddZPos += -movementSpeed*cameraViewZPos*averageDivider; //Når man bevæger sig bagud, skal begge værdier være minus
      cameraAddXPos += -movementSpeed*cameraViewXPos*averageDivider;
    }
    if (keyen==65) {
      cameraAddZPos += movementSpeed*cameraViewXPos*averageDivider; //Når man vil bevæge sig vinkelret til fremad, skal man bytte rundt på værdierne, og så den ene skal være ganget med minus.
      cameraAddXPos += -movementSpeed*cameraViewZPos*averageDivider;
    }

    if (keyen==68) {
      cameraAddZPos += -movementSpeed*cameraViewXPos*averageDivider; //Her er de begge ganget med -1 iforhodl til ovenstående
      cameraAddXPos += movementSpeed*cameraViewZPos*averageDivider;
    }
  }

  //Nedenstående er fordi hvis man fx. holder a og w nede, bliver der rykket frem med 50% og til venstre med 50%, men fordi det er kateter, bliver hypotenysen længere, og man bevæger sig derfor hurtigere skråt end ligeud fx.
  if (cameraAddZPos!=0 ||cameraAddXPos!=0) {//Fordi at hvis man fx. holder a og d nede, bliver de begge nul og så fucker det op og multiplier bliver uendelig stort
    float multiplier = (sqrt(pow(movementSpeed, 2)+pow(0, 2)) //Her findes hvor stort den nuværende hypotenuse for bevægelsen er ift. hvis den var længst, er 1 ved en enhedscirkel (Dog er det movementspeed istedet).
      /sqrt(pow(cameraAddZPos, 2)+(pow(cameraAddXPos, 2))));
    cameraAddZPos *=multiplier; //Herefter kan multiplieren ganges på.
    cameraAddXPos *=multiplier;
  }
}
void updateCameraYAddValuesWithFreeFly(IntList keysPressed) {
  for (int i=0; i<keysPressed.size(); i++) { //Kør igennem knapperne der holdes nede

    int  keyen = keysPressed.get(i); //Få knappen (om det er w,s,a eller d)

    if (keyen==16) { //Hvis det er shift
      cameraAddYPos = -movementSpeed; //Man går ned
    }

    if (keyen==32) {//Hvis der er mellemrum
      cameraAddYPos = movementSpeed; //Man går op
    }
  }
}

boolean isJumpPressed(IntList keysPressed) {
  for (int i=0; i<keysPressed.size(); i++) { //Kør igennem knapperne der holdes nede

    int  keyen = keysPressed.get(i); //Få knappen (om det er w,s,a eller d)

    if (keyen==32) {//Hvis der er mellemrum
      return true;
    }
  }
  return false;
}

boolean standingOnground() {
  for (int i = 0; i<Map.size(); i++) { //Sammenlign med alle objector
    if (Map.get(i)!=None) { //Den skal ikke se om man er inde i objecter der ikke eksistere
      if (advcollision(//For om ens fødder er i noget
        Map.get(i)[0]-Map.get(i)[3]/2, Map.get(i)[1]-Map.get(i)[4]/2, Map.get(i)[2]-Map.get(i)[5]/2,
        Map.get(i)[0]+Map.get(i)[3]/2, Map.get(i)[1]+Map.get(i)[4]/2, Map.get(i)[2]+Map.get(i)[5]/2,
        cameraXPos-20, cameraYPos+cameraAddYPos-playerHeight-21, cameraZPos-20,
        cameraXPos+20, cameraYPos+cameraAddYPos+20, cameraZPos+20)==true) {
        return true;
      }
    }
  }
  return false;
}

void startJump() {
  jumpAdd = jumpHeight;
  cameraAddYPos = jumpAdd;
  currentlyJumping = true;
}

void calcOngoingJump() {

  if (jumpAdd <= 0) {
    currentlyJumping = false;
  } else {
    jumpAdd -= jumpHeight/10;
    cameraAddYPos = jumpAdd;
  }
}


boolean afterMovementInsideObjectCheck() {
  for (int i = 0; i<Map.size(); i++) { //Sammenlign med alle objector
    if (Map.get(i)!=None) { //Den skal ikke se om man er inde i objecter der ikke eksistere
      if (advcollision(//Her sammenlignes om man, når bevægelsen også er talt med, vil komme til at støde ind i noget.
        Map.get(i)[0]-Map.get(i)[3]/2, Map.get(i)[1]-Map.get(i)[4]/2, Map.get(i)[2]-Map.get(i)[5]/2,
        Map.get(i)[0]+Map.get(i)[3]/2, Map.get(i)[1]+Map.get(i)[4]/2, Map.get(i)[2]+Map.get(i)[5]/2,
        cameraXPos+cameraAddXPos-20, cameraYPos+cameraAddYPos-playerHeight-20, cameraZPos+cameraAddZPos-20,
        cameraXPos+cameraAddXPos+20, cameraYPos+cameraAddYPos+20, cameraZPos+cameraAddZPos+20)==true) {
        return true;
      }
    }
  }
  return false;
}

void insideObjectCalc() {


  for (int i = 0; i<Map.size(); i++) { //For om man er inde i noget
    if (Map.get(i)!=None) {
      if (advcollision(
        Map.get(i)[0]-Map.get(i)[3]/2, Map.get(i)[1]-Map.get(i)[4]/2, Map.get(i)[2]-Map.get(i)[5]/2,
        Map.get(i)[0]+Map.get(i)[3]/2, Map.get(i)[1]+Map.get(i)[4]/2, Map.get(i)[2]+Map.get(i)[5]/2,
        cameraXPos-20, cameraYPos-playerHeight-20, cameraZPos-20,
        cameraXPos+20, cameraYPos+20, cameraZPos+20)==true) {
        float[] distanceToEdge = new float[6];

        distanceToEdge[0] = Map.get(i)[0]-Map.get(i)[3]/2-cameraXPos-20; //Først hvor der står alt det med Map findes x-koordinatet til det ene punkt (og derved hele kanten) herefter fratakkes cameraXpositoinen, for derved at få differensen mellem kamerapunktet og  kanten. til sidst trækkes de 20 fra, som stammer fra at vi søger inden for et 20 pixels område
        distanceToEdge[1] = Map.get(i)[0]+Map.get(i)[3]/2-cameraXPos+20;
        distanceToEdge[2] = Map.get(i)[2]-Map.get(i)[5]/2-cameraZPos-20;
        distanceToEdge[3] = Map.get(i)[2]+Map.get(i)[5]/2-cameraZPos+20;
        distanceToEdge[4] = Map.get(i)[1]-Map.get(i)[4]/2-cameraYPos-20;
        distanceToEdge[5] = Map.get(i)[1]+Map.get(i)[4]/2-cameraYPos+playerHeight+20;

        for (int n=0; n<6; n++) {
          if (distanceToEdge[n]<0) { // For at få den numeriske værdi.
            distanceToEdge[n] *= -1;
          }
        }


        if (distanceToEdge[0]<distanceToEdge[1] &&distanceToEdge[0]<distanceToEdge[2] &&distanceToEdge[0]<distanceToEdge[3]&&distanceToEdge[0]<distanceToEdge[4]&&distanceToEdge[0]<distanceToEdge[5]) {

          cameraAddXPos -= distanceToEdge[0];
        }
        if (distanceToEdge[1]<distanceToEdge[0] &&distanceToEdge[1]<distanceToEdge[2] &&distanceToEdge[1]<distanceToEdge[3]&&distanceToEdge[1]<distanceToEdge[4]&&distanceToEdge[1]<distanceToEdge[5]) {

          cameraAddXPos += distanceToEdge[1];
        }
        if (distanceToEdge[2]<distanceToEdge[1] &&distanceToEdge[2]<distanceToEdge[0] &&distanceToEdge[2]<distanceToEdge[3]&&distanceToEdge[2]<distanceToEdge[4]&&distanceToEdge[2]<distanceToEdge[5]) {

          cameraAddZPos -= distanceToEdge[2];
        }
        if (distanceToEdge[3]<distanceToEdge[1] &&distanceToEdge[3]<distanceToEdge[0] &&distanceToEdge[3]<distanceToEdge[2]&&distanceToEdge[3]<distanceToEdge[4]&&distanceToEdge[3]<distanceToEdge[5]) {

          cameraAddZPos += distanceToEdge[3];
        }

        if (distanceToEdge[4]<distanceToEdge[1] &&distanceToEdge[4]<distanceToEdge[0] &&distanceToEdge[4]<distanceToEdge[3]&&distanceToEdge[4]<distanceToEdge[2]&&distanceToEdge[4]<distanceToEdge[5]) {

          cameraAddYPos -= distanceToEdge[4];
          if (freeFly == false) {
            cameraAddYPos = 0;
          }
        }
        if (distanceToEdge[5]<distanceToEdge[1] &&distanceToEdge[5]<distanceToEdge[0] &&distanceToEdge[5]<distanceToEdge[2]&&distanceToEdge[5]<distanceToEdge[4]&&distanceToEdge[5]<distanceToEdge[3]) {

          cameraAddYPos += distanceToEdge[5];
        }
      }
    }
  }
}
