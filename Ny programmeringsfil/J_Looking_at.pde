int[] objectInLine(float centerX, float centerY, float centerZ, float centerHeadingX, float centerHeadingY, float centerHeadingZ, float checkLength) {
  ArrayList<PVector> checkCoords = createStartingCoords( centerX, centerY, centerZ, centerHeadingX, centerHeadingY, centerHeadingZ, checkLength); //Danneren arrayliste med PVector hvor man er, plus et koordinat med hvor man kigger hen gange med renderDistance
  IntList checkObjects = createStartingObjects(); //Laver en liste med alle de objektor som eksistere lige nu.
  int[] returnList = new int[5];
  returnList[0]=0; //Om der er et objekt eller ej alltså 0 eller 1
  returnList[1]=0; //Hvilket objekt det er
  returnList[2]=0; //Om det er af X-aksen man har trykket
  returnList[3]=0;//Om det er af y-aksen man har trykket
  returnList[4]=0;//Om det er af Z-aksen man har trykket

  while (checkObjects.size()>0) { //Mens at der stadig er objekter at undersøge.

    IntList newCheckObjects = new IntList(); //Lav ny midlertidig checkObjects så der ikke sker interferens med den gamle
    ArrayList<PVector> newCheckCoords = new ArrayList<PVector>();//Lav ny midlertidig checkCoords så der ikke sker interferens med den gamle


if (checkObjects.size()<100){

}
    for (int vectorI= 0; vectorI<checkCoords.size(); vectorI=vectorI+2) { //Gør igennem hver koordinatsæt for hvad der skal tjekkes.
  
      
      for (int i=0; i<checkObjects.size(); i++) { //Der rendes igennem alle de objektor der skal tjekkes.
        if (isObjectInsideboundary(checkObjects.get(i), vectorI, checkCoords)==true) { //Hvis at objektet er indefor afgrænsnignen af det koordinatsæt der tjekkes for
          boolean objectAlreadyinList = false; //Checker om objektet allerede er i listen
          for (int objectIndex = 0;newCheckObjects.size()>objectIndex;objectIndex++){
            if (newCheckObjects.get(objectIndex)==checkObjects.get(i)){
              objectAlreadyinList=true;
            }
          }
          if (objectAlreadyinList==false){ //Hvis objektet ikke allerede er i listen
          newCheckObjects.append(checkObjects.get(i)); //bliver objektet tilføjet til hvad der også skal tjekkes næste gang.
          }
          
        }
      }


      if (newCheckObjects.size()>0) { //Hvis der stadig er objektor indenfor afgrænsningen
        float checkSize = (sqrt(pow(checkCoords.get(vectorI).x-checkCoords.get(vectorI+1).x,2)+pow(checkCoords.get(vectorI).y-checkCoords.get(vectorI+1).y,2)+pow(checkCoords.get(vectorI).z-checkCoords.get(vectorI+1).z,2)));
        checkSize = makeNumerical(checkSize); //Ovenover samt her bliver der beregnet for stor afgræsningen er.

        if (checkSize<1) { //Hvis afgrænsningsstørrelsen er mindre end 1, skal funktionen retunere svaret.
          //objectBoxAddition(checkCoords.get(vectorI).x, checkCoords.get(vectorI).y, checkCoords.get(vectorI).z, 5, 5, 5, 0, 255, 0, 0);
          int[] sideOfBlockCoords = sideOfBlock(objectInfo(newCheckObjects.get(0), "xPos")-objectInfo(newCheckObjects.get(0), "xDim")/2, objectInfo(newCheckObjects.get(0), "yPos")-objectInfo(newCheckObjects.get(0), "yDim")/2, objectInfo(newCheckObjects.get(0), "zPos")-objectInfo(newCheckObjects.get(0), "zDim")/2,
            objectInfo(newCheckObjects.get(0), "xPos")+objectInfo(newCheckObjects.get(0), "xDim")/2, objectInfo(newCheckObjects.get(0), "yPos")+objectInfo(newCheckObjects.get(0), "yDim")/2, objectInfo(newCheckObjects.get(0), "zPos")+objectInfo(newCheckObjects.get(0), "zDim")/2,
            checkCoords.get(vectorI).x, checkCoords.get(vectorI).y, checkCoords.get(vectorI).z);
          returnList[0]=1;
          returnList[1]=newCheckObjects.get(0);
          returnList[2]=sideOfBlockCoords[0];
          returnList[3]=sideOfBlockCoords[1];
          returnList[4]=sideOfBlockCoords[2];

          return returnList;
        } else { //Ellers skal afgrænsnigen blive halveret:


          PVector newInnerVector = new PVector(checkCoords.get(vectorI).x, checkCoords.get(vectorI).y, checkCoords.get(vectorI).z); //Den første del af koordinatsættet for hvor der er undersøgt.
          //PVector newMiddleVector = new PVector(checkCoords.get(vectorI).x+(checkCoords.get(vectorI+1).x-checkCoords.get(vectorI).x)/2, checkCoords.get(vectorI).y+(checkCoords.get(vectorI+1).y-checkCoords.get(vectorI).y)/2, checkCoords.get(vectorI).z+(checkCoords.get(vectorI+1).z-checkCoords.get(vectorI).z)/2);//Midt imellem de to koordinater
          PVector newMiddleVector = new PVector((checkCoords.get(vectorI).x+checkCoords.get(vectorI+1).x)/2, (checkCoords.get(vectorI).y+checkCoords.get(vectorI+1).y)/2, (checkCoords.get(vectorI).z+checkCoords.get(vectorI+1).z)/2);//Midt imellem de to koordinater
          PVector newOuterVector = new PVector(checkCoords.get(vectorI+1).x, checkCoords.get(vectorI+1).y, checkCoords.get(vectorI+1).z);//Den sidste del af koordinatsættet for hvor der er undersøgt.
          newCheckCoords.add(newInnerVector); //Første del af første koordinatsæt til næste gennemgang
          newCheckCoords.add(newMiddleVector);//anden del af første koordinatsæt til næste gennemgang
          newCheckCoords.add(newMiddleVector);//Første del af anden koordinatsæt til næste gennemgang
          newCheckCoords.add(newOuterVector);//anden del af anden koordinatsæt til næste gennemgang
        }
      }
    }


    checkCoords = newCheckCoords; //Værdierne bliver erstattet af de nye beregnede værdier.
    checkObjects = newCheckObjects;
  }


  return returnList; //Retunere hvis der ikke bliver set noget.
}
boolean finishLookingAt = true;
int[] lookingAt() {

  return objectInLine(cameraXPos, cameraYPos, cameraZPos, cameraViewXPos+cameraXPos, cameraViewYPos+cameraYPos, cameraViewZPos+cameraZPos, float(renderDistance)); //For at gøre det lettere for brugeren at broge funktionen
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------Hjælpefunktioner------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
boolean isObjectInsideboundary(int object1, int object2, ArrayList<PVector> object2List) {
  if (advcollision(
    objectInfo(object1, "xPos")-objectInfo(object1, "xDim")/2, objectInfo(object1, "yPos")-objectInfo(object1, "yDim")/2, objectInfo(object1, "zPos")-objectInfo(object1, "zDim")/2, //Udregn hjørnet
    objectInfo(object1, "xPos")+objectInfo(object1, "xDim")/2, objectInfo(object1, "yPos")+objectInfo(object1, "yDim")/2, objectInfo(object1, "zPos")+objectInfo(object1, "zDim")/2,
    object2List.get(object2).x, object2List.get(object2).y, object2List.get(object2).z,
    object2List.get(object2+1).x, object2List.get(object2+1).y, object2List.get(object2+1).z)==true) {
    return true;
  }
  return false;
}

ArrayList<PVector> createStartingCoords(float centerX, float centerY, float centerZ, float centerHeadingX, float centerHeadingY, float centerHeadingZ, float checkLength) {
  ArrayList<PVector> calcCheckCoords = new ArrayList<PVector>(); //Laver en liste som skal indeholde koordinater for afgrænsninger for hvad der skal tjekkes.

  PVector centerVector = new PVector(centerX, centerY, centerZ); //Danner centervektoren, altså hvor man står.
  calcCheckCoords.add(centerVector); //Og tilføjer den som første koordinat, af et koordinatsæt som skal tjekkes som afgræsning


  PVector helperOuterCheckVector = new PVector(centerHeadingX-centerX, centerHeadingY-centerY, centerHeadingZ-centerZ); //Bliver bestemt hvilken retning man kigger (Uden at tage hensyn med hvorfra)
  helperOuterCheckVector.normalize(); //Laver vektoren om til en størrelse på 1
  helperOuterCheckVector.mult(checkLength); //Og ganger den med hvor langt man vil tjekke


  PVector outerCheckVector = new PVector(centerX+helperOuterCheckVector.x, centerY+helperOuterCheckVector.y, centerZ+helperOuterCheckVector.z); //Danner herefter anden koordinat, som er del af koordinatsæt, som er hvor man er plus den vej man kigger.

  calcCheckCoords.add(outerCheckVector); //Tilføjer den til hvad der skal tjekkes af afgræsning

  return calcCheckCoords; //Retunere afgrænsningsværdierne.
}
IntList createStartingObjects() {
  //Denne funktion tilføjer alle blokke der eksistere til en intliste og retunere den.
  IntList calcCheckObjects = new IntList();
  for (int i=0; i<Map.size(); i++) {
    if (Map.get(i)!=None) {
      calcCheckObjects.append(i);
    }
  }
  return calcCheckObjects;
}
