float fric = 0;
float drag = 0.05;
float hardRadius = 20;
float forceRadius = 25;
int types = 6;
int initParticles = 100;
float initVel = 4;
float forceRange = .2;
float fusionRadius = .2;

color[] colors;
float[][] forces;
float[][] radii;
int[][][] fusionList;

PVector newAdd(PVector u, PVector v) {
  return new PVector((u.x+v.x+width)%width, (u.y+v.y+height)%height);
}

PVector newSub(PVector u, PVector v) {
  PVector w = new PVector(0,0);
  if(abs((u.x-v.x+width)%width) < abs((v.x-u.x+width)%width)) w.x = (u.x-v.x+width)%width;
  else w.x = -(v.x-u.x+width)%width;
  if(abs((u.y-v.y+height)%height) < abs((v.y-u.y+height)%height)) w.y = (u.y-v.y+height)%height;
  else w.y = -(v.y-u.y+height)%height;
  return w;
}

class Particle {
  int type;
  PVector loc;
  PVector d;
  
  void update() {
    if(d.x > 0) d.x -= min(abs(d.x), fric);
    if(d.x < 0) d.x += min(abs(d.x), fric);
    if(d.y > 0) d.y -= min(abs(d.y), fric);
    if(d.y < 0) d.y += min(abs(d.y), fric);
    
    d.mult(1-drag);

    loc = newAdd(loc, d);
    
    /*if(loc.x < 0){ loc.x = 0; d.x = -d.x; }
    if(loc.x > width){ loc.x = width; d.x = -d.x; }
    if(loc.y < 0) { loc.y = 0; d.y = -d.y; }
    if(loc.y > height) { loc.y = height; d.y = -d.y; }*/
  }
  
  PVector applyForce(Particle other) {
    float dist = newSub(loc, other.loc).mag();
    float force = 0;
    //if(dist > hardRadius) force = forces[type][other.type]/(dist);
    if(dist < hardRadius && dist>0) force = -2/dist;
    
    else if(dist < hardRadius+radii[type][other.type]*2) force
      = -forces[type][other.type]*(abs((dist-hardRadius)/radii[type][other.type] - 1) - 1);
    
    d.add( PVector.mult( PVector.normalize(newSub(other.loc, loc)), force ) );
    
    return newSub(other.loc, loc);
  }
}

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  size(800, 600);
  noStroke();
  
  colors = new color[types];
  for(int i=0; i<types; i++) {
    colors[i] = color(random(0,255),random(0,255),random(0,255));
  }
  
  forces = new float[types][types];
  for(int i=0; i<types; i++) {
    for(int j=0; j<types; j++) {
      forces[i][j] = random(-forceRange,forceRange);
    }
  }
  
  radii = new float[types][types];
  for(int i=0; i<types; i++) {
    for(int j=0; j<types; j++) {
      radii[i][j] = random(hardRadius+1,hardRadius*2);
    }
  }
  
  for(int i=0; i<initParticles; i++) {
    particles.add(new Particle());
    particles.get(i).type = int(random(0,types));
    particles.get(i).loc = new PVector(random(width*.25,width*.75), random(height*.25,height*.75));
    particles.get(i).d = new PVector(random(-initVel,initVel), random(-initVel,initVel));
  }
}

void mouseClicked() {
  particles.clear();
  
  for(int i=0; i<initParticles; i++) {
    particles.add(new Particle());
    particles.get(i).type = int(random(0,types));
    particles.get(i).loc = new PVector(random(width*.25,width*.75), random(height*.25,height*.75));
    particles.get(i).d = new PVector(random(-initVel,initVel), random(-initVel,initVel));
  }
}

void draw() {
  background(0);
  
  for(int i=0; i<particles.size(); i++) {
    fill(colors[particles.get(i).type]);
    
    particles.get(i).update();
    
    ellipse(particles.get(i).loc.x, particles.get(i).loc.y, hardRadius, hardRadius);
    for(int j=0; j<particles.size(); j++) {
      if(i != j) {
        PVector f = particles.get(i).applyForce(particles.get(j));
      }
    }
  }
}