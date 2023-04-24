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
    float textX = 0;
    float textY = 0;
    float textZ = 0;

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
            textX = checkCoords.get(vectorI).x;
            textY = checkCoords.get(vectorI).y;
            textZ = checkCoords.get(vectorI).z;
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


            PVector reverseLookingDirection = new PVector(centerHeadingX-centerX, centerHeadingY-centerY, centerHeadingZ-centerZ);
            reverseLookingDirection.normalize();

            reverseLookingDirection.mult(-1);


            //FIND HVILKEN SIDE:

            //PVector sideCheckingCoords = new PVector(Map.get(newCheckObjects.get(0))[0], Map.get(newCheckObjects.get(0))[1], Map.get(newCheckObjects.get(0))[2]);
            PVector sideCheckingCoords = new PVector(textX, textY, textZ);


            int testCounter = 0;
            while (true) {
              testCounter++;
              if (advcollision(//Check om det minus vektoren giver igen kollision med boksen
                Map.get(newCheckObjects.get(0))[0]-Map.get(newCheckObjects.get(0))[3]/2, Map.get(newCheckObjects.get(0))[1]-Map.get(newCheckObjects.get(0))[4]/2, Map.get(newCheckObjects.get(0))[2]-Map.get(newCheckObjects.get(0))[5]/2,
                Map.get(newCheckObjects.get(0))[0]+Map.get(newCheckObjects.get(0))[3]/2, Map.get(newCheckObjects.get(0))[1]+Map.get(newCheckObjects.get(0))[4]/2, Map.get(newCheckObjects.get(0))[2]+Map.get(newCheckObjects.get(0))[5]/2,
                sideCheckingCoords.x-0.1+reverseLookingDirection.x, sideCheckingCoords.y-0.1+reverseLookingDirection.y, sideCheckingCoords.z-0.1+reverseLookingDirection.z,
                sideCheckingCoords.x+0.1+reverseLookingDirection.x, sideCheckingCoords.y+0.1+reverseLookingDirection.y, sideCheckingCoords.z+0.1+reverseLookingDirection.z)==false) {

                //Hvis false så er det koordinaterne.
                //objectBoxAddition(sideCheckingCoords.x, sideCheckingCoords.y, sideCheckingCoords.z, 5, 5, 5, 255, 0, 0, 0);
                break;
              } else {//Hvis ikke så plus vektoren
                sideCheckingCoords.add(reverseLookingDirection);

                if (testCounter==30) { //For en sikkerhedskyld
                  break;
                }
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

  boolean objectExist(int index) {
    if (Map.get(index)==None) {
      return false;
    }
    return true;
  }
