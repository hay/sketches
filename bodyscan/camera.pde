class Camera {
    SimpleOpenNI ctx;
    float zoomF = 0.3f;
    float rotX = radians(180);
    float rotY = radians(0);
    float rotatingDelta = 0.01f;
    int skipPoint = 10;

    Camera(SimpleOpenNI initCtx) {
        println("Setup Camera");

        ctx = initCtx;

        if(ctx.isInit() == false)  {
            println("Can't init SimpleOpenNI, maybe the camera is not connected!");
            exit();
            return;
        }

        ctx.setMirror(true);
        ctx.enableDepth();
        ctx.enableUser();
        ctx.enableRGB();
        strokeWeight(5);
    }

    void update() {
        ctx.update();
    }

    int getNumberOfUsers() {
        return ctx.getNumberOfUsers();
    }

    void drawSkeleton(int userId) {
        stroke(255, 0, 0);

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
        if (rotY > 12) {
            rotY = 0;
            modus.set(Modi.RESULT);
            perspective();
        }
    }

    void drawVideo() {
        if (modus.is(Modi.HAS_SKELETON)) {
            image(ctx.userImage(),0,0);
        } else {
            image(ctx.rgbImage(),0,0);
        }

        int[] userList = ctx.getUsers();

        for (int i=0 ; i < userList.length;i++) {
            int userId = userList[i];

            if (ctx.isTrackingSkeleton(userId)) {
                if (!modus.is(Modi.RESULT)) {
                    modus.set(Modi.HAS_SKELETON);
                }

                drawSkeleton(userId);
            } else {
                modus.set(Modi.DETECTED_PERSON);
                ctx.startTrackingSkeleton(userId);
            }
        }
    }
}