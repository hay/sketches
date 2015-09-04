import ddf.minim.*;

class Sound {
    AudioPlayer player;
    Minim minim;

    Sound(PApplet parent) {
        minim = new Minim(parent);
    }

    void play(String soundFile) {
        player = minim.loadFile("data/" + soundFile + ".mp3");
        player.play();
    }
}