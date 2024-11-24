import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim = new Minim(this);
AudioSnippet bgm;

float CENTER_X;
float CENTER_Y;
int h_size = 15;
int count = 15;
Hanabi hanabi[] = new Hanabi[10];
int num = 0;
PImage bg;

class Hanabi {
  float size;
  float cx, cy;
  int col;
  float time;
  int wait;
  Ball[][] hanabis;
  Ball[][] bls;
  AudioSnippet player;
  
  Hanabi() {
    size = 0;
    cx = 0; cy = 0;
    col = 0;
    time = 0;
    wait = 0;
    hanabis = new Ball[count][4];
    
    // hanabi sound effect load
    player = minim.loadSnippet("hanabi2.mp3");
    player.setGain(-10);
    for (int i = 0; i < count; i++) {
       for (int j = 0; j < 4; j++) {
         hanabis[i][j] = new Ball();
       }
    }
    //text("hanabi", 0, 10);
  }
  
  void setup() {
    size = random(h_size/2)+(h_size/2);
    cx = mouseX; 
    cy = mouseY;
    int colsel = int(random(6));
    time = 0;
    wait = 30;
    
    switch (colsel) {
    case 0 : 
      col = 60; 
      break;
    case 1 : 
      col = 120; 
      break;
    case 2 : 
      col = 180; 
      break;
    case 3 : 
      col = 240; 
      break;
    case 4 : 
      col = 300; 
      break;
    case 5 : 
      col = 360; 
      break;
      
    }
    
    for (int i = 0; i < count; i++) {
       for (int j = 0; j < 4; j++) {
         hanabis[i][j].setup(hanabis, size, i, j, col);
       }
    }
  } 

  void draw() {
    if (wait > 0) {
      uchiage(cx, cy, wait);
      wait--;
    } else {

      
      for (int i = 0; i < count; i++) {
        for (int j = 0; j < 4; j++) {
          if (hanabis[i][j].time >= 0) {
            
            pushMatrix();
            
            translate(cx, cy);
            rotate(radians(hanabis[i][j].r));
  
            noStroke();
            fill(hanabis[i][j].col, 99, 99, 30);
            ellipse(hanabis[i][j].x, hanabis[i][j].y, size*2, h_size*2);
            
            stroke(hanabis[i][j].col, 99, 99, 50);
            strokeWeight(0.5);
            fill(hanabis[i][j].col, 99, 99, 90);
            ellipse(hanabis[i][j].x, hanabis[i][j].y, size, h_size);
            
            hanabis[i][j].time--;
            hanabis[i][j].y += 0.5;
            hanabis[i][j].r += 30;
            
            popMatrix();
          }
        }
      }
    }
  }
}

class Ball {
  float size;
  float x, y;
  float col;
  float r;
  float time;

  //initialize
  Ball() {
    size = 0;
    x = 0; 
    y = 0;
    col = 0;
    r = 0;
    time = 0;
    //text("new ball", 0, 20);
  }


  void setup(Ball[][] hanabis, float hanabi_size, int i, int j, int colsel) {

    if (i == 0) hanabis[i][j].size = hanabi_size;
    
    //position set
    switch (j) {
    case 0 : 
      hanabis[i][j].x = hanabi_size*i;
      hanabis[i][j].y = hanabi_size*i*(i%2);
      break; 
    case 1 : 
      hanabis[i][j].x = hanabi_size*i*(i%2);
      hanabis[i][j].y = -1 * hanabi_size*i;
      break;
    case 2 :
      hanabis[i][j].x = -1 * hanabi_size*i;
      hanabis[i][j].y = -1 * hanabi_size*i*(i%2);
      break;
    case 3 : 
      hanabis[i][j].x = -1 * hanabi_size*i*(i%2);
      hanabis[i][j].y = hanabi_size*i;
      break;
    }

    
    hanabis[i][j].r = 0;
    
    hanabis[i][j].size = hanabi_size*i/3;

    hanabis[i][j].time = i * 2 + 5;
    hanabis[i][j].col = random(colsel-30, colsel+30);
    //text("balls setup", 0, 30);

  }
}


//all initialize
void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  size(displayWidth, displayHeight);
  
  //gradertion
  color c1 = color(240, 100, 10);
  color c2 = color(240, 0, 0);
  noStroke();
  rectMode(CORNER);
  for (float h = 0; h < displayHeight; h += 5) {
    color c = lerpColor(c1, c2, h / displayHeight);
    fill(c);

    rect(0, h, displayWidth, 5);
  }
  CENTER_X = displayWidth/2;
  CENTER_Y = displayHeight/2;
  frameRate(16);
  //bgm set
  bgm = minim.loadSnippet("bgm.mp3");
  bgm.setGain(-10);
  bgm.loop();
  
  //background set
  bg = loadImage("bg.png");
  //image(bg, 0, 0, displayWidth, displayHeight);
  for (int i = 0; i < hanabi.length; i++) hanabi[i] = new Hanabi();
}

void uchiage(float mouse_x, float mouse_y, int wait) {
  fill(random(360), 100, 100, 80);
  ellipse(mouse_x+(20*(cos(radians(90+wait*12)))), displayHeight-h_size*2-(mouseY/wait), h_size/2, h_size/2);
}

void mousePressed() {
  hanabi[num].setup();
  hanabi[num].player.rewind();
  hanabi[num].player.play();
  if (num < hanabi.length-1) num++;
  else num = 0;
}


void fade() {
  color c1 = color(240, 100, 10);
  color c2 = color(240, 0, 0);
  noStroke();
  rectMode(CORNER);
  for (float h = 0; h < displayHeight; h += 5) {
    color c = lerpColor(c1, c2, h / displayHeight);
    fill(c);
    rect(0, h, displayWidth, 5);
  }
  tint(0, 90);
  //image(bg, 0, 0, displayWidth, displayHeight);
}

void draw() {
  fade();
  for (int i = 0; i < hanabi.length; i++) hanabi[i].draw();
 
}

void stop() {
  minim.stop();
}
