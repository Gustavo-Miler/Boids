class Boid {
  PVector pos;
  PVector vel;
  PVector acc;
  PShape shape;
  
  public Boid(PVector pos, PVector vel) {
    this.acc = new PVector();
    this.pos = pos;
    this.vel = vel;
    shape = createShape(TRIANGLE, 0, 0, 0, 10, 10, 5);
    shape.setStroke(255);
    shape.setFill(false);
  }
  
  void separate() {
    int total = 0;
    PVector target = new PVector();
    
    for (Boid other : boids) {
      float d = PVector.dist(pos, other.pos);
      if (other != this && isInView(other.pos.x, other.pos.y)) {
        PVector diff = PVector.sub(pos, other.pos);
        diff.div(d * d);
        target.add(diff);
        total++;
      }
    }
    if (total == 0) return;
    target.div(total);
    target.setMag(maxSpeed);
    PVector force = PVector.sub(target, vel);
    force.limit(maxForce);
    force.mult(sCoef);
    acc.add(force);
  }
  
  void cohese() {
    int total = 0;
    PVector center = new PVector();
    for (Boid other : boids) {
      if (other != this && isInView(other.pos.x, other.pos.y)) {
        center.add(other.pos);
        total++;
      }
    }
    if (total == 0) return;
    center.div(total);
    PVector target = PVector.sub(center, pos);
    target.setMag(maxSpeed);
    PVector force = PVector.sub(target, vel);
    force.limit(maxForce);
    force.mult(cCoef);
    acc.add(force);
  }
  
  void align() {
    PVector target = new PVector();
    int total = 0;
    
    for (Boid other : boids) {
      if (other != this && isInView(other.pos.x, other.pos.y)) {
        target.add(other.vel);
        total++;
      }
    }
    if (total == 0) return;
    target.div(total);
    target.setMag(maxSpeed);
    PVector force = PVector.sub(target, vel);
    force.limit(maxForce);
    force.mult(aCoef);
    acc.add(force);
  }
  
  boolean isInView(float x, float y) {
    float dist = PVector.dist(pos, new PVector(x, y));
    float angle = atan2(y - pos.y, x - pos.x) * 180 / PI;
    
    if (dist < radius && angle > degrees(vel.heading() - FOV / 2) && angle < degrees(vel.heading() + FOV / 2)) return true;
    return false;
  }
  
  void update() {
    separate();
    cohese();
    align();
    
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    
    if (pos.x < 0) { pos.x = width; }
    else if (pos.x > width) pos.x = 0;
    if (pos.y < 0) { pos.y = height; }
    else if (pos.y > height) pos.y = 0;
  }
  
  void drawBoid(float x, float y, float heading) {
    pushMatrix();
    translate(x, y);
    rotate(heading);
    shape(shape);
    popMatrix();
  }
  
  void display() {
    drawBoid(pos.x, pos.y, vel.heading());
  }
}
