int[] sideOfBlock (float mainBlockX1, float mainBlockY1, float mainBlockZ1, float mainBlockX2, float mainBlockY2, float mainBlockZ2, float sideBlockX, float sideBlockY, float sideBlockZ) {

  float[] mainBlockCoords = new float[6]; //Laver en liste koordinaterne til hovedblokken.
  mainBlockCoords[0] = mainBlockX1;
  mainBlockCoords[1] = mainBlockY1;
  mainBlockCoords[2] = mainBlockZ1;
  mainBlockCoords[3] = mainBlockX2;
  mainBlockCoords[4] = mainBlockY2;
  mainBlockCoords[5] = mainBlockZ2;


  int[] sidePlacement = new int[3]; //Laver start til retunerliste
  sidePlacement[0]=0;
  sidePlacement[1]=0;
  sidePlacement[2]=0;

  for (int i=0; i<mainBlockCoords.length; i++) { //Går igennem koordinaterne for blokken.
    if (i==0 || i==3) { //Hvis der er en af x-koordinaterne
      if (mainBlockCoords[i]>mainBlockCoords[3-i] && sideBlockX>mainBlockCoords[i]) { //Hvis det x-koordinat som indekset nu svarer til, er større end det andet x-koordinat på samme mainblock, og sideblockens x-koordinat er større endnu, må der være klikket på den side med et højere x-koordinat.
        sidePlacement[0]=1; //Sætter første index til lig med 1 (Fordi at der er klikket på posetiv side af x-aksen på blocken.)
        break;
      } else if (mainBlockCoords[i]<mainBlockCoords[3-i] && sideBlockX<mainBlockCoords[i]){//Hvis det x-koordinat som indekset nu svarer til, er mindre end det andet x-koordinat på samme mainblock, og sideblockens x-koordinat er mindre endnu, må der være klikket på den side med et lavere x-koordinat.
        sidePlacement[0]=-1;
        break;
      }
    }
    if (i==1 || i==4) { //Hvis der er en af y-koordinaterne
      if (mainBlockCoords[i]>mainBlockCoords[5-i] && sideBlockY>mainBlockCoords[i]) {//Y
        sidePlacement[1]=1;
        break;
      } else if (mainBlockCoords[i]<mainBlockCoords[5-i] && sideBlockY<mainBlockCoords[i]) {
        sidePlacement[1]=-1;
        break;
      }
    }
    if (i==2 || i==5) {//Hvis der er en af z-koordinaterne
      if (mainBlockCoords[i]>mainBlockCoords[7-i]&& sideBlockZ>mainBlockCoords[i]) {//Z
        sidePlacement[2]=1;
        break;
      } else if (mainBlockCoords[i]<mainBlockCoords[7-i]&& sideBlockZ<mainBlockCoords[i]) {
        sidePlacement[2]=-1;
        break;
      }
    }
  }
  return sidePlacement;
}
