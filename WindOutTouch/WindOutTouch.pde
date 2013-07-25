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
String messageText;
String mode;

Button startOver, saveImage, changeColors;

void setup() {
  //noCursor();
  background(255);
  svgl = new SVGLoader();
  svgl.loadVectors(shapes, this.sketchPath + "/data/vector/", 500, "retro");
  sourceImage = loadImage("http://img.ffffound.com/static-data/assets/6/1e6bd71919bdd56832ee20a655d30d467da2b936_m.jpg");
  sourceImage.resize(1920, 1080);
  size(sourceImage.width, sourceImage.height);
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  cp5 = new ControlP5(this);
  PFont font = loadFont("HelveticaNeue-Light-12.vlw");
  textFont(font);
  cp5.setFont(font);
  cp5.setColorBackground(color(0, 200));
  startOver = cp5.addButton("startOver").setPosition(10, 10).setSize(120, 40).setLabel("Start Over");
  saveImage = cp5.addButton("saveImage").setPosition(10, 60).setSize(120, 40).setLabel("Save");
  changeColors = cp5.addButton("changeColors").setPosition(10, 110).setSize(120, 40).setLabel("Change Colors");
  palettes = new Palettes();
  colors = palettes.colors.get(0);
  messageText = "";
}

void changeColors() {
  palettes.nextColor();
  colors = palettes.colors.get(palettes.currentPalette);
}

void saveImage() {
  String id = generateString(4);
  canvas.save("/Users/criebsch/Dropbox/Public/windout/" + id + ".jpg");
  canvas.save("data/output/" + id + ".tif");
  messageText = "Done! Your image is at http://art.the816.com/" + id;
  saveImage.setVisible(false);
  changeColors.setVisible(false);
}

void startOver() {
  saveImage.setVisible(true);
  changeColors.setVisible(true);
  particles.clear();
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  messageText = "";
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
  if (changeColors.isVisible()) {
    for (int i = 0; i < colors.length; i++) {
      fill(colors[i]);
      strokeWeight(0.1);
      rect(i * 20 + 10, 160, 20, 20);
    }
  }
  if (messageText != "") {
    fill(#FC5833);
    rect(140, 10, 300, 40);
    fill(0);
    text(messageText, 150, 35);
  }
}

void keyPressed() {
  if (key == 's') {
    String id = generateString(4);
    canvas.save("/Users/criebsch/Dropbox/Public/windout/" + id + ".jpg");
    canvas.save("data/output/" + id + ".tif");
    // TODO: also save a tif
  }
}

void mousePressed() {
  if (cp5.isMouseOver()) return;
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

