int n;

float sCoef;
float cCoef;
float aCoef;

float maxForce;
float maxSpeed;

float radius;
float FOV;

Boid[] boids;

void setup() {
  size(1000, 600);
  frameRate(60);
  
  n = 150;
  
  maxForce = 1;
  maxSpeed = 3;
  
  sCoef = 0.02;
  cCoef = 0.01;
  aCoef = 0.07;
  
  radius = 50;
  FOV = 90;
  
  boids = new Boid[n];
  
  for (int i = 0; i < boids.length; i++) {
    boids[i] = new Boid(new PVector(random(0, width), random(0, height)), PVector.random2D());
  }
}

void draw() {
  background(0);
  for (Boid b : boids) {
    b.update();
    b.display();
  }
}
