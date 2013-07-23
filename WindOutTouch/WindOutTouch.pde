import controlP5.*;

ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<PShape> shapes = new ArrayList<PShape>();
boolean drawing = false;
SVGLoader svgl;
PImage sourceImage;
ControlP5 cp5;

void setup() {
  noCursor();
  background(255);
  svgl = new SVGLoader();
  svgl.loadVectors(shapes, this.sketchPath + "/data/vector/", 500, "retro");
  sourceImage = loadImage("http://img.ffffound.com/static-data/assets/6/1e6bd71919bdd56832ee20a655d30d467da2b936_m.jpg");
  sourceImage.resize(displayWidth, displayHeight);
  size(sourceImage.width, sourceImage.height);
  cp5 = new ControlP5(this);
}

void draw() {
  if (drawing == true && particles.size() < 30 ) {
    PVector pos = new PVector(mouseX, mouseY);
    PVector vel = new PVector(0, 0);
    Particle p = new Particle(pos, vel, random(500,2500));
    p.shape = shapes.get((int) random(shapes.size()));
    p.pixel = sourceImage.pixels[(int) random(sourceImage.pixels.length)];
    particles.add(p);
  } 

  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = (Particle) particles.get(i);
    for (float ii = 0; ii < TWO_PI; ii += TWO_PI / 5) {
      pushMatrix();
      translate(width / 2, height / 2);
      rotate(ii);
      p.update();
      p.draw();
      popMatrix();
    }

    if (p.isDead) particles.remove(i);
  }
}

void mousePressed() {
  drawing = true;
}

void mouseReleased() {
  drawing = false;
}

