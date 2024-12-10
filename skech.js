let CENTER_X;
let CENTER_Y;
let h_size = 15;
let count = 15;
let hanabi = [];
let num = 0;

class Hanabi {
  constructor() {
    this.size = 0;
    this.cx = 0;
    this.cy = 0;
    this.col = 0;
    this.time = 0;
    this.wait = 0;
    this.hanabis = Array.from({ length: count }, () =>
      Array.from({ length: 4 }, () => new Ball())
    );
  }

  setup() {
    this.size = random(h_size / 2) + h_size / 2;
    this.cx = mouseX;
    this.cy = mouseY;
    let colsel = int(random(6));
    this.time = 0;
    this.wait = 30;

    switch (colsel) {
      case 0:
        this.col = 60;
        break;
      case 1:
        this.col = 120;
        break;
      case 2:
        this.col = 180;
        break;
      case 3:
        this.col = 240;
        break;
      case 4:
        this.col = 300;
        break;
      case 5:
        this.col = 360;
        break;
    }

    for (let i = 0; i < count; i++) {
      for (let j = 0; j < 4; j++) {
        this.hanabis[i][j].setup(this.hanabis, this.size, i, j, this.col);
      }
    }
  }

  draw() {
    if (this.wait > 0) {
      uchiage(this.cx, this.cy, this.wait);
      this.wait--;
    } else {
      for (let i = 0; i < count; i++) {
        for (let j = 0; j < 4; j++) {
          if (this.hanabis[i][j].time >= 0) {
            push();
            translate(this.cx, this.cy);
            rotate(radians(this.hanabis[i][j].r));

            noStroke();
            fill(this.hanabis[i][j].col, 99, 99, 30);
            ellipse(
              this.hanabis[i][j].x,
              this.hanabis[i][j].y,
              this.size * 2,
              h_size * 2
            );

            stroke(this.hanabis[i][j].col, 99, 99, 50);
            strokeWeight(0.5);
            fill(this.hanabis[i][j].col, 99, 99, 90);
            ellipse(
              this.hanabis[i][j].x,
              this.hanabis[i][j].y,
              this.size,
              h_size
            );

            this.hanabis[i][j].time--;
            this.hanabis[i][j].y += 0.5;
            this.hanabis[i][j].r += 30;

            pop();
          }
        }
      }
    }
  }
}

class Ball {
  constructor() {
    this.size = 0;
    this.x = 0;
    this.y = 0;
    this.col = 0;
    this.r = 0;
    this.time = 0;
  }

  setup(hanabis, hanabi_size, i, j, colsel) {
    if (i === 0) hanabis[i][j].size = hanabi_size;

    // Position set
    switch (j) {
      case 0:
        hanabis[i][j].x = hanabi_size * i;
        hanabis[i][j].y = hanabi_size * i * (i % 2);
        break;
      case 1:
        hanabis[i][j].x = hanabi_size * i * (i % 2);
        hanabis[i][j].y = -1 * hanabi_size * i;
        break;
      case 2:
        hanabis[i][j].x = -1 * hanabi_size * i;
        hanabis[i][j].y = -1 * hanabi_size * i * (i % 2);
        break;
      case 3:
        hanabis[i][j].x = -1 * hanabi_size * i * (i % 2);
        hanabis[i][j].y = hanabi_size * i;
        break;
    }

    hanabis[i][j].r = 0;
    hanabis[i][j].size = hanabi_size * i / 3;
    hanabis[i][j].time = i * 2 + 5;
    hanabis[i][j].col = random(colsel - 30, colsel + 30);
  }
}

function setup() {
  colorMode(HSB, 360, 100, 100, 100);
  createCanvas(windowWidth, windowHeight);

  CENTER_X = width / 2;
  CENTER_Y = height / 2;
  frameRate(16);

  for (let i = 0; i < 10; i++) {
    hanabi.push(new Hanabi());
  }
}

function draw() {
  fade();
  for (let h of hanabi) h.draw();
}

function fade() {
  let c1 = color(240, 100, 10);
  let c2 = color(240, 0, 0);
  noStroke();
  for (let h = 0; h < height; h += 5) {
    let c = lerpColor(c1, c2, h / height);
    fill(c);
    rect(0, h, width, 5);
  }
}

function uchiage(mouse_x, mouse_y, wait) {
  fill(random(360), 100, 100, 80);
  ellipse(
    mouse_x + 20 * cos(radians(90 + wait * 12)),
    height - h_size * 2 - mouse_y / wait,
    h_size / 2,
    h_size / 2
  );
}

function mousePressed() {
  hanabi[num].setup();
  num = (num + 1) % hanabi.length;
}
