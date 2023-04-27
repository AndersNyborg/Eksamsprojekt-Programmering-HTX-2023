void drawObejcts() {


    //Her bliver objekterne "tegnet" efter den angivne map.
    
    
    pointLight(255, 255, 255, cameraXPos, cameraYPos, cameraZPos); //Standard belysning
    background(255);
    for (int i=0; i<Map.size(); i++) {
      if (objectExist(i)==true) {
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
