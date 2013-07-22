class Particle {

  PVector pos, vel, noiseVec;
  float noiseFloat, lifetime, age;
  boolean isDead;
  PShape shape;
  int pixel;
  float initialRotation,finalRotation;
  float maxScale;

  public Particle(PVector _pos, PVector _vel, float _lifetime) {
    pos = _pos;
    vel = _vel;
    lifetime = _lifetime;
    age = 0;
    isDead = false;
    noiseVec = new PVector();
    initialRotation = random(-TWO_PI,TWO_PI);
    finalRotation = random(-TWO_PI,TWO_PI);
    maxScale = random(-1,1);
  }

  void update() {
    noiseFloat = noise(pos.x * 0.0025, pos.y * 0.0025, frameCount * 0.0025);
    noiseVec.x = cos(((noiseFloat - 0.3) * TWO_PI) * 10);
    noiseVec.y = sin(((noiseFloat - 0.3) * TWO_PI) * 10);

    vel.add(noiseVec);
    vel.div(6);
    pos.add(vel);

    if (1.0-(age/lifetime) <= 0) {
      isDead = true;
    }

    if (pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height) {
      isDead = true;
    }

     age++;
  }

  void draw() {  
    fill(red(pixel),green(pixel),blue(pixel),255 - 255 * (age / lifetime));
    noStroke();
    shape.resetMatrix();
    shape.scale(maxScale * (age / lifetime));
    shape.rotate(map(age / lifetime, 0, 1, initialRotation, finalRotation));
    shape(shape, pos.x - width/2, pos.y-height/2);
  }
}

