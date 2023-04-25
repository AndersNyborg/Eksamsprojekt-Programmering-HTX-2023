int[] sideOfBlock (float mainBlockX1, float mainBlockY1, float mainBlockZ1, float mainBlockX2, float mainBlockY2, float mainBlockZ2, float sideBlockX, float sideBlockY, float sideBlockZ) {

  float[] mainBlockCoords = new float[6];
  mainBlockCoords[0] = mainBlockX1;
  mainBlockCoords[1] = mainBlockY1;
  mainBlockCoords[2] = mainBlockZ1;
  mainBlockCoords[3] = mainBlockX2;
  mainBlockCoords[4] = mainBlockY2;
  mainBlockCoords[5] = mainBlockZ2;


  float[] distanceToCoord = new float[6];
  distanceToCoord[0]=makeNumerical(mainBlockX1-sideBlockX);
  distanceToCoord[1]=makeNumerical(mainBlockY1-sideBlockY);
  distanceToCoord[2]=makeNumerical(mainBlockZ1-sideBlockZ);
  distanceToCoord[3]=makeNumerical(mainBlockX2-sideBlockX);
  distanceToCoord[4]=makeNumerical(mainBlockY2-sideBlockY);
  distanceToCoord[5]=makeNumerical(mainBlockZ2-sideBlockZ);
  println("--");
  println(distanceToCoord);
  println("--");
  int[] sidePlacement = new int[3];
  sidePlacement[0]=0;
  sidePlacement[1]=0;
  sidePlacement[2]=0;
  for (int i=0; i<distanceToCoord.length; i++) {
    if (isLowestinArray(distanceToCoord[i], distanceToCoord)==true) {


      if (i==0 || i==3) {
        if (mainBlockCoords[i]>mainBlockCoords[3-i]) { //X
          sidePlacement[0]=1;
        } else {
          sidePlacement[0]=-1;
        }
      }
      if (i==1 || i==4) {
        if (mainBlockCoords[i]>mainBlockCoords[5-i]) {//Y
          sidePlacement[1]=1;
        } else {
          sidePlacement[1]=-1;
        }
      }
      if (i==2 || i==5) {
        if (mainBlockCoords[i]>mainBlockCoords[7-i]) {//Z
          sidePlacement[2]=1;
        } else {
          sidePlacement[2]=-1;
        }
      }
    }
  }
  return sidePlacement;
}
