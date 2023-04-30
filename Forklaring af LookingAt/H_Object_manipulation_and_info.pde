

  void deleteObject(int integer) {
    Map.set(integer, None); //Sætter indekset til float[] None jeg har lavet.
  }



  float objectInfo(int integer, String variable) {
    if (Map.get(integer)==None) {
      return 0;
    }

    //Alt nedenunder gør egentlig bare at den ser hvad indekset er for den variabel man vil ændre, og ændre det derefter.
    StringList valuesForObject = new StringList();
    valuesForObject.append("xPos");
    valuesForObject.append("yPos");
    valuesForObject.append("zPos");
    valuesForObject.append("xDim");
    valuesForObject.append("yDim");
    valuesForObject.append("zDim");
    valuesForObject.append("fillr");
    valuesForObject.append("fillg");
    valuesForObject.append("fillb");
    valuesForObject.append("stroke");

    int index=-1;
    for (int i = 0; i<valuesForObject.size(); i++) {

      if ( valuesForObject.get(i)==variable) {
        index = i;
      }
    }


    return(Map.get(integer)[index]);
  }

  void changeObject(int integer, String variable, float newValue) {
    //if (Map.get(integer)==None){
    // return;
    //}

    float[] oldInfo = Map.get(integer);

    //Alt nedenunder gør egentlig bare at den ser hvad indekset er for den variabel man vil ændre, og ændre det derefter.
    StringList valuesForObject = new StringList();
    valuesForObject.append("xPos");
    valuesForObject.append("yPos");
    valuesForObject.append("zPos");
    valuesForObject.append("xDim");
    valuesForObject.append("yDim");
    valuesForObject.append("zDim");
    valuesForObject.append("fillr");
    valuesForObject.append("fillg");
    valuesForObject.append("fillb");
    valuesForObject.append("stroke");

    int index = -1;
    for (int i = 0; i<valuesForObject.size(); i++) {

      if ( valuesForObject.get(i)==variable) {
        index = i;
      }
    }

    oldInfo[index] = newValue;
    Map.set(integer, oldInfo);
  }
  
