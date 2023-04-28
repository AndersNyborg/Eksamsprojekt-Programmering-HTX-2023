void drawObejcts() {


    //Her bliver objekterne "tegnet" efter den angivne map.
    
    
    pointLight(255, 255, 255, cameraXPos, cameraYPos, cameraZPos); //Standard belysning
    background(255);
    for (int i=0; i<Map.size(); i++) {
      if (objectExist(i)==true) {
        pushMatrix();

        //Fill (Farve)
        fill(objectInfo(i,"fillr"), objectInfo(i,"fillg"), objectInfo(i,"fillb"));

        //Position via translate
        translate(objectInfo(i,"xPos"), objectInfo(i,"yPos"), objectInfo(i,"zPos"));

        //Stroke
        if (objectInfo(i,"stroke")<1) {
          noStroke();
        } else {
          stroke(objectInfo(i,"stroke"));
        }


        box(objectInfo(i,"xDim"), objectInfo(i,"yDim"),objectInfo(i,"zDim")); //Danne box


        popMatrix();
      }
    }
   
    
//for (int i=0; i<MapNoCollision.size(); i++) {
   
//        pushMatrix();

//        //Fill (Farve)
//        fill(MapNoCollision.get(i)[6], MapNoCollision.get(i)[7], MapNoCollision.get(i)[8]);

//        //Position via translate
//        translate(MapNoCollision.get(i)[0], MapNoCollision.get(i)[1], MapNoCollision.get(i)[2]);

//        //Stroke
//        if (MapNoCollision.get(i)[9]<1) {
//          noStroke();
//        } else {
//          stroke(MapNoCollision.get(i)[9]);
//        }


//        box(MapNoCollision.get(i)[3], MapNoCollision.get(i)[4], MapNoCollision.get(i)[5]); //Danne box


//        popMatrix();
      
//    }
      
  }
