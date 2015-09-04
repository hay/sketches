import SimpleOpenNI.*;

SimpleOpenNI ctx;
PFont font;
Modus modus = new Modus();
float zoomF = 0.3f;
float rotX = radians(180);
float rotY = radians(0);
float rotatingDelta = 0.01f;
int skipPoint = 10;
int nrOfUsers = 0;

void setup() {
    println("Setup");
    size(640, 480, P3D); // Beamer Sebastiaan is 1024x768

    ctx = new SimpleOpenNI(this);

    if(ctx.isInit() == false)  {
        println("Can't init SimpleOpenNI, maybe the camera is not connected!");
        exit();
        return;
    }

    font = createFont("HelveticaNeue", 24);
    textFont(font);

    ctx.setMirror(true);
    ctx.enableDepth();
    ctx.enableUser();
    ctx.enableRGB();

    background(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(5);
}

void draw() {
    // update the cam
    ctx.update();
    background(0);

    nrOfUsers = ctx.getNumberOfUsers();

    if (modus.is(Modi.HAS_SKELETON)) {
        modus.set(Modi.SCANNING);
    }

    if (modus.is(Modi.SCANNING)) {
        drawDepth();
    } else {
        drawVideo();
    }

    if (modus.is(Modi.RESULT)) {
        drawResult();
    }

    modus.draw(nrOfUsers);
}

void drawDepth() {
    perspective(radians(45), float(width)/float(height), 10,150000);
    rotY += 0.1f;

    translate(width/2, height/2, 0);
    rotateX(rotX);
    rotateY(rotY);
    scale(zoomF);

    int[]   depthMap = ctx.depthMap();
    int     index;
    PVector realWorldPoint;

    translate(0,0,-1500);  // set the rotation center of the scene 1000 infront of the camera

    stroke(255);

    PVector[] realWorldMap = ctx.depthMapRealWorld();

    // draw pointcloud
    beginShape(POINTS);
    for (int y = 0; y < ctx.depthHeight(); y += skipPoint) {
        for (int x = 0; x < ctx.depthWidth(); x += skipPoint) {
            index = x + y * ctx.depthWidth();
            if (depthMap[index] > 0) {
                // draw the projected point
                realWorldPoint = realWorldMap[index];
                vertex(realWorldPoint.x,realWorldPoint.y,realWorldPoint.z);
            }
        }
    }
    endShape();

    // Done scanning?
    if (rotY > 6) {
        rotY = 0;
        modus.set(Modi.RESULT);
        perspective();
    }
}

void drawVideo() {
    image(ctx.rgbImage(),0,0);

    int[] userList = ctx.getUsers();

    for (int i=0 ; i < userList.length;i++) {
        if (ctx.isTrackingSkeleton(userList[i])) {
            if (!modus.is(Modi.RESULT)) {
                modus.set(Modi.HAS_SKELETON);
            }

            drawSkeleton(userList[i]);
        } else {
            modus.set(Modi.DETECTED_PERSON);
        }
    }
}

void drawResult() {
    fill(255, 0, 0);
    text("You are very sick", 10, 200);
}

void drawSkeleton(int userId) {
    ctx.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

    ctx.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    ctx.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    ctx.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

    ctx.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    ctx.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    ctx.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

    ctx.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    ctx.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

    ctx.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    ctx.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    ctx.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

    ctx.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    ctx.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    ctx.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
}

void onNewUser(SimpleOpenNI ctx, int userId) {
    println("new user: " + userId);
    modus.set(Modi.DETECTED_PERSON);
    ctx.startTrackingSkeleton(userId);
}

// For some reason, this never happens!
void onLostUser(int userId) {
    println("lost user: " + userId);
}

void onVisibleUser(int userId) {
    println("visible user: " + userId);
}

void keyPressed() {
    if (key == 's') {
        modus.set(Modi.SCANNING);
    }

    if (key == 'r') {
        modus.set(Modi.DEMO);
    }
}