void setup() {
    size(640, 480);
}

void draw() {
    background(0,0,0);
    stroke(255, 0, 0);

    for (int x = 0; x < 640; x++) {
        point(x, x);
    }
}