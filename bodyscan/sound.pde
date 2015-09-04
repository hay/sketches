import ddf.minim.*;

class Sound {
    AudioPlayer player;
    Minim minim;

    Sound(PApplet parent) {
        minim = new Minim(parent);
        player = minim.loadFile("data/system_error.mp3");
    }

    void play(String soundFile) {
        if (player.isPlaying()) {
            player.pause();
        }

        player = minim.loadFile("data/" + soundFile + ".mp3");
        player.play();
    }
}