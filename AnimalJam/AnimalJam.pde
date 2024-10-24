import processing.opengl.*;
import java.util.*;
import processing.serial.*;

int width = 800;
int height = 800;

color colors[] = {#ffadad, #fbe0e0, #ffd6a5, #fff0d4, #fdffb6, #ffffea, #caffbf, 
              #9bf6ff, #d7f9f8, #a0c4ff, #d6e6ff, #bdb2ff, #e5d4ef, #ffc6ff, #EFC378, #CFA969, #916213};
int backgroundColorIndex = 8;

String hats[] = {"models/capy", "models/capy-croc", "models/capy-covid", "models/capy-halo", "models/capy-propellor"};
int hatIndex = 0;

PShape capy;
PShape inverseCapy;
PImage insideCapyText;
PImage outsideCapyText;
int capyColorIndex = 15;
int capyOutlineColorIndex = 16;

Animal animals[];

// y rotation speed
float rotation;
float rotationSpeed = 0.005;

//font variable
PFont f;

ModeBox modes[];
int currentMode;
int lastMode = -1;
int numModes = 5;
int rectHeight = 125;
int rectWidth = 125;
float fadeSpeed = 10;
float slideSpeed = 1;
float easingValue = 0.05;
int fadeTimeConstant = 4;
int modeX = width/2 - rectWidth/2;
int modeY = 100;
boolean transitioning = false;

boolean spinning = true;
int lastPotVal = Integer.MIN_VALUE;

Serial myPort;
String val;
int lastInput = Integer.MIN_VALUE;
int inputDiff = 250;

public void setup() {
  size(800, 800, P3D);

  printArray(Serial.list());   
  String portName = Serial.list()[10];   
  println(portName);  
  myPort = new Serial(this, portName, 9600);

  unloadAnimals("models");

  capy = loadShape("models/capy.obj");
  insideCapyText = loadImage("models/capy.png");
  capy.setTexture(insideCapyText);
  inverseCapy = loadShape("models/capy_outline.obj");
  outsideCapyText = loadImage("models/capy_outline.png");
  inverseCapy.setTexture(outsideCapyText);

  modes = new ModeBox[numModes];
  for (int i = 0; i < numModes; i++) {
    modes[i] = new ModeBox(modeX, modeY, "mode " + i);
  }
  currentMode = 0;

  f = createFont("Arial", 16, true);
}

public void draw() {
  if(myPort.available() > 0) {
    val = myPort.readStringUntil('\n');
  }

  val = trim(val);
  if(val != null) {
    int[] xyzb = int(split(val, ','));

    if(xyzb.length == 5) {
      int x = xyzb[0];
      int y = xyzb[1];
      int z = xyzb[2];
      int b = xyzb[3];
      int p = xyzb[4];

      println(Arrays.toString(xyzb));

      if(b == 0 && transitioning == false) {
        transitionMode();
      }

      if(z == 0) {
         modes[currentMode].fadeIn();
      }

      if(x == 0 && millis() >= lastInput + inputDiff) {
        leftInputted();
        lastInput = millis();
      } else if(x == 4095 && millis() >= lastInput + inputDiff) {
        rightInputted();
        lastInput = millis();
      }
      
      if(lastPotVal == Integer.MIN_VALUE) {
        lastPotVal = p;
      } else if(lastPotVal != p) {
        rotation += (p-lastPotVal)/500;
        lastPotVal = p;
      }

    }
  }

  background(colors[backgroundColorIndex]);
  //lights

  modes[currentMode].drawToScreen();

  translate (width/2, height/2 + 100);
  scale(100);
  rotateZ(PI);
  rotateY(rotation);

  PGL pgl = beginPGL();
  pgl.enable(PGL.CULL_FACE);
  shape(inverseCapy);
  endPGL();

  shape(capy);

  rotation += rotationSpeed;
}

void transitionMode() {
  transitioning = true;
  modes[currentMode].slideOut();
  if (currentMode == modes.length-1) currentMode = 0;
  else currentMode++;
  modes[currentMode].slideIn();
}

void updateHat() {
  capy = loadShape(hats[hatIndex] + ".obj");
  insideCapyText = loadImage("models/capy.png");
  capy.setTexture(insideCapyText);
  inverseCapy = loadShape(hats[hatIndex] + "_outline.obj");
  outsideCapyText = loadImage("models/capy_outline.png");
  inverseCapy.setTexture(outsideCapyText);
}

void leftInputted() {
  if (currentMode == 1) {
    if (backgroundColorIndex == 0) backgroundColorIndex = colors.length-1;
    else backgroundColorIndex--;
  } else if (currentMode == 2) {
    if (capyColorIndex == 0) capyColorIndex = colors.length-1;
    else capyColorIndex--;
    updateObjectColor(capy, colors[capyColorIndex], insideCapyText);
  } else if (currentMode == 3) {
    if (capyOutlineColorIndex == 0) capyOutlineColorIndex = colors.length-1;
    else capyOutlineColorIndex--;
    updateObjectColor(inverseCapy, colors[capyOutlineColorIndex], outsideCapyText);
  } else if(currentMode == 4) {
    if(hatIndex == 0) hatIndex = hats.length -1;
    else hatIndex--;
    updateHat();
  }
}

void rightInputted() {
  if (currentMode == 1) {
    if (backgroundColorIndex == colors.length-1) backgroundColorIndex = 0;
    else backgroundColorIndex++;
  } else if (currentMode == 2) {
    if (capyColorIndex == colors.length-1) capyColorIndex = 0;
    else capyColorIndex++;
    updateObjectColor(capy, colors[capyColorIndex], insideCapyText);
  } else if (currentMode == 3) {
    if (capyOutlineColorIndex == colors.length-1) capyOutlineColorIndex = 0;
    else capyOutlineColorIndex++;
    updateObjectColor(inverseCapy, colors[capyOutlineColorIndex], outsideCapyText);
  } else if (currentMode == 4) {
    if(hatIndex == hats.length-1) hatIndex = 0;
    else hatIndex++;
    updateHat();
  }
}

void keyPressed() {
  if (key == 'x') {
    modes[currentMode].fadeIn();
  } else if (key == 'y') {
    transitionMode();
  } else if (key == 'a') {
    leftInputted();
  } else if (key == 'd') {
    rightInputted();
  }
}

class ModeBox {
  float x;
  float y;
  String mode;

  int fadeTime;
  int firstDrawn;
  int fadeValue;

  boolean beginFadeOut;
  boolean beginFadeIn;

  boolean beginSlideIn;
  boolean beginSlideOut;

  ModeBox (float x, float y, String mode) {
    this.x = x;
    this.y = y;
    this.mode = mode;

    firstDrawn = 0;
    fadeTime = Integer.MAX_VALUE;
    fadeValue = 0;
    beginFadeOut = false;
    beginFadeIn = false;

    beginSlideOut = false;
    beginSlideIn = false;
  }

  void fadeIn() {
    beginFadeOut = false;
    beginFadeIn = true;
  }

  void slideOut() {
    beginSlideOut = true;
    beginFadeOut = true;
    beginFadeIn = false;
    beginSlideIn = false;
  }

  void slideIn() {
    beginFadeOut = false;
    beginSlideOut = false;

    x = modeX + rectWidth;
    fadeValue = 0;
    beginSlideIn = true;
    beginFadeIn = true;
  }

  void drawToScreen() {
    if (firstDrawn == 0) {
      firstDrawn = 1;
      beginFadeIn = true;
    }

    if (!beginFadeIn && millis()/1000 >= fadeTime) {
      beginFadeOut = true;
    }

    if (beginFadeOut) {
      fadeValue -= fadeSpeed + fadeValue * easingValue;
      if (fadeValue <= 0) {
        fadeValue = 0;
        beginFadeOut = false;
      }
    }

    if (beginFadeIn) {
      fadeValue += fadeSpeed + (255-fadeValue) * easingValue;
      if (fadeValue >= 255) {
        fadeValue = 255;
        beginFadeIn = false;
        fadeTime = millis()/1000 + fadeTimeConstant;

        transitioning = false;
      }
    }

    if (beginSlideOut) {
      x -=  slideSpeed + x * easingValue;
      if (fadeValue <= 0) {
        x = modeX;
        beginSlideOut = false;
      }
    } else if (beginSlideIn) {
      x -= slideSpeed + (x-modeX) * easingValue;
      if (x <= modeX) {
        x = modeX;
        beginSlideIn = false;
      }
    }

    // draw rect
    fill(255, 255, 255, fadeValue);
    noStroke();
    rect(x, y, rectWidth, rectHeight, 28);

    // draw mode text
    textFont(f, 16);
    fill(0, 0, 0, fadeValue);
    text(mode, x + rectWidth/4, y+rectHeight/2);
  }
}

void updateObjectColor(PShape obj, color c, PImage texture) {
  texture.loadPixels();
  for (int x = 0; x < texture.width; x++) {
    for (int y = 0; y < texture.width; y++) {
      int i =  x+ y*texture.width;
      texture.pixels[i] = c;
    }
  }
  texture.updatePixels();
  obj.setTexture(texture);
}

void unloadAnimals(String modelsPath) {
  File dir = new File(dataPath(modelsPath));


  File[] files = dir.listFiles();

  ArrayList<String> animals = new ArrayList<>();
  for ( int i=0; i < files.length; i++ ) {
    String path = files[i].getAbsolutePath();
    if (path.contains(".mtl") || path.contains(".png") || path.contains("-") || path.contains("_")) {
      continue;
    } else {
      animals.add(path.substring(path.lastIndexOf('/') + 1, path.length()-4));
    }
  }

  HashMap<String, Animal> map = new HashMap<>();

  for (String currentAnimal : animals) {
    Animal animal = new Animal();

    for (int i = 0; i < files.length; i++) {
      String path = files[i].getAbsolutePath();
      if (!path.contains(currentAnimal) || path.contains(".mtl"))
        continue;
      if (path.contains(animal + ".obj"))
        animal.setModel("models/" + path.substring(path.lastIndexOf('/') + 1, path.length()));
      else if (path.contains(animal + "_outline.obj"))
        animal.setOutline("models/" + path.substring(path.lastIndexOf('/') + 1, path.length()));
      else if (path.contains(animal + ".png"))
        animal.setTexture("models/" + path.substring(path.lastIndexOf('/') + 1, path.length()));
      else if (path.contains(animal + "_outline.png"))
        animal.setOutlineTexture("models/" + path.substring(path.lastIndexOf('/') + 1, path.length()));
      else if (path.contains(animal + "-")) {
          /*if(path.contains("_"))
            animal.addToHatOutlines();
          else if(path.contains("png"))
            animal.addToHatTextures();
          else
            animal.addToHatModels();*/
        }
     }
  }
    
}

class Animal {
    String model;
    String outline;
    
    ArrayList<String> hatModels;
    ArrayList<String> hatOutlines;
    HashMap<Integer, PImage> hatTextures;
    HashMap<String, Integer> hatIndecies;
    
    PImage modelTexture;
    PImage modelOutlineTexture;
    
    int modelColorIndex;
    int outlineColorIndex;
    
    Animal () {
      hatModels = new ArrayList<>();
      hatOutlines = new ArrayList<>();
      hatTextures = new HashMap<>();
    }
    
    void setModel(String model) {
        this.model = model;
    }
    
    void setOutline(String outline) {
       this.outline = outline;
    }
    
    void setTexture(String texture) {
       modelTexture = loadImage(texture);
    }
    
    void setOutlineTexture(String texture) {
       modelOutlineTexture = loadImage(texture);
    }
    
    void addToHatModels(String hatName, String model) {
        int index = hatModels.size();
        hatModels.add(model);
        hatIndecies.put(hatName, index);
    }
    
    void addToHatOutlines(String hatName, String model) {
        
    }
    
    void addToHatTextures() {
      
    }
}
