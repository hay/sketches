import SimpleOpenNI.*;

Modus modus;
Camera camera;
final boolean CAMERA_ENABLED = false;
final boolean SOUND_ENABLED = true;
int timeout = -1;
final int TIMEOUT_TIME = 100;

void setup() {
    println("Setup");
    println("Camera enabled: " + CAMERA_ENABLED);
    size(640, 480, P3D); // Beamer Sebastiaan is 1024x768

    if (CAMERA_ENABLED) {
        camera = new Camera(new SimpleOpenNI(this));
    }

    modus = new Modus(this);
}

void draw() {
    background(0);

    if (CAMERA_ENABLED) {
        camera.update();
    }

    if (modus.is(Modi.HAS_SKELETON)) {
        if (timeout == -1) {
            timeout = TIMEOUT_TIME;
        } else if (timeout > 0) {
            timeout--;
        } else if (timeout == 0) {
            timeout = -1;
            modus.set(Modi.SCANNING);
        }
    }

    if (modus.is(Modi.SCANNING)) {
        if (CAMERA_ENABLED) camera.drawDepth();
    } else {
        if (CAMERA_ENABLED) camera.drawVideo();
    }

    if (CAMERA_ENABLED) {
        modus.draw(camera.getNumberOfUsers());

        if (camera.getNumberOfUsers() == 0) {
            modus.set(Modi.EMPTY);
        }
    } else {
        modus.draw(-1);
    }
}

void keyPressed() {
    if (key == 'q') {
        exit();
    }

    int keyModus = int(str(key));
    modus.set(keyModus);
}