import controlP5.*;
import java.util.Random;

ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<PShape> shapes = new ArrayList<PShape>();
boolean drawing = false;
SVGLoader svgl;
PImage sourceImage;
ControlP5 cp5;
PGraphics canvas;
Palettes palettes;
color[] colors;


void setup() {
  //noCursor();
  background(255);
  svgl = new SVGLoader();
  svgl.loadVectors(shapes, this.sketchPath + "/data/vector/", 500, "retro");
  sourceImage = loadImage("http://img.ffffound.com/static-data/assets/6/1e6bd71919bdd56832ee20a655d30d467da2b936_m.jpg");
  sourceImage.resize(1920, 1080);
  size(sourceImage.width, sourceImage.height);
  cp5 = new ControlP5(this);
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  palettes = new Palettes();
  colors = palettes.colors.get(0);
}

void draw() {
  if (drawing == true && particles.size() < 30) {
    Particle p = new Particle(new PVector(mouseX, mouseY), (int) random(150, 500));
    p.shape = shapes.get((int) random(shapes.size()));
    //p.pixel = sourceImage.get((int) random(sourceImage.width), (int) random(sourceImage.height));
    p.pixel = colors[(int) random(colors.length)];
    particles.add(p);
  }
  canvas.beginDraw();
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = (Particle) particles.get(i);
    p.update();
    for (float turn = 0; turn < TWO_PI; turn += TWO_PI / 6) {
      canvas.pushMatrix();
      canvas.translate(width / 2, height / 2);
      canvas.rotate(turn);
      p.draw();
      canvas.popMatrix();
    }
    if (p.isDead) particles.remove(i);
  }
  canvas.endDraw();

  image(canvas, 0, 0);
  for (int i = 0; i < colors.length; i++) {
    fill(colors[i]);
    rect(i * 20, 0, 20, 20);
  }
}

void keyPressed() {
  if (key == 's') {
    String id = generateString(4);
    canvas.save("/Users/criebsch/Dropbox/Public/windout/" + id + ".jpg");
    // TODO: also save a tif
  }
}

void mousePressed() {
  drawing = true;
}

void mouseReleased() {
  drawing = false;
}

public static String generateString(int length)
{
  Random rng = new Random();
  String characters = "01234567890";
  char[] text = new char[length];
  for (int i = 0; i < length; i++)
  {
    text[i] = characters.charAt(rng.nextInt(characters.length()));
  }
  return new String(text);
}

