void setView(float viewXCo, float viewYCo, float viewZCo) {
    PVector cameraHeading = new PVector(viewXCo-cameraXPos, viewYCo-cameraYPos, viewZCo-cameraZPos); //Lave en vektor fra hvor man er til hvor man vil kigge hen.
    cameraHeading.normalize(); //Lav vektoren om til en længde på 1.

    cameraViewXPos = cameraHeading.x; //Sæt viewet til man kigger hen.
    cameraViewYPos = cameraHeading.y;
    cameraViewZPos = cameraHeading.z;

    viewAngleY = degrees(asin(cameraHeading.y)); //Beregn hvad viewangle Y skal være

    viewAngleX = degrees(asin(cameraHeading.z)); //Beregn hcad viewangleX skal være, der skal ikke både bruges cameraHeading.z og cameraHeading.x, da de begge normalt er baseret på viewAngleX.


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



  
