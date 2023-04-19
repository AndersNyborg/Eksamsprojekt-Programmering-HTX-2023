boolean advcollision(float object1XCo1, float object1YCo1, float object1ZCo1, float object1XCo2, float object1YCo2, float object1ZCo2, float object2XCo1, float object2YCo1, float object2ZCo1, float object2XCo2, float object2YCo2, float object2ZCo2) {
    // Fungere ved at finde centrumspunkter for de to kasser, og dimensionerne på kasserne. Hvis differensen mellem midterpunkterne er mindre, end længden fra midten til siden af kasse + det samme fra den anden kasse er der kollision.

    float[] objectsDim = new float[6];
    objectsDim[0] = object1XCo1-object1XCo2;
    objectsDim[1] = object1YCo1-object1YCo2;
    objectsDim[2] = object1ZCo1-object1ZCo2;

    objectsDim[3] = object2XCo1-object2XCo2;
    objectsDim[4] = object2YCo1-object2YCo2;
    objectsDim[5] = object2ZCo1-object2ZCo2;


    for (int i=0; i<6; i++) { // For at få den numeriske værdi
      if (objectsDim[i]<0) {

        objectsDim[i] *= -1;
      }
    }

    float[] objectsCenterCo = new float[6];
    objectsCenterCo[0] = (object1XCo1+object1XCo2)/2;
    objectsCenterCo[1] = (object1YCo1+object1YCo2)/2;
    objectsCenterCo[2] = (object1ZCo1+object1ZCo2)/2;

    objectsCenterCo[3] = (object2XCo1+object2XCo2)/2;
    objectsCenterCo[4] = (object2YCo1+object2YCo2)/2;
    objectsCenterCo[5] = (object2ZCo1+object2ZCo2)/2;

    float[] objectCenterCoDifference = new float[3];
    objectCenterCoDifference[0] = objectsCenterCo[0]-objectsCenterCo[3];
    objectCenterCoDifference[1] = objectsCenterCo[1]-objectsCenterCo[4];
    objectCenterCoDifference[2] = objectsCenterCo[2]-objectsCenterCo[5];

    for (int i=0; i<3; i++) {
      if (objectCenterCoDifference[i]<0) { // For at få den numeriske værdi
        objectCenterCoDifference[i] *= -1;
      }
    }


    if (objectsDim[0]/2+objectsDim[3]/2>=objectCenterCoDifference[0]) { //Test for x
      if (objectsDim[1]/2+objectsDim[4]/2>=objectCenterCoDifference[1]) { //Test for y
        if (objectsDim[2]/2+objectsDim[5]/2>=objectCenterCoDifference[2]) { //Test for x
          return true;
        }
      }
    }


    return false;
  }
  boolean collision(int object1, int object2) {
    if (Map.get(object1)==None||Map.get(object2)==None) {
      return false;
    }
    if (advcollision(
      Map.get(object1)[0]-Map.get(object1)[3]/2, Map.get(object1)[1]-Map.get(object1)[4]/2, Map.get(object1)[2]-Map.get(object1)[5]/2,
      Map.get(object1)[0]+Map.get(object1)[3]/2, Map.get(object1)[1]+Map.get(object1)[4]/2, Map.get(object1)[2]+Map.get(object1)[5]/2,
      Map.get(object2)[0]-Map.get(object2)[3]/2, Map.get(object2)[1]-Map.get(object2)[4]/2, Map.get(object2)[2]-Map.get(object2)[5]/2,
      Map.get(object2)[0]+Map.get(object2)[3]/2, Map.get(object2)[1]+Map.get(object2)[4]/2, Map.get(object2)[2]+Map.get(object2)[5]/2)==true) {
      return true;
    }
    return false;
  }





  
