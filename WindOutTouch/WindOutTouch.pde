import controlP5.*;
import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

VerletPhysics2D physics;
PGraphics canvas;
ArrayList<PShape> shapes = new ArrayList<PShape>();
PImage sourceImage;
float time;
ControlP5 cp5;
boolean isToolbarVisible = false;
SVGLoader svgl;
DynamicShapeUtil dsu;

int NUMBER_OF_ROTATIONS = 6;
int SHAPES_PER_CLICK = 3;
int SHAPE_SCATTER = 20;
float SHAPE_SCALE_MIN = -2f;
float SHAPE_SCALE_MAX = 2f;
int SHAPE_FILL_ALPHA = 20;
int SHAPE_STROKE_ALPHA = 0;
int PARTICLE_FORCE_RADIUS = 400;
float PARTICLE_FORCE = -1.0f;
float PARTICLE_LIFETIME = 300f;

void setup() {
  svgl = new SVGLoader();
  svgl.loadVectors(shapes, this.sketchPath + "/data/vector/", 50, "flourish");
  dsu = new DynamicShapeUtil();
  size(1920, 1080);
  canvas = createGraphics(width, height);
  canvas.beginDraw();
  canvas.background(255);
  canvas.endDraw();
  physics = new VerletPhysics2D();
  physics.setDrag(0.05f);
  sourceImage = loadImage("http://img.ffffound.com/static-data/assets/6/0edac85884b069ad2b5bb8a3944f088b181f8ba0_m.jpg");
  sourceImage.loadPixels();
  cp5 = new ControlP5(this);
  cp5.addNumberbox("NUMBER_OF_ROTATIONS").setPosition(10, 100).setSize(100, 14).setMultiplier(1).setMin(1).setMax(22).setValue(NUMBER_OF_ROTATIONS).setCaptionLabel("NUMBER_OF_ROTATIONS");
  cp5.addNumberbox("SHAPES_PER_CLICK").setPosition(10, 140).setSize(100, 14).setMultiplier(1).setMin(1).setMax(50).setValue(SHAPES_PER_CLICK).setCaptionLabel("SHAPES_PER_CLICK");
  cp5.addNumberbox("SHAPE_SCATTER").setPosition(10, 180).setSize(100, 14).setMultiplier(1).setMin(0).setMax(300).setValue(SHAPE_SCATTER).setCaptionLabel("SHAPE_SCATTER");
  cp5.addNumberbox("SHAPE_SCALE_MIN").setPosition(10, 220).setSize(100, 14).setMultiplier(0.1f).setMin(-10f).setMax(10f).setValue(SHAPE_SCALE_MIN).setCaptionLabel("SHAPE_SCALE_MIN");
  cp5.addNumberbox("SHAPE_SCALE_MAX").setPosition(10, 260).setSize(100, 14).setMultiplier(0.1f).setMin(0f).setMax(20f).setValue(SHAPE_SCALE_MAX).setCaptionLabel("SHAPE_SCALE_MAX");
  cp5.addNumberbox("SHAPE_FILL_ALPHA").setPosition(10, 300).setSize(100, 14).setMultiplier(1).setMin(0).setMax(255).setValue(SHAPE_FILL_ALPHA).setCaptionLabel("SHAPE_FILL_ALPHA");
  cp5.addNumberbox("SHAPE_STROKE_ALPHA").setPosition(10, 340).setSize(100, 14).setMultiplier(1).setMin(0).setMax(255).setValue(SHAPE_STROKE_ALPHA).setCaptionLabel("SHAPE_STROKE_ALPHA");
  cp5.addNumberbox("PARTICLE_FORCE_RADIUS").setPosition(10, 380).setSize(100, 14).setMultiplier(1).setMin(0).setMax(1000).setValue(PARTICLE_FORCE_RADIUS).setCaptionLabel("PARTICLE_FORCE_RADIUS");
  cp5.addNumberbox("PARTICLE_FORCE").setPosition(10, 420).setSize(100, 14).setMultiplier(0.01f).setMin(-5f).setMax(5f).setValue(PARTICLE_FORCE).setCaptionLabel("PARTICLE_FORCE");
  cp5.addNumberbox("PARTICLE_LIFETIME").setPosition(10, 460).setSize(100, 14).setMultiplier(1).setMin(1f).setMax(300f).setValue(PARTICLE_LIFETIME).setCaptionLabel("PARTICLE_LIFETIME");
  cp5.hide();
}

void render() {
  time += 0.01;
  canvas.beginDraw();
  canvas.noFill();
  canvas.noStroke();
  canvas.strokeWeight(0.1);
  for (VerletParticle2D vp2d : physics.particles) {
    Particle p = (Particle) vp2d;
    if (p.age >= p.lifetime) {
      physics.removeParticle(p); 
      return;
    }
    for (float i = 0; i < TWO_PI; i+= TWO_PI / NUMBER_OF_ROTATIONS) {
      int c = dsu.getColor(p, "a", p.targetPixel);
      //int c = getColor(p, "fadeTo", 0xFF000000);
      int fillColor = color(c, dsu.getAlpha(p, "fadeInOut", SHAPE_FILL_ALPHA));
      int strokeColor = color(p.pixel, dsu.getAlpha(p, "fadeInOut", SHAPE_STROKE_ALPHA));
      if (SHAPE_FILL_ALPHA != 0) canvas.fill(fillColor);
      if (SHAPE_STROKE_ALPHA != 0) canvas.stroke(strokeColor);
      canvas.pushMatrix();
      canvas.translate(canvas.width / 2, canvas.height / 2);
      canvas.rotate(i);
      p.shape.resetMatrix();
      p.shape.scale(dsu.getScale(p, "scaleInOut"));
      p.shape.rotate(dsu.getRotation(p, "noise", 0, PI, p.directionality));
      canvas.shape(p.shape, p.x - canvas.width / 2, p.y - canvas.height / 2);
      canvas.popMatrix();
    }
    p.age++;
  }
  canvas.endDraw();
}

void draw() {
  background(255);
  physics.update();
  if (physics.particles.size() > 0) render();
  image(canvas, 0, 0, width, height);
  if (isToolbarVisible) {
    fill(0, 150);
    rect(0, 0, width, height);
  }
}

void mousePressed() {
  if (isToolbarVisible) return;
  resetPhysics();
  for (int i = 0; i < SHAPES_PER_CLICK; i++) {
    float pX = map(mouseX, 0, width, 0, canvas.width) + random(-SHAPE_SCATTER, SHAPE_SCATTER);
    float pY = map(mouseY, 0, height, 0, canvas.height) + random(-SHAPE_SCATTER, SHAPE_SCATTER);
    Particle p = new Particle(pX, pY);
    physics.addParticle(p);
    p.addVelocity(new Vec2D(random(-15, 15), random(-15, 15)));
    //physics.addBehavior(new AttractionBehavior(p, PARTICLE_FORCE_RADIUS, PARTICLE_FORCE));
    p.shape = shapes.get((int) random(shapes.size()));
    int r = (int) random(sourceImage.pixels.length);
    p.pixel = sourceImage.pixels[r];
    p.targetPixel = sourceImage.pixels[(int) (sourceImage.pixels.length - r)];
    p.lifetime = PARTICLE_LIFETIME;
  }
}

void keyPressed() {
  if (key == 't') {
    isToolbarVisible = !isToolbarVisible;
    if (isToolbarVisible) cp5.show();
    else cp5.hide();
  }
  if (key == 's') {
    String fileName = "composition-" + month() + "-" + day() + "-" + hour() + "-" + minute() + "-" + second() + ".png";
    canvas.save("data/output/" + fileName);
    println("Saved: " + fileName);
  }
  if (key == 'c') {
    canvas.beginDraw();
    canvas.clear();
    canvas.endDraw();
  }
  if (key == ' ') {
    resetPhysics();
  }
}

void resetPhysics() {
  time = random(1000);
  physics.particles.clear();
  physics.behaviors.clear();
  physics.clear();
}
