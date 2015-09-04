import ddf.minim.*;

class Sound {
    AudioPlayer player;
    Minim minim;

    void setup() {
        minim = new Minim(this);
    }

    void play(String soundFile) {
        // player = minim.loadFile("sounds/" + soundFile + ".mp3");
        // player.play();
    }
}