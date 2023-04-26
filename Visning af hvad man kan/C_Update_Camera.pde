boolean currentlyJumping = false;
float jumpAdd = 0;
float fallingSpeed = 0;

void updateCamera() {
  
  //Det hjælper meget at kigge på rutediagrammet for at forstå hvad der sker.
  
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
          calcFallingYAddValue(); //Beregn hvor hurtigt man skal falde
        }
      } else { //Hvis et hop er igang
        calcOngoingJump();
      }
      //Kommer der til at ske en kollision ved bevægelsen:
    }
    if (afterMovementInsideObjectCheck()==true) {
      resetCameraAddValues(); //Hvis man vil komme til at støde ind i noget, sættes tillæggelserne til 0
      if (freeFly==false && standingOnground()==false) { //Hvis man skal falde
        calcFallingYAddValue(); //Beregn hvor hurtigt man skal falde
      }
      insideObjectCalc(); //Beregn evt. x,y og z værditillægelser, hvis man er inde i et object
    }
  } else { //Hvis der ikke er trykket nogen knapper ned
    insideObjectCalc(); //Beregn evt. x,y og z værditillægelser, hvis man er inde i et object
    if (freeFly == false && standingOnground()==false) { //Hvis man skal falde
      calcFallingYAddValue(); //Beregn hvor hurtigt man skal falde
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

void calcFallingYAddValue() {
  if (standingOnground()==true) { //Hvis man står på jorden skal man ikke falde videre ned.
    cameraAddYPos=0;
  } else {

    fallingSpeed += 0.75; //Hvis man ikke står på jorden, skal man falde hurtigere og hurtigere
    int[] objectUnderFeet = objectInLine(cameraXPos, cameraYPos, cameraZPos, cameraXPos, cameraYPos-1, cameraZPos, playerHeight+1+fallingSpeed); //Find ud af hvilket object der er under fødderne
    if (objectUnderFeet[0]==0 || -1*makeNumerical((objectInfo(objectUnderFeet[1], "yPos")+objectInfo(objectUnderFeet[1], "yDim")/2))>fallingSpeed) { //Hvis der ikke er noget object under fødderne eller afstanden ned til til er mere end hvor meget der skal faldes med
      cameraAddYPos=-fallingSpeed;
    } else { //Hvis der er mindre ned til objektet under end, end fallingspeed
      cameraAddYPos=-1*makeNumerical((cameraYPos-playerHeight-1)-(objectInfo(objectUnderFeet[1], "yPos")+objectInfo(objectUnderFeet[1], "yDim")/2)); //beregnelse af hvor langt der er ned til objektet under ens fødder.

    }
  }
}
float makeNumerical(float value) { //En hjælpefunktion som gør en værdi numerisk, altså altid posetiv.
  if (value >= 0) {
    return value;
  }
  return value*-1;
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
        objectInfo(i,"xPos")-objectInfo(i,"xDim")/2, objectInfo(i,"yPos")-objectInfo(i,"yDim")/2, objectInfo(i,"zPos")-objectInfo(i,"zDim")/2, //Udregn hjørnet
        objectInfo(i,"xPos")+objectInfo(i,"xDim")/2, objectInfo(i,"yPos")+objectInfo(i,"yDim")/2, objectInfo(i,"zPos")+objectInfo(i,"zDim")/2,
        cameraXPos-20, cameraYPos-playerHeight-1, cameraZPos-20, //der bliver sammenlignet med spillersposition, og der er minusset med -1, fordi man ikke skal være nede i objektet under end, men bare stå på det.
        cameraXPos+20, cameraYPos, cameraZPos+20)==true) {
        fallingSpeed = 0;
        return true;
      }
    }
  }
  return false;
}

void startJump() {
  jumpAdd = jumpHeight; //JumpAdd er hvad der løbende vil blive lagt til cameraAddYPos, så hoppet bliver gradvis.
  cameraAddYPos = jumpAdd;
  currentlyJumping = true;
}

void calcOngoingJump() {

  if (jumpAdd <= 0) { //Hvis hoppet er færdig
    currentlyJumping = false;
  } else {
    jumpAdd -= jumpHeight/10; //Der trækkes hele tiden 10% af det oprindelige fra, så hoppet bliver gradvis.
    cameraAddYPos = jumpAdd; //Der bliver lagt til jumpadd
  }
}


boolean afterMovementInsideObjectCheck() {
  for (int i = 0; i<Map.size(); i++) { //Sammenlign med alle objector
    if (Map.get(i)!=None) { //Den skal ikke se om man er inde i objecter der ikke eksistere
      if (advcollision(//Her sammenlignes om man, når bevægelsen også er talt med, vil komme til at støde ind i noget.
        objectInfo(i,"xPos")-objectInfo(i,"xDim")/2, objectInfo(i,"yPos")-objectInfo(i,"yDim")/2, objectInfo(i,"zPos")-objectInfo(i,"zDim")/2, //Udregn hjørnet
        objectInfo(i,"xPos")+objectInfo(i,"xDim")/2, objectInfo(i,"yPos")+objectInfo(i,"yDim")/2, objectInfo(i,"zPos")+objectInfo(i,"zDim")/2,
        cameraXPos+cameraAddXPos-20, cameraYPos+cameraAddYPos-playerHeight, cameraZPos+cameraAddZPos-20,
        cameraXPos+cameraAddXPos+20, cameraYPos+cameraAddYPos, cameraZPos+cameraAddZPos+20)==true) {
        return true;
      }
    }
  }
  return false;
}

void insideObjectCalc() {

  for (int i = 0; i<Map.size(); i++) { //Render igennem alle objektor
    if (Map.get(i)!=None) { //Gider ikke sammenligne hvis objektet ikke findes længere
      if (advcollision(
        objectInfo(i,"xPos")-objectInfo(i,"xDim")/2, objectInfo(i,"yPos")-objectInfo(i,"yDim")/2, objectInfo(i,"zPos")-objectInfo(i,"zDim")/2, //Udregn hjørnet
        objectInfo(i,"xPos")+objectInfo(i,"xDim")/2, objectInfo(i,"yPos")+objectInfo(i,"yDim")/2, objectInfo(i,"zPos")+objectInfo(i,"zDim")/2,
        cameraXPos-20, cameraYPos-playerHeight, cameraZPos-20,
        cameraXPos+20, cameraYPos, cameraZPos+20)==true) { //Hvis ja så skal der nu regnes ud hvilken vej man skal skubbes for at komme mest naturlig ud.
        float[] distanceToEdge = new float[6]; //Der bliver lavet et floatarray, som skal indeholde hvor langt der er til alle kanter, fra hvor kameraet et nu.

        distanceToEdge[0] = objectInfo(i,"xPos")-objectInfo(i,"xDim")/2-cameraXPos-20; //Først hvor der står alt det med Map findes x-koordinatet til det ene punkt (og derved hele kanten) herefter fratakkes cameraXpositoinen, for derved at få differensen mellem kamerapunktet og  kanten. til sidst trækkes de 20 fra, som stammer fra at vi søger inden for et 20 pixels område
        distanceToEdge[1] = objectInfo(i,"xPos")+objectInfo(i,"xDim")/2-cameraXPos+20;
        distanceToEdge[2] = objectInfo(i,"zPos")-objectInfo(i,"zDim")/2-cameraZPos-20;
        distanceToEdge[3] = objectInfo(i,"zPos")+objectInfo(i,"zDim")/2-cameraZPos+20;
        distanceToEdge[4] = objectInfo(i,"yPos")-objectInfo(i,"yDim")/2-cameraYPos;
        distanceToEdge[5] = objectInfo(i,"yPos")+objectInfo(i,"yDim")/2-cameraYPos+playerHeight;

        for (int n=0; n<6; n++) { //Alle distancerne skal være numeriske for at knne sammenligne dem.
          distanceToEdge[n] = makeNumerical(distanceToEdge[n]);
        }

        for (int n=0; n<6; n++) { //Der bliver kigget listen igennem
          if (isLowestinArray(distanceToEdge[n],distanceToEdge)==true) { //Hvis det er det laveste tal i floatarrayet (altså den korteste distance, skal der laves en aktion;)
            int sideSwitch = 1;
            if ((n+1)%2==1){ //Fordi jeg før gjorde alle talene numeriske, skal halvdelen nu kunne blive lavet tilbage til deres oprindelige størrelse.
              sideSwitch =-1;
            }
            if (n==0 || n==1){ //Alt efter hvilket indeks det er som er det laveste, skal man rykkes på x,y eller z aksen.
              cameraAddXPos += distanceToEdge[n]*sideSwitch;
            }
            else if (n==2 || n==3){
              cameraAddZPos += distanceToEdge[n]*sideSwitch;
            }
            else if (n==4 || n==5){
              cameraAddYPos += distanceToEdge[n]*sideSwitch;
            }
          }
        }
      }
    }
  }
}
boolean isLowestinArray(float value, float[] valueList) {
  float lowestFloat = valueList[0]; //Initere lowestfloat med en tilfældig

  for (int i=0; i<valueList.length; i++) {
    if (valueList[i]<lowestFloat) { //Tag dem alle i rækkefølge, og hvis de er mindre end det nuværende lowestfloat, bliver det skiftet.
      lowestFloat=valueList[i];
    }
  }
  if (value==lowestFloat) { //Hvis den værdi vi har spurgt om er det mindste tal, også er det mindste tal, er det sandt.
    return true;
  }
  return false;
}
