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

}
