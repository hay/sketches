static class Modi {
    static int DEMO = 1;
    static int DETECTED_PERSON = 2;
    static int HAS_SKELETON = 3;
    static int SCANNING = 4;
    static int RESULT = 5;
    final static int NR_OF_MODI = 5;
}

class Modus {
    int modus;
    PFont font;
    Sound sound;

    Modus(PApplet parent) {
        println("Setup Modus");
        modus = Modi.DEMO;
        font = createFont("HelveticaNeue", 24);
        textFont(font);
        sound = new Sound(parent);
        playSound();
    }

    void draw(int nrOfUsers) {
        fill(255);
        String text = "";

        if (modus == Modi.DEMO) {
            text = "Please enter the scanner...";
        }

        if (modus == Modi.DETECTED_PERSON) {
            text = "Detected a person";
        }

        if (modus == Modi.HAS_SKELETON) {
            text = "Detected body points";
        }

        if (modus == Modi.SCANNING) {
            text = "Now scanning, please hold still...";
        }

        if (modus == Modi.RESULT) {
            sound.play("scanning_complete");
        }

        textAlign(LEFT);
        text(text, 10, 30);
        textAlign(RIGHT);
        text(nrOfUsers, width - 10, 30);
    }

    void playSound() {
        if (modus == Modi.DEMO) {
            sound.play("system_error");
        }

        if (modus == Modi.DETECTED_PERSON) {
            sound.play("object_detected");
        }

        if (modus == Modi.HAS_SKELETON) {
            sound.play("awaiting_scan");
        }

        if (modus == Modi.SCANNING) {
            sound.play("scanning");
        }

        if (modus == Modi.RESULT) {
            sound.play("scanning_complete");
        }
    }

    int get() {
        return modus;
    }

    boolean is(int aModus) {
        return aModus == modus;
    }

    void set(int newModus) {
        if (newModus == modus) {
            return;
        }

        if (newModus > 0 && newModus <= Modi.NR_OF_MODI) {
            println("Setting modus to " + newModus);
            modus = newModus;
            playSound();
        } else {
            println("Not a valid modus: " + newModus);
        }
    }
}