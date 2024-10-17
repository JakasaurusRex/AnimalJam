import processing.opengl.*;

PShape capy;
PShape inverseCapy;

float ry;

public void setup() {
  size(1000, 1000, P3D);

  capy = loadShape("capy.obj");
  inverseCapy = loadShape("outline.obj");
}

public void draw() {
  background(124, 242, 252);
  //lights();

  translate (width/2, height/2 + 100);
  scale(100);
  rotateZ(PI);
  rotateY(ry);

  
  
 
  
  PGL pgl = beginPGL();
  pgl.enable(PGL.CULL_FACE);
  shape(inverseCapy);
   endPGL(); 
  
  shape(capy);
  
  
  ry += 0.005;
}
