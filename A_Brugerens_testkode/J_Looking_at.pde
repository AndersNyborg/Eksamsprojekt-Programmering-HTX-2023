

int objectInLine(float centerX, float centerY, float centerZ, float centerHeadingX, float centerHeadingY, float centerHeadingZ, float checkLength) {
  ArrayList<PVector> checkCoords = createStartingCoords( centerX, centerY, centerZ, centerHeadingX, centerHeadingY, centerHeadingZ, checkLength); //Danneren arrayliste med PVector hvor man er, plus et koordinat med hvor man kigger hen gange med renderDistance
  IntList checkObjects = createStartingObjects(); //Laver en liste med alle de objektor som eksistere lige nu.

  while (checkObjects.size()>0) { //Mens at der stadig er objekter at undersøge.

    IntList newCheckObjects = new IntList(); //Lav ny midlertidig checkObjects så der ikke sker interferens med den gamle
    ArrayList<PVector> newCheckCoords = new ArrayList<PVector>();//Lav ny midlertidig checkCoords så der ikke sker interferens med den gamle


    for (int vectorI= 0; vectorI<checkCoords.size(); vectorI=vectorI+2) { //Gør igennem hver koordinatsæt for hvad der skal tjekkes.

      for (int i=0; i<checkObjects.size(); i++) { //Der rendes igennem alle de objektor der skal tjekkes.
        if (isObjectInsideboundary(checkObjects.get(i), vectorI, checkCoords)==true) { //Hvis at objektet er indefor afgrænsnignen af det koordinatsæt der tjekkes for
          newCheckObjects.append(checkObjects.get(i)); //bliver objektet tilføjet til hvad der også skal tjekkes næste gang.
        }
      }


      if (newCheckObjects.size()>0) { //Hvis der stadig er objektor indenfor afgrænsningen
        float checkSize = ((checkCoords.get(vectorI).x-checkCoords.get(vectorI+1).x+checkCoords.get(vectorI).y-checkCoords.get(vectorI+1).y+checkCoords.get(vectorI).z-checkCoords.get(vectorI+1).z)/3);
        checkSize = makeNumerical(checkSize); //Ovenover samt her bliver der beregnet for stor afgræsningen er.

        if (checkSize<1) { //Hvis afgrænsningsstørrelsen er mindre end 1, skal funktionen retunere svaret.
          objectBoxAddition(checkCoords.get(vectorI).x, checkCoords.get(vectorI).y, checkCoords.get(vectorI).z, 5, 5, 5, 0, 255, 0, 0);
          finishLookingAt = false;
          return  newCheckObjects.get(0); //HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHEEEEEEEEEEEEEEEEEEEEEEEEEEERRRRRRRRRRRRRRR der skal tilføjes så  jeg kan finde hvilket side er på.
        } else { //Ellers skal afgrænsnigen blive halveret:


          PVector newInnerVector = new PVector(checkCoords.get(vectorI).x, checkCoords.get(vectorI).y, checkCoords.get(vectorI).z); //Den første del af koordinatsættet for hvor der er undersøgt.
          PVector newMiddleVector = new PVector(checkCoords.get(vectorI).x+(checkCoords.get(vectorI+1).x-checkCoords.get(vectorI).x)/2, checkCoords.get(vectorI).y+(checkCoords.get(vectorI+1).y-checkCoords.get(vectorI).y)/2, checkCoords.get(vectorI).z+(checkCoords.get(vectorI+1).z-checkCoords.get(vectorI).z)/2);//Midt imellem de to koordinater
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

  finishLookingAt = false;
  return 100; //Retunere hvis der ikke bliver set noget.
}
boolean finishLookingAt = true;
int lookingAt() {
  if (finishLookingAt==false) {
    finishLookingAt = true;
    return objectInLine(cameraXPos, cameraYPos, cameraZPos, cameraViewXPos+cameraXPos, cameraViewYPos+cameraYPos, cameraViewZPos+cameraZPos, float(renderDistance)); //For at gøre det lettere for brugeren at broge funktionen
  }
  return 0;
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------------------------------------Hjælpefunktioner------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
boolean isObjectInsideboundary(int object1, int object2, ArrayList<PVector> object2List) {
  if (advcollision(
    Map.get(object1)[0]-Map.get(object1)[3]/2, Map.get(object1)[1]-Map.get(object1)[4]/2, Map.get(object1)[2]-Map.get(object1)[5]/2,
    Map.get(object1)[0]+Map.get(object1)[3]/2, Map.get(object1)[1]+Map.get(object1)[4]/2, Map.get(object1)[2]+Map.get(object1)[5]/2,
    object2List.get(object2).x, object2List.get(object2).y, object2List.get(object2).z,
    object2List.get(object2+1).x, object2List.get(object2+1).y, object2List.get(object2+1).z)==true) {
    return true;
  }
  return false;
}

ArrayList<PVector> createStartingCoords(float centerX, float centerY, float centerZ, float centerHeadingX, float centerHeadingY, float centerHeadingZ, float checkLength) {
  ArrayList<PVector> calcCheckCoords = new ArrayList<PVector>();

  PVector centerVector = new PVector(centerX, centerY, centerZ);
  calcCheckCoords.add(centerVector);


  PVector helperOuterCheckVector = new PVector(centerHeadingX-centerX, centerHeadingY-centerY, centerHeadingZ-centerZ);
  helperOuterCheckVector.normalize();
  helperOuterCheckVector.mult(checkLength);


  PVector outerCheckVector = new PVector(centerX+helperOuterCheckVector.x, centerY+helperOuterCheckVector.y, centerZ+helperOuterCheckVector.z);

  calcCheckCoords.add(outerCheckVector);

  return calcCheckCoords;
}
IntList createStartingObjects() {

  IntList calcCheckObjects = new IntList();
  for (int i=0; i<Map.size(); i++) {
    if (Map.get(i)!=None) {
      calcCheckObjects.append(i);
    }
  }
  return calcCheckObjects;
}
