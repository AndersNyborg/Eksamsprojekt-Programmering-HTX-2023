IntList controls = new IntList();
float jumpAdd;
boolean jumpAbble = false;

void updateCamera() {
  
  //Kameraets (spillerens syn) placering bliver opdateret ved at tage den nuværende position for kameraet og addere cameraAddXPos, cameraAddYPos og cameraAddZPos
  
  cameraAddZPos = 0;// Begge værdier sættes til nul, så der kan blive adderet med hvor stor størrelsen skal være alt efter hvilke knapper der holdes inde.
  cameraAddXPos = 0;
  if (freeFly == true) { //Og hvis man kan flyve skal man også stå stille på y-aksen
    cameraAddYPos = 0;
  }
  if (controls.size()>0) { //Hvis listen "controls" (som indeholder hvilke knapper der lige nu er trykket ned) inderholder en eller flere knapper (W,A,S,D,Shift, mellemrum) køres funktionen til udregning af nye cameraAddXPos, cameraAddYPos og cameraAddZPos
      
      //Beregningen for hvad cameraAddXPos osv. skal være fungerer ved at tage en knap ad gangen fra controls listen.
      //Herefter bliver fx. cameraAddXPos beregnet alt efter hvor meget man kigger mod x og hvad movementspeed er.
      //Hvis der så er holdt flere knapper nede, fx. 2, skal være knap kun udgør 50% af hvad den ellers ville 
      
      
      
      float averageDivider = 1/float(controls.size()); //Bruges til at kunne finde gennemsnit hvis flere knapper holdes ned samtidig.

 
      for (int i=0; i<controls.size(); i++) { //Kør igennem knapperne der holdes nede

        int  keyen = controls.get(i); //Få knappen (om det er w,s,a eller d)

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
        if (keyen==16) {
          if (freeFly == true) {
            cameraAddYPos = -movementSpeed;
          }
        }
        if (keyen==32) {
          if (freeFly == true) {
            cameraAddYPos = movementSpeed;
          }
          if (freeFly == false) {
            if (jumpAdd <= 0 && jumpAbble == true) {

              jumpAdd = jumpHeight;
            }
          }
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
    
    //For at kunne hoppe:
      if (freeFly == false) {
        if (jumpAdd >= 0) {
          cameraAddYPos = jumpHeight;
          jumpAdd-=jumpHeight/10;
        }
      }
    boolean  collisionState = false;


    jumpAbble = false;
    for (int i = 0; i<Map.size(); i++) {
      if (Map.get(i)!=None) {
        if (advcollision(//For om ens fødder er i noget
          Map.get(i)[0]-Map.get(i)[3]/2, Map.get(i)[1]-Map.get(i)[4]/2, Map.get(i)[2]-Map.get(i)[5]/2,
          Map.get(i)[0]+Map.get(i)[3]/2, Map.get(i)[1]+Map.get(i)[4]/2, Map.get(i)[2]+Map.get(i)[5]/2,
          cameraXPos-20, cameraYPos+cameraAddYPos-playerHeight-20, cameraZPos-20,
          cameraXPos+20, cameraYPos+cameraAddYPos+20, cameraZPos+20)==true) {

          jumpAbble = true;
        }

        if (advcollision(//For om man kommer til at gå ind i noget
          Map.get(i)[0]-Map.get(i)[3]/2, Map.get(i)[1]-Map.get(i)[4]/2, Map.get(i)[2]-Map.get(i)[5]/2,
          Map.get(i)[0]+Map.get(i)[3]/2, Map.get(i)[1]+Map.get(i)[4]/2, Map.get(i)[2]+Map.get(i)[5]/2,
          cameraXPos+cameraAddXPos-20, cameraYPos+cameraAddYPos-playerHeight-20, cameraZPos+cameraAddZPos-20,
          cameraXPos+cameraAddXPos+20, cameraYPos+cameraAddYPos+20, cameraZPos+cameraAddZPos+20)==true) {
          collisionState=true;

          if (freeFly == false) {
            cameraAddYPos = 0;
          }
        }
      }
    }



    for (int i = 0; i<Map.size(); i++) { //For om man er inde i noget
      if (Map.get(i)!=None) {
        if (advcollision(
          Map.get(i)[0]-Map.get(i)[3]/2, Map.get(i)[1]-Map.get(i)[4]/2, Map.get(i)[2]-Map.get(i)[5]/2,
          Map.get(i)[0]+Map.get(i)[3]/2, Map.get(i)[1]+Map.get(i)[4]/2, Map.get(i)[2]+Map.get(i)[5]/2,
          cameraXPos-20, cameraYPos-playerHeight-20, cameraZPos-20,
          cameraXPos+20, cameraYPos+20, cameraZPos+20)==true) {

          collisionState=false;


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

            cameraXPos -= distanceToEdge[0];
          }
          if (distanceToEdge[1]<distanceToEdge[0] &&distanceToEdge[1]<distanceToEdge[2] &&distanceToEdge[1]<distanceToEdge[3]&&distanceToEdge[1]<distanceToEdge[4]&&distanceToEdge[1]<distanceToEdge[5]) {

            cameraXPos += distanceToEdge[1];
          }
          if (distanceToEdge[2]<distanceToEdge[1] &&distanceToEdge[2]<distanceToEdge[0] &&distanceToEdge[2]<distanceToEdge[3]&&distanceToEdge[2]<distanceToEdge[4]&&distanceToEdge[2]<distanceToEdge[5]) {

            cameraZPos -= distanceToEdge[2];
          }
          if (distanceToEdge[3]<distanceToEdge[1] &&distanceToEdge[3]<distanceToEdge[0] &&distanceToEdge[3]<distanceToEdge[2]&&distanceToEdge[3]<distanceToEdge[4]&&distanceToEdge[3]<distanceToEdge[5]) {

            cameraZPos += distanceToEdge[3];
          }

          if (distanceToEdge[4]<distanceToEdge[1] &&distanceToEdge[4]<distanceToEdge[0] &&distanceToEdge[4]<distanceToEdge[3]&&distanceToEdge[4]<distanceToEdge[2]&&distanceToEdge[4]<distanceToEdge[5]) {

            cameraYPos -= distanceToEdge[4];
            if (freeFly == false) {
              cameraAddYPos = 0;
            }
          }
          if (distanceToEdge[5]<distanceToEdge[1] &&distanceToEdge[5]<distanceToEdge[0] &&distanceToEdge[5]<distanceToEdge[2]&&distanceToEdge[5]<distanceToEdge[4]&&distanceToEdge[5]<distanceToEdge[3]) {

            cameraYPos += distanceToEdge[5];
          }
        }
      }
    }



    if ((collisionState)==false) {
      cameraXPos += cameraAddXPos;
      if (freeFly == false) {
        cameraAddYPos += -0.75;
      }
      cameraYPos += cameraAddYPos;
      cameraZPos += cameraAddZPos;
    }




    camera(cameraXPos, cameraYPos, cameraZPos, cameraXPos+cameraViewXPos, cameraYPos+cameraViewYPos, cameraZPos+cameraViewZPos, 0, -1, 0); // Her opdaters kameraet.
  }
