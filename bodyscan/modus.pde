import ddf.minim.*;

static class Modi {
    static int DEMO = 0;
    static int DETECTED_PERSON = 1;
    static int HAS_SKELETON = 2;
    static int SCANNING = 3;
    static int RESULT = 4;
}

class Modus {
    int modus;
    AudioPlayer player;
    Minim minim;

    void setup() {
        modus = 0;
    }

    void playSound(String soundFile) {
        String soundPath = dataPath(soundFile + ".mp3");
        println("Playing " + soundPath);
        minim = new Minim(this);
        player = minim.loadFile(soundPath);
        player.play();
    }

    void draw(int nrOfUsers) {
        fill(255);
        String text = "";

        if (modus == 0) {
            text = "Please enter the scanner...";
        }

        if (modus == 1) {
            playSound("object_detected");
            text = "Detected a person";
        }

        if (modus == 2) {
            playSound("awaiting_scan");
            text = "Detected body points";
        }

        if (modus == 3) {
            playSound("scanning");
            text = "Now scanning, please hold still...";
        }

        if (modus == 4) {
            // sound.play("scanning_complete");
        }

        textAlign(LEFT);
        text(text, 10, 30);
        textAlign(RIGHT);
        text(nrOfUsers, width - 10, 30);
    }


    int get() {
        return modus;
    }

    boolean is(int aModus) {
        return aModus == modus;
    }

    void set(int newModus) {
        modus = newModus;
    }
}