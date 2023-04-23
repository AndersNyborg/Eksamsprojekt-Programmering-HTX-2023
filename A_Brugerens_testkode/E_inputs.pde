IntList controls = new IntList();
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

      cameraViewZPos = sin(radians(viewAngleX)); //Få lavet til enhedscirklen.
      cameraViewXPos = cos(radians(viewAngleX)); //Få lavet til enhedscirklen.

      float divider = sqrt(-1*(pow(cameraViewYPos, 2)-1)*(pow(cameraViewXPos, 2)+pow(cameraViewZPos, 2)))/(pow(cameraViewYPos, 2)-1); //Formlen for dette kan ses i beregningerne

      cameraViewXPos /= divider;//Formlen for dette kan ses i beregningerne
      cameraViewZPos /= divider;//Formlen for dette kan ses i beregningerne




      robot.mouseMove(width/2, height/2); //Sæt cursor tilbage til midten efter bevægelse.
    }
  }
