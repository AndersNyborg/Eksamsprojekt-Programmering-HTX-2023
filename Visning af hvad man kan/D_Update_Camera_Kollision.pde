boolean advcollision(float object1XCo1, float object1YCo1, float object1ZCo1, float object1XCo2, float object1YCo2, float object1ZCo2, float object2XCo1, float object2YCo1, float object2ZCo1, float object2XCo2, float object2YCo2, float object2ZCo2) {
  // Fungere ved at finde centrumspunkter for de to kasser, og dimensionerne på kasserne. Hvis differensen mellem midterpunkterne er mindre, end længden fra midten til siden af kasse + det samme fra den anden kasse er der kollision.

  float[] objectsDim = new float[6]; //Længderne på objekterne
  objectsDim[0] = object1XCo1-object1XCo2;
  objectsDim[1] = object1YCo1-object1YCo2;
  objectsDim[2] = object1ZCo1-object1ZCo2;

  objectsDim[3] = object2XCo1-object2XCo2;
  objectsDim[4] = object2YCo1-object2YCo2;
  objectsDim[5] = object2ZCo1-object2ZCo2;


  for (int i=0; i<6; i++) { // For at få den numeriske værdi
    objectsDim[i] = makeNumerical(objectsDim[i]);
  }

  float[] objectsCenterCo = new float[6]; //Objekternes centre
  objectsCenterCo[0] = (object1XCo1+object1XCo2)/2;
  objectsCenterCo[1] = (object1YCo1+object1YCo2)/2;
  objectsCenterCo[2] = (object1ZCo1+object1ZCo2)/2;

  objectsCenterCo[3] = (object2XCo1+object2XCo2)/2;
  objectsCenterCo[4] = (object2YCo1+object2YCo2)/2;
  objectsCenterCo[5] = (object2ZCo1+object2ZCo2)/2;

  float[] objectCenterCoDifference = new float[3]; //Objekternes centres forskelle.
  objectCenterCoDifference[0] = objectsCenterCo[0]-objectsCenterCo[3];
  objectCenterCoDifference[1] = objectsCenterCo[1]-objectsCenterCo[4];
  objectCenterCoDifference[2] = objectsCenterCo[2]-objectsCenterCo[5];

  for (int i=0; i<3; i++) {
    objectCenterCoDifference[i] = makeNumerical(objectCenterCoDifference[i]); //Finde differensen
  }


  if (objectsDim[0]/2+objectsDim[3]/2>=objectCenterCoDifference[0]) { //Test for x (Om de to halvle længder af x-siderne tilsammen er mindre eller lig med forskellen i centernes x-koordinater)
    if (objectsDim[1]/2+objectsDim[4]/2>=objectCenterCoDifference[1]) { //Test for y
      if (objectsDim[2]/2+objectsDim[5]/2>=objectCenterCoDifference[2]) { //Test for x
        return true;
      }
    }
  }


  return false;
}
boolean collision(int object1, int object2) { //En hjælpefunktion, for kollision mellem to objektor.
  if (Map.get(object1)==None||Map.get(object2)==None) { //Hvis der er en af objekterne som ikke eksistere, kan der ikke være kollision.
    return false;
  }
  if (advcollision( //Her bliver funktion advcollision så brugt til at sammenligne for de to objektor:
    objectInfo(object1, "xPos")-objectInfo(object1, "xDim")/2, objectInfo(object1, "yPos")-objectInfo(object1, "yDim")/2, objectInfo(object1, "zPos")-objectInfo(object1, "zDim")/2, //Udregn hjørnet
    objectInfo(object1, "xPos")+objectInfo(object1, "xDim")/2, objectInfo(object1, "yPos")+objectInfo(object1, "yDim")/2, objectInfo(object1, "zPos")+objectInfo(object1, "zDim")/2,
    objectInfo(object2, "xPos")-objectInfo(object2, "xDim")/2, objectInfo(object2, "yPos")-objectInfo(object2, "yDim")/2, objectInfo(object2, "zPos")-objectInfo(object2, "zDim")/2,
    objectInfo(object2, "xPos")+objectInfo(object2, "xDim")/2, objectInfo(object2, "yPos")+objectInfo(object2, "yDim")/2, objectInfo(object2, "zPos")+objectInfo(object2, "zDim")/2) == true) {
    return true;
  }
  return false;
}
boolean insideCollision(int object1, int object2) { //En hjælpefunktion, for kollision mellem to objektor.
  float insideBuffer = 0.0001;
  if (Map.get(object1)==None||Map.get(object2)==None) { //Hvis der er en af objekterne som ikke eksistere, kan der ikke være kollision.
    return false;
  }
  if (advcollision( //Her bliver funktion advcollision så brugt til at sammenligne for de to objektor:
    objectInfo(object1, "xPos")-(objectInfo(object1, "xDim")-insideBuffer)/2, objectInfo(object1, "yPos")-(objectInfo(object1, "yDim")-insideBuffer)/2, objectInfo(object1, "zPos")-(objectInfo(object1, "zDim")-insideBuffer)/2, //Udregn hjørnet
    objectInfo(object1, "xPos")+(objectInfo(object1, "xDim")-insideBuffer)/2, objectInfo(object1, "yPos")+(objectInfo(object1, "yDim")-insideBuffer)/2, objectInfo(object1, "zPos")+(objectInfo(object1, "zDim")-insideBuffer)/2,
    objectInfo(object2, "xPos")-(objectInfo(object2, "xDim")-insideBuffer)/2, objectInfo(object2, "yPos")-(objectInfo(object2, "yDim")-insideBuffer)/2, objectInfo(object2, "zPos")-(objectInfo(object2, "zDim")-insideBuffer)/2,
    objectInfo(object2, "xPos")+(objectInfo(object2, "xDim")-insideBuffer)/2, objectInfo(object2, "yPos")+(objectInfo(object2, "yDim")-insideBuffer)/2, objectInfo(object2, "zPos")+(objectInfo(object2, "zDim")-insideBuffer)/2) == true) {
    return true;
  }
  return false;
}
