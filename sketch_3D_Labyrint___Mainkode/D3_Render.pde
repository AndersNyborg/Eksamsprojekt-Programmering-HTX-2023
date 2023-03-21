class simplified3D {



  float cameraXPos = 0;
  float cameraYPos = 0;
  float cameraZPos = 0;

  float cameraAddXPos = 0;
  float cameraAddYPos = 0;
  float cameraAddZPos = 0;


  float cameraViewXPos = 0;
  float cameraViewYPos = 0;
  float cameraViewZPos = 0;

  float viewAngleX = 0;
  float viewAngleY = 0;

  float playerHeight = 100;
  float jumpHeight = 10;

  boolean freeFly = true;
  int renderDistance = 3000;

  ArrayList<float[]> Map = new ArrayList<float[]>();
  float[] None = new float[0];

  void intiliazesimplified3D(float x, float y, float z, float viewX, float viewY, float viewZ) {
    try {
      robot = new Robot();
    }
    catch (Throwable e) {
    }
    robot.mouseMove(width/2, height/2);

    cameraXPos = x;
    cameraYPos = y;
    cameraZPos = z;


    setView(viewX, viewY, viewZ);


    //noCursor();
    perspective(PI/3.0, (float) width/height, 1, renderDistance);
  }


  IntList controls = new IntList();
  float jumpAdd;
  boolean jumpAbble = false;

  void updateCamera() {


    if (controls.size()==0) { //Hvis ingen knapper holdes nede (Controls listens størrelse er lig med 0), skal der lægges 0 til begge positioner
      cameraAddZPos = 0;
      cameraAddXPos = 0;
      if (freeFly == true) {
        cameraAddYPos = 0;
      }
    } else {
      cameraAddZPos = 0;
      cameraAddXPos = 0;
      if (freeFly == true) {
        cameraAddYPos = 0;
      }





      float averageDivider = 1/float(controls.size()); //Bruges til at kunne finde gennemsnit hvis flere knapper holdes ned samtidig.

      int keyen = ' ';
      for (int i=0; i<controls.size(); i++) { //Kør igennem knapperne der holdes nede

        keyen = controls.get(i); //Få knappen (om det er w,s,a eller d)

        if (keyen==87) {
          cameraAddZPos += movementSpeed*cameraViewZPos*averageDivider; //Først er det movementSpeed * cameraViewZPos (Altså den vej man kigger) * averagedivider (Til hvis der er flere knapper nede samtidig)
          cameraAddXPos += movementSpeed*cameraViewXPos*averageDivider;
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

      //For at kunne hoppe:
      if (freeFly == false) {
        if (jumpAdd >= 0) {
          cameraAddYPos = jumpHeight;
          jumpAdd-=jumpHeight/10;
        }
      }



      if (cameraAddZPos!=0 ||cameraAddXPos!=0) {//Fordi at hvis man fx. holder a og d nede, bliver de begge nul og så fucker det op og multiplier bliver uendelig stort
        float multiplier = (sqrt(pow(movementSpeed, 2)+pow(0, 2))
          /sqrt(pow(cameraAddZPos, 2)+(pow(cameraAddXPos, 2)))); //Her findes hvor stort den nuværende hypotenuse for bevægelsen er ift. hvis den var længst, er 1 ved en enhedscirkel (Dog er det movementspeed istedet).
        cameraAddZPos *=multiplier; //Herefter kan multiplieren ganges på.
        cameraAddXPos *=multiplier;
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

  boolean advcollision(float object1XCo1, float object1YCo1, float object1ZCo1, float object1XCo2, float object1YCo2, float object1ZCo2, float object2XCo1, float object2YCo1, float object2ZCo1, float object2XCo2, float object2YCo2, float object2ZCo2) {
    // Fungere ved at finde centrumspunkter for de to kasser, og dimensionerne på kasserne. Hvis differensen mellem midterpunkterne er mindre, end længden fra midten til siden af kasse + det samme fra den anden kasse er der kollision.

    float[] objectsDim = new float[6];
    objectsDim[0] = object1XCo1-object1XCo2;
    objectsDim[1] = object1YCo1-object1YCo2;
    objectsDim[2] = object1ZCo1-object1ZCo2;

    objectsDim[3] = object2XCo1-object2XCo2;
    objectsDim[4] = object2YCo1-object2YCo2;
    objectsDim[5] = object2ZCo1-object2ZCo2;


    for (int i=0; i<6; i++) { // For at få den numeriske værdi
      if (objectsDim[i]<0) {

        objectsDim[i] *= -1;
      }
    }

    float[] objectsCenterCo = new float[6];
    objectsCenterCo[0] = (object1XCo1+object1XCo2)/2;
    objectsCenterCo[1] = (object1YCo1+object1YCo2)/2;
    objectsCenterCo[2] = (object1ZCo1+object1ZCo2)/2;

    objectsCenterCo[3] = (object2XCo1+object2XCo2)/2;
    objectsCenterCo[4] = (object2YCo1+object2YCo2)/2;
    objectsCenterCo[5] = (object2ZCo1+object2ZCo2)/2;

    float[] objectCenterCoDifference = new float[3];
    objectCenterCoDifference[0] = objectsCenterCo[0]-objectsCenterCo[3];
    objectCenterCoDifference[1] = objectsCenterCo[1]-objectsCenterCo[4];
    objectCenterCoDifference[2] = objectsCenterCo[2]-objectsCenterCo[5];

    for (int i=0; i<3; i++) {
      if (objectCenterCoDifference[i]<0) { // For at få den numeriske værdi
        objectCenterCoDifference[i] *= -1;
      }
    }


    if (objectsDim[0]/2+objectsDim[3]/2>=objectCenterCoDifference[0]) { //Test for x
      if (objectsDim[1]/2+objectsDim[4]/2>=objectCenterCoDifference[1]) { //Test for y
        if (objectsDim[2]/2+objectsDim[5]/2>=objectCenterCoDifference[2]) { //Test for x
          return true;
        }
      }
    }


    return false;
  }
  boolean collision(int object1, int object2) {
    if (Map.get(object1)==None||Map.get(object2)==None) {
      return false;
    }
    if (advcollision(
      Map.get(object1)[0]-Map.get(object1)[3]/2, Map.get(object1)[1]-Map.get(object1)[4]/2, Map.get(object1)[2]-Map.get(object1)[5]/2,
      Map.get(object1)[0]+Map.get(object1)[3]/2, Map.get(object1)[1]+Map.get(object1)[4]/2, Map.get(object1)[2]+Map.get(object1)[5]/2,
      Map.get(object2)[0]-Map.get(object2)[3]/2, Map.get(object2)[1]-Map.get(object2)[4]/2, Map.get(object2)[2]-Map.get(object2)[5]/2,
      Map.get(object2)[0]+Map.get(object2)[3]/2, Map.get(object2)[1]+Map.get(object2)[4]/2, Map.get(object2)[2]+Map.get(object2)[5]/2)==true) {
      return true;
    }
    return false;
  }





  void simplified3DkeyPressed() {
    //Tilføj knappen der er trykket ned til listen over keys der er trykket ned samtidig.
    controls.append(keyCode);
  }


  void simplified3DkeyReleased() {
    //Når en knap er released, skal den fjernes fra listen af keys der er trykket ned samtidig.
    for (int i=0; i<controls.size(); i++) {
      if (controls.get(i)==keyCode) {
        controls.remove(i);
      }
    }
  }



  void simplified3DmouseMoved() {
    if (frameCount>1) { //Fordi den ellers tager med før den har haft mulighed for at få mussen ned i hjørnet.

      float deltaX = width/2-mouseX;
      float deltaY = height/2-mouseY;



      //Få y vinkel fra -90 til 90 hvor højt man kigger
      viewAngleY += deltaY/(mouseSensivety);


      if (viewAngleY>87||viewAngleY<-87) { //Sørge for man ikke kan gå hele vejen over midten
        if (viewAngleY>87) {
          viewAngleY=87;
        }
        if (viewAngleY<-87) {
          viewAngleY=-87;
        }
      }


      cameraViewYPos = sin(radians(viewAngleY)); //Få lavet til på enhedscirklen


      //Få x vinkel fra 0 til 360
      viewAngleX = (viewAngleX+deltaX/mouseSensivety)%360;

      if (viewAngleX<0) { //Sørge for det ikke bliver -10 med 350 grader
        viewAngleX = 360-(-1*viewAngleX);
      }

      cameraViewZPos = sin(radians(viewAngleX)); //Få lavet Z pos, hvor at det er indregnet at hvis y er høj, skal værdien være lav.
      cameraViewXPos = cos(radians(viewAngleX)); //Få lavet X pos, hvor at det er indregnet at hvis y er høj, skal værdien være lav.

      float test = sqrt(-1*(pow(cameraViewYPos, 2)-1)*(pow(cameraViewXPos, 2)+pow(cameraViewZPos, 2)))/(pow(cameraViewYPos, 2)-1);

      cameraViewXPos /= test;
      cameraViewZPos /= test;




      robot.mouseMove(width/2, height/2); //Sæt cursor tilbage til midten efter bevægelse.
    }
  }

  int objectBoxAddition(float objectXPos, float objectYPos, float objectZPos, float objectXDim, float objectYDim, float objectZDim, float fillr, float fillg, float fillb, float stroke) {
    //Her tilføjes en stringlist med et objekt altså kasse eller sådan.
    float[] Genstand = new float[10];
    Genstand[0] = objectXPos;
    Genstand[1] = objectYPos;
    Genstand[2] = objectZPos;
    Genstand[3] = objectXDim;
    Genstand[4] = objectYDim;
    Genstand[5] = objectZDim;
    Genstand[6] = fillr;
    Genstand[7] = fillg;
    Genstand[8] = fillb;
    Genstand[9] = stroke;


    Map.add(Genstand);

    return Map.size()-1;
  }


  void drawObejcts() {
    //Her bliver objekterne "tegnet" efter den angivne map.
    pointLight(255, 255, 255, cameraXPos, cameraYPos, cameraZPos); //Standard belysning
    for (int i=0; i<Map.size(); i++) {
      if (Map.get(i)!=None) {
        pushMatrix();

        //Fill (Farve)
        fill(Map.get(i)[6], Map.get(i)[7], Map.get(i)[8]);

        //Position via translate
        translate(Map.get(i)[0], Map.get(i)[1], Map.get(i)[2]);

        //Stroke
        if (Map.get(i)[9]<1) {
          noStroke();
        } else {
          stroke(Map.get(i)[9]);
        }


        box(Map.get(i)[3], Map.get(i)[4], Map.get(i)[5]); //Danne box


        popMatrix();
      }
    }
  }

  void deleteObject(int integer) {
    Map.set(integer, None); //Sætter indekset til float[] None jeg har lavet.
  }



  float objectInfo(int integer, String variable) {
    if (Map.get(integer)==None){
     return 0; 
    }
    
    //Alt nedenunder gør egentlig bare at den ser hvad indekset er for den variabel man vil ændre, og ændre det derefter.
    StringList valuesForObject = new StringList();
    valuesForObject.append("xPos");
    valuesForObject.append("yPos");
    valuesForObject.append("zPos");
    valuesForObject.append("xDim");
    valuesForObject.append("yDim");
    valuesForObject.append("zDim");
    valuesForObject.append("fillr");
    valuesForObject.append("fillg");
    valuesForObject.append("fillb");
    valuesForObject.append("stroke");

    int index = 0;
    for (int i = 0; i<valuesForObject.size(); i++) {

      if ( valuesForObject.get(i)==variable) {
        index = i;
      }
    }
  

    return(Map.get(integer)[index]);
  }

  void changeObject(int integer, String variable, float newValue) {
    //if (Map.get(integer)==None){
    // return; 
    //}
    
    float[] oldInfo = Map.get(integer);

    //Alt nedenunder gør egentlig bare at den ser hvad indekset er for den variabel man vil ændre, og ændre det derefter.
    StringList valuesForObject = new StringList();
    valuesForObject.append("xPos");
    valuesForObject.append("yPos");
    valuesForObject.append("zPos");
    valuesForObject.append("xDim");
    valuesForObject.append("yDim");
    valuesForObject.append("zDim");
    valuesForObject.append("fillr");
    valuesForObject.append("fillg");
    valuesForObject.append("fillb");
    valuesForObject.append("stroke");

    int index = 0;
    for (int i = 0; i<valuesForObject.size(); i++) {

      if ( valuesForObject.get(i)==variable) {
        index = i;
      }
    }

    oldInfo[index] = newValue;
    Map.set(integer, oldInfo);
  }
  void setView(float viewXCo, float viewYCo, float viewZCo) {
    PVector cameraHeading = new PVector(viewXCo-cameraXPos, viewYCo-cameraYPos, viewZCo-cameraZPos);
    cameraHeading.normalize();

    cameraViewXPos = cameraHeading.x;
    cameraViewYPos = cameraHeading.y;
    cameraViewZPos = cameraHeading.z;

    viewAngleY = degrees(asin(cameraHeading.y));

    viewAngleX = degrees(asin(cameraHeading.z));


    //Alt nedenunder er fordi asin kun kan give fra 90 til -90 grader.
    if (cameraHeading.z>=0&&cameraHeading.x>0) {
      viewAngleX= viewAngleX+180;
    }
    if (cameraHeading.z<0&&cameraHeading.x>=0) {
      viewAngleX=(90-(-1*viewAngleX))+90;
      
    }
    if (cameraHeading.z>=0&&cameraHeading.x<=0) {
      viewAngleX = (360-viewAngleX);
      
    }
    if (cameraHeading.z<0&&cameraHeading.x<0) {
      viewAngleX = -1*viewAngleX;
      
    }
   
  }

  void freeFlyMode(boolean wantedState) {
    freeFly = wantedState;
  }
  void changePlayerHeight(float wantedHeight) {
    playerHeight = wantedHeight;
  }

  int objectInLine(float centerX, float centerY, float centerZ, float centerHeadingX, float centerHeadingY, float centerHeadingZ, float checkLength) {
    ArrayList<PVector> checkCoords = new ArrayList<PVector>();

    PVector centerVector = new PVector(centerX, centerY, centerZ);
    checkCoords.add(centerVector);


    PVector helperOuterCheckVector = new PVector(centerHeadingX-centerX, centerHeadingY-centerY, centerHeadingZ-centerZ);
    helperOuterCheckVector.normalize();
    helperOuterCheckVector.mult(checkLength);


    PVector outerCheckVector = new PVector(centerX+helperOuterCheckVector.x, centerY+helperOuterCheckVector.y, centerZ+helperOuterCheckVector.z);

    checkCoords.add(outerCheckVector);


    //objectBoxAddition(outerCheckVector.x,outerCheckVector.y,outerCheckVector.z,100,100,100,255,0,0,0);
    IntList checkObjects = new IntList();
    for (int i=0; i<Map.size(); i++) {
      if (Map.get(i)!=None) {
        checkObjects.append(i);
      }
    }


    while (checkObjects.size()>0) {

      IntList newCheckObjects = new IntList();
      ArrayList<PVector> newCheckCoords = new ArrayList<PVector>();
      //println("checkCoords: "+checkCoords);
      //println("checkObjects: "+checkObjects);

      for (int vectorI= 0; vectorI<checkCoords.size(); vectorI=vectorI+2) {
        //Brug det her nedenunder for at vise hvordan det fungerer.
        //objectBoxAddition(checkCoords.get(vectorI).x, checkCoords.get(vectorI).y, checkCoords.get(vectorI).z, 100, 100, 100, 255, 0, 0, 0);
        //objectBoxAddition(checkCoords.get(vectorI+1).x, checkCoords.get(vectorI+1).y, checkCoords.get(vectorI+1).z, 100, 100, 100, 255, 0, 0, 0);
        boolean objectsInsideCheckCoords = false;
        for (int i=0; i<checkObjects.size(); i++) {
          if (advcollision(
            Map.get(checkObjects.get(i))[0]-Map.get(checkObjects.get(i))[3]/2, Map.get(checkObjects.get(i))[1]-Map.get(checkObjects.get(i))[4]/2, Map.get(checkObjects.get(i))[2]-Map.get(checkObjects.get(i))[5]/2,
            Map.get(checkObjects.get(i))[0]+Map.get(checkObjects.get(i))[3]/2, Map.get(checkObjects.get(i))[1]+Map.get(checkObjects.get(i))[4]/2, Map.get(checkObjects.get(i))[2]+Map.get(checkObjects.get(i))[5]/2,
            checkCoords.get(vectorI).x, checkCoords.get(vectorI).y, checkCoords.get(vectorI).z,
            checkCoords.get(vectorI+1).x, checkCoords.get(vectorI+1).y, checkCoords.get(vectorI+1).z)==true) {
            newCheckObjects.append(checkObjects.get(i));

            objectsInsideCheckCoords=true;
          }
        }

        if (objectsInsideCheckCoords==true) {




          PVector newInnerVector = new PVector(checkCoords.get(vectorI).x, checkCoords.get(vectorI).y, checkCoords.get(vectorI).z);
          PVector newMiddleVector = new PVector(checkCoords.get(vectorI).x+(checkCoords.get(vectorI+1).x-checkCoords.get(vectorI).x)/2, checkCoords.get(vectorI).y+(checkCoords.get(vectorI+1).y-checkCoords.get(vectorI).y)/2, checkCoords.get(vectorI).z+(checkCoords.get(vectorI+1).z-checkCoords.get(vectorI).z)/2);
          PVector newOuterVector = new PVector(checkCoords.get(vectorI+1).x, checkCoords.get(vectorI+1).y, checkCoords.get(vectorI+1).z);
          newCheckCoords.add(newInnerVector);
          newCheckCoords.add(newMiddleVector);
          newCheckCoords.add(newMiddleVector);
          newCheckCoords.add(newOuterVector);



          float checkSize = ((newInnerVector.x-newMiddleVector.x+newInnerVector.y-newMiddleVector.y+newInnerVector.z-newMiddleVector.z)/3);
          if (checkSize<0) {
            checkSize*=-1;
          }

          if (checkSize<1) {
            //Find vektor
   
            
            PVector reverseLookingDirection = new PVector(centerHeadingX, centerHeadingY, centerHeadingZ);
            reverseLookingDirection.normalize();
            println(reverseLookingDirection);
            reverseLookingDirection.mult(-1);
            println(reverseLookingDirection);
            //PVector reverseLookingDirection = outerCheckVector;
            //reverseLookingDirection.normalize();
            //reverseLookingDirection.mult(-1);
            
            //Lav koordinater til checking
            println(Map.get(newCheckObjects.get(0)));
            PVector sideCheckingCoords = new PVector(Map.get(newCheckObjects.get(0))[0], Map.get(newCheckObjects.get(0))[1], Map.get(newCheckObjects.get(0))[2]);
            
            int testCounter = 0;
            while (1==1) {
              testCounter++;
              if (advcollision(//Check om det minus vektoren giver igen kollision med boksen
            Map.get(newCheckObjects.get(0))[0]-Map.get(newCheckObjects.get(0))[3]/2, Map.get(newCheckObjects.get(0))[1]-Map.get(newCheckObjects.get(0))[4]/2, Map.get(newCheckObjects.get(0))[2]-Map.get(newCheckObjects.get(0))[5]/2,
            Map.get(newCheckObjects.get(0))[0]+Map.get(newCheckObjects.get(0))[3]/2, Map.get(newCheckObjects.get(0))[1]+Map.get(newCheckObjects.get(0))[4]/2, Map.get(newCheckObjects.get(0))[2]+Map.get(newCheckObjects.get(0))[5]/2,
            sideCheckingCoords.x-0.1+reverseLookingDirection.x, sideCheckingCoords.y-0.1+reverseLookingDirection.y, sideCheckingCoords.z-0.1+reverseLookingDirection.z,
            sideCheckingCoords.x+0.1+reverseLookingDirection.x, sideCheckingCoords.y+0.1+reverseLookingDirection.y, sideCheckingCoords.z+0.1+reverseLookingDirection.z)==false){
              
              //Hvis ja så er det koordinaterne.
              objectBoxAddition(sideCheckingCoords.x, sideCheckingCoords.y, sideCheckingCoords.z, 5, 5, 5, 255, 0, 0, 0);
              println("hej");
              
             
            }
               //Hvis ikke så plus vektoren
              
               sideCheckingCoords.add(reverseLookingDirection);
               
               
              objectBoxAddition(sideCheckingCoords.x, sideCheckingCoords.y, sideCheckingCoords.z, 5, 5, 5, 255, 0, 0, 0);
              
              if (testCounter==30){
               break; 
              }
            }
            return  newCheckObjects.get(0);
          }
        }
      }
      //println("checkCoords: "+newCheckCoords);
      //println("checkObjects: "+ newCheckObjects);

      checkCoords = newCheckCoords;
      checkObjects = newCheckObjects;

      //println("checkCoords: " +checkCoords);
      //println("checkObjects.size():" +checkObjects.size());
    }


    return 100;
  }

  int lookingAt() {
    return objectInLine(cameraXPos, cameraYPos, cameraZPos, cameraViewXPos+cameraXPos, cameraViewYPos+cameraYPos, cameraViewZPos+cameraZPos, float(renderDistance));
  }
  
  boolean objectExist(int index){
    if (Map.get(index)==None){
     return false;
    }
    return true;
  }
}
