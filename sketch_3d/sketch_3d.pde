import SimpleOpenNI.*;

SimpleOpenNI context;
float zoomF =0.3f;
float rotX = radians(180);  // by default rotate the hole scene 180deg around the x-axis,
                            // the data from openni comes upside down
float rotY = radians(0);
boolean rotating = false;
float rotatingDelta = 0.02f;
int skipPoint = 3;

void setup() {
  size(1024,600,P3D);

  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!");
     exit();
     return;
  }

  // disable mirror
  context.setMirror(false);

  // enable depthMap generation
  context.enableDepth();

  stroke(255,255,255);
  smooth();
  perspective(radians(45),
              float(width)/float(height),
              10,150000);
  textSize(30);
}

void showDebugValues() {
  text("hoi allen", 10, 10);
  fill(255, 255, 255);
}

void draw()
{
  // update the cam
  context.update();

  if (rotating) {
    rotY += 0.1f;
    zoomF += rotatingDelta;

    if (zoomF > 1) {
      rotatingDelta *= -1;
      zoomF = 0.99;
    }

    if (zoomF < 0.2) {
      rotatingDelta *= -1;
      zoomF = 0.21;
    }
  }

  background(0,0,0);

  translate(width/2, height/2, 0);
  rotateX(rotX);
  rotateY(rotY);
  scale(zoomF);

  int[]   depthMap = context.depthMap();
  int     index;
  PVector realWorldPoint;

  translate(0,0,-1000);  // set the rotation center of the scene 1000 infront of the camera

  stroke(255);

  PVector[] realWorldMap = context.depthMapRealWorld();

  // draw pointcloud
  beginShape(POINTS);
  for(int y=0;y < context.depthHeight();y+=skipPoint)
  {
    for(int x=0;x < context.depthWidth();x+=skipPoint)
    {
      index = x + y * context.depthWidth();
      if(depthMap[index] > 0)
      {
        // draw the projected point
        realWorldPoint = realWorldMap[index];
        vertex(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);  // make realworld z negative, in the 3d drawing coordsystem +z points in the direction of the eye
      }
    }
  }
  endShape();

  // draw the kinect cam
  // context.drawCamFrustum();
  showDebugValues();
}


void keyPressed()
{
  if (key == 'l') {
    rotating = !rotating;
  }

  if (key == 's') {
    skipPoint++;
  }

  if (key == 'a') {
    skipPoint--;
  }

  switch(keyCode)
  {
  case LEFT:
    rotY += 0.1f;
    break;
  case RIGHT:
    // zoom out
    rotY -= 0.1f;
    break;
  case UP:
    if(keyEvent.isShiftDown())
      zoomF += 0.02f;
    else
      rotX += 0.1f;
    break;
  case DOWN:
    if(keyEvent.isShiftDown())
    {
      zoomF -= 0.02f;
      if(zoomF < 0.01)
        zoomF = 0.01;
    }
    else
      rotX -= 0.1f;
    break;
  }
}

