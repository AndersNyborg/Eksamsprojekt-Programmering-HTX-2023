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



  
