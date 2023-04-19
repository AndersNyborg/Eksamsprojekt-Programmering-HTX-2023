  int objectBoxAddition(float objectXPos, float objectYPos, float objectZPos, float objectXDim, float objectYDim, float objectZDim, float fillr, float fillg, float fillb, float stroke) {
    //Her tilføjes en stringlist med et objekt altså kasse eller sådan.
    float[] Genstand = new float[10];
    Genstand[0] = objectXPos;
    Genstand[1] = objectYPos;
    Genstand[2] = objectZPos;
    Genstand[3] = objectXDim;
    Genstand[4] = objectYDim;
    Genstand[5] = objectZDim;
    Genstand[6] = fillr;
    Genstand[7] = fillg;
    Genstand[8] = fillb;
    Genstand[9] = stroke;


    Map.add(Genstand);

    return Map.size()-1;
  }
