Integer counter = 0;
PFont font;

void setup() {
    size(640, 480);
    font = createFont("HelveticaNeue", 30);
    textFont(font);
}

void draw() {
    background(0,0,0);
    counter++;
    text("Number of people: " + str(counter), 10, 30);
}