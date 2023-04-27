void freeFlyMode(boolean wantedState) { // Så brugeren kan ændre om han eller hun vil kunne flyve
  freeFly = wantedState;
}
void changePlayerHeight(float wantedHeight) {// Så brugeren kan ændre hvor høj han eller hun vil være
  playerHeight = wantedHeight;
}


boolean objectExist(int index) {
  if (Map.get(index)==None) {
    return false;
  }
  return true;
}
float[] getPlayerPos() {
  float[] playerPos = new float[3];
  playerPos[0] = cameraXPos;
  playerPos[1] = cameraYPos;
  playerPos[2] = cameraZPos;
  return playerPos;
}
float[] getPlayerHeading() {
  float[] playerHeading = new float[3];
  playerHeading[0] = cameraViewXPos;
  playerHeading[1] = cameraViewYPos;
  playerHeading[2] = cameraViewZPos;
  return playerHeading;
}
}
