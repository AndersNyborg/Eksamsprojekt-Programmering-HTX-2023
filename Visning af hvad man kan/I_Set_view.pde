void setView(float viewXCo, float viewYCo, float viewZCo) {
  PVector cameraHeading = new PVector(viewXCo - cameraXPos, viewYCo - cameraYPos, viewZCo - cameraZPos);  //Dan en vektor for hvor man ville kigge hen
  cameraHeading.normalize();

  cameraViewXPos = cameraHeading.x; //Sæt viewet til man kigger hen.
  cameraViewYPos = cameraHeading.y;
  cameraViewZPos = cameraHeading.z;

  viewAngleY = degrees(asin(cameraHeading.y)); //Beregn den nye viewAngleY efter hvor man vil kigge hen
  viewAngleX = degrees(atan2(cameraHeading.z, cameraHeading.x)); //atan2 gør så man kan give en y og x koordinat (Ja i den rækkefølge) på dens eget lille kort, og så regner den vinklen til dette kordinat fra (0,0) på dens eget lille kort.


  if (cameraHeading.z >= 0 && cameraHeading.x > 0) { //Alt herefter justeringer af viewAngleX, fordi den kun kan gå fra -90 til 90
    viewAngleX = viewAngleX+180;
  } else if (cameraHeading.z < 0 && cameraHeading.x >= 0) {
    viewAngleX = viewAngleX + 180; //Selvom det er det samme som ved if-statement ovenover synes jeg det gav bedre overblik hvis man spliitede de op i alle 4 "hjørner"
  } else if (cameraHeading.z >= 0 && cameraHeading.x <= 0) {
    viewAngleX = viewAngleX+180;
  } else if (cameraHeading.z < 0 && cameraHeading.x < 0) {
    viewAngleX = viewAngleX+180;
  }
}
