class simplified3D {



  float cameraXPos = 0;
  float cameraYPos = 0;
  float cameraZPos = 0;

  float cameraAddXPos = 0;
  float cameraAddYPos = 0;
  float cameraAddZPos = 0;


  float cameraViewXPos = 0;
  float cameraViewYPos = 0;
  float cameraViewZPos = 0;

  float viewAngleX = 0;
  float viewAngleY = 0;

  float playerHeight = 100;
  float jumpHeight = 15;

  boolean freeFly = true;
  int renderDistance = 3000;

  ArrayList<float[]> Map = new ArrayList<float[]>();
  float[] None = new float[0];

  void intiliazesimplified3D(float x, float y, float z, float viewX, float viewY, float viewZ) {
    try {
      robot = new Robot();
    }
    catch (Throwable e) {
    }
    robot.mouseMove(width/2, height/2);

    cameraXPos = x;
    cameraYPos = y;
    cameraZPos = z;


    setView(viewX, viewY, viewZ);


    //noCursor();
    perspective(PI/3.0, (float) width/height, 1, renderDistance);
   
  }
